---
title: "AWS Security Agent, SLA/Monitoring, and Cloud Certification"
weight: 2
chapter: false
pre: " <b> 4.2 </b> "
---

# AWS Security Agent, SLA/Monitoring, and Cloud Certification

**Date:** 11 July 2026  
**Format:** In person, Ho Chi Minh City  
**Role:** Attendee

This workshop linked early security review, SLA-driven operations, system
observability, incident response, and AWS Certified Cloud Practitioner
preparation. The sessions were delivered by Thinh, Son, and Huy.

#### Highlights

- Architecture, Infrastructure as Code, and source changes should be reviewed
  for security early in the development lifecycle.
- Healthy infrastructure metrics do not guarantee that a user journey works;
  monitoring must include application outcomes and business flows.
- An alarm needs an owner, severity, response action, and post-incident review.
- Certification study provides a structured foundation, while practical work
  remains essential.

#### Key takeaways and application

For the interaction pipeline, I reviewed S3 public-access controls, Lambda IAM
scope, log retention, and the separation of `incoming/`, `processed/`,
`rejected/`, and `reports/`. CloudWatch logs and the data-quality report are both
treated as operational evidence: one explains execution, the other explains the
resulting data.

#### Personal reflection

The monitoring session was especially useful because it shifted my attention
from “no Lambda error” to whether the expected clean dataset and quality checks
were actually produced.

![Attendance photo during the security and monitoring workshop](/images/4-Events/2026-07-11-security-monitoring.jpg)

*Attendance photo with a monitoring display visible in the event space.*
