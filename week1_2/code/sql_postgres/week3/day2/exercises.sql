-- Week 3, Day 2: Views and Materialized Views
-- Exercises

-- Use the following setup script to create and populate tables for these exercises
-- Note: This creates the same tables used in the examples

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
    hire_date DATE NOT NULL,
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

-- Insert sample data if tables are empty
INSERT INTO departments (department_id, department_name) 
SELECT * FROM (VALUES 
    (1, 'IT'),
    (2, 'Sales'),
    (3, 'Marketing'),
    (4, 'Human Resources')
) AS d WHERE NOT EXISTS (SELECT 1 FROM departments LIMIT 1);

INSERT INTO employees (employee_id, first_name, last_name, email, department_id, salary, hire_date, is_active) 
SELECT * FROM (VALUES 
    (1, 'Alice', 'Johnson', 'alice.johnson@example.com', 1, 85000.00, '2020-01-15', TRUE),
    (2, 'Bob', 'Smith', 'bob.smith@example.com', 2, 72000.00, '2019-05-20', TRUE),
    (3, 'Carol', 'Williams', 'carol.williams@example.com', 3, 78000.00, '2021-03-10', TRUE),
    (4, 'David', 'Brown', 'david.brown@example.com', 4, 65000.00, '2018-11-05', TRUE),
    (5, 'Eve', 'Davis', 'eve.davis@example.com', 1, 90000.00, '2022-02-18', TRUE),
    (6, 'Frank', 'Miller', 'frank.miller@example.com', 2, 45000.00, '2020-07-22', FALSE),
    (7, 'Grace', 'Wilson', 'grace.wilson@example.com', 3, 82000.00, '2021-09-30', TRUE),
    (8, 'Henry', 'Taylor', 'henry.taylor@example.com', 4, 68000.00, '2019-12-01', TRUE),
    (9, 'Ivy', 'Anderson', 'ivy.anderson@example.com', 1, 75000.00, '2022-04-15', TRUE),
    (10, 'Jack', 'Thomas', 'jack.thomas@example.com', 2, 48000.00, '2020-10-10', TRUE)
) AS e WHERE NOT EXISTS (SELECT 1 FROM employees LIMIT 1);

INSERT INTO addresses (address_id, street, city, state, country, postal_code) 
SELECT * FROM (VALUES
    (1, '123 Main St', 'New York', 'NY', 'USA', '10001'),
    (2, '456 Oak Ave', 'Los Angeles', 'CA', 'USA', '90001'),
    (3, '789 Pine Rd', 'Chicago', 'IL', 'USA', '60601'),
    (4, '101 Maple Dr', 'Toronto', NULL, 'Canada', 'M5V 2L7'),
    (5, '202 Cedar Ln', 'London', NULL, 'UK', 'SW1A 1AA'),
    (6, '303 Elm St', 'Sydney', 'NSW', 'Australia', '2000'),
    (7, '404 Birch Blvd', 'Paris', NULL, 'France', '75001'),
    (8, '505 Redwood Rd', 'Berlin', NULL, 'Germany', '10115')
) AS a WHERE NOT EXISTS (SELECT 1 FROM addresses LIMIT 1);

INSERT INTO customers (customer_id, first_name, last_name, email, address_id) 
SELECT * FROM (VALUES
    (1, 'John', 'Doe', 'john.doe@example.com', 1),
    (2, 'Jane', 'Smith', 'jane.smith@example.com', 2),
    (3, 'Robert', 'Johnson', 'robert.johnson@example.com', 3),
    (4, 'Lisa', 'Brown', 'lisa.brown@example.com', 4),
    (5, 'Michael', 'Wilson', 'michael.wilson@example.com', 5),
    (6, 'Emma', 'Garcia', 'emma.garcia@example.com', 6),
    (7, 'James', 'Martinez', 'james.martinez@example.com', 7),
    (8, 'Sophia', 'Lopez', 'sophia.lopez@example.com', 8)
) AS c WHERE NOT EXISTS (SELECT 1 FROM customers LIMIT 1);

INSERT INTO categories (category_id, category_name, description) 
SELECT * FROM (VALUES
    (1, 'Electronics', 'Electronic devices and accessories'),
    (2, 'Clothing', 'Apparel and fashion items'),
    (3, 'Books', 'Books and publications'),
    (4, 'Home & Kitchen', 'Home decor and kitchen appliances'),
    (5, 'Sports & Outdoors', 'Sports equipment and outdoor gear')
) AS c WHERE NOT EXISTS (SELECT 1 FROM categories LIMIT 1);

