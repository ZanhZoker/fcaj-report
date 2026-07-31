---
title: "Tuần 4"
weight: 4
chapter: false
pre: " <b> 1.4 </b> "
---

#### Tuần 4 — Xây dựng ban đầu và báo cáo chất lượng

**Thời gian:** 06-12/07/2026

**Trạng thái:** Hoàn thành

#### Mục tiêu

- Xây dựng pipeline đầu tiên và schema validation.
- Tạo output chất lượng dữ liệu có thể kiểm tra lại.

#### Hoạt động

Tôi xây dựng archive reader, core validation, CLI chạy local và module tạo báo
cáo. Bộ test bao phủ archive lỗi, thiếu file bắt buộc, path không an toàn, dữ
liệu thiếu, event/timestamp sai, product không tồn tại, duplicate và bảo toàn ID.
Tôi trao đổi với nhóm về input/output mong đợi.

#### Kết quả

- Pipeline local tạo clean CSV, rejected CSV, JSON report và Markdown report.
- Lỗi cấp dòng được giữ lại cùng mã lý do chuẩn.
- Lỗi data contract cấp archive làm job dừng an toàn.

#### Khó khăn

Validation phải bảo vệ khâu bàn giao nhưng không âm thầm đổi dữ liệu nguồn. Vì
vậy ID chỉ được trim khoảng trắng hai đầu, giữ nguyên chữ hoa/thường và cấu trúc.

#### Bước tiếp theo

Xác nhận artifact bàn giao ML và đối chiếu giả định pipeline với export ứng dụng
hiện tại.
