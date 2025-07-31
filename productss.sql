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

