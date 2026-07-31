---
title: "Amazon Personalize và Recommendation"
weight: 8
chapter: false
pre: " <b> 5.8 </b> "
---

# Amazon Personalize và Recommendation

Amazon Personalize là dịch vụ recommendation downstream được đề xuất. Data
Engineering cung cấp interaction CSV sạch bốn cột; thành viên/nhóm ML phụ trách
schema phía service, dataset import, solution, solution version, evaluation,
campaign và tích hợp.

#### Input bàn giao

```csv
USER_ID,ITEM_ID,EVENT_TYPE,TIMESTAMP
user-133,prod-008,view,1779328979
user-133,prod-008,add_to_cart,1779329120
user-133,prod-008,purchase,1779329340
```

Pipeline đảm bảo điều kiện schema/chất lượng nhưng không chọn Personalize recipe
và không nhận model performance. `items.csv` không thuộc contract Data
Engineering hiện tại; item dataset nếu ML cần phải được chuẩn bị và sở hữu riêng
bởi vai trò đó.

#### Workflow ML thuộc thành viên/nhóm phụ trách

1. Xác nhận `USER_ID`, `ITEM_ID` khớp định danh ứng dụng.
2. Tạo Personalize dataset group và schema.
3. Import `interactions_clean.csv` từ S3 location đã thống nhất.
4. Tạo và train solution version.
5. Xem metric recommendation và so sánh baseline đã thống nhất.
6. Chỉ tạo campaign khi cần test real-time hoặc demo.
7. Đưa item ID đã xếp hạng qua backend và giữ nguyên thứ tự.
8. Xóa resource tính phí khi không còn cần.

#### Metric và trách nhiệm

Blog/proposal được cung cấp có Precision@5, NDCG@10, MRR@25 và Coverage cho hai
dataset. Đây là kết quả đánh giá ML trong tài liệu nhóm, không phải metric Data
Engineering và không được gán cho Trần Uy Danh. Pipeline chất lượng được đánh giá
bằng row count, rejection reason, duplicate, product ID sai, bảo toàn ID và test.

#### Kiểm tra tích hợp ứng dụng

- Test nhiều user đủ điều kiện với ranked response phù hợp.
- Backend giữ nguyên thứ tự recommendation service trả về.
- Có fallback cho product lạ hoặc không còn khả dụng.
- Có fallback không cá nhân hóa cho anonymous user.
- Frontend phân biệt live recommendation với product slice tĩnh hiện tại.

<!-- TODO: Team evidence - Personalize dataset import -->
<!-- TODO: Team evidence - solution and solution version -->
<!-- TODO: Team evidence - campaign and recommendation response -->
<!-- TODO: Team evidence - ML evaluation metrics -->
