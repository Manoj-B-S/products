-- Create database (run this first in MySQL Workbench)
CREATE DATABASE IF NOT EXISTS products_db;
USE products_db;

-- Create products table
CREATE TABLE IF NOT EXISTS products (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    description TEXT,
    price DECIMAL(10, 2) NOT NULL,
    category VARCHAR(100) NOT NULL,
    stock INT NOT NULL DEFAULT 0,
    sku VARCHAR(50) UNIQUE NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    INDEX idx_category (category),
    INDEX idx_name (name),
    INDEX idx_sku (sku)
);

-- Insert sample data
INSERT INTO products (name, description, price, category, stock, sku) VALUES
('Wireless Bluetooth Headphones', 'High-quality wireless headphones with noise cancellation', 199.99, 'Electronics', 50, 'WBH-001'),
('Smartphone Case', 'Durable protective case for smartphones', 29.99, 'Accessories', 200, 'SPC-002'),
('Laptop Stand', 'Adjustable aluminum laptop stand for better ergonomics', 79.99, 'Office', 75, 'LPS-003'),
('USB-C Cable', 'Fast charging USB-C cable, 6 feet long', 19.99, 'Accessories', 300, 'USC-004'),
('Wireless Mouse', 'Ergonomic wireless mouse with precision tracking', 49.99, 'Electronics', 120, 'WM-005'),
('Desk Lamp', 'LED desk lamp with adjustable brightness', 89.99, 'Office', 60, 'DL-006'),
('Portable Charger', '10000mAh portable battery pack', 39.99, 'Electronics', 150, 'PC-007'),
('Bluetooth Speaker', 'Compact waterproof Bluetooth speaker', 69.99, 'Electronics', 90, 'BS-008'),
('Monitor Stand', 'Adjustable monitor stand with storage', 59.99, 'Office', 40, 'MS-009'),
('Keyboard', 'Mechanical keyboard with RGB backlighting', 129.99, 'Electronics', 80, 'KB-010'),
('Coffee Mug', 'Ceramic coffee mug with ergonomic handle', 14.99, 'Kitchen', 250, 'CM-011'),
('Water Bottle', 'Stainless steel insulated water bottle', 24.99, 'Kitchen', 180, 'WB-012'),
('Notebook', 'Premium leather-bound notebook', 34.99, 'Office', 95, 'NB-013'),
('Phone Charger', 'Universal phone charger with multiple ports', 22.99, 'Electronics', 220, 'PHC-014'),
('Desk Organizer', 'Bamboo desk organizer with multiple compartments', 45.99, 'Office', 65, 'DO-015');