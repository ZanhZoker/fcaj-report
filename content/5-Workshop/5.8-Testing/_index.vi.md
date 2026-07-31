---
title: "Kiểm thử End-to-End"
weight: 10
chapter: false
pre: " <b> 5.10 </b> "
---

# Kiểm thử End-to-End

Một component hoạt động riêng lẻ không chứng minh toàn hệ thống hoạt động. Kiểm
thử đầu cuối phải theo cùng identifier và expected result từ browser, frontend,
API, DynamoDB qua bước bàn giao Data Engineering tới recommendation response. Ảnh
một trang AWS chỉ là bằng chứng hỗ trợ cho component đó.

## Mục tiêu và điều kiện đầu vào

Dùng AWS profile đã xác minh ở **ap-southeast-1**, CloudFront/API URL được duyệt,
hai test user không nhạy cảm, một product ID đã biết, interaction export có kiểm
soát và quyền xem CloudWatch. Ghi timestamp để nối observation giữa các dịch vụ.

## Bước 1. Kiểm tra các lớp hạ tầng

Chạy các lệnh inventory read-only trước:

```powershell
aws sts get-caller-identity --profile <AWS-PROFILE>
aws cloudfront list-distributions --profile <AWS-PROFILE>
aws apigatewayv2 get-apis --region ap-southeast-1 --profile <AWS-PROFILE>
aws lambda get-function-configuration --function-name fcj-api --region ap-southeast-1 --profile <AWS-PROFILE>
aws dynamodb list-tables --region ap-southeast-1 --profile <AWS-PROFILE>
aws personalize list-dataset-groups --region ap-southeast-1 --profile <AWS-PROFILE>
```

Kiểm tra từng lớp mà không xem sự tồn tại của nó là bằng chứng tích hợp:

| Lớp | Cách kiểm tra |
|---|---|
| CloudFront | Distribution enabled; HTTPS domain tải build frontend hiện tại |
| Frontend S3 | Origin private có `index.html` và hashed asset mới |
| API Gateway | Stage/route đã duyệt tích hợp Application Lambda |
| Application Lambda | Runtime, role và log group khớp source owner |
| DynamoDB | Các bảng ghi nhận ACTIVE và key schema khớp ảnh nhóm |
| Data S3 và processing Lambda | Có input/output boundary theo Data Engineering |
| CloudWatch | Xem được log group application và processing |
| Amazon Personalize | Dataset group và solution version dự kiến ACTIVE |

Dừng nếu sai AWS account hoặc Region. Không dùng resource ID, URL hoặc ARN phỏng đoán.

## Bước 2. Kiểm tra bàn giao Data Engineering

Implementation, lệnh và bằng chứng chi tiết nằm tại trang
[Pipeline Data Engineering](../5.7-DataEngineering/) được giữ nguyên. End-to-End
test dùng component đó như contract thay vì viết lại.

Với một export có kiểm soát:

1. Upload export ZIP vào incoming location đã xác minh.
2. Xác nhận processing Lambda được S3 event trigger.
3. Khớp CloudWatch run identifier với object đã upload.
4. Xác nhận tạo `interactions_clean.csv` và quality report.
5. So sánh input, clean, rejected và duplicate count.
6. Xác nhận `USER_ID` và `ITEM_ID` nguồn được giữ nguyên.
7. Xác nhận mọi clean item ID tồn tại trong `Products.json` và application catalogue.
8. Bàn giao clean file/report đã duyệt cho owner ML.

Không đánh dấu handoff hoàn tất chỉ từ một S3 object; count, ID check và report
phải thuộc cùng data run.

## Bước 3. Kiểm tra Recommendation

Dùng hai user hợp lệ có history khác nhau. Gọi runtime route được nhóm duyệt hoặc
Personalize test surface và chỉ ghi identifier không nhạy cảm.

```powershell
curl "<API-URL>/<RECOMMENDATION-ROUTE>?userId=<TEST-USER-ID>"
```

Kiểm tra:

- response thành công và đúng JSON shape đã định nghĩa;
- hai user có thể nhận ranked result khác nhau khi đủ history;
- mọi item ID trả về tồn tại trong **Products**;
- duplicate/unknown ID được xử lý rõ;
- backend giữ thứ tự Personalize trả về;
- frontend render cùng thứ tự.

Ảnh dataset group và model metrics chỉ chứng minh training resource, không chứng
minh live campaign hoặc runtime call. Runtime recommendation vẫn là **Not
documented** cho tới khi thành viên phụ trách ghi nhận response.

## Bước 4. Kiểm tra luồng Browser

Dùng test session mới và ghi Network panel cùng application logs. Source frontend
đã rà soát hỗ trợ các màn hình sau, nhưng mock service phải được thay hoặc tắt
trước khi khẳng định tích hợp cloud API.

