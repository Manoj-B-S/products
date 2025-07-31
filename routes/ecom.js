import express from 'express';
import { EcomService } from '../services/ecomService.js';

const router = express.Router();
const ecomService = new EcomService();

// Products routes
router.get('/products', async (req, res, next) => {
  try {
    const page = parseInt(req.query.page) || 1;
    const limit = parseInt(req.query.limit) || 10;
    const search = req.query.search || '';
    const categoryId = req.query.category_id ? parseInt(req.query.category_id) : null;
    const brandId = req.query.brand_id ? parseInt(req.query.brand_id) : null;
    const featured = req.query.featured === 'true' ? true : req.query.featured === 'false' ? false : null;

    if (page < 1 || limit < 1 || limit > 100) {
      return res.status(400).json({
        error: 'Bad Request',
        message: 'Invalid pagination parameters. Page must be >= 1, limit must be between 1 and 100.'
      });
    }

    const result = await ecomService.getAllProducts(page, limit, search, categoryId, brandId, featured);
    
    res.json({
      success: true,
      data: result.products,
      pagination: {
        currentPage: page,
        totalPages: result.totalPages,
        totalItems: result.totalItems,
        itemsPerPage: limit,
        hasNextPage: page < result.totalPages,
        hasPrevPage: page > 1
      }
    });
  } catch (error) {
    next(error);
  }
});

router.get('/products/featured', async (req, res, next) => {
  try {
    const page = parseInt(req.query.page) || 1;
    const limit = parseInt(req.query.limit) || 10;

    const result = await ecomService.getFeaturedProducts(page, limit);
    
    res.json({
      success: true,
      data: result.products,
      pagination: {
        currentPage: page,
        totalPages: result.totalPages,
        totalItems: result.totalItems,
        itemsPerPage: limit,
        hasNextPage: page < result.totalPages,
        hasPrevPage: page > 1
      }
    });
  } catch (error) {
    next(error);
  }
});

router.get('/products/search', async (req, res, next) => {
  try {
    const query = req.query.q || '';
    const page = parseInt(req.query.page) || 1;
    const limit = parseInt(req.query.limit) || 10;

    if (!query.trim()) {
      return res.status(400).json({
        error: 'Bad Request',
        message: 'Search query is required'
      });
    }

    const result = await ecomService.searchProducts(query, page, limit);
    
    res.json({
      success: true,
      data: result.products,
      query: query,
      pagination: {
        currentPage: page,
        totalPages: result.totalPages,
        totalItems: result.totalItems,
        itemsPerPage: limit,
        hasNextPage: page < result.totalPages,
        hasPrevPage: page > 1
      }
    });
  } catch (error) {
    next(error);
  }
});

router.get('/products/:id', async (req, res, next) => {
  try {
    const { id } = req.params;

    if (!/^\d+$/.test(id)) {
      return res.status(400).json({
        error: 'Bad Request',
        message: 'Invalid product ID format. ID must be a positive integer.'
      });
    }

    const productId = parseInt(id);
    const product = await ecomService.getProductById(productId);

    if (!product) {
      return res.status(404).json({
        error: 'Not Found',
        message: `Product with ID ${productId} not found.`
      });
    }

    res.json({
      success: true,
      data: product
    });
  } catch (error) {
    next(error);
  }
});

// Categories routes
router.get('/categories', async (req, res, next) => {
  try {
    const categories = await ecomService.getCategories();
    
    res.json({
      success: true,
      data: categories
    });
  } catch (error) {
    next(error);
  }
});

router.get('/categories/:id', async (req, res, next) => {
  try {
    const { id } = req.params;

    if (!/^\d+$/.test(id)) {
      return res.status(400).json({
        error: 'Bad Request',
        message: 'Invalid category ID format. ID must be a positive integer.'
      });
    }

    const categoryId = parseInt(id);
    const category = await ecomService.getCategoryById(categoryId);

    if (!category) {
      return res.status(404).json({
        error: 'Not Found',
        message: `Category with ID ${categoryId} not found.`
      });
    }

    res.json({
      success: true,
      data: category
    });
  } catch (error) {
    next(error);
  }
});

