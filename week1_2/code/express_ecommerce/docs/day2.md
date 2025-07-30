# Day 2: User Authentication, JWT Setup, and Login Endpoint

## 🎯 Goal

Implement user authentication, set up JWT for secure token-based authentication, and create the login endpoint.

## 📝 Tasks

1. Install JWT and validation dependencies
2. Implement login endpoint with password verification
3. Create JWT authentication middleware
4. Set up role-based access middleware
5. Update routes with authentication requirements
6. Test authentication flow

## 📂 Folder & File Structure (New/Updated Files)

```
express_ecommerce/
├── controllers/
│   └── authController.js (updated)
├── middleware/
│   ├── auth.js (new)
│   └── roleCheck.js (new)
├── routes/
│   └── authRoutes.js (updated)
├── utils/
│   └── jwtHelper.js (new)
└── package.json (updated)
```

## 📦 Dependencies to Install

```bash
npm install jsonwebtoken express-validator
```

## 🖥️ Code Snippets

### utils/jwtHelper.js

```javascript
const jwt = require('jsonwebtoken');
require('dotenv').config();

const JWT_SECRET = process.env.JWT_SECRET || 'your-secret-key';
const JWT_EXPIRES_IN = process.env.JWT_EXPIRES_IN || '1d';

const generateToken = (userId, role) => {
  return jwt.sign(
    { id: userId, role }, 
    JWT_SECRET, 
    { expiresIn: JWT_EXPIRES_IN }
  );
};

const verifyToken = (token) => {
  try {
    return jwt.verify(token, JWT_SECRET);
  } catch (error) {
    throw new Error('Invalid or expired token');
  }
};

module.exports = {
  generateToken,
  verifyToken
};
```

### middleware/auth.js

```javascript
const { verifyToken } = require('../utils/jwtHelper');

const authenticate = (req, res, next) => {
  try {
    // Get token from header
    const authHeader = req.headers.authorization;
    
    if (!authHeader || !authHeader.startsWith('Bearer ')) {
      return res.status(401).json({ 
        status: 'error',
        message: 'Authentication required. No token provided.'
      });
    }
    
    // Extract the token
    const token = authHeader.split(' ')[1];
    
    // Verify token
    const decoded = verifyToken(token);
    
    // Attach user info to request object
    req.user = decoded;
    
    next();
  } catch (error) {
    return res.status(401).json({
      status: 'error',
      message: 'Authentication failed: ' + error.message
    });
  }
};

module.exports = authenticate;
```

### middleware/roleCheck.js

```javascript
const checkRole = (roles) => {
  return (req, res, next) => {
    if (!req.user) {
      return res.status(401).json({
        status: 'error',
        message: 'Unauthorized - User not authenticated'
      });
    }
    
    const userRole = req.user.role;
    
    if (!roles.includes(userRole)) {
      return res.status(403).json({
        status: 'error',
        message: 'Forbidden - Insufficient permissions'
      });
    }
    
    next();
  };
};

module.exports = {
  checkRole
};
```

### controllers/authController.js (Updated)

```javascript
const bcrypt = require('bcrypt');
const { validationResult } = require('express-validator');
const userQueries = require('../models/userQueries');
const { generateToken } = require('../utils/jwtHelper');

const authController = {
  // Register a new user (existing code from Day 1)
  register: async (req, res, next) => {
    try {
      // Validate request data
      const errors = validationResult(req);
      if (!errors.isEmpty()) {
        return res.status(400).json({ 
          status: 'error',
          errors: errors.array() 
        });
      }
      
      const { username, email, password } = req.body;
      
      // Check if user already exists
      const existingUser = await userQueries.findUserByEmail(email);
      if (existingUser) {
        return res.status(400).json({ 
          status: 'error',
          message: 'User with this email already exists' 
        });
      }
      
      // Hash password
      const saltRounds = 10;
      const hashedPassword = await bcrypt.hash(password, saltRounds);
      
      // Create user with hashed password
      const newUser = await userQueries.createUser(
        username, 
        email, 
        hashedPassword
      );
      
      res.status(201).json({
        status: 'success',
        message: 'User registered successfully',
        data: {
          id: newUser.id,
          username: newUser.username,
          email: newUser.email,
          role: newUser.role,
          created_at: newUser.created_at
        }
      });
      
    } catch (error) {
      next(error);
    }
  },
  
  // Login user
  login: async (req, res, next) => {
    try {
      // Validate request data
      const errors = validationResult(req);
      if (!errors.isEmpty()) {
        return res.status(400).json({ 
          status: 'error',
          errors: errors.array() 
        });
      }
      
      const { email, password } = req.body;
      
      // Find user by email
      const user = await userQueries.findUserByEmail(email);
      if (!user) {
        return res.status(401).json({
          status: 'error',
          message: 'Invalid email or password'
        });
      }
      
      // Compare passwords
      const isPasswordValid = await bcrypt.compare(password, user.password);
      if (!isPasswordValid) {
        return res.status(401).json({
          status: 'error',
          message: 'Invalid email or password'
        });
      }
      
      // Generate JWT token
      const token = generateToken(user.id, user.role);
      
      res.status(200).json({
        status: 'success',
        message: 'Login successful',
        data: {
          id: user.id,
          username: user.username,
          email: user.email,
          role: user.role,
          token
        }
      });
      
    } catch (error) {
      next(error);
    }
  },
  
  // Get current user profile
  getProfile: async (req, res, next) => {
    try {
      // User ID is available from the JWT token verification
      const userId = req.user.id;
      
      // Get user details (excluding password)
      const user = await userQueries.findUserById(userId);
      
      if (!user) {
        return res.status(404).json({
          status: 'error',
          message: 'User not found'
        });
      }
      
      res.status(200).json({
        status: 'success',
        data: {
          id: user.id,
          username: user.username,
          email: user.email,
          role: user.role,
          created_at: user.created_at
        }
      });
      
    } catch (error) {
      next(error);
    }
  }
};

module.exports = authController;
```

