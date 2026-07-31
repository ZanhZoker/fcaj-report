---
title: "Prerequisites"
weight: 3
chapter: false
pre: " <b> 5.3 </b> "
---

# Prerequisites

| Item | Purpose |
|---|---|
| AWS account | Create and verify only the resources assigned to the workshop |
| IAM permissions | S3, Lambda, CloudFormation/SAM, CloudWatch, and optional Athena; team roles cover their own services |
| AWS CLI v2 | Identity checks, S3 upload/download, and stack inspection |
| AWS SAM CLI | Validate, build, deploy, and remove the Data Engineering stack |
| Node.js | Build and inspect the React/Vite frontend |
| Python 3.11+ | Run the local Data Engineering pipeline and tests |
| Git | Retrieve and review source repositories |
| Hugo | Build the bilingual internship report |
| Input data | Export ZIP containing `interactions.csv`, `Products.json`, and optionally ignored `items.csv` |

#### Source repositories

- [Team frontend](https://github.com/dxsondangdung2019-arch/E-commerceWebsiteDesign)
- [Data Engineering pipeline](https://github.com/ZanhZoker/ecommerce-interactions-pipeline)
- [Report source](https://github.com/ZanhZoker/fcaj-report)

#### Safe identity check

```powershell
aws sts get-caller-identity --profile ecommerce-pipeline
python --version
sam --version
node --version
hugo version
```

Never paste real access keys, secret keys, session tokens, passwords, or MFA
values into commands, screenshots, source files, or this report.

**Cloud safety:** Before creating resources, confirm the selected AWS account,
Region, profile, expected cost, and cleanup owner.
