# Day 10: Final Touches, Documentation, and Deployment Preparation

## 🎯 Goal

Finalize the application by adding comprehensive documentation, preparing for deployment, and implementing any remaining features or improvements.

## 📝 Tasks

1. Create comprehensive API documentation
2. Implement database migrations and seeds
3. Create deployment scripts
4. Add health check endpoint
5. Set up continuous integration
6. Implement API versioning
7. Complete project README with setup instructions

## 📂 Folder & File Structure (New/Updated Files)

```
express_ecommerce/
├── db/
│   ├── migrations/
│   │   ├── 01_create_tables.sql (new)
│   │   └── 02_create_indexes.sql (new)
│   └── seeds/
│       ├── 01_users.sql (new)
│       └── 02_products.sql (new)
├── docs/
│   ├── api.md (new)
│   └── database.md (new)
├── scripts/
│   ├── db-migrate.js (new)
│   └── db-seed.js (new)
├── routes/
│   └── healthRoutes.js (new)
├── app.js (updated)
├── .env.example (updated)
├── Dockerfile (new)
├── docker-compose.yml (new)
└── README.md (new)
```

## 🖥️ Code Snippets

### db/migrations/01_create_tables.sql

```sql
-- Create users table
CREATE TABLE IF NOT EXISTS users (
  id SERIAL PRIMARY KEY,
  username VARCHAR(50) NOT NULL,
  email VARCHAR(100) UNIQUE NOT NULL,
  password VARCHAR(100) NOT NULL,
  role VARCHAR(20) NOT NULL DEFAULT 'user',
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Create products table
CREATE TABLE IF NOT EXISTS products (
  id SERIAL PRIMARY KEY,
  name VARCHAR(100) NOT NULL,
  description TEXT NOT NULL,
  price DECIMAL(10, 2) NOT NULL,
  image_url VARCHAR(255),
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Create carts table
CREATE TABLE IF NOT EXISTS carts (
  id SERIAL PRIMARY KEY,
  user_id INTEGER NOT NULL,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE
);

-- Create cart_items table
CREATE TABLE IF NOT EXISTS cart_items (
  id SERIAL PRIMARY KEY,
  cart_id INTEGER NOT NULL,
  product_id INTEGER NOT NULL,
  quantity INTEGER NOT NULL DEFAULT 1,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (cart_id) REFERENCES carts(id) ON DELETE CASCADE,
  FOREIGN KEY (product_id) REFERENCES products(id) ON DELETE CASCADE
);

-- Create orders table
CREATE TABLE IF NOT EXISTS orders (
  id SERIAL PRIMARY KEY,
  user_id INTEGER NOT NULL,
  status VARCHAR(20) NOT NULL DEFAULT 'pending',
  total_amount DECIMAL(10, 2) NOT NULL,
  shipping_address TEXT NOT NULL,
  payment_method VARCHAR(50) NOT NULL,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
  CONSTRAINT valid_status CHECK (status IN ('pending', 'processing', 'shipped', 'delivered', 'cancelled'))
);

-- Create order_items table
CREATE TABLE IF NOT EXISTS order_items (
  id SERIAL PRIMARY KEY,
  order_id INTEGER NOT NULL,
  product_id INTEGER NOT NULL,
  quantity INTEGER NOT NULL,
  unit_price DECIMAL(10, 2) NOT NULL,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (order_id) REFERENCES orders(id) ON DELETE CASCADE,
  FOREIGN KEY (product_id) REFERENCES products(id)
);
```

### db/migrations/02_create_indexes.sql

```sql
-- Create index on users email
CREATE INDEX IF NOT EXISTS idx_users_email ON users(email);

-- Create index on product name for faster search
CREATE INDEX IF NOT EXISTS idx_products_name ON products(name);

-- Create indexes for faster queries on carts
CREATE INDEX IF NOT EXISTS idx_carts_user_id ON carts(user_id);
CREATE INDEX IF NOT EXISTS idx_cart_items_cart_id ON cart_items(cart_id);
CREATE INDEX IF NOT EXISTS idx_cart_items_product_id ON cart_items(product_id);

-- Add unique constraint to prevent duplicate products in cart
CREATE UNIQUE INDEX IF NOT EXISTS idx_cart_items_unique ON cart_items(cart_id, product_id);

-- Create indexes for faster queries on orders
CREATE INDEX IF NOT EXISTS idx_orders_user_id ON orders(user_id);
CREATE INDEX IF NOT EXISTS idx_orders_status ON orders(status);
CREATE INDEX IF NOT EXISTS idx_order_items_order_id ON order_items(order_id);
CREATE INDEX IF NOT EXISTS idx_order_items_product_id ON order_items(product_id);
```

