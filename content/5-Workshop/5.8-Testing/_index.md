---
title: "Testing and Validation"
weight: 10
chapter: false
pre: " <b> 5.10 </b> "
---

# Testing and Validation

Testing is divided by ownership so verified Data Engineering results are not
mistaken for unverified whole-system results.

## Team-level testing

| Area | Required test | Current status |
|---|---|---|
| Frontend | Build, routing, catalogue, search, cart, checkout, account | Source available; recorded execution evidence pending |
| Backend/API | Auth, validation, product/cart/order routes, CORS, errors | Source and execution evidence pending |
| Database | Keys, access patterns, ownership, order consistency | Source and evidence pending |
| Recommendation | Import, model metrics, user variation, rank preservation | Team evidence pending |
| Visual search | Image input, embedding/cache, similarity result | Implementation evidence pending |
| Integration | Export → clean data → ML → API → frontend | End-to-end evidence pending |

Do not mark the row complete from a screenshot of only one component. A valid
integration result must identify the input, expected output, actual output, and
the same identifier across each boundary.

## Data Engineering testing

The repository reports **48 tests passed**. Verified behaviours include:

- safe handling of invalid ZIPs, path traversal, size and member limits;
- missing/ambiguous required files and duplicate product IDs;
- required columns, UTF-8 BOM, and header normalization;
- missing values, invalid event types and timestamps;
- unknown product IDs and exact duplicates;
- preservation of case, hyphens, leading zeros, and source IDs;
- deterministic local run IDs and clean output;
- S3 prefix/suffix filtering, URL-decoded keys, and multi-record Lambda events;
- run-scoped and `latest/` output publication.

```powershell
python -m pytest -q
python -m app.cli --input .\export.zip --output .\output
```

The current quality report reconciles 23,377 input rows to 23,377 clean rows,
with zero rejected and duplicate rows. A zero-rejection result for this input
does not remove the rejected-data path; tests exercise the failure cases.

## Output verification

1. Compare input, clean, rejected, and duplicate counts.
2. Confirm generated user/item ID counts are zero.
3. Confirm the clean header and sample source ID shapes.
4. Inspect rejection reasons with a controlled invalid test archive.
5. On AWS, match S3 artifacts and the CloudWatch run summary by run ID.
6. If Athena is used, reconcile its counts with the JSON report.

<!-- TODO: Team evidence - frontend and checkout tests -->
<!-- TODO: Team evidence - backend API tests -->
<!-- TODO: Team evidence - recommendation and integration tests -->
<!-- TODO: Personal evidence - automated test result and output verification -->
