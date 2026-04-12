/* TRỌN BỘ CODE KHỞI TẠO VÀ GIẢI LAB 7
   Sinh viên: Nam - FPT Polytechnic
*/

-----------------------------------------------------------
-- PHẦN 0: KHỞI TẠO LẠI BẢNG (Để tránh lỗi Does Not Exist)
-----------------------------------------------------------

DROP TABLE IF EXISTS order_items;
DROP TABLE IF EXISTS orders;
DROP TABLE IF EXISTS products;
DROP TABLE IF EXISTS suppliers;
DROP TABLE IF EXISTS customers;

CREATE TABLE customers (
    customer_id SERIAL PRIMARY KEY,
    full_name VARCHAR(100),
    phone_number VARCHAR(15),
    address VARCHAR(255) -- Thêm cột address để phục vụ Bài 4
);

-- Thêm một ít dữ liệu mẫu để câu lệnh SELECT có cái để chạy
INSERT INTO customers (full_name, phone_number, address) VALUES 
('Nguyen Van Nam', '0910099999', 'Address 100'),
('Tran Thi Bong', '0910012222', 'Address 500'),
('Test User', '0888777666', 'Ha Noi');


-----------------------------------------------------------
-- BÀI 1: PHÂN TÍCH KHI CHƯA CÓ INDEX (Sequential Scan)
-----------------------------------------------------------
-- Xem kế hoạch thực thi khi chưa có Index
EXPLAIN ANALYZE
SELECT * FROM customers WHERE phone_number = '0910099999';

/* Ghi chú cho Nam: 
- Bạn sẽ thấy dòng "Seq Scan on customers".
- Seq Scan là quét lần lượt từng dòng, rất chậm khi dữ liệu lớn.
*/


-----------------------------------------------------------
-- BÀI 2: TẠO INDEX VÀ KIỂM TRA (Index Scan)
-----------------------------------------------------------
-- 1. Tạo Index cho số điện thoại
CREATE INDEX idx_customers_phone ON customers(phone_number);

-- 2. Chạy lại để thấy sự khác biệt
EXPLAIN ANALYZE
SELECT * FROM customers WHERE phone_number = '0910099999';

/* Ghi chú cho Nam: 
- Bây giờ sẽ xuất hiện "Index Scan using idx_customers_phone".
- Tốc độ sẽ nhanh hơn vì nó tra cứu theo cấu trúc cây thay vì quét hết bảng.
*/


-----------------------------------------------------------
-- BÀI 3: CHI PHÍ CỦA INDEX (INSERT)
-----------------------------------------------------------
EXPLAIN ANALYZE
INSERT INTO customers (full_name, phone_number, address)
VALUES ('Test Index User', '0999999999', '123 Test Index');

/* Ghi chú cho Nam: 
- Lệnh INSERT sẽ tốn thêm một chút thời gian để cập nhật cả Index idx_customers_phone.
*/


-----------------------------------------------------------
-- BÀI 4: BITMAP SCAN (Truy vấn phức tạp)
-----------------------------------------------------------
-- 1. Tạo Index cho địa chỉ
CREATE INDEX idx_customers_address ON customers(address);

-- 2. Xem kế hoạch thực thi cho lệnh OR/LIKE
EXPLAIN
SELECT * FROM customers
WHERE address = 'Address 500' OR phone_number LIKE '091001%';

/* Ghi chú cho Nam: 
- Bạn sẽ thấy "Bitmap Index Scan" và "Bitmap Heap Scan".
- Nó gom các vị trí thỏa mãn vào một "bản đồ" trước khi lấy dữ liệu thật để tối ưu tốc độ.
*/