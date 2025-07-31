-- Create database (run this first in MySQL Workbench)
CREATE DATABASE IF NOT EXISTS ecom;
USE ecom;

-- Create categories table
CREATE TABLE IF NOT EXISTS categories (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) NOT NULL UNIQUE,
    description TEXT,
    parent_id INT NULL,
    is_active BOOLEAN DEFAULT TRUE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (parent_id) REFERENCES categories(id) ON DELETE SET NULL,
    INDEX idx_parent_id (parent_id),
    INDEX idx_name (name)
);

-- Create brands table
CREATE TABLE IF NOT EXISTS brands (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) NOT NULL UNIQUE,
    description TEXT,
    logo_url VARCHAR(255),
    website VARCHAR(255),
    is_active BOOLEAN DEFAULT TRUE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    INDEX idx_name (name)
);

-- Create products table
CREATE TABLE IF NOT EXISTS products (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    description TEXT,
    short_description VARCHAR(500),
    sku VARCHAR(50) UNIQUE NOT NULL,
    barcode VARCHAR(100),
    price DECIMAL(10, 2) NOT NULL,
    compare_price DECIMAL(10, 2),
    cost_price DECIMAL(10, 2),
    category_id INT NOT NULL,
    brand_id INT,
    weight DECIMAL(8, 2),
    dimensions VARCHAR(100),
    is_active BOOLEAN DEFAULT TRUE,
    is_featured BOOLEAN DEFAULT FALSE,
    meta_title VARCHAR(255),
    meta_description TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (category_id) REFERENCES categories(id) ON DELETE RESTRICT,
    FOREIGN KEY (brand_id) REFERENCES brands(id) ON DELETE SET NULL,
    INDEX idx_category_id (category_id),
    INDEX idx_brand_id (brand_id),
    INDEX idx_sku (sku),
    INDEX idx_name (name),
    INDEX idx_is_active (is_active),
    INDEX idx_is_featured (is_featured)
);

-- Create product_variants table
CREATE TABLE IF NOT EXISTS product_variants (
    id INT AUTO_INCREMENT PRIMARY KEY,
    product_id INT NOT NULL,
    variant_name VARCHAR(100),
    sku VARCHAR(50) UNIQUE NOT NULL,
    price DECIMAL(10, 2) NOT NULL,
    compare_price DECIMAL(10, 2),
    cost_price DECIMAL(10, 2),
    stock_quantity INT NOT NULL DEFAULT 0,
    weight DECIMAL(8, 2),
    is_active BOOLEAN DEFAULT TRUE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (product_id) REFERENCES products(id) ON DELETE CASCADE,
    INDEX idx_product_id (product_id),
    INDEX idx_sku (sku),
    INDEX idx_is_active (is_active)
);

-- Create product_images table
CREATE TABLE IF NOT EXISTS product_images (
    id INT AUTO_INCREMENT PRIMARY KEY,
    product_id INT NOT NULL,
    image_url VARCHAR(500) NOT NULL,
    alt_text VARCHAR(255),
    sort_order INT DEFAULT 0,
    is_primary BOOLEAN DEFAULT FALSE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (product_id) REFERENCES products(id) ON DELETE CASCADE,
    INDEX idx_product_id (product_id),
    INDEX idx_sort_order (sort_order)
);

-- Create product_attributes table
CREATE TABLE IF NOT EXISTS product_attributes (
    id INT AUTO_INCREMENT PRIMARY KEY,
    product_id INT NOT NULL,
    attribute_name VARCHAR(100) NOT NULL,
    attribute_value VARCHAR(255) NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (product_id) REFERENCES products(id) ON DELETE CASCADE,
    INDEX idx_product_id (product_id),
    INDEX idx_attribute_name (attribute_name)
);

-- Create customers table
CREATE TABLE IF NOT EXISTS customers (
    id INT AUTO_INCREMENT PRIMARY KEY,
    email VARCHAR(255) UNIQUE NOT NULL,
    password_hash VARCHAR(255) NOT NULL,
    first_name VARCHAR(100) NOT NULL,
    last_name VARCHAR(100) NOT NULL,
    phone VARCHAR(20),
    date_of_birth DATE,
    gender ENUM('male', 'female', 'other'),
    is_active BOOLEAN DEFAULT TRUE,
    email_verified BOOLEAN DEFAULT FALSE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    INDEX idx_email (email),
    INDEX idx_name (first_name, last_name)
);

