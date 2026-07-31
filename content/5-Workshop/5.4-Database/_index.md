---
title: "Create and Configure the Database"
weight: 5
chapter: false
pre: " <b> 5.5 </b> "
---

# Create and Configure the Database

## Objective and architecture position

DynamoDB is the application persistence layer between the API and the data or
recommendation workflows. It must keep product and user identifiers stable so
exports, recommendations, cart operations and orders refer to the same entities.

## Evidence and scope

The reviewed frontend source uses a generated in-browser database stored in
local storage; it does not create or query DynamoDB. The table list and key
layout below come from the supplied team console capture and agree with the team
proposal. They are team resources, not Trần Uy Danh's individual implementation.

![Active DynamoDB tables supplied by the team](/images/5-Workshop/team/dynamodb-tables.png)

*The capture shows eight active, on-demand tables and their key columns.*

## Step 1. Verify the table plan

| Table | Partition key | Sort key | Purpose |
|---|---|---|---|
| **Products** | **id** (String) | — | Catalogue records and stable item identifiers |
| **Categories** | **id** (String) | — | Product grouping |
| **Users** | **id** (String) | — | Application accounts |
| **Sessions** | **token** (String) | — | Session lookup and revocation state |
| **Carts** | **userId** (String) | — | One cart state per user |
| **Vouchers** | **code** (String) | — | Voucher validation |
| **Reviews** | **productId** (String) | **id** (String) | Reviews grouped by product |
| **Orders** | **userId** (String) | **id** (String) | Orders grouped by user |

The supplied capture shows on-demand capacity and no secondary indexes. That is
evidence of the displayed environment, not a replacement for infrastructure
source or an access-pattern review.

## Step 2. Create or confirm tables

For a new environment, the application owner should create the tables from the
approved infrastructure definition. No DynamoDB IaC exists in the reviewed team
repository, so this report does not invent CloudFormation resources. When
checking the supplied environment, use read-only commands:

```powershell
aws dynamodb list-tables `
  --region ap-southeast-1 `
  --profile <AWS-PROFILE>

aws dynamodb describe-table `
  --table-name Products `
  --region ap-southeast-1 `
  --profile <AWS-PROFILE>
```

Confirm status **ACTIVE**, billing mode **PAY_PER_REQUEST**, and the key schema
before the API is connected.

## Step 3. Seed and inspect catalogue data

The frontend prototype seed is not a DynamoDB import. Catalogue data must be
loaded through the team-approved backend or import process so product IDs match
the IDs used by interactions and Personalize.

```powershell
aws dynamodb scan `
  --table-name Products `
  --limit 5 `
  --region ap-southeast-1 `
  --profile <AWS-PROFILE>
```

Use a bounded read for verification. Do not export passwords, session tokens,
personal data, full customer records or sensitive order details into screenshots.

## Step 4. Connect the backend

The application Lambda role should receive only the actions required for its
routes and only on the approved tables. Reads should use a key or query where an
access pattern exists; broad scans should remain diagnostic and bounded. The
backend must calculate trusted totals and must not accept a client-supplied order
total without re-reading product prices.

## Step 5. Prepare the data boundary

The application/database owner exports interaction and product data for the
separate [Data Engineering Pipeline](../5.7-DataEngineering/). The handoff is
valid only when product IDs in the interaction data resolve to **Products** and
the pipeline can preserve the source identifiers.

## Common issues

- A table can be ACTIVE while containing no usable catalogue records.
- A key name mismatch causes validation errors even when the item shape looks correct.
- Prototype local-storage data does not prove DynamoDB integration.
- Screenshots must not expose user records, session tokens or account identifiers.
- Deletion protection is shown off in the supplied capture; cleanup therefore requires careful resource confirmation.

## Verification

| Check | Expected result |
|---|---|
| Table inventory | Eight documented tables are present and ACTIVE |
| Key schema | Matches the captured partition and sort keys |
| Products data | A bounded read returns valid catalogue IDs |
| Backend access | Product/cart/order operations use the intended tables |
| Security | No public access and no sensitive values in report evidence |

**Output for the next step:** verified table names, key contracts and catalogue
IDs that the API and downstream data flow can reference consistently.
