# Express.js + PostgreSQL E-commerce Backend Project

This project guides you through building a complete backend for an e-commerce application using Express.js and PostgreSQL with raw SQL queries. The development is structured as a 10-day learning journey, with each day focused on specific aspects of backend development.

## Project Overview

### Core Features:
- User authentication and authorization (Admin and Regular User roles)
- Product management with image uploads
- Shopping cart functionality
- Order processing with status management
- RESTful API design

### Technology Stack:
- **Node.js & Express.js**: Server framework
- **PostgreSQL**: Database (using raw SQL queries with `pg` module)
- **bcrypt**: Password hashing
- **JWT/express-session**: Authentication
- **Multer**: File uploads
- **express-validator**: Input validation

### Project Structure:
```
express_ecommerce/
│
├── config/
│   └── db.js                 # PostgreSQL pool setup
├── controllers/
│   ├── authController.js
│   ├── productController.js
│   ├── cartController.js
│   ├── orderController.js
│   └── uploadController.js
├── models/
│   ├── userQueries.js
│   ├── productQueries.js
│   ├── cartQueries.js
│   ├── orderQueries.js
│   └── orderItemQueries.js
├── routes/
│   ├── authRoutes.js
│   ├── productRoutes.js
│   ├── cartRoutes.js
│   ├── orderRoutes.js
│   └── uploadRoutes.js
├── middleware/
│   ├── auth.js               # JWT or session auth
│   ├── roleCheck.js          # admin/user
│   └── validation.js         # input validation
├── utils/
│   └── upload.js             # multer config for images
├── media/
│   └── uploads/              # uploaded product images
├── app.js                    # Express app setup
└── server.js                 # Server entry point
```

## Day-by-Day Development Guide

The project is divided into 10 days of focused development:

1. **Day 1**: Project Initialization, Express Setup, PostgreSQL Connection, and User Registration Endpoint
2. **Day 2**: User Authentication, JWT/Session Setup, and Login Endpoint
3. **Day 3**: Role-based Authorization and Admin User Setup
4. **Day 4**: Product Management API with Image Upload
5. **Day 5**: Shopping Cart Implementation
6. **Day 6**: Order Processing and Management
7. **Day 7**: Order Status Management and Admin Controls
8. **Day 8**: Input Validation, Error Handling, and Security Improvements
9. **Day 9**: Testing, Debugging, and Performance Optimization
10. **Day 10**: Final Touches, Documentation, and Deployment Preparation

Each day has its own detailed document with specific tasks, code examples, and learning objectives.

## Getting Started

To begin the project, follow the instructions in the Day 1 documentation file. Each subsequent day builds upon the previous day's work.

Ensure you have Node.js and PostgreSQL installed on your system before starting.
