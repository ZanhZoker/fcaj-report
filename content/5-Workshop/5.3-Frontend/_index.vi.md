---
title: "Triển khai lớp Frontend"
weight: 4
chapter: false
pre: " <b> 5.4 </b> "
---


## Mục tiêu và vị trí trong kiến trúc

Build ứng dụng React/Vite thành static file, đặt trong S3 origin private và phân
phối HTTPS qua CloudFront. Frontend là component chung của nhóm; trang này mô tả
source đã rà soát và quy trình triển khai, không nhận đây là công việc cá nhân
của Trần Uy Danh.

## Bằng chứng và giới hạn

Repository nhóm dùng React, Vite, React Router và Redux Toolkit. Route bao gồm
home, product detail, category/search, authentication, cart, checkout, account,
notifications, seller và admin. Source hiện gọi mock API trong trình duyệt và
lưu dữ liệu seed bằng local storage. Không có API variable `import.meta.env` hay
production `fetch` client trong source đã rà soát, vì vậy kết nối API thật phải
được xác minh riêng.

## Bước 1. Cài dependency và build

```powershell
npm i
npm run build
```

Script `build` chạy `vite build`. Xác nhận `dist/index.html` và các file có hash
trong `dist/assets/` được tạo trước khi upload.

## Bước 2. Chuẩn bị S3 origin

Tạo hoặc chọn frontend bucket đã xác minh tại **ap-southeast-1**. Giữ Block Public
Access bật, không mở static website trực tiếp và chỉ upload nội dung trong
`dist/`. CloudFront phải phục vụ file thay vì cho phép truy cập S3 ẩn danh.

```powershell
aws s3 sync dist/ s3://<FRONTEND-BUCKET>/ --delete --profile <AWS-PROFILE>
```

Chỉ thay giá trị trong dấu ngoặc nhọn sau khi xác nhận đúng bucket và profile của nhóm.

## Bước 3. Cấu hình CloudFront

1. Dùng S3 bucket private làm origin.
2. Tạo hoặc gắn Origin Access Control.
3. Chỉ áp dụng bucket policy sinh ra cho bucket đã xác minh.
4. Đặt default root object là `index.html`.
5. Redirect HTTP sang HTTPS.
6. Bật compression và chọn cache policy phù hợp static asset.

![CloudFront distribution đang enabled do nhóm cung cấp](/images/5-Workshop/team/cloudfront-distribution.png)

*Minh chứng nhóm: CloudFront distribution của frontend chung đang enabled. Báo
cáo không lặp lại resource identifier.*

## Bước 4. Hỗ trợ React Router

Khi mở trực tiếp `/product/:id`, `/cart` hoặc `/account`, CloudFront phải trả về
SPA entry point thay vì lỗi truy cập S3. Cấu hình custom error cho hành vi
403/404 đã chọn để trả `/index.html` với response code thống nhất, sau đó mở trực
tiếp một nested route để kiểm tra.

## Bước 5. Kết nối API ứng dụng

Ranh giới tích hợp còn lại là API contract production. Trước khi tích hợp cloud,
owner frontend phải xác nhận tên environment variable và thay mock service bằng
API client được review. Giá trị `<API-URL>` trong Workshop chỉ là cú pháp
tài liệu, không phải endpoint đã triển khai. API thật phải trả CORS header phù hợp.

## Bước 6. Publish bản cập nhật

Sau mỗi build mới, sync `dist/` rồi invalidate đúng distribution đã xác minh:

```powershell
aws cloudfront create-invalidation `
  --distribution-id <DISTRIBUTION-ID> `
  --paths "/*" `
  --profile <AWS-PROFILE>
```

## Bước 7. Kiểm tra giao diện

![Danh mục sản phẩm của frontend nhóm](/images/5-Workshop/frontend/catalog.png)

*Màn hình catalogue từ source/report frontend của nhóm.*

![Trang chi tiết sản phẩm của frontend nhóm](/images/5-Workshop/frontend/product-detail.png)

*Product-detail route dùng để kiểm tra client-side routing và catalogue ID.*

## Lỗi thường gặp

- Cache CloudFront cũ vẫn hiển thị build trước sau khi S3 đã cập nhật.
- Thiếu SPA fallback làm nested route trả 403/404.
- S3 public sẽ bỏ qua ranh giới OAC mong muốn.
- Mock API có thể làm giao diện trông hoạt động dù API triển khai chưa được chứng minh.
- API URL sai stage hoặc Region gây lỗi network/CORS.

## Kiểm tra

| Hạng mục | Kết quả mong đợi |
|---|---|
| CloudFront domain | Mở được qua HTTPS |
| Home và catalogue | React render, không có màn hình trắng |
| Static assets | Không thiếu JavaScript, CSS hoặc ảnh |
| Nested route | Mở trực tiếp và trả về SPA |
| API configuration | Trỏ tới API nhóm đã duyệt, không dùng mock service |
| Cache refresh | Build mới xuất hiện sau invalidation |

**Đầu ra cho bước tiếp theo:** frontend HTTPS đã xác minh và build có catalogue
identifier truy vết được qua API và database.
