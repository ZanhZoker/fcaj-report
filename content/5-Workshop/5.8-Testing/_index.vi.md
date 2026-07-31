---
title: "Kiểm thử và validation"
weight: 10
chapter: false
pre: " <b> 5.10 </b> "
---

# Kiểm thử và validation

Testing được chia theo owner để kết quả Data Engineering đã xác minh không bị
nhầm thành kết quả toàn hệ thống chưa có bằng chứng.

## Kiểm thử cấp nhóm

| Phần | Kiểm thử cần có | Trạng thái hiện tại |
|---|---|---|
| Frontend | Build, routing, catalog, search, cart, checkout, account | Có source; chờ bằng chứng chạy |
| Backend/API | Auth, validation, product/cart/order, CORS, error | Chờ source và bằng chứng chạy |
| Database | Key, access pattern, ownership, nhất quán order | Chờ source và bằng chứng |
| Recommendation | Import, model metric, khác biệt user, giữ thứ tự | Chờ bằng chứng nhóm |
| Visual search | Ảnh input, embedding/cache, kết quả similarity | Chờ bằng chứng triển khai |
| Integration | Export → clean data → ML → API → frontend | Chờ bằng chứng đầu cuối |

Không đánh dấu một dòng hoàn thành chỉ từ ảnh một component. Kết quả integration
hợp lệ phải nêu input, expected output, actual output và cùng định danh qua từng
ranh giới.

## Kiểm thử Data Engineering

Repository ghi nhận **48 tests passed**. Hành vi đã kiểm tra gồm:

- xử lý ZIP sai, path traversal, giới hạn size/member an toàn;
- file bắt buộc thiếu/mơ hồ và product ID trùng;
- required columns, UTF-8 BOM và normalize header;
- missing value, event type và timestamp sai;
- product ID lạ và exact duplicate;
- bảo toàn chữ hoa/thường, gạch nối, số 0 đầu và ID nguồn;
- local run ID và clean output ổn định;
- S3 prefix/suffix filter, key URL-decoded và Lambda event nhiều record;
- xuất output theo run và `latest/`.

```powershell
python -m pytest -q
python -m app.cli --input .\export.zip --output .\output
```

Quality report hiện tại đối chiếu 23.377 input rows với 23.377 clean rows, 0
rejected và 0 duplicate. Việc input này không có rejected không làm mất nhánh
xử lý lỗi; bộ test đã kiểm tra các tình huống đó.

## Xác minh output

1. So sánh input, clean, rejected và duplicate count.
2. Xác nhận user/item ID sinh mới bằng 0.
3. Xác nhận clean header và hình dạng ID nguồn mẫu.
4. Kiểm tra rejection reason bằng archive test sai có kiểm soát.
5. Trên AWS, khớp S3 artifact với CloudWatch summary theo run ID.
6. Nếu dùng Athena, đối chiếu count với JSON report.

<!-- TODO: Team evidence - frontend and checkout tests -->
<!-- TODO: Team evidence - backend API tests -->
<!-- TODO: Team evidence - recommendation and integration tests -->
<!-- TODO: Personal evidence - automated test result and output verification -->
