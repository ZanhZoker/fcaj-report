---
title: "Week 5"
weight: 5
chapter: false
pre: " <b> 1.5 </b> "
---

#### Week 5 — Data contract and ML handoff

**Dates:** 13-19 July 2026

**Status:** Completed

#### Objectives

- Finalise the clean dataset structure for the ML member/team.
- Resolve identifier compatibility between earlier data and the application.

#### Activities

I reviewed the export files and clarified that the pipeline should process
`interactions.csv`, use only `Products.json` as the product-ID lookup, and not
use `items.csv`. Discussions with the ML side exposed that replacement IDs from
an earlier dataset would not safely join back to real users and products.

#### Results

- Handoff artifact defined as `interactions_clean.csv` with exactly four columns.
- `USER_ID` and `ITEM_ID` preservation became an explicit, tested data contract.
- Rejected rows and quality reports were included in the handoff package.

#### Challenges

The important issue was not file format but semantic compatibility. Keeping
source identifiers intact prevents a technically valid CSV from becoming
unusable in downstream integration.

#### Next steps

Adjust the pipeline to the confirmed export and update its tests and docs.
