---
title: "Clean Up"
weight: 11
chapter: false
pre: " <b> 5.11 </b> "
---

# Clean Up

**Destructive-operation warning:** Personalize resources may continue generating
cost, CloudFront must be disabled before deletion, S3 buckets must be emptied,
and dependency order matters. Confirm the AWS account, **ap-southeast-1**, profile
and exact resource before every command. The commands below are procedures only;
they were not executed while preparing this report.

## Before You Delete Anything

1. Confirm the profile, account and Region.
2. Export or screenshot the non-sensitive evidence required for the internship report.
3. Download approved quality reports and test summaries.
4. Record only the resource identifiers needed by the cleanup operator; do not publish them.
5. Confirm which resources are shared with another team project.
6. Stop active testing and obtain approval from each component owner.

```powershell
aws sts get-caller-identity --profile <AWS-PROFILE>
aws configure get region --profile <AWS-PROFILE>
aws resourcegroupstaggingapi get-resources `
  --region ap-southeast-1 `
  --profile <AWS-PROFILE>
```

Do not continue unless the account and Region match the project inventory.

## Step 1. Delete the Personalize Campaign

A campaign can be the largest ongoing cost and should be handled first when it
exists. This report has training-resource evidence but no campaign capture, so
the operator must verify that the ARN belongs to this project.

```powershell
aws personalize delete-campaign `
  --campaign-arn <VERIFIED-CAMPAIGN-ARN> `
  --region ap-southeast-1 `
  --profile <AWS-PROFILE>
```

Wait until the campaign no longer appears before deleting its solution.

## Step 2. Delete the Solution and Dataset Resources

Delete the verified solution after no campaign depends on it. Then remove the
Interactions dataset, dataset group and project-only schema in the dependency
order shown by the Personalize console. A dataset import job is historical state;
follow the current service dependency message rather than guessing an order.

```powershell
aws personalize delete-solution `
  --solution-arn <VERIFIED-SOLUTION-ARN> `
  --region ap-southeast-1 `
  --profile <AWS-PROFILE>

aws personalize delete-dataset `
  --dataset-arn <VERIFIED-DATASET-ARN> `
  --region ap-southeast-1 `
  --profile <AWS-PROFILE>

aws personalize delete-dataset-group `
  --dataset-group-arn <VERIFIED-DATASET-GROUP-ARN> `
  --region ap-southeast-1 `
  --profile <AWS-PROFILE>
```

Do not delete a schema or role that is shared by another dataset group.

## Step 3. Disable and Delete CloudFront

1. Open the verified distribution.
2. Save its configuration only if the team needs recovery evidence.
3. Disable the distribution and wait until status returns to **Deployed**.
4. Confirm the alternate domain is not serving another project.
5. Delete the distribution using the current ETag.

CloudFront cannot be deleted while enabled or while a configuration update is
still deploying. Remove its OAC only after no other distribution uses it.

## Step 4. Empty and Delete S3 Buckets

Inventory each bucket separately: frontend build, ML import, Data Engineering
data and Athena results when Athena was used. Versioned buckets also require
deleting object versions and delete markers.

```powershell
aws s3 ls s3://<VERIFIED-BUCKET>/ --recursive --profile <AWS-PROFILE>

# Destructive: run only after the exact bucket and retained evidence are confirmed.
aws s3 rm s3://<VERIFIED-BUCKET>/ --recursive --profile <AWS-PROFILE>

aws s3api delete-bucket `
  --bucket <VERIFIED-BUCKET> `
  --region ap-southeast-1 `
  --profile <AWS-PROFILE>
```

Never replace `<VERIFIED-BUCKET>` with a guessed name.

## Step 5. Delete API Gateway and Application Lambda

Confirm that the API ID and function belong to the application stack and are not
shared. If an owning CloudFormation stack exists, prefer deleting through that
stack so integrations and permissions are removed together.

```powershell
aws apigatewayv2 delete-api `
  --api-id <VERIFIED-API-ID> `
  --region ap-southeast-1 `
  --profile <AWS-PROFILE>

aws lambda delete-function `
  --function-name fcj-api `
  --region ap-southeast-1 `
  --profile <AWS-PROFILE>
```

Delete the API first so it cannot invoke a function that is being removed.

## Step 6. Delete DynamoDB Tables

Export any required non-sensitive records, confirm each table is project-owned,
and delete only the eight tables shown in the supplied team environment:
**Products, Categories, Users, Sessions, Carts, Vouchers, Reviews, Orders**.

```powershell
$projectTables = @('Products','Categories','Users','Sessions','Carts','Vouchers','Reviews','Orders')
foreach ($tableName in $projectTables) {
  aws dynamodb delete-table `
    --table-name $tableName `
    --region ap-southeast-1 `
    --profile <AWS-PROFILE>
}
```

This loop is destructive. Review the resolved account and list before running it.

## Step 7. Delete the Data Engineering Stack

This is cleanup guidance only; the Data Engineering Workshop and its assets are
not modified. The source uses AWS SAM/CloudFormation, so the verified stack should
be removed through SAM after retained artifacts are downloaded and blocking S3
objects are handled.

```powershell
sam delete `
  --stack-name <VERIFIED-DATA-PIPELINE-STACK> `
  --region ap-southeast-1 `
  --profile <AWS-PROFILE>
```

Confirm that the stack's processing Lambda, role, event notification and log
group are removed. Do not delete the application Lambda as part of this stack
unless the owning template actually contains it.

## Step 8. Delete IAM and CloudWatch Resources

Remove only roles and policies dedicated to deleted project resources, after all
services have stopped using them. The supplied project capture shows alarms named
**fcj-lambda-latency** and **fcj-lambda-errors**; confirm they still belong to the
application before deletion.

```powershell
aws cloudwatch delete-alarms `
  --alarm-names fcj-lambda-latency fcj-lambda-errors `
  --region ap-southeast-1 `
  --profile <AWS-PROFILE>

aws logs delete-log-group `
  --log-group-name <VERIFIED-LOG-GROUP> `
  --region ap-southeast-1 `
  --profile <AWS-PROFILE>
```

## Step 9. Final Cost Sweep

Check Billing and Cost Explorer after resource deletion, allowing for reporting
delay. Inventory S3, Lambda, DynamoDB, Personalize, CloudFront, CloudWatch,
CloudFormation and API Gateway in **ap-southeast-1** and any Region previously
used by the team. Review unattached IAM policies, log groups, S3 versions and
CloudFront/OAC resources that can survive the main deletions.

## Clean-up Checklist

| Resource | Required action | Verified |
|---|---|---|
| Personalize campaign | Delete first when present | ☐ |
| Personalize solution/datasets/group | Remove in dependency order | ☐ |
| CloudFront distribution | Disable, wait for Deployed, then delete | ☐ |
| Frontend/ML/data/Athena S3 | Retain evidence, empty versions, delete | ☐ |
| API Gateway | Delete verified application API | ☐ |
| Application Lambda | Delete function or owning stack | ☐ |
| DynamoDB tables | Export required data and delete project tables | ☐ |
| Data Engineering stack | Delete with SAM after bucket review | ☐ |
| IAM policies/roles | Remove only project-dedicated resources | ☐ |
| CloudWatch alarms/log groups | Delete after evidence retention | ☐ |
| Billing/Cost Explorer | Confirm no unexpected continuing charge | ☐ |

**Final output:** a recorded before/after inventory, retained non-sensitive
evidence and confirmation that no project-owned chargeable resource remains.
