# E-commerce REST API

A comprehensive RESTful API for e-commerce applications built with Express.js and MySQL.

## Features

- ✅ **Products Management**
  - List all products with advanced filtering (category, brand, featured)
  - Get specific product with variants, images, and attributes
  - Search products across multiple fields
  - Featured products endpoint

- ✅ **Categories & Brands**
  - Hierarchical category structure
  - Brand management with product counts
  - Get products by category or brand

- ✅ **Orders & Customers**
  - Complete order management system
  - Customer profiles with order history
  - Order items with product details

- ✅ **Advanced Features**
  - Dashboard statistics
  - MySQL Views for optimized queries
  - Stored procedures and functions
  - Comprehensive error handling
  - CORS support
  - Input validation and pagination

## Prerequisites

- Node.js (v14 or higher)
- MySQL Server
- MySQL Workbench (recommended for database management)

## Database Setup

1. **Install MySQL Server** if you haven't already
2. **Open MySQL Workbench** and connect to your local MySQL server
3. **Run the database schema**:
   - Open the `database/schema.sql` file in MySQL Workbench  
   - Execute the entire script to create the database and sample data
4. **Configure environment variables**:
   - Copy the `.env` file and update the database credentials
   - Make sure `DB_PASSWORD` matches your MySQL root password
   - Update `DB_NAME=ecom` (database name changed from products_db to ecom)

## API Endpoints

### Products

### GET /api/products
List all products with advanced filtering options.

**Query Parameters:**
- `page` (optional): Page number (default: 1)
- `limit` (optional): Items per page (default: 10, max: 100)
- `search` (optional): Search term for name, description, or category
- `category_id` (optional): Filter by category ID
- `brand_id` (optional): Filter by brand ID
- `featured` (optional): Filter featured products (true/false)

**Example:**
```
GET /api/products?page=1&limit=5&search=iphone&category_id=3&featured=true
```

### GET /api/products/featured
Get all featured products.

### GET /api/products/search
Search products with query parameter.

**Query Parameters:**
- `q` (required): Search query
- `page`, `limit`: Pagination parameters

**Example:**
```
GET /api/products/search?q=wireless&page=1&limit=10
```

### GET /api/products/:id
Get a specific product by ID with complete details including variants, images, and attributes.

**Example:**
```
GET /api/products/1
```

### Categories

### GET /api/categories
Get all categories with product counts.

### GET /api/categories/:id
Get specific category by ID.

### GET /api/categories/:id/products
Get all products in a specific category.

**Example:**
```
GET /api/categories/3/products?page=1&limit=10
```

### Brands

### GET /api/brands
Get all brands with product counts.

### GET /api/brands/:id/products
Get all products from a specific brand.

### Orders

### GET /api/orders
Get all orders with optional customer filtering.

**Query Parameters:**
- `customer_id` (optional): Filter by customer ID
- `page`, `limit`: Pagination parameters

### GET /api/orders/:id
Get specific order with complete details including items.

### Customers

### GET /api/customers
Get all customers with search functionality.

**Query Parameters:**
- `search` (optional): Search by name or email
- `page`, `limit`: Pagination parameters

### Dashboard

### GET /api/dashboard/stats
Get comprehensive dashboard statistics including:
- Total products, categories, brands, customers
- Total orders and revenue
- Pending orders and featured products

## Error Handling

The API returns appropriate HTTP status codes and error messages:

- `400 Bad Request`: Invalid parameters or ID format
- `404 Not Found`: Product not found or invalid route
- `500 Internal Server Error`: Server errors

**Error Response Format:**
```json
{
  "error": "Not Found",
  "message": "Product with ID 999 not found."
}
```

## Getting Started

1. Install dependencies:
   ```bash
   npm install
   ```

2. Set up the database:
   - Install MySQL Server and MySQL Workbench
   - Run the SQL script in `database/schema.sql`
   - Update the `.env` file with your database credentials

