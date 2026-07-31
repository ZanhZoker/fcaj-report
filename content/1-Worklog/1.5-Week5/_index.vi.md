---
title: "Tuần 5"
weight: 5
chapter: false
pre: " <b> 1.5 </b> "
---

#### Tuần 5 — Data contract và bàn giao ML

**Thời gian:** 13-19/07/2026

**Trạng thái:** Hoàn thành

#### Mục tiêu

- Chốt cấu trúc dataset sạch cho thành viên/nhóm ML.
- Xử lý vấn đề tương thích định danh giữa dữ liệu cũ và ứng dụng.

#### Hoạt động

Tôi rà soát các file export và làm rõ pipeline chỉ xử lý `interactions.csv`, chỉ
dùng `Products.json` để đối chiếu product ID và không dùng `items.csv`. Trao đổi
với phía ML cho thấy ID thay thế trong dataset cũ không thể liên kết an toàn về
user và product thật.

#### Kết quả

- Xác định artifact bàn giao là `interactions_clean.csv` đúng bốn cột.
- Bảo toàn `USER_ID` và `ITEM_ID` trở thành data contract có test cụ thể.
- Gói bàn giao gồm cả rejected rows và quality reports.

#### Khó khăn

Vấn đề quan trọng không chỉ là định dạng file mà là tính tương thích ngữ nghĩa.
Giữ nguyên ID nguồn tránh tình trạng CSV hợp lệ về kỹ thuật nhưng không thể tích
hợp downstream.

#### Bước tiếp theo

Điều chỉnh pipeline theo export đã xác nhận, đồng thời cập nhật test và tài liệu.
