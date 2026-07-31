---
title: "Build the Recommendation Engine"
weight: 8
chapter: false
pre: " <b> 5.8 </b> "
---

# Build the Recommendation Engine

## Objective and ownership

Amazon Personalize converts validated user-item interactions into ranked product
recommendations. Trần Uy Danh owns dataset validation and the clean handoff. The
ML member/team owns schemas, imports, training, solution versions, campaigns and
model evaluation. Backend and frontend owners integrate the served result.

The source of truth for preprocessing remains the unchanged
[Data Engineering Pipeline](../5.7-DataEngineering/); this page starts at its
handoff boundary.

## Step 1. Receive the clean interactions

The ML owner receives `interactions_clean.csv` and the matching quality report.
Before import, confirm the required columns, source-ID preservation, row counts
and that every `ITEM_ID` resolves to the application's product catalogue.

## Step 2. Confirm the Personalize schema

The interaction schema must match the clean file types and event vocabulary.
Schema field names and data types are case-sensitive. Do not remap user or item
IDs unless the application and downstream lookup are updated consistently.

## Step 3. Upload the approved dataset

Place the approved file in a verified ML S3 location. Keep the Data Engineering
bucket boundary separate from the ML owner's import location when ownership or
permissions differ.

## Step 4. Grant import access

Amazon Personalize needs an IAM role and bucket policy that allow reading only
the approved dataset path. Do not publish the full role ARN, bucket name or
account identifier in this report.

## Step 5. Create or select the dataset group

![Active Personalize dataset group supplied by the team](/images/5-Workshop/team/personalize-dataset-group.png)

*Team/ML evidence: one custom dataset group is shown as Active.*

```powershell
aws personalize list-dataset-groups `
  --region ap-southeast-1 `
  --profile <AWS-PROFILE>
```

## Step 6. Create the interaction dataset and import job

Attach the reviewed schema to an Interactions dataset, start the import from the
approved S3 object, and wait for the job to become **ACTIVE**. A failed import
should be investigated from the job reason rather than retried with altered IDs.

## Step 7. Create the solution

The team proposal specifies the **aws-user-personalization** recipe. Confirm the
recipe and dataset group before training; do not infer a campaign from an Active
solution version.

## Step 8. Train a solution version

Wait for training to finish and record the version used for evaluation. The
supplied capture shows a full training run lasting 0.85 hours and an Active
solution version.

## Step 9. Evaluate model metrics

![Personalize solution-version metrics supplied by the team](/images/5-Workshop/team/personalize-solution-metrics.png)

*The supplied metrics show NDCG@5 0.5868, NDCG@10 0.6512, NDCG@25 0.7221,
precision@5 0.4348, precision@10 0.2826, precision@25 0.1496, MRR@25 0.7130
and coverage 0.9505. These are ML-team results, not Data Engineering metrics.*

## Step 10. Create a campaign only when required

A campaign is needed for the campaign-based runtime described in the proposal
and can remain a significant cost driver while active. No campaign capture is
provided here, so the report does not claim a live campaign. Create it only for
an approved test/demo window and record its status without publishing the ARN.

## Step 11. Verify runtime recommendations

Use two valid application users and compare the ordered item IDs. Personalised
results should vary when the model has sufficient history; all IDs must exist in
**Products**. A successful CLI or console response is required before marking
this layer complete.

## Step 12. Integrate the backend

The application Lambda should pass the authenticated user ID, call the approved
Personalize resource, preserve returned order, resolve product details and apply
a controlled fallback when Personalize is unavailable.

## Step 13. Render in the frontend

The frontend should render the response order exactly, avoid duplicate products,
handle unavailable catalogue items and distinguish personalised results from the
prototype's local related-product logic.

## Common issues

- Schema types differ from the uploaded CSV.
- S3 or IAM permission blocks the import job.
- Application IDs and dataset IDs use different formats.
- A solution version is Active but no campaign/runtime resource is available.
- The backend reorders IDs while fetching product details.
- A campaign remains active after the demonstration and continues generating cost.

## Verification and output

| Check | Expected result | Evidence state |
|---|---|---|
| Data handoff | Clean file and quality report agree | Documented by Data Engineering |
| Dataset group | Active custom group | Supplied capture |
| Solution version | Active and evaluated | Supplied capture |
| Model metrics | Recorded from the evaluated version | Supplied capture |
| Campaign/runtime | Returns ranked IDs for valid users | Not documented |
| Backend/frontend | Preserves rank and resolves products | Not documented end to end |

**Output for the next step:** an evaluated solution version and, when explicitly
created for testing, a runtime resource whose ranked IDs can be traced through
the API to the frontend.
