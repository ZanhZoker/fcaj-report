---
title: "Cost Optimization"
draft: true
weight: 12
chapter: false
pre: " <b> 5.12 </b> "
---

The project favours managed and serverless services so that a demonstration environment can scale down when idle. The points below are design guidance and estimates, not an actual AWS bill.

| Area | Cost approach | Evidence status |
|---|---|---|
| Frontend | Cache static assets at CloudFront and keep only build artifacts in S3 | CloudFront resource confirmed; cache policy review remains team-owned |
| API and processing | Use Lambda's request-based model and right-size memory after observing duration | Data pipeline configuration and application Lambda captured; runtime right-sizing not evaluated |
| Application data | Use DynamoDB on-demand capacity for an irregular demonstration workload | Proposed |
| Data lake | Apply S3 lifecycle rules if raw exports and reports accumulate | Recommended; lifecycle rule not confirmed |
| Logs | Keep a bounded retention period; the Data Engineering SAM template uses seven days | Confirmed for the processing Lambda |
| Recommendation | Create Amazon Personalize resources only for evaluation or a scheduled demo and remove idle campaigns | Active training resources confirmed; lifecycle remains team/ML-owned |

Cost should be reviewed by region and against the current AWS pricing pages before deployment. Budgets and cost-allocation tags are useful safeguards but are not claimed as implemented here.


The cleanup sequence in the next section is part of the cost plan: temporary resources should not remain active after the project demonstration.
