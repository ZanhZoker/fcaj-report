---
title: "Dọn dẹp tài nguyên"
weight: 13
chapter: false
pre: " <b> 5.13 </b> "
---

{{% notice warning %}}
Thao tác xóa không thể hoàn tác. Trước khi chạy lệnh, phải xác nhận AWS account, region, tên stack, tên bucket và minh chứng cần giữ. Thay mọi placeholder bằng giá trị đã kiểm tra trên console; không chạy lệnh phá hủy với tài nguyên phỏng đoán.
{{% /notice %}}

#### Stack Data Engineering

Các tài nguyên do SAM quản lý nên được xóa thông qua stack để CloudFormation xử lý đúng dependency:

```bash
sam delete --stack-name <verified-data-pipeline-stack> --region <verified-region>
```

Trước khi xóa stack, kiểm tra và chỉ lưu lại các artifact không nhạy cảm thực sự cần thiết. Nếu bucket còn object làm cản trở thao tác xóa, phải xem lại chính xác bucket và danh sách object trước khi làm rỗng. Sau khi xóa, xác nhận S3 bucket, processing Lambda, IAM role, event notification và CloudWatch log group không còn tồn tại. Nếu đã dùng Athena, xóa riêng các object kết quả truy vấn.

#### Tài nguyên ứng dụng nhóm

Thành viên phụ trách cần kiểm kê và chỉ xóa những tài nguyên thực sự được tạo cho project:

1. Xóa Amazon Personalize campaign/recommender và solution version hoặc dataset phụ thuộc sau khi người phụ trách ML xác nhận không còn cần dùng.
2. Disable và xóa đúng CloudFront distribution khi không còn phục vụ demo.
3. Kiểm tra và xóa object cùng bucket S3 của ứng dụng.
4. Xóa API Gateway, Lambda ứng dụng và log group qua stack sở hữu khi có thể.
5. Export bản ghi cần lưu, sau đó xóa đúng các bảng DynamoDB.
6. Kiểm tra IAM role và policy được tạo riêng cho project.
7. Kiểm tra resource inventory và billing view của region để phát hiện tài nguyên còn phát sinh phí.

Đây là quy trình thực hiện, không phải tuyên bố cleanup đã hoàn thành.

<!-- TODO: Team evidence - resource inventory before cleanup -->
<!-- TODO: Team evidence - resource inventory after cleanup -->
<!-- TODO: Personal evidence - SAM stack deletion or confirmed retained environment -->
