---
title: "Backend, API Gateway và Application Lambda"
weight: 5
chapter: false
pre: " <b> 5.5 </b> "
---

# Backend, API Gateway và Application Lambda

Proposal giao application API cho API Gateway và một application Lambda. Thành
phần này tách biệt với Lambda Python của Data Engineering. Repository nhóm hiện
không có application Lambda hoặc hạ tầng API, vì vậy phần dưới được giữ ở mức
mục tiêu tích hợp của nhóm.

#### Trách nhiệm mục tiêu

- Nhận request ứng dụng đã xác thực qua API Gateway.
- Định tuyến catalog, account, cart, voucher, review, order và recommendation.
- Kiểm tra payload và áp dụng business rule phía server.
- Đọc/ghi record ứng dụng trong DynamoDB.
- Gọi recommendation endpoint và ánh xạ item ID đã xếp hạng về product detail.
- Trả JSON nhất quán và CORS header cho frontend.

#### Authentication và business rule

Frontend hiện tại chỉ có browser mock token và giá trị mật khẩu giả lập; đây
không phải xác thực production. Backend mục tiêu cần authentication phía server,
password hashing an toàn, session có thời hạn hoặc có thể thu hồi và cấu hình
qua environment. Tổng tiền order phải tính từ dữ liệu ứng dụng đáng tin cậy,
không tin giá do browser gửi.

#### Checklist API contract

Trước khi deploy, thành viên frontend và backend cần thống nhất:

| Phạm vi contract | Quyết định cần có |
|---|---|
| Identity | Token, expiry, role và error response |
| Product | ID chuẩn, price, stock, image, category |
| Cart/checkout | Quantity, voucher, payment method, total |
| Order | Status, line item, timestamp, ownership |
| Recommendation | User ID input, item ID có thứ tự, fallback |
| Error | HTTP code và response schema ổn định |

#### Hoạt động kiểm tra

Sau khi có source và infrastructure ứng dụng, cần kiểm tra route đã cấu hình,
gọi request đại diện, xác nhận quyền database/Personalize tối thiểu và chụp
response thành công/lỗi đã che dữ liệu nhạy cảm.

<!-- TODO: Team evidence - API Gateway routes -->
<!-- TODO: Team evidence - application Lambda -->
<!-- TODO: Team evidence - successful API response -->