3. Start the development server:
   ```bash
   npm run dev
   ```

4. The API will be available at `http://localhost:3000`

## Database Structure

The API uses a comprehensive MySQL e-commerce database with the following structure:

### Core Tables:
- **products**: Main product information
- **categories**: Hierarchical product categories  
- **brands**: Product brands
- **product_variants**: Product variations (size, color, etc.)
- **product_images**: Product image gallery
- **product_attributes**: Custom product attributes
- **customers**: Customer profiles
- **customer_addresses**: Customer shipping/billing addresses
- **orders**: Order information
- **order_items**: Individual order line items

### Database Features:
- **Views**: Optimized product_details view for faster queries
- **Stored Procedures**: GetProductsByCategory, GetFeaturedProducts, SearchProducts
- **Functions**: GetProductStock, GetCategoryProductCount
- **Indexes**: Optimized for common query patterns
- **Foreign Keys**: Referential integrity maintained

## Sample Data

The database includes comprehensive sample data:
- 10 products across multiple categories (Electronics, Computers, Mobile Phones, etc.)
- 8 categories with hierarchical structure
- 8 brands including Apple, Samsung, Sony, Microsoft
- Product variants with different configurations
- Sample customers and orders
- Product images from Pexels
- Product attributes and specifications

## Testing the API

You can test the endpoints using:

- **Browser**: Visit `http://localhost:3000/api/products`
- **curl**: 
  ```bash
  # Get all products
  curl "http://localhost:3000/api/products"
  
  # Get featured products
  curl "http://localhost:3000/api/products/featured"
  
  # Search products
  curl "http://localhost:3000/api/products/search?q=iphone"
  
  # Get specific product
  curl http://localhost:3000/api/products/1
  
  # Get categories
  curl http://localhost:3000/api/categories
  
  # Get dashboard stats
  curl http://localhost:3000/api/dashboard/stats
  ```
- **Postman**: Import the endpoints and test them
- **Any HTTP client**: Make GET requests to the endpoints

## Project Structure

```
├── server.js              # Main server file
├── routes/
│   └── ecom.js            # E-commerce routes
├── services/
│   └── ecomService.js     # Business logic
├── database/
│   ├── mysql.js            # MySQL connection pool
│   ├── ecomDatabase.js    # Database operations
│   └── schema.sql         # Complete e-commerce schema
├── middleware/
│   └── errorHandler.js     # Error handling middleware
├── .env                    # Environment variables
└── README.md
```

## Environment Variables

Create a `.env` file in the root directory:

```env
DB_HOST=localhost
DB_PORT=3306
DB_USER=root
DB_PASSWORD=your_mysql_password
DB_NAME=ecom
PORT=3000
NODE_ENV=development
```

## MySQL Workbench Usage

1. **Connect to your local MySQL server** in MySQL Workbench
2. **Create the database** by running the `schema.sql` script
3. **Explore the database structure**:
   - Tables: products, categories, brands, customers, orders, etc.
   - Views: product_details for optimized queries
   - Procedures: GetProductsByCategory, GetFeaturedProducts
   - Functions: GetProductStock, GetCategoryProductCount
4. **View and manage data** using the visual interface
5. **Run custom queries** to test and modify data
6. **Monitor performance** and optimize queries

## Advanced Features

### Database Views
The `product_details` view provides optimized access to product information with category and brand names, variant counts, and stock totals.

### Stored Procedures
- `GetProductsByCategory(category_name)`: Get products by category name
- `GetFeaturedProducts()`: Get all featured products
- `SearchProducts(search_term)`: Full-text search across products

### Functions
- `GetProductStock(product_id)`: Calculate total stock for a product
- `GetCategoryProductCount(category_id)`: Count products in a category

### Performance Optimizations
- Connection pooling for database connections
- Indexed columns for faster queries
- Optimized JOIN operations
- Prepared statements for security

## CORS Support

CORS is enabled for all origins to support frontend integration. In production, configure CORS to only allow specific domains.