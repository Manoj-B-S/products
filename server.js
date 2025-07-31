import express from 'express';
import cors from 'cors';
import dotenv from 'dotenv';
import { ecomRouter } from './routes/ecom.js';
import { errorHandler } from './middleware/errorHandler.js';
import { testConnection } from './database/mysql.js';

// Load environment variables
dotenv.config();

const app = express();
const PORT = process.env.PORT || 3000;

// Middleware
app.use(cors());
app.use(express.json());

// Routes
app.use('/api', ecomRouter);

// Root endpoint
app.get('/', (req, res) => {
  res.json({
    message: 'E-commerce REST API',
    version: '1.0.0',
    database: 'MySQL (E-commerce Schema)',
    endpoints: {
      'GET /api/products': 'List all products (with pagination, search, filters)',
      'GET /api/products/:id': 'Get a specific product by ID',
      'GET /api/products/featured': 'Get featured products',
      'GET /api/products/search': 'Search products',
      'GET /api/categories': 'Get all product categories',
      'GET /api/categories/:id': 'Get category by ID',
      'GET /api/categories/:id/products': 'Get products by category',
      'GET /api/brands': 'Get all brands',
      'GET /api/brands/:id/products': 'Get products by brand',
      'GET /api/orders': 'Get all orders',
      'GET /api/orders/:id': 'Get order by ID',
      'GET /api/customers': 'Get all customers',
      'GET /api/dashboard/stats': 'Get dashboard statistics'
    }
  });
});

// Error handling middleware
app.use(errorHandler);

// 404 handler
app.use('*', (req, res) => {
  res.status(404).json({
    error: 'Not Found',
    message: `Route ${req.originalUrl} not found`
  });
});

app.listen(PORT, async () => {
  // Test database connection on startup
  await testConnection();
  
  console.log(`🚀 Server running on http://localhost:${PORT}`);
  console.log(`📚 API Documentation available at http://localhost:${PORT}`);
  console.log(`🗄️  Database: MySQL`);
});