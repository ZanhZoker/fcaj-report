---
title: "Pipeline Data Engineering"
weight: 7
chapter: false
pre: " <b> 5.7 </b> "
---

# Pipeline Data Engineering

Đây là phần chi tiết nhất vì pipeline là đóng góp cá nhân của tôi. Ranh giới
được giữ hẹp: kiểm tra và làm sạch interaction export theo batch, bảo toàn ID
nguồn, xuất artifact có thể audit và bàn giao clean dataset cho thành viên/nhóm
Machine Learning. Pipeline không train model, không vận hành database ứng dụng
và không xây dựng frontend.

![Kiến trúc pipeline Data Engineering](/images/5-Workshop/data-engineering-pipeline.png)

#### 1. Data contract

ZIP có thể chứa thư mục lồng nhau. File bắt buộc được tìm theo basename:

```text
export/
└── export/
    ├── interactions.csv   # được xử lý
    ├── items.csv          # nhận diện và bỏ qua
    └── Products.json      # chỉ dùng trường id
```

`interactions.csv` phải có bốn cột logic:

```csv
USER_ID,ITEM_ID,EVENT_TYPE,TIMESTAMP
```

Header được trim khoảng trắng và không phân biệt hoa/thường khi đối chiếu. Output
luôn có đúng bốn cột viết hoa theo thứ tự trên. `Products.json` phải là list hoặc
object có list `products`, mỗi product có một `id` duy nhất và không rỗng. File
nguồn không bị chỉnh sửa.

#### 2. Đọc archive an toàn

`app/archive_reader.py` đọc ZIP trong bộ nhớ. Giới hạn mặc định: file nén 50 MiB,
tổng dữ liệu giải nén 150 MiB và 100 member. Absolute path, drive-qualified path
và entry có `..` bị từ chối. Thiếu hoặc trùng basename bắt buộc làm toàn job lỗi.

```python
interactions_member = _one_member_by_basename(members, "interactions.csv")
products_member = _one_member_by_basename(members, "Products.json")
```

Archive không được extract ra thư mục filesystem, nhờ vậy không phải tin tưởng
member path trong quá trình giải nén.

#### 3. Validation và normalization từng dòng

Core trong `app/pipeline.py` kiểm tra:

- thiếu `USER_ID`, `ITEM_ID` hoặc `TIMESTAMP`;
- `ITEM_ID` không có trong lookup từ `Products.json`;
- event ngoài `view`, `add_to_cart`, `remove_from_cart`, `purchase`;
- timestamp không phải Unix integer ASCII dương;
- exact duplicate của một dòng hợp lệ đã nhận trước đó.

```python
REQUIRED_COLUMNS = ("USER_ID", "ITEM_ID", "EVENT_TYPE", "TIMESTAMP")
VALID_EVENT_TYPES = {"view", "add_to_cart", "remove_from_cart", "purchase"}
```

Event type được trim và lower-case. ID chỉ trim hai đầu; chữ hoa/thường, gạch nối,
số 0 đầu và cấu trúc nguồn được giữ nguyên. Exact duplicate hợp lệ đầu tiên được
giữ, bản sau vào rejected với lý do `DUPLICATE_ROW`. Nhiều lỗi trên một dòng được
nối bằng `|` để không che mất lý do nào.

#### 4. Bảo toàn định danh

Pipeline không tạo map, hash, UUID, index hay surrogate key cho user/item. Quality
report chứng minh output ID là tập con input ID, clean item tồn tại trong product
lookup và số ID sinh mới bằng 0.

```python
generated_user_ids = output_user_ids - input_user_ids
generated_item_ids = output_item_ids - input_item_ids
id_check["status"] = "PASS" if all(id_check.values()) else "FAIL"
```

Ràng buộc này cần thiết cho tích hợp downstream: item ID được gợi ý vẫn phải ánh
xạ đến đúng product trong ứng dụng.

#### 5. Output artifact

| Prefix/file | Mục đích |
|---|---|
| `processed/.../interactions_clean.csv` | Dataset bốn cột sẵn sàng cho ML |
| `rejected/.../interactions_rejected.csv` | Dòng sai/trùng và lý do loại |
| `reports/.../data_quality_report.json` | Bằng chứng chất lượng machine-readable |
| `reports/.../data_quality_report.md` | Báo cáo tương đương cho người đọc |

Trên AWS, mỗi artifact được ghi vào cả `run_id=<RUN_ID>/` và `latest/`. Run ID ổn
định được tạo từ identity của S3 object, nên event gửi lại ghi đè cùng run folder
thay vì tạo bản không giới hạn.

#### 6. Chạy local

`app/cli.py` gọi cùng storage-independent core mà Lambda sử dụng:

```powershell
python -m pytest -q
python -m app.cli --input .\export.zip --output .\output
```

```python
result = process_archive(args.input, source_archive=args.input.name)
write_local_outputs(result, args.output)
```

CLI in summary input, clean, rejected, duplicate, unique user/item và ID audit.
Contract lỗi trả exit code khác 0 cùng thông báo rõ ràng.

#### 7. Thực thi event-driven trên AWS

