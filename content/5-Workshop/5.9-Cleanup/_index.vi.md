---
title: "Dọn dẹp tài nguyên"
weight: 11
chapter: false
pre: " <b> 5.11 </b> "
---

# Dọn dẹp tài nguyên

**Cảnh báo thao tác phá hủy:** Personalize có thể tiếp tục phát sinh chi phí,
CloudFront phải disable trước khi delete, S3 bucket phải empty và thứ tự dependency
rất quan trọng. Xác nhận AWS account, **ap-southeast-1**, profile và đúng resource
trước mỗi lệnh. Các lệnh dưới đây chỉ là quy trình; không lệnh cleanup nào được
chạy khi chuẩn bị báo cáo.

## Trước khi xóa bất kỳ tài nguyên nào

1. Xác nhận profile, account và Region.
2. Export hoặc chụp minh chứng không nhạy cảm cần cho báo cáo thực tập.
3. Tải quality report và test summary đã duyệt.
4. Chỉ ghi resource identifier cần cho người cleanup; không công khai.
5. Xác nhận resource nào dùng chung với project khác.
6. Dừng test đang chạy và nhận xác nhận của owner từng component.

```powershell
aws sts get-caller-identity --profile <AWS-PROFILE>
aws configure get region --profile <AWS-PROFILE>
aws resourcegroupstaggingapi get-resources `
  --region ap-southeast-1 `
  --profile <AWS-PROFILE>
```

Không tiếp tục nếu account/Region khác inventory project.

## Bước 1. Xóa Personalize Campaign

Campaign có thể là nguồn chi phí tiếp diễn lớn nhất và nên xử lý trước khi tồn tại.
Báo cáo có training evidence nhưng không có ảnh campaign, nên operator phải xác
minh ARN thuộc đúng project.

```powershell
aws personalize delete-campaign `
  --campaign-arn <VERIFIED-CAMPAIGN-ARN> `
  --region ap-southeast-1 `
  --profile <AWS-PROFILE>
```

Chờ campaign biến mất trước khi xóa solution phụ thuộc.

## Bước 2. Xóa Solution và Dataset Resources

Xóa solution đã xác minh khi không còn campaign phụ thuộc. Sau đó xóa Interactions
dataset, dataset group và project-only schema theo dependency mà Personalize
console hiển thị. Import job là historical state; làm theo service dependency
message hiện tại thay vì đoán thứ tự.

```powershell
aws personalize delete-solution `
  --solution-arn <VERIFIED-SOLUTION-ARN> `
  --region ap-southeast-1 `
  --profile <AWS-PROFILE>

aws personalize delete-dataset `
  --dataset-arn <VERIFIED-DATASET-ARN> `
  --region ap-southeast-1 `
  --profile <AWS-PROFILE>

aws personalize delete-dataset-group `
  --dataset-group-arn <VERIFIED-DATASET-GROUP-ARN> `
  --region ap-southeast-1 `
  --profile <AWS-PROFILE>
```

Không xóa schema hoặc role đang dùng chung với dataset group khác.

## Bước 3. Disable và xóa CloudFront

1. Mở đúng distribution đã xác minh.
2. Lưu configuration chỉ khi nhóm cần recovery evidence.
3. Disable distribution và chờ status trở lại **Deployed**.
4. Xác nhận alternate domain không phục vụ project khác.
5. Xóa distribution bằng ETag hiện tại.

CloudFront không thể bị xóa khi còn enabled hoặc configuration update đang deploy.
Chỉ xóa OAC khi không distribution nào khác sử dụng.

## Bước 4. Empty và xóa S3 Buckets

Inventory riêng từng bucket: frontend build, ML import, Data Engineering data và
Athena results nếu đã dùng Athena. Bucket bật versioning cần xóa cả object version
và delete marker.

```powershell
aws s3 ls s3://<VERIFIED-BUCKET>/ --recursive --profile <AWS-PROFILE>

# Phá hủy: chỉ chạy sau khi xác nhận bucket và evidence cần giữ.
aws s3 rm s3://<VERIFIED-BUCKET>/ --recursive --profile <AWS-PROFILE>

aws s3api delete-bucket `
  --bucket <VERIFIED-BUCKET> `
  --region ap-southeast-1 `
  --profile <AWS-PROFILE>
