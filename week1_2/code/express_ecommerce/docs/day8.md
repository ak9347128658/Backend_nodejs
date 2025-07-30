# Day 8: Input Validation, Error Handling, and Security Improvements

## 🎯 Goal

Enhance the application's security, implement comprehensive input validation, improve error handling, and add rate limiting to protect the API from abuse.

## 📝 Tasks

1. Implement comprehensive input validation for all routes
2. Create a centralized validation middleware
3. Enhance error handling with detailed error classes
4. Add rate limiting for sensitive endpoints
5. Implement security headers
6. Add request logging middleware
7. Test security features and validation

## 📂 Folder & File Structure (New/Updated Files)

```
express_ecommerce/
├── middleware/
│   ├── validators/
│   │   ├── authValidator.js (new)
│   │   ├── productValidator.js (new)
│   │   ├── cartValidator.js (new)
│   │   └── orderValidator.js (new)
│   ├── errorHandler.js (updated)
│   ├── rateLimiter.js (new)
│   ├── requestLogger.js (new)
│   └── securityHeaders.js (new)
├── utils/
│   └── errorTypes.js (new)
├── routes/
│   ├── authRoutes.js (updated)
│   ├── productRoutes.js (updated)
│   ├── cartRoutes.js (updated)
│   └── orderRoutes.js (updated)
└── app.js (updated)
```

## 📦 Dependencies to Install

```bash
npm install express-rate-limit helmet winston
```

## 🖥️ Code Snippets

### utils/errorTypes.js

```javascript
/**
 * Custom error classes for better error handling
 */

class AppError extends Error {
  constructor(message, statusCode) {
    super(message);
    this.statusCode = statusCode;
    this.status = `${statusCode}`.startsWith('4') ? 'fail' : 'error';
    this.isOperational = true;
    
    Error.captureStackTrace(this, this.constructor);
  }
}

class ValidationError extends AppError {
  constructor(errors) {
    super('Validation failed', 400);
    this.errors = errors;
  }
}

class NotFoundError extends AppError {
  constructor(message = 'Resource not found') {
    super(message, 404);
  }
}

class UnauthorizedError extends AppError {
  constructor(message = 'Unauthorized access') {
    super(message, 401);
  }
}

class ForbiddenError extends AppError {
  constructor(message = 'Access forbidden') {
    super(message, 403);
  }
}

module.exports = {
  AppError,
  ValidationError,
  NotFoundError,
  UnauthorizedError,
  ForbiddenError
};
```

### middleware/errorHandler.js (Updated)

```javascript
const { AppError, ValidationError } = require('../utils/errorTypes');

/**
 * Global error handling middleware
 */
const errorHandler = (err, req, res, next) => {
  console.error(err);
  
  // Handle validation errors from express-validator
  if (err.array && typeof err.array === 'function') {
    const validationErrors = err.array().map(error => ({
      field: error.param,
      message: error.msg
    }));
    
    return res.status(400).json({
      status: 'error',
      message: 'Validation failed',
      errors: validationErrors
    });
  }
  
  // Handle custom ValidationError
  if (err instanceof ValidationError) {
    return res.status(err.statusCode).json({
      status: err.status,
      message: err.message,
      errors: err.errors
    });
  }
  
  // Handle known operational errors
  if (err instanceof AppError) {
    return res.status(err.statusCode).json({
      status: err.status,
      message: err.message
    });
  }
  
  // Handle Postgres unique constraint violations
  if (err.code === '23505') {
    return res.status(400).json({
      status: 'error',
      message: 'Duplicate value violates unique constraint',
      error: err.detail
    });
  }
  
  // Handle Postgres foreign key violations
  if (err.code === '23503') {
    return res.status(400).json({
      status: 'error',
      message: 'Foreign key constraint violation',
      error: err.detail
    });
  }
  
  // Default error for unexpected errors (don't leak details in production)
  const statusCode = err.statusCode || 500;
  const message = process.env.NODE_ENV === 'production' && statusCode === 500
    ? 'Internal server error'
    : err.message;
  
  res.status(statusCode).json({
    status: 'error',
    message,
    ...(process.env.NODE_ENV !== 'production' && { stack: err.stack })
  });
};

module.exports = errorHandler;
```

### middleware/validators/authValidator.js

