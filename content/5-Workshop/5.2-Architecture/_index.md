---
title: "Overall Architecture"
weight: 2
chapter: false
pre: " <b> 5.2 </b> "
---

# Overall Architecture

## Objective and position

This page establishes the boundaries between the customer application, the data
handoff, and the recommendation layer before any deployment steps are followed.

![Overall architecture of the team project](/images/5-Workshop/team-architecture-2026.jpg)

*Overall team architecture. The Data Engineering branch remains a distinct
component and is documented in its own unchanged Workshop page.*

## Architecture layers

1. **Delivery layer:** CloudFront serves the React/Vite build from a private S3 origin.
2. **Application layer:** API Gateway is the proposed HTTP entry point for the application Lambda.
3. **Persistence layer:** DynamoDB stores catalogue, identity, cart and order entities described by the team proposal.
4. **Data layer:** an export ZIP enters the independent Data Engineering pipeline and becomes a validated ML handoff.
5. **Recommendation layer:** Amazon Personalize resources are owned by the ML/team side and return ranked product IDs.
6. **Operations layer:** CloudWatch provides logs and metrics; IAM limits access between services.

## Integration contracts

| Boundary | Contract to verify |
|---|---|
| Browser → frontend | HTTPS page and route assets load through CloudFront |
| Frontend → API | Configured API base URL, valid JSON and CORS response |
| API → DynamoDB | Stable user/product/order IDs and least-privilege access |
| Application → Data Engineering | Export contains the required interaction and product files |
| Data Engineering → ML | Clean interactions retain application `USER_ID` and `ITEM_ID` values |
| Personalize → API → frontend | Ranked item IDs remain ordered and resolve to catalogue products |

## Important design decisions

- S3 origins should remain private and be reached through CloudFront Origin Access Control.
- A browser route such as `/product/123` requires SPA fallback behaviour when requested directly.
- Application and data-processing Lambdas have different ownership and permissions.
- The frontend source reviewed here currently uses a mock API and local storage; production API integration must be verified separately.
- Component captures are not treated as proof of a successful browser-to-recommendation path.

## Verification

- Confirm the diagram is readable and matches the services owned by each team member.
- Confirm no application bucket, ARN, endpoint or account identifier is hard-coded in this report.
- Confirm each component page links its output to the next layer.
- Use [End-to-End Testing](../5.8-Testing/) for runtime verification and [Clean Up](../5.9-Cleanup/) for dependency-aware removal.
