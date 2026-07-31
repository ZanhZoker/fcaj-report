---
title: "Week 6"
weight: 6
chapter: false
pre: " <b> 1.6 </b> "
---

#### Week 6 — Alignment with the real export

**Dates:** 20-26 July 2026

**Status:** Completed

#### Objectives

- Align processing with the confirmed export contract.
- Update automated tests and technical documentation.

#### Activities

I restricted processing to `interactions.csv`, read the `id` field from
`Products.json` for validation, and explicitly ignored `items.csv`. The pipeline
keeps `USER_ID` and `ITEM_ID` as strings, rejects invalid products and exact
duplicates, and generates no surrogate IDs. I updated the test suite and
documentation for local and AWS execution.

#### Results

- Current report: 23,377 input and clean rows, 0 rejected, 0 duplicates.
- 200 unique users, 100 unique items, and ID-preservation status `PASS`.
- Generated user IDs: 0; generated item IDs: 0.

#### Challenges

The earlier assumptions around `items.csv` conflicted with the real application
export. Treating the contract as versioned technical documentation made the
change explicit and testable.

#### Next steps

Complete source review, verify the automated tests, and prepare AWS deployment
and report evidence.
