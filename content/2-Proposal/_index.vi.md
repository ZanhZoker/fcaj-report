---
title: "Đề xuất"
weight: 2
chapter: false
pre: " <b> 2. </b> "
---

# Hệ thống thương mại điện tử tích hợp gợi ý và tìm kiếm hình ảnh trên AWS

## 1. Tóm tắt điều hành

Project nhóm đề xuất nền tảng thương mại điện tử có duyệt sản phẩm, tài khoản,
giỏ hàng, thanh toán, gợi ý và tìm kiếm bằng hình ảnh. Kiến trúc AWS mục tiêu sử
dụng frontend React/Vite, Amazon S3 và CloudFront để phân phối, API Gateway và
application Lambda cho nghiệp vụ, DynamoDB cho dữ liệu ứng dụng và Amazon
Personalize cho recommendation. Proposal cũng mô tả visual search dựa trên CLIP.

Bằng chứng triển khai giữa các thành phần chưa đồng đều. Repository nhóm hiện có
xác nhận prototype React/Vite chạy với mock data trong trình duyệt. Repository
Data Engineering xác nhận pipeline Python riêng, automated tests, quality report
và hạ tầng AWS SAM. Backend ứng dụng, DynamoDB, Personalize, CLIP và triển khai
toàn hệ thống vẫn cần source hoặc ảnh từ thành viên phụ trách trước khi ghi là đã
hoàn thành.

## 2. Tuyên bố vấn đề

Một hệ thống e-commerce phải hỗ trợ luồng mua sắm thông thường, đồng thời giúp
người dùng tìm sản phẩm phù hợp. Giai đoạn recommendation phụ thuộc vào dữ liệu
interaction còn hợp lệ qua các ranh giới hệ thống. Nếu định danh user hoặc
product bị thay thế khi chuẩn bị dữ liệu, output của model không thể liên kết an
toàn về catalog ứng dụng.

Project vì vậy giải quyết hai bài toán liên kết: xây dựng trải nghiệm mua sắm đầu
cuối và thiết lập quy trình bàn giao dữ liệu đáng tin cậy từ export ứng dụng sang
workflow Machine Learning.

## 3. Giải pháp đề xuất

Giải pháp mục tiêu gồm bốn lớp phối hợp:

1. Ứng dụng React/Vite cho catalog, search, account, cart, checkout, seller,
   notification và administration.
2. Lớp ứng dụng serverless được đề xuất với API Gateway, Lambda và DynamoDB.
3. Pipeline Data Engineering đã có source dùng S3, Lambda, CloudWatch Logs và
   SAM/CloudFormation để tạo dataset interaction sẵn sàng cho ML.
4. Lớp ML được đề xuất với Amazon Personalize và visual search CLIP, tích hợp
   ngược vào ứng dụng qua backend API.

## 4. Lợi ích

- **Khám phá sản phẩm:** recommendation và visual search giúp vượt giới hạn tìm
  kiếm từ khóa cơ bản.
- **Rõ trách nhiệm:** contract giữa các thành phần cho phép frontend, backend,
  data, cloud và ML phối hợp ở các điểm bàn giao cụ thể.
- **Vận hành serverless:** managed services giảm nhu cầu quản lý server thường
  trực, phù hợp lưu lượng thấp hoặc không đều.
- **Chất lượng dữ liệu kiểm tra được:** clean, rejected và report artifact cho
  phép audit từng batch trước khi đưa vào ML.
- **Giữ liên kết nguồn:** bảo toàn ID giúp kết quả gợi ý ánh xạ về đúng user và
  product trong ứng dụng.

## 5. Kiến trúc tổng thể

![Kiến trúc mục tiêu của nhóm](/images/5-Workshop/team-architecture-2026.jpg)

Hình trên là kiến trúc tham chiếu của nhóm, không phải bằng chứng triển khai.
Luồng ứng dụng dự kiến:

```text
Người dùng → CloudFront → S3 frontend → API Gateway → application Lambda
           → DynamoDB / Amazon Personalize → phản hồi gợi ý
```

Luồng Data Engineering:

```text
Database export ZIP → S3 incoming/ → data-processing Lambda
→ processed/ + rejected/ + reports/ → interactions_clean.csv
→ Machine Learning / Amazon Personalize downstream
```

