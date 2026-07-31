---
title: "Amazon Personalize and Recommendation"
weight: 8
chapter: false
pre: " <b> 5.8 </b> "
---

# Amazon Personalize and Recommendation

Amazon Personalize is the proposed downstream recommendation service. Data
Engineering supplies a clean four-column interaction CSV; the ML member/team is
responsible for service-side schema, dataset import, solution, solution version,
evaluation, campaign, and integration.

#### Handoff input

```csv
USER_ID,ITEM_ID,EVENT_TYPE,TIMESTAMP
user-133,prod-008,view,1779328979
user-133,prod-008,add_to_cart,1779329120
user-133,prod-008,purchase,1779329340
```

The pipeline guarantees schema and quality conditions but does not decide the
Personalize recipe or claim model performance. `items.csv` is not part of the
current Data Engineering contract; any item dataset required by the ML design
must be prepared and owned separately by that role.

#### ML workflow owned by the responsible member/team

1. Confirm that `USER_ID` and `ITEM_ID` match application identifiers.
2. Create the Personalize dataset group and schema.
3. Import `interactions_clean.csv` from the approved S3 location.
4. Create and train a solution version.
5. Review recommendation metrics and compare against an agreed baseline.
6. Create a campaign only when real-time testing or demonstration is required.
7. Expose ranked item IDs through the backend and preserve their order.
8. Delete chargeable resources when no longer required.

#### Metrics and responsibility

The supplied blog/proposal includes Precision@5, NDCG@10, MRR@25, and Coverage
for two datasets. These values are ML evaluation results supplied in the team
material. They are not Data Engineering metrics and are not attributed to Trần
Uy Danh. The quality pipeline is evaluated with row counts, rejection reasons,
duplicate counts, invalid product IDs, ID preservation, and automated tests.

#### Application integration checks

- Different eligible users should be tested for appropriate ranked responses.
- The backend must preserve the order returned by the recommendation service.
- Unknown or unavailable products need a defined fallback.
- Anonymous users need an explicit non-personalized fallback.
- The frontend must distinguish live recommendations from its current static
  product slice.

<!-- TODO: Team evidence - Personalize dataset import -->
<!-- TODO: Team evidence - solution and solution version -->
<!-- TODO: Team evidence - campaign and recommendation response -->
<!-- TODO: Team evidence - ML evaluation metrics -->
