-- Using the "retail_store" database
-- If you need to create it again:
-- CREATE DATABASE retail_store;
-- \c retail_store

-- Recreate tables if needed
CREATE TABLE IF NOT EXISTS customers (
    id SERIAL PRIMARY KEY,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    email VARCHAR(100) UNIQUE,
    phone VARCHAR(20),
    address TEXT,
    registration_date DATE DEFAULT CURRENT_DATE
);

CREATE TABLE IF NOT EXISTS categories (
    id SERIAL PRIMARY KEY,
    name VARCHAR(50) NOT NULL,
    description TEXT
);

CREATE TABLE IF NOT EXISTS products (
    id SERIAL PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    description TEXT,
    price NUMERIC(10, 2) CHECK (price > 0),
    inventory_count INTEGER DEFAULT 0,
    category_id INTEGER REFERENCES categories(id)
);

CREATE TABLE IF NOT EXISTS orders (
    id SERIAL PRIMARY KEY,
    customer_id INTEGER REFERENCES customers(id),
    order_date DATE DEFAULT CURRENT_DATE,
    total_amount NUMERIC(12, 2) CHECK (total_amount >= 0),
    status VARCHAR(20) DEFAULT 'Pending' CHECK (status IN ('Pending', 'Processing', 'Shipped', 'Delivered', 'Cancelled'))
);

CREATE TABLE IF NOT EXISTS order_items (
    order_id INTEGER REFERENCES orders(id) ON DELETE CASCADE,
    product_id INTEGER REFERENCES products(id),
    quantity INTEGER CHECK (quantity > 0),
    unit_price NUMERIC(10, 2),
    PRIMARY KEY (order_id, product_id)
);

-- Exercise 1: Insert data into tables

-- Insert customers
INSERT INTO customers (first_name, last_name, email, phone, address)
VALUES 
    ('John', 'Doe', 'john.doe@example.com', '555-123-4567', '123 Main St, Anytown, USA'),
    ('Jane', 'Smith', 'jane.smith@example.com', '555-234-5678', '456 Oak Ave, Somewhere, USA'),
    ('Robert', 'Johnson', 'robert.johnson@example.com', '555-345-6789', '789 Pine Rd, Nowhere, USA'),
    ('Emily', 'Williams', 'emily.williams@example.com', '555-456-7890', '321 Maple Dr, Anywhere, USA'),
    ('Michael', 'Brown', 'michael.brown@example.com', '555-567-8901', '654 Cedar Ln, Everywhere, USA');

-- Insert categories
INSERT INTO categories (name, description)
VALUES 
    ('Electronics', 'Electronic devices and accessories'),
    ('Clothing', 'Apparel and fashion items'),
    ('Home & Kitchen', 'Products for home and kitchen use');

-- Insert products
INSERT INTO products (name, description, price, inventory_count, category_id)
VALUES 
    ('Smartphone', 'Latest model smartphone with advanced features', 799.99, 50, 1),
    ('Laptop', 'High-performance laptop for work and gaming', 1299.99, 30, 1),
    ('Wireless Earbuds', 'Bluetooth earbuds with noise cancellation', 149.99, 100, 1),
    ('Smart Watch', 'Fitness tracking and notifications', 249.99, 45, 1),
    ('T-shirt', 'Cotton t-shirt, various colors', 19.99, 200, 2),
    ('Jeans', 'Classic denim jeans', 49.99, 150, 2),
    ('Dress Shirt', 'Formal dress shirt for professional settings', 59.99, 80, 2),
    ('Coffee Maker', 'Programmable coffee maker', 89.99, 40, 3),
    ('Blender', 'High-speed blender for smoothies and more', 79.99, 35, 3),
    ('Cookware Set', 'Complete set of non-stick cookware', 199.99, 25, 3);

-- Insert orders
INSERT INTO orders (customer_id, order_date, total_amount, status)
VALUES 
    (1, '2023-07-01', 849.98, 'Delivered'),
    (2, '2023-07-05', 199.97, 'Shipped'),
    (3, '2023-07-10', 1299.99, 'Pending');

-- Insert order_items
INSERT INTO order_items (order_id, product_id, quantity, unit_price)
VALUES 
    (1, 1, 1, 799.99),
    (1, 3, 1, 149.99),
    (2, 5, 2, 19.99),
    (2, 8, 1, 89.99),
    (3, 2, 1, 1299.99);

-- Exercise 2: UPDATE operations

-- Update the price of all products in the Electronics category by increasing 5%
UPDATE products
SET price = price * 1.05
WHERE category_id = 1;

-- Update a customer's contact information
UPDATE customers
SET 
    phone = '555-999-8888',
    address = '888 Updated St, Newtown, USA'
WHERE id = 4;

-- Update order status from Pending to Shipped
UPDATE orders
SET status = 'Shipped'
WHERE id = 3;

-- Exercise 3: DELETE operations

-- Create an archived_orders table for Exercise 5
CREATE TABLE archived_orders (
    id INTEGER PRIMARY KEY,
    customer_id INTEGER,
    order_date DATE,
    total_amount NUMERIC(12, 2),
    status VARCHAR(20),
    archived_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Delete a specific order and its order items
-- With ON DELETE CASCADE in the order_items table, this will delete related order items automatically
DELETE FROM orders 
WHERE id = 2
RETURNING *;

-- Delete all products with zero inventory
UPDATE products
SET inventory_count = 0
WHERE id = 7;

DELETE FROM products
WHERE inventory_count = 0
RETURNING *;

-- Exercise 4: Using RETURNING clause
-- Already used RETURNING in previous exercises

-- Exercise 5: Move cancelled orders to archived_orders
-- First, let's create a cancelled order
INSERT INTO orders (customer_id, order_date, total_amount, status)
VALUES (5, '2023-07-15', 299.98, 'Cancelled');

-- Now move all cancelled orders to archived_orders
INSERT INTO archived_orders (id, customer_id, order_date, total_amount, status)
SELECT id, customer_id, order_date, total_amount, status
FROM orders
WHERE status = 'Cancelled';

-- Then delete the cancelled orders
DELETE FROM orders
WHERE status = 'Cancelled'
RETURNING *;
