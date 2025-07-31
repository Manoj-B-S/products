import pool from './mysql.js';

export class EcomDatabase {
  // Products operations
  async getProducts(offset = 0, limit = 10, search = '', categoryId = null, brandId = null, featured = null) {
    try {
      let query = `
        SELECT pd.id, pd.name, pd.description, pd.short_description, pd.sku, 
               pd.price, pd.compare_price, pd.category_name, pd.brand_name,
               pd.is_active, pd.is_featured, pd.created_at, pd.updated_at,
               pd.variant_count, pd.total_stock
        FROM product_details pd
        WHERE pd.is_active = TRUE
      `;
      
      let countQuery = 'SELECT COUNT(*) as total FROM product_details pd WHERE pd.is_active = TRUE';
      let queryParams = [];
      let countParams = [];

      // Add search functionality
      if (search) {
        const searchCondition = `
          AND (pd.name LIKE ? 
          OR pd.description LIKE ? 
          OR pd.category_name LIKE ?
          OR pd.brand_name LIKE ?)
        `;
        query += searchCondition;
        countQuery += searchCondition;
        
        const searchParam = `%${search}%`;
        queryParams.push(searchParam, searchParam, searchParam, searchParam);
        countParams.push(searchParam, searchParam, searchParam, searchParam);
      }

      // Add category filter
      if (categoryId) {
        query += ' AND pd.id IN (SELECT id FROM products WHERE category_id = ?)';
        countQuery += ' AND pd.id IN (SELECT id FROM products WHERE category_id = ?)';
        queryParams.push(categoryId);
        countParams.push(categoryId);
      }

      // Add brand filter
      if (brandId) {
        query += ' AND pd.id IN (SELECT id FROM products WHERE brand_id = ?)';
        countQuery += ' AND pd.id IN (SELECT id FROM products WHERE brand_id = ?)';
        queryParams.push(brandId);
        countParams.push(brandId);
      }

      // Add featured filter
      if (featured !== null) {
        query += ' AND pd.is_featured = ?';
        countQuery += ' AND pd.is_featured = ?';
        queryParams.push(featured);
        countParams.push(featured);
      }

      // Add pagination
      query += ' ORDER BY pd.created_at DESC LIMIT ? OFFSET ?';
      queryParams.push(limit, offset);

      // Execute both queries
      const [productsResult] = await pool.execute(query, queryParams);
      const [countResult] = await pool.execute(countQuery, countParams);

      return {
        products: productsResult,
        total: countResult[0].total
      };
    } catch (error) {
      console.error('Database error in getProducts:', error);
      throw new Error(`Database query failed: ${error.message}`);
    }
  }

  async getProductById(id) {
    try {
      const query = `
        SELECT pd.*, 
               (SELECT JSON_ARRAYAGG(
                 JSON_OBJECT(
                   'id', pv.id,
                   'variant_name', pv.variant_name,
                   'sku', pv.sku,
                   'price', pv.price,
                   'stock_quantity', pv.stock_quantity
                 )
               ) FROM product_variants pv WHERE pv.product_id = pd.id AND pv.is_active = TRUE) as variants,
               (SELECT JSON_ARRAYAGG(
                 JSON_OBJECT(
                   'id', pi.id,
                   'image_url', pi.image_url,
                   'alt_text', pi.alt_text,
                   'is_primary', pi.is_primary
                 )
               ) FROM product_images pi WHERE pi.product_id = pd.id ORDER BY pi.sort_order) as images,
               (SELECT JSON_ARRAYAGG(
                 JSON_OBJECT(
                   'attribute_name', pa.attribute_name,
                   'attribute_value', pa.attribute_value
                 )
               ) FROM product_attributes pa WHERE pa.product_id = pd.id) as attributes
        FROM product_details pd 
        WHERE pd.id = ? AND pd.is_active = TRUE
      `;
      
      const [results] = await pool.execute(query, [id]);
      return results.length > 0 ? results[0] : null;
    } catch (error) {
      console.error('Database error in getProductById:', error);
      throw new Error(`Database query failed: ${error.message}`);
    }
  }

  // Categories operations
  async getCategories() {
    try {
      const query = `
        SELECT c.id, c.name, c.description, c.parent_id,
               GetCategoryProductCount(c.id) as product_count
        FROM categories c 
        WHERE c.is_active = TRUE
        ORDER BY c.name
      `;
      
      const [results] = await pool.execute(query);
      return results;
    } catch (error) {
      console.error('Database error in getCategories:', error);
      throw new Error(`Database query failed: ${error.message}`);
    }
  }

  async getCategoryById(id) {
    try {
      const query = `
        SELECT c.*, GetCategoryProductCount(c.id) as product_count
        FROM categories c 
        WHERE c.id = ? AND c.is_active = TRUE
      `;
      
      const [results] = await pool.execute(query, [id]);
      return results.length > 0 ? results[0] : null;
    } catch (error) {
      console.error('Database error in getCategoryById:', error);
      throw new Error(`Database query failed: ${error.message}`);
    }
  }

  // Brands operations
  async getBrands() {
    try {
      const query = `
        SELECT b.id, b.name, b.description, b.logo_url, b.website,
               COUNT(p.id) as product_count
        FROM brands b
        LEFT JOIN products p ON b.id = p.brand_id AND p.is_active = TRUE
        WHERE b.is_active = TRUE
        GROUP BY b.id, b.name, b.description, b.logo_url, b.website
        ORDER BY b.name
      `;
      
      const [results] = await pool.execute(query);
      return results;
    } catch (error) {
      console.error('Database error in getBrands:', error);
      throw new Error(`Database query failed: ${error.message}`);
    }
  }

