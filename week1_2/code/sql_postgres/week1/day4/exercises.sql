-- Using the "retail_store" database
-- Connect to the database if needed
-- \c retail_store

-- If tables don't exist, recreate them with sample data
-- (You can use the code from Day 3 exercises to set up the tables and data)

-- Exercise 1: Basic SELECT queries with WHERE

-- Select all customers' full names and contact information
SELECT 
    id,
    first_name || ' ' || last_name AS "Full Name",
    email,
    phone,
    address
FROM customers;

-- Find all products that cost more than $100
SELECT *
FROM products
WHERE price > 100;

-- List all orders with a status of 'Shipped' or 'Delivered'
SELECT *
FROM orders
WHERE status IN ('Shipped', 'Delivered');

-- Find all products in the 'Electronics' category
SELECT p.*
FROM products p
JOIN categories c ON p.category_id = c.id
WHERE c.name = 'Electronics';

-- List all customers whose email contains 'example.com'
SELECT *
FROM customers
WHERE email LIKE '%example.com';

-- Exercise 2: Queries using various operators

-- Find products with inventory between 30 and 100 units
SELECT *
FROM products
WHERE inventory_count BETWEEN 30 AND 100;

-- Find customers who registered before 2023
SELECT *
FROM customers
WHERE registration_date < '2023-01-01';

-- Find orders with a total amount greater than $500
SELECT *
FROM orders
WHERE total_amount > 500;

-- Exercise 3: Queries with sorting

-- List products by price from highest to lowest
SELECT *
FROM products
ORDER BY price DESC;

-- List customers by last name alphabetically
SELECT *
FROM customers
ORDER BY last_name ASC;

-- List orders by date with the most recent first
SELECT *
FROM orders
ORDER BY order_date DESC;

-- Exercise 4: Queries with pagination

-- Get the 5 most expensive products
SELECT *
FROM products
ORDER BY price DESC
LIMIT 5;

-- Get products 6-10 in terms of price (second page with 5 items per page)
SELECT *
FROM products
ORDER BY price DESC
LIMIT 5 OFFSET 5;

-- Get the 3 most recent orders
SELECT *
FROM orders
ORDER BY order_date DESC
LIMIT 3;

-- Exercise 5: Challenge query

-- Find the top 3 categories by number of products
SELECT 
    c.id,
    c.name,
    COUNT(p.id) AS product_count
FROM categories c
JOIN products p ON c.id = p.category_id
GROUP BY c.id, c.name
ORDER BY product_count DESC
LIMIT 3;

-- Additional challenge: Find the average price of products in each category
SELECT 
    c.name AS category_name,
    AVG(p.price) AS average_price,
    MIN(p.price) AS lowest_price,
    MAX(p.price) AS highest_price
FROM categories c
JOIN products p ON c.id = p.category_id
GROUP BY c.name
ORDER BY average_price DESC;
