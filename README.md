# 📦 Ecommerce Products Loader

**Milestone 1: Database Design and Loading Data**  
This project involves designing a database schema and loading product data from an e-commerce dataset into a MySQL database.

---

## 📂 Dataset Information

- **Source**: [Ecommerce Dataset GitHub](https://github.com/recruit41/ecommerce-dataset)
- **File Used**: `products.csv` (extracted from `archive.zip`)
- **Fields**:
  - `id`: INT – Product ID
  - `cost`: DECIMAL – Product cost
  - `category`: VARCHAR – Product category
  - `name`: TEXT – Product name
  - `brand`: VARCHAR – Brand name
  - `retail_price`: DECIMAL – Price to customer
  - `department`: VARCHAR – Department (e.g., Women)
  - `sku`: VARCHAR – Unique product code
  - `distribution_center_id`: INT – Warehouse identifier

---

## 🗄️ Database Schema (MySQL)

```sql
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
