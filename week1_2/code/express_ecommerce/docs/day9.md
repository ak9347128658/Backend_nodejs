# Day 9: Testing, Debugging, and Performance Optimization

## 🎯 Goal

Implement testing, identify and fix bugs, and optimize the application's performance.

## 📝 Tasks

1. Set up testing environment and tools
2. Create unit tests for key functionalities
3. Implement integration tests for API endpoints
4. Add database query optimization
5. Implement response caching for frequently accessed data
6. Add request timeout handling
7. Test and analyze application performance

## 📂 Folder & File Structure (New/Updated Files)

```
express_ecommerce/
├── tests/
│   ├── unit/
│   │   ├── models.test.js (new)
│   │   └── utils.test.js (new)
│   ├── integration/
│   │   ├── auth.test.js (new)
│   │   ├── products.test.js (new)
│   │   ├── cart.test.js (new)
│   │   └── orders.test.js (new)
│   └── setup.js (new)
├── middleware/
│   ├── cache.js (new)
│   └── timeout.js (new)
├── config/
│   └── db.js (updated)
├── models/
│   ├── productQueries.js (updated)
│   └── orderQueries.js (updated)
├── app.js (updated)
└── package.json (updated)
```

## 📦 Dependencies to Install

```bash
npm install --save-dev jest supertest node-mocks-http
npm install express-timeout-handler memory-cache
```

## 🖥️ Code Snippets

### package.json (Test Scripts)

```json
"scripts": {
  "start": "node server.js",
  "dev": "nodemon server.js",
  "test": "jest --verbose",
  "test:unit": "jest --verbose tests/unit",
  "test:integration": "jest --verbose tests/integration"
}
```

### tests/setup.js

```javascript
/**
 * Test Setup File
 * 
 * This file sets up the environment for testing.
 */

// Set environment to test
process.env.NODE_ENV = 'test';

// Other test configuration can be added here
const originalEnv = process.env;

// Restore original environment after tests
afterAll(() => {
  process.env = originalEnv;
});
```

### tests/unit/utils.test.js

```javascript
const { generateToken, verifyToken } = require('../../utils/jwtHelper');
const { AppError, ValidationError } = require('../../utils/errorTypes');

// Mock environment variables for testing
process.env.JWT_SECRET = 'test-secret';
process.env.JWT_EXPIRES_IN = '1h';

describe('JWT Helper', () => {
  const userId = 1;
  const userRole = 'user';
  
  test('should generate a valid JWT token', () => {
    const token = generateToken(userId, userRole);
    expect(token).toBeDefined();
    expect(typeof token).toBe('string');
  });
  
  test('should verify a valid token', () => {
    const token = generateToken(userId, userRole);
    const decoded = verifyToken(token);
    
    expect(decoded).toBeDefined();
    expect(decoded.id).toBe(userId);
    expect(decoded.role).toBe(userRole);
  });
  
  test('should throw error for invalid token', () => {
    expect(() => {
      verifyToken('invalid-token');
    }).toThrow();
  });
});

describe('Error Types', () => {
  test('should create AppError with correct properties', () => {
    const error = new AppError('Test error', 400);
    
    expect(error).toBeDefined();
    expect(error.message).toBe('Test error');
    expect(error.statusCode).toBe(400);
    expect(error.status).toBe('fail');
    expect(error.isOperational).toBe(true);
  });
  
  test('should create ValidationError with errors array', () => {
    const validationErrors = [
      { field: 'email', message: 'Invalid email' }
    ];
    
    const error = new ValidationError(validationErrors);
    
    expect(error).toBeDefined();
    expect(error.message).toBe('Validation failed');
    expect(error.statusCode).toBe(400);
    expect(error.errors).toEqual(validationErrors);
  });
});
```

### tests/unit/models.test.js

