---
title: "Self-evaluation"
weight: 6
chapter: false
pre: " <b> 6. </b> "
---

#### Summary

| Area | Current level | Evidence and limitation |
|---|---|---|
| AWS fundamentals | Basic to good | I can explain the role of the services in the project, but I still need more independent production experience. |
| Amazon S3 | Good in the practised scope | I designed input and output prefixes, private storage, encryption, and S3 event processing for the data pipeline. |
| AWS Lambda | Good in the practised scope | I packaged a Python handler for ZIP processing and understand event-driven execution; operational tuning needs more practice. |
| CloudWatch | Basic | I used execution logs and configured a seven-day log retention period; alarms and dashboards were outside my verified scope. |
| SAM/CloudFormation | Basic to good | I can describe and validate the pipeline resources in `template.yaml`; broader multi-stack design remains a learning goal. |
| Python and data processing | Good | I implemented archive reading, validation, reporting, command-line execution, and the Lambda entry point. |
| Data validation and quality | Good | I check required values, event types, timestamps, duplicates, and product identifiers, then report clean and rejected rows. |
| Automated testing | Good in project scope | The Data Engineering repository records 48 passing tests covering normal and failure cases. I need more experience with performance and integration testing. |
| Git and GitHub | Good for daily collaboration | I can work with branches, reviews, documentation, and repository hygiene; release automation needs further practice. |
| Teamwork and communication | Developing well | I clarified the data interface with other roles and learned to distinguish my deliverables from downstream ownership. |

#### What I practised

The most important technical result was turning an ambiguous export into a clear data contract. I learned that a pipeline is not complete when it only produces a CSV: it must define accepted files, schemas, validation rules, rejected-row handling, quality measurements, and a reproducible handoff. Preserving the application's original `USER_ID` and `ITEM_ID` values was essential because the recommendation result must map back to real users and products.

I also improved my problem-solving process. When the earlier dataset did not align with real catalogue identifiers, I traced the mismatch across the export and downstream requirements, confirmed `Products.json` as the product lookup, ignored the unused `items.csv`, and updated tests and documentation together with the code. This was more reliable than adapting one file without revisiting the contract.

#### Collaboration and communication

The project required coordination across frontend, backend, database, cloud, ML, and Data Engineering roles. I practised asking for exact input and output examples, recording assumptions, and communicating breaking changes. A key lesson is to agree on identifiers, timestamps, event names, and file ownership before implementation begins. I can now contribute more clearly in technical discussions, although I still need to make status and risks visible earlier.

#### Limitations

I do not consider myself an AWS or Data Engineering expert. My strongest evidence is within this pipeline's validation, testing, reporting, and SAM configuration. I have less hands-on evidence for production-scale observability, networking, infrastructure security reviews, Athena operations, and the team's backend or Personalize deployment. Those areas should not be inferred from my contribution.

#### Next learning goals

1. Complete an independently evidenced SAM deployment and operational runbook.
2. Practise Athena-based verification, partitioned data layouts, and lifecycle management.
3. Add end-to-end tests from application export through the ML handoff.
4. Improve monitoring, cost controls, IAM review, and secure secret management.
5. Study reliable batch processing patterns, orchestration, and data lineage on AWS.