### models/userQueries.js (Updated)

```javascript
const pool = require('../config/db');

const userQueries = {
  // Create a new user (existing from Day 1)
  createUser: async (username, email, password, role = 'user') => {
    const query = `
      INSERT INTO users (username, email, password, role)
      VALUES ($1, $2, $3, $4)
      RETURNING id, username, email, role, created_at
    `;
    
    const values = [username, email, password, role];
    
    try {
      const result = await pool.query(query, values);
      return result.rows[0];
    } catch (error) {
      throw error;
    }
  },
  
  // Check if a user exists by email (existing from Day 1)
  findUserByEmail: async (email) => {
    const query = `
      SELECT * FROM users
      WHERE email = $1
    `;
    
    try {
      const result = await pool.query(query, [email]);
      return result.rows[0];
    } catch (error) {
      throw error;
    }
  },
  
  // Find user by ID
  findUserById: async (id) => {
    const query = `
      SELECT id, username, email, role, created_at, updated_at
      FROM users
      WHERE id = $1
    `;
    
    try {
      const result = await pool.query(query, [id]);
      return result.rows[0];
    } catch (error) {
      throw error;
    }
  }
};

module.exports = userQueries;
```

### routes/authRoutes.js (Updated)

```javascript
const express = require('express');
const { body } = require('express-validator');
const router = express.Router();
const authController = require('../controllers/authController');
const authenticate = require('../middleware/auth');

// Validation middleware
const registerValidation = [
  body('username').notEmpty().withMessage('Username is required'),
  body('email').isEmail().withMessage('Valid email is required'),
  body('password').isLength({ min: 6 }).withMessage('Password must be at least 6 characters')
];

const loginValidation = [
  body('email').isEmail().withMessage('Valid email is required'),
  body('password').notEmpty().withMessage('Password is required')
];

// Public routes
router.post('/register', registerValidation, authController.register);
router.post('/login', loginValidation, authController.login);

// Protected routes
router.get('/profile', authenticate, authController.getProfile);

module.exports = router;
```

### Update to .env (Add JWT Secret)

```
JWT_SECRET=your_jwt_secret_key
JWT_EXPIRES_IN=1d
```

## 🔒 Security & Validation Notes

- JWT tokens are used for stateless authentication
- Passwords are verified using bcrypt's compare function
- Input validation using express-validator
- Role-based access control implementation
- Token expiration to limit the lifetime of issued tokens

## 🧪 API Testing Tips

### Login User

```bash
# Using curl
curl -X POST http://localhost:3000/api/auth/login \
  -H "Content-Type: application/json" \
  -d '{"email":"test@example.com","password":"password123"}'
```

### Get User Profile (Authenticated)

```bash
# Using curl (replace YOUR_JWT_TOKEN with actual token from login)
curl -X GET http://localhost:3000/api/auth/profile \
  -H "Authorization: Bearer YOUR_JWT_TOKEN"
```

## 🚀 Day 2 Implementation Steps

1. **Install JWT dependencies**:
   - Install jsonwebtoken and express-validator

2. **Set up JWT utilities**:
   - Create JWT token generation and verification functions

3. **Create authentication middleware**:
   - Implement middleware to verify tokens
   - Create role-based access control middleware

4. **Update User Model**:
   - Add function to find user by ID

5. **Update Auth Controller**:
   - Implement login functionality with password verification
   - Create get profile endpoint

6. **Update Routes**:
   - Add validation to endpoints
   - Protect routes with authentication middleware

7. **Test Authentication Flow**:
   - Register a user
   - Login and obtain JWT token
   - Access protected route using the token

## 📝 Notes and Best Practices

- Store JWT secrets in environment variables, never hardcode them
- Use proper error messages (don't expose sensitive information)
- Set reasonable token expiration times
- Implement proper input validation
- Use consistent response formats

## 🔄 Next Steps

On Day 3, we will focus on implementing role-based authorization and creating admin user functionality.
