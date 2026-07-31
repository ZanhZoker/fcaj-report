---
title: "Bài viết đã đăng"
weight: 3
chapter: false
pre: " <b> 3. </b> "
---

Tại đây sẽ là phần liệt kê, giới thiệu các blogs đã đăng trên [AWS Study Group](https://www.facebook.com/groups/awsstudygroupfcj).

### [Blog 1 - Session Policies trong Amazon EKS Pod Identity](3.1-Blog1/)

Blog này giới thiệu tính năng session policies mới được bổ sung trong Amazon EKS Pod Identity, cho phép thu hẹp quyền IAM linh hoạt và chính xác cho từng pod mà không cần tạo nhiều IAM roles riêng biệt. Bài viết bao gồm các khái niệm chính như cách session policy hoạt động (quyền hiệu lực = giao điểm giữa role permissions và session policy), lợi ích như giảm số lượng IAM roles và tránh chạm quota, cùng kỹ thuật debug lỗi AccessDenied thực tế với khung bốn câu hỏi (principal, action, resource, context). Bài viết cũng giải thích mối quan hệ giữa các tầng IAM policy khác nhau.

### [Blog 2 - Từ Zero Đến Zero-Downtime: DevOps & CI/CD Trên AWS](3.2-Blog2/)

Blog này chia sẻ những bài học thực tế từ quá trình triển khai DevOps và CI/CD trên AWS. Bài viết đề cập ba bài học quan trọng: Infrastructure as Code (dùng Terraform hoặc AWS CDK thay vì bấm tay trên console), Shift-Left Security (tích hợp bảo mật sớm với Checkov, TFLint và Amazon ECR Image Scanning), và Blue/Green & Canary Deployments (đạt zero-downtime qua CodeDeploy). Bài viết còn mô tả chi tiết kiến trúc pipeline: GitHub → AWS CodePipeline → AWS CodeBuild (Unit Tests & Security Scan) → Amazon ECR → AWS CodeDeploy/Helm → Amazon EKS. Kết quả đạt được bao gồm thời gian deploy giảm từ 30 phút xuống dưới 4 phút với khả năng tự động rollback.

### [Blog 3 - Hệ Gợi Ý Thất Bại: Dữ Liệu, Không Phải Thuật Toán](3.3-Blog3/)

Blog này chia sẻ một bài học quan trọng từ quá trình xây dựng hệ thống gợi ý sản phẩm với Amazon Personalize trong kỳ thực tập tại FCAJ. Khi các chỉ số ban đầu thảm hại (Precision@5 = 0.0889, NDCG@10 = 0.1799, MRR@25 = 0.1216), phản xạ đầu tiên là đổi thuật toán. Tuy nhiên, vấn đề thực sự nằm ở chất lượng dữ liệu — các tương tác được sinh ngẫu nhiên, không có quy luật nào. Sau khi tái tạo dữ liệu với các phân khúc người dùng thực tế (điện tử, thời trang, sách), hành vi theo phiên, phễu chuyển đổi và phân phối lũy thừa, hiệu suất cải thiện đáng kể: Precision@5 tăng 4.9 lần, NDCG@10 tăng 3.6 lần, và MRR@25 tăng 5.9 lần — tất cả với cùng một thuật toán. Bài viết nhấn mạnh ba bài học quan trọng: hiểu cơ chế cốt lõi của thuật toán (collaborative filtering cần cấu trúc), ưu tiên chất lượng dữ liệu hơn chọn thuật toán, và thiết kế dữ liệu mô phỏng cẩn thận. Điểm mấu chốt: công cụ và thuật toán chỉ chiếm 20%, 80% còn lại là chất lượng dữ liệu và hiểu rõ lĩnh vực bài toán.
