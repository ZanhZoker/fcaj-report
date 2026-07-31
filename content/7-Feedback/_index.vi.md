---
title: "Chia sẻ và phản hồi"
weight: 7
chapter: false
pre: " <b> 7. </b> "
---

#### Kiến thức và kinh nghiệm thu được

Kỳ thực tập kết nối các khái niệm AWS với một project nhóm có ranh giới thật giữa trải nghiệm người dùng, logic ứng dụng, lưu trữ dữ liệu, chuẩn bị dữ liệu và recommendation. Tôi học được nhiều nhất từ các giao diện giữa những phần này. Một component đúng về kỹ thuật vẫn có thể làm project thất bại nếu identifier, định dạng file hoặc quy trình bàn giao không khớp với component tiếp theo.

Công việc Data Engineering giúp tôi hiểu rõ hơn luồng S3 event, đóng gói Lambda, SAM/CloudFormation, CloudWatch log, data validation, quality reporting và automated test. Công việc này cũng củng cố một nguyên tắc thực tế: giữ nguyên identifier nguồn trừ khi toàn bộ hệ thống đã thống nhất mapping. Thay ID cục bộ có thể làm dataset đơn giản hơn nhưng khiến kết quả recommendation không dùng được trong ứng dụng.

#### Giá trị của project nhóm

Project thương mại điện tử làm cho việc phối hợp vai trò trở nên cụ thể. Frontend cần API ổn định và product ID nhất quán; người phụ trách backend và database định nghĩa bản ghi ứng dụng; Data Engineering chuyển export thành artifact đã kiểm tra; ML nhận contract đó và phụ trách training, evaluation; các vai trò cloud và testing giúp các component vận hành cùng nhau. Nhìn thấy dependency end-to-end này có giá trị hơn việc xem mỗi dịch vụ là một bài tập riêng lẻ.

Giai đoạn khó nhất là khi yêu cầu dữ liệu còn ngầm định. Làm rõ filename được chấp nhận, schema, event vocabulary, quy tắc timestamp, catalogue lookup và người sở hữu bước bàn giao đã giảm việc làm lại. Với project sau, tôi sẽ bắt đầu bằng data contract có version và fixture nhỏ mang tính đại diện để các vai trò liên quan dùng chung.

#### Kinh nghiệm triển khai AWS

Chuẩn bị pipeline cho AWS cho thấy sự khác nhau giữa chạy local thành công và một workload có thể vận hành: permission, event configuration, log retention, resource naming, failure output và cleanup đều quan trọng. README Data Engineering ghi nhận việc xác minh triển khai, nhưng minh chứng phù hợp để đưa vào báo cáo vẫn đang được tập hợp. Vì vậy, tôi xem minh chứng triển khai là một deliverable riêng thay vì coi source configuration là bằng chứng của môi trường đang chạy.

#### Phản hồi về chương trình

Cấu trúc FCAJ hữu ích vì kết hợp tự học, viết tài liệu kỹ thuật, source code, minh chứng và báo cáo công khai song ngữ. Yêu cầu viết workshop khuyến khích người tham gia giải thích không chỉ đã xây dựng gì mà còn cách người khác có thể xác minh và dọn dẹp tài nguyên.

Đề xuất cải thiện:

1. Cung cấp sớm một ví dụ về data contract xuyên vai trò và checklist minh chứng.
2. Có buổi hướng dẫn ngắn về chi phí và cleanup trước khi người tham gia tạo managed resource.
3. Công bố tiêu chí review theo milestone cho kiến trúc, source, bảo mật, testing và ảnh chụp.
4. Tạo checkpoint tích hợp sớm để phát hiện nhanh sai khác identifier và schema.

#### Định hướng sau kỳ thực tập

Tôi dự định tiếp tục học AWS và Data Engineering qua các deployment nhỏ có thể xác minh độc lập. Ưu tiên của tôi là thực hành IAM và observability tốt hơn, data orchestration, Athena và mô hình lưu trữ phân tích, CI testing, cùng luồng tích hợp hoàn chỉnh từ event ứng dụng đến nơi sử dụng recommendation.
