---
title: "Session Policies trong Amazon EKS Pod Identity"
weight: 1
chapter: false
pre: " <b> 3.1. </b> "
---

# SESSION POLICIES TRONG AMAZON EKS POD IDENTITY

Amazon EKS Pod Identity vừa bổ sung tính năng session policies, cho phép thu hẹp quyền IAM linh hoạt cho từng pod mà không cần tạo nhiều IAM roles riêng biệt.

## Điểm chính

- **Session policy** là inline IAM policy chỉ định khi tạo Pod Identity association
- **Quyền hiệu lực** = giao giữa IAM role permissions và session policy → chỉ thu hẹp, không mở rộng
- Giảm số lượng IAM roles cần quản lý, tránh chạm quota
- Hỗ trợ same-account và cross-account

## Lỗi AccessDenied dù có Allow?

Khi gặp AccessDenied, xác định 4 yếu tố:

1. **Principal** – ai gọi?
2. **Action** – hành động gì?
3. **Resource** – tài nguyên nào?
4. **Context** – điều kiện gì (region, account, tag, network, session)?

## Các lớp policy

| Loại policy          | Cấp quyền | Hạn chế |
| -------------------- | --------- | ------- |
| Identity-based       | ✅        | ❌      |
| Resource-based       | ✅        | ❌      |
| Permissions Boundary | ❌        | ✅      |
| SCP                  | ❌        | ✅      |
| **Session Policy**   | ❌        | ✅      |

## Quy trình debug AccessDenied

1. **Xác định caller**: `aws sts get-caller-identity`
2. **Ghi nhận yêu cầu**: principal, action, resource, context
3. **Kiểm tra policy cấp quyền**: identity-based, resource-based, trust policy
4. **Kiểm tra lớp hạn chế**: boundary, SCP, **session policy**, conditions
5. **Dùng CloudTrail** và Policy Simulator (có giới hạn)
6. **Sửa đúng lớp**, test lại, thu hẹp quyền

## Hiểu lầm thường gặp

- ❌ "Có Allow là đủ" → Sai nếu boundary/SCP/session policy chặn
- ❌ "SCP cấp quyền" → SCP chỉ đặt trần
- ❌ "Policy Simulator báo allowed là chắc chắn" → Có giới hạn
- ❌ "Cấp quyền rộng là sửa nhanh" → Che nguyên nhân, tạo rủi ro

## Kết luận

Khi gặp AccessDenied, cần hỏi: _"Quyền hiệu lực của principal này với action, resource và context cụ thể là gì?"_

Session policies giúp kiểm soát chính xác trong EKS, nhưng vẫn cần hiểu cách các lớp IAM tương tác.

**Xem bài viết gốc:** [Facebook AWS Study Group FCJ](https://www.facebook.com/groups/awsstudygroupfcj/?multi_permalinks=2221829758581984)
