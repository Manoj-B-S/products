create database ecom;
use ecom;

CREATE TABLE products (
    id INT PRIMARY KEY,
    cost DECIMAL(10,5),
    category VARCHAR(100),
    name TEXT,
    brand VARCHAR(100),
    retail_price DECIMAL(10,2),
    department VARCHAR(100),
    sku VARCHAR(100),
    distribution_center_id INT
);

SHOW VARIABLES LIKE 'local_infile';
SELECT * FROM products LIMIT 5;


-- Checking null  
SELECT * FROM products
WHERE id IS NULL
   OR cost IS NULL
   OR category IS NULL
   OR name IS NULL
   OR brand IS NULL
   OR retail_price IS NULL
   OR department IS NULL
   OR sku IS NULL
   OR distribution_center_id IS NULL;
   
-- Check for Negative Prices or Cost
 SELECT * FROM products
WHERE cost < 0 OR retail_price < 0;

-- Check for Duplicates by id or sku
SELECT id, COUNT(*) AS count
FROM products
GROUP BY id
HAVING COUNT(*) > 1;

SELECT sku, COUNT(*) AS count
FROM products
GROUP BY sku
HAVING COUNT(*) > 1;

-- Count Products per Category
SELECT category, COUNT(*) AS product_count
FROM products
GROUP BY category
ORDER BY product_count DESC;



CREATE TABLE orders (
  id INT AUTO_INCREMENT PRIMARY KEY,
  order_number VARCHAR(100),
  customer_id INT,
  status VARCHAR(50),
  subtotal DECIMAL(10, 2),
  tax_amount DECIMAL(10, 2),
  shipping_amount DECIMAL(10, 2),
  total_amount DECIMAL(10, 2),
  currency VARCHAR(10),
  payment_status VARCHAR(50),
  created_at DATETIME,
  updated_at DATETIME
);

SHOW TABLES IN ecom;

-- Step 1: Create the new departments table
CREATE TABLE departments (
    id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(255) NOT NULL UNIQUE,
    description TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

-- Step 2: First, check what columns exist in your products table
DESCRIBE products;
-- OR
SHOW COLUMNS FROM products;

-- Step 2: Extract unique department names and populate departments table
INSERT INTO departments (name)
SELECT DISTINCT department 
FROM products 
WHERE department IS NOT NULL 
AND department != '';

-- Step 3: Add department_id column to products table
-- Just add the foreign key constraint
ALTER TABLE products 
ADD CONSTRAINT fk_products_department 
    FOREIGN KEY (department_id) REFERENCES departments(id);
-- Step 4: Update products table to use department_id instead of department
UPDATE products p
JOIN departments d ON p.department = d.name
SET p.department_id = d.id
WHERE p.id > 0;

-- Step 5: Remove the old department column (optional - do this after verification)
-- ALTER TABLE products DROP COLUMN department;

-- Verification queries
-- Check departments table
SELECT * FROM departments ORDER BY name;

-- Check products with department information
SELECT 
    p.id,
    p.name as product_name,
    p.department_id,
    d.name as department_name
FROM products p
LEFT JOIN departments d ON p.department_id = d.id
LIMIT 10;

-- Count products per department
SELECT 
    d.name as department_name,
    COUNT(p.id) as product_count
FROM departments d
LEFT JOIN products p ON d.id = p.department_id
GROUP BY d.id, d.name
ORDER BY product_count DESC;
