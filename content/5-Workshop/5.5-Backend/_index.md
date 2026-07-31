---
title: "Backend, API Gateway and Application Lambda"
weight: 5
chapter: false
pre: " <b> 5.5 </b> "
---

# Backend, API Gateway and Application Lambda

The proposal assigns the application API to API Gateway and an application
Lambda. This component is separate from the Python Data Engineering Lambda. The
available team repository does not contain the application Lambda or API
infrastructure, so the design below is retained as the team integration target.

#### Target responsibilities

- Receive authenticated application requests through API Gateway.
- Route catalogue, account, cart, voucher, review, order, and recommendation operations.
- Validate request payloads and enforce business rules server-side.
- Read and write application records in DynamoDB.
- Call the recommendation endpoint and map ranked item IDs to product details.
- Return consistent JSON responses and CORS headers to the frontend.

#### Authentication and business rules

The current frontend has only a browser mock token and mock password values; it
is not a production authentication implementation. The target backend must use
server-side authentication, secure password hashing, short-lived or revocable
sessions, and environment-based configuration. Order totals must be calculated
from trusted application data rather than browser-supplied prices.

#### API contract checklist

Before deployment, the responsible frontend and backend members should agree:

| Contract area | Required decision |
|---|---|
| Identity | Token format, expiry, role, and error responses |
| Product | Canonical ID, price, stock, image, category fields |
| Cart/checkout | Quantity, voucher, payment method, totals |
| Order | Status names, line items, timestamps, ownership |
| Recommendation | Input user ID, ordered item IDs, fallback behaviour |
| Errors | HTTP codes and stable response schema |

#### Verification activity

After application source and infrastructure are available, inspect configured
routes, invoke representative requests, confirm least-privilege database and
Personalize access, and capture sanitized success/error responses.

<!-- TODO: Team evidence - API Gateway routes -->
<!-- TODO: Team evidence - application Lambda -->
<!-- TODO: Team evidence - successful API response -->
