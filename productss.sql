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


 