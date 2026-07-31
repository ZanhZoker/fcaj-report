---
title: "Điều kiện chuẩn bị"
weight: 3
chapter: false
pre: " <b> 5.3 </b> "
---

# Điều kiện chuẩn bị

| Hạng mục | Mục đích |
|---|---|
| Tài khoản AWS | Tạo và xác minh đúng resource thuộc phạm vi workshop |
| Quyền IAM | S3, Lambda, CloudFormation/SAM, CloudWatch và Athena tùy chọn; vai trò nhóm dùng dịch vụ của mình |
| AWS CLI v2 | Kiểm tra identity, upload/download S3 và xem stack |
| AWS SAM CLI | Validate, build, deploy và xóa stack Data Engineering |
| Node.js | Build và kiểm tra frontend React/Vite |
| Python 3.11+ | Chạy pipeline Data Engineering local và tests |
| Git | Lấy và rà soát source repository |
| Hugo | Build báo cáo thực tập song ngữ |
| Dữ liệu input | Export ZIP có `interactions.csv`, `Products.json` và có thể có `items.csv` bị bỏ qua |

#### Source repository

- [Frontend nhóm](https://github.com/dxsondangdung2019-arch/E-commerceWebsiteDesign)
- [Pipeline Data Engineering](https://github.com/ZanhZoker/ecommerce-interactions-pipeline)
- [Source báo cáo](https://github.com/ZanhZoker/fcaj-report)

#### Kiểm tra identity an toàn

```powershell
aws sts get-caller-identity --profile ecommerce-pipeline
python --version
sam --version
node --version
hugo version
```

Không đưa access key, secret key, session token, mật khẩu hoặc MFA thật vào lệnh,
ảnh chụp, source hay báo cáo.

{{% notice warning %}}
Trước khi tạo cloud resource, xác nhận đúng tài khoản AWS, Region, profile, chi
phí dự kiến và người chịu trách nhiệm cleanup.
{{% /notice %}}