### db/seeds/01_users.sql

```sql
-- Insert admin user
INSERT INTO users (username, email, password, role)
VALUES (
  'admin',
  'admin@example.com',
  -- bcrypt hash for 'adminPassword123'
  '$2b$10$gxS6E0MzplCrVbq4nIBGGuiNVOajW8q/F4xoECPJbDQAqLAFbBvlO',
  'admin'
)
ON CONFLICT (email) DO NOTHING;

-- Insert regular user
INSERT INTO users (username, email, password, role)
VALUES (
  'user',
  'user@example.com',
  -- bcrypt hash for 'userPassword123'
  '$2b$10$YtYhljV0XFxXYTRpx.GXUeBfjdEyK.PHuoQnz5ZYwUmY0xOr6eMJy',
  'user'
)
ON CONFLICT (email) DO NOTHING;
```

### db/seeds/02_products.sql

```sql
-- Insert sample products
INSERT INTO products (name, description, price, image_url)
VALUES
  ('Smartphone XYZ', 'Latest smartphone with advanced features', 599.99, '/uploads/smartphone.jpg'),
  ('Laptop Pro', 'High-performance laptop for professionals', 1299.99, '/uploads/laptop.jpg'),
  ('Wireless Headphones', 'Noise-cancelling wireless headphones', 149.99, '/uploads/headphones.jpg'),
  ('Smart Watch', 'Fitness tracking smartwatch with heart rate monitor', 199.99, '/uploads/smartwatch.jpg'),
  ('Bluetooth Speaker', 'Portable wireless speaker with 20-hour battery life', 79.99, '/uploads/speaker.jpg'),
  ('Tablet Ultra', '10-inch tablet with HD display', 349.99, '/uploads/tablet.jpg'),
  ('Digital Camera', 'Professional digital camera with 24MP sensor', 649.99, '/uploads/camera.jpg'),
  ('Gaming Console', 'Next-generation gaming console', 499.99, '/uploads/console.jpg'),
  ('Wireless Mouse', 'Ergonomic wireless mouse', 29.99, '/uploads/mouse.jpg'),
  ('External SSD', '1TB external solid state drive', 129.99, '/uploads/ssd.jpg')
ON CONFLICT DO NOTHING;
```

### scripts/db-migrate.js

```javascript
const { Pool } = require('pg');
const fs = require('fs');
const path = require('path');
require('dotenv').config();

// Create connection pool
const pool = new Pool({
  user: process.env.DB_USER,
  password: process.env.DB_PASSWORD,
  host: process.env.DB_HOST,
  port: process.env.DB_PORT,
  database: process.env.DB_NAME
});

/**
 * Run migrations
 */
async function runMigrations() {
  const client = await pool.connect();
  
  try {
    console.log('Running migrations...');
    
    // Create migrations table if it doesn't exist
    await client.query(`
      CREATE TABLE IF NOT EXISTS migrations (
        id SERIAL PRIMARY KEY,
        name VARCHAR(255) NOT NULL,
        executed_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
      )
    `);
    
    // Get executed migrations
    const { rows: executedMigrations } = await client.query(
      'SELECT name FROM migrations'
    );
    const executedMigrationNames = executedMigrations.map(row => row.name);
    
    // Read migration files
    const migrationsDir = path.join(__dirname, '../db/migrations');
    const migrationFiles = fs.readdirSync(migrationsDir)
      .filter(file => file.endsWith('.sql'))
      .sort(); // Sort to ensure order
    
    // Execute migrations that haven't been run yet
    for (const file of migrationFiles) {
      if (!executedMigrationNames.includes(file)) {
        console.log(`Executing migration: ${file}`);
        
        const filePath = path.join(migrationsDir, file);
        const sql = fs.readFileSync(filePath, 'utf8');
        
        await client.query('BEGIN');
        
        try {
          await client.query(sql);
          await client.query(
            'INSERT INTO migrations (name) VALUES ($1)',
            [file]
          );
          
          await client.query('COMMIT');
          console.log(`Migration ${file} executed successfully`);
          
        } catch (error) {
          await client.query('ROLLBACK');
          console.error(`Error executing migration ${file}:`, error);
          throw error;
        }
      } else {
        console.log(`Migration ${file} already executed, skipping...`);
      }
    }
    
    console.log('All migrations completed successfully');
    
  } catch (error) {
    console.error('Migration failed:', error);
    throw error;
  } finally {
    client.release();
    await pool.end();
  }
}

// Run migrations
runMigrations()
  .catch(err => {
    console.error('Error in migration script:', err);
    process.exit(1);
  });
```

