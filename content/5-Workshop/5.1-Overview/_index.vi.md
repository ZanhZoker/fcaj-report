---
title: "Tổng quan project"
weight: 1
chapter: false
pre: " <b> 5.1 </b> "
---

# Tổng quan project

Project nhóm giải quyết bài toán khám phá sản phẩm trong trải nghiệm e-commerce
có đầy đủ luồng mua sắm thông thường. Prototype frontend hiện có các route
catalog, category, text search, product detail, cart, checkout, account, seller,
notification và administration. Recommendation và visual search mở rộng khả
năng khám phá vượt ra ngoài tìm kiếm văn bản trực tiếp.

#### Mục tiêu project

- Cung cấp giao diện commerce React/Vite dễ sử dụng.
- Dùng kiến trúc AWS serverless mục tiêu cho phân phối và dịch vụ nghiệp vụ.
- Chuẩn bị interaction data an toàn cho recommendation training.
- Trả kết quả gợi ý qua ứng dụng về frontend.
- Duy trì trách nhiệm, monitoring, security, testing, cost và cleanup rõ ràng.

#### Tóm tắt thành phần và bằng chứng

| Phần | Vai trò trong project | Bằng chứng hiện tại |
|---|---|---|
| Frontend | Màn hình commerce và luồng trình duyệt | Source React/Vite; mock data trong browser |
| Cloud delivery | S3 origin và CloudFront HTTPS | Proposal; chờ ảnh |
| Backend | API Gateway và application Lambda | Proposal; chờ source/ảnh |
| Database ứng dụng | Các bảng DynamoDB | Proposal; chờ source/ảnh |
| Data Engineering | Kiểm tra và bàn giao interaction | Source, tests, reports, SAM template |
| Machine Learning | Train/evaluate/campaign Personalize | Proposal và blog; chờ bằng chứng trực tiếp |
| Visual search | CLIP embedding và similarity | Proposal; chờ bằng chứng triển khai |

#### Vai trò cá nhân

Tôi phụ trách pipeline Data Engineering, không phải toàn bộ nền tảng. Công việc
của tôi bắt đầu từ export ứng dụng/database và kết thúc ở clean dataset cùng
quality report bàn giao cho thành viên/nhóm ML.

<!-- TODO: Team evidence - project overview and deployed experience -->
