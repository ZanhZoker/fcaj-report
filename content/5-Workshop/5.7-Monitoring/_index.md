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

The repository does not confirm CloudWatch alarms, SNS topics, or email notifications, so this report does not present them as deployed resources.

#### Team application security targets

The proposal calls for HTTPS through CloudFront, a private S3 origin with Origin Access Control, authenticated API access, restricted Lambda permissions, and protected application data. The current frontend source is a browser-based prototype that uses mock data and local storage; therefore it is not evidence of production authentication, password hashing, deployed OAC, or backend monitoring.

Before a production release, the team should verify request authorization, input validation, password hashing, secret storage, log redaction, CORS, least-privilege access, and retention settings across the application stack.

<!-- TODO: Team evidence - CloudFront HTTPS and private origin configuration -->
<!-- TODO: Team evidence - application IAM roles and security review -->
<!-- TODO: Team evidence - application logs or monitoring dashboard -->
<!-- TODO: Personal evidence - CloudWatch execution log with sensitive values redacted -->

#### Evidence checklist

Screenshots must hide credentials, session tokens, full account identifiers, personal data, and unrelated billing information. A console screenshot is evidence only when its resource name, region, and relationship to this project can be verified.
