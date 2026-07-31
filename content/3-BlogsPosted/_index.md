---
title: "Blogs Posted"
weight: 3
chapter: false
pre: " <b> 3. </b> "
---

This section lists and introduces the blogs posted to [AWS Study Group](https://www.facebook.com/groups/awsstudygroupfcj).

### [Blog 1 - Session Policies in Amazon EKS Pod Identity](3.1-Blog1/)

This blog introduces the newly added session policies feature in Amazon EKS Pod Identity, which allows you to narrow IAM permissions flexibly and precisely for each pod without needing to create multiple separate IAM roles. The article covers key concepts including how session policies work (effective permissions = intersection between role permissions and session policy), benefits such as reducing IAM role proliferation and avoiding quota limits, and practical debugging techniques for AccessDenied errors using the four-question framework (principal, action, resource, context). It also explains the relationship between different IAM policy layers including identity-based policies, resource-based policies, permissions boundaries, SCPs, and session policies.

### [Blog 2 - From Zero to Zero-Downtime: DevOps & CI/CD on AWS](3.2-Blog2/)

This blog shares practical lessons learned from implementing DevOps and CI/CD on AWS. It covers three key lessons: Infrastructure as Code (using Terraform or AWS CDK instead of manual console clicks), Shift-Left Security (integrating security scans early in the pipeline with Checkov, TFLint, and Amazon ECR Image Scanning), and Blue/Green & Canary Deployments (achieving zero-downtime through AWS CodeDeploy strategies). The article also details a complete pipeline architecture: GitHub → AWS CodePipeline → AWS CodeBuild (Unit Tests & Security Scan) → Amazon ECR → AWS CodeDeploy/Helm → Amazon EKS. Results include deployment time reduction from 30 minutes to under 4 minutes with automated rollback capabilities.

### [Blog 3 - Recommendation Systems Fail: Data, Not Algorithm](3.3-Blog3/)

This blog shares a critical lesson from building a product recommendation system with Amazon Personalize during an internship at FCAJ. When initial metrics were disastrous (Precision@5 = 0.0889, NDCG@10 = 0.1799, MRR@25 = 0.1216), the first instinct was to change the algorithm recipe. However, the real issue was data quality — the interactions were randomly generated with no underlying patterns. After regenerating data with realistic user segments (electronics, fashion, books), session-based behavior, conversion funnels, and power-law distributions, performance improved dramatically: Precision@5 increased 4.9x, NDCG@10 increased 3.6x, and MRR@25 increased 5.9x — all with the same algorithm. The article emphasizes three key lessons: understand your algorithm's core mechanism (collaborative filtering needs structure), prioritize data quality over algorithm selection, and design synthetic data carefully. The key takeaway: tools and algorithms are only 20%, the remaining 80% is data quality and understanding your problem domain.
