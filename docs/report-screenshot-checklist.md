# Report Screenshot Checklist

This internal checklist tracks evidence that must be supplied or verified before final submission. Do not publish screenshots containing access keys, secret keys, session tokens, MFA codes, passwords, personal user data, a full AWS account ID, or unrelated billing information. Crop only after retaining enough context to verify the project, resource, region, and result.

## 1. Overall project evidence

- [ ] Current overall architecture diagram and editable draw.io source
- [ ] Team repository overview with the relevant revision visible
- [ ] End-to-end demonstration from product browsing to recommendation
- [ ] Inventory identifying which AWS resources are deployed and which remain design targets
- [ ] Final team integration result with date and responsible component owners

## 2. Frontend evidence

- [ ] Deployed CloudFront website with URL and HTTPS visible
- [ ] Homepage and product browsing
- [ ] Search and product-detail flow
- [ ] Cart or checkout flow using non-sensitive demonstration data
- [ ] Recommendation section connected to a verified data source
- [ ] CloudFront distribution and private S3 origin/OAC configuration, if deployed

## 3. Backend and database evidence

- [ ] API Gateway routes
- [ ] Application Lambda configuration
- [ ] Successful API response using non-sensitive sample data
- [ ] DynamoDB tables actually created for the application
- [ ] Authentication and authorization behaviour
- [ ] Backend/application logs or monitoring view
- [ ] Integration test covering API, Lambda, database, and recommendation response

## 4. Machine Learning evidence

- [ ] Dataset import derived from the handed-off `interactions_clean.csv`
- [ ] Amazon Personalize dataset group
- [ ] Solution and solution version, if used
- [ ] Campaign or recommender, if deployed
- [ ] Evaluation metrics with source, run, and owner identified
- [ ] Recommendation response mapped back to original user and product IDs
- [ ] CLIP visual-search demonstration and its verified execution environment

## 5. Data Engineering evidence

- [ ] Automated test run showing the command, revision, and 48 passing tests
- [ ] Local pipeline execution
- [ ] Input ZIP structure containing `interactions.csv` and `Products.json`
- [ ] SAM/CloudFormation deployment output
- [ ] S3 `incoming/` object
- [ ] S3 ObjectCreated trigger
- [ ] Data Processing Lambda configuration
- [ ] IAM execution role and scoped S3 permissions
- [ ] CloudWatch execution log with sensitive fields redacted
- [ ] `processed/interactions_clean.csv`
- [ ] `rejected/` artifact or verified empty-rejection case
- [ ] JSON and Markdown data-quality reports
- [ ] Comparison proving original `USER_ID` and `ITEM_ID` values are preserved
- [ ] Athena verification, only if Athena was actually run
- [ ] Resource inventory before cleanup
- [ ] Stack deletion or a documented decision to retain the environment

## 6. Blog evidence

- [ ] Screenshot of each published Facebook post with title and permalink visible
- [ ] Confirm publication dates before adding any dates to front matter
- [ ] Confirm all three public permalinks still open for the intended audience

## 7. Event evidence

- [ ] Confirm official event name
- [ ] Confirm event date, organiser, speaker, and participation details
- [ ] Add a non-sensitive participation screenshot or certificate
- [ ] Replace the bilingual placeholder only after the facts are verified

## 8. Final website evidence

- [ ] Successful local `hugo --minify` build
- [ ] English navigation and every required section
- [ ] Vietnamese navigation and every required section
- [ ] Desktop screenshots of the homepage, Proposal, Workshop, and References
- [ ] Mobile navigation and responsive layout
- [ ] Working deployed report URL
- [ ] Link and image audit after deployment
- [ ] Final review for old-template identity, encoding errors, phone numbers, and secrets
- [ ] Confirm no unsupported deployment or metric claims remain
- [ ] Record the submitted FCAJ URL and submission date
