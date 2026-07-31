---
title: "Overall Architecture"
weight: 2
chapter: false
pre: " <b> 5.2 </b> "
---

# Overall Architecture

![Overall team architecture](/images/5-Workshop/architecture.png)

The diagram represents the team's target architecture. It must be read with the
evidence matrix below; an architecture symbol alone does not prove that a
resource has been deployed.

#### Application path

1. A user opens the HTTPS website through CloudFront.
2. CloudFront serves the React/Vite build from an S3 origin.
3. Browser requests go to API Gateway and an application Lambda.
4. Application data is read from or written to DynamoDB.
5. The backend can request ranked item IDs from a Personalize campaign and map
   them back to product data before returning the response.

#### Data and recommendation path

1. An application/database export ZIP is uploaded to `incoming/` in S3.
2. An S3 ObjectCreated event invokes the Python data-processing Lambda.
3. The function writes clean, rejected, and quality-report artifacts.
4. `interactions_clean.csv` is handed to the ML member/team.
5. The ML member/team owns Personalize import, solution training, evaluation,
   campaign deployment, and application integration.

#### Shared operational controls

- CloudWatch Logs records the Data Engineering Lambda execution summary.
- SAM/CloudFormation owns the Data Engineering S3 bucket, function, trigger,
  IAM policies, log group, and outputs.
- IAM roles should follow least privilege; no credentials belong in source.
- CloudFront OAC, application security, and application monitoring require team
  source or screenshots before being marked complete.

<!-- TODO: Team evidence - final overall architecture approved by all roles -->