INSERT INTO products (product_id, product_name, category_id, unit_price, stock_quantity) 
SELECT * FROM (VALUES
    (1, 'Smartphone', 1, 699.99, 50),
    (2, 'Laptop', 1, 1299.99, 30),
    (3, 'T-shirt', 2, 19.99, 200),
    (4, 'Jeans', 2, 49.99, 150),
    (5, 'SQL Programming Guide', 3, 39.99, 75),
    (6, 'Data Science Handbook', 3, 59.99, 40),
    (7, 'Coffee Maker', 4, 89.99, 25),
    (8, 'Blender', 4, 69.99, 35),
    (9, 'Yoga Mat', 5, 29.99, 100),
    (10, 'Tennis Racket', 5, 129.99, 20),
    (11, 'Headphones', 1, 149.99, 60),
    (12, 'Monitor', 1, 249.99, 40),
    (13, 'Sweater', 2, 39.99, 120),
    (14, 'Jacket', 2, 79.99, 80),
    (15, 'PostgreSQL Cookbook', 3, 44.99, 50)
) AS p WHERE NOT EXISTS (SELECT 1 FROM products LIMIT 1);

INSERT INTO orders (order_id, customer_id, order_date, status, total_amount) 
SELECT * FROM (VALUES
    (1, 1, '2023-01-15', 'D', 1399.98),
    (2, 2, '2023-02-20', 'S', 749.98),
    (3, 3, '2023-03-10', 'P', 119.97),
    (4, 4, '2023-04-05', 'D', 1399.99),
    (5, 5, '2023-05-12', 'S', 159.97),
    (6, 6, '2023-06-18', 'D', 219.97),
    (7, 7, '2023-07-25', 'P', 599.98),
    (8, 8, '2023-08-03', 'S', 349.97),
    (9, 1, '2023-09-14', 'D', 279.98),
    (10, 2, '2023-10-22', 'P', 499.99),
    (11, 3, '2023-11-30', 'S', 169.99),
    (12, 4, '2023-12-10', 'D', 229.98)
) AS o WHERE NOT EXISTS (SELECT 1 FROM orders LIMIT 1);

INSERT INTO order_items (order_id, product_id, quantity, unit_price) 
SELECT * FROM (VALUES
    (1, 2, 1, 1299.99), (1, 5, 1, 39.99), (1, 6, 1, 59.99),
    (2, 1, 1, 699.99), (2, 5, 1, 39.99), (2, 3, 1, 19.99),
    (3, 3, 3, 19.99), (3, 5, 1, 39.99),
    (4, 2, 1, 1299.99), (4, 6, 1, 59.99), (4, 3, 2, 19.99),
    (5, 4, 3, 49.99), (5, 3, 1, 19.99),
    (6, 7, 1, 89.99), (6, 9, 1, 29.99), (6, 3, 5, 19.99),
    (7, 1, 1, 699.99), (7, 11, 1, 149.99),
    (8, 12, 1, 249.99), (8, 13, 2, 39.99), (8, 9, 1, 29.99),
    (9, 8, 1, 69.99), (9, 14, 1, 79.99), (9, 15, 1, 44.99), (9, 5, 1, 39.99),
    (10, 10, 1, 129.99), (10, 12, 1, 249.99), (10, 11, 1, 149.99),
    (11, 9, 1, 29.99), (11, 10, 1, 129.99),
    (12, 7, 1, 89.99), (12, 8, 1, 69.99), (12, 3, 1, 19.99), (12, 5, 1, 39.99)
) AS oi WHERE NOT EXISTS (SELECT 1 FROM order_items LIMIT 1);

-- Exercise 1: Basic View Creation
-- Create a view called "employee_department_view" that shows employee_id, full name (first + last), 
-- email, department_name, and salary

-- Your solution here:


-- Exercise 2: View with Conditional Logic
-- Create a view called "salary_bands" that categorizes employees into salary bands:
-- Under 50K: 'Entry Level'
-- 50K to 75K: 'Mid Level'
-- 75K to 90K: 'Senior Level'
-- 90K and above: 'Executive Level'
-- Include employee_id, full name, department_name, salary, and the salary band

-- Your solution here:


-- Exercise 3: Customer Geography View
-- Create a view called "customer_geography" that shows the number of customers and
-- their total order amounts by country. Include country, customer_count, and total_spent.

