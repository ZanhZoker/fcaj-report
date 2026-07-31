---
title: "End-to-End Testing"
weight: 10
chapter: false
pre: " <b> 5.10 </b> "
---


A component working in isolation does not prove that the system works as a
whole. End-to-end verification must follow the same identifiers and expected
result from the browser, frontend, API and DynamoDB through the Data Engineering
handoff and recommendation response. A screenshot of one AWS page is supporting
evidence for that component only.

## Objective and prerequisites

Use a verified AWS profile in **ap-southeast-1**, the approved CloudFront and API
URLs, two non-sensitive test users, a known product ID, a controlled interaction
export, and access to CloudWatch logs. Record timestamps so observations across
services can be correlated.

## Evidence and limitations

Reviewed source and supplied captures support the React/Vite prototype, DynamoDB
table design, Lambda order logic, Personalize training resources, CloudWatch
alarms and the complete Data Engineering handoff. The evidence set does not yet
contain one timestamped browser-to-recommendation run, so live application and
runtime checks remain in the final checklist.

## Step 1. Verify Infrastructure Layers

Run read-only inventory commands first:

```powershell
aws sts get-caller-identity --profile <AWS-PROFILE>
aws cloudfront list-distributions --profile <AWS-PROFILE>
aws apigatewayv2 get-apis --region ap-southeast-1 --profile <AWS-PROFILE>
aws lambda get-function-configuration --function-name fcj-api --region ap-southeast-1 --profile <AWS-PROFILE>
aws dynamodb list-tables --region ap-southeast-1 --profile <AWS-PROFILE>
aws personalize list-dataset-groups --region ap-southeast-1 --profile <AWS-PROFILE>
```

Verify each layer without assuming that its existence proves integration:

| Layer | Verification |
|---|---|
| CloudFront | Distribution enabled; HTTPS domain loads the current frontend build |
| Frontend S3 | Private origin contains `index.html` and current hashed assets |
| API Gateway | Approved stage and routes integrate with the application Lambda |
| Application Lambda | Runtime configuration, role and log group match owning source |
| DynamoDB | Documented tables are ACTIVE and key schemas match the team capture |
| Data S3 and processing Lambda | Input/output boundary is available as documented by Data Engineering |
| CloudWatch | Application and processing log groups can be inspected |
| Amazon Personalize | Dataset group and intended solution version are ACTIVE |

Stop if the AWS account or Region is wrong. Do not substitute guessed resource
IDs, URLs or ARNs.

## Step 2. Verify the Data Engineering Handoff

The detailed implementation, commands and evidence remain in the unchanged
[Data Engineering Pipeline](../5.7-DataEngineering/). This end-to-end test uses
that component as a contract rather than rewriting it.

For one controlled export:

1. Upload the export ZIP to the verified incoming location.
2. Confirm the processing Lambda is invoked by the S3 event.
3. Match the CloudWatch run identifier to the uploaded object.
4. Confirm `interactions_clean.csv` and the quality report are created.
5. Compare input, clean, rejected and duplicate counts.
6. Confirm original `USER_ID` and `ITEM_ID` values are preserved.
7. Confirm every clean item ID exists in `Products.json` and the application catalogue.
8. Hand the approved clean file and report to the ML owner.

Do not mark the handoff complete from an S3 object alone; the counts, identifier
checks and report must belong to the same run.

## Step 3. Verify Recommendations

Use two valid users with different histories. Invoke the team-approved runtime
route or Personalize test surface and record only non-sensitive IDs.

```powershell
curl "<API-URL>/<RECOMMENDATION-ROUTE>?userId=<TEST-USER-ID>"
```

Check that:

- the response is successful and has the documented JSON shape;
- two users can receive different ranked results when sufficient history exists;
- every returned item ID exists in **Products**;
- duplicate or unknown IDs are handled explicitly;
- the backend preserves the order returned by Personalize;
- the frontend renders the same order.

Capture the runtime response, request timestamp and returned IDs so this test can
connect the verified training resources to the application path.

## Step 4. Verify the Browser Workflow

Use a new test session and record the browser Network panel alongside application
logs. The reviewed frontend source supports the following screens, but its mock
service must be replaced or disabled before claiming cloud API integration.

