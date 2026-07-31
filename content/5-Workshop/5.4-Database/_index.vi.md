---
title: "Tạo và cấu hình Database"
weight: 5
chapter: false
pre: " <b> 5.5 </b> "
---

# Tạo và cấu hình Database

## Mục tiêu và vị trí trong kiến trúc

DynamoDB là lớp lưu trữ ứng dụng giữa API với luồng dữ liệu/recommendation. Lớp
này phải giữ product ID và user ID ổn định để export, recommendation, cart và
order cùng tham chiếu đúng entity.

## Bằng chứng và phạm vi

Source frontend đã rà soát dùng database sinh trong trình duyệt và lưu bằng local
storage; source này không tạo hoặc query DynamoDB. Danh sách bảng và key dưới đây
đến từ ảnh console do nhóm cung cấp, đồng thời khớp proposal. Đây là resource của
nhóm, không phải phần triển khai cá nhân của Trần Uy Danh.

![Các bảng DynamoDB active do nhóm cung cấp](/images/5-Workshop/team/dynamodb-tables.png)

*Ảnh cho thấy tám bảng active ở chế độ on-demand cùng key column tương ứng.*

## Bước 1. Xác minh thiết kế bảng

| Bảng | Partition key | Sort key | Mục đích |
|---|---|---|---|
| **Products** | **id** (String) | — | Catalogue và item identifier ổn định |
| **Categories** | **id** (String) | — | Nhóm sản phẩm |
| **Users** | **id** (String) | — | Tài khoản ứng dụng |
| **Sessions** | **token** (String) | — | Tra cứu session và trạng thái thu hồi |
| **Carts** | **userId** (String) | — | Trạng thái giỏ hàng theo user |
| **Vouchers** | **code** (String) | — | Kiểm tra voucher |
| **Reviews** | **productId** (String) | **id** (String) | Review theo sản phẩm |
| **Orders** | **userId** (String) | **id** (String) | Order theo user |

Ảnh cho thấy capacity on-demand và không có secondary index. Đây là bằng chứng
của môi trường được chụp, không thay thế source hạ tầng hoặc access-pattern review.

## Bước 2. Tạo hoặc xác nhận bảng

Với môi trường mới, owner ứng dụng nên tạo bảng từ định nghĩa hạ tầng đã duyệt.
Repository nhóm đã rà soát không có DynamoDB IaC, nên báo cáo không tự tạo
CloudFormation resource. Khi kiểm tra môi trường đã có, dùng lệnh read-only:

```powershell
aws dynamodb list-tables `
  --region ap-southeast-1 `
  --profile <AWS-PROFILE>

aws dynamodb describe-table `
  --table-name Products `
  --region ap-southeast-1 `
  --profile <AWS-PROFILE>
```

Xác nhận trạng thái **ACTIVE**, billing mode **PAY_PER_REQUEST** và đúng key schema
trước khi kết nối API.

## Bước 3. Seed và kiểm tra catalogue

Dữ liệu seed của prototype frontend không phải DynamoDB import. Catalogue phải
được nạp qua backend hoặc quy trình import đã được nhóm duyệt để product ID khớp
với interactions và Personalize.

```powershell
aws dynamodb scan `
  --table-name Products `
  --limit 5 `
  --region ap-southeast-1 `
  --profile <AWS-PROFILE>
```

Chỉ đọc giới hạn để kiểm tra. Không đưa password, session token, dữ liệu cá nhân,
customer record đầy đủ hoặc chi tiết order nhạy cảm vào ảnh báo cáo.

## Bước 4. Kết nối backend

Role của Application Lambda chỉ nên có action cần cho route tương ứng và chỉ trên
các bảng được duyệt. Ưu tiên key/query cho access pattern; scan chỉ dùng chẩn đoán
có giới hạn. Backend phải tính lại total đáng tin cậy và không chấp nhận order
total do client gửi mà không đọc lại giá sản phẩm.

## Bước 5. Chuẩn bị ranh giới dữ liệu

Owner application/database export interaction và product data cho trang
[Pipeline Data Engineering](../5.7-DataEngineering/) riêng. Handoff chỉ hợp lệ
khi product ID trong interactions ánh xạ được về **Products** và pipeline giữ
nguyên định danh nguồn.

## Lỗi thường gặp

- Bảng ACTIVE nhưng chưa có catalogue record sử dụng được.
- Sai tên key gây validation error dù item trông đúng.
- Dữ liệu local-storage của prototype không chứng minh tích hợp DynamoDB.
- Ảnh không được để lộ user record, session token hoặc account identifier.
- Ảnh cho thấy deletion protection đang off; cleanup phải xác nhận tài nguyên cẩn thận.

## Kiểm tra

| Hạng mục | Kết quả mong đợi |
|---|---|
| Table inventory | Có tám bảng đã ghi nhận và đều ACTIVE |
| Key schema | Khớp partition/sort key trong ảnh |
| Products data | Bounded read trả về catalogue ID hợp lệ |
| Backend access | Product/cart/order dùng đúng bảng |
| Security | Không public access và không có dữ liệu nhạy cảm trong minh chứng |

**Đầu ra cho bước tiếp theo:** table name, key contract và catalogue ID đã xác
minh để API cùng downstream data flow tham chiếu nhất quán.
