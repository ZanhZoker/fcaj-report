---
title: "Resource Cleanup"
weight: 13
chapter: false
pre: " <b> 5.13 </b> "
---

**Deletion safety:** Deletion is irreversible. Before running any command,
confirm the AWS account, Region, stack name, bucket name, and retained evidence.
Use only values verified in the console; never run a destructive command against
a guessed resource.

#### Data Engineering stack

The SAM-managed resources should normally be removed through the stack so CloudFormation can respect dependencies:

```bash
sam delete --stack-name <verified-data-pipeline-stack> --region <verified-region>
```

Before stack deletion, inspect and retain only the required non-sensitive artifacts. If the bucket contains objects that block deletion, review the exact bucket and object list before emptying it. Confirm that the S3 bucket, processing Lambda, IAM role, event notification, and CloudWatch log group no longer exist after deletion. Remove Athena query-result objects separately if Athena was used.

#### Team application resources

The responsible team members should inventory and remove only resources actually created for the project:

1. Remove Amazon Personalize campaigns/recommenders and dependent solution versions or datasets after the ML owner confirms they are no longer needed.
2. Disable and delete the verified CloudFront distribution when it is no longer serving the demo.
3. Review and remove application S3 objects and buckets.
4. Remove the application API Gateway, Lambda functions, and their log groups through the owning stack when possible.
5. Export any required records, then remove the verified DynamoDB tables.
6. Review IAM roles and policies created specifically for the project.
7. Check the region's resource inventory and billing view for remaining chargeable resources.

This is a procedure, not a statement that cleanup has already occurred.
