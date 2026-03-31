-- =============================================
-- 1. INSERT: Thêm 2 nhà cung cấp mới
-- Cột supplier_id tự động tăng nên chúng ta chỉ chèn Name, Phone và Email
-- =============================================

INSERT INTO suppliers (supplier_name, contact_phone, email) 
VALUES 
('Cong ty Sua Viet Nam', '0987654321', 'contact@vinamilk.vn'),
('Cong ty Thuc pham A Chau', '0912345678', 'contact@acecook.vn');


-- =============================================
-- 2. UPDATE: Sửa số điện thoại sai cho 'Cong ty Thuc pham A Chau'
-- Chúng ta dùng điều kiện WHERE theo tên để đảm bảo sửa đúng đối tượng
-- =============================================

UPDATE suppliers 
SET contact_phone = '0911112222' 
WHERE supplier_name = 'Cong ty Thuc pham A Chau';


-- =============================================
-- 3. DELETE: Xóa sản phẩm không còn kinh doanh
-- Yêu cầu xóa sản phẩm có mã (ID) bằng 8
-- Lưu ý: Trong Bài 1 bạn đặt tên bảng là SanPham và cột là MaSP
-- =============================================

DELETE FROM SanPham 
WHERE MaSP = '8'; 

-- Nếu bạn đã lỡ đặt kiểu dữ liệu MaSP là số (INT), hãy bỏ dấu nháy đơn:
-- DELETE FROM SanPham WHERE MaSP = 8;


-- =============================================
-- 4. TRUY VẤN KIỂM TRA KẾT QUẢ
-- =============================================

-- Kiểm tra danh sách nhà cung cấp sau khi thêm và sửa
SELECT * FROM suppliers;

-- Kiểm tra danh sách sản phẩm sau khi xóa
SELECT * FROM SanPham;