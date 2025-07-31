import { EcomDatabase } from '../database/ecomDatabase.js';

export class EcomService {
  constructor() {
    this.db = new EcomDatabase();
  }

  // Products services
  async getAllProducts(page = 1, limit = 10, search = '', categoryId = null, brandId = null, featured = null) {
    try {
      const offset = (page - 1) * limit;
      const result = await this.db.getProducts(offset, limit, search, categoryId, brandId, featured);
      
      return {
        products: result.products,
        totalItems: result.total,
        totalPages: Math.ceil(result.total / limit)
      };
    } catch (error) {
      throw new Error(`Failed to fetch products: ${error.message}`);
    }
  }

  async getProductById(id) {
    try {
      const product = await this.db.getProductById(id);
      if (product) {
        // Parse JSON fields
        product.variants = product.variants ? JSON.parse(product.variants) : [];
        product.images = product.images ? JSON.parse(product.images) : [];
        product.attributes = product.attributes ? JSON.parse(product.attributes) : [];
      }
      return product;
    } catch (error) {
      throw new Error(`Failed to fetch product: ${error.message}`);
    }
  }

  async getFeaturedProducts(page = 1, limit = 10) {
    try {
      return await this.getAllProducts(page, limit, '', null, null, true);
    } catch (error) {
      throw new Error(`Failed to fetch featured products: ${error.message}`);
    }
  }

  // Categories services
  async getCategories() {
    try {
      return await this.db.getCategories();
    } catch (error) {
      throw new Error(`Failed to fetch categories: ${error.message}`);
    }
  }

  async getCategoryById(id) {
    try {
      return await this.db.getCategoryById(id);
    } catch (error) {
      throw new Error(`Failed to fetch category: ${error.message}`);
    }
  }

  async getProductsByCategory(categoryId, page = 1, limit = 10) {
    try {
      return await this.getAllProducts(page, limit, '', categoryId);
    } catch (error) {
      throw new Error(`Failed to fetch products by category: ${error.message}`);
    }
  }

  // Brands services
  async getBrands() {
    try {
      return await this.db.getBrands();
    } catch (error) {
      throw new Error(`Failed to fetch brands: ${error.message}`);
    }
  }

  async getProductsByBrand(brandId, page = 1, limit = 10) {
    try {
      return await this.getAllProducts(page, limit, '', null, brandId);
    } catch (error) {
      throw new Error(`Failed to fetch products by brand: ${error.message}`);
    }
  }

  // Orders services
  async getOrders(customerId = null, page = 1, limit = 10) {
    try {
      const offset = (page - 1) * limit;
      const result = await this.db.getOrders(customerId, offset, limit);
      
      return {
        orders: result.orders,
        totalItems: result.total,
        totalPages: Math.ceil(result.total / limit)
      };
    } catch (error) {
      throw new Error(`Failed to fetch orders: ${error.message}`);
    }
  }

  async getOrderById(id) {
    try {
      const order = await this.db.getOrderById(id);
      if (order && order.items) {
        order.items = JSON.parse(order.items);
      }
      return order;
    } catch (error) {
      throw new Error(`Failed to fetch order: ${error.message}`);
    }
  }

  // Customers services
  async getCustomers(page = 1, limit = 10, search = '') {
    try {
      const offset = (page - 1) * limit;
      const result = await this.db.getCustomers(offset, limit, search);
      
      return {
        customers: result.customers,
        totalItems: result.total,
        totalPages: Math.ceil(result.total / limit)
      };
    } catch (error) {
      throw new Error(`Failed to fetch customers: ${error.message}`);
    }
  }

  // Dashboard services
  async getDashboardStats() {
    try {
      return await this.db.getDashboardStats();
    } catch (error) {
      throw new Error(`Failed to fetch dashboard stats: ${error.message}`);
    }
  }

  // Search services
  async searchProducts(query, page = 1, limit = 10) {
    try {
      return await this.getAllProducts(page, limit, query);
    } catch (error) {
      throw new Error(`Failed to search products: ${error.message}`);
    }
  }
}