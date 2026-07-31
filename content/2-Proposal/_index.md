---
title: "Proposal"
weight: 2
chapter: false
pre: " <b> 2. </b> "
---

# E-commerce Recommendation and Visual Search System on AWS

## 1. Executive Summary

The team project proposes an e-commerce platform with product browsing, account,
cart, checkout, recommendation, and visual-search capabilities. Its target AWS
architecture uses a React/Vite frontend, Amazon S3 and CloudFront for delivery,
API Gateway and application Lambda for business operations, DynamoDB for
application data, and Amazon Personalize for recommendations. The proposal also
describes CLIP-based visual search.

The implementation evidence is not uniform across all components. The available
team repository confirms a working React/Vite prototype backed by browser-local
mock data. The Data Engineering repository confirms a separate Python pipeline,
automated tests, quality reports, and AWS SAM infrastructure. Application
backend, DynamoDB, Personalize, CLIP, and full system deployment remain subject
to team source or screenshots before being reported as completed.

## 2. Problem Statement

An e-commerce catalogue must support normal shopping flows while helping users
discover relevant products. The recommendation stage depends on interaction
data that remains valid across system boundaries. If user or product identifiers
are replaced during preparation, the model output cannot be joined safely back
to the application catalogue.

The project therefore has two linked problems: deliver an end-to-end commerce
experience, and establish a reliable data handoff from application export to the
Machine Learning workflow.

## 3. Proposed Solution

The target solution combines four cooperating layers:

1. A React/Vite web application for catalogue, search, account, cart, checkout,
   seller, notification, and administration screens.
2. A proposed serverless application layer using API Gateway, Lambda, and
   DynamoDB.
3. A verified Data Engineering pipeline using S3, Lambda, CloudWatch Logs, and
   SAM/CloudFormation to create an ML-ready interaction dataset.
4. A proposed ML layer using Amazon Personalize and CLIP-based visual search,
   integrated back into the application through the backend API.

## 4. Benefits

- **Product discovery:** recommendation and visual-search concepts help users
  find products beyond basic keyword matching.
- **Clear ownership:** component contracts allow frontend, backend, data, cloud,
  and ML work to progress with explicit handoff points.
- **Serverless operations:** managed services reduce permanent server management
  and support pay-per-use operation for low or uneven traffic.
- **Auditable data quality:** clean, rejected, and report artifacts make each
  batch traceable before it reaches ML.
- **Source linkage:** preserving original IDs allows recommendation results to
  map back to application users and products.

## 5. Overall Architecture

![Target team architecture](/images/5-Workshop/architecture.png)

The image is the team's reference architecture, not deployment evidence. The
intended application path is:

```text
User → CloudFront → S3 frontend → API Gateway → application Lambda
     → DynamoDB / Amazon Personalize → recommendation response
```

The Data Engineering path is:

```text
Database export ZIP → S3 incoming/ → data-processing Lambda
→ processed/ + rejected/ + reports/ → interactions_clean.csv
→ Machine Learning / Amazon Personalize downstream
```

## 6. AWS Services and Technologies

| Component | Purpose | Evidence status |
|---|---|---|
| React, Vite, Redux Toolkit | Team web experience | Confirmed in frontend source |
| Browser mock API and local storage | Current prototype data layer | Confirmed in frontend source |
| S3 and CloudFront | Target static hosting and HTTPS delivery | Proposal; team evidence pending |
| API Gateway and application Lambda | Target serverless API and business logic | Proposal; application source pending |
| DynamoDB | Target application data store | Eight-table design in proposal; source pending |
| S3 and data-processing Lambda | Interaction pipeline input/output and compute | Confirmed in Data Engineering source |
| CloudWatch Logs | Pipeline execution logging | Confirmed in SAM template and repository status |
| SAM/CloudFormation | Pipeline infrastructure as code | Confirmed in `template.yaml` |
| Athena | Optional clean-CSV verification | SQL supplied; execution evidence pending |
| Amazon Personalize | Team recommendation training and serving | Proposal/blog evidence; deployment evidence pending |
| CLIP | Team visual-search concept | Proposal; available frontend does not implement it |

## 7. Component Design

### Frontend

