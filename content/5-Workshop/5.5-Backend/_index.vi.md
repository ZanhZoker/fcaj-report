---
title: "Triển khai lớp API"
weight: 6
chapter: false
pre: " <b> 5.6 </b> "
---

# Triển khai lớp API

## Mục tiêu và vị trí trong kiến trúc

API nằm giữa frontend React với DynamoDB hoặc Amazon Personalize. Lớp này cần
validate request, thực thi authentication/ownership, tính order total đáng tin
cậy và trả JSON ổn định. Đây là component nhóm; source backend ứng dụng không có
trong repository frontend đã rà soát.

## Ranh giới bằng chứng

Proposal nhóm mô tả HTTP API Gateway có 22 routes và Lambda Node.js 20 tên
**fcj-api**. Ảnh console do nhóm cung cấp cho thấy code tạo order trong Lambda và
handler **index.handler**, nhưng ảnh không chứng minh mọi route, environment
variable, timeout hoặc memory setting.

![Code Application Lambda do nhóm cung cấp](/images/5-Workshop/team/application-lambda.png)

*Minh chứng nhóm được crop giữ phần logic order; account và storage identifier đã
được loại khỏi ảnh.*

## Bước 1. Xác minh IAM execution role

Execution role của Lambda cần quyền CloudWatch Logs và chỉ những action DynamoDB
hoặc Personalize mà route thực sự dùng. Không dùng administrator policy rộng để
thay cho access-pattern review. Secret phải nằm trong secret store hoặc cấu hình
được bảo vệ, không nằm trong source hay báo cáo.

## Bước 2. Xác minh cấu hình Lambda

Dùng lệnh read-only với profile đã được nhóm duyệt:

```powershell
aws lambda get-function-configuration `
  --function-name fcj-api `
  --region ap-southeast-1 `
  --profile <AWS-PROFILE>
```

Đối chiếu runtime, handler, role, architecture, timeout, memory và tên environment
variable với source của owner. Node.js 20 trong proposal là tài liệu thiết kế;
báo cáo không tự tạo giá trị runtime còn thiếu.

## Bước 3. Cấu hình environment variable

Nhóm biến dự kiến gồm tên bảng, frontend origin được phép, session/token config và
Personalize campaign reference khi recommendation runtime được bật. Chỉ ghi tên
biến, không công khai secret value, token, account ID hoặc private ARN đầy đủ.

## Bước 4. Kết nối API Gateway

Proposal mô tả HTTP API. Phải kiểm tra API và integration thật, không copy endpoint
từ môi trường khác:

```powershell
aws apigatewayv2 get-apis `
  --region ap-southeast-1 `
  --profile <AWS-PROFILE>

aws apigatewayv2 get-routes `
  --api-id <API-ID> `
  --region ap-southeast-1 `
  --profile <AWS-PROFILE>
```

Với mỗi route, kiểm tra method, path, integration, authorization và error shape.
Con số 22 routes vẫn ở mức proposal cho tới khi output route hoặc source backend
được rà soát.

## Bước 5. Cấu hình CORS

Production chỉ nên cho phép CloudFront origin đã xác minh. Thêm đúng method/header
frontend cần, sau đó test request thường và preflight. Không dùng wildcard origin
khi request có cookie hoặc authorization header.

## Bước 6. Kết nối DynamoDB

Product read phải resolve ID từ **Products**. Cart/order phải lấy user từ session
đã xác thực và dùng key schema trong bước Database. API cần đọc lại giá, validate
voucher và lưu order nhất quán với workflow project.

## Bước 7. Kết nối recommendation và frontend

Khi Personalize campaign active, API truyền authenticated user ID, nhận item ID
có thứ tự, ánh xạ về catalogue mà không đổi thứ tự và trả response an toàn cho
frontend. Nếu campaign chưa active, API nên trả fallback có kiểm soát thay vì lộ
AWS error. Frontend phải dùng `<API-URL>` đã xác minh, không dùng mock service local.

## Bước 8. Kiểm tra CloudWatch Logs

Kiểm tra request ID, status code, duration và error context có cấu trúc. Log không
được chứa password, session token hoặc customer payload đầy đủ.

## Lỗi thường gặp

- API route tồn tại nhưng trỏ sai Lambda alias/integration.
- CORS chạy với GET nhưng lỗi ở request authenticated hoặc preflight.
- Lambda role invoke được nhưng không đọc được DynamoDB key cần thiết.
- Backend tin order total do client gửi mà không tính lại.
- Recommendation ID bị đổi thứ tự khi lấy catalogue detail.

## Kiểm tra

| Hạng mục | Kết quả mong đợi | Trạng thái bằng chứng |
|---|---|---|
| Lambda configuration | Runtime, handler và role khớp source owner | Cần kiểm tra configuration |
| Product endpoint | Trả catalogue JSON hợp lệ | Chưa có minh chứng đầu cuối |
| Authentication | Session hợp lệ được chấp nhận, session sai bị từ chối | Chưa có minh chứng đầu cuối |
| DynamoDB access | Product/cart/order key resolve đúng | Có ảnh bảng; chưa có runtime call |
| CloudWatch | Có request/error log và không lộ secret | Có ảnh alarm; chưa có API request log |
| Frontend call | Browser request tới đúng API | Cần kiểm tra ở End-to-End Testing |

**Đầu ra cho bước tiếp theo:** API contract đã review và runtime path đã xác minh
để dùng database ID cùng recommendation result.