### scripts/db-seed.js

```javascript
const { Pool } = require('pg');
const fs = require('fs');
const path = require('path');
require('dotenv').config();

// Create connection pool
const pool = new Pool({
  user: process.env.DB_USER,
  password: process.env.DB_PASSWORD,
  host: process.env.DB_HOST,
  port: process.env.DB_PORT,
  database: process.env.DB_NAME
});

/**
 * Run seeds
 */
async function runSeeds() {
  const client = await pool.connect();
  
  try {
    console.log('Running seeds...');
    
    // Create seeds table if it doesn't exist
    await client.query(`
      CREATE TABLE IF NOT EXISTS seeds (
        id SERIAL PRIMARY KEY,
        name VARCHAR(255) NOT NULL,
        executed_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
      )
    `);
    
    // Get executed seeds
    const { rows: executedSeeds } = await client.query(
      'SELECT name FROM seeds'
    );
    const executedSeedNames = executedSeeds.map(row => row.name);
    
    // Read seed files
    const seedsDir = path.join(__dirname, '../db/seeds');
    const seedFiles = fs.readdirSync(seedsDir)
      .filter(file => file.endsWith('.sql'))
      .sort(); // Sort to ensure order
    
    // Execute seeds that haven't been run yet
    for (const file of seedFiles) {
      if (!executedSeedNames.includes(file)) {
        console.log(`Executing seed: ${file}`);
        
        const filePath = path.join(seedsDir, file);
        const sql = fs.readFileSync(filePath, 'utf8');
        
        await client.query('BEGIN');
        
        try {
          await client.query(sql);
          await client.query(
            'INSERT INTO seeds (name) VALUES ($1)',
            [file]
          );
          
          await client.query('COMMIT');
          console.log(`Seed ${file} executed successfully`);
          
        } catch (error) {
          await client.query('ROLLBACK');
          console.error(`Error executing seed ${file}:`, error);
          throw error;
        }
      } else {
        console.log(`Seed ${file} already executed, skipping...`);
      }
    }
    
    console.log('All seeds completed successfully');
    
  } catch (error) {
    console.error('Seeding failed:', error);
    throw error;
  } finally {
    client.release();
    await pool.end();
  }
}

// Run seeds
runSeeds()
  .catch(err => {
    console.error('Error in seed script:', err);
    process.exit(1);
  });
```

### routes/healthRoutes.js

```javascript
const express = require('express');
const router = express.Router();
const pool = require('../config/db');
const { version } = require('../package.json');

/**
 * @route GET /api/health
 * @desc Health check endpoint
 * @access Public
 */
router.get('/', async (req, res) => {
  try {
    // Check database connection
    const dbStart = Date.now();
    await pool.query('SELECT 1');
    const dbDuration = Date.now() - dbStart;
    
    // Return health status
    res.status(200).json({
      status: 'success',
      message: 'API is healthy',
      version,
      timestamp: new Date().toISOString(),
      database: {
        status: 'connected',
        responseTime: `${dbDuration}ms`
      }
    });
  } catch (error) {
    res.status(500).json({
      status: 'error',
      message: 'API health check failed',
      error: error.message,
      database: {
        status: 'disconnected'
      }
    });
  }
});

module.exports = router;
```

### app.js (Updated with Versioning)

```javascript
// Add to the existing app.js

// API versioning
const apiV1 = express.Router();
app.use('/api/v1', apiV1);

// Health check route
const healthRoutes = require('./routes/healthRoutes');
app.use('/api/health', healthRoutes);

// Register routes with versioning
apiV1.use('/auth', authRoutes);
apiV1.use('/admin', adminRoutes);
apiV1.use('/products', cache(300), productRoutes);
apiV1.use('/cart', cartRoutes);
apiV1.use('/orders', orderRoutes);

// Keep the original routes for backward compatibility
app.use('/api/auth', authRoutes);
app.use('/api/admin', adminRoutes);
app.use('/api/products', cache(300), productRoutes);
app.use('/api/cart', cartRoutes);
app.use('/api/orders', orderRoutes);
```