-- Create customer_addresses table
CREATE TABLE IF NOT EXISTS customer_addresses (
    id INT AUTO_INCREMENT PRIMARY KEY,
    customer_id INT NOT NULL,
    type ENUM('billing', 'shipping') NOT NULL,
    first_name VARCHAR(100) NOT NULL,
    last_name VARCHAR(100) NOT NULL,
    company VARCHAR(100),
    address_line_1 VARCHAR(255) NOT NULL,
    address_line_2 VARCHAR(255),
    city VARCHAR(100) NOT NULL,
    state VARCHAR(100) NOT NULL,
    postal_code VARCHAR(20) NOT NULL,
    country VARCHAR(100) NOT NULL,
    phone VARCHAR(20),
    is_default BOOLEAN DEFAULT FALSE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (customer_id) REFERENCES customers(id) ON DELETE CASCADE,
    INDEX idx_customer_id (customer_id),
    INDEX idx_type (type)
);

-- Create orders table
CREATE TABLE IF NOT EXISTS orders (
    id INT AUTO_INCREMENT PRIMARY KEY,
    order_number VARCHAR(50) UNIQUE NOT NULL,
    customer_id INT,
    status ENUM('pending', 'processing', 'shipped', 'delivered', 'cancelled', 'refunded') DEFAULT 'pending',
    subtotal DECIMAL(10, 2) NOT NULL,
    tax_amount DECIMAL(10, 2) DEFAULT 0,
    shipping_amount DECIMAL(10, 2) DEFAULT 0,
    discount_amount DECIMAL(10, 2) DEFAULT 0,
    total_amount DECIMAL(10, 2) NOT NULL,
    currency VARCHAR(3) DEFAULT 'USD',
    payment_status ENUM('pending', 'paid', 'failed', 'refunded') DEFAULT 'pending',
    payment_method VARCHAR(50),
    shipping_method VARCHAR(100),
    notes TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (customer_id) REFERENCES customers(id) ON DELETE SET NULL,
    INDEX idx_customer_id (customer_id),
    INDEX idx_order_number (order_number),
    INDEX idx_status (status),
    INDEX idx_created_at (created_at)
);

-- Create order_items table
CREATE TABLE IF NOT EXISTS order_items (
    id INT AUTO_INCREMENT PRIMARY KEY,
    order_id INT NOT NULL,
    product_id INT NOT NULL,
    variant_id INT,
    quantity INT NOT NULL,
    unit_price DECIMAL(10, 2) NOT NULL,
    total_price DECIMAL(10, 2) NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (order_id) REFERENCES orders(id) ON DELETE CASCADE,
    FOREIGN KEY (product_id) REFERENCES products(id) ON DELETE RESTRICT,
    FOREIGN KEY (variant_id) REFERENCES product_variants(id) ON DELETE SET NULL,
    INDEX idx_order_id (order_id),
    INDEX idx_product_id (product_id)
);

-- Insert sample categories
INSERT INTO categories (name, description) VALUES
('Electronics', 'Electronic devices and gadgets'),
('Computers', 'Computers and computer accessories'),
('Mobile Phones', 'Smartphones and mobile accessories'),
('Audio', 'Audio equipment and accessories'),
('Home & Garden', 'Home and garden products'),
('Office Supplies', 'Office and business supplies'),
('Sports & Outdoors', 'Sports and outdoor equipment'),
('Books', 'Books and educational materials');

-- Insert sample brands
INSERT INTO brands (name, description, website) VALUES
('Apple', 'Technology company known for innovative products', 'https://apple.com'),
('Samsung', 'Electronics and technology company', 'https://samsung.com'),
('Sony', 'Electronics and entertainment company', 'https://sony.com'),
('Microsoft', 'Software and technology company', 'https://microsoft.com'),
('Dell', 'Computer technology company', 'https://dell.com'),
('HP', 'Technology company specializing in computers', 'https://hp.com'),
('Logitech', 'Computer peripherals and accessories', 'https://logitech.com'),
('Generic', 'Generic brand products', NULL);

