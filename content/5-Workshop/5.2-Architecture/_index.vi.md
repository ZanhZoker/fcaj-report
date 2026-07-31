---
title: "Kiến trúc tổng thể"
weight: 2
chapter: false
pre: " <b> 5.2 </b> "
---


## Mục tiêu và vị trí

Trang này xác định ranh giới giữa ứng dụng người dùng, luồng bàn giao dữ liệu và
recommendation trước khi thực hiện các bước triển khai.

![Kiến trúc tổng thể của project nhóm](/images/5-Workshop/team-architecture-2026.jpg)

*Kiến trúc tổng thể của nhóm. Nhánh Data Engineering vẫn là component độc lập và
được mô tả tại trang Workshop riêng, không bị thay đổi.*

## Các lớp kiến trúc

1. **Lớp phân phối:** CloudFront phục vụ build React/Vite từ S3 origin private.
2. **Lớp ứng dụng:** API Gateway là HTTP entry point mục tiêu của application Lambda.
3. **Lớp lưu trữ:** DynamoDB lưu catalogue, identity, cart và order theo proposal nhóm.
4. **Lớp dữ liệu:** export ZIP đi vào pipeline Data Engineering riêng và trở thành gói bàn giao ML đã kiểm tra.
5. **Lớp recommendation:** tài nguyên Amazon Personalize do phía ML/nhóm phụ trách và trả về product ID có thứ tự.
6. **Lớp vận hành:** CloudWatch cung cấp log/metric; IAM giới hạn quyền giữa các dịch vụ.

## Contract tích hợp

| Ranh giới | Contract cần kiểm tra |
|---|---|
| Browser → frontend | Trang HTTPS và asset của route tải được qua CloudFront |
| Frontend → API | API base URL đúng, JSON hợp lệ và có CORS response |
| API → DynamoDB | User/product/order ID ổn định và quyền truy cập tối thiểu |
| Application → Data Engineering | Export có đủ file interaction và product bắt buộc |
| Data Engineering → ML | Clean interactions giữ nguyên `USER_ID` và `ITEM_ID` của ứng dụng |
| Personalize → API → frontend | Item ID giữ đúng thứ tự và ánh xạ được về catalogue |

## Quyết định thiết kế quan trọng

- S3 origin nên private và chỉ được CloudFront truy cập qua Origin Access Control.
- Route trình duyệt như `/product/123` cần SPA fallback khi được mở trực tiếp.
- Application Lambda và data-processing Lambda có owner và quyền khác nhau.
- Source frontend đã rà soát hiện dùng mock API cùng local storage; tích hợp API production cần được kiểm tra riêng.
- Ảnh từng component không được xem là bằng chứng cho toàn bộ luồng browser-to-recommendation.

## Kiểm tra

- Xác nhận sơ đồ dễ đọc và đúng ownership của từng component.
- Xác nhận báo cáo không hard-code bucket, ARN, endpoint hoặc account identifier.
- Xác nhận mỗi trang component bàn giao đầu ra rõ ràng cho lớp tiếp theo.
- Dùng [Kiểm thử đầu cuối](../5.8-Testing/) để xác minh runtime và [Dọn dẹp](../5.9-Cleanup/) để xóa đúng dependency.