```javascript
const { body, param } = require('express-validator');
const { validate } = require('./validator');

const registerValidator = validate([
  body('username')
    .notEmpty().withMessage('Username is required')
    .isLength({ min: 3, max: 30 }).withMessage('Username must be between 3 and 30 characters')
    .matches(/^[a-zA-Z0-9_]+$/).withMessage('Username can only contain letters, numbers and underscores'),
    
  body('email')
    .notEmpty().withMessage('Email is required')
    .isEmail().withMessage('Must be a valid email address')
    .normalizeEmail(),
    
  body('password')
    .notEmpty().withMessage('Password is required')
    .isLength({ min: 6 }).withMessage('Password must be at least 6 characters')
    .matches(/\d/).withMessage('Password must contain at least one number')
    .matches(/[a-zA-Z]/).withMessage('Password must contain at least one letter')
]);

const loginValidator = validate([
  body('email')
    .notEmpty().withMessage('Email is required')
    .isEmail().withMessage('Must be a valid email address')
    .normalizeEmail(),
    
  body('password')
    .notEmpty().withMessage('Password is required')
]);

const updateProfileValidator = validate([
  body('username')
    .optional()
    .isLength({ min: 3, max: 30 }).withMessage('Username must be between 3 and 30 characters')
    .matches(/^[a-zA-Z0-9_]+$/).withMessage('Username can only contain letters, numbers and underscores'),
    
  body('currentPassword')
    .if(body('newPassword').exists())
    .notEmpty().withMessage('Current password is required to set a new password'),
    
  body('newPassword')
    .optional()
    .isLength({ min: 6 }).withMessage('New password must be at least 6 characters')
    .matches(/\d/).withMessage('New password must contain at least one number')
    .matches(/[a-zA-Z]/).withMessage('New password must contain at least one letter')
]);

const updateUserRoleValidator = validate([
  param('id')
    .isInt({ min: 1 }).withMessage('User ID must be a positive integer'),
    
  body('role')
    .isIn(['user', 'admin']).withMessage('Role must be either "user" or "admin"')
]);

module.exports = {
  registerValidator,
  loginValidator,
  updateProfileValidator,
  updateUserRoleValidator
};
```

### middleware/validators/productValidator.js

```javascript
const { body, param, query } = require('express-validator');
const { validate } = require('./validator');

const createProductValidator = validate([
  body('name')
    .notEmpty().withMessage('Product name is required')
    .isLength({ min: 3, max: 100 }).withMessage('Product name must be between 3 and 100 characters'),
    
  body('description')
    .notEmpty().withMessage('Product description is required'),
    
  body('price')
    .notEmpty().withMessage('Product price is required')
    .isFloat({ gt: 0 }).withMessage('Price must be a positive number')
]);

const updateProductValidator = validate([
  param('id')
    .isInt({ min: 1 }).withMessage('Product ID must be a positive integer'),
    
  body('name')
    .optional()
    .isLength({ min: 3, max: 100 }).withMessage('Product name must be between 3 and 100 characters'),
    
  body('price')
    .optional()
    .isFloat({ gt: 0 }).withMessage('Price must be a positive number')
]);

const getProductValidator = validate([
  param('id')
    .isInt({ min: 1 }).withMessage('Product ID must be a positive integer')
]);

const queryProductsValidator = validate([
  query('page')
    .optional()
    .isInt({ min: 1 }).withMessage('Page must be a positive integer'),
    
  query('limit')
    .optional()
    .isInt({ min: 1, max: 100 }).withMessage('Limit must be between 1 and 100')
]);

const searchProductsValidator = validate([
  query('query')
    .notEmpty().withMessage('Search query is required'),
    
  query('page')
    .optional()
    .isInt({ min: 1 }).withMessage('Page must be a positive integer'),
    
  query('limit')
    .optional()
    .isInt({ min: 1, max: 100 }).withMessage('Limit must be between 1 and 100')
]);

module.exports = {
  createProductValidator,
  updateProductValidator,
  getProductValidator,
  queryProductsValidator,
  searchProductsValidator
};
```

### middleware/validators/cartValidator.js

```javascript
const { body, param } = require('express-validator');
const { validate } = require('./validator');

const addToCartValidator = validate([
  body('productId')
    .isInt({ min: 1 }).withMessage('Product ID must be a positive integer'),
    
  body('quantity')
    .optional()
    .isInt({ min: 1 }).withMessage('Quantity must be a positive integer')
]);

const updateCartItemValidator = validate([
  param('itemId')
    .isInt({ min: 1 }).withMessage('Item ID must be a positive integer'),
    
  body('quantity')
    .isInt({ min: 1 }).withMessage('Quantity must be a positive integer')
]);

const removeCartItemValidator = validate([
  param('itemId')
    .isInt({ min: 1 }).withMessage('Item ID must be a positive integer')
]);

module.exports = {
  addToCartValidator,
  updateCartItemValidator,
  removeCartItemValidator
};
```

