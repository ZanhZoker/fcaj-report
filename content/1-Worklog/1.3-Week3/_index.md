---
title: "Week 3"
weight: 3
chapter: false
pre: " <b> 1.3 </b> "
---

#### Week 3 — Pipeline design

**Dates:** 29 June-05 July 2026

**Status:** Completed

#### Objectives

- Design the ingestion and validation workflow.
- Define clean, rejected, and report outputs for the ML handoff.

#### Activities

I designed a batch pipeline that reads an export ZIP in memory, locates required
files even under nested folders, validates each interaction, and separates
accepted rows from rejected rows. I also defined quality-report fields and safe
archive limits.

#### Results

- Proposed `incoming/`, `processed/`, `rejected/`, and `reports/` zones.
- Defined row validation, duplicate handling, and output schemas.
- Confirmed that the pipeline must not generate replacement IDs.

#### Challenges

The archive structure could vary between exports. Searching for a unique file
basename while rejecting ambiguous or unsafe paths addressed this variability.

#### Next steps

Implement the core pipeline, reporting module, CLI, and automated tests.
