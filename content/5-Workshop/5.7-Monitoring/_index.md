---
title: "Monitoring and Alerting"
weight: 9
chapter: false
pre: " <b> 5.9 </b> "
---

# Monitoring and Alerting

## Objective and architecture position

Monitoring must answer which component failed, which request or data run was
affected, how long it took, and whether the failure is isolated or recurring.
The application Lambda and Data Engineering Lambda are separate functions and
must be investigated with their own log groups and ownership boundaries.

## Step 1. Locate application logs

Verify the application Lambda log group and inspect recent streams using the
team-approved profile:

```powershell
aws logs describe-log-groups `
  --log-group-name-prefix /aws/lambda/fcj-api `
  --region ap-southeast-1 `
  --profile <AWS-PROFILE>
```

Application logs should include request IDs, route/method, status, duration and
a safe error code. They must not contain passwords, authorization tokens,
session values or full customer payloads.

## Step 2. Locate Data Engineering logs

The processing Lambda records run-level counts and status described by the
[Data Engineering Pipeline](../5.7-DataEngineering/). Use those logs to correlate
the input object, output artifacts and quality report without changing the
pipeline page or its evidence.

## Step 3. Monitor Lambda metrics

For both functions, review at least:

| Metric | Why it matters | Investigation trigger |
|---|---|---|
| Invocations | Confirms traffic or event delivery | Expected request/upload produces no invocation |
| Errors | Detects failed handlers | Any sustained non-zero error count |
| Duration | Shows latency and timeout risk | Approaches configured timeout or increases sharply |
| Throttles | Detects concurrency limits | Any throttle during expected traffic |
| Concurrent executions | Explains bursts and contention | Unexpected saturation |

API Gateway 4xx/5xx, CloudFront error rate, DynamoDB throttling and Personalize
runtime errors should be correlated when those components are active.

## Step 4. Inspect structured failures

Start from the user-visible symptom, record its timestamp, then trace CloudFront,
API Gateway, application Lambda and downstream service logs. For a data run,
trace the S3 object event to the processing Lambda and its output report. Use IDs
and timestamps rather than copying sensitive payloads into the report.

## Step 5. Verify alarms

![CloudWatch alarms supplied by the team](/images/5-Workshop/team/cloudwatch-alarms.png)

*Supplied project capture: alarms for application Lambda latency and errors are present with
actions enabled. The capture does not identify the notification destination, so
the report does not claim an SNS topic.*

Check period, statistic, threshold, missing-data treatment and action target for
each alarm. A newly created alarm may show **Insufficient data** until enough
metric periods arrive.

## Step 6. Set log retention and control cost

Retention should be long enough for the internship demonstration and incident
review, but not unlimited without a reason. The Data Engineering source defines
a bounded retention for its function; application retention must be inspected
in the owning environment. Remove verbose debug logging before a public demo and
avoid logging large request or response bodies.

Cost controls integrated into this step include:

- bounded CloudWatch retention;
- CloudFront caching for static assets;
- DynamoDB on-demand capacity for irregular demo traffic;
- Lambda memory right-sizing only after duration evidence is collected;
- Personalize campaign lifecycle management, because an idle campaign can dominate project cost.

## Common issues

- Looking in the wrong Region or log group.
- Alarm threshold uses the wrong statistic or evaluation period.
- Errors are swallowed and only a generic 200 response is logged.
- Logs contain tokens, personal data or full records.
- A Personalize campaign remains active with no scheduled test.

## Verification

| Check | Expected result | Evidence state |
|---|---|---|
| Application log group | Recent requests have safe structured logs | Must be inspected |
| Processing log group | Run summary can be matched to artifacts | Documented by Data Engineering |
| Errors/duration/throttles | Dashboard or CLI view is available | Procedure documented |
| Alarms | Error and latency alarms exist | Supplied capture |
| Notification action | Confirmed destination and recipient | Not documented |
| Retention | Explicit value for each project log group | Data layer documented; application must be inspected |

**Output for the next step:** timestamps, request/run identifiers, logs and metric
evidence that can support the End-to-End checklist without exposing sensitive data.