The source uses React with Vite, React Router, Redux Toolkit, and reusable UI
components. Routes cover home, product details, category, text search, cart,
checkout, account, seller, notification, and admin views. The current homepage
uses static product slices for its recommendation block; this is not evidence of
a live Personalize integration.

### Backend and application data

The proposal assigns authentication, business rules, order processing,
recommendation calls, and database access to an application Lambda behind API
Gateway. It lists `Products`, `Categories`, `Users`, `Sessions`, `Carts`,
`Vouchers`, `Reviews`, and `Orders` as DynamoDB tables. These are kept as the
team design but require backend/database source or deployment evidence.

### Recommendation and visual search

The ML member/team owns dataset import, solution training, evaluation, campaign
deployment, and integration. Proposal and blog material describe Amazon
Personalize and CLIP with cosine similarity. These responsibilities are
distinct from the Data Engineering pipeline.

### Data Engineering

The pipeline reads `interactions.csv` and product IDs from `Products.json`
inside an export ZIP. It detects but ignores `items.csv`, validates schema and
rows, removes exact duplicates, preserves original IDs, and produces clean,
rejected, JSON-report, and Markdown-report artifacts.

## 8. Team Responsibilities

| Role | Responsibility |
|---|---|
| Frontend member/team | React/Vite user interface and browser flows |
| Backend member/team | Application API, authentication, and business logic |
| Machine Learning member/team | Personalize training/evaluation/campaign and CLIP work |
| Cloud/architecture member/team | Shared AWS architecture, deployment, IAM, and integration |
| Data Engineering — Trần Uy Danh | Interaction ingestion, validation, quality reporting, AWS batch pipeline, and ML data handoff |

## 9. Personal Contribution

My individual contribution is the Data Engineering component. I implemented:

- safe in-memory ZIP inspection with compressed/uncompressed/member limits;
- discovery of one `interactions.csv` and one `Products.json` by basename;
- explicit recognition and exclusion of `items.csv`;
- schema, missing-value, event-type, positive Unix timestamp, duplicate, and
  product-ID validation;
- preservation of `USER_ID` and `ITEM_ID` without maps or surrogate IDs;
- `interactions_clean.csv`, `interactions_rejected.csv`, and equivalent JSON and
  Markdown data-quality reports;
- local CLI execution and an S3-event Lambda adapter;
- private SSE-S3 storage, filtered trigger, least-privilege policies, and log
  retention through AWS SAM/CloudFormation;
- automated tests and optional Athena verification SQL;
- handoff of the clean dataset and reports to the ML member/team.

I do not claim the team's frontend, application backend, DynamoDB design,
Personalize model, or CLIP implementation as personal work.

## 10. Technical Implementation

The SAM template limits the Lambda to reading `incoming/*` and writing only the
three output prefixes:

```yaml
Events:
  IncomingZipCreated:
    Type: S3
    Properties:
      Events: s3:ObjectCreated:*
      Filter:
        S3Key:
          Rules:
            - { Name: prefix, Value: incoming/ }
            - { Name: suffix, Value: .zip }
```

The core accepts only four event types and preserves a fixed output schema:

```python
REQUIRED_COLUMNS = ("USER_ID", "ITEM_ID", "EVENT_TYPE", "TIMESTAMP")
VALID_EVENT_TYPES = {"view", "add_to_cart", "remove_from_cart", "purchase"}
```

The Lambda writes both immutable run-scoped locations and convenient `latest/`
copies. Full files are linked in [References](../8-References/) rather than
duplicated in this report.

## 11. Timeline and Milestones

| Period | Milestone | Status |
|---|---|---|
| 15-28 Jun | Onboarding, project analysis, role and data requirements | Completed |
| 29 Jun-12 Jul | Pipeline/data-contract design and initial implementation | Completed |
| 13-26 Jul | ML handoff clarification, real-export alignment, tests/docs | Completed |
| 27 Jul-02 Aug | Source completion, AWS verification, Hugo report | In progress |
| 03-09 Aug | Team/personal evidence and bilingual workshop | Planned |
| 10-14 Aug | Event, final review, cleanup, and submission | Planned |

## 12. Data Flow and Integration

1. The application/database export supplies a ZIP.
2. The Data Engineering pipeline reads `interactions.csv` and the product-ID
   lookup from `Products.json`; `items.csv` is ignored by contract.