```

Không thay `<VERIFIED-BUCKET>` bằng tên phỏng đoán.

## Bước 5. Xóa API Gateway và Application Lambda

Xác nhận API ID/function thuộc application stack và không dùng chung. Nếu có
CloudFormation stack owner, ưu tiên xóa qua stack để integration/permission được
gỡ cùng nhau.

```powershell
aws apigatewayv2 delete-api `
  --api-id <VERIFIED-API-ID> `
  --region ap-southeast-1 `
  --profile <AWS-PROFILE>

aws lambda delete-function `
  --function-name fcj-api `
  --region ap-southeast-1 `
  --profile <AWS-PROFILE>
```

Xóa API trước để nó không invoke function đang được gỡ.

## Bước 6. Xóa DynamoDB Tables

Export record không nhạy cảm cần giữ, xác nhận từng bảng thuộc project rồi chỉ xóa
tám bảng trong ảnh môi trường nhóm: **Products, Categories, Users, Sessions,
Carts, Vouchers, Reviews, Orders**.

```powershell
$projectTables = @('Products','Categories','Users','Sessions','Carts','Vouchers','Reviews','Orders')
foreach ($tableName in $projectTables) {
  aws dynamodb delete-table `
    --table-name $tableName `
    --region ap-southeast-1 `
    --profile <AWS-PROFILE>
}
```

Loop này có tính phá hủy. Kiểm tra account và list đã resolve trước khi chạy.

## Bước 7. Xóa Data Engineering Stack

Đây chỉ là hướng dẫn cleanup; trang Workshop Data Engineering và asset của nó
không bị thay đổi. Source dùng AWS SAM/CloudFormation, vì vậy stack đã xác minh
nên được xóa qua SAM sau khi tải artifact cần giữ và xử lý S3 object cản trở.

```powershell
sam delete `
  --stack-name <VERIFIED-DATA-PIPELINE-STACK> `
  --region ap-southeast-1 `
  --profile <AWS-PROFILE>
```

Xác nhận processing Lambda, role, event notification và log group của stack đã
được xóa. Không xóa Application Lambda cùng stack này trừ khi template owner
thực sự chứa resource đó.

## Bước 8. Xóa IAM và CloudWatch Resources

Chỉ xóa role/policy dành riêng cho resource project đã gỡ và sau khi mọi service
ngừng sử dụng. Ảnh nhóm cho thấy alarm **fcj-lambda-latency** và
**fcj-lambda-errors**; xác nhận chúng vẫn thuộc application trước khi xóa.

```powershell
aws cloudwatch delete-alarms `
  --alarm-names fcj-lambda-latency fcj-lambda-errors `
  --region ap-southeast-1 `
  --profile <AWS-PROFILE>

aws logs delete-log-group `
  --log-group-name <VERIFIED-LOG-GROUP> `
  --region ap-southeast-1 `
  --profile <AWS-PROFILE>
```

## Bước 9. Rà soát chi phí cuối cùng

Kiểm tra Billing và Cost Explorer sau cleanup, lưu ý có độ trễ báo cáo. Inventory
S3, Lambda, DynamoDB, Personalize, CloudFront, CloudWatch, CloudFormation và API
Gateway ở **ap-southeast-1** cùng Region khác nhóm từng dùng. Rà unattached IAM
policy, log group, S3 version và CloudFront/OAC còn sót.

## Checklist Cleanup

| Tài nguyên | Thao tác bắt buộc | Đã xác minh |
|---|---|---|
| Personalize campaign | Xóa trước nếu tồn tại | ☐ |
| Personalize solution/datasets/group | Xóa theo dependency | ☐ |
| CloudFront distribution | Disable, chờ Deployed rồi delete | ☐ |
| Frontend/ML/data/Athena S3 | Giữ evidence, empty version rồi delete | ☐ |
| API Gateway | Xóa application API đã xác minh | ☐ |
| Application Lambda | Xóa function hoặc owning stack | ☐ |
| DynamoDB tables | Export dữ liệu cần giữ và xóa bảng project | ☐ |
| Data Engineering stack | Xóa qua SAM sau khi rà bucket | ☐ |
| IAM policy/role | Chỉ xóa resource dành riêng cho project | ☐ |
| CloudWatch alarm/log group | Xóa sau khi lưu evidence | ☐ |
| Billing/Cost Explorer | Xác nhận không còn phí bất thường | ☐ |

**Đầu ra cuối:** inventory trước/sau, evidence không nhạy cảm được giữ lại và xác
nhận không còn resource project có thể tiếp tục phát sinh phí.