### Dockerfile

```dockerfile
FROM node:18-alpine

# Create app directory
WORKDIR /usr/src/app

# Install app dependencies
COPY package*.json ./
RUN npm ci --only=production

# Bundle app source
COPY . .

# Create uploads directory
RUN mkdir -p media/uploads && chmod -R 755 media

# Expose port
EXPOSE 3000

# Create non-root user for security
RUN addgroup -S appgroup && adduser -S appuser -G appgroup
RUN chown -R appuser:appgroup /usr/src/app
USER appuser

# Run migrations and start server
CMD ["sh", "-c", "node scripts/db-migrate.js && node server.js"]
```

### docker-compose.yml

```yaml
version: '3.8'

services:
  app:
    build: .
    ports:
      - "3000:3000"
    depends_on:
      - db
    environment:
      - NODE_ENV=production
      - PORT=3000
      - DB_HOST=db
      - DB_PORT=5432
      - DB_NAME=ecommerce_db
      - DB_USER=postgres
      - DB_PASSWORD=postgres
      - JWT_SECRET=your_jwt_secret
      - JWT_EXPIRES_IN=1d
    volumes:
      - ./media/uploads:/usr/src/app/media/uploads
    restart: unless-stopped

  db:
    image: postgres:14-alpine
    ports:
      - "5432:5432"
    environment:
      - POSTGRES_USER=postgres
      - POSTGRES_PASSWORD=postgres
      - POSTGRES_DB=ecommerce_db
    volumes:
      - postgres_data:/var/lib/postgresql/data
    restart: unless-stopped

volumes:
  postgres_data:
```

### .env.example (Updated)

```
# Server Configuration
PORT=3000
NODE_ENV=development

# Database Configuration
DB_HOST=localhost
DB_PORT=5432
DB_NAME=ecommerce_db
DB_USER=postgres
DB_PASSWORD=your_password
TEST_DB_NAME=ecommerce_test

# JWT Configuration
JWT_SECRET=your_jwt_secret_key
JWT_EXPIRES_IN=1d

# Admin User (used by seed script)
ADMIN_USERNAME=admin
ADMIN_EMAIL=admin@example.com
ADMIN_PASSWORD=adminPassword123
```

### docs/api.md