### middleware/validators/orderValidator.js

```javascript
const { body, param, query } = require('express-validator');
const { validate } = require('./validator');

const createOrderValidator = validate([
  body('shippingAddress')
    .notEmpty().withMessage('Shipping address is required')
    .isLength({ min: 10 }).withMessage('Please provide a complete shipping address'),
    
  body('paymentMethod')
    .notEmpty().withMessage('Payment method is required')
    .isIn(['Credit Card', 'PayPal', 'Bank Transfer', 'Cash on Delivery'])
    .withMessage('Invalid payment method')
]);

const updateOrderStatusValidator = validate([
  param('id')
    .isInt({ min: 1 }).withMessage('Order ID must be a positive integer'),
    
  body('status')
    .isIn(['pending', 'processing', 'shipped', 'delivered', 'cancelled'])
    .withMessage('Invalid order status')
]);

const getOrderValidator = validate([
  param('id')
    .isInt({ min: 1 }).withMessage('Order ID must be a positive integer')
]);

const queryOrdersValidator = validate([
  query('page')
    .optional()
    .isInt({ min: 1 }).withMessage('Page must be a positive integer'),
    
  query('limit')
    .optional()
    .isInt({ min: 1, max: 100 }).withMessage('Limit must be between 1 and 100'),
    
  query('status')
    .optional()
    .isIn(['pending', 'processing', 'shipped', 'delivered', 'cancelled'])
    .withMessage('Invalid order status')
]);

module.exports = {
  createOrderValidator,
  updateOrderStatusValidator,
  getOrderValidator,
  queryOrdersValidator
};
```

### middleware/validators/validator.js

```javascript
const { validationResult } = require('express-validator');
const { ValidationError } = require('../../utils/errorTypes');

/**
 * Validation middleware factory
 * @param {Array} validations - Array of express-validator validations
 * @returns {Function} Express middleware function
 */
const validate = (validations) => {
  return async (req, res, next) => {
    // Execute all validations
    await Promise.all(validations.map(validation => validation.run(req)));
    
    const errors = validationResult(req);
    
    if (errors.isEmpty()) {
      return next();
    }
    
    // Format validation errors
    const formattedErrors = errors.array().map(error => ({
      field: error.param,
      message: error.msg
    }));
    
    // Throw custom ValidationError
    next(new ValidationError(formattedErrors));
  };
};

module.exports = { validate };
```

### middleware/rateLimiter.js

```javascript
const rateLimit = require('express-rate-limit');

/**
 * Standard API rate limiter (100 requests per 15 minutes)
 */
const standardLimiter = rateLimit({
  windowMs: 15 * 60 * 1000, // 15 minutes
  max: 100, // 100 requests per window
  standardHeaders: true,
  legacyHeaders: false,
  message: {
    status: 'error',
    message: 'Too many requests from this IP, please try again later'
  }
});

/**
 * Strict rate limiter for auth endpoints (10 attempts per 15 minutes)
 */
const authLimiter = rateLimit({
  windowMs: 15 * 60 * 1000, // 15 minutes
  max: 10, // 10 login/register attempts per window
  standardHeaders: true,
  legacyHeaders: false,
  message: {
    status: 'error',
    message: 'Too many authentication attempts from this IP, please try again later'
  }
});

module.exports = {
  standardLimiter,
  authLimiter
};
```

### middleware/requestLogger.js

```javascript
const winston = require('winston');

// Create logger instance
const logger = winston.createLogger({
  level: 'info',
  format: winston.format.combine(
    winston.format.timestamp(),
    winston.format.json()
  ),
  transports: [
    new winston.transports.Console(),
    new winston.transports.File({ 
      filename: 'logs/error.log', 
      level: 'error' 
    }),
    new winston.transports.File({ 
      filename: 'logs/combined.log' 
    })
  ]
});

// Request logging middleware
const requestLogger = (req, res, next) => {
  // Log request details
  const startTime = Date.now();
  
  // Log when response finishes
  res.on('finish', () => {
    const duration = Date.now() - startTime;
    
    logger.info({
      method: req.method,
      url: req.originalUrl,
      status: res.statusCode,
      duration: `${duration}ms`,
      ip: req.ip,
      userAgent: req.get('user-agent') || 'unknown'
    });
  });
  
  next();
};

// Export both the logger and middleware
module.exports = {
  logger,
  requestLogger
};
```

