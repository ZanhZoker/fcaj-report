---
title: "Frontend và CloudFront"
weight: 4
chapter: false
pre: " <b> 5.4 </b> "
---

# Frontend và CloudFront

Repository nhóm xác nhận ứng dụng một trang React/Vite sử dụng React Router,
Redux Toolkit và các UI component tái sử dụng. Source route bao gồm homepage,
category, text search, product detail, cart, checkout, account, seller,
notification và administration.

#### Hành vi source hiện tại

- Product, account, cart, voucher và order dùng mock data local.
- Mock API mô phỏng độ trễ và lưu dữ liệu trong local storage của trình duyệt.
- Khối recommendation ở homepage chọn một lát cắt product tĩnh.
- Search dựa trên text; source này chưa có CLIP visual search.

Vì vậy frontend là UI prototype hữu ích nhưng không được mô tả như đã tích hợp
backend hoặc Personalize thật.

#### Mục tiêu phân phối trên AWS

Proposal đặt output `dist/` của Vite trong bucket S3 private và dùng CloudFront
cho HTTPS cùng caching. CloudFront Origin Access Control (OAC) là mục tiêu phù
hợp để người dùng không truy cập thẳng bucket. Client-side route cũng cần SPA
fallback về `index.html`.

```powershell
npm install
npm run build
aws s3 sync .\dist "s3://<FRONTEND_BUCKET>/" --delete
aws cloudfront create-invalidation --distribution-id <DISTRIBUTION_ID> --paths "/*"
```

Các lệnh mô tả quy trình triển khai có thể lặp lại. Ảnh do thành viên nhóm cung
cấp bên dưới xác nhận một CloudFront distribution đang bật cho frontend.

![CloudFront distribution của frontend nhóm đang hoạt động](/images/5-Workshop/team/cloudfront-distribution.png)

#### Kiểm tra

- Build frontend thành công.
- Mở các route home, product, category, search, cart, checkout và account.
- Kiểm tra direct SPA path qua CloudFront.
- Xác nhận S3 origin không public nếu dùng OAC.
- Chỉ xác nhận browser dùng API mục tiêu sau khi tích hợp tồn tại.

![Giao diện danh mục và flash sale](/images/5-Workshop/frontend/catalog.png)

*Frontend nhóm thể hiện điều hướng danh mục, thẻ sản phẩm, giá, đánh giá và
trạng thái còn hàng.*

![Giao diện chi tiết sản phẩm](/images/5-Workshop/frontend/product-detail.png)

*Route chi tiết sản phẩm minh họa chọn số lượng cùng thao tác thêm giỏ hàng và
mua ngay trong UI prototype.*
