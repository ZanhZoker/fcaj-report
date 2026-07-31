---
title: "Internship Report"
weight: 1
chapter: false
---

# Internship Report

![Portrait of Trần Uy Danh](/images/avatar-tran-uy-danh.jpg)

### Student Information

&emsp; **Full name:** Trần Uy Danh

&emsp; **University:** Ho Chi Minh City University of Technology (HCMUT) - VNU-HCM

&emsp; **Major:** Computer Engineering

&emsp; **Internship organisation:** AWS-FCAJ

&emsp; **Internship position:** Data Engineering Intern

&emsp; **Internship period:** 15 June 2026 - 14 August 2026

&emsp; **Email:** [danh.tranuy@hcmut.edu.vn](mailto:danh.tranuy@hcmut.edu.vn)

### About This Report

This report presents the team's AWS e-commerce system, which combines product
browsing and shopping flows with recommendation and visual-search concepts. The
target architecture connects a React/Vite frontend with serverless application,
database, and machine-learning components. Each section distinguishes
source-verified implementation, supplied deployment captures, and
proposal-level design.

My main contribution is the Data Engineering pipeline for interaction data. I
designed and implemented the workflow that reads an export ZIP, validates and
normalises `interactions.csv`, checks product identifiers against
`Products.json`, preserves the original `USER_ID` and `ITEM_ID`, and hands
`interactions_clean.csv` plus quality reports to the Machine Learning stage.
Frontend, backend, application database, recommendation training, and visual
search remain team components rather than my individual work.

The report follows the work chronologically through the Worklog, documents the
team proposal, records technical writing and events, and then presents a
step-by-step Workshop. The Workshop links each layer to its evidence and keeps
unverified deployment claims clearly separated from source-confirmed behaviour.

### Report Contents

1.  [Worklog](1-Worklog/)
2.  [Proposal](2-Proposal/)
3.  [Blogs Posted](3-BlogsPosted/)
4.  [Events Participated](4-EventParticipated/)
5.  [Workshop](5-Workshop/)
6.  [Self-evaluation](6-Self-evaluation/)
7.  [Sharing and Feedback](7-Feedback/)
8.  [References](8-References/)

### Project Links

- [Report website](https://zanhzoker.github.io/fcaj-report/)
- [Report repository](https://github.com/ZanhZoker/fcaj-report)
- [Data Engineering repository](https://github.com/ZanhZoker/ecommerce-interactions-pipeline)
- [Team e-commerce repository](https://github.com/dxsondangdung2019-arch/E-commerceWebsiteDesign)
