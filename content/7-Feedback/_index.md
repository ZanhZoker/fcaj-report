---
title: "Sharing and Feedback"
weight: 7
chapter: false
pre: " <b> 7. </b> "
---

#### Knowledge and experience gained

The internship connected AWS concepts with a team project that had real boundaries between user experience, application logic, data storage, data preparation, and recommendation. I learned most from the interfaces between those areas. A technically correct component can still fail the project if its identifiers, file format, or delivery process do not match the next component.

My Data Engineering work improved my understanding of S3 event flows, Lambda packaging, SAM/CloudFormation, CloudWatch logs, data validation, quality reporting, and automated tests. It also reinforced a practical rule: preserve source identifiers unless the complete system has agreed on a mapping. Changing IDs locally may simplify a dataset while making recommendation results unusable by the application.

#### Value of the team project

The e-commerce project made role coordination concrete. Frontend needs stable API and product identifiers; backend and database owners define application records; Data Engineering converts exports into validated artifacts; ML consumes that contract and owns training and evaluation; cloud and testing roles help the components operate together. Seeing this end-to-end dependency was more valuable than treating each service as an isolated exercise.

The hardest periods were those in which the data requirements were implicit. Clarifying accepted filenames, schemas, event vocabulary, timestamp rules, catalogue lookups, and handoff ownership reduced rework. I would start future projects with a versioned data contract and small representative fixtures shared by all affected roles.

#### AWS deployment experience

Preparing the pipeline for AWS showed me the difference between local success and an operable workload: permissions, event configuration, log retention, resource naming, failure outputs, and cleanup all matter. The Data Engineering README records deployment verification, but report-ready evidence is still being assembled. I therefore treat deployment evidence as a separate deliverable rather than assuming that source configuration proves a live environment.

#### Programme feedback

The FCAJ structure is useful because it combines self-study, technical writing, source code, evidence, and a public bilingual report. Requiring a workshop encourages participants to explain not only what was built, but also how another person could verify and clean it up.

Suggested improvements:

1. Provide an early example of a cross-role data contract and evidence checklist.
2. Include a short cost and cleanup briefing before participants create managed resources.
3. Publish milestone-based review criteria for architecture, source, security, testing, and screenshots.
4. Give teams an early integration checkpoint so identifier and schema mismatches are discovered sooner.

#### Direction after the internship

I plan to continue learning AWS and Data Engineering through small, independently verified deployments. My priorities are stronger IAM and observability practices, data orchestration, Athena and analytical storage patterns, CI testing, and complete integration from application events to recommendation consumption.
