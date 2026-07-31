---
title: "Giám sát, IAM và bảo mật"
weight: 11
chapter: false
pre: " <b> 5.11 </b> "
---

Phần này tách biệt các biện pháp đã được xác nhận trong source Data Engineering với các biện pháp vẫn là mục tiêu của ứng dụng nhóm.

#### Kiểm soát Data Engineering đã được xác nhận trong source

- **CloudWatch Logs:** log chạy Lambda cung cấp dấu vết cho từng lần xử lý do S3 kích hoạt. SAM template tạo log group của function với thời gian lưu bảy ngày.
- **IAM tối thiểu:** function xử lý chỉ được đọc `incoming/*` và ghi vào `processed/*`, `rejected/*`, `reports/*` trong data bucket.
- **Lưu trữ riêng tư:** S3 bucket chặn truy cập công khai và dùng mã hóa phía máy chủ với khóa do Amazon S3 quản lý.
- **Cấu hình:** bucket và các output prefix được truyền qua biến môi trường. Credential và secret không được lưu trong repository.
- **Khả năng quan sát lỗi:** lỗi validation được ghi thành artifact rejected và được tổng hợp trong quality report JSON và Markdown. Ngoại lệ không dự kiến được ghi vào Lambda log.

Repository Data Engineering không định nghĩa alarm hoặc SNS notification. Tách
biệt với pipeline, ảnh do nhóm cung cấp xác nhận CloudWatch alarm cho lỗi và độ
trễ của Lambda ứng dụng.

![CloudWatch alarm cho lỗi và độ trễ ứng dụng](/images/5-Workshop/team/cloudwatch-alarms.png)

#### Mục tiêu bảo mật cho ứng dụng nhóm

Proposal hướng đến HTTPS qua CloudFront, S3 origin riêng tư với Origin Access Control, API có xác thực, quyền Lambda giới hạn và dữ liệu ứng dụng được bảo vệ. Source frontend hiện tại là prototype chạy trên trình duyệt, dùng dữ liệu mock và local storage; vì vậy đây không phải bằng chứng cho xác thực production, password hashing, OAC đã triển khai hoặc giám sát backend.

Trước khi phát hành production, nhóm cần xác minh phân quyền request, kiểm tra input, password hashing, quản lý secret, che dữ liệu nhạy cảm trong log, CORS, quyền tối thiểu và thời gian lưu log trên toàn bộ application stack.

![Sự kiện thực thi Lambda Data Engineering](/images/5-Workshop/data-engineering/cloudwatch-log-events.png)

Ảnh ghi nhận một lần Lambda chạy thành công. Summary chi tiết được trình bày ở
phần Data Engineering sau khi loại bỏ định danh cấp tài khoản.

#### Checklist minh chứng

Ảnh chụp phải che credential, session token, account ID đầy đủ, dữ liệu cá nhân và thông tin billing không liên quan. Ảnh console chỉ được xem là minh chứng khi có thể xác minh tên tài nguyên, region và mối liên hệ với project này.
