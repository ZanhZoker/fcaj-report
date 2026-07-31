---
title: "Tổng quan project"
weight: 1
chapter: false
pre: " <b> 5.1 </b> "
---


## Mục tiêu

Project nhóm xây dựng trải nghiệm thương mại điện tử gồm duyệt sản phẩm, xác
thực, giỏ hàng và đơn hàng, kết hợp kiến trúc AWS serverless mục tiêu với hệ gợi
ý cá nhân hóa. Workshop trình bày cách các component kết nối, phần nào được source
xác nhận và phần nào cần kiểm tra trực tiếp trên môi trường triển khai.

![Kiến trúc tổng thể của project nhóm](/images/5-Workshop/team-architecture-2026.jpg)

*Sơ đồ mới nhất của nhóm tách rõ luồng ứng dụng phục vụ người dùng và luồng bàn
giao dữ liệu từ Data Engineering sang recommendation.*

## Luồng hệ thống

| Giai đoạn | Trách nhiệm chính | Đầu ra cho bước tiếp theo |
|---|---|---|
| Frontend | Hiển thị màn hình mua sắm và thu nhận hành động | HTTPS request và interaction record |
| API | Kiểm tra request và điều phối nghiệp vụ | Phản hồi sản phẩm, tài khoản, giỏ hàng và đơn hàng |
| DynamoDB | Lưu entity ứng dụng và định danh ổn định | Dữ liệu ứng dụng có thể export |
| Data Engineering | Kiểm tra interaction và bảo toàn ID nguồn | Dataset sạch và quality report |
| Recommendation | Huấn luyện và trả về product ID có thứ tự | Danh sách gợi ý đã xếp hạng |
| Monitoring | Ghi lỗi, độ trễ và tín hiệu vận hành | Log, metric và ngữ cảnh điều tra |

Luồng trình duyệt là **CloudFront → S3 frontend private → API Gateway →
application Lambda → DynamoDB hoặc Amazon Personalize**. Luồng dữ liệu bắt đầu
từ export của application/database, đi qua trang
[Pipeline Data Engineering](../5.7-DataEngineering/) riêng trước khi thành viên
ML import dataset đã được kiểm tra.

## Ranh giới bằng chứng

| Khu vực | Nội dung hiện có |
|---|---|
| Frontend | Source React/Vite, output `dist/` và ảnh giao diện |
| Cloud delivery | Ảnh S3 và CloudFront distribution đang enabled do nhóm cung cấp |
| Backend ứng dụng | Proposal và ảnh Application Lambda; source backend không có trong repository đã rà soát |
| Database | Ảnh bảng DynamoDB do nhóm cung cấp; source access pattern không có trong repository đã rà soát |
| Data Engineering | Source, tests, hạ tầng SAM và ảnh triển khai |
| Recommendation | Ảnh dataset group và solution metrics từ phía ML/nhóm |

Ảnh một component chỉ xác nhận tài nguyên đang hiển thị, không chứng minh toàn bộ
luồng đầu cuối. Vì vậy phần kiểm thử cuối Workshop ghi rõ kết quả nào đã có tài
liệu, kết quả nào được source xác nhận và kết quả nào là quy trình cần chạy.

## Phân công

Trần Uy Danh phụ trách Data Engineering: kiểm tra export, giữ nguyên định danh
ứng dụng, tạo minh chứng chất lượng và bàn giao dataset sạch cho phía ML. Frontend,
backend ứng dụng, thiết kế DynamoDB, huấn luyện Personalize và tích hợp cloud là
trách nhiệm chung của các thành viên tương ứng.

## Đầu ra của Workshop

Sau Workshop, người đọc có thể lần theo luồng từ trình duyệt tới recommendation,
xác định bằng chứng của từng lớp, thực hiện checklist kiểm tra và dọn tài nguyên
theo đúng dependency mà không biến nội dung chưa xác minh thành kết quả đã hoàn tất.
