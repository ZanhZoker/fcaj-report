---
title: "Tuần 2"
weight: 2
chapter: false
pre: " <b> 1.2 </b> "
---

#### Tuần 2 — Phân tích hệ thống và dữ liệu

**Thời gian:** 22-28/06/2026

**Trạng thái:** Hoàn thành

#### Mục tiêu

- Làm rõ trách nhiệm frontend, backend, ML, cloud và data.
- Hiểu dữ liệu user, product và interaction phục vụ recommendation.

#### Hoạt động

Tôi phân tích proposal của nhóm và source frontend, sau đó đối chiếu luồng ứng
dụng dự kiến với dữ liệu cần bàn giao downstream. Nhu cầu tích hợp quan trọng là
dataset interaction bốn cột, trong đó định danh user và item vẫn khớp hệ thống
nguồn.

#### Kết quả

- Xác định bốn trường logic `USER_ID`, `ITEM_ID`, `EVENT_TYPE`, `TIMESTAMP`.
- Ghi nhận mã sản phẩm cần được đối chiếu với nguồn dữ liệu ứng dụng đáng tin cậy.

#### Khó khăn

Proposal mô tả nhiều thành phần cloud hơn những gì source ứng dụng hiện có xác
nhận. Tôi tách rõ ý định thiết kế và bằng chứng triển khai.

#### Bước tiếp theo

Thiết kế ingestion, validation, vùng output và hợp đồng bàn giao cho ML.
