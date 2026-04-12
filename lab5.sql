/* LAB 5: LÀM VIỆC VỚI NHIỀU BẢNG & SUBQUERIES
   Sinh viên thực hiện: Nam
*/

-----------------------------------------------------------
-- PHẦN 0: KHỞI TẠO DỮ LIỆU (ĐỂ CHẠY ĐƯỢC LAB 5)
-----------------------------------------------------------

DROP TABLE IF EXISTS order_items CASCADE;
DROP TABLE IF EXISTS orders CASCADE;
DROP TABLE IF EXISTS products CASCADE;
DROP TABLE IF EXISTS suppliers CASCADE;
DROP TABLE IF EXISTS customers CASCADE;

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

-- Chèn dữ liệu mẫu
INSERT INTO suppliers (supplier_name, contact_phone) VALUES 
('Công ty Sữa Việt Nam', '0123456789'), 
('Đồ Gia Dụng ABC', '0987654321');

INSERT INTO products (product_name, price, supplier_id) VALUES 
('Sữa tươi Vinamilk', 25000, 1), 
('Sữa chua', 5000, 1), 
('Chảo chống dính', 150000, 2),
('Ấm đun nước', 200000, 2);

INSERT INTO customers (full_name, phone_number) VALUES 
('Nguyễn Văn Nam', '0333444555'), 
('Trần Thị Bông', '0999888777'),
('Khách hàng mới', '0111222333');

INSERT INTO orders (customer_id, order_date) VALUES (1, '2026-04-12');

INSERT INTO order_items (order_id, product_id, quantity, price) VALUES 
(1, 1, 2, 25000), 
(1, 4, 1, 200000);


-----------------------------------------------------------
-- PHẦN I: BÀI 1 & BÀI 2
-----------------------------------------------------------

-- BÀI 1.1: (INNER JOIN) Chi tiết các sản phẩm đã được bán
SELECT 
    oi.order_id, 
    p.product_name, 
    oi.quantity, 
    oi.price
FROM order_items oi
INNER JOIN products p ON oi.product_id = p.product_id;

-- BÀI 1.2: (LEFT JOIN) Liệt kê khách hàng và đơn hàng (kể cả khách chưa mua)
SELECT 
    c.full_name, 
    o.order_id
FROM customers c
LEFT JOIN orders o ON c.customer_id = o.customer_id;

-- BÀI 2.1: (RIGHT JOIN) Liệt kê sản phẩm và đơn hàng (tìm sản phẩm chưa bán)
SELECT 
    p.product_name, 
    oi.order_id
FROM order_items oi
RIGHT JOIN products p ON oi.product_id = p.product_id;

-- BÀI 2.2: (UNION) Danh bạ duy nhất khách hàng và nhà cung cấp
SELECT full_name AS ContactName, phone_number AS PhoneNumber FROM customers
UNION
SELECT supplier_name AS ContactName, contact_phone AS PhoneNumber FROM suppliers;


-----------------------------------------------------------
-- PHẦN II: BÀI 3 & BÀI 4
-----------------------------------------------------------

-- BÀI 3.1: (Subquery với IN) Sản phẩm từ 'Công ty Sữa Việt Nam'
SELECT product_name, price
FROM products
WHERE supplier_id IN (
    SELECT supplier_id 
    FROM suppliers 
    WHERE supplier_name = 'Công ty Sữa Việt Nam'
);

-- BÀI 3.2: (Subquery trong SELECT) So sánh giá với giá trung bình
SELECT 
    product_name, 
    price,
    (SELECT AVG(price) FROM products) AS average_price
FROM products;

-- BÀI 4.1: (Subquery trong FROM) Đơn hàng > 50,000đ
SELECT order_id, total_value
FROM (
    SELECT order_id, SUM(quantity * price) AS total_value
    FROM order_items
    GROUP BY order_id
) AS OrderTotals
WHERE total_value > 50000;

-- BÀI 4.2: (EXISTS) Nhà cung cấp có sản phẩm trong kho
SELECT supplier_name
FROM suppliers s
WHERE EXISTS (
    SELECT 1 
    FROM products p 
    WHERE p.supplier_id = s.supplier_id
);