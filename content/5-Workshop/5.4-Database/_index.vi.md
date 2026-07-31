---
title: "DynamoDB và dữ liệu ứng dụng"
weight: 6
chapter: false
pre: " <b> 5.6 </b> "
---

# DynamoDB và dữ liệu ứng dụng

Proposal xác định DynamoDB là database ứng dụng. Database này không phải layout
lưu trữ S3 của Data Engineering: DynamoDB phục vụ giao dịch commerce, còn bucket
pipeline lưu input và artifact batch được sinh ra.

#### Các bảng ứng dụng được đề xuất

| Bảng | Dữ liệu dự kiến |
|---|---|
| `Products` | Catalog và định danh sản phẩm |
| `Categories` | Nhóm sản phẩm |
| `Users` | Account; mật khẩu không được lưu plain text |
| `Sessions` | Session xác thực hoặc trạng thái thu hồi |
| `Carts` | Trạng thái giỏ hàng theo user |
| `Vouchers` | Định nghĩa và hiệu lực giảm giá |
| `Reviews` | Đánh giá sản phẩm |
| `Orders` | Order header và line data |

Ảnh console do thành viên nhóm cung cấp xác nhận tám bảng DynamoDB đang hoạt
động ở chế độ on-demand và thể hiện cấu trúc khóa chính.

![Các bảng DynamoDB đang hoạt động và cấu trúc khóa](/images/5-Workshop/team/dynamodb-tables.png)

#### Tích hợp với Data Engineering

Pipeline không query hay sửa các bảng trên. Pipeline nhận export ZIP từ
database, sau đó dùng giá trị `id` trong `Products.json` làm product lookup đáng
tin cậy. Ranh giới này tránh phụ thuộc batch job vào credential ứng dụng hoặc
tính sẵn sàng của live database.

#### Checklist tách dữ liệu

- Không upload export database người dùng vào repository báo cáo công khai.
- Tách rõ bảng ứng dụng và prefix S3 của pipeline.
- Giữ định danh ứng dụng trong export và gói ML sạch.
- Ghi rõ owner, format, cadence và retention của export.
- Dùng dữ liệu đã che hoặc synthetic trong ảnh.

Báo cáo không công khai item hoặc dữ liệu khách hàng; ảnh ở mức danh sách bảng
ghi nhận mô hình dữ liệu đã triển khai mà không làm lộ dữ liệu ứng dụng.
