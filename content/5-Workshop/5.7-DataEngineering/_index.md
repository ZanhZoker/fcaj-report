---
title: "Data Engineering Pipeline"
weight: 7
chapter: false
pre: " <b> 5.7 </b> "
---

# Data Engineering Pipeline

This is the most detailed section because the pipeline is my individual
contribution. Its boundary is intentionally narrow: validate and clean a batch
interaction export, preserve source identifiers, publish auditable artifacts,
and hand the clean dataset to the Machine Learning member/team. It does not
train a model, operate the application database, or implement the frontend.

![Data Engineering pipeline architecture](/images/5-Workshop/data-engineering-pipeline.png)

#### 1. Data contract

The ZIP may contain nested folders. Required files are located by basename:

```text
export/
└── export/
    ├── interactions.csv   # processed
    ├── items.csv          # detected and ignored
    └── Products.json      # only the id field is used
```

`interactions.csv` must provide four logical columns:

```csv
USER_ID,ITEM_ID,EVENT_TYPE,TIMESTAMP
```

Header matching trims surrounding spaces and ignores case. Output always uses
the exact four uppercase columns in this order. `Products.json` must be a list,
or an object containing a `products` list, with one non-empty unique `id` per
product. The source files are never modified.

#### 2. Safe archive ingestion

`app/archive_reader.py` reads the ZIP in memory. Defaults limit compressed size
to 50 MiB, total uncompressed size to 150 MiB, and member count to 100. Absolute
paths, drive-qualified paths, and `..` traversal entries are rejected. Missing
or duplicate required basenames fail the complete job.

```python
interactions_member = _one_member_by_basename(members, "interactions.csv")
products_member = _one_member_by_basename(members, "Products.json")
```

The archive is not extracted to a filesystem directory, which removes the need
to trust member paths during extraction.

#### 3. Row validation and normalisation

The core in `app/pipeline.py` validates:

- missing `USER_ID`, `ITEM_ID`, or `TIMESTAMP`;
- an `ITEM_ID` absent from the `Products.json` lookup;
- an event outside **view**, **add_to_cart**, **remove_from_cart**, **purchase**;
- a timestamp that is not a positive ASCII Unix integer;
- an exact duplicate of a previously accepted normalised row.

```python
REQUIRED_COLUMNS = ("USER_ID", "ITEM_ID", "EVENT_TYPE", "TIMESTAMP")
VALID_EVENT_TYPES = {"view", "add_to_cart", "remove_from_cart", "purchase"}
```

Event type is trimmed and lowercased. IDs are only trimmed at the edges; case,
hyphens, leading zeros, and source structure remain. The first exact valid row
is kept, while later copies go to rejected output as `DUPLICATE_ROW`. Multiple
row problems are joined with `|` so no reason is hidden.

#### 4. Identifier preservation

The pipeline creates no map, hash, UUID, index, or surrogate user/item key. Its
quality report proves that output IDs are subsets of input IDs, clean items
exist in the product lookup, and generated ID counts are zero.

```python
generated_user_ids = output_user_ids - input_user_ids
generated_item_ids = output_item_ids - input_item_ids
id_check["status"] = "PASS" if all(id_check.values()) else "FAIL"
```

This constraint is essential for downstream integration: a recommendation item
ID must still resolve to the same product in the application.

#### 5. Output artifacts

| Prefix/file | Purpose |
|---|---|
| `processed/.../interactions_clean.csv` | Four-column ML-ready dataset |
| `rejected/.../interactions_rejected.csv` | Invalid/duplicate rows plus rejection reason |
| `reports/.../data_quality_report.json` | Machine-readable quality evidence |
| `reports/.../data_quality_report.md` | Human-readable equivalent report |

On AWS, each artifact is written under both `run_id=<RUN_ID>/` and `latest/`.
The stable run ID is derived from S3 object identity, so a redelivered event
overwrites the same run-scoped artifacts instead of creating unlimited copies.

![S3 prefixes for incoming, processed, rejected, and reports](/images/5-Workshop/data-engineering/s3-pipeline-prefixes.png)

![Clean interaction dataset in the stable latest prefix](/images/5-Workshop/data-engineering/processed-clean-output.png)

#### 6. Local execution

`app/cli.py` calls the same storage-independent core used by Lambda:

```powershell
python -m pytest -q
python -m app.cli --input .\export.zip --output .\output
```

```python
result = process_archive(args.input, source_archive=args.input.name)
write_local_outputs(result, args.output)
```