## 6. Dịch vụ AWS và công nghệ

| Thành phần | Mục đích | Trạng thái bằng chứng |
|---|---|---|
| React, Vite, Redux Toolkit | Trải nghiệm web của nhóm | Có trong source frontend |
| Mock API và local storage | Lớp dữ liệu prototype hiện tại | Có trong source frontend |
| S3 và CloudFront | Static hosting và HTTPS mục tiêu | Có ảnh CloudFront enabled; cấu hình S3 origin private cần được kiểm tra |
| API Gateway và application Lambda | API serverless và nghiệp vụ mục tiêu | Có ảnh Application Lambda; source triển khai không nằm trong các repository đã rà soát |
| DynamoDB | Kho dữ liệu ứng dụng mục tiêu | Có ảnh tám bảng active on-demand và key layout; source triển khai không nằm trong các repository đã rà soát |
| S3 và data-processing Lambda | Input/output và compute cho pipeline | Có trong source Data Engineering |
| CloudWatch Logs | Log thực thi pipeline | Có trong SAM template và trạng thái repository |
| SAM/CloudFormation | Infrastructure as Code cho pipeline | Có trong `template.yaml` |
| Athena | Xác minh clean CSV tùy chọn | Đã có SQL; báo cáo không khẳng định đã chạy query |
| Amazon Personalize | Train và phục vụ recommendation của nhóm | Có ảnh triển khai và model metrics trong Workshop 5.8 |
| CLIP | Ý tưởng visual search của nhóm | Proposal; frontend hiện có chưa triển khai |

## 7. Thiết kế thành phần

### Frontend

Source dùng React với Vite, React Router, Redux Toolkit và các UI component tái
sử dụng. Route bao gồm home, product detail, category, text search, cart,
checkout, account, seller, notification và admin. Khối gợi ý trên homepage hiện
lấy lát cắt sản phẩm tĩnh; đây chưa phải bằng chứng tích hợp Personalize thật.

### Backend và dữ liệu ứng dụng

Proposal giao cho application Lambda phía sau API Gateway việc xác thực, xử lý
nghiệp vụ, order, gọi recommendation và truy cập database. Tám bảng DynamoDB
được liệt kê là **Products**, **Categories**, **Users**, **Sessions**, **Carts**,
**Vouchers**, **Reviews**, **Orders**. Báo cáo giữ đây là thiết kế nhóm nhưng vẫn cần
source backend/database hoặc bằng chứng triển khai.

### Recommendation và visual search

Thành viên/nhóm ML phụ trách dataset import, train solution, evaluation, deploy
campaign và tích hợp. Proposal và blog mô tả Amazon Personalize cùng CLIP với
cosine similarity. Các trách nhiệm này tách biệt với pipeline Data Engineering.

### Data Engineering

Pipeline đọc `interactions.csv` và product ID từ `Products.json` trong export
ZIP. Pipeline nhận diện nhưng bỏ qua `items.csv`, kiểm tra schema và từng dòng,
loại exact duplicate, giữ nguyên ID, rồi tạo clean, rejected, JSON report và
Markdown report.

## 8. Phân công nhóm

| Vai trò | Trách nhiệm |
|---|---|
| Thành viên/nhóm Frontend | Giao diện React/Vite và luồng trình duyệt |
| Thành viên/nhóm Backend | API ứng dụng, xác thực và nghiệp vụ |
| Thành viên/nhóm Machine Learning | Train/evaluate/deploy Personalize và phần CLIP |
| Thành viên/nhóm Cloud/Architecture | Kiến trúc AWS chung, triển khai, IAM và tích hợp |
| Data Engineering — Trần Uy Danh | Ingestion, validation, quality report, batch pipeline AWS và bàn giao dữ liệu ML |

## 9. Đóng góp cá nhân

Đóng góp cá nhân của tôi là thành phần Data Engineering, bao gồm:

- kiểm tra ZIP an toàn trong bộ nhớ với giới hạn kích thước nén/giải nén và số file;
- tìm duy nhất một `interactions.csv` và một `Products.json` theo basename;
- nhận diện và loại `items.csv` khỏi xử lý;
- validation schema, missing value, event type, Unix timestamp dương, duplicate
  và product ID;