1. Open the verified CloudFront website over HTTPS.
2. Register a test account or log in with a non-sensitive test user.
3. Browse the catalogue and use category/search filters.
4. Open a product-detail route directly and from a product card.
5. Add the product to the cart and change quantity.
6. Apply a valid voucher if the deployed API implements vouchers.
7. Complete checkout or place a controlled order.
8. Open account/order history and find the new order.
9. Return to the home page.
10. Open the personalised recommendation section.
11. Open Developer Tools → Network.
12. Confirm requests use the approved API origin, status codes and response order.

![Catalogue used in the browser workflow](/images/5-Workshop/frontend/catalog.png)

*The catalogue screen is available in the team frontend; the Network panel must
still prove whether it is using the deployed API or the local mock service.*

![Product-detail route used in the browser workflow](/images/5-Workshop/frontend/product-detail.png)

*Use a known product ID to trace the browser route, API response, database item
and recommendation result.*

## Step 5. Verify Data Consistency

Choose one test user, product and order, then follow the same identifiers across
each boundary:

| Consistency check | Expected result |
|---|---|
| Product ID | Same value in DynamoDB, `Products.json`, interactions and Personalize output |
| User ID | Same application value in the interaction dataset and recommendation request |
| Recommendation rank | API and frontend preserve Personalize order |
| Price | Backend re-reads product price and calculates line/order totals |
| Voucher | Backend validates active state and expiry before discount |
| Order | Stored under the authenticated user and visible in order history |
| Data Engineering | Does not replace original application IDs |

If the frontend mock database is still active, stop the cloud consistency claim:
local-storage IDs are prototype data and do not prove DynamoDB or Personalize integration.

## Step 6. Failure Scenarios

| Scenario | Expected behaviour | Where to investigate |
|---|---|---|
| API unavailable | Frontend shows a controlled error or retry state | Browser Network, API Gateway and Lambda logs |
| CORS failure | Preflight is rejected clearly; production origin policy is corrected | Browser console and API CORS config |
| Stale CloudFront cache | Invalidation exposes the new build | Distribution invalidations and asset hashes |
| React route returns 403/404 | SPA fallback returns `index.html` | CloudFront custom errors and S3 origin |
| Malformed ZIP | Processing fails safely with a clear run error | Processing Lambda logs and report boundary |
| Missing `interactions.csv` | Run fails without publishing a misleading clean dataset | Data Engineering logs |
| Unknown `ITEM_ID` | Row is rejected and counted | Quality report |
| Lambda timeout | Invocation fails visibly; duration approaches timeout | CloudWatch duration/error metrics |
| Personalize campaign not ACTIVE | API returns a controlled fallback | Application logs and Personalize status |

## Final End-to-End Checklist

| Item | Expected result | Status or evidence |
|---|---|---|
| CloudFront loads | HTTPS page returns the current build | Distribution captured; pending timestamped load |
| Frontend assets | JavaScript, CSS and images load without errors | Interface captures and `dist/` source available |
| Product API | Valid product JSON for a known ID | Pending timestamped API call |
| Authentication | Valid login succeeds; invalid session is rejected | Prototype flow available; cloud test pending |
| Cart | Add, update and remove persist for the user | Prototype flow available; cloud test pending |
| Checkout | Server calculates and stores a controlled order | Lambda order logic captured; runtime test pending |
| Order history | New order appears for the same user | Pending controlled order test |
| Data Engineering trigger | Controlled upload invokes processing | Documented in the Data Engineering page |
| Clean dataset | Clean output and quality report belong to the same run | Documented in the Data Engineering page |
| ID preservation | Original user/item IDs remain unchanged | Documented in the Data Engineering page |
| Personalize recommendation | Runtime returns ranked IDs | Training evidence available; runtime response pending |
| Recommendation order | API and frontend preserve model order | Pending integrated response trace |
| CloudWatch logs | Requests/runs can be correlated without secrets | Component evidence available; full correlation pending |

## Result and team conclusion

The available evidence supports the React/Vite prototype, deployed component
captures, Data Engineering handoff, Personalize training resources and monitoring
alarms. One timestamped run should now complete the pending checklist rows before
the team presents the project as fully integrated. Trần Uy Danh's verified role
remains the Data Engineering boundary within that wider team system.