1. Mở CloudFront website đã xác minh qua HTTPS.
2. Đăng ký test account hoặc login bằng test user không nhạy cảm.
3. Duyệt catalogue và dùng category/search filter.
4. Mở product-detail route trực tiếp và từ product card.
5. Thêm sản phẩm vào cart và đổi quantity.
6. Áp dụng voucher hợp lệ nếu API triển khai voucher.
7. Checkout hoặc tạo controlled order.
8. Mở account/order history và tìm order mới.
9. Trở về home.
10. Mở personalized recommendation section.
11. Mở Developer Tools → Network.
12. Xác nhận request dùng đúng API origin, status code và response order.

![Catalogue dùng trong browser workflow](/images/5-Workshop/frontend/catalog.png)

*Màn hình catalogue có trong frontend nhóm; Network panel vẫn phải chứng minh nó
dùng API đã triển khai hay mock service local.*

![Product-detail route dùng trong browser workflow](/images/5-Workshop/frontend/product-detail.png)

*Dùng product ID đã biết để truy vết browser route, API response, database item
và recommendation result.*

## Bước 5. Kiểm tra tính nhất quán dữ liệu

Chọn một test user, product và order rồi theo cùng identifier qua từng ranh giới:

| Kiểm tra | Kết quả mong đợi |
|---|---|
| Product ID | Cùng giá trị trong DynamoDB, `Products.json`, interactions và Personalize output |
| User ID | Cùng application value trong interaction dataset và recommendation request |
| Recommendation rank | API/frontend giữ nguyên thứ tự Personalize |
| Price | Backend đọc lại product price và tính line/order total |
| Voucher | Backend kiểm tra active/expiry trước discount |
| Order | Lưu dưới authenticated user và hiện trong order history |
| Data Engineering | Không thay original application ID |

Nếu frontend mock database vẫn active, dừng claim cloud consistency: local-storage
ID là dữ liệu prototype, không chứng minh DynamoDB/Personalize integration.

## Bước 6. Kịch bản lỗi

| Tình huống | Hành vi mong đợi | Nơi điều tra |
|---|---|---|
| API unavailable | Frontend hiển thị error/retry có kiểm soát | Browser Network, API Gateway và Lambda logs |
| CORS failure | Preflight bị từ chối rõ; sửa production origin policy | Browser console và API CORS config |
| CloudFront cache cũ | Invalidation làm build mới xuất hiện | Distribution invalidation và asset hash |
| React route trả 403/404 | SPA fallback trả `index.html` | CloudFront custom errors và S3 origin |
| Malformed ZIP | Processing fail an toàn với run error rõ | Processing Lambda logs và report boundary |
| Thiếu `interactions.csv` | Run fail, không publish clean dataset gây hiểu nhầm | Data Engineering logs |
| `ITEM_ID` không tồn tại | Row bị reject và được đếm | Quality report |
| Lambda timeout | Invocation fail rõ, duration gần timeout | CloudWatch duration/error metrics |
| Personalize campaign chưa ACTIVE | API trả fallback có kiểm soát | Application logs và Personalize status |

## Checklist End-to-End cuối cùng

| Hạng mục | Kết quả mong đợi | Trạng thái hoặc bằng chứng |
|---|---|---|
| CloudFront loads | HTTPS trả build hiện tại | Có ảnh distribution; chưa có live response |
| Frontend assets | JavaScript, CSS và ảnh không lỗi | Có ảnh giao diện và source `dist/` |
| Product API | Trả product JSON cho ID đã biết | Not documented |
| Authentication | Login hợp lệ thành công, session sai bị từ chối | Chỉ có source prototype; cloud result chưa có |
| Cart | Add/update/remove lưu đúng user | Chỉ có source prototype; cloud result chưa có |
| Checkout | Server tính và lưu controlled order | Có ảnh code Lambda; runtime đầy đủ chưa có |
| Order history | Order mới hiện cho cùng user | Not documented |
| Data Engineering trigger | Controlled upload invoke processing | Có trong trang Data Engineering |
| Clean dataset | Clean output và quality report cùng run | Có trong trang Data Engineering |
| ID preservation | User/item ID nguồn không đổi | Có trong trang Data Engineering |
| Personalize recommendation | Runtime trả ranked ID | Có training evidence; runtime chưa có |
| Recommendation order | API/frontend giữ model order | Not documented |
| CloudWatch logs | Correlate request/run và không lộ secret | Có evidence component; full correlation chưa có |

## Kết quả và kết luận nhóm

Bằng chứng hiện có hỗ trợ prototype React/Vite, ảnh component triển khai, handoff
Data Engineering, tài nguyên training Personalize và monitoring alarms. Chưa có
bằng chứng cho một lần chạy browser-to-recommendation hoàn chỉnh. Nhóm nên hoàn
thành các dòng **Not documented** bằng một test run có timestamp trước khi trình
bày project đã tích hợp toàn bộ. Vai trò đã xác minh của Trần Uy Danh vẫn là ranh
giới Data Engineering trong hệ thống chung đó.
