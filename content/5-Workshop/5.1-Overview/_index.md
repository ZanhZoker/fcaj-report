---
title: "Project Overview"
weight: 1
chapter: false
pre: " <b> 5.1 </b> "
---

# Project Overview

## Objective

The team project is an e-commerce experience that combines catalogue browsing,
authentication, cart and order flows with a serverless AWS target architecture
and personalised recommendations. This Workshop explains how the components fit
together, what the reviewed source proves, and what must still be verified in a
live environment.

![Overall architecture of the team project](/images/5-Workshop/team-architecture-2026.jpg)

*The latest team diagram separates the customer-facing application path from
the Data Engineering handoff used by the recommendation workflow.*

## System journey

| Stage | Main responsibility | Output for the next stage |
|---|---|---|
| Frontend | Render commerce screens and collect user actions | HTTPS requests and interaction records |
| API layer | Validate requests and coordinate business operations | Product, account, cart and order responses |
| DynamoDB | Persist application entities and stable identifiers | Application data and exportable records |
| Data Engineering | Validate interactions and preserve source IDs | Clean interaction dataset and quality report |
| Recommendation | Train and serve ranked product IDs | Ordered recommendation list |
| Monitoring | Record failures, latency and operational signals | Logs, metrics and investigation context |

The browser path is **CloudFront → private S3 frontend → API Gateway →
application Lambda → DynamoDB or Amazon Personalize**. The data path starts from
an application/database export and continues through the separate
[Data Engineering Pipeline](../5.7-DataEngineering/) before the ML owner imports
the validated dataset.

## Evidence boundary

| Area | What is available |
|---|---|
| Frontend | React/Vite source, built `dist/` output and interface captures |
| Cloud delivery | Team captures of S3 and an enabled CloudFront distribution |
| Application backend | Proposal plus a supplied application Lambda capture; backend source is not in the reviewed repository |
| Database | Supplied DynamoDB table capture; detailed access code is not in the reviewed repository |
| Data Engineering | Source, tests, SAM infrastructure and deployment evidence |
| Recommendation | Dataset-group and solution-metric captures supplied by the ML/team side |

Component screenshots prove the resource shown, not an entire end-to-end
deployment. The final testing section therefore keeps each result labelled as
documented, source-confirmed, or a procedure to execute.

## Ownership

Trần Uy Danh owns the Data Engineering contribution: validating the export,
preserving application identifiers, producing quality evidence, and handing a
clean dataset to the ML member/team. Frontend, application backend, DynamoDB
design, Personalize training and cloud integration are team responsibilities.

## Workshop output

After completing the Workshop, the reader should be able to trace the system
from the browser to the recommendation result, identify the evidence available
for each layer, execute the verification checklist, and remove project resources
in dependency order without treating unverified claims as completed work.
