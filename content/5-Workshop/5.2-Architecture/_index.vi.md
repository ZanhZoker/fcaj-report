---
title: "Kiến trúc tổng thể"
weight: 2
chapter: false
pre: " <b> 5.2 </b> "
---

# Kiến trúc tổng thể

![Kiến trúc tổng thể của nhóm](/images/5-Workshop/architecture.png)

Sơ đồ thể hiện kiến trúc mục tiêu của nhóm. Cần đọc cùng ma trận bằng chứng bên
dưới; một biểu tượng kiến trúc không tự chứng minh resource đã được deploy.

#### Luồng ứng dụng

1. Người dùng mở website HTTPS qua CloudFront.
2. CloudFront phục vụ bản build React/Vite từ S3 origin.
3. Request trình duyệt đi qua API Gateway đến application Lambda.
4. Dữ liệu ứng dụng được đọc/ghi ở DynamoDB.
5. Backend có thể lấy item ID đã xếp hạng từ Personalize campaign, ánh xạ về
   product data rồi trả response.

#### Luồng dữ liệu và recommendation

1. File export ZIP từ ứng dụng/database được upload vào `incoming/` trên S3.
2. S3 ObjectCreated event gọi data-processing Lambda Python.
3. Function ghi clean, rejected và quality-report artifact.
4. `interactions_clean.csv` được bàn giao cho thành viên/nhóm ML.
5. Thành viên/nhóm ML phụ trách import Personalize, train solution, evaluate,
   deploy campaign và tích hợp ứng dụng.

#### Kiểm soát vận hành dùng chung

- CloudWatch Logs ghi summary thực thi Lambda Data Engineering.
- SAM/CloudFormation quản lý S3 bucket, function, trigger, IAM policy, log group
  và output của Data Engineering.
- IAM role phải theo quyền tối thiểu; source không chứa credential.
- CloudFront OAC, bảo mật ứng dụng và monitoring ứng dụng cần source/ảnh từ nhóm
  trước khi đánh dấu hoàn thành.

<!-- TODO: Team evidence - final overall architecture approved by all roles -->
