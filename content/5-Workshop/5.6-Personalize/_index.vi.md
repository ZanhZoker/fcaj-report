---
title: "Xây dựng Recommendation Engine"
weight: 8
chapter: false
pre: " <b> 5.8 </b> "
---


## Mục tiêu và phân công

Amazon Personalize chuyển interaction đã kiểm tra thành danh sách product gợi ý
có thứ tự. Trần Uy Danh phụ trách validation dataset và clean handoff. Thành viên
ML/nhóm phụ trách schema, import, training, solution version, campaign và đánh giá
model. Owner backend/frontend tích hợp kết quả runtime.

Nguồn sự thật cho preprocessing vẫn là trang
[Pipeline Data Engineering](../5.7-DataEngineering/) được giữ nguyên; trang này
bắt đầu từ ranh giới bàn giao của pipeline.

## Bằng chứng và giới hạn

Ảnh cung cấp xác nhận custom dataset group Active, solution version đã đánh giá,
training duration và model metrics. Bằng chứng hiện có chưa gồm campaign response
hoặc runtime path từ backend tới frontend; hai ranh giới này được gom vào checklist
cuối thay vì lặp lại trong từng bước triển khai.

## Bước 1. Nhận clean interactions

Owner ML nhận `interactions_clean.csv` và quality report tương ứng. Trước import,
xác nhận đủ cột, bảo toàn ID nguồn, row count và mọi `ITEM_ID` đều ánh xạ được về
catalogue sản phẩm của ứng dụng.

## Bước 2. Xác nhận Personalize schema

Interaction schema phải khớp kiểu dữ liệu và event vocabulary của clean file.
Tên field và data type phân biệt chính xác. Không remap user/item ID trừ khi ứng
dụng và downstream lookup được cập nhật nhất quán.

## Bước 3. Upload dataset đã duyệt

Đặt file đã duyệt vào S3 location dành cho ML đã xác minh. Giữ ranh giới bucket
Data Engineering tách với import location của ML khi owner hoặc permission khác nhau.

## Bước 4. Cấp quyền import

Amazon Personalize cần IAM role và bucket policy chỉ cho phép đọc dataset path đã
duyệt. Không công khai role ARN đầy đủ, bucket name hoặc account identifier.

## Bước 5. Tạo hoặc chọn dataset group

![Personalize dataset group Active do nhóm cung cấp](/images/5-Workshop/team/personalize-dataset-group.png)

*Minh chứng nhóm/ML: một custom dataset group được hiển thị ở trạng thái Active.*

```powershell
aws personalize list-dataset-groups `
  --region ap-southeast-1 `
  --profile <AWS-PROFILE>
```

## Bước 6. Tạo Interactions dataset và import job

Gắn schema đã review vào Interactions dataset, bắt đầu import từ S3 object đã duyệt
và chờ job **ACTIVE**. Nếu import failed, điều tra failure reason thay vì retry với
ID đã bị thay đổi.

## Bước 7. Tạo solution

Proposal nhóm chỉ định recipe **aws-user-personalization**. Xác nhận recipe và
dataset group trước khi train; không suy ra campaign chỉ từ solution version Active.

## Bước 8. Train solution version

Chờ training hoàn tất và ghi nhận version dùng để đánh giá. Ảnh cung cấp cho thấy
full training kéo dài 0,85 giờ và solution version Active.

## Bước 9. Đánh giá model metrics

![Personalize solution-version metrics do nhóm cung cấp](/images/5-Workshop/team/personalize-solution-metrics.png)

*Metrics cung cấp gồm NDCG@5 0,5868; NDCG@10 0,6512; NDCG@25 0,7221;
precision@5 0,4348; precision@10 0,2826; precision@25 0,1496; MRR@25 0,7130
và coverage 0,9505. Đây là kết quả ML của nhóm, không phải metric Data Engineering.*

## Bước 10. Chỉ tạo campaign khi cần

Campaign cần cho runtime dạng campaign trong proposal và có thể là nguồn chi phí
lớn khi còn active. Chỉ tạo trong cửa sổ test/demo đã duyệt và ghi status mà
không công khai ARN.

## Bước 11. Kiểm tra recommendation runtime

Dùng hai application user hợp lệ và so sánh item ID có thứ tự. Kết quả cá nhân
hóa nên khác khi model có đủ history; mọi ID phải tồn tại trong **Products**.
Cần CLI/console response thành công trước khi đánh dấu lớp này hoàn tất.

## Bước 12. Tích hợp backend

Application Lambda truyền authenticated user ID, gọi đúng Personalize resource,
giữ thứ tự trả về, lấy product detail và dùng fallback có kiểm soát khi
Personalize không khả dụng.

## Bước 13. Render trên frontend

Frontend render đúng thứ tự response, tránh duplicate, xử lý catalogue item không
còn tồn tại và phân biệt recommendation cá nhân hóa với local related-product
logic của prototype.

## Lỗi thường gặp

- Schema type khác CSV upload.
- S3/IAM permission chặn import job.
- Application ID và dataset ID khác format.
- Solution version Active nhưng chưa có campaign/runtime resource.
- Backend đổi thứ tự ID khi lấy product detail.
- Campaign còn active sau demo và tiếp tục phát sinh chi phí.

## Kiểm tra và đầu ra

| Hạng mục | Kết quả mong đợi | Trạng thái bằng chứng |
|---|---|---|
| Data handoff | Clean file và quality report khớp nhau | Được Data Engineering ghi nhận |
| Dataset group | Custom group Active | Có ảnh cung cấp |
| Solution version | Active và đã đánh giá | Có ảnh cung cấp |
| Model metrics | Ghi nhận từ version đã đánh giá | Có ảnh cung cấp |
| Campaign/runtime | Trả ranked ID cho user hợp lệ | Chờ runtime response |
| Backend/frontend | Giữ rank và resolve product | Chờ integrated test |

**Đầu ra cho bước tiếp theo:** solution version đã đánh giá và, khi được tạo rõ
ràng cho test, runtime resource có ranked ID truy vết qua API tới frontend.
