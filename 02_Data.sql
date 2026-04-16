-- 1. Đảm bảo bảng Danh mục tồn tại (Y2)
CREATE TABLE IF NOT EXISTS product_categories (
    category_id SERIAL PRIMARY KEY,
    category_name VARCHAR(100) NOT NULL UNIQUE
);

-- 2. Nhập dữ liệu cho Danh mục (Y3)
INSERT INTO product_categories (category_name) VALUES 
('Đồ uống'), 
('Thực phẩm khô'), 
('Hóa mỹ phẩm'), 
('Đồ gia dụng'), 
('Thực phẩm tươi sống');

-- 3. Đảm bảo bảng Nhà cung cấp tồn tại (Y2)
CREATE TABLE IF NOT EXISTS suppliers (
    supplier_id SERIAL PRIMARY KEY,
    supplier_name VARCHAR(200) NOT NULL,
    contact_info TEXT
);

-- 4. Nhập dữ liệu cho Nhà cung cấp (Y3)
INSERT INTO suppliers (supplier_name, contact_info) VALUES 
('Công ty Thực phẩm Hảo Hạng', '0901234567'), 
('Nước giải khát ABC', '0908889999'),
('Gia dụng Việt', '0912345678'),
('Nông sản Sạch', '0933445566'),
('Hóa phẩm P&G', '0944556677');