-- Week 3, Day 2: Views and Materialized Views
-- Examples

-- Setup some sample tables for our examples
CREATE TABLE IF NOT EXISTS customers (
    customer_id SERIAL PRIMARY KEY,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    address_id INTEGER,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE IF NOT EXISTS addresses (
    address_id SERIAL PRIMARY KEY,
    street VARCHAR(100) NOT NULL,
    city VARCHAR(50) NOT NULL,
    state VARCHAR(50),
    country VARCHAR(50) NOT NULL,
    postal_code VARCHAR(20)
);

CREATE TABLE IF NOT EXISTS employees (
    employee_id SERIAL PRIMARY KEY,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    department_id INTEGER,
    salary NUMERIC(10, 2) NOT NULL,
    is_active BOOLEAN DEFAULT TRUE
);

CREATE TABLE IF NOT EXISTS departments (
    department_id SERIAL PRIMARY KEY,
    department_name VARCHAR(100) NOT NULL,
    manager_id INTEGER
);

CREATE TABLE IF NOT EXISTS orders (
    order_id SERIAL PRIMARY KEY,
    customer_id INTEGER REFERENCES customers(customer_id),
    order_date DATE NOT NULL,
    status CHAR(1) CHECK (status IN ('P', 'S', 'D')), -- Processing, Shipped, Delivered
    total_amount NUMERIC(10, 2)
);

CREATE TABLE IF NOT EXISTS categories (
    category_id SERIAL PRIMARY KEY,
    category_name VARCHAR(100) NOT NULL,
    description TEXT
);

CREATE TABLE IF NOT EXISTS products (
    product_id SERIAL PRIMARY KEY,
    product_name VARCHAR(100) NOT NULL,
    category_id INTEGER REFERENCES categories(category_id),
    unit_price NUMERIC(10, 2) NOT NULL,
    stock_quantity INTEGER NOT NULL
);

CREATE TABLE IF NOT EXISTS order_items (
    item_id SERIAL PRIMARY KEY,
    order_id INTEGER REFERENCES orders(order_id),
    product_id INTEGER REFERENCES products(product_id),
    quantity INTEGER NOT NULL CHECK (quantity > 0),
    unit_price NUMERIC(10, 2) NOT NULL
);

-- Insert some sample data
INSERT INTO departments (department_id, department_name) VALUES 
(1, 'IT'),
(2, 'Sales'),
(3, 'Marketing'),
(4, 'Human Resources');

INSERT INTO employees (employee_id, first_name, last_name, email, department_id, salary, is_active) VALUES
(1, 'Alice', 'Johnson', 'alice.johnson@example.com', 1, 85000.00, TRUE),
(2, 'Bob', 'Smith', 'bob.smith@example.com', 2, 72000.00, TRUE),
(3, 'Carol', 'Williams', 'carol.williams@example.com', 3, 78000.00, TRUE),
(4, 'David', 'Brown', 'david.brown@example.com', 4, 65000.00, TRUE),
(5, 'Eve', 'Davis', 'eve.davis@example.com', 1, 90000.00, TRUE),
(6, 'Frank', 'Miller', 'frank.miller@example.com', 2, 45000.00, FALSE);

INSERT INTO addresses (address_id, street, city, state, country, postal_code) VALUES
(1, '123 Main St', 'New York', 'NY', 'USA', '10001'),
(2, '456 Oak Ave', 'Los Angeles', 'CA', 'USA', '90001'),
(3, '789 Pine Rd', 'Chicago', 'IL', 'USA', '60601'),
(4, '101 Maple Dr', 'Toronto', NULL, 'Canada', 'M5V 2L7'),
(5, '202 Cedar Ln', 'London', NULL, 'UK', 'SW1A 1AA');

INSERT INTO customers (customer_id, first_name, last_name, email, address_id) VALUES
(1, 'John', 'Doe', 'john.doe@example.com', 1),
(2, 'Jane', 'Smith', 'jane.smith@example.com', 2),
(3, 'Robert', 'Johnson', 'robert.johnson@example.com', 3),
(4, 'Lisa', 'Brown', 'lisa.brown@example.com', 4),
(5, 'Michael', 'Wilson', 'michael.wilson@example.com', 5);

INSERT INTO categories (category_id, category_name, description) VALUES
(1, 'Electronics', 'Electronic devices and accessories'),
(2, 'Clothing', 'Apparel and fashion items'),
(3, 'Books', 'Books and publications');

INSERT INTO products (product_id, product_name, category_id, unit_price, stock_quantity) VALUES
(1, 'Smartphone', 1, 699.99, 50),
(2, 'Laptop', 1, 1299.99, 30),
(3, 'T-shirt', 2, 19.99, 200),
(4, 'Jeans', 2, 49.99, 150),
(5, 'SQL Programming Guide', 3, 39.99, 75),
(6, 'Data Science Handbook', 3, 59.99, 40);

INSERT INTO orders (order_id, customer_id, order_date, status, total_amount) VALUES
(1, 1, '2023-01-15', 'D', 1399.98),
(2, 2, '2023-02-20', 'S', 749.98),
(3, 3, '2023-03-10', 'P', 119.97),
(4, 4, '2023-04-05', 'D', 1399.99),
(5, 5, '2023-05-12', 'S', 159.97);

INSERT INTO order_items (order_id, product_id, quantity, unit_price) VALUES
(1, 2, 1, 1299.99),
(1, 5, 1, 39.99),
(1, 6, 1, 59.99),
(2, 1, 1, 699.99),
(2, 5, 1, 39.99),
(2, 3, 1, 19.99),
(3, 3, 3, 19.99),
(3, 5, 1, 39.99),
(4, 2, 1, 1299.99),
(4, 6, 1, 59.99),
(4, 3, 2, 19.99),
(5, 4, 3, 49.99),
(5, 3, 1, 19.99);

-- Example 1: Creating a Basic View
-- Views provide a way to simplify complex queries and present a clear interface to users
CREATE OR REPLACE VIEW customer_info AS
SELECT 
    c.customer_id, 
    c.first_name, 
    c.last_name, 
    c.email, 
    a.city, 
    a.country
FROM 
    customers c
JOIN 
    addresses a ON c.address_id = a.address_id;

-- Using the view
SELECT * FROM customer_info WHERE country = 'USA';

-- Example 2: Creating a View with Computed Columns
CREATE OR REPLACE VIEW order_summary AS
SELECT 
    o.order_id,
    c.first_name || ' ' || c.last_name AS customer_name,
    COUNT(oi.item_id) AS items_count,
    SUM(oi.quantity * oi.unit_price) AS total_amount,
    o.order_date,
    CASE 
        WHEN o.status = 'D' THEN 'Delivered'
        WHEN o.status = 'P' THEN 'Processing'
        WHEN o.status = 'S' THEN 'Shipped'
        ELSE 'Unknown'
    END AS status_description
FROM 
    orders o
JOIN 
    customers c ON o.customer_id = c.customer_id
JOIN 
    order_items oi ON o.order_id = oi.order_id
GROUP BY 
    o.order_id, c.first_name, c.last_name, o.order_date, o.status;

-- Query the view
SELECT * FROM order_summary WHERE total_amount > 1000;

-- Example 3: Updatable Views
CREATE OR REPLACE VIEW active_employees AS
SELECT 
    employee_id,
    first_name,
    last_name,
    email,
    department_id,
    salary
FROM 
    employees
WHERE 
    is_active = TRUE;

-- Operations on an updatable view
-- Insert through the view
INSERT INTO active_employees (
    employee_id, first_name, last_name, email, department_id, salary
) VALUES (
    101, 'John', 'Smith', 'john.smith@example.com', 3, 75000
);

-- Update through the view
UPDATE active_employees SET salary = 80000 WHERE employee_id = 101;

-- Delete through the view
DELETE FROM active_employees WHERE employee_id = 101;

-- Example 4: Views with Check Option
CREATE OR REPLACE VIEW high_salary_employees AS
SELECT 
    employee_id,
    first_name,
    last_name,
    department_id,
    salary
FROM 
    employees
WHERE 
    salary > 50000
WITH CHECK OPTION;

-- This will succeed
INSERT INTO high_salary_employees (employee_id, first_name, last_name, email, department_id, salary) 
VALUES (102, 'Jane', 'Doe', 'jane.doe@example.com', 2, 60000);

-- This will fail because the salary doesn't meet the view's criteria
-- Uncomment to see the error
-- INSERT INTO high_salary_employees (employee_id, first_name, last_name, email, department_id, salary) 
-- VALUES (103, 'Bob', 'Johnson', 'bob.johnson@example.com', 1, 45000);

-- Example 5: Materialized Views
CREATE MATERIALIZED VIEW monthly_sales_summary AS
SELECT 
    DATE_TRUNC('month', o.order_date) AS month,
    p.category_id,
    c.category_name,
    SUM(oi.quantity * oi.unit_price) AS total_sales,
    COUNT(DISTINCT o.customer_id) AS unique_customers
FROM 
    orders o
JOIN 
    order_items oi ON o.order_id = oi.order_id
JOIN 
    products p ON oi.product_id = p.product_id
JOIN 
    categories c ON p.category_id = c.category_id
GROUP BY 
    DATE_TRUNC('month', o.order_date), p.category_id, c.category_name;

-- Query the materialized view
SELECT * FROM monthly_sales_summary ORDER BY month, category_id;

-- Example 6: Refreshing Materialized Views
-- Make some changes to the underlying data
INSERT INTO orders (order_id, customer_id, order_date, status, total_amount) VALUES
(6, 1, '2023-06-20', 'D', 799.98);

INSERT INTO order_items (order_id, product_id, quantity, unit_price) VALUES
(6, 1, 1, 699.99),
(6, 5, 1, 39.99);

-- The materialized view doesn't see these changes yet
-- Refresh it to update
REFRESH MATERIALIZED VIEW monthly_sales_summary;

-- Now the new data will be visible
SELECT * FROM monthly_sales_summary ORDER BY month, category_id;

-- Example 7: Using Indexes with Materialized Views
-- Create an index on a materialized view
CREATE INDEX idx_monthly_sales_category
ON monthly_sales_summary(category_id);

-- Create a unique index to enable concurrent refreshes
CREATE UNIQUE INDEX idx_monthly_sales_month_category
ON monthly_sales_summary(month, category_id);

-- Example 8: View Information
-- To see information about views in your database
SELECT 
    table_schema,
    table_name,
    view_definition
FROM 
    information_schema.views
WHERE 
    table_schema NOT IN ('pg_catalog', 'information_schema')
ORDER BY 
    table_schema, table_name;

-- To see information about materialized views
SELECT 
    schemaname,
    matviewname,
    matviewowner,
    ispopulated
FROM 
    pg_matviews
ORDER BY 
    schemaname, matviewname;

-- Cleanup - Drop sample objects (uncomment if needed)
/*
DROP MATERIALIZED VIEW IF EXISTS monthly_sales_summary;
DROP VIEW IF EXISTS high_salary_employees;
DROP VIEW IF EXISTS active_employees;
DROP VIEW IF EXISTS order_summary;
DROP VIEW IF EXISTS customer_info;

DROP TABLE IF EXISTS order_items;
DROP TABLE IF EXISTS orders;
DROP TABLE IF EXISTS products;
DROP TABLE IF EXISTS categories;
DROP TABLE IF EXISTS customers;
DROP TABLE IF EXISTS addresses;
DROP TABLE IF EXISTS employees;
DROP TABLE IF EXISTS departments;
*/