- bảo toàn `USER_ID`, `ITEM_ID`, không tạo mapping hay surrogate ID;
- sinh `interactions_clean.csv`, `interactions_rejected.csv`, JSON report và
  Markdown report tương đương;
- chạy bằng CLI local và Lambda adapter nhận S3 event;
- S3 private có SSE-S3, trigger có filter, policy tối thiểu và log retention qua
  AWS SAM/CloudFormation;
- automated tests và SQL xác minh Athena tùy chọn;
- bàn giao clean dataset và report cho thành viên/nhóm ML.

Tôi không nhận frontend, backend ứng dụng, thiết kế DynamoDB, model Personalize
hay CLIP của nhóm là công việc cá nhân.

## 10. Triển khai kỹ thuật

SAM template giới hạn Lambda chỉ đọc `incoming/*` và chỉ ghi ba prefix output:

```yaml
Events:
  IncomingZipCreated:
    Type: S3
    Properties:
      Events: s3:ObjectCreated:*
      Filter:
        S3Key:
          Rules:
            - { Name: prefix, Value: incoming/ }
            - { Name: suffix, Value: .zip }
```

Core chỉ chấp nhận bốn event type và giữ schema output cố định:

```python
REQUIRED_COLUMNS = ("USER_ID", "ITEM_ID", "EVENT_TYPE", "TIMESTAMP")
VALID_EVENT_TYPES = {"view", "add_to_cart", "remove_from_cart", "purchase"}
```

Lambda ghi cả thư mục theo run ID và bản thuận tiện trong `latest/`. File đầy đủ
được liên kết ở [Tài liệu tham khảo](../8-References/) thay vì sao chép vào báo cáo.

## 11. Lộ trình và mốc triển khai

| Thời gian | Mốc | Trạng thái |
|---|---|---|
| 15-28/06 | Onboarding, phân tích project, vai trò và yêu cầu dữ liệu | Hoàn thành |
| 29/06-12/07 | Thiết kế data contract/pipeline và source ban đầu | Hoàn thành |
| 13-26/07 | Làm rõ bàn giao ML, đồng bộ export thật, test/docs | Hoàn thành |
| 27/07-02/08 | Hoàn thiện source, xác minh AWS, báo cáo Hugo | Đang thực hiện |
| 03-09/08 | Minh chứng nhóm/cá nhân và workshop song ngữ | Kế hoạch |
| 10-14/08 | Event, rà soát cuối, cleanup và nộp bài | Kế hoạch |

## 12. Luồng dữ liệu và tích hợp

1. Ứng dụng/database cung cấp file export ZIP.
2. Data Engineering đọc `interactions.csv` và lookup product ID từ
   `Products.json`; `items.csv` bị bỏ qua theo contract.
3. Dòng sai vào rejected output; dòng hợp lệ giữ nguyên ID nguồn.
4. `interactions_clean.csv` và quality report là gói bàn giao ML chính thức.
5. Thành viên/nhóm ML chịu trách nhiệm import, train, evaluate và campaign.
6. Backend được đề xuất ánh xạ item ID gợi ý về product ứng dụng và trả danh sách
   xếp hạng cho frontend.

Luồng này giữ join key quan trọng giữa dữ liệu ứng dụng nguồn và recommendation
output downstream.

## 13. Kiểm thử và đánh giá

### Bằng chứng Data Engineering

Repository ghi nhận **48 automated tests passed**. Export local đã kiểm tra cho
kết quả:

| Chỉ số | Kết quả |
|---|---:|
| Input rows | 23.377 |
| Clean rows | 23.377 |
| Rejected rows | 0 |
| Exact duplicates | 0 |
| User duy nhất | 200 |
| Item duy nhất | 100 |
| User/item ID sinh mới | 0 / 0 |
| Bảo toàn ID | PASS |

Bộ test bao phủ ZIP không an toàn hoặc malformed, thiếu file/cột, event và
timestamp sai, thiếu ID, product lạ, duplicate, run ổn định, S3 event filtering,
Lambda nhiều record và bảo toàn ID.

### Đánh giá project nhóm và ML