router.get('/categories/:id/products', async (req, res, next) => {
  try {
    const { id } = req.params;
    const page = parseInt(req.query.page) || 1;
    const limit = parseInt(req.query.limit) || 10;

    if (!/^\d+$/.test(id)) {
      return res.status(400).json({
        error: 'Bad Request',
        message: 'Invalid category ID format. ID must be a positive integer.'
      });
    }

    const categoryId = parseInt(id);
    const result = await ecomService.getProductsByCategory(categoryId, page, limit);
    
    res.json({
      success: true,
      data: result.products,
      pagination: {
        currentPage: page,
        totalPages: result.totalPages,
        totalItems: result.totalItems,
        itemsPerPage: limit,
        hasNextPage: page < result.totalPages,
        hasPrevPage: page > 1
      }
    });
  } catch (error) {
    next(error);
  }
});

// Brands routes
router.get('/brands', async (req, res, next) => {
  try {
    const brands = await ecomService.getBrands();
    
    res.json({
      success: true,
      data: brands
    });
  } catch (error) {
    next(error);
  }
});

router.get('/brands/:id/products', async (req, res, next) => {
  try {
    const { id } = req.params;
    const page = parseInt(req.query.page) || 1;
    const limit = parseInt(req.query.limit) || 10;

    if (!/^\d+$/.test(id)) {
      return res.status(400).json({
        error: 'Bad Request',
        message: 'Invalid brand ID format. ID must be a positive integer.'
      });
    }

    const brandId = parseInt(id);
    const result = await ecomService.getProductsByBrand(brandId, page, limit);
    
    res.json({
      success: true,
      data: result.products,
      pagination: {
        currentPage: page,
        totalPages: result.totalPages,
        totalItems: result.totalItems,
        itemsPerPage: limit,
        hasNextPage: page < result.totalPages,
        hasPrevPage: page > 1
      }
    });
  } catch (error) {
    next(error);
  }
});

// Orders routes
router.get('/orders', async (req, res, next) => {
  try {
    const page = parseInt(req.query.page) || 1;
    const limit = parseInt(req.query.limit) || 10;
    const customerId = req.query.customer_id ? parseInt(req.query.customer_id) : null;

    if (page < 1 || limit < 1 || limit > 100) {
      return res.status(400).json({
        error: 'Bad Request',
        message: 'Invalid pagination parameters. Page must be >= 1, limit must be between 1 and 100.'
      });
    }

    const result = await ecomService.getOrders(customerId, page, limit);
    
    res.json({
      success: true,
      data: result.orders,
      pagination: {
        currentPage: page,
        totalPages: result.totalPages,
        totalItems: result.totalItems,
        itemsPerPage: limit,
        hasNextPage: page < result.totalPages,
        hasPrevPage: page > 1
      }
    });
  } catch (error) {
    next(error);
  }
});

router.get('/orders/:id', async (req, res, next) => {
  try {
    const { id } = req.params;

    if (!/^\d+$/.test(id)) {
      return res.status(400).json({
        error: 'Bad Request',
        message: 'Invalid order ID format. ID must be a positive integer.'
      });
    }

    const orderId = parseInt(id);
    const order = await ecomService.getOrderById(orderId);

    if (!order) {
      return res.status(404).json({
        error: 'Not Found',
        message: `Order with ID ${orderId} not found.`
      });
    }

    res.json({
      success: true,
      data: order
    });
  } catch (error) {
    next(error);
  }
});

// Customers routes
router.get('/customers', async (req, res, next) => {
  try {
    const page = parseInt(req.query.page) || 1;
    const limit = parseInt(req.query.limit) || 10;
    const search = req.query.search || '';

    if (page < 1 || limit < 1 || limit > 100) {
      return res.status(400).json({
        error: 'Bad Request',
        message: 'Invalid pagination parameters. Page must be >= 1, limit must be between 1 and 100.'
      });
    }

    const result = await ecomService.getCustomers(page, limit, search);
    
    res.json({
      success: true,
      data: result.customers,
      pagination: {
        currentPage: page,
        totalPages: result.totalPages,
        totalItems: result.totalItems,
        itemsPerPage: limit,
        hasNextPage: page < result.totalPages,
        hasPrevPage: page > 1
      }
    });
  } catch (error) {
    next(error);
  }
});

// Dashboard routes
router.get('/dashboard/stats', async (req, res, next) => {
  try {
    const stats = await ecomService.getDashboardStats();
    
    res.json({
      success: true,
      data: stats
    });
  } catch (error) {
    next(error);
  }
});

export { router as ecomRouter };