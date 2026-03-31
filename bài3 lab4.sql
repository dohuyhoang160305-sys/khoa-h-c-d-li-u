
-- 1. Thêm cột email vào bảng suppliers
-- Kiểu dữ liệu VARCHAR(100)
ALTER TABLE suppliers 
ADD COLUMN email VARCHAR(100);

-- 2. Thêm cột supplier_id vào bảng SanPham (products)
-- Cột này phải cùng kiểu dữ liệu với supplier_id bên bảng suppliers (INT)
ALTER TABLE SanPham 
ADD COLUMN supplier_id INT;

-- 3. Tạo ràng buộc Khóa ngoại (FOREIGN KEY)
-- Kết nối cột supplier_id của bảng SanPham tới supplier_id của bảng suppliers
ALTER TABLE SanPham 
ADD CONSTRAINT FK_SanPham_Suppliers 
FOREIGN KEY (supplier_id) REFERENCES suppliers(supplier_id);

-- =============================================
-- THỬ NGHIỆM CẬP NHẬT DỮ LIỆU (KIỂM TRA)
-- =============================================

-- Cập nhật email cho nhà cung cấp đã có
UPDATE suppliers 
SET email = 'contact@anbinh.com' 
WHERE supplier_id = 1;

-- Gán sản phẩm SP01 cho nhà cung cấp số 1
UPDATE SanPham 
SET supplier_id = 1 
WHERE MaSP = 'SP01';

-- Truy vấn kiểm tra cấu trúc mới
SELECT * FROM suppliers;
SELECT MaSP, TenSP, supplier_id FROM SanPham;