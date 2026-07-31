---
title: "Deploy the API Layer"
weight: 6
chapter: false
pre: " <b> 5.6 </b> "
---

# Deploy the API Layer

## Objective and architecture position

The API layer sits between the React frontend and DynamoDB or Amazon Personalize.
It should validate requests, enforce authentication and ownership, calculate
trusted order values, and return stable JSON responses. This is a team component;
the application-backend source is not present in the reviewed frontend repository.

## Evidence boundary

The team proposal describes an HTTP API Gateway with 22 routes and a Node.js 20
Lambda named **fcj-api**. A supplied console capture shows application order code
inside Lambda and the handler value **index.handler**, but the screenshot does not
prove every route, environment variable, timeout or memory setting.

![Application Lambda code supplied by the team](/images/5-Workshop/team/application-lambda.png)

*Supplied project capture cropped to the application order logic; account and storage
identifiers are excluded.*

## Step 1. Verify the IAM execution role

The Lambda execution role should include CloudWatch Logs permissions and only the
DynamoDB or Personalize actions required by implemented routes. Do not use a
broad administrator policy as a substitute for an access-pattern review. Secrets
belong in a managed secret store or protected environment configuration, not in
source or this report.

## Step 2. Verify the Lambda configuration

Use a read-only command against the team-approved profile:

```powershell
aws lambda get-function-configuration `
  --function-name fcj-api `
  --region ap-southeast-1 `
  --profile <AWS-PROFILE>
```

Confirm the runtime, handler, role, architecture, timeout, memory and environment
variable names against the owning source. The proposal's Node.js 20 statement is
design documentation; this report does not invent missing runtime values.

## Step 3. Configure environment variables

Expected categories include table names, allowed frontend origin, session or
token configuration, and a Personalize campaign reference when runtime
recommendations are enabled. Record variable names without publishing secret
values, tokens, account IDs or full private ARNs.

## Step 4. Connect API Gateway

The proposal describes an HTTP API. Verify the real API and integrations rather
than copying an endpoint from another environment:

```powershell
aws apigatewayv2 get-apis `
  --region ap-southeast-1 `
  --profile <AWS-PROFILE>

aws apigatewayv2 get-routes `
  --api-id <API-ID> `
  --region ap-southeast-1 `
  --profile <AWS-PROFILE>
```

For each route, check method, path, integration, authorization and error shape.
The 22-route count remains proposal-level until route output or backend source is
reviewed.

## Step 5. Configure CORS

Allow only the verified CloudFront origin for production. Include the methods and
headers required by the frontend, and test both a normal request and a preflight
request. Avoid wildcard credentials or an unrestricted origin when authentication
cookies or authorization headers are involved.

## Step 6. Connect DynamoDB

Product reads should resolve IDs from **Products**. Cart and order operations must
derive the user from the authenticated session and use the key schema documented
in the Database step. The API should re-read prices, validate voucher state and
persist an order atomically enough for the project workflow.

## Step 7. Connect recommendations and frontend

When the Personalize campaign is active, the API should pass the authenticated
user ID, receive ranked item IDs, resolve them to catalogue products without
changing order, and return a frontend-safe response. If the campaign is not
active, the API should return a controlled fallback rather than expose an AWS
error. The frontend must use a verified `<API-URL>` and not the local mock service.

## Step 8. Inspect CloudWatch Logs

Check request IDs, status codes, duration and structured error context. Logs must
not include passwords, session tokens or complete customer payloads.

## Common issues

- API Gateway route exists but points to the wrong Lambda alias or integration.
- CORS succeeds for GET but fails for authenticated or preflight requests.
- Lambda role can invoke but cannot read the required DynamoDB key.
- Client-supplied totals are trusted without server-side recalculation.
- Recommendation IDs are reordered while catalogue details are fetched.

## Verification

| Check | Expected result | Evidence state |
|---|---|---|
| Lambda configuration | Runtime, handler and role match owning source | Configuration must be inspected |
| Product endpoint | Returns valid catalogue JSON | Not documented end to end |
| Authentication | Valid session accepted; invalid session rejected | Not documented end to end |
| DynamoDB access | Product/cart/order keys resolve correctly | Table capture available; runtime call not documented |
| CloudWatch | Request and error logs appear without secrets | Alarm capture exists; API request log not documented |
| Frontend call | Browser request reaches the approved API | Must be verified in End-to-End Testing |

**Output for the next step:** a reviewed API contract and verified runtime path
that can consume database IDs and recommendation results.
