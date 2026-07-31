---
title: "System Integration and Data Handoff"
draft: true
weight: 9
chapter: false
pre: " <b> 5.9 </b> "
---


The complete target flow crosses four responsibility boundaries:

```text
Application/database export
        ↓
Data Engineering validation and cleaning
        ↓
interactions_clean.csv + quality reports
        ↓
Machine Learning import/training/evaluation
        ↓
Amazon Personalize campaign
        ↓
Backend API product lookup and ordering
        ↓
Frontend recommendation section
```

#### Boundary contract

| Boundary | Input | Output | Owner |
|---|---|---|---|
| Application → Data | Export ZIP | `interactions.csv`, `Products.json`, ignored `items.csv` | Application/data coordination |
| Data pipeline | Export files | Clean, rejected, JSON/Markdown reports | Trần Uy Danh |
| Data → ML | Clean CSV + reports | Accepted import artifact | Data + ML sign-off |
| ML → Backend | User ID | Ordered recommended item IDs | ML + backend |
| Backend → Frontend | Recommended product objects | Rendered recommendation block | Backend + frontend |

#### Handoff acceptance criteria

- Output has exactly `USER_ID,ITEM_ID,EVENT_TYPE,TIMESTAMP`.
- Output IDs remain subsets of input IDs.
- Every clean item exists in `Products.json`.
- Rejected and duplicate counts reconcile with input and clean counts.
- The quality report and clean CSV come from the same run.
- The ML member/team records which run ID and object were imported.
- Backend lookup preserves recommendation order.

#### Current status

The Data Engineering side of the handoff is source-verified and has a confirmed
local report. The available frontend source is a mock-data prototype. The ML
import, application API, live product lookup, and browser response still require
team source or deployment evidence.
