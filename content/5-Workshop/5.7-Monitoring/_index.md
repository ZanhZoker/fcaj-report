---
title: "Monitoring, IAM and Security"
weight: 11
chapter: false
pre: " <b> 5.11 </b> "
---

This section separates controls confirmed in the Data Engineering source from controls that remain targets for the team application.

#### Data Engineering controls confirmed in source

- **CloudWatch Logs:** Lambda runtime logs provide an execution trail for each S3-triggered run. The SAM template creates the function log group with a seven-day retention period.
- **Least-privilege IAM:** the processing function may read only from `incoming/*` and write only to `processed/*`, `rejected/*`, and `reports/*` in its data bucket.
- **Private storage:** the S3 bucket blocks public access and uses server-side encryption with Amazon S3-managed keys.
- **Configuration:** bucket and output prefixes are supplied through environment variables. Credentials and secrets are not stored in the repository.
- **Failure visibility:** validation errors are written as rejected-row artifacts and summarized in JSON and Markdown quality reports. Unexpected exceptions are recorded in Lambda logs.

The Data Engineering repository does not define alarms or SNS notifications.
Separately, a team-supplied capture confirms application-level CloudWatch alarms
for Lambda errors and latency.

![Application CloudWatch alarms for errors and latency](/images/5-Workshop/team/cloudwatch-alarms.png)

#### Team application security targets

The proposal calls for HTTPS through CloudFront, a private S3 origin with Origin Access Control, authenticated API access, restricted Lambda permissions, and protected application data. The current frontend source is a browser-based prototype that uses mock data and local storage; therefore it is not evidence of production authentication, password hashing, deployed OAC, or backend monitoring.

Before a production release, the team should verify request authorization, input validation, password hashing, secret storage, log redaction, CORS, least-privilege access, and retention settings across the application stack.

![Data Engineering Lambda execution events](/images/5-Workshop/data-engineering/cloudwatch-log-events.png)

The capture records a successful Lambda invocation. The detailed run summary is
shown in the Data Engineering section with account-level identifiers removed.

#### Evidence checklist

Screenshots must hide credentials, session tokens, full account identifiers, personal data, and unrelated billing information. A console screenshot is evidence only when its resource name, region, and relationship to this project can be verified.
