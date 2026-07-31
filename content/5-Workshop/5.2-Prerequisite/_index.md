---
title: "Prerequisites"
weight: 3
chapter: false
pre: " <b> 5.3 </b> "
---


## Objective

Prepare a reproducible local environment, verify the AWS identity before any
cloud operation, and separate source-confirmed commands from deployment values
that must be supplied by the responsible team member.

## Required tools and access

| Item | Purpose | Verification |
|---|---|---|
| Git | Review the report, frontend and Data Engineering repositories | `git --version` |
| Node.js and npm | Install and build the React/Vite frontend | `node --version` and `npm --version` |
| Python 3.11+ | Run the Data Engineering project locally | `python --version` |
| AWS CLI v2 | Inspect identity and project resources | `aws --version` |
| AWS SAM CLI | Inspect the Data Engineering stack lifecycle | `sam --version` |
| Hugo | Build the bilingual report | `hugo version` |

## Step 1. Review the source boundaries

- Team frontend: [E-commerceWebsiteDesign](https://github.com/dxsondangdung2019-arch/E-commerceWebsiteDesign)
- Data Engineering: [ecommerce-interactions-pipeline](https://github.com/ZanhZoker/ecommerce-interactions-pipeline)
- Report: [fcaj-report](https://github.com/ZanhZoker/fcaj-report)

The reviewed frontend repository contains React/Vite code, a mock API, local
storage persistence and an existing `dist/` build. It does not contain the
application Lambda or API Gateway infrastructure. Those layers must be verified
from their owning source or AWS environment rather than inferred from frontend code.

## Step 2. Install and build the frontend

```powershell
npm i
npm run build
```

Expected output: Vite completes successfully and writes static assets to `dist/`.

## Step 3. Verify AWS identity

```powershell
aws sts get-caller-identity --profile <AWS-PROFILE>
aws configure get region --profile <AWS-PROFILE>
```

Confirm the expected account and **ap-southeast-1** before using any command that
creates, changes or deletes resources. Do not paste access keys, session tokens,
passwords, MFA values, account IDs or private URLs into this report.

## Step 4. Prepare project inputs

The Data Engineering input is an export ZIP containing `interactions.csv`,
`Products.json`, and an optional `items.csv` that the pipeline deliberately
ignores. Application deployment values such as `<FRONTEND-BUCKET>`, `<API-URL>`
and `<DISTRIBUTION-ID>` must come from the verified team environment.

## Common issues

- A successful local frontend build does not prove the AWS deployment is current.
- The prototype mock API must not be described as the deployed application API.
- A wrong AWS profile or Region can make valid resources appear missing.
- Never replace angle-bracket values with guesses.

## Verification and output

- Tool versions are recorded locally.
- `npm run build` produces `dist/` without errors.
- AWS identity and Region are confirmed by the operator.
- Required input files are available without secrets.
- The next step receives only verified resource identifiers.