`template.yaml` tạo bucket private SSE-S3, Lambda Python 3.13 arm64, S3
ObjectCreated trigger lọc `incoming/*.zip`, policy S3 quyền tối thiểu, CloudWatch
log group giữ bảy ngày và các stack output.

```yaml
Policies:
  - AWSLambdaBasicExecutionRole
  - Statement:
      - Sid: ReadIncomingArchives
        Action: [s3:GetObject, s3:GetObjectVersion]
      - Sid: WritePipelineArtifacts
        Action: [s3:PutObject]
```

`app/lambda_handler.py` URL-decode S3 key, bỏ object ngoài phạm vi, kiểm tra size,
tải ZIP, gọi core, ghi tám S3 object (bốn theo run và bốn `latest`) rồi log summary.

```python
if not key.startswith(input_prefix):
    return {"status": "SKIPPED", "reason": "PREFIX"}
if not key.lower().endswith(".zip"):
    return {"status": "SKIPPED", "reason": "SUFFIX"}
```

README hiện tại ghi nhận đã deploy và kiểm tra tại `ap-southeast-1`. Workshop note
cũ hơn vẫn ghi deploy-ready; vì vậy ảnh AWS đã che thông tin nhạy cảm vẫn là minh
chứng bắt buộc.

#### 8. Kết quả dữ liệu local đã xác nhận

`data_quality_report.json` đã kiểm tra ghi nhận:

| Chỉ số | Kết quả |
|---|---:|
| Input / clean rows | 23.377 / 23.377 |
| Rejected / duplicate rows | 0 / 0 |
| User / item duy nhất | 200 / 100 |
| Product lookup IDs | 100 |
| `view` | 17.089 |
| `add_to_cart` | 4.382 |
| `purchase` | 1.220 |
| `remove_from_cart` | 686 |
| User/item ID sinh mới | 0 / 0 |
| Bảo toàn ID | PASS |

Đây là metric chất lượng Data Engineering. Precision, NDCG, MRR và Coverage
thuộc đánh giá model ML, không phải điểm số của pipeline.

#### 9. Automated tests

Repository ghi nhận **48 tests passed**. Phạm vi gồm an toàn/giới hạn archive,
file lồng/thiếu/trùng, UTF-8 BOM, schema, giá trị sai, product lookup, duplicate,
cột output chính xác, bảo toàn ID, run ổn định, S3 filter, URL decoding, event
nhiều record và vị trí output.

```python
def test_output_ids_are_subsets_of_input_ids():
    result = process_archive(make_zip())
    assert result.report["id_preservation_check"]["status"] == "PASS"
```

#### 10. Xác minh Athena tùy chọn

Thư mục `athena/` có SQL tạo database `ecommerce_pipeline`, external table trỏ
đến `processed/latest/` và query kiểm tra count, distribution, distinct ID, giá
trị sai, activity theo ngày và ID nguồn mẫu.

```sql
SELECT event_type, COUNT(*) AS interaction_count
FROM ecommerce_pipeline.interactions_clean
GROUP BY event_type
ORDER BY interaction_count DESC;
```

Athena không sửa CSV. Đây là lớp xác minh tùy chọn; chưa ghi nhận query đã chạy
cho đến khi có minh chứng trực tiếp.

#### 11. Bàn giao cho Machine Learning

Gói bàn giao gồm `interactions_clean.csv`, `data_quality_report.json` và
`data_quality_report.md`. Thành viên/nhóm ML phụ trách import Personalize, kiểm
tra schema ở service boundary, train, evaluate, solution version, deploy campaign
và tích hợp ứng dụng sau đó.

#### File nguồn

- [`template.yaml`](https://github.com/ZanhZoker/ecommerce-interactions-pipeline/blob/main/template.yaml)
- [`app/lambda_handler.py`](https://github.com/ZanhZoker/ecommerce-interactions-pipeline/blob/main/app/lambda_handler.py)
- [`app/pipeline.py`](https://github.com/ZanhZoker/ecommerce-interactions-pipeline/blob/main/app/pipeline.py)
- [`app/cli.py`](https://github.com/ZanhZoker/ecommerce-interactions-pipeline/blob/main/app/cli.py)
- [`tests/`](https://github.com/ZanhZoker/ecommerce-interactions-pipeline/tree/main/tests)
- [`athena/`](https://github.com/ZanhZoker/ecommerce-interactions-pipeline/tree/main/athena)


#### Minh chứng triển khai và kết quả

![Kết quả chạy local và bộ test tự động](/images/5-Workshop/data-engineering/local-run-and-tests.png)

![SAM template hợp lệ và build thành công](/images/5-Workshop/data-engineering/sam-validate-build.png)

![SAM deploy thành công](/images/5-Workshop/data-engineering/sam-deploy-success.png)

![Các prefix incoming, processed, rejected và reports trên S3](/images/5-Workshop/data-engineering/s3-pipeline-prefixes.png)

![Dataset tương tác sạch trong prefix latest](/images/5-Workshop/data-engineering/processed-clean-output.png)

![CloudWatch summary của lần chạy pipeline thành công](/images/5-Workshop/data-engineering/cloudwatch-run-summary.png)