-- Insert sample products
INSERT INTO products (name, description, short_description, sku, price, compare_price, category_id, brand_id, is_featured) VALUES
('iPhone 15 Pro', 'Latest iPhone with advanced camera system and A17 Pro chip', 'Premium smartphone with cutting-edge technology', 'IPH-15-PRO-001', 999.99, 1099.99, 3, 1, TRUE),
('MacBook Air M2', '13-inch laptop with M2 chip, perfect for everyday tasks', 'Lightweight laptop with exceptional performance', 'MBA-M2-13-001', 1199.99, 1299.99, 2, 1, TRUE),
('Samsung Galaxy S24', 'Flagship Android smartphone with AI features', 'Advanced Android phone with premium features', 'SGS-24-001', 899.99, 999.99, 3, 2, TRUE),
('Sony WH-1000XM5', 'Premium noise-canceling wireless headphones', 'Industry-leading noise cancellation', 'SNY-WH1000XM5', 399.99, 449.99, 4, 3, TRUE),
('Dell XPS 13', 'Ultra-portable laptop with stunning display', 'Premium ultrabook for professionals', 'DLL-XPS13-001', 1099.99, 1199.99, 2, 5, FALSE),
('Microsoft Surface Pro 9', '2-in-1 laptop tablet with versatile design', 'Convertible device for work and creativity', 'MSF-SP9-001', 999.99, 1099.99, 2, 4, FALSE),
('Logitech MX Master 3S', 'Advanced wireless mouse for productivity', 'Ergonomic mouse with precision tracking', 'LOG-MXM3S-001', 99.99, 119.99, 2, 7, FALSE),
('iPad Pro 12.9', 'Large tablet perfect for creative professionals', 'Professional tablet with M2 chip', 'IPD-PRO129-001', 1099.99, 1199.99, 2, 1, TRUE),
('Samsung 4K Monitor', '27-inch 4K display for work and entertainment', 'High-resolution monitor with vibrant colors', 'SAM-4K27-001', 349.99, 399.99, 2, 2, FALSE),
('Wireless Charging Pad', 'Fast wireless charging for compatible devices', 'Convenient wireless charging solution', 'WCP-FAST-001', 29.99, 39.99, 3, 8, FALSE);

-- Insert sample product variants
INSERT INTO product_variants (product_id, variant_name, sku, price, stock_quantity) VALUES
(1, '128GB Natural Titanium', 'IPH-15-PRO-128-NT', 999.99, 50),
(1, '256GB Natural Titanium', 'IPH-15-PRO-256-NT', 1099.99, 30),
(1, '512GB Natural Titanium', 'IPH-15-PRO-512-NT', 1299.99, 20),
(2, '8GB RAM 256GB SSD', 'MBA-M2-8-256', 1199.99, 25),
(2, '16GB RAM 512GB SSD', 'MBA-M2-16-512', 1499.99, 15),
(3, '128GB Phantom Black', 'SGS-24-128-PB', 899.99, 40),
(3, '256GB Phantom Black', 'SGS-24-256-PB', 999.99, 25),
(4, 'Black', 'SNY-WH1000XM5-BLK', 399.99, 35),
(4, 'Silver', 'SNY-WH1000XM5-SLV', 399.99, 20);

-- Insert sample product images
INSERT INTO product_images (product_id, image_url, alt_text, sort_order, is_primary) VALUES
(1, 'https://images.pexels.com/photos/788946/pexels-photo-788946.jpeg', 'iPhone 15 Pro front view', 1, TRUE),
(2, 'https://images.pexels.com/photos/205421/pexels-photo-205421.jpeg', 'MacBook Air M2 open', 1, TRUE),
(3, 'https://images.pexels.com/photos/1092644/pexels-photo-1092644.jpeg', 'Samsung Galaxy S24', 1, TRUE),
(4, 'https://images.pexels.com/photos/3394650/pexels-photo-3394650.jpeg', 'Sony headphones', 1, TRUE);

-- Insert sample product attributes
INSERT INTO product_attributes (product_id, attribute_name, attribute_value) VALUES
(1, 'Screen Size', '6.1 inches'),
(1, 'Storage', '128GB'),
(1, 'Color', 'Natural Titanium'),
(1, 'Operating System', 'iOS 17'),
(2, 'Screen Size', '13.6 inches'),
(2, 'Processor', 'Apple M2'),
(2, 'RAM', '8GB'),
(2, 'Storage', '256GB SSD'),
(3, 'Screen Size', '6.2 inches'),
(3, 'Storage', '128GB'),
(3, 'Operating System', 'Android 14'),
(4, 'Type', 'Over-ear'),
(4, 'Connectivity', 'Bluetooth 5.2'),
(4, 'Battery Life', '30 hours');

