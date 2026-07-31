---
title: "Kết luận và đóng góp của nhóm"
draft: true
weight: 14
chapter: false
pre: " <b> 5.14 </b> "
---

Project nhóm kết nối trải nghiệm thương mại điện tử React/Vite với kiến trúc ứng dụng serverless và luồng recommendation dự kiến trên AWS. Source frontend đã xác nhận các chức năng khám phá sản phẩm, tìm kiếm, chi tiết sản phẩm, giỏ hàng, thanh toán, tài khoản, giao diện người bán, thông báo và quản trị bằng dữ liệu mock phía trình duyệt. Kiến trúc mục tiêu bổ sung CloudFront, S3, API Gateway, application Lambda, DynamoDB và Amazon Personalize; minh chứng triển khai cho các thành phần chung này vẫn cần được thu thập.

Mỗi vai trò đóng góp một phần cần thiết cho luồng end-to-end. Frontend tạo trải nghiệm khách hàng; backend và database xác định hành vi cùng trạng thái ứng dụng; vai trò ML chuẩn bị và đánh giá mô hình gợi ý; vai trò cloud phối hợp triển khai và bảo mật; kiểm thử xác minh trải nghiệm tích hợp.

Đóng góp Data Engineering của tôi tạo ranh giới giữa dữ liệu export từ ứng dụng và đầu vào ML. Pipeline kiểm tra `interactions.csv` dựa trên `Products.json`, loại bản ghi không hợp lệ kèm lý do, giữ nguyên giá trị `USER_ID` và `ITEM_ID`, tạo quality report và bàn giao `interactions_clean.csv`. Source gồm xử lý local, automated tests và Lambda được kích hoạt bởi S3, đóng gói bằng AWS SAM. Đóng góp này không đồng nghĩa với việc sở hữu các phần frontend, backend hoặc ML.

Hạn chế hiện tại là mức độ đầy đủ của minh chứng: một số dịch vụ AWS dùng chung vẫn là mục tiêu thiết kế hoặc deliverable do thành viên khác phụ trách, trong khi README Data Engineering ghi nhận một lần triển khai nhưng vẫn cần ảnh phù hợp cho báo cáo. Hướng phát triển tiếp theo là thay dữ liệu frontend mock bằng API đã xác minh, hoàn thiện security review, chạy và ghi nhận kiểm thử recommendation end-to-end, tự động hóa việc bàn giao dữ liệu, đồng thời bổ sung minh chứng giám sát và chi phí trước khi nộp.
