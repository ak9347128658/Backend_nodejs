# Day 3: Role-based Authorization and Admin User Setup

## 🎯 Goal

Implement role-based authorization, create admin user functionality, and set up admin-only routes.

## 📝 Tasks

1. Create admin user seeding script
2. Implement admin-specific controllers
3. Create admin routes with role verification
4. Set up a system to manage users (admin function)
5. Test admin authorization flow

## 📂 Folder & File Structure (New/Updated Files)

```
express_ecommerce/
├── controllers/
│   ├── authController.js (updated)
│   └── adminController.js (new)
├── models/
│   └── userQueries.js (updated)
├── routes/
│   ├── authRoutes.js (updated)
│   └── adminRoutes.js (new)
├── utils/
│   └── seedAdmin.js (new)
└── app.js (updated)
```

## 🖥️ Code Snippets

### utils/seedAdmin.js

```javascript
const bcrypt = require('bcrypt');
const pool = require('../config/db');
require('dotenv').config();

const createAdminUser = async () => {
  try {
    // Check if admin already exists
    const checkQuery = `
      SELECT * FROM users
      WHERE email = $1 AND role = 'admin'
    `;
    
    const checkResult = await pool.query(checkQuery, [process.env.ADMIN_EMAIL]);
    
    if (checkResult.rows.length > 0) {
      console.log('Admin user already exists');
      return;
    }
    
    // Create admin user
    const saltRounds = 10;
    const hashedPassword = await bcrypt.hash(process.env.ADMIN_PASSWORD, saltRounds);
    
    const insertQuery = `
      INSERT INTO users (username, email, password, role)
      VALUES ($1, $2, $3, $4)
      RETURNING id, username, email, role
    `;
    
    const values = [
      process.env.ADMIN_USERNAME || 'admin',
      process.env.ADMIN_EMAIL || 'admin@example.com',
      hashedPassword,
      'admin'
    ];
    
    const result = await pool.query(insertQuery, values);
    
    console.log('Admin user created successfully:', result.rows[0]);
    
  } catch (error) {
    console.error('Error creating admin user:', error.message);
  }
};

// Execute if this file is run directly
if (require.main === module) {
  createAdminUser()
    .then(() => {
      console.log('Admin seeding complete');
      process.exit(0);
    })
    .catch(err => {
      console.error('Admin seeding failed:', err);
      process.exit(1);
    });
}

module.exports = { createAdminUser };
```

### controllers/adminController.js

```javascript
const userQueries = require('../models/userQueries');

const adminController = {
  // Get all users (admin only)
  getAllUsers: async (req, res, next) => {
    try {
      const users = await userQueries.findAllUsers();
      
      res.status(200).json({
        status: 'success',
        results: users.length,
        data: { users }
      });
      
    } catch (error) {
      next(error);
    }
  },
  
  // Get user by ID (admin only)
  getUserById: async (req, res, next) => {
    try {
      const { id } = req.params;
      
      const user = await userQueries.findUserById(id);
      
      if (!user) {
        return res.status(404).json({
          status: 'error',
          message: 'User not found'
        });
      }
      
      res.status(200).json({
        status: 'success',
        data: { user }
      });
      
    } catch (error) {
      next(error);
    }
  },
  
  // Update user role (admin only)
  updateUserRole: async (req, res, next) => {
    try {
      const { id } = req.params;
      const { role } = req.body;
      
      // Validate role
      if (!['admin', 'user'].includes(role)) {
        return res.status(400).json({
          status: 'error',
          message: 'Invalid role. Role must be either "admin" or "user"'
        });
      }
      
      // Check if user exists
      const existingUser = await userQueries.findUserById(id);
      
      if (!existingUser) {
        return res.status(404).json({
          status: 'error',
          message: 'User not found'
        });
      }
      
      // Update user role
      const updatedUser = await userQueries.updateUserRole(id, role);
      
      res.status(200).json({
        status: 'success',
        message: 'User role updated successfully',
        data: { user: updatedUser }
      });
      
    } catch (error) {
      next(error);
    }
  },
  
  // Delete user (admin only)
  deleteUser: async (req, res, next) => {
    try {
      const { id } = req.params;
      
      // Check if user exists
      const existingUser = await userQueries.findUserById(id);
      
      if (!existingUser) {
        return res.status(404).json({
          status: 'error',
          message: 'User not found'
        });
      }
      
      // Don't allow admins to delete themselves
      if (existingUser.id === req.user.id) {
        return res.status(400).json({
          status: 'error',
          message: 'Cannot delete your own admin account'
        });
      }
      
      // Delete user
      await userQueries.deleteUser(id);
      
      res.status(200).json({
        status: 'success',
        message: 'User deleted successfully'
      });
      
    } catch (error) {
      next(error);
    }
  }
};

module.exports = adminController;
```

### models/userQueries.js (Updated)

