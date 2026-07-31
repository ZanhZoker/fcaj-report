---
title: "Frontend and CloudFront"
weight: 4
chapter: false
pre: " <b> 5.4 </b> "
---

# Frontend and CloudFront

The team repository confirms a React/Vite single-page application using React
Router, Redux Toolkit, and reusable UI components. Source routes cover the home
page, categories, text search, product details, cart, checkout, account, seller,
notifications, and administration.

#### Current source behaviour

- Product, account, cart, voucher, and order operations use local mock data.
- The mock API simulates latency and stores data in browser local storage.
- The homepage recommendation block selects a static product slice.
- Search is text-based; no CLIP visual-search code is present in this source.

These details make the frontend useful as a UI prototype, but they must not be
described as live backend or Personalize integration.

#### Target AWS delivery

The proposal places the Vite `dist/` output in a private S3 bucket and uses
CloudFront for HTTPS and caching. CloudFront Origin Access Control (OAC) is the
preferred target so users cannot browse the bucket directly. Client-side routes
also need an SPA fallback to `index.html`.

```powershell
npm install
npm run build
aws s3 sync .\dist "s3://<FRONTEND_BUCKET>/" --delete
aws cloudfront create-invalidation --distribution-id <DISTRIBUTION_ID> --paths "/*"
```

The commands are a deployment procedure, not proof that the target resources
exist. Replace placeholders only after the responsible team member confirms the
actual resource names.

#### Verification

- Build the frontend successfully.
- Open home, product, category, search, cart, checkout, and account routes.
- Verify direct SPA paths resolve through CloudFront.
- Confirm the S3 origin is not public if OAC is used.
- Confirm browser requests use the intended API only after integration exists.

<!-- TODO: Team evidence - deployed CloudFront website -->
<!-- TODO: Team evidence - homepage and product browsing -->
<!-- TODO: Team evidence - recommendation section -->
