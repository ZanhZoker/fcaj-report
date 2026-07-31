---
title: "Week 7"
weight: 7
chapter: false
pre: " <b> 1.7 </b> "
---

#### Week 7 — Source completion and AWS verification

**Dates:** 27 July-02 August 2026

**Status:** In progress

#### Objectives

- Finalise the Data Engineering source, tests, README, and architecture.
- Prepare or verify AWS SAM deployment and start the Hugo report.

#### Activities

The repository now contains the Python pipeline, Lambda adapter, SAM template,
Athena verification SQL, bilingual workshop notes, and automated tests. Its
README records 48 passing tests and a checked deployment in **ap-southeast-1**
using S3, Lambda, CloudWatch Logs, and SAM/CloudFormation. I am organising the
bilingual Hugo report and the evidence checklist.

#### Results

- Data Engineering source and documentation are substantially complete.
- SAM template defines a private encrypted bucket, filtered S3 trigger,
  least-privilege Lambda access, and seven-day log retention.
- Report content and screenshot evidence are still in progress.

#### Challenges

The source documents contain an older note that describes AWS as deploy-ready,
while the newer README records a deployment. The workshop now pairs that text
with supplied SAM build, deployment, S3, and CloudWatch captures.

#### Next steps

Finish bilingual workshop pages and collect deployment evidence without exposing
credentials or unrelated account information.