```javascript
const pool = require('../../config/db');
const userQueries = require('../../models/userQueries');
const productQueries = require('../../models/productQueries');

// Mock the pool
jest.mock('../../config/db', () => ({
  query: jest.fn()
}));

describe('User Queries', () => {
  afterEach(() => {
    jest.clearAllMocks();
  });
  
  test('findUserByEmail should return user when found', async () => {
    const mockUser = {
      id: 1,
      username: 'testuser',
      email: 'test@example.com',
      role: 'user'
    };
    
    pool.query.mockResolvedValue({
      rows: [mockUser]
    });
    
    const result = await userQueries.findUserByEmail('test@example.com');
    
    expect(result).toEqual(mockUser);
    expect(pool.query).toHaveBeenCalledWith(
      expect.any(String),
      ['test@example.com']
    );
  });
  
  test('findUserByEmail should return undefined when user not found', async () => {
    pool.query.mockResolvedValue({
      rows: []
    });
    
    const result = await userQueries.findUserByEmail('nonexistent@example.com');
    
    expect(result).toBeUndefined();
    expect(pool.query).toHaveBeenCalledWith(
      expect.any(String),
      ['nonexistent@example.com']
    );
  });
  
  // Add more tests for other user queries...
});

describe('Product Queries', () => {
  afterEach(() => {
    jest.clearAllMocks();
  });
  
  test('findProductById should return product when found', async () => {
    const mockProduct = {
      id: 1,
      name: 'Test Product',
      description: 'Test description',
      price: '29.99'
    };
    
    pool.query.mockResolvedValue({
      rows: [mockProduct]
    });
    
    const result = await productQueries.findProductById(1);
    
    expect(result).toEqual(mockProduct);
    expect(pool.query).toHaveBeenCalledWith(
      expect.any(String),
      [1]
    );
  });
  
  test('findProductById should return undefined when product not found', async () => {
    pool.query.mockResolvedValue({
      rows: []
    });
    
    const result = await productQueries.findProductById(999);
    
    expect(result).toBeUndefined();
    expect(pool.query).toHaveBeenCalledWith(
      expect.any(String),
      [999]
    );
  });
  
  // Add more tests for other product queries...
});
```

### tests/integration/auth.test.js

```javascript
const request = require('supertest');
const app = require('../../app');
const pool = require('../../config/db');
const bcrypt = require('bcrypt');

// Use a test database
process.env.DB_NAME = 'ecommerce_test';

describe('Auth Endpoints', () => {
  let testUser;
  
  beforeAll(async () => {
    // Set up test database and create test user
    const hashedPassword = await bcrypt.hash('password123', 10);
    
    await pool.query(`
      INSERT INTO users (username, email, password, role)
      VALUES ($1, $2, $3, $4)
      RETURNING id, username, email, role
    `, ['testuser', 'test@example.com', hashedPassword, 'user']);
    
    const result = await pool.query('SELECT * FROM users WHERE email = $1', ['test@example.com']);
    testUser = result.rows[0];
  });
  
  afterAll(async () => {
    // Clean up test database
    await pool.query('DELETE FROM users');
    await pool.end();
  });
  
  describe('POST /api/auth/register', () => {
    test('should register a new user', async () => {
      const res = await request(app)
        .post('/api/auth/register')
        .send({
          username: 'newuser',
          email: 'new@example.com',
          password: 'newpassword123'
        });
      
      expect(res.statusCode).toEqual(201);
      expect(res.body.status).toEqual('success');
      expect(res.body.data).toHaveProperty('id');
      expect(res.body.data.username).toEqual('newuser');
      expect(res.body.data.email).toEqual('new@example.com');
      expect(res.body.data).not.toHaveProperty('password');
    });
    
    test('should reject duplicate email', async () => {
      const res = await request(app)
        .post('/api/auth/register')
        .send({
          username: 'duplicate',
          email: 'test@example.com', // Already exists
          password: 'password123'
        });
      
      expect(res.statusCode).toEqual(400);
      expect(res.body.status).toEqual('error');
    });
    
    test('should validate input fields', async () => {
      const res = await request(app)
        .post('/api/auth/register')
        .send({
          username: 't', // Too short
          email: 'not-an-email',
          password: '123' // Too short
        });
      
      expect(res.statusCode).toEqual(400);
      expect(res.body.status).toEqual('error');
      expect(res.body).toHaveProperty('errors');
    });
  });
  
  describe('POST /api/auth/login', () => {
    test('should login existing user and return token', async () => {
      const res = await request(app)
        .post('/api/auth/login')
        .send({
          email: 'test@example.com',
          password: 'password123'
        });
      
      expect(res.statusCode).toEqual(200);
      expect(res.body.status).toEqual('success');
      expect(res.body.data).toHaveProperty('token');
      expect(res.body.data.email).toEqual('test@example.com');
    });
    
    test('should reject wrong password', async () => {
      const res = await request(app)
        .post('/api/auth/login')
        .send({
          email: 'test@example.com',
          password: 'wrongpassword'
        });
      
      expect(res.statusCode).toEqual(401);
      expect(res.body.status).toEqual('error');
    });
    
    test('should reject non-existent user', async () => {
      const res = await request(app)
        .post('/api/auth/login')
        .send({
          email: 'nonexistent@example.com',
          password: 'password123'
        });
      
      expect(res.statusCode).toEqual(401);
      expect(res.body.status).toEqual('error');
    });
  });
  
  // Add more tests for other auth endpoints...
});
```

