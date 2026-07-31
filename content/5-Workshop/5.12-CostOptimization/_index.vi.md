---
title: "Tối ưu chi phí"
weight: 12
chapter: false
pre: " <b> 5.12 </b> "
---

Project ưu tiên dịch vụ managed và serverless để môi trường demo có thể giảm mức sử dụng khi không hoạt động. Các nội dung dưới đây là định hướng thiết kế và ước tính, không phải hóa đơn AWS thực tế.

| Hạng mục | Cách tiếp cận chi phí | Trạng thái bằng chứng |
|---|---|---|
| Frontend | Cache tài nguyên tĩnh tại CloudFront và chỉ lưu build artifact trong S3 | Theo đề xuất; đang chờ minh chứng triển khai |
| API và xử lý | Dùng mô hình tính phí theo request của Lambda và điều chỉnh memory sau khi quan sát duration | Cấu hình data pipeline đã xác nhận; triển khai ứng dụng đang chờ |
| Dữ liệu ứng dụng | Dùng DynamoDB on-demand cho tải demo không đều | Theo đề xuất |
| Data lake | Áp dụng S3 lifecycle nếu raw export và report tăng lên | Khuyến nghị; chưa xác nhận lifecycle rule |
| Log | Giới hạn thời gian lưu; SAM template Data Engineering dùng bảy ngày | Đã xác nhận cho processing Lambda |
| Recommendation | Chỉ tạo tài nguyên Amazon Personalize khi đánh giá hoặc demo theo lịch và xóa campaign không dùng | Việc của nhóm/ML; đang chờ minh chứng triển khai |

Chi phí cần được kiểm tra theo region và bảng giá AWS hiện hành trước khi triển khai. Budget và cost-allocation tag là biện pháp bảo vệ hữu ích nhưng báo cáo không khẳng định đã cấu hình.

<!-- TODO: Team evidence - current AWS cost estimate and resource inventory -->
<!-- TODO: Team evidence - Personalize resource status before and after demo -->

Quy trình cleanup ở phần tiếp theo là một phần của kế hoạch chi phí: không để tài nguyên tạm tiếp tục hoạt động sau buổi demo project.