### middleware/securityHeaders.js

```javascript
const helmet = require('helmet');

// Configure security headers
const securityHeaders = helmet({
  contentSecurityPolicy: {
    directives: {
      defaultSrc: ["'self'"],
      styleSrc: ["'self'", "'unsafe-inline'"],
      imgSrc: ["'self'", "data:"],
      scriptSrc: ["'self'"]
    }
  },
  // Other helmet defaults are enabled automatically
});

module.exports = securityHeaders;
```

### app.js (Updated)

```javascript
const express = require('express');
const cors = require('cors');
const path = require('path');
const { requestLogger } = require('./middleware/requestLogger');
const securityHeaders = require('./middleware/securityHeaders');
const { standardLimiter, authLimiter } = require('./middleware/rateLimiter');
const authRoutes = require('./routes/authRoutes');
const adminRoutes = require('./routes/adminRoutes');
const productRoutes = require('./routes/productRoutes');
const cartRoutes = require('./routes/cartRoutes');
const orderRoutes = require('./routes/orderRoutes');
const errorHandler = require('./middleware/errorHandler');

// Initialize Express app
const app = express();

// Apply security headers
app.use(securityHeaders);

// Request logging
app.use(requestLogger);

// Apply rate limiting
app.use('/api/', standardLimiter);
app.use('/api/auth', authLimiter);

// Standard middleware
app.use(cors());
app.use(express.json());
app.use(express.urlencoded({ extended: true }));

// Serve uploaded files statically
app.use('/uploads', express.static(path.join(__dirname, 'media/uploads')));

// Routes
app.use('/api/auth', authRoutes);
app.use('/api/admin', adminRoutes);
app.use('/api/products', productRoutes);
app.use('/api/cart', cartRoutes);
app.use('/api/orders', orderRoutes);

// Basic route for testing
app.get('/', (req, res) => {
  res.json({ message: 'Welcome to the E-commerce API' });
});

// 404 handler
app.use((req, res, next) => {
  res.status(404).json({
    status: 'error',
    message: 'Route not found'
  });
});

// Error handling middleware (should be last)
app.use(errorHandler);

module.exports = app;
```

## 🔒 Security & Validation Notes

- Input validation is applied to all API endpoints
- Rate limiting protects against brute force and DoS attacks
- Security headers prevent common web vulnerabilities
- Detailed error handling improves security by not leaking sensitive information
- Request logging helps with monitoring and debugging
- Custom error types make error handling more consistent

## 🧪 API Testing Tips

### Testing Rate Limiting

```bash
# Run this repeatedly to trigger rate limiting
curl -X POST http://localhost:3000/api/auth/login \
  -H "Content-Type: application/json" \
  -d '{"email":"test@example.com","password":"password123"}'
```

### Testing Validation

```bash
# Test with invalid data
curl -X POST http://localhost:3000/api/products \
  -H "Authorization: Bearer ADMIN_JWT_TOKEN" \
  -H "Content-Type: application/json" \
  -d '{"name":"T","price":-10}'
```

## 🚀 Day 8 Implementation Steps

1. **Set up custom error types**:
   - Create error classes for different scenarios
   - Implement consistent error response format

2. **Enhance error handler**:
   - Update middleware to handle different error types
   - Add specific handling for database errors

3. **Create validation middleware**:
   - Implement validators for each entity
   - Add detailed validation rules

4. **Implement security features**:
   - Add rate limiting for API protection
   - Set up security headers with Helmet

5. **Add request logging**:
   - Configure Winston for logging
   - Create request logging middleware

6. **Update routes**:
   - Apply validators to all routes
   - Add rate limiting to sensitive endpoints

7. **Test security features**:
   - Test validation with invalid data
   - Test rate limiting
   - Verify security headers

## 📝 Notes and Best Practices

- Apply validation early in the request lifecycle
- Use appropriate rate limiting for different endpoints
- Structure error responses consistently
- Log requests and errors for monitoring and debugging
- Sanitize user inputs to prevent injection attacks
- Use proper HTTP status codes
- Implement proper security headers
- Don't leak sensitive information in error responses
- Use custom error types for better error handling

## 🔄 Next Steps

On Day 9, we'll focus on testing, debugging, and performance optimization.