### middleware/cache.js

```javascript
const cache = require('memory-cache');

/**
 * Cache middleware factory
 * @param {number} duration - Cache duration in seconds
 * @returns {Function} Express middleware function
 */
const cacheMiddleware = (duration) => {
  return (req, res, next) => {
    // Skip cache for non-GET methods
    if (req.method !== 'GET') {
      return next();
    }
    
    // Create a unique key based on URL and query parameters
    const key = `__express__${req.originalUrl || req.url}`;
    
    // Check if we have a cached response
    const cachedBody = cache.get(key);
    
    if (cachedBody) {
      // Send cached response
      res.send(cachedBody);
      return;
    }
    
    // Store original send method
    const originalSend = res.send;
    
    // Override send method to cache the response
    res.send = function(body) {
      // Only cache successful responses
      if (res.statusCode >= 200 && res.statusCode < 300) {
        cache.put(key, body, duration * 1000);
      }
      originalSend.call(this, body);
    };
    
    next();
  };
};

/**
 * Clear cache for specific key pattern
 * @param {string} keyPattern - Key pattern to match
 */
const clearCache = (keyPattern) => {
  const memCache = cache.keys();
  
  if (keyPattern) {
    memCache.forEach(key => {
      if (key.includes(keyPattern)) {
        cache.del(key);
      }
    });
  } else {
    cache.clear();
  }
};

module.exports = {
  cache: cacheMiddleware,
  clearCache
};
```

### middleware/timeout.js

```javascript
const timeout = require('express-timeout-handler');

/**
 * Request timeout middleware
 * Default timeout: 30 seconds
 */
const timeoutMiddleware = timeout.handler({
  timeout: 30000, // 30 seconds
  onTimeout: (req, res) => {
    res.status(503).json({
      status: 'error',
      message: 'Request timed out. Please try again later.'
    });
  },
  onDelayedResponse: (req, method, args, requestTime) => {
    console.warn(`Delayed response: ${method} ${req.originalUrl} - ${requestTime}ms`);
  }
});

module.exports = timeoutMiddleware;
```

### config/db.js (Updated)

```javascript
const { Pool } = require('pg');
require('dotenv').config();

// Determine environment
const isTest = process.env.NODE_ENV === 'test';

// Use test database if in test environment
const dbName = isTest ? process.env.TEST_DB_NAME : process.env.DB_NAME;

// Configure pool with optimized settings
const pool = new Pool({
  user: process.env.DB_USER,
  password: process.env.DB_PASSWORD,
  host: process.env.DB_HOST,
  port: process.env.DB_PORT,
  database: dbName,
  // Connection pool settings
  max: 20, // Maximum number of clients
  idleTimeoutMillis: 30000, // How long a client is allowed to remain idle before being closed
  connectionTimeoutMillis: 2000, // How long to wait for a connection
  maxUses: 7500, // Number of times a client can be used before being recycled
});

// Monitor the pool for issues
pool.on('error', (err, client) => {
  console.error('Unexpected error on idle client', err);
});

// Test the connection
pool.query('SELECT NOW()', (err, res) => {
  if (err) {
    console.error('Error connecting to the database:', err.message);
    return;
  }
  console.log(`Connected to PostgreSQL database ${dbName} at:`, res.rows[0].now);
});

module.exports = pool;
```

