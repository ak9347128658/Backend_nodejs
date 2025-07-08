-- Create a database called "retail_store"
CREATE DATABASE retail_store;

-- Connect to the database
-- \c retail_store

-- Create customers table
CREATE TABLE customers (
    id SERIAL PRIMARY KEY,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    email VARCHAR(100) UNIQUE,
    phone VARCHAR(20),
    address TEXT
);

-- Create categories table
CREATE TABLE categories (
    id SERIAL PRIMARY KEY,
    name VARCHAR(50) NOT NULL,
    description TEXT
);

-- Create products table with foreign key to categories
CREATE TABLE products (
    id SERIAL PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    description TEXT,
    price NUMERIC(10, 2) CHECK (price > 0),
    stock_quantity INTEGER DEFAULT 0,
    category_id INTEGER REFERENCES categories(id)
);

-- Create orders table with foreign key to customers
CREATE TABLE orders (
    id SERIAL PRIMARY KEY,
    customer_id INTEGER REFERENCES customers(id),
    order_date DATE DEFAULT CURRENT_DATE,
    total_amount NUMERIC(12, 2) CHECK (total_amount >= 0),
    status VARCHAR(20) DEFAULT 'Pending' CHECK (status IN ('Pending', 'Processing', 'Shipped', 'Delivered', 'Cancelled'))
);

-- Create order_items table with composite primary key and foreign keys
CREATE TABLE order_items (
    order_id INTEGER REFERENCES orders(id),
    product_id INTEGER REFERENCES products(id),
    quantity INTEGER CHECK (quantity > 0),
    unit_price NUMERIC(10, 2),
    PRIMARY KEY (order_id, product_id)
);

-- Add a new column to customers table
ALTER TABLE customers ADD COLUMN registration_date DATE DEFAULT CURRENT_DATE;

-- Rename a column in products table
ALTER TABLE products RENAME COLUMN stock_quantity TO inventory_count;
