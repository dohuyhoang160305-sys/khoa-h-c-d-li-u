-- 1. Bảng Danh mục sản phẩm
CREATE TABLE Categories (
    category_id SERIAL PRIMARY KEY,
    category_name VARCHAR(100) NOT NULL UNIQUE
);

-- 2. Bảng Nhà cung cấp
CREATE TABLE Suppliers (
    supplier_id SERIAL PRIMARY KEY,
    supplier_name VARCHAR(200) NOT NULL,
    contact_name VARCHAR(100),
    phone VARCHAR(20) UNIQUE,
    email VARCHAR(100),
    address TEXT
);

-- 3. Bảng Chương trình khuyến mãi
CREATE TABLE Promotions (
    promotion_id SERIAL PRIMARY KEY,
    promo_name VARCHAR(200) NOT NULL,
    description TEXT,
    discount_percent DECIMAL(5, 2) CHECK (discount_percent >= 0 AND discount_percent <= 100),
    start_date DATE NOT NULL,
    end_date DATE NOT NULL,
    CONSTRAINT date_check CHECK (end_date >= start_date)
);

-- 4. Bảng Sản phẩm
CREATE TABLE Products (
    product_id SERIAL PRIMARY KEY,
    product_name VARCHAR(200) NOT NULL,
    price DECIMAL(12, 2) NOT NULL CHECK (price > 0),
    category_id INT REFERENCES Categories(category_id) ON DELETE SET NULL,
    supplier_id INT REFERENCES Suppliers(supplier_id) ON DELETE SET NULL
);

-- 5. Bảng Khách hàng
CREATE TABLE Customers (
    customer_id SERIAL PRIMARY KEY,
    full_name VARCHAR(100) NOT NULL,
    phone VARCHAR(20) UNIQUE NOT NULL,
    email VARCHAR(100) UNIQUE,
    address TEXT
);

-- 6. Bảng Nhân viên
CREATE TABLE Employees (
    employee_id SERIAL PRIMARY KEY,
    full_name VARCHAR(100) NOT NULL,
    position VARCHAR(50) NOT NULL, -- Ví dụ: 'Thu ngân', 'Quản lý kho'
    hire_date DATE DEFAULT CURRENT_DATE,
    salary DECIMAL(12, 2)
);

-- 7. Bảng Đơn hàng
CREATE TABLE Orders (
    order_id SERIAL PRIMARY KEY,
    customer_id INT REFERENCES Customers(customer_id),
    employee_id INT REFERENCES Employees(employee_id),
    promotion_id INT REFERENCES Promotions(promotion_id),
    order_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- 8. Bảng Chi tiết đơn hàng
CREATE TABLE OrderDetails (
    order_detail_id SERIAL PRIMARY KEY,
    order_id INT REFERENCES Orders(order_id) ON DELETE CASCADE,
    product_id INT REFERENCES Products(product_id),
    quantity INT NOT NULL CHECK (quantity > 0),
    unit_price DECIMAL(12, 2) NOT NULL, -- Giá tại thời điểm mua để tránh biến động giá sau này
    CONSTRAINT fk_order FOREIGN KEY (order_id) REFERENCES Orders(order_id)
);