-- Your solution here:


-- Exercise 4: Updatable View with Check Option
-- Create an updatable view called "inventory_management" for products with low stock
-- (less than 50 items). Include all columns from the products table. 
-- Use the WITH CHECK OPTION to ensure only products with low stock can be added through this view.

-- Your solution here:


-- Exercise 5: Order Detail View
-- Create a view called "order_details_view" that shows comprehensive information about each order:
-- order_id, order_date, customer full name, status (readable, not the code), 
-- total number of items, total amount, and a list of product names concatenated as a string.

-- Your solution here:


-- Exercise 6: Employee Tenure View
-- Create a view called "employee_tenure" that shows each employee's tenure in years
-- (based on hire_date), along with their name, department, and salary. 
-- Include a column that ranks employees by tenure within their departments.

-- Your solution here:


-- Exercise 7: Materialized View for Sales Analytics
-- Create a materialized view called "quarterly_sales_report" that shows:
-- Year, quarter, category_name, total_sales, and year-over-year growth percentage.
-- You'll need to calculate quarters from the order_date and use window functions for the YoY growth.

-- Your solution here:


-- Exercise 8: Materialized View with Indexes
-- For the materialized view from Exercise 7, create appropriate indexes to optimize 
-- queries that filter by year, quarter, and category_name.

-- Your solution here:


-- Exercise 9: View Permissions
-- Write the SQL statements to:
-- 1. Create a role called "sales_analyst"
-- 2. Grant SELECT permission on the order_summary view (from the examples) to this role
-- 3. Grant SELECT permission on the quarterly_sales_report materialized view to this role

-- Your solution here:


-- Exercise 10: View Management
-- Write SQL statements to:
-- 1. List all views in the current database
-- 2. Show the definition of the "employee_department_view" view
-- 3. Alter the "salary_bands" view to add a column showing how much the salary differs from the average department salary
-- 4. Drop the "customer_geography" view

-- Your solution here:


-- Solutions:

