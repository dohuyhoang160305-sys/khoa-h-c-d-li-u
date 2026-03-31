-- =============================================
-- 1. CHUẨN BỊ: Tạo bảng nháp (test_table)
-- =============================================
CREATE TABLE test_table (
    id INT
);

-- (Tùy chọn) Kiểm tra xem bảng đã tồn tại chưa
-- SELECT * FROM test_table;


-- =============================================
-- 2. DROP COLUMN: Xóa cột contact_phone khỏi bảng suppliers
-- Tình huống: Quản lý qua email nên không cần cột số điện thoại
-- =============================================
ALTER TABLE suppliers 
DROP COLUMN contact_phone;


-- =============================================
-- 3. DROP TABLE: Xóa hoàn toàn bảng nháp test_table
-- Tình huống: Bảng không còn giá trị sử dụng
-- =============================================
DROP TABLE test_table;


-- =============================================
-- 4. KIỂM TRA SAU KHI THỰC THI
-- =============================================

-- Kiểm tra cấu trúc bảng suppliers (Sẽ thấy cột contact_phone đã biến mất)
SELECT * FROM suppliers;

-- Thử truy vấn bảng test_table (Sẽ báo lỗi vì bảng không còn tồn tại)
-- SELECT * FROM test_table;