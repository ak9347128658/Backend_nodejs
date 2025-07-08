-- Using the "retail_store" database created earlier
-- Connect to the database if needed
-- \c retail_store

-- Exercise 1: Basic aggregation queries

-- Calculate the total revenue for each product
SELECT 
    p.id,
    p.name AS product_name,
    SUM(oi.quantity * oi.unit_price) AS total_revenue
FROM products p
LEFT JOIN order_items oi ON p.id = oi.product_id
GROUP BY p.id, p.name
ORDER BY total_revenue DESC NULLS LAST;

-- Find the average order value for each customer
SELECT 
    c.id,
    c.first_name || ' ' || c.last_name AS customer_name,
    AVG(o.total_amount) AS average_order_value,
    COUNT(o.id) AS order_count
FROM customers c
JOIN orders o ON c.id = o.customer_id
GROUP BY c.id, c.first_name, c.last_name
ORDER BY average_order_value DESC;

-- Calculate how many orders each customer has placed
SELECT 
    c.id,
    c.first_name || ' ' || c.last_name AS customer_name,
    COUNT(o.id) AS order_count
FROM customers c
LEFT JOIN orders o ON c.id = o.customer_id
GROUP BY c.id, c.first_name, c.last_name
ORDER BY order_count DESC;

-- Determine which category has the most products
SELECT 
    c.id,
    c.name AS category_name,
    COUNT(p.id) AS product_count
FROM categories c
LEFT JOIN products p ON c.id = p.category_id
GROUP BY c.id, c.name
ORDER BY product_count DESC;

-- Find the total revenue by order status
SELECT 
    o.status,
    COUNT(o.id) AS order_count,
    SUM(o.total_amount) AS total_revenue
FROM orders o
GROUP BY o.status
ORDER BY total_revenue DESC;

-- Exercise 2: HAVING clause

-- Find all products that have been ordered more than 2 times
SELECT 
    p.id,
    p.name AS product_name,
    COUNT(oi.order_id) AS order_count
FROM products p
JOIN order_items oi ON p.id = oi.product_id
GROUP BY p.id, p.name
HAVING COUNT(oi.order_id) > 2
ORDER BY order_count DESC;

-- Find customers who have spent more than $500 total
SELECT 
    c.id,
    c.first_name || ' ' || c.last_name AS customer_name,
    SUM(o.total_amount) AS total_spent
FROM customers c
JOIN orders o ON c.id = o.customer_id
GROUP BY c.id, c.first_name, c.last_name
HAVING SUM(o.total_amount) > 500
ORDER BY total_spent DESC;

-- Find categories where the average product price is over $50
SELECT 
    c.id,
    c.name AS category_name,
    AVG(p.price) AS avg_price,
    COUNT(p.id) AS product_count
FROM categories c
JOIN products p ON c.id = p.category_id
GROUP BY c.id, c.name
HAVING AVG(p.price) > 50
ORDER BY avg_price DESC;

-- Exercise 3: Combine filtering with grouping

-- Find the total sales by category for products with inventory count > 20
SELECT 
    c.name AS category_name,
    SUM(oi.quantity * oi.unit_price) AS total_sales,
    COUNT(DISTINCT p.id) AS product_count
FROM categories c
JOIN products p ON c.id = p.category_id
JOIN order_items oi ON p.id = oi.product_id
WHERE p.inventory_count > 20
GROUP BY c.name
ORDER BY total_sales DESC;

-- Find the average order value by month for orders with status 'Delivered'
SELECT 
    EXTRACT(YEAR FROM o.order_date) AS year,
    EXTRACT(MONTH FROM o.order_date) AS month,
    COUNT(o.id) AS order_count,
    AVG(o.total_amount) AS avg_order_value
FROM orders o
WHERE o.status = 'Delivered'
GROUP BY year, month
ORDER BY year, month;

-- Calculate the number of orders by customer for orders placed in 2023
SELECT 
    c.id,
    c.first_name || ' ' || c.last_name AS customer_name,
    COUNT(o.id) AS order_count
FROM customers c
JOIN orders o ON c.id = o.customer_id
WHERE EXTRACT(YEAR FROM o.order_date) = 2023
GROUP BY c.id, c.first_name, c.last_name
ORDER BY order_count DESC;

-- Exercise 4: Multiple grouping levels

-- Calculate sales by category AND by month
SELECT 
    c.name AS category_name,
    EXTRACT(YEAR FROM o.order_date) AS year,
    EXTRACT(MONTH FROM o.order_date) AS month,
    SUM(oi.quantity * oi.unit_price) AS total_sales
FROM categories c
JOIN products p ON c.id = p.category_id
JOIN order_items oi ON p.id = oi.product_id
JOIN orders o ON oi.order_id = o.id
GROUP BY c.name, year, month
ORDER BY c.name, year, month;

-- Find the number of products in each price range by category
SELECT 
    c.name AS category_name,
    CASE 
        WHEN p.price BETWEEN 0 AND 50 THEN '0-50'
        WHEN p.price BETWEEN 51 AND 100 THEN '51-100'
        WHEN p.price BETWEEN 101 AND 200 THEN '101-200'
        ELSE '200+'
    END AS price_range,
    COUNT(p.id) AS product_count
FROM categories c
JOIN products p ON c.id = p.category_id
GROUP BY c.name, price_range
ORDER BY c.name, price_range;

-- Determine the average order value by customer AND by order status
SELECT 
    c.first_name || ' ' || c.last_name AS customer_name,
    o.status,
    COUNT(o.id) AS order_count,
    AVG(o.total_amount) AS avg_order_value
FROM customers c
JOIN orders o ON c.id = o.customer_id
GROUP BY c.first_name, c.last_name, o.status
ORDER BY customer_name, o.status;

-- Exercise 5: Challenge - Calculate percentage of total revenue by category

-- First, create a CTE (Common Table Expression) to get the total revenue
WITH total_revenue AS (
    SELECT SUM(oi.quantity * oi.unit_price) AS grand_total
    FROM order_items oi
),
category_revenue AS (
    SELECT 
        c.id,
        c.name AS category_name,
        SUM(COALESCE(oi.quantity * oi.unit_price, 0)) AS cat_revenue
    FROM categories c
    LEFT JOIN products p ON c.id = p.category_id
    LEFT JOIN order_items oi ON p.id = oi.product_id
    GROUP BY c.id, c.name
)
SELECT 
    cr.category_name,
    cr.cat_revenue,
    tr.grand_total,
    CASE 
        WHEN tr.grand_total = 0 THEN 0
        ELSE ROUND((cr.cat_revenue / tr.grand_total) * 100, 2)
    END AS percentage
FROM category_revenue cr, total_revenue tr
ORDER BY percentage DESC;
