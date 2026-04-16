--- ==========================================
--- Y2: TRIỂN KHAI CSDL (01_Schema.sql)
--- ==========================================
CREATE TABLE IF NOT EXISTS product_categories (
    category_id SERIAL PRIMARY KEY,
    category_name VARCHAR(100) NOT NULL UNIQUE
);

CREATE TABLE IF NOT EXISTS suppliers (
    supplier_id SERIAL PRIMARY KEY,
    supplier_name VARCHAR(200) NOT NULL,
    contact_info TEXT
);

CREATE TABLE IF NOT EXISTS promotions (
    promotion_id SERIAL PRIMARY KEY,
    promotion_name VARCHAR(200) NOT NULL,
    description TEXT,
    discount_percentage DECIMAL(5,2),
    start_date DATE,
    end_date DATE
);

CREATE TABLE IF NOT EXISTS products (
    product_id SERIAL PRIMARY KEY,
    product_name VARCHAR(200) NOT NULL,
    price DECIMAL(15,2) DEFAULT 0,
    category_id INT REFERENCES product_categories(category_id),
    supplier_id INT REFERENCES suppliers(supplier_id)
);

CREATE TABLE IF NOT EXISTS customers (
    customer_id SERIAL PRIMARY KEY,
    customer_name VARCHAR(100) NOT NULL,
    phone VARCHAR(15),
    email VARCHAR(100) UNIQUE,
    address TEXT
);

CREATE TABLE IF NOT EXISTS employees (
    employee_id SERIAL PRIMARY KEY,
    employee_name VARCHAR(100) NOT NULL,
    position VARCHAR(50),
    hire_date DATE DEFAULT CURRENT_DATE
);