```markdown
# E-commerce API Documentation

## Base URL

```
http://localhost:3000/api
```

or with versioning:

```
http://localhost:3000/api/v1
```

## Authentication

### Register a new user

**Endpoint:** `POST /auth/register`

**Request Body:**

```json
{
  "username": "john_doe",
  "email": "john@example.com",
  "password": "password123"
}
```

**Response:**

```json
{
  "status": "success",
  "message": "User registered successfully",
  "data": {
    "id": 1,
    "username": "john_doe",
    "email": "john@example.com",
    "role": "user",
    "created_at": "2023-09-15T12:00:00Z"
  }
}
```

### Login

**Endpoint:** `POST /auth/login`

**Request Body:**

```json
{
  "email": "john@example.com",
  "password": "password123"
}
```

**Response:**

```json
{
  "status": "success",
  "message": "Login successful",
  "data": {
    "id": 1,
    "username": "john_doe",
    "email": "john@example.com",
    "role": "user",
    "token": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9..."
  }
}
```

### Get Current User Profile

**Endpoint:** `GET /auth/profile`

**Headers:**

```
Authorization: Bearer {token}
```

**Response:**

```json
{
  "status": "success",
  "data": {
    "id": 1,
    "username": "john_doe",
    "email": "john@example.com",
    "role": "user",
    "created_at": "2023-09-15T12:00:00Z"
  }
}
```

## Products

### Get All Products

**Endpoint:** `GET /products?page=1&limit=10`

**Response:**

```json
{
  "status": "success",
  "data": {
    "products": [
      {
        "id": 1,
        "name": "Smartphone XYZ",
        "description": "Latest smartphone with advanced features",
        "price": "599.99",
        "image_url": "/uploads/smartphone.jpg",
        "created_at": "2023-09-15T12:00:00Z",
        "updated_at": "2023-09-15T12:00:00Z"
      },
      // ...more products
    ],
    "pagination": {
      "totalProducts": 50,
      "totalPages": 5,
      "currentPage": 1,
      "limit": 10
    }
  }
}
```

### Get Product by ID

**Endpoint:** `GET /products/:id`

**Response:**

```json
{
  "status": "success",
  "data": {
    "product": {
      "id": 1,
      "name": "Smartphone XYZ",
      "description": "Latest smartphone with advanced features",
      "price": "599.99",
      "image_url": "/uploads/smartphone.jpg",
      "created_at": "2023-09-15T12:00:00Z",
      "updated_at": "2023-09-15T12:00:00Z"
    }
  }
}
```

### Create Product (Admin Only)

**Endpoint:** `POST /products`

**Headers:**

```
Authorization: Bearer {admin_token}
Content-Type: multipart/form-data
```

**Request Body:**

```
name: "Smartphone XYZ"
description: "Latest smartphone with advanced features"
price: 599.99
image: [file]
```

**Response:**

```json
{
  "status": "success",
  "message": "Product created successfully",
  "data": {
    "product": {
      "id": 1,
      "name": "Smartphone XYZ",
      "description": "Latest smartphone with advanced features",
      "price": "599.99",
      "image_url": "/uploads/smartphone-1234567890.jpg",
      "created_at": "2023-09-15T12:00:00Z",
      "updated_at": "2023-09-15T12:00:00Z"
    }
  }
}
```

### Update Product (Admin Only)

**Endpoint:** `PATCH /products/:id`

**Headers:**

```
Authorization: Bearer {admin_token}
Content-Type: multipart/form-data
```

**Request Body:**

```
name: "Updated Smartphone XYZ"
price: 649.99
```

**Response:**

```json
{
  "status": "success",
  "message": "Product updated successfully",
  "data": {
    "product": {
      "id": 1,
      "name": "Updated Smartphone XYZ",
      "description": "Latest smartphone with advanced features",
      "price": "649.99",
      "image_url": "/uploads/smartphone-1234567890.jpg",
      "created_at": "2023-09-15T12:00:00Z",
      "updated_at": "2023-09-15T13:00:00Z"
    }
  }
}
```

### Delete Product (Admin Only)

**Endpoint:** `DELETE /products/:id`

**Headers:**

```
Authorization: Bearer {admin_token}
```

**Response:**

```json
{
  "status": "success",
  "message": "Product deleted successfully",
  "data": {
    "product": {
      "id": 1,
      "name": "Updated Smartphone XYZ",
      "description": "Latest smartphone with advanced features",
      "price": "649.99",
      "image_url": "/uploads/smartphone-1234567890.jpg",
      "created_at": "2023-09-15T12:00:00Z",
      "updated_at": "2023-09-15T13:00:00Z"
    }
  }
}
```

## Cart

### Get Current User's Cart

**Endpoint:** `GET /cart`

**Headers:**

```
Authorization: Bearer {token}
```

**Response:**

```json
{
  "status": "success",
  "data": {
    "cart": {
      "id": 1,
      "user_id": 1,
      "created_at": "2023-09-15T12:00:00Z",
      "updated_at": "2023-09-15T12:00:00Z",
      "items": [
        {
          "id": 1,
          "product_id": 1,
          "quantity": 2,
          "name": "Smartphone XYZ",
          "description": "Latest smartphone with advanced features",
          "price": "599.99",
          "image_url": "/uploads/smartphone.jpg",
          "created_at": "2023-09-15T12:00:00Z"
        },
        // ...more items
      ],
      "total_price": 1199.98,
      "item_count": 1
    }
  }
}
```

### Add Item to Cart

**Endpoint:** `POST /cart/items`

**Headers:**

```
Authorization: Bearer {token}
Content-Type: application/json
```

**Request Body:**

```json
{
  "productId": 1,
  "quantity": 2
}
```

**Response:**

```json
{
  "status": "success",
  "message": "Item added to cart",
  "data": {
    "cartItem": {
      "id": 1,
      "product_id": 1,
      "quantity": 2,
      "name": "Smartphone XYZ",
      "price": "599.99",
      "image_url": "/uploads/smartphone.jpg",
      "total_price": 1199.98
    }
  }
}
```

### Update Cart Item Quantity

**Endpoint:** `PATCH /cart/items/:itemId`

**Headers:**

```
Authorization: Bearer {token}
Content-Type: application/json
```

**Request Body:**

```json
{
  "quantity": 3
}
```

**Response:**

```json
{
  "status": "success",
  "message": "Cart item updated",
  "data": {
    "cartItem": {
      "id": 1,
      "product_id": 1,
      "quantity": 3,
      "name": "Smartphone XYZ",
      "price": "599.99",
      "image_url": "/uploads/smartphone.jpg",
      "total_price": 1799.97
    }
  }
}
```

### Remove Item from Cart

**Endpoint:** `DELETE /cart/items/:itemId`

**Headers:**

```
Authorization: Bearer {token}
```

**Response:**

```json
{
  "status": "success",
  "message": "Item removed from cart"
}
```

### Clear Cart

**Endpoint:** `DELETE /cart`

**Headers:**

```
Authorization: Bearer {token}
```

**Response:**

```json
{
  "status": "success",
  "message": "Cart cleared successfully"
}
```

## Orders

### Create Order from Cart

**Endpoint:** `POST /orders`

**Headers:**

```
Authorization: Bearer {token}
Content-Type: application/json
```

**Request Body:**

```json
{
  "shippingAddress": "123 Main St, City, Country",
  "paymentMethod": "Credit Card"
}
```

**Response:**

```json
{
  "status": "success",
  "message": "Order created successfully",
  "data": {
    "order": {
      "id": 1,
      "user_id": 1,
      "username": "john_doe",
      "email": "john@example.com",
      "status": "pending",
      "total_amount": 1799.97,
      "shipping_address": "123 Main St, City, Country",
      "payment_method": "Credit Card",
      "created_at": "2023-09-15T12:00:00Z",
      "updated_at": "2023-09-15T12:00:00Z",
      "items": [
        {
          "id": 1,
          "product_id": 1,
          "name": "Smartphone XYZ",
          "description": "Latest smartphone with advanced features",
          "image_url": "/uploads/smartphone.jpg",
          "quantity": 3,
          "unit_price": "599.99",
          "total_price": 1799.97
        },
        // ...more items
      ]
    }
  }
}
```

### Get User's Orders

**Endpoint:** `GET /orders/user?page=1&limit=10`

**Headers:**

```
Authorization: Bearer {token}
```

**Response:**

```json
{
  "status": "success",
  "data": {
    "orders": [
      {
        "id": 1,
        "status": "pending",
        "total_amount": "1799.97",
        "shipping_address": "123 Main St, City, Country",
        "payment_method": "Credit Card",
        "created_at": "2023-09-15T12:00:00Z",
        "updated_at": "2023-09-15T12:00:00Z",
        "item_count": 1
      },
      // ...more orders
    ],
    "pagination": {
      "totalOrders": 5,
      "totalPages": 1,
      "currentPage": 1,
      "limit": 10
    }
  }
}
```

### Get User's Order by ID

**Endpoint:** `GET /orders/user/:id`

**Headers:**

```
Authorization: Bearer {token}
```

**Response:**

```json
{
  "status": "success",
  "data": {
    "order": {
      "id": 1,
      "user_id": 1,
      "username": "john_doe",
      "email": "john@example.com",
      "status": "pending",
      "total_amount": 1799.97,
      "shipping_address": "123 Main St, City, Country",
      "payment_method": "Credit Card",
      "created_at": "2023-09-15T12:00:00Z",
      "updated_at": "2023-09-15T12:00:00Z",
      "items": [
        {
          "id": 1,
          "product_id": 1,
          "name": "Smartphone XYZ",
          "description": "Latest smartphone with advanced features",
          "image_url": "/uploads/smartphone.jpg",
          "quantity": 3,
          "unit_price": "599.99",
          "total_price": 1799.97
        },
        // ...more items
      ]
    }
  }
}
```

### Cancel Order (User)

**Endpoint:** `PATCH /orders/user/:id/cancel`

**Headers:**

```
Authorization: Bearer {token}
```

**Response:**

```json
{
  "status": "success",
  "message": "Order cancelled successfully",
  "data": {
    "order": {
      "id": 1,
      "user_id": 1,
      "status": "cancelled",
      "total_amount": "1799.97",
      "shipping_address": "123 Main St, City, Country",
      "payment_method": "Credit Card",
      "created_at": "2023-09-15T12:00:00Z",
      "updated_at": "2023-09-15T13:00:00Z"
    }
  }
}
```

### Get All Orders (Admin Only)

**Endpoint:** `GET /orders/admin?page=1&limit=10&status=pending`

**Headers:**

```
Authorization: Bearer {admin_token}
```

**Response:**

```json
{
  "status": "success",
  "data": {
    "orders": [
      {
        "id": 1,
        "user_id": 1,
        "username": "john_doe",
        "email": "john@example.com",
        "status": "pending",
        "total_amount": "1799.97",
        "shipping_address": "123 Main St, City, Country",
        "payment_method": "Credit Card",
        "created_at": "2023-09-15T12:00:00Z",
        "updated_at": "2023-09-15T12:00:00Z",
        "item_count": 1
      },
      // ...more orders
    ],
    "pagination": {
      "totalOrders": 20,
      "totalPages": 2,
      "currentPage": 1,
      "limit": 10
    }
  }
}
```

### Update Order Status (Admin Only)

**Endpoint:** `PATCH /orders/admin/:id/status`

**Headers:**

```
Authorization: Bearer {admin_token}
Content-Type: application/json
```

**Request Body:**

```json
{
  "status": "processing"
}
```

**Response:**

```json
{
  "status": "success",
  "message": "Order status updated successfully",
  "data": {
    "order": {
      "id": 1,
      "user_id": 1,
      "status": "processing",
      "total_amount": "1799.97",
      "shipping_address": "123 Main St, City, Country",
      "payment_method": "Credit Card",
      "created_at": "2023-09-15T12:00:00Z",
      "updated_at": "2023-09-15T13:00:00Z"
    }
  }
}
```

### Get Order Analytics (Admin Only)

**Endpoint:** `GET /orders/admin/analytics`

**Headers:**

```
Authorization: Bearer {admin_token}
```

**Response:**

```json
{
  "status": "success",
  "data": {
    "analytics": {
      "ordersByStatus": {
        "pending": 5,
        "processing": 3,
        "shipped": 2,
        "delivered": 10,
        "cancelled": 1
      },
      "dailyOrders": [
        {
          "date": "2023-09-15",
          "orderCount": 3,
          "revenue": 245.85
        },
        // ...more dates
      ],
      "topProducts": [
        {
          "id": 1,
          "name": "Smartphone XYZ",
          "totalQuantity": 15,
          "totalRevenue": 8999.85
        },
        // ...more products
      ],
      "totals": {
        "totalOrders": 21,
        "totalRevenue": 15175.50,
        "uniqueCustomers": 12
      }
    }
  }
}
```

## Health Check

### Get API Health Status

**Endpoint:** `GET /health`

**Response:**

```json
{
  "status": "success",
  "message": "API is healthy",
  "version": "1.0.0",
  "timestamp": "2023-09-15T12:00:00Z",
  "database": {
    "status": "connected",
    "responseTime": "5ms"
  }
}
```
```

