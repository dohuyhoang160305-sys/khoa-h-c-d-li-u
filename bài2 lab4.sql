
-- 1. Xóa bảng nếu đã tồn tại để làm sạch môi trường trước khi tạo
DROP TABLE IF EXISTS suppliers;

-- 2. Tạo bảng suppliers với các ràng buộc theo yêu cầu
CREATE TABLE suppliers (
    -- supplier_id: Kiểu số nguyên, tự động tăng (SERIAL) và là khóa chính
    supplier_id SERIAL PRIMARY KEY,
    
    -- supplier_name: Kiểu chuỗi, không được để trống
    supplier_name VARCHAR(255) NOT NULL,
    
    -- contact_phone: Kiểu chuỗi, không được trùng lặp
    contact_phone VARCHAR(15) UNIQUE
);

-- 3. Thêm dữ liệu mẫu (DML) để kiểm tra cột tự động tăng
-- Lưu ý: Không cần chèn supplier_id vì hệ thống tự sinh số 1, 2, 3...
INSERT INTO suppliers (supplier_name, contact_phone) 
VALUES (N'Công ty Thực phẩm Sạch HN', '0243999888');

INSERT INTO suppliers (supplier_name, contact_phone) 
VALUES (N'Nhà phân phối An Bình', '0283777666');

INSERT INTO suppliers (supplier_name, contact_phone) 
VALUES (N'Tổng kho Điện máy Miền Bắc', '0912345678');

-- 4. Truy vấn kiểm tra kết quả
SELECT * FROM suppliers;