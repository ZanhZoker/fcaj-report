---
title: "Tuần 3"
weight: 3
chapter: false
pre: " <b> 1.3 </b> "
---

#### Tuần 3 — Thiết kế pipeline

**Thời gian:** 29/06-05/07/2026

**Trạng thái:** Hoàn thành

#### Mục tiêu

- Thiết kế luồng ingestion và validation.
- Xác định output sạch, bị loại và báo cáo để bàn giao cho ML.

#### Hoạt động

Tôi thiết kế batch pipeline đọc file export ZIP trong bộ nhớ, tìm file bắt buộc
dù nằm trong thư mục lồng nhau, kiểm tra từng interaction và tách dòng hợp lệ
khỏi dòng bị loại. Tôi cũng xác định các trường trong quality report và giới hạn
an toàn cho archive.

#### Kết quả

- Đề xuất các vùng `incoming/`, `processed/`, `rejected/`, `reports/`.
- Xác định quy tắc kiểm tra dòng, xử lý trùng và schema output.
- Thống nhất pipeline không được sinh định danh thay thế.

#### Khó khăn

Cấu trúc thư mục trong export có thể thay đổi. Tìm theo basename duy nhất và từ
chối path không an toàn hoặc mơ hồ giúp xử lý biến động này.

#### Bước tiếp theo

Xây dựng core pipeline, module báo cáo, CLI và automated tests.