### models/productQueries.js (Optimized)

```javascript
// Update the findAllProducts function in productQueries.js

// Find all products (with pagination and optimized queries)
findAllProducts: async (page = 1, limit = 10) => {
  const offset = (page - 1) * limit;
  
  // Use a single query with COUNT() OVER() for improved performance
  const query = `
    SELECT p.*,
           COUNT(*) OVER() as total_count
    FROM products p
    ORDER BY p.created_at DESC
    LIMIT $1 OFFSET $2
  `;
  
  try {
    const result = await pool.query(query, [limit, offset]);
    
    const products = result.rows;
    const totalProducts = products.length > 0 ? parseInt(products[0].total_count) : 0;
    const totalPages = Math.ceil(totalProducts / limit);
    
    // Remove total_count from each product
    products.forEach(product => {
      delete product.total_count;
    });
    
    return {
      products,
      pagination: {
        totalProducts,
        totalPages,
        currentPage: page,
        limit
      }
    };
  } catch (error) {
    throw error;
  }
}
```

### app.js (Updated with Caching and Timeout)

```javascript
const express = require('express');
const cors = require('cors');
const path = require('path');
const { requestLogger } = require('./middleware/requestLogger');
const securityHeaders = require('./middleware/securityHeaders');
const { standardLimiter, authLimiter } = require('./middleware/rateLimiter');
const timeoutMiddleware = require('./middleware/timeout');
const { cache } = require('./middleware/cache');
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

// Apply timeout middleware
app.use(timeoutMiddleware);

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

// Routes with caching for GET requests
app.use('/api/auth', authRoutes);
app.use('/api/admin', adminRoutes);
app.use('/api/products', cache(300), productRoutes); // Cache product listings for 5 minutes
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

## 🧪 Testing and Performance Tips

### Unit Tests

Unit tests verify the correctness of individual components in isolation. Key areas to test:

- Model functions
- Utility functions
- Validation rules
- Error handling

### Integration Tests

Integration tests verify the interaction between components. Key areas to test:

- API endpoints
- Database operations
- Authentication flow
- Request/response cycle

### Performance Optimizations

1. **Database Query Optimization**:
   - Use appropriate indexes
   - Combine queries where possible
   - Use COUNT() OVER() for pagination
   - Implement connection pooling

2. **Caching**:
   - Cache frequently accessed data
   - Set appropriate cache durations
   - Clear cache when data changes

3. **Request Processing**:
   - Add timeouts to prevent hanging requests
   - Optimize middleware order
   - Use compression for responses
   - Implement efficient input validation

## 🚀 Day 9 Implementation Steps

1. **Set up testing environment**:
   - Install testing tools
   - Configure test database
   - Create test setup scripts

2. **Write unit tests**:
   - Test models and queries
   - Test utility functions
   - Test validation logic

3. **Write integration tests**:
   - Test API endpoints
   - Test authentication flow
   - Test error handling

4. **Optimize database queries**:
   - Analyze and improve query performance
   - Add appropriate indexing
   - Configure connection pool settings

5. **Implement caching**:
   - Add caching middleware
   - Configure cache for appropriate routes
   - Implement cache invalidation

6. **Add timeout handling**:
   - Implement request timeout middleware
   - Set appropriate timeout values
   - Handle long-running operations properly

7. **Test performance**:
   - Verify optimizations work as expected
   - Test under load conditions
   - Fix any identified bottlenecks

## 📝 Notes and Best Practices

- Write tests that are focused on specific behaviors
- Use mock objects for external dependencies in unit tests
- Test both success and failure cases
- Optimize database queries for frequently accessed data
- Cache data that doesn't change frequently
- Set appropriate timeout limits for requests
- Monitor performance metrics in production
- Use a separate database for testing
- Clean up test data after test runs
- Always write tests before fixing bugs to prevent regression

## 🔄 Next Steps

On Day 10, we'll finalize the application with documentation, deployment preparation, and final touches.