3. Invalid rows go to rejected output; accepted rows retain original identifiers.
4. `interactions_clean.csv` and quality reports are the formal ML handoff.
5. The ML member/team owns dataset import, training, evaluation, and campaign.
6. The proposed backend maps recommendation item IDs to application products and
   returns the ranked response to the frontend.

This flow preserves the critical join key between source application data and
downstream recommendation output.

## 13. Testing and Evaluation

### Data Engineering evidence

The repository reports **48 automated tests passed**. The checked local export
produced:

| Metric | Result |
|---|---:|
| Input rows | 23,377 |
| Clean rows | 23,377 |
| Rejected rows | 0 |
| Exact duplicates | 0 |
| Unique users | 200 |
| Unique items | 100 |
| Generated user/item IDs | 0 / 0 |
| ID preservation | PASS |

The tests cover unsafe or malformed ZIPs, missing files and columns, invalid
events/timestamps, missing IDs, unknown products, duplicates, stable runs, S3
event filtering, multi-record Lambda events, and ID preservation.

### Team and ML evaluation

The supplied blog/proposal records Precision, NDCG, MRR, and Coverage for two
Personalize datasets. Those are recommendation-model metrics belonging to the
team's ML work; they are not metrics for my Data Engineering pipeline. Direct
Personalize screenshots/source are still required before treating them as
deployment evidence. Frontend, API, checkout, recommendation, and full
integration testing also remain team-level evidence items.

## 14. Budget Estimation

The following is an **estimate from the project proposal**, not an invoice or
observed bill. It assumes a low-traffic demonstration environment and may change
with Region, duration, and current AWS pricing.

| Service | Proposal assumption | Estimated cost (USD/month) |
|---|---|---:|
| Lambda | About 1M calls, 512 MB, 200 ms average | $0.20-$1.00 |
| API Gateway HTTP API | About 1M requests | About $1.00 |
| DynamoDB on-demand | Eight tables, about 1M read/write units | $5-$10 |
| S3 | About 5 GB plus requests | About $0.15 |
| CloudFront | About 50 GB transfer out | About $4.25 |
| Personalize campaign | One always-on campaign at minimum TPS | $150-$220 |
| Personalize training | About 2-4 hours per run | $0.50-$1.00/run |
| CloudWatch | Basic logs/monitoring | About $1.00 |
| **Proposal total** | Continuous campaign assumption | **About $160-$240/month** |

The Data Engineering pipeline is event-driven and does not create EC2, RDS, NAT
Gateway, OpenSearch, or SageMaker resources. Its SAM template retains logs for
seven days.

## 15. Risks and Mitigation

| Risk | Mitigation |
|---|---|
| Source and target architecture diverge | Maintain an evidence matrix and versioned contracts |
| User/product identifiers no longer match | Preserve source IDs and test subset/lookup conditions |
| Invalid or unsafe archive | Enforce size/member/path checks and fail the job |
| Poor interaction quality | Publish row/rejection/distribution reports before ML import |
| Personalize idle cost | Create campaigns only for required evaluation/demo windows and clean up |
| Secrets or user data exposed | Use roles/environment variables; review screenshots and repository scans |
| Frontend/backend contract mismatch | Agree request/response and data contracts before integration |
| In-memory pipeline limits | Keep explicit limits; adopt streaming/columnar processing only when needed |

## 16. Expected Outcomes

- A traceable team design for the complete e-commerce and recommendation flow.
- A usable React/Vite prototype while team cloud integration is validated.
- A tested Data Engineering pipeline and ML-ready interaction handoff.
- Clear ownership between application, data, cloud, and ML roles.
- Evidence-driven reporting that does not confuse target design with completed deployment.

## 17. Deliverables

| Deliverable | Status |
|---|---|
| Bilingual Hugo internship report | In progress |
| Team frontend source | Available |
| Data Engineering source, README, and architecture | Available |
| `template.yaml` and Lambda pipeline | Available |
| Automated tests and local quality report | Available |
| Athena SQL | Available; optional execution not yet evidenced |
| Clean dataset handoff contract | Available |
| Team backend/database/Personalize/CLIP source | Pending from responsible members |
| Team and personal deployment screenshots | Pending checklist completion |
| Event evidence and final submission evidence | Planned |
