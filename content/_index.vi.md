---
title: "Báo cáo thực tập"
weight: 1
chapter: false
---

# Báo cáo thực tập

![Ảnh chân dung Trần Uy Danh](/images/avatar-tran-uy-danh.jpg)

### Thông tin sinh viên

&emsp; **Họ và tên:** Trần Uy Danh

&emsp; **Trường:** Đại học Bách Khoa - Đại học Quốc gia TP. Hồ Chí Minh

&emsp; **Chuyên ngành:** Kỹ thuật Máy tính

&emsp; **Đơn vị thực tập:** AWS-FCAJ

&emsp; **Vị trí thực tập:** Thực tập sinh Data Engineering

&emsp; **Thời gian thực tập:** 15/06/2026 - 14/08/2026

&emsp; **Email:** [danh.tranuy@hcmut.edu.vn](mailto:danh.tranuy@hcmut.edu.vn)

### Giới thiệu báo cáo

Báo cáo trình bày hệ thống thương mại điện tử tích hợp gợi ý sản phẩm trên AWS
do nhóm thực hiện. Kiến trúc mục tiêu kết nối giao diện React/Vite với các thành
phần ứng dụng serverless, cơ sở dữ liệu và Machine Learning; từng phần trong báo
cáo phân biệt rõ nội dung đã được source xác nhận, ảnh triển khai do nhóm cung
cấp và nội dung ở mức đề xuất.

Trong dự án, tôi phụ trách xây dựng pipeline Data Engineering để kiểm tra, chuẩn
hóa và bàn giao dữ liệu tương tác cho giai đoạn Machine Learning. Pipeline đọc
file export ZIP, xử lý `interactions.csv`, đối chiếu mã sản phẩm với
`Products.json`, giữ nguyên `USER_ID` và `ITEM_ID`, rồi xuất
`interactions_clean.csv` cùng báo cáo chất lượng. Frontend, backend, cơ sở dữ
liệu ứng dụng, huấn luyện recommendation và visual search là các thành phần của
project nhóm, không phải toàn bộ công việc cá nhân của tôi.

Báo cáo đi từ Worklog theo tiến độ, Proposal của nhóm, các bài viết và sự kiện,
sau đó trình bày Workshop theo từng bước. Mỗi lớp trong Workshop được liên kết
với nguồn hoặc ảnh minh chứng tương ứng; các quy trình chưa có bằng chứng triển
khai được mô tả như bước kiểm tra, không được trình bày như kết quả đã hoàn tất.

### Nội dung báo cáo

1.  [Nhật ký công việc](1-Worklog/)
2.  [Đề xuất dự án](2-Proposal/)
3.  [Bài viết đã đăng](3-BlogsPosted/)
4.  [Sự kiện đã tham gia](4-EventParticipated/)
5.  [Workshop](5-Workshop/)
6.  [Tự đánh giá](6-Self-evaluation/)
7.  [Chia sẻ và phản hồi](7-Feedback/)
8.  [Tài liệu tham khảo](8-References/)

### Liên kết dự án

- [Website báo cáo](https://zanhzoker.github.io/fcaj-report/)
- [Repository báo cáo](https://github.com/ZanhZoker/fcaj-report)
- [Repository Data Engineering](https://github.com/ZanhZoker/ecommerce-interactions-pipeline)
- [Repository thương mại điện tử của nhóm](https://github.com/dxsondangdung2019-arch/E-commerceWebsiteDesign)
