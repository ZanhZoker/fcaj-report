---
title: "Điều kiện chuẩn bị"
weight: 3
chapter: false
pre: " <b> 5.3 </b> "
---


## Mục tiêu

Chuẩn bị môi trường local có thể lặp lại, xác nhận AWS identity trước mọi thao tác
cloud và tách rõ lệnh được source xác nhận với giá trị triển khai phải lấy từ
thành viên phụ trách.

## Công cụ và quyền cần có

| Hạng mục | Mục đích | Cách kiểm tra |
|---|---|---|
| Git | Rà soát repository report, frontend và Data Engineering | `git --version` |
| Node.js và npm | Cài dependency và build React/Vite | `node --version` và `npm --version` |
| Python 3.11+ | Chạy project Data Engineering local | `python --version` |
| AWS CLI v2 | Kiểm tra identity và resource project | `aws --version` |
| AWS SAM CLI | Kiểm tra vòng đời stack Data Engineering | `sam --version` |
| Hugo | Build báo cáo song ngữ | `hugo version` |

## Bước 1. Xác định ranh giới source

- Frontend nhóm: [E-commerceWebsiteDesign](https://github.com/dxsondangdung2019-arch/E-commerceWebsiteDesign)
- Data Engineering: [ecommerce-interactions-pipeline](https://github.com/ZanhZoker/ecommerce-interactions-pipeline)
- Báo cáo: [fcaj-report](https://github.com/ZanhZoker/fcaj-report)

Repository frontend đã rà soát có code React/Vite, mock API, local storage và build
`dist/` hiện có. Repository này không chứa source Application Lambda hoặc hạ tầng
API Gateway. Các lớp đó phải được xác minh từ source của owner hoặc môi trường AWS,
không được suy ra từ code frontend.

## Bước 2. Cài và build frontend

```powershell
npm i
npm run build
```

Đầu ra mong đợi: Vite hoàn tất và ghi static asset vào `dist/`.

## Bước 3. Kiểm tra AWS identity

```powershell
aws sts get-caller-identity --profile <AWS-PROFILE>
aws configure get region --profile <AWS-PROFILE>
```

Xác nhận đúng account và **ap-southeast-1** trước lệnh tạo, thay đổi hoặc xóa tài
nguyên. Không đưa access key, session token, mật khẩu, MFA, account ID hoặc URL
private vào báo cáo.

## Bước 4. Chuẩn bị input

Input Data Engineering là export ZIP có `interactions.csv`, `Products.json` và
`items.csv` tùy chọn mà pipeline chủ động bỏ qua. Các giá trị triển khai như
`<FRONTEND-BUCKET>`, `<API-URL>` và `<DISTRIBUTION-ID>` phải lấy từ môi trường nhóm
đã xác minh.

## Lỗi thường gặp

- Frontend build local thành công không chứng minh AWS deployment đang mới nhất.
- Không được mô tả mock API của prototype như API ứng dụng đã triển khai.
- Sai AWS profile hoặc Region có thể làm tài nguyên hợp lệ trông như bị thiếu.
- Không thay giá trị trong dấu ngoặc nhọn bằng tên phỏng đoán.

## Kiểm tra và đầu ra

- Đã ghi nhận phiên bản tool local.
- `npm run build` tạo `dist/` không lỗi.
- Người thao tác đã xác nhận AWS identity và Region.
- Input bắt buộc có sẵn và không chứa secret.
- Bước tiếp theo chỉ nhận resource identifier đã xác minh.