### README.md

```markdown
# Express.js + PostgreSQL E-commerce API

A complete RESTful API for an e-commerce application built with Express.js and PostgreSQL.

## Features

- User authentication and authorization (JWT-based)
- Role-based access control (admin and regular users)
- Product management with image uploads
- Shopping cart functionality
- Order processing with status management
- Input validation and error handling
- API rate limiting and security features
- Comprehensive API documentation

## Tech Stack

- **Node.js & Express.js**: Server framework
- **PostgreSQL**: Database (using raw SQL queries with `pg` module)
- **JWT**: Authentication
- **bcrypt**: Password hashing
- **Multer**: File uploads
- **express-validator**: Input validation
- **Jest & Supertest**: Testing

## Prerequisites

- Node.js (v16+)
- PostgreSQL (v13+)
- npm or yarn

## Installation & Setup

1. **Clone the repository**

```bash
git clone https://github.com/yourusername/express-ecommerce-api.git
cd express-ecommerce-api
```

2. **Install dependencies**

```bash
npm install
```

3. **Configure environment variables**

Create a `.env` file in the root directory based on the provided `.env.example`:

```
# Server Configuration
PORT=3000
NODE_ENV=development

# Database Configuration
DB_HOST=localhost
DB_PORT=5432
DB_NAME=ecommerce_db
DB_USER=postgres
DB_PASSWORD=your_password
TEST_DB_NAME=ecommerce_test