```javascript
const pool = require('../config/db');

const userQueries = {
  // Existing methods from Day 1 and Day 2...
  
  // Find all users
  findAllUsers: async () => {
    const query = `
      SELECT id, username, email, role, created_at, updated_at
      FROM users
      ORDER BY id
    `;
    
    try {
      const result = await pool.query(query);
      return result.rows;
    } catch (error) {
      throw error;
    }
  },
  
  // Update user role
  updateUserRole: async (userId, role) => {
    const query = `
      UPDATE users
      SET role = $1, updated_at = CURRENT_TIMESTAMP
      WHERE id = $2
      RETURNING id, username, email, role, created_at, updated_at
    `;
    
    try {
      const result = await pool.query(query, [role, userId]);
      return result.rows[0];
    } catch (error) {
      throw error;
    }
  },
  
  // Delete user
  deleteUser: async (userId) => {
    const query = `
      DELETE FROM users
      WHERE id = $1
    `;
    
    try {
      await pool.query(query, [userId]);
      return true;
    } catch (error) {
      throw error;
    }
  }
};

module.exports = userQueries;
```

### routes/adminRoutes.js

```javascript
const express = require('express');
const router = express.Router();
const adminController = require('../controllers/adminController');
const authenticate = require('../middleware/auth');
const { checkRole } = require('../middleware/roleCheck');
const { body } = require('express-validator');

// All routes require authentication and admin role
router.use(authenticate, checkRole(['admin']));

// Get all users
router.get('/users', adminController.getAllUsers);

// Get user by ID
router.get('/users/:id', adminController.getUserById);

// Update user role
router.patch(
  '/users/:id/role',
  [body('role').isIn(['admin', 'user']).withMessage('Role must be either "admin" or "user"')],
  adminController.updateUserRole
);

// Delete user
router.delete('/users/:id', adminController.deleteUser);

module.exports = router;
```

### app.js (Updated)

```javascript
const express = require('express');
const cors = require('cors');
const authRoutes = require('./routes/authRoutes');
const adminRoutes = require('./routes/adminRoutes');
const errorHandler = require('./middleware/errorHandler');

// Initialize Express app
const app = express();

// Middleware
app.use(cors());
app.use(express.json());
app.use(express.urlencoded({ extended: true }));

// Routes
app.use('/api/auth', authRoutes);
app.use('/api/admin', adminRoutes);

// Basic route for testing
app.get('/', (req, res) => {
  res.json({ message: 'Welcome to the E-commerce API' });
});

// Error handling middleware
app.use(errorHandler);

module.exports = app;
```

### Update to .env (Add Admin Credentials)

```
ADMIN_USERNAME=admin
ADMIN_EMAIL=admin@example.com
ADMIN_PASSWORD=adminPassword123
```

## 🧪 API Testing Tips

### Create Admin User (Run Script)

```bash
# Run the admin seeding script
node utils/seedAdmin.js
```

### Admin Login

```bash
# Using curl
curl -X POST http://localhost:3000/api/auth/login \
  -H "Content-Type: application/json" \
  -d '{"email":"admin@example.com","password":"adminPassword123"}'
```

### Get All Users (Admin Only)

```bash
# Using curl (replace ADMIN_JWT_TOKEN with actual token from admin login)
curl -X GET http://localhost:3000/api/admin/users \
  -H "Authorization: Bearer ADMIN_JWT_TOKEN"
```

### Update User Role

```bash
# Using curl (replace ADMIN_JWT_TOKEN and USER_ID with actual values)
curl -X PATCH http://localhost:3000/api/admin/users/USER_ID/role \
  -H "Authorization: Bearer ADMIN_JWT_TOKEN" \
  -H "Content-Type: application/json" \
  -d '{"role":"admin"}'
```

### Delete User

```bash
# Using curl (replace ADMIN_JWT_TOKEN and USER_ID with actual values)
curl -X DELETE http://localhost:3000/api/admin/users/USER_ID \
  -H "Authorization: Bearer ADMIN_JWT_TOKEN"
```

## 🔒 Security & Validation Notes

- Only administrators can access admin routes
- Admin users cannot delete their own accounts (to prevent admin lockout)
- Role validation ensures only valid roles are assigned
- All admin routes are protected with both authentication and role verification
- Proper error handling for not found and forbidden scenarios

## 🚀 Day 3 Implementation Steps

1. **Set up admin seeding**:
   - Create admin seeding script
   - Add admin credentials to environment variables

2. **Update user model**:
   - Add methods to find all users, update roles, and delete users

3. **Create admin controller**:
   - Implement CRUD operations for user management
   - Add role-based restrictions

4. **Add admin routes**:
   - Create dedicated router for admin-only endpoints
   - Apply authentication and role check middleware

5. **Update main app**:
   - Register admin routes
   - Ensure proper middleware order

6. **Test admin functionality**:
   - Create admin user via seeding script
   - Test admin login and protected endpoints

## 📝 Notes and Best Practices

- Always check user role before allowing access to admin functions
- Use middleware for consistent authentication and authorization
- Validate input data, especially when changing sensitive information like roles
- Prevent self-deletion to avoid locking out admin access
- Keep admin credentials in environment variables, never hardcode them

## 🔄 Next Steps

On Day 4, we'll implement the Product Management API with image upload functionality.
