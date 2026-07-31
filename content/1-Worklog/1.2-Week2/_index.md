---
title: "Week 2"
weight: 2
chapter: false
pre: " <b> 1.2 </b> "
---

#### Week 2 — System and data analysis

**Dates:** 22-28 June 2026

**Status:** Completed

#### Objectives

- Clarify frontend, backend, ML, cloud, and data responsibilities.
- Understand users, products, and interaction data needed for recommendation.

#### Activities

I analysed the team proposal and frontend source, then mapped the intended
application flow against the data needed downstream. The key integration need
was a four-column interaction dataset whose user and item identifiers still
match the source system.

#### Results

- Identified `USER_ID`, `ITEM_ID`, `EVENT_TYPE`, and `TIMESTAMP` as the logical
  interaction fields.
- Documented that product identifiers require a trusted application lookup.

#### Challenges

The proposal described more cloud components than the available application
source confirmed. I kept design intent separate from implementation evidence.

#### Next steps

Design ingestion, validation, output zones, and a handoff contract for ML.
