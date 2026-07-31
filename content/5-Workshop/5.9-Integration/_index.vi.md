---
title: "Tích hợp hệ thống và bàn giao dữ liệu"
draft: true
weight: 9
chapter: false
pre: " <b> 5.9 </b> "
---


Luồng mục tiêu hoàn chỉnh đi qua bốn ranh giới trách nhiệm:

```text
Export ứng dụng/database
        ↓
Data Engineering validation và làm sạch
        ↓
interactions_clean.csv + quality reports
        ↓
Machine Learning import/train/evaluate
        ↓
Amazon Personalize campaign
        ↓
Backend API lookup product và giữ thứ tự
        ↓
Khối recommendation trên frontend
```

#### Contract qua ranh giới

| Ranh giới | Input | Output | Owner |
|---|---|---|---|
| Application → Data | Export ZIP | `interactions.csv`, `Products.json`, `items.csv` bị bỏ qua | Phối hợp application/data |
| Data pipeline | Các file export | Clean, rejected, JSON/Markdown report | Trần Uy Danh |
| Data → ML | Clean CSV + report | Artifact được chấp nhận để import | Data + ML ký nhận |
| ML → Backend | User ID | Item ID gợi ý có thứ tự | ML + backend |
| Backend → Frontend | Recommended product object | Khối gợi ý đã render | Backend + frontend |

#### Tiêu chí chấp nhận bàn giao

- Output có đúng `USER_ID,ITEM_ID,EVENT_TYPE,TIMESTAMP`.
- Output ID là tập con input ID.
- Mọi clean item tồn tại trong `Products.json`.
- Rejected/duplicate count khớp với input và clean count.
- Quality report và clean CSV đến từ cùng run.
- Thành viên/nhóm ML ghi lại run ID và object đã import.
- Backend lookup giữ nguyên thứ tự recommendation.

#### Trạng thái hiện tại

Phía Data Engineering của handoff đã có source và report local xác nhận. Frontend
hiện có là prototype mock data. ML import, application API, live product lookup
và browser response vẫn cần source hoặc bằng chứng triển khai từ nhóm.