# JWT Configuration
JWT_SECRET=your_jwt_secret_key
JWT_EXPIRES_IN=1d

# Admin User
ADMIN_USERNAME=admin
ADMIN_EMAIL=admin@example.com
ADMIN_PASSWORD=adminPassword123
```

4. **Create database**

```bash
# Log into PostgreSQL
psql -U postgres

# Create database
CREATE DATABASE ecommerce_db;
```

5. **Run database migrations**

```bash
node scripts/db-migrate.js
```

6. **Seed database with initial data (optional)**

```bash
node scripts/db-seed.js
```

7. **Start the server**

```bash
# Development mode
npm run dev

# Production mode
npm start
```

## Docker Setup

To run the application using Docker:

```bash
# Build and start containers
docker-compose up -d

# Stop containers
docker-compose down
```

## API Documentation

The full API documentation is available in the [docs/api.md](docs/api.md) file.

### Base URL

```
http://localhost:3000/api
```

or with versioning:

```
http://localhost:3000/api/v1
```

### Authentication

- Register: `POST /api/auth/register`
- Login: `POST /api/auth/login`

### Products

- Get all products: `GET /api/products`
- Get product by ID: `GET /api/products/:id`
- Create product (admin): `POST /api/products`
- Update product (admin): `PATCH /api/products/:id`
- Delete product (admin): `DELETE /api/products/:id`

### Cart

- Get cart: `GET /api/cart`
- Add to cart: `POST /api/cart/items`
- Update item quantity: `PATCH /api/cart/items/:itemId`
- Remove item: `DELETE /api/cart/items/:itemId`
- Clear cart: `DELETE /api/cart`

### Orders

- Create order: `POST /api/orders`
- Get user orders: `GET /api/orders/user`
- Get order by ID: `GET /api/orders/user/:id`
- Cancel order: `PATCH /api/orders/user/:id/cancel`
- Get all orders (admin): `GET /api/orders/admin`
- Update order status (admin): `PATCH /api/orders/admin/:id/status`

## Running Tests

```bash
# Run all tests
npm test

