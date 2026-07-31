---
title: "DynamoDB and Application Data"
weight: 6
chapter: false
pre: " <b> 5.6 </b> "
---

# DynamoDB and Application Data

The proposal defines DynamoDB as the application database. This database is not
the Data Engineering S3 storage layout: DynamoDB serves commerce transactions,
while the pipeline bucket stores incoming and generated batch artifacts.

#### Deployed application tables

| Table | Intended data |
|---|---|
| `Products` | Product catalogue and identifiers |
| `Categories` | Product grouping |
| `Users` | Account records; passwords must never be stored in plain text |
| `Sessions` | Authenticated sessions or revocation state |
| `Carts` | User cart state |
| `Vouchers` | Discount definitions and validity |
| `Reviews` | Product reviews |
| `Orders` | Order header and line data |

The supplied console capture confirms eight active on-demand DynamoDB tables
and shows their primary-key layout.

![Active DynamoDB tables and key layout](/images/5-Workshop/team/dynamodb-tables.png)

#### Integration with Data Engineering

The pipeline does not query or modify these tables. It receives a database
export ZIP, then uses the `id` values in `Products.json` as the trusted product
lookup. This boundary avoids coupling the batch job to application credentials
or live database availability.

#### Data separation checklist

- Do not upload user database exports to the public report repository.
- Keep application tables and pipeline S3 prefixes conceptually separate.
- Preserve application identifiers in the export and clean ML handoff.
- Document export ownership, format, cadence, and retention.
- Use masked or synthetic data in screenshots.

The report does not publish table items or customer records; the table-level
view documents the deployed data model without exposing application data.
