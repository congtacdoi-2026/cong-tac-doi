APP QUẢN LÝ CÔNG TÁC ĐỘI ONLINE

1) Tạo một project Supabase.
2) Vào SQL Editor và chạy toàn bộ file supabase_schema.sql.
3) Trong Authentication > Users, tạo tài khoản email/password cho Tổng phụ trách và 12 chi đội.
4) Sau khi có user, vào Table Editor > profiles và thêm 13 dòng:
   - 1 dòng role=admin, class_name để trống.
   - 12 dòng role=class, class_name lần lượt:
     6A7, 6A8, 6A9, 7A7, 7A8, 7A9, 8A6, 8A7, 8A8, 9A8, 9A9, 9A10.
   id của mỗi dòng phải đúng User ID tương ứng trong Authentication.
5) Sao chép config.example.js thành config.js.
6) Điền SUPABASE_URL và SUPABASE_KEY (publishable/anon key). TUYỆT ĐỐI KHÔNG dùng service_role/secret key ở frontend.
7) Mở index.html để thử. Để dùng online, đưa thư mục này lên một dịch vụ host tĩnh (Netlify, Vercel, Cloudflare Pages, GitHub Pages...) và cấu hình config.js tương ứng.

CƠ CHẾ PHÂN QUYỀN:
- Tổng phụ trách: xem/sửa điểm cả 12 chi đội, xem toàn bộ học sinh, cài đặt.
- Tài khoản lớp: chỉ nhập/sửa điểm của chính lớp đó và xem dữ liệu học sinh của lớp đó.
- Xếp hạng vẫn hiển thị toàn bộ 12 chi đội.
- RLS của Supabase là lớp bảo vệ dữ liệu; không dựa vào việc ẩn nút trên giao diện.

ĐIỂM HỌC TẬP:
T +10, K +5, TB -15, Y -30.
ĐIỂM NỀ NẾP:
Chuyên cần, Nề nếp, Văn nghệ đầu tuần, Xe đạp, Vệ sinh, Bồn hoa, Tác phong.