-- Insert sample customers
INSERT INTO customers (email, password_hash, first_name, last_name, phone, is_active, email_verified) VALUES
('john.doe@example.com', '$2b$10$hash1', 'John', 'Doe', '+1234567890', TRUE, TRUE),
('jane.smith@example.com', '$2b$10$hash2', 'Jane', 'Smith', '+1234567891', TRUE, TRUE),
('mike.johnson@example.com', '$2b$10$hash3', 'Mike', 'Johnson', '+1234567892', TRUE, FALSE);

-- Insert sample orders
INSERT INTO orders (order_number, customer_id, status, subtotal, tax_amount, shipping_amount, total_amount, payment_status) VALUES
('ORD-2024-001', 1, 'delivered', 999.99, 80.00, 9.99, 1089.98, 'paid'),
('ORD-2024-002', 2, 'processing', 1199.99, 96.00, 0.00, 1295.99, 'paid'),
('ORD-2024-003', 1, 'pending', 399.99, 32.00, 9.99, 441.98, 'pending');

-- Insert sample order items
INSERT INTO order_items (order_id, product_id, variant_id, quantity, unit_price, total_price) VALUES
(1, 1, 1, 1, 999.99, 999.99),
(2, 2, 4, 1, 1199.99, 1199.99),
(3, 4, 8, 1, 399.99, 399.99);

-- Create views for easier data access
CREATE VIEW product_details AS
SELECT 
    p.id,
    p.name,
    p.description,
    p.short_description,
    p.sku,
    p.price,
    p.compare_price,
    c.name as category_name,
    b.name as brand_name,
    p.is_active,
    p.is_featured,
    p.created_at,
    p.updated_at,
    (SELECT COUNT(*) FROM product_variants pv WHERE pv.product_id = p.id) as variant_count,
    (SELECT SUM(pv.stock_quantity) FROM product_variants pv WHERE pv.product_id = p.id) as total_stock
FROM products p
LEFT JOIN categories c ON p.category_id = c.id
LEFT JOIN brands b ON p.brand_id = b.id;

-- Create stored procedures
DELIMITER //

CREATE PROCEDURE GetProductsByCategory(IN category_name VARCHAR(100))
BEGIN
    SELECT pd.* 
    FROM product_details pd 
    WHERE pd.category_name = category_name 
    AND pd.is_active = TRUE
    ORDER BY pd.created_at DESC;
END //

CREATE PROCEDURE GetFeaturedProducts()
BEGIN
    SELECT pd.* 
    FROM product_details pd 
    WHERE pd.is_featured = TRUE 
    AND pd.is_active = TRUE
    ORDER BY pd.created_at DESC;
END //

CREATE PROCEDURE SearchProducts(IN search_term VARCHAR(255))
BEGIN
    SELECT pd.* 
    FROM product_details pd 
    WHERE (pd.name LIKE CONCAT('%', search_term, '%') 
           OR pd.description LIKE CONCAT('%', search_term, '%')
           OR pd.category_name LIKE CONCAT('%', search_term, '%')
           OR pd.brand_name LIKE CONCAT('%', search_term, '%'))
    AND pd.is_active = TRUE
    ORDER BY pd.created_at DESC;
END //

DELIMITER ;

-- Create functions
DELIMITER //

CREATE FUNCTION GetProductStock(product_id INT) RETURNS INT
READS SQL DATA
DETERMINISTIC
BEGIN
    DECLARE total_stock INT DEFAULT 0;
    SELECT COALESCE(SUM(stock_quantity), 0) INTO total_stock
    FROM product_variants 
    WHERE product_variants.product_id = product_id AND is_active = TRUE;
    RETURN total_stock;
END //

CREATE FUNCTION GetCategoryProductCount(category_id INT) RETURNS INT
READS SQL DATA
DETERMINISTIC
BEGIN
    DECLARE product_count INT DEFAULT 0;
    SELECT COUNT(*) INTO product_count
    FROM products 
    WHERE products.category_id = category_id AND is_active = TRUE;
    RETURN product_count;
END //

DELIMITER ;