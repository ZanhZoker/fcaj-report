---
title: "Deploy the Frontend Layer"
weight: 4
chapter: false
pre: " <b> 5.4 </b> "
---

# Deploy the Frontend Layer

## Objective and architecture position

Build the React/Vite application into static files, place them in a private S3
origin, and deliver them over HTTPS through CloudFront. The frontend is a team
component; this page documents the reviewed source and the deployment procedure,
not an individual claim by Trần Uy Danh.

## Source-confirmed baseline

The team repository uses React, Vite, React Router and Redux Toolkit. Its routes
cover the home page, product detail, category/search, authentication, cart,
checkout, account, notifications, seller and admin screens. The current source
calls a browser-side mock API and stores seeded data in local storage. No
`import.meta.env` API variable or production `fetch` client exists in the
reviewed source, so a live API connection must be verified separately.

## Step 1. Install and build

```powershell
npm i
npm run build
```

The `build` script runs `vite build`. Confirm that `dist/index.html` and hashed
files under `dist/assets/` are created before uploading anything.

## Step 2. Prepare the S3 origin

Create or select the verified frontend bucket in **ap-southeast-1**. Keep Block
Public Access enabled, disable static-website public access, and upload only the
contents of `dist/`. CloudFront—not anonymous S3 access—should serve the files.

```powershell
aws s3 sync dist/ s3://<FRONTEND-BUCKET>/ --delete --profile <AWS-PROFILE>
```

Do not replace the angle-bracket values until the operator has confirmed the
actual team bucket and profile.

## Step 3. Configure CloudFront

1. Use the private S3 bucket as the origin.
2. Create or attach an Origin Access Control.
3. Apply the generated bucket policy only to the verified bucket.
4. Set the default root object to `index.html`.
5. Redirect HTTP to HTTPS.
6. Keep compression enabled and select a cache policy suitable for static assets.

![Enabled CloudFront distribution supplied by the team](/images/5-Workshop/team/cloudfront-distribution.png)

*Supplied project capture: an enabled CloudFront distribution for the shared frontend. The
resource identifier is not repeated in the report.*

## Step 4. Support React Router

Direct navigation to routes such as `/product/:id`, `/cart` or `/account` must
return the SPA entry point rather than an S3 access error. Configure CloudFront
custom error handling for the chosen 403/404 behaviour to return `/index.html`
with the response code expected by the team, then test a nested route directly.

## Step 5. Connect the application API

The reviewed source does not define a production API environment variable.
Before cloud integration, the frontend owner must confirm the variable name and
replace the mock service through a reviewed API client. A value such as
`<API-URL>` in this Workshop is documentation syntax, not a deployed endpoint.
The browser must receive CORS headers from the real API origin.

## Step 6. Publish an update

After each new build, sync `dist/` and invalidate cached files only on the
verified distribution:

```powershell
aws cloudfront create-invalidation `
  --distribution-id <DISTRIBUTION-ID> `
  --paths "/*" `
  --profile <AWS-PROFILE>
```

## Step 7. Inspect the interface

![Product catalogue rendered by the team frontend](/images/5-Workshop/frontend/catalog.png)

*Catalogue screen from the team frontend source/report.*

![Product detail rendered by the team frontend](/images/5-Workshop/frontend/product-detail.png)

*Product-detail route used to verify client-side routing and catalogue IDs.*

## Common issues

- An old CloudFront cache can show a previous build after S3 is updated.
- A missing SPA fallback causes nested routes to return 403/404.
- A public S3 bucket bypasses the intended OAC boundary.
- The current mock API can make the interface appear functional without proving the deployed API works.
- A frontend API URL that points to the wrong stage or Region produces network or CORS failures.

## Verification

| Check | Expected result |
|---|---|
| CloudFront domain | Opens over HTTPS |
| Home and catalogue | React renders without a blank screen |
| Static assets | No missing JavaScript, CSS or image requests |
| Nested route | Opens directly and returns the SPA |
| API configuration | Points to the team-approved API, not the mock service |
| Cache refresh | New build appears after invalidation |

**Output for the next step:** a verified HTTPS frontend URL and a build whose
catalogue identifiers can be traced through the API and database layers.