The CLI prints input, clean, rejected, duplicate, unique user/item, and ID audit
summaries. A failed contract returns a non-zero exit code and a clear message.

![Successful local pipeline run and automated tests](/images/5-Workshop/data-engineering/local-run-and-tests.png)

#### 7. AWS event-driven execution

`template.yaml` creates a private SSE-S3 bucket, Python 3.13 arm64 Lambda, S3
ObjectCreated trigger filtered to `incoming/*.zip`, least-privilege S3 policies,
a CloudWatch log group with seven-day retention, and stack outputs.

```yaml
Policies:
  - AWSLambdaBasicExecutionRole
  - Statement:
      - Sid: ReadIncomingArchives
        Action: [s3:GetObject, s3:GetObjectVersion]
      - Sid: WritePipelineArtifacts
        Action: [s3:PutObject]
```

`app/lambda_handler.py` URL-decodes the S3 key, skips unrelated objects, checks
object size, downloads the ZIP, calls the core, writes eight S3 objects (four
run-scoped and four `latest/`), and logs an aggregate summary.

```python
if not key.startswith(input_prefix):
    return {"status": "SKIPPED", "reason": "PREFIX"}
if not key.lower().endswith(".zip"):
    return {"status": "SKIPPED", "reason": "SUFFIX"}
```

The current repository README records deployment and verification in
**ap-southeast-1**. The captures below confirm a valid SAM template, a successful
build, and a successfully created/updated CloudFormation stack.

![SAM template validation and build](/images/5-Workshop/data-engineering/sam-validate-build.png)

![Successful SAM deployment](/images/5-Workshop/data-engineering/sam-deploy-success.png)

#### 8. Confirmed local data result

The checked `data_quality_report.json` records:

| Metric | Result |
|---|---:|
| Input / clean rows | 23,377 / 23,377 |
| Rejected / duplicate rows | 0 / 0 |
| Unique users / items | 200 / 100 |
| Product lookup IDs | 100 |
| **view** | 17,089 |
| **add_to_cart** | 4,382 |
| **purchase** | 1,220 |
| **remove_from_cart** | 686 |
| Generated user/item IDs | 0 / 0 |
| ID preservation | PASS |

These are Data Engineering quality metrics. Precision, NDCG, MRR, and Coverage
belong to ML model evaluation and are not pipeline scores.

![CloudWatch summary for the successful pipeline run](/images/5-Workshop/data-engineering/cloudwatch-run-summary.png)

#### 9. Automated tests

The repository records **48 tests passed**. Coverage includes archive safety and
limits, nested/missing/duplicate files, UTF-8 BOM, schema checks, invalid values,
product lookup, duplicates, exact output columns, ID preservation, deterministic
runs, S3 filters, URL decoding, multi-record events, and output locations.

```python
def test_output_ids_are_subsets_of_input_ids():
    result = process_archive(make_zip())
    assert result.report["id_preservation_check"]["status"] == "PASS"
```

#### 10. Optional Athena verification

The `athena/` folder contains SQL to create database **ecommerce_pipeline**, define
an external table over `processed/latest/`, and check counts, distributions,
distinct IDs, invalid values, daily activity, and sample original IDs.

```sql
SELECT event_type, COUNT(*) AS interaction_count
FROM ecommerce_pipeline.interactions_clean
GROUP BY event_type
ORDER BY interaction_count DESC;
```

Athena never changes the CSV. It is an optional verification layer; no executed
query result is claimed until direct evidence is added.

#### 11. Handoff to Machine Learning

The handoff package contains `interactions_clean.csv`,
`data_quality_report.json`, and `data_quality_report.md`. The ML member/team owns
Personalize import, schema compatibility at the service boundary, training,
evaluation, solution version, campaign deployment, and later application
integration.

#### Source files

- [`template.yaml`](https://github.com/ZanhZoker/ecommerce-interactions-pipeline/blob/main/template.yaml)
- [`app/lambda_handler.py`](https://github.com/ZanhZoker/ecommerce-interactions-pipeline/blob/main/app/lambda_handler.py)
- [`app/pipeline.py`](https://github.com/ZanhZoker/ecommerce-interactions-pipeline/blob/main/app/pipeline.py)
- [`app/cli.py`](https://github.com/ZanhZoker/ecommerce-interactions-pipeline/blob/main/app/cli.py)
- [`tests/`](https://github.com/ZanhZoker/ecommerce-interactions-pipeline/tree/main/tests)
- [`athena/`](https://github.com/ZanhZoker/ecommerce-interactions-pipeline/tree/main/athena)
