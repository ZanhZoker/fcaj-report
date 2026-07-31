---
title: "Tự đánh giá"
weight: 6
chapter: false
pre: " <b> 6. </b> "
---

#### Tổng quan

| Năng lực | Mức hiện tại | Minh chứng và giới hạn |
|---|---|---|
| Nền tảng AWS | Cơ bản đến khá | Tôi có thể giải thích vai trò của các dịch vụ trong project nhưng vẫn cần thêm kinh nghiệm production độc lập. |
| Amazon S3 | Khá trong phạm vi đã thực hành | Tôi thiết kế input/output prefix, lưu trữ riêng tư, mã hóa và xử lý theo S3 event cho data pipeline. |
| AWS Lambda | Khá trong phạm vi đã thực hành | Tôi đóng gói Python handler xử lý ZIP và hiểu cách chạy event-driven; tối ưu vận hành vẫn cần thực hành thêm. |
| CloudWatch | Cơ bản | Tôi dùng execution log và cấu hình thời gian lưu log bảy ngày; alarm và dashboard nằm ngoài phạm vi đã xác minh. |
| SAM/CloudFormation | Cơ bản đến khá | Tôi có thể giải thích và kiểm tra tài nguyên pipeline trong `template.yaml`; thiết kế nhiều stack lớn hơn vẫn là mục tiêu học tập. |
| Python và xử lý dữ liệu | Khá | Tôi triển khai đọc archive, validation, reporting, chạy command line và Lambda entry point. |
| Data validation và chất lượng | Khá | Tôi kiểm tra giá trị bắt buộc, event type, timestamp, duplicate và product ID, sau đó báo cáo dòng clean và rejected. |
| Automated testing | Khá trong phạm vi project | Repository Data Engineering ghi nhận 48 test đạt, bao phủ trường hợp bình thường và lỗi. Tôi cần thêm kinh nghiệm performance và integration testing. |
| Git và GitHub | Khá cho cộng tác hằng ngày | Tôi có thể làm việc với branch, review, tài liệu và vệ sinh repository; release automation cần thực hành thêm. |
| Làm việc nhóm và giao tiếp | Đang phát triển tốt | Tôi làm rõ data interface với các vai trò khác và học cách tách deliverable của mình khỏi trách nhiệm downstream. |

#### Nội dung đã thực hành

Kết quả kỹ thuật quan trọng nhất là chuyển một dữ liệu export chưa rõ thành data contract cụ thể. Tôi hiểu rằng pipeline không hoàn thành chỉ vì tạo được một file CSV: cần định nghĩa file được chấp nhận, schema, quy tắc validation, cách xử lý rejected row, chỉ số chất lượng và quy trình bàn giao có thể lặp lại. Việc giữ nguyên `USER_ID` và `ITEM_ID` của ứng dụng là thiết yếu vì kết quả recommendation phải ánh xạ lại được người dùng và sản phẩm thật.

Tôi cũng cải thiện quy trình giải quyết vấn đề. Khi dataset cũ không khớp identifier trong catalogue thật, tôi lần theo sự khác biệt giữa export và yêu cầu downstream, xác nhận `Products.json` là product lookup, bỏ qua `items.csv` không dùng, đồng thời cập nhật test và tài liệu cùng với code. Cách làm này đáng tin cậy hơn việc chỉ sửa một file mà không xem lại contract.

#### Phối hợp và giao tiếp

Project yêu cầu phối hợp giữa các vai trò frontend, backend, database, cloud, ML và Data Engineering. Tôi đã thực hành yêu cầu ví dụ input/output chính xác, ghi nhận assumption và thông báo breaking change. Bài học quan trọng là thống nhất identifier, timestamp, event name và quyền sở hữu file trước khi bắt đầu triển khai. Tôi có thể đóng góp rõ ràng hơn trong trao đổi kỹ thuật, dù vẫn cần chủ động báo trạng thái và rủi ro sớm hơn.

#### Giới hạn

Tôi không tự xem mình là chuyên gia AWS hoặc Data Engineering. Minh chứng mạnh nhất của tôi nằm trong validation, testing, reporting và cấu hình SAM của pipeline này. Tôi có ít minh chứng thực hành hơn về observability production, networking, security review hạ tầng, vận hành Athena, backend của nhóm và triển khai Personalize. Không nên suy rộng các nội dung đó từ đóng góp cá nhân của tôi.

#### Mục tiêu học tiếp theo

1. Hoàn tất một lần triển khai SAM có minh chứng độc lập và operational runbook.
2. Thực hành kiểm tra bằng Athena, dữ liệu phân vùng và lifecycle management.
3. Bổ sung test end-to-end từ application export đến điểm bàn giao cho ML.
4. Cải thiện monitoring, kiểm soát chi phí, IAM review và quản lý secret an toàn.
5. Học sâu hơn về batch processing đáng tin cậy, orchestration và data lineage trên AWS.
