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

![Catalogue and flash-sale interface](/images/5-Workshop/frontend/catalog.png)

*The team frontend demonstrates catalogue navigation, product cards, pricing,
ratings, and availability states.*

![Product detail interface](/images/5-Workshop/frontend/product-detail.png)

*The product-detail route demonstrates quantity selection and cart/purchase
actions in the UI prototype.*

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

The commands describe the repeatable deployment procedure. The supplied team
capture below confirms one enabled CloudFront distribution for the frontend.

![Enabled CloudFront distribution for the team frontend](/images/5-Workshop/team/cloudfront-distribution.png)

#### Verification

- Build the frontend successfully.
- Open home, product, category, search, cart, checkout, and account routes.
- Verify direct SPA paths resolve through CloudFront.
- Confirm the S3 origin is not public if OAC is used.
- Confirm browser requests use the intended API only after integration exists.

The screenshots verify the user interface and CloudFront resource. Live API and
Personalize responses are evaluated separately on the integration page.
