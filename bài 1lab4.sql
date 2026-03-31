
-- 1. TẠO CẤU TRÚC CSDL (DDL)


-- Xóa bảng cũ nếu tồn tại (theo thứ tự bảng con trước, bảng cha sau)
DROP TABLE IF EXISTS DonHangChiTiet;
DROP TABLE IF EXISTS DonHang;
DROP TABLE IF EXISTS SanPham;
DROP TABLE IF EXISTS KhachHang;

-- Tạo bảng Khách hàng
CREATE TABLE KhachHang (
    MaKH VARCHAR(10) NOT NULL,
    HoTen VARCHAR(100) NOT NULL,
    Email VARCHAR(50),
    SoDT VARCHAR(15),
    DiaChi VARCHAR(255),
    CONSTRAINT PK_KhachHang PRIMARY KEY (MaKH),
    CONSTRAINT UC_Email UNIQUE (Email)
);

-- Tạo bảng Sản phẩm
CREATE TABLE SanPham (
    MaSP VARCHAR(10) NOT NULL,
    TenSP VARCHAR(100) NOT NULL,
    DonGia DECIMAL(18, 2),
    SoLuongTon INT,
    DonViTinh VARCHAR(20),
    CONSTRAINT PK_SanPham PRIMARY KEY (MaSP),
    CONSTRAINT CK_DonGia CHECK (DonGia >= 0),
    CONSTRAINT CK_SoLuongTon CHECK (SoLuongTon >= 0)
);

-- Tạo bảng Đơn hàng
CREATE TABLE DonHang (
    MaDH VARCHAR(10) NOT NULL,
    NgayDat DATE DEFAULT CURRENT_DATE,
    MaKH VARCHAR(10),
    TrangThai VARCHAR(50),
    CONSTRAINT PK_DonHang PRIMARY KEY (MaDH),
    CONSTRAINT FK_DonHang_KhachHang FOREIGN KEY (MaKH) REFERENCES KhachHang(MaKH)
);

-- Tạo bảng Đơn hàng chi tiết
CREATE TABLE DonHangChiTiet (
    MaDH VARCHAR(10) NOT NULL,
    MaSP VARCHAR(10) NOT NULL,
    SoLuong INT NOT NULL,
    GiaBan DECIMAL(18, 2),
    CONSTRAINT PK_DonHangChiTiet PRIMARY KEY (MaDH, MaSP),
    CONSTRAINT FK_CTDH_DonHang FOREIGN KEY (MaDH) REFERENCES DonHang(MaDH),
    CONSTRAINT FK_CTDH_SanPham FOREIGN KEY (MaSP) REFERENCES SanPham(MaSP),
    CONSTRAINT CK_SoLuong_Ban CHECK (SoLuong > 0)
);

-- =============================================
-- 2. THAO TÁC DỮ LIỆU MẪU (DML)
-- =============================================

-- Thêm dữ liệu vào bảng Khách hàng
INSERT INTO KhachHang (MaKH, HoTen, Email, SoDT, DiaChi) VALUES 
('KH001', 'Nguyen Van An', 'an.nv@gmail.com', '0901234567', 'Ha Noi'),
('KH002', 'Le Thi Binh', 'binh.lt@gmail.com', '0912345678', 'TP.HCM'),
('KH003', 'Tran Duc Hoa', 'hoa.td@gmail.com', '0988776655', 'Da Nang');

-- Thêm dữ liệu vào bảng Sản phẩm
INSERT INTO SanPham (MaSP, TenSP, DonGia, SoLuongTon, DonViTinh) VALUES 
('SP01', 'Laptop Dell XPS', 25000000, 10, 'Cai'),
('SP02', 'Chuot Logitech', 500000, 50, 'Con'),
('SP03', 'Ban phim co', 1200000, 20, 'Cai');

-- Thêm dữ liệu vào bảng Đơn hàng
INSERT INTO DonHang (MaDH, NgayDat, MaKH, TrangThai) VALUES 
('DH01', '2024-03-20', 'KH001', 'Da thanh toan'),
('DH02', '2024-03-21', 'KH002', 'Cho giao hang');

-- Thêm dữ liệu vào bảng Đơn hàng chi tiết
INSERT INTO DonHangChiTiet (MaDH, MaSP, SoLuong, GiaBan) VALUES 
('DH01', 'SP01', 1, 25000000),
('DH01', 'SP02', 2, 500000),
('DH02', 'SP03', 1, 1200000);

-- =============================================
-- 3. TRUY VẤN KIỂM TRA
-- =============================================
SELECT * FROM KhachHang;
SELECT * FROM SanPham;
SELECT * FROM DonHang;
SELECT * FROM DonHangChiTiet;