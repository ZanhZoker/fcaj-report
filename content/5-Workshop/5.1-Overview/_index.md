---
title: "Project Overview"
weight: 1
chapter: false
pre: " <b> 5.1 </b> "
---

# Project Overview

The team project addresses product discovery in an e-commerce experience that
also covers the normal shopping journey. The available frontend prototype
contains catalogue, category, text search, product detail, cart, checkout,
account, seller, notification, and administration routes. Recommendation and
visual search extend discovery beyond direct text queries.

#### Project goals

- Provide an accessible React/Vite commerce interface.
- Use a serverless AWS target architecture for delivery and business services.
- Prepare interaction data safely for recommendation training.
- Return recommendation results through the application to the frontend.
- Maintain clear ownership, monitoring, security, testing, cost, and cleanup.

#### Component and evidence summary

| Area | Role in the project | Current evidence |
|---|---|---|
| Frontend | Commerce screens and browser flows | React/Vite source; browser-local mock data |
| Cloud delivery | S3 origin and CloudFront HTTPS distribution | CloudFront and S3 captures supplied by the team |
| Backend | API Gateway and application Lambda | Application Lambda captured; API source is not in the reviewed repositories |
| Application database | DynamoDB application tables | Active DynamoDB tables and key layout captured |
| Data Engineering | Validate and hand off interactions | Source, tests, reports, SAM template |
| Machine Learning | Personalize training/evaluation/campaign | Dataset group and solution metrics supplied by the team |
| Visual search | CLIP embeddings and similarity | Proposal scope; no implementation result is claimed |

#### Personal role

I am responsible for the Data Engineering pipeline, not the whole platform. My
work begins with the application/database export and ends with the clean dataset
and quality-report handoff to the ML member/team.