  // Orders operations
  async getOrders(customerId = null, offset = 0, limit = 10) {
    try {
      let query = `
        SELECT o.id, o.order_number, o.customer_id, o.status, o.subtotal,
               o.tax_amount, o.shipping_amount, o.total_amount, o.currency,
               o.payment_status, o.created_at, o.updated_at,
               CONCAT(c.first_name, ' ', c.last_name) as customer_name,
               c.email as customer_email
        FROM orders o
        LEFT JOIN customers c ON o.customer_id = c.id
      `;
      
      let countQuery = 'SELECT COUNT(*) as total FROM orders o';
      let queryParams = [];
      let countParams = [];

      if (customerId) {
        query += ' WHERE o.customer_id = ?';
        countQuery += ' WHERE o.customer_id = ?';
        queryParams.push(customerId);
        countParams.push(customerId);
      }

      query += ' ORDER BY o.created_at DESC LIMIT ? OFFSET ?';
      queryParams.push(limit, offset);

      const [ordersResult] = await pool.execute(query, queryParams);
      const [countResult] = await pool.execute(countQuery, countParams);

      return {
        orders: ordersResult,
        total: countResult[0].total
      };
    } catch (error) {
      console.error('Database error in getOrders:', error);
      throw new Error(`Database query failed: ${error.message}`);
    }
  }

  async getOrderById(id) {
    try {
      const query = `
        SELECT o.*, 
               CONCAT(c.first_name, ' ', c.last_name) as customer_name,
               c.email as customer_email,
               (SELECT JSON_ARRAYAGG(
                 JSON_OBJECT(
                   'id', oi.id,
                   'product_id', oi.product_id,
                   'product_name', p.name,
                   'variant_id', oi.variant_id,
                   'variant_name', pv.variant_name,
                   'quantity', oi.quantity,
                   'unit_price', oi.unit_price,
                   'total_price', oi.total_price
                 )
               ) FROM order_items oi 
               LEFT JOIN products p ON oi.product_id = p.id
               LEFT JOIN product_variants pv ON oi.variant_id = pv.id
               WHERE oi.order_id = o.id) as items
        FROM orders o
        LEFT JOIN customers c ON o.customer_id = c.id
        WHERE o.id = ?
      `;
      
      const [results] = await pool.execute(query, [id]);
      return results.length > 0 ? results[0] : null;
    } catch (error) {
      console.error('Database error in getOrderById:', error);
      throw new Error(`Database query failed: ${error.message}`);
    }
  }

  // Customers operations
  async getCustomers(offset = 0, limit = 10, search = '') {
    try {
      let query = `
        SELECT c.id, c.email, c.first_name, c.last_name, c.phone,
               c.is_active, c.email_verified, c.created_at,
               COUNT(o.id) as total_orders,
               COALESCE(SUM(o.total_amount), 0) as total_spent
        FROM customers c
        LEFT JOIN orders o ON c.id = o.customer_id
      `;
      
      let countQuery = 'SELECT COUNT(*) as total FROM customers c';
      let queryParams = [];
      let countParams = [];

      if (search) {
        const searchCondition = `
          WHERE (c.first_name LIKE ? 
          OR c.last_name LIKE ? 
          OR c.email LIKE ?)
        `;
        query += searchCondition;
        countQuery += searchCondition;
        
        const searchParam = `%${search}%`;
        queryParams.push(searchParam, searchParam, searchParam);
        countParams.push(searchParam, searchParam, searchParam);
      }

      query += ` 
        GROUP BY c.id, c.email, c.first_name, c.last_name, c.phone,
                 c.is_active, c.email_verified, c.created_at
        ORDER BY c.created_at DESC 
        LIMIT ? OFFSET ?
      `;
      queryParams.push(limit, offset);

      const [customersResult] = await pool.execute(query, queryParams);
      const [countResult] = await pool.execute(countQuery, countParams);

      return {
        customers: customersResult,
        total: countResult[0].total
      };
    } catch (error) {
      console.error('Database error in getCustomers:', error);
      throw new Error(`Database query failed: ${error.message}`);
    }
  }

  // Dashboard statistics
  async getDashboardStats() {
    try {
      const queries = [
        'SELECT COUNT(*) as total_products FROM products WHERE is_active = TRUE',
        'SELECT COUNT(*) as total_categories FROM categories WHERE is_active = TRUE',
        'SELECT COUNT(*) as total_brands FROM brands WHERE is_active = TRUE',
        'SELECT COUNT(*) as total_customers FROM customers WHERE is_active = TRUE',
        'SELECT COUNT(*) as total_orders FROM orders',
        'SELECT COALESCE(SUM(total_amount), 0) as total_revenue FROM orders WHERE payment_status = "paid"',
        'SELECT COUNT(*) as pending_orders FROM orders WHERE status = "pending"',
        'SELECT COUNT(*) as featured_products FROM products WHERE is_featured = TRUE AND is_active = TRUE'
      ];

      const results = await Promise.all(
        queries.map(query => pool.execute(query))
      );

      return {
        total_products: results[0][0][0].total_products,
        total_categories: results[1][0][0].total_categories,
        total_brands: results[2][0][0].total_brands,
        total_customers: results[3][0][0].total_customers,
        total_orders: results[4][0][0].total_orders,
        total_revenue: results[5][0][0].total_revenue,
        pending_orders: results[6][0][0].pending_orders,
        featured_products: results[7][0][0].featured_products
      };
    } catch (error) {
      console.error('Database error in getDashboardStats:', error);
      throw new Error(`Database query failed: ${error.message}`);
    }
  }
}