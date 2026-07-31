---
title: "Tuần 6"
weight: 6
chapter: false
pre: " <b> 1.6 </b> "
---

#### Tuần 6 — Đồng bộ với export thực tế

**Thời gian:** 20-26/07/2026

**Trạng thái:** Hoàn thành

#### Mục tiêu

- Đồng bộ xử lý với data contract của export đã xác nhận.
- Cập nhật automated tests và tài liệu kỹ thuật.

#### Hoạt động

Tôi giới hạn xử lý ở `interactions.csv`, đọc trường `id` của `Products.json` để
validation và bỏ qua `items.csv` một cách tường minh. Pipeline giữ `USER_ID` và
`ITEM_ID` dưới dạng chuỗi, loại product không hợp lệ và exact duplicate, không
sinh surrogate ID. Tôi cập nhật bộ test và tài liệu chạy local/AWS.

#### Kết quả

- Report hiện tại: 23.377 input/clean rows, 0 rejected, 0 duplicate.
- 200 user duy nhất, 100 item duy nhất và trạng thái bảo toàn ID `PASS`.
- User ID sinh mới: 0; item ID sinh mới: 0.

#### Khó khăn

Giả định cũ về `items.csv` mâu thuẫn với export ứng dụng thật. Xem data contract
như tài liệu kỹ thuật có phiên bản giúp thay đổi này trở nên rõ ràng và có thể
kiểm thử.

#### Bước tiếp theo

Hoàn thiện source, rà soát automated tests, chuẩn bị triển khai AWS và minh chứng
báo cáo.