/*
-- Exercise 1 Solution
CREATE OR REPLACE VIEW employee_department_view AS
SELECT 
    e.employee_id,
    e.first_name || ' ' || e.last_name AS full_name,
    e.email,
    d.department_name,
    e.salary
FROM 
    employees e
JOIN 
    departments d ON e.department_id = d.department_id;

-- Exercise 2 Solution
CREATE OR REPLACE VIEW salary_bands AS
SELECT 
    e.employee_id,
    e.first_name || ' ' || e.last_name AS full_name,
    d.department_name,
    e.salary,
    CASE 
        WHEN e.salary < 50000 THEN 'Entry Level'
        WHEN e.salary >= 50000 AND e.salary < 75000 THEN 'Mid Level'
        WHEN e.salary >= 75000 AND e.salary < 90000 THEN 'Senior Level'
        ELSE 'Executive Level'
    END AS salary_band
FROM 
    employees e
JOIN 
    departments d ON e.department_id = d.department_id;

-- Exercise 3 Solution
CREATE OR REPLACE VIEW customer_geography AS
SELECT 
    a.country,
    COUNT(DISTINCT c.customer_id) AS customer_count,
    COALESCE(SUM(o.total_amount), 0) AS total_spent
FROM 
    customers c
JOIN 
    addresses a ON c.address_id = a.address_id
LEFT JOIN 
    orders o ON c.customer_id = o.customer_id
GROUP BY 
    a.country;

-- Exercise 4 Solution
CREATE OR REPLACE VIEW inventory_management AS
SELECT 
    product_id,
    product_name,
    category_id,
    unit_price,
    stock_quantity
FROM 
    products
WHERE 
    stock_quantity < 50
WITH CHECK OPTION;

-- Exercise 5 Solution
CREATE OR REPLACE VIEW order_details_view AS
SELECT 
    o.order_id,
    o.order_date,
    c.first_name || ' ' || c.last_name AS customer_name,
    CASE 
        WHEN o.status = 'D' THEN 'Delivered'
        WHEN o.status = 'P' THEN 'Processing'
        WHEN o.status = 'S' THEN 'Shipped'
        ELSE 'Unknown'
    END AS status,
    SUM(oi.quantity) AS total_items,
    SUM(oi.quantity * oi.unit_price) AS total_amount,
    STRING_AGG(p.product_name, ', ') AS products
FROM 
    orders o
JOIN 
    customers c ON o.customer_id = c.customer_id
JOIN 
    order_items oi ON o.order_id = oi.order_id
JOIN 
    products p ON oi.product_id = p.product_id
GROUP BY 
    o.order_id, o.order_date, c.first_name, c.last_name, o.status;

-- Exercise 6 Solution
CREATE OR REPLACE VIEW employee_tenure AS
SELECT 
    e.employee_id,
    e.first_name || ' ' || e.last_name AS full_name,
    d.department_name,
    e.salary,
    EXTRACT(YEAR FROM AGE(CURRENT_DATE, e.hire_date)) AS years_of_service,
    RANK() OVER (PARTITION BY d.department_id ORDER BY e.hire_date) AS tenure_rank
FROM 
    employees e
JOIN 
    departments d ON e.department_id = d.department_id
WHERE 
    e.is_active = TRUE;

-- Exercise 7 Solution
CREATE MATERIALIZED VIEW quarterly_sales_report AS
WITH quarterly_sales AS (
    SELECT 
        EXTRACT(YEAR FROM o.order_date) AS year,
        EXTRACT(QUARTER FROM o.order_date) AS quarter,
        c.category_id,
        c.category_name,
        SUM(oi.quantity * oi.unit_price) AS total_sales
    FROM 
        orders o
    JOIN 
        order_items oi ON o.order_id = oi.order_id
    JOIN 
        products p ON oi.product_id = p.product_id
    JOIN 
        categories c ON p.category_id = c.category_id
    GROUP BY 
        EXTRACT(YEAR FROM o.order_date), 
        EXTRACT(QUARTER FROM o.order_date),
        c.category_id,
        c.category_name
)
SELECT 
    qs.year,
    qs.quarter,
    qs.category_name,
    qs.total_sales,
    CASE 
        WHEN LAG(qs.total_sales) OVER (PARTITION BY qs.category_id ORDER BY qs.year, qs.quarter) IS NULL THEN NULL
        ELSE (qs.total_sales - LAG(qs.total_sales) OVER (PARTITION BY qs.category_id ORDER BY qs.year, qs.quarter)) / 
             LAG(qs.total_sales) OVER (PARTITION BY qs.category_id ORDER BY qs.year, qs.quarter) * 100
    END AS yoy_growth_percentage
FROM 
    quarterly_sales qs
ORDER BY 
    qs.year, qs.quarter, qs.category_name;

-- Exercise 8 Solution
CREATE INDEX idx_quarterly_sales_year_quarter ON quarterly_sales_report(year, quarter);
CREATE INDEX idx_quarterly_sales_category ON quarterly_sales_report(category_name);
CREATE INDEX idx_quarterly_sales_year_quarter_category ON quarterly_sales_report(year, quarter, category_name);

-- Exercise 9 Solution
CREATE ROLE sales_analyst;
GRANT SELECT ON order_summary TO sales_analyst;
GRANT SELECT ON quarterly_sales_report TO sales_analyst;

-- Exercise 10 Solution
-- 1. List all views
SELECT 
    table_schema,
    table_name,
    'VIEW' as type
FROM 
    information_schema.views
WHERE 
    table_schema NOT IN ('pg_catalog', 'information_schema')
UNION ALL
SELECT 
    schemaname as table_schema,
    matviewname as table_name,
    'MATERIALIZED VIEW' as type
FROM 
    pg_matviews
ORDER BY 
    table_schema, table_name;

-- 2. Show the definition of a view
SELECT view_definition 
FROM information_schema.views 
WHERE table_name = 'employee_department_view' 
AND table_schema NOT IN ('pg_catalog', 'information_schema');

-- 3. Alter a view
CREATE OR REPLACE VIEW salary_bands AS
SELECT 
    e.employee_id,
    e.first_name || ' ' || e.last_name AS full_name,
    d.department_name,
    e.salary,
    CASE 
        WHEN e.salary < 50000 THEN 'Entry Level'
        WHEN e.salary >= 50000 AND e.salary < 75000 THEN 'Mid Level'
        WHEN e.salary >= 75000 AND e.salary < 90000 THEN 'Senior Level'
        ELSE 'Executive Level'
    END AS salary_band,
    e.salary - (SELECT AVG(e2.salary) FROM employees e2 WHERE e2.department_id = e.department_id) AS salary_diff_from_avg
FROM 
    employees e
JOIN 
    departments d ON e.department_id = d.department_id;

-- 4. Drop a view
DROP VIEW IF EXISTS customer_geography;
*/
