-- Using the "retail_store" database
-- Connect to the database if needed
-- \c retail_store

-- Exercise 1: Basic JOINs with existing tables

-- Join customers and orders to find which customers have placed orders
SELECT 
    c.id AS customer_id,
    c.first_name || ' ' || c.last_name AS customer_name,
    o.id AS order_id,
    o.order_date,
    o.total_amount,
    o.status
FROM customers c
JOIN orders o ON c.id = o.customer_id
ORDER BY o.order_date DESC;

-- Join orders, order_items, and products to see what products were ordered
SELECT 
    o.id AS order_id,
    o.order_date,
    p.name AS product_name,
    oi.quantity,
    oi.unit_price,
    (oi.quantity * oi.unit_price) AS total_item_price
FROM orders o
JOIN order_items oi ON o.id = oi.order_id
JOIN products p ON oi.product_id = p.id
ORDER BY o.id, p.name;

-- Join products and categories to list products with their category names
SELECT 
    p.id AS product_id,
    p.name AS product_name,
    p.price,
    c.name AS category_name
FROM products p
JOIN categories c ON p.category_id = c.id
ORDER BY c.name, p.price DESC;

-- Exercise 2: Create and work with a self-referencing table

-- Create staff table with self-referencing relationship
CREATE TABLE staff (
    id SERIAL PRIMARY KEY,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    title VARCHAR(100),
    manager_id INTEGER REFERENCES staff(id),
    department_id INTEGER REFERENCES departments(department_id),
    hire_date DATE,
    salary NUMERIC(10, 2)
);

-- Insert sample data
INSERT INTO staff (first_name, last_name, title, manager_id, department_id, hire_date, salary)
VALUES 
    ('Richard', 'Wilson', 'CEO', NULL, 1, '2015-01-01', 150000),
    ('Lisa', 'Johnson', 'CTO', 1, 1, '2016-03-15', 135000),
    ('Mark', 'Taylor', 'CFO', 1, 3, '2016-05-20', 135000),
    ('Patricia', 'Brown', 'IT Director', 2, 1, '2017-02-10', 110000),
    ('George', 'Miller', 'Finance Director', 3, 3, '2017-04-15', 110000),
    ('Susan', 'Davis', 'HR Director', 1, 2, '2017-06-01', 105000),
    ('Michael', 'Garcia', 'Senior Developer', 4, 1, '2018-01-15', 95000),
    ('Jennifer', 'Martinez', 'Junior Developer', 4, 1, '2019-03-01', 75000),
    ('David', 'Anderson', 'Financial Analyst', 5, 3, '2018-07-10', 85000),
    ('Mary', 'Thomas', 'HR Specialist', 6, 2, '2019-05-15', 70000);

-- Show each staff member and their manager
SELECT 
    s.id,
    s.first_name || ' ' || s.last_name AS employee_name,
    s.title,
    m.first_name || ' ' || m.last_name AS manager_name,
    m.title AS manager_title,
    d.department_name
FROM staff s
LEFT JOIN staff m ON s.manager_id = m.id
JOIN departments d ON s.department_id = d.department_id
ORDER BY s.id;

-- Find all staff members who don't have a manager (top-level)
SELECT 
    s.id,
    s.first_name || ' ' || s.last_name AS employee_name,
    s.title,
    d.department_name
FROM staff s
JOIN departments d ON s.department_id = d.department_id
WHERE s.manager_id IS NULL;

-- Find all managers and count how many staff report to each
SELECT 
    m.id,
    m.first_name || ' ' || m.last_name AS manager_name,
    m.title,
    COUNT(s.id) AS direct_reports
FROM staff m
JOIN staff s ON s.manager_id = m.id
GROUP BY m.id, m.first_name, m.last_name, m.title
ORDER BY direct_reports DESC;

-- Exercise 3: Advanced JOIN queries

-- Find customers who have never placed an order (using LEFT JOIN)
SELECT 
    c.id,
    c.first_name || ' ' || c.last_name AS customer_name,
    c.email
FROM customers c
LEFT JOIN orders o ON c.id = o.customer_id
WHERE o.id IS NULL;

-- Find products that have never been ordered (using LEFT JOIN)
SELECT 
    p.id,
    p.name,
    p.price,
    cat.name AS category
FROM products p
LEFT JOIN order_items oi ON p.id = oi.product_id
JOIN categories cat ON p.category_id = cat.id
WHERE oi.order_id IS NULL;

-- Find categories that don't have any products (using RIGHT JOIN)
SELECT 
    c.id,
    c.name AS category_name,
    c.description
FROM products p
RIGHT JOIN categories c ON p.category_id = c.id
WHERE p.id IS NULL;

-- Exercise 4: Multi-table JOIN query for complete order report
SELECT 
    o.id AS order_id,
    o.order_date,
    c.first_name || ' ' || c.last_name AS customer_name,
    p.name AS product_name,
    cat.name AS category_name,
    oi.quantity,
    oi.unit_price,
    (oi.quantity * oi.unit_price) AS total_item_price
FROM orders o
JOIN customers c ON o.customer_id = c.id
JOIN order_items oi ON o.id = oi.order_id
JOIN products p ON oi.product_id = p.id
JOIN categories cat ON p.category_id = cat.id
ORDER BY o.id, p.name;

-- Exercise 5: Challenge - Calculate total revenue by category
SELECT 
    c.name AS category_name,
    COALESCE(SUM(oi.quantity * oi.unit_price), 0) AS total_revenue
FROM categories c
LEFT JOIN products p ON c.id = p.category_id
LEFT JOIN order_items oi ON p.id = oi.product_id
GROUP BY c.name
ORDER BY total_revenue DESC;