Blog/proposal được cung cấp ghi nhận Precision, NDCG, MRR và Coverage cho hai
dataset Personalize. Đây là metric model recommendation thuộc phần ML của nhóm,
không phải metric pipeline Data Engineering của tôi. Ảnh dataset group và
solution metrics xác nhận tài nguyên tương ứng; báo cáo không suy rộng các ảnh
component này thành kết quả kiểm thử tích hợp đầu cuối.

## 14. Ước tính ngân sách

Bảng dưới là **ước tính từ proposal**, không phải hóa đơn hoặc billing thực tế.
Giả định môi trường demo lưu lượng thấp; con số có thể thay đổi theo Region,
thời gian hoạt động và bảng giá hiện hành.

| Dịch vụ | Giả định trong proposal | Chi phí ước tính (USD/tháng) |
|---|---|---:|
| Lambda | Khoảng 1M lượt gọi, 512 MB, 200 ms trung bình | $0,20-$1,00 |
| API Gateway HTTP API | Khoảng 1M request | Khoảng $1,00 |
| DynamoDB on-demand | Tám bảng, khoảng 1M read/write units | $5-$10 |
| S3 | Khoảng 5 GB và request | Khoảng $0,15 |
| CloudFront | Khoảng 50 GB truyền ra | Khoảng $4,25 |
| Personalize campaign | Một campaign chạy liên tục ở minimum TPS | $150-$220 |
| Personalize training | Khoảng 2-4 giờ mỗi lần | $0,50-$1,00/lần |
| CloudWatch | Log/monitoring cơ bản | Khoảng $1,00 |
| **Tổng theo proposal** | Giả định campaign chạy liên tục | **Khoảng $160-$240/tháng** |

Pipeline Data Engineering hoạt động theo event và không tạo EC2, RDS, NAT
Gateway, OpenSearch hoặc SageMaker. SAM template giữ log trong bảy ngày.

## 15. Rủi ro và giảm thiểu

| Rủi ro | Cách giảm thiểu |
|---|---|
| Source lệch kiến trúc mục tiêu | Duy trì ma trận bằng chứng và contract có phiên bản |
| User/product ID không còn khớp | Giữ ID nguồn và test điều kiện subset/lookup |
| Archive sai hoặc không an toàn | Giới hạn size/member/path và dừng job |
| Chất lượng interaction kém | Xuất báo cáo row/rejection/distribution trước ML import |
| Chi phí Personalize khi idle | Chỉ tạo campaign trong cửa sổ test/demo cần thiết và cleanup |
| Lộ secret hoặc dữ liệu người dùng | Dùng role/biến môi trường; rà soát ảnh và repository |
| Frontend/backend lệch contract | Thống nhất request/response và data contract trước tích hợp |
| Giới hạn xử lý trong bộ nhớ | Giữ giới hạn rõ; chỉ chuyển streaming/columnar khi quy mô yêu cầu |

## 16. Kết quả kỳ vọng

- Thiết kế project nhóm có thể truy vết cho toàn luồng e-commerce/recommendation.
- Prototype React/Vite sử dụng được trong khi tích hợp cloud được xác minh.
- Pipeline Data Engineering có test và gói interaction bàn giao ML.
- Ranh giới trách nhiệm rõ giữa application, data, cloud và ML.
- Báo cáo dựa trên bằng chứng, không nhầm kiến trúc mục tiêu với triển khai xong.

## 17. Sản phẩm bàn giao

| Sản phẩm | Trạng thái |
|---|---|
| Website báo cáo Hugo song ngữ | Đã hợp nhất nội dung Workshop và Event |
| Source frontend nhóm | Có sẵn |
| Source, README và kiến trúc Data Engineering | Có sẵn |
| `template.yaml` và Lambda pipeline | Có sẵn |
| Automated tests và quality report local | Có sẵn |
| SQL Athena | Có sẵn; chưa có minh chứng chạy tùy chọn |
| Data contract bàn giao clean dataset | Có sẵn |
| Source backend/database/Personalize/CLIP của nhóm | Không có trong các repository đã rà soát; ảnh component được ghi nhãn riêng |
| Ảnh triển khai nhóm và cá nhân | Có cho các component được trình bày |
| Minh chứng Event | Có cho cả ba buổi được trình bày |
