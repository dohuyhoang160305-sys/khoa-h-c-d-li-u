-----------------------------------------------------------
-- 1. KHỞI TẠO CẤU TRÚC DỮ LIỆU (PHẢI CHẠY PHẦN NÀY TRƯỚC)
-----------------------------------------------------------

-- Xóa bảng nếu đã tồn tại để làm mới hoàn toàn
DROP TABLE IF EXISTS order_items;
DROP TABLE IF EXISTS orders;
DROP TABLE IF EXISTS products;
DROP TABLE IF EXISTS suppliers;
DROP TABLE IF EXISTS customers;

-- Tạo lại các bảng
CREATE TABLE customers (
    customer_id SERIAL PRIMARY KEY,
    full_name VARCHAR(100),
    phone_number VARCHAR(15)
);

CREATE TABLE suppliers (
    supplier_id SERIAL PRIMARY KEY,
    supplier_name VARCHAR(100),
    contact_phone VARCHAR(15)
);

CREATE TABLE products (
    product_id SERIAL PRIMARY KEY,
    product_name VARCHAR(100),
    price DECIMAL(10, 2),
    supplier_id INT REFERENCES suppliers(supplier_id)
);

CREATE TABLE orders (
    order_id SERIAL PRIMARY KEY,
    customer_id INT REFERENCES customers(customer_id),
    order_date DATE
);

CREATE TABLE order_items (
    item_id SERIAL PRIMARY KEY,
    order_id INT REFERENCES orders(order_id),
    product_id INT REFERENCES products(product_id),
    quantity INT,
    price DECIMAL(10, 2)
);

-- Thêm dữ liệu mẫu (Để Lab 6 có kết quả hiển thị)
INSERT INTO suppliers (supplier_name, contact_phone) VALUES 
('Công ty Sữa Việt Nam', '0123456789'), 
('Đồ Gia Dụng ABC', '0987654321');

INSERT INTO products (product_name, price, supplier_id) VALUES 
('Sữa tươi Vinamilk', 25000, 1), 
('Sữa chua', 5000, 1), 
('Chảo chống dính', 150000, 2),
('Ấm đun nước', 200000, 2); -- Thêm sản phẩm để thỏa mãn bài 2

INSERT INTO customers (full_name, phone_number) VALUES 
('Nguyễn Văn Nam', '0333444555'), 
('Trần Thị Bông', '0999888777');

-- Thêm đơn hàng vào tháng 10/2025 để thỏa mãn bài 3
INSERT INTO orders (customer_id, order_date) VALUES 
(1, '2025-10-15'), 
(2, '2025-10-20');

-- Thêm chi tiết để khách hàng tiêu trên 100k cho bài 4
INSERT INTO order_items (order_id, product_id, quantity, price) VALUES 
(1, 4, 1, 200000), -- Nam mua ấm đun 200k
(2, 3, 1, 150000); -- Bông mua chảo 150k


-----------------------------------------------------------
-- 2. GIẢI BÀI TẬP LAB 6
-----------------------------------------------------------

-- BÀI 1: THỐNG KÊ SẢN PHẨM
SELECT 
    COUNT(*) AS SoLuongSanPham,
    AVG(price) AS GiaTrungBinh,
    MIN(price) AS GiaReNhat,
    MAX(price) AS GiaDatNhat
FROM products;

-- BÀI 2: PHÂN TÍCH NHÀ CUNG CẤP
SELECT 
    s.supplier_name, 
    COUNT(p.product_id) AS TongSoSanPham
FROM suppliers s
JOIN products p ON s.supplier_id = p.supplier_id
GROUP BY s.supplier_name
HAVING COUNT(p.product_id) > 1;

-- BÀI 3: ĐỊNH DẠNG NGÀY THÁNG
SELECT 
    order_id, 
    TO_CHAR(order_date, 'DD/MM/YYYY') AS NgayDatHangVN
FROM orders
WHERE EXTRACT(YEAR FROM order_date) = 2025 
  AND EXTRACT(MONTH FROM order_date) = 10;

-- BÀI 4: BÁO CÁO DOANH THU KHÁCH VIP
SELECT 
    c.full_name, 
    SUM(oi.quantity * oi.price) AS TongChiTieu
FROM customers c
JOIN orders o ON c.customer_id = o.customer_id
JOIN order_items oi ON o.order_id = oi.order_id
GROUP BY c.full_name
HAVING SUM(oi.quantity * oi.price) > 100000
ORDER BY TongChiTieu DESC;