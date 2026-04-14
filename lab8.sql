/* ================================================================
LAB 8: WINDOW FUNCTIONS IN SQL
================================================================
*/

-- 0. CHUẨN BỊ DỮ LIỆU (Để có thể thực thi các bài tập bên dưới)
CREATE TABLE products (
    product_id INT PRIMARY KEY,
    product_name VARCHAR(100),
    category VARCHAR(50),
    price DECIMAL(10, 2)
);

CREATE TABLE orders (
    order_id INT PRIMARY KEY,
    order_date DATE
);

CREATE TABLE order_items (
    order_id INT,
    product_id INT,
    quantity INT,
    price DECIMAL(10, 2)
);

INSERT INTO products VALUES 
(1, 'Sữa tươi', 'Thực phẩm', 20000),
(2, 'Bánh mì', 'Thực phẩm', 15000),
(3, 'Bột giặt', 'Hóa phẩm', 150000),
(4, 'Nước rửa chén', 'Hóa phẩm', 35000),
(5, 'Táo nhập khẩu', 'Thực phẩm', 80000);

INSERT INTO orders VALUES (1, '2023-10-01'), (2, '2023-10-01'), (3, '2023-10-02');
INSERT INTO order_items VALUES (1, 1, 2, 20000), (2, 3, 1, 150000), (3, 5, 1, 80000);

---

-- BÀI 1: SO SÁNH WINDOW FUNCTION VỚI GROUP BY

-- 1. Thử nghiệm với GROUP BY (Vấn đề: Mất thông tin từng sản phẩm)
SELECT product_name, AVG(price) as avg_price
FROM products
GROUP BY product_name;

-- 2. Sử dụng Window Function (Giải pháp: Giữ nguyên dòng, tính toán trên "cửa sổ")
SELECT 
    product_name, 
    price, 
    AVG(price) OVER () AS avg_overall_price
FROM products;

---

-- BÀI 2: PHÂN TÍCH TRONG TỪNG NHÓM VỚI PARTITION BY

SELECT 
    category,
    product_name,
    price,
    AVG(price) OVER (PARTITION BY category) AS avg_category_price
FROM products;

---

-- BÀI 3: XẾP HẠNG SẢN PHẨM

-- 1. Chuẩn bị: Cập nhật giá để thấy rõ sự khác biệt của Rank
UPDATE products SET price = 35000 WHERE product_id IN (1, 4);

-- 2. Thực hành xếp hạng
SELECT 
    product_name, 
    price,
    ROW_NUMBER() OVER (ORDER BY price DESC) AS row_num,
    RANK() OVER (ORDER BY price DESC) AS rank_num,
    DENSE_RANK() OVER (ORDER BY price DESC) AS dense_rank_num
FROM products;

/* 3. Giải thích:
   - ROW_NUMBER: Luôn tăng dần (1, 2, 3...) không quan tâm giá trùng.
   - RANK: Đồng hạng thì cùng số, nhưng nhảy bậc (1, 1, 3...).
   - DENSE_RANK: Đồng hạng cùng số, nhưng không nhảy bậc (1, 1, 2...).
*/

---

-- BÀI 4: TÍNH TỔNG LŨY KẾ DOANH THU THEO NGÀY

WITH daily_revenue AS (
    -- Bước 1: Gom nhóm tính doanh thu tổng mỗi ngày
    SELECT 
        o.order_date, 
        SUM(oi.quantity * oi.price) AS total_daily_revenue
    FROM order_items oi
    JOIN orders o ON oi.order_id = o.order_id
    GROUP BY o.order_date
)
-- Bước 2: Dùng Window Function để tính lũy kế (Running Total)
SELECT 
    order_date,
    total_daily_revenue,
    SUM(total_daily_revenue) OVER (ORDER BY order_date) AS running_total_revenue
FROM daily_revenue;