# Run unit tests only
npm run test:unit

# Run integration tests only
npm run test:integration
```

## License

MIT
```

## 🚀 Day 10 Implementation Steps

1. **Create database migrations**:
   - Write SQL scripts for table creation
   - Add index creation scripts
   - Create migration runner script

2. **Create seed data**:
   - Add sample users and products
   - Create seeding script

3. **Create API documentation**:
   - Document all endpoints
   - Include request/response examples
   - Add authentication information

4. **Set up deployment configurations**:
   - Create Dockerfile
   - Set up docker-compose
   - Configure environment variables

5. **Add health check endpoint**:
   - Create route for system status
   - Include database connection check
   - Add version information

6. **Implement API versioning**:
   - Set up versioned routes
   - Maintain backward compatibility

7. **Create comprehensive README**:
   - Add installation instructions
   - Document setup process
   - Include usage examples

## 📝 Notes and Best Practices

- Use database migrations to track schema changes
- Provide seed data for easy testing and development
- Document all API endpoints thoroughly
- Use semantic versioning for your API
- Include health checks for monitoring
- Containerize your application for easy deployment
- Use environment variables for configuration
- Provide clear setup instructions

## 🎉 Project Completion

Congratulations! You've successfully completed the 10-day development plan for an Express.js + PostgreSQL e-commerce API. This project has covered:

1. Setting up a complete Express.js application
2. Implementing raw SQL queries with the pg module
3. Creating a role-based authentication system
4. Building product management with file uploads
5. Implementing shopping cart functionality
6. Creating order processing and management
7. Adding security features and input validation
8. Setting up testing and optimization
9. Preparing for deployment
10. Documenting the entire API

This backend is now ready to be used as the foundation for an e-commerce application. It can be connected to any frontend that consumes RESTful APIs.

## 🔄 Next Steps

If you want to extend this project further, consider:

1. Implementing payment gateway integration
2. Adding a product review system
3. Creating a recommendation engine
4. Building a notification system
5. Setting up CI/CD pipelines
6. Adding more comprehensive analytics
7. Implementing a caching layer with Redis
8. Creating a frontend application to consume the API
