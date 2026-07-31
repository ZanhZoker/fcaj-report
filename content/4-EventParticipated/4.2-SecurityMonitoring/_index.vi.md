---
title: "AWS Security Agent, SLA/Monitoring và chứng chỉ Cloud"
weight: 2
chapter: false
pre: " <b> 4.2 </b> "
---

# AWS Security Agent, SLA/Monitoring và chứng chỉ Cloud

**Ngày:** 11/07/2026  
**Hình thức:** Tham dự trực tiếp tại Thành phố Hồ Chí Minh  
**Vai trò:** Người tham dự

Workshop kết nối kiểm tra bảo mật sớm, vận hành theo SLA, observability, phản ứng
sự cố và định hướng AWS Certified Cloud Practitioner. Các phần chia sẻ được
trình bày bởi anh Thinh, anh Son và anh Huy.

#### Nội dung nổi bật

- Kiến trúc, Infrastructure as Code và thay đổi source nên được kiểm tra bảo mật
  sớm trong vòng đời phát triển.
- Metric hạ tầng bình thường không đảm bảo hành trình người dùng hoạt động;
  monitoring cần quan sát cả kết quả ứng dụng và luồng nghiệp vụ.
- Alarm cần có người phụ trách, mức độ ưu tiên, hành động phản ứng và bước rút
  kinh nghiệm sau sự cố.
- Học chứng chỉ tạo khung kiến thức, nhưng không thay thế thực hành.

#### Bài học và áp dụng

Với interaction pipeline, tôi rà soát S3 public access, phạm vi IAM của Lambda,
thời gian lưu log và sự tách biệt giữa `incoming/`, `processed/`, `rejected/` và
`reports/`. CloudWatch log giải thích lần chạy, còn quality report giải thích kết
quả dữ liệu.

#### Cảm nhận cá nhân

Phần monitoring hữu ích nhất vì giúp tôi chuyển từ câu hỏi “Lambda có lỗi
không?” sang “dataset sạch và các kiểm tra chất lượng có được tạo đúng không?”.

![Ảnh tham dự workshop bảo mật và monitoring](/images/4-Events/2026-07-11-security-monitoring.jpg)

*Ảnh tham dự với màn hình monitoring trong không gian sự kiện.*
