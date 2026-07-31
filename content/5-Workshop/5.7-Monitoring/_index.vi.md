---
title: "Monitoring và Alerting"
weight: 9
chapter: false
pre: " <b> 5.9 </b> "
---

# Monitoring và Alerting

## Mục tiêu và vị trí trong kiến trúc

Monitoring phải trả lời component nào lỗi, request hoặc data run nào bị ảnh hưởng,
thời gian xử lý bao lâu và lỗi đơn lẻ hay lặp lại. Application Lambda và Data
Engineering Lambda là hai function riêng, cần log group và ownership riêng khi điều tra.

## Bước 1. Xác định application logs

Kiểm tra log group của Application Lambda và stream gần nhất bằng profile đã duyệt:

```powershell
aws logs describe-log-groups `
  --log-group-name-prefix /aws/lambda/fcj-api `
  --region ap-southeast-1 `
  --profile <AWS-PROFILE>
```

Application log nên có request ID, route/method, status, duration và error code an
toàn. Không log password, authorization token, session value hoặc customer payload đầy đủ.

## Bước 2. Xác định Data Engineering logs

Processing Lambda ghi count/status theo data run như trang
[Pipeline Data Engineering](../5.7-DataEngineering/) mô tả. Dùng log đó để nối
input object, output artifact và quality report mà không thay đổi trang pipeline
hoặc ảnh minh chứng của trang đó.

## Bước 3. Theo dõi Lambda metrics

Với cả hai function, kiểm tra tối thiểu:

| Metric | Ý nghĩa | Tín hiệu điều tra |
|---|---|---|
| Invocations | Xác nhận traffic hoặc event delivery | Request/upload dự kiến nhưng không invoke |
| Errors | Phát hiện handler thất bại | Error count khác 0 kéo dài |
| Duration | Cho biết latency và nguy cơ timeout | Tiệm cận timeout hoặc tăng mạnh |
| Throttles | Phát hiện concurrency limit | Có throttle trong traffic dự kiến |
| Concurrent executions | Giải thích burst và tranh chấp | Saturation bất thường |

Khi các component active, cần đối chiếu thêm API Gateway 4xx/5xx, CloudFront error,
DynamoDB throttling và Personalize runtime error.

## Bước 4. Truy lỗi có cấu trúc

Bắt đầu từ triệu chứng phía user, ghi timestamp rồi lần theo CloudFront, API
Gateway, Application Lambda và downstream service. Với data run, lần theo S3
object event tới processing Lambda và output report. Dùng ID/timestamp thay vì
copy payload nhạy cảm vào báo cáo.

## Bước 5. Xác minh alarm

![CloudWatch alarm do nhóm cung cấp](/images/5-Workshop/team/cloudwatch-alarms.png)

*Minh chứng nhóm: có alarm latency và error cho Application Lambda với action
enabled. Ảnh không cho biết notification destination nên báo cáo không khẳng định SNS topic.*

Kiểm tra period, statistic, threshold, missing-data treatment và action target.
Alarm mới tạo có thể ở **Insufficient data** cho tới khi đủ metric period.

## Bước 6. Đặt retention và kiểm soát chi phí

Retention phải đủ cho demo và incident review nhưng không để vô hạn nếu không có
lý do. Source Data Engineering định nghĩa retention hữu hạn cho function của nó;
retention ứng dụng phải được kiểm tra trong môi trường owner. Tắt debug log dài
trước demo công khai và không log request/response body lớn.

Các kiểm soát chi phí được tích hợp tại bước này:

- giới hạn CloudWatch retention;
- cache static asset qua CloudFront;
- DynamoDB on-demand cho demo traffic không đều;
- chỉ right-size Lambda memory sau khi có duration evidence;
- quản lý vòng đời Personalize campaign vì campaign idle có thể chiếm phần lớn chi phí.

## Lỗi thường gặp

- Xem sai Region hoặc log group.
- Alarm dùng sai statistic/evaluation period.
- Handler nuốt lỗi và chỉ log response 200 chung chung.
- Log chứa token, dữ liệu cá nhân hoặc record đầy đủ.
- Personalize campaign còn active dù không có lịch test.

## Kiểm tra

| Hạng mục | Kết quả mong đợi | Trạng thái bằng chứng |
|---|---|---|
| Application log group | Request gần nhất có structured log an toàn | Cần kiểm tra |
| Processing log group | Run summary khớp artifact | Được Data Engineering ghi nhận |
| Errors/duration/throttles | Có dashboard hoặc CLI view | Đã mô tả quy trình |
| Alarms | Có error và latency alarm | Có ảnh cung cấp |
| Notification action | Destination và recipient được xác nhận | Chưa có tài liệu |
| Retention | Có giá trị rõ cho từng log group project | Data layer đã ghi nhận; application cần kiểm tra |

**Đầu ra cho bước tiếp theo:** timestamp, request/run identifier, log và metric
evidence hỗ trợ End-to-End checklist mà không lộ dữ liệu nhạy cảm.