CREATE TABLE IF NOT EXISTS orders (
    order_id SERIAL PRIMARY KEY,
    customer_id INT REFERENCES customers(customer_id),
    employee_id INT REFERENCES employees(employee_id),
    promotion_id INT REFERENCES promotions(promotion_id),
    order_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE IF NOT EXISTS order_items (
    order_item_id SERIAL PRIMARY KEY,
    order_id INT REFERENCES orders(order_id),
    product_id INT REFERENCES products(product_id),
    quantity INT NOT NULL,
    unit_price DECIMAL(15,2) NOT NULL
);

--- ==========================================
--- Y3: NHẬP DỮ LIỆU MẪU (02_Data.sql)
--- ==========================================
-- Nhập Danh mục & Nhà cung cấp
INSERT INTO product_categories (category_name) VALUES ('Đồ uống'), ('Thực phẩm khô'), ('Hóa mỹ phẩm'), ('Đồ gia dụng'), ('Thực phẩm tươi sống') ON CONFLICT DO NOTHING;
INSERT INTO suppliers (supplier_name) VALUES ('Công ty Thực phẩm Hảo Hạng'), ('Nước giải khát ABC'), ('Gia dụng Việt'), ('Nông sản Sạch'), ('Hóa phẩm P&G') ON CONFLICT DO NOTHING;

-- Nhập Sản phẩm (Yêu cầu tối thiểu 30) [cite: 70]
INSERT INTO products (product_name, price, category_id, supplier_id) VALUES 
('Coca Cola', 10000, 1, 2), ('Gạo Tám', 200000, 2, 1), ('Omo 3kg', 150000, 3, 5), ('Thịt bò', 280000, 5, 4) ON CONFLICT DO NOTHING;

-- Nhập Khách hàng (Sử dụng hàm tạo 50 khách hàng cho nhanh) [cite: 69]
INSERT INTO customers (customer_name, email) 
SELECT 'Khách hàng ' || i, 'customer' || i || '@email.com'
FROM generate_series(1, 50) AS i ON CONFLICT DO NOTHING;

-- Nhập Nhân viên (Tối thiểu 10) [cite: 68]
INSERT INTO employees (employee_name, position) VALUES 
('NV 1', 'Thu ngân'), ('NV 2', 'Quản lý'), ('NV 3', 'Thu ngân'), ('NV 4', 'Kho'), ('NV 5', 'Bán hàng'),
('NV 6', 'Bán hàng'), ('NV 7', 'Thu ngân'), ('NV 8', 'Bảo vệ'), ('NV 9', 'Kế toán'), ('NV 10', 'Bán hàng') ON CONFLICT DO NOTHING;

-- Nhập Đơn hàng mẫu (Tối thiểu 100 đơn) [cite: 71]
INSERT INTO orders (customer_id, employee_id, order_date) 
SELECT floor(random() * 50 + 1), floor(random() * 10 + 1), '2025-10-15 10:00:00'
FROM generate_series(1, 100);

-- Nhập Chi tiết đơn hàng (Mỗi đơn 1 sản phẩm ngẫu nhiên)
INSERT INTO order_items (order_id, product_id, quantity, unit_price)
SELECT i, floor(random() * 4 + 1), 2, 50000
FROM generate_series(1, 100) AS i;

--- ==========================================
--- Y4 - Y7: CÁC TRUY VẤN BÁO CÁO (03_Queries.sql)
--- ==========================================

-- Y4: 10 giao dịch gần đây [cite: 74, 75]
SELECT o.order_id, c.customer_name, e.employee_name, o.order_date, SUM(oi.quantity * oi.unit_price) AS total
FROM orders o 
JOIN customers c ON o.customer_id = c.customer_id 
JOIN employees e ON o.employee_id = e.employee_id
JOIN order_items oi ON o.order_id = oi.order_id
GROUP BY o.order_id, c.customer_name, e.employee_name, o.order_date
ORDER BY o.order_date DESC LIMIT 10;

-- Y5: Doanh thu theo danh mục > 1,000,000 [cite: 84, 85]
SELECT pc.category_name, SUM(oi.quantity * oi.unit_price) AS total_revenue
FROM product_categories pc
JOIN products p ON pc.category_id = p.category_id
JOIN order_items oi ON p.product_id = oi.product_id
GROUP BY pc.category_name
HAVING SUM(oi.quantity * oi.unit_price) > 1000000
ORDER BY total_revenue DESC;

-- Y7: Xếp hạng nhân viên tháng 10/2025 [cite: 92, 93]
SELECT e.employee_name, SUM(oi.quantity * oi.unit_price) AS revenue,
       DENSE_RANK() OVER (ORDER BY SUM(oi.quantity * oi.unit_price) DESC) as rank
FROM employees e
JOIN orders o ON e.employee_id = o.employee_id
JOIN order_items oi ON o.order_id = oi.order_id
WHERE o.order_date BETWEEN '2025-10-01' AND '2025-10-31'
GROUP BY e.employee_id, e.employee_name;
--- ===========================================================
--- Y8: PHÂN TÍCH HIỆU NĂNG TRUY VẤN (CHƯA CÓ INDEX)
--- ===========================================================

-- 1. Chèn thêm 50.000 khách hàng ảo để mô phỏng dữ liệu lớn
-- Sử dụng generate_series để tạo dữ liệu nhanh chóng
INSERT INTO customers (customer_name, phone, email, address)
SELECT 
    'Khách hàng Ảo ' || i, 
    '09' || LPAD(i::text, 8, '0'), 
    'user' || i || '@anbinhmart.com', 
    'Địa chỉ ngẫu nhiên ' || i
FROM generate_series(1, 50000) AS i;

-- 2. Chạy lệnh EXPLAIN ANALYZE để kiểm tra Query Plan khi chưa có Index
-- Bạn cần chụp ảnh kết quả của lệnh này cho minh chứng Y8
EXPLAIN ANALYZE 
SELECT * FROM customers 
WHERE email = 'user45000@anbinhmart.com';


--- ===========================================================
--- Y9: TỐI ƯU HÓA HIỆU NĂNG (TẠO INDEX)
--- ===========================================================

-- 1. Viết câu lệnh CREATE INDEX để tăng tốc tìm kiếm qua email
CREATE INDEX idx_customers_email ON customers(email);

-- 2. Chạy lại chính xác câu lệnh EXPLAIN ANALYZE để so sánh
-- Bạn cần chụp ảnh kết quả của lệnh này cho minh chứng Y9
EXPLAIN ANALYZE 
SELECT * FROM customers 
WHERE email = 'user45000@anbinhmart.com';