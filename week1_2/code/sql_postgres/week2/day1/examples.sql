-- Example 1: Basic Aggregate Functions
-- Create a sample table
CREATE TABLE sales (
    sale_id SERIAL PRIMARY KEY,
    product_id INTEGER,
    customer_id INTEGER,
    sale_date DATE,
    quantity INTEGER,
    unit_price NUMERIC(10, 2),
    total_price NUMERIC(10, 2)
);

-- Insert sample data
INSERT INTO sales (product_id, customer_id, sale_date, quantity, unit_price, total_price)
VALUES 
    (1, 101, '2023-01-15', 2, 25.99, 51.98),
    (2, 102, '2023-01-16', 1, 149.99, 149.99),
    (3, 103, '2023-01-17', 3, 12.50, 37.50),
    (1, 104, '2023-01-18', 1, 25.99, 25.99),
    (4, 105, '2023-01-19', 2, 34.99, 69.98),
    (2, 106, '2023-01-20', 1, 149.99, 149.99),
    (5, 107, '2023-01-21', 4, 9.99, 39.96),
    (3, 108, '2023-01-22', 2, 12.50, 25.00),
    (1, 109, '2023-01-23', 3, 25.99, 77.97),
    (4, 110, '2023-01-24', 1, 34.99, 34.99);

-- COUNT: Count the number of sales
SELECT COUNT(*) AS total_sales FROM sales;

-- SUM: Sum the total sales
SELECT SUM(total_price) AS total_revenue FROM sales;

-- AVG: Calculate the average sale amount
SELECT AVG(total_price) AS average_sale FROM sales;

-- MIN/MAX: Find the minimum and maximum sale amounts
SELECT 
    MIN(total_price) AS min_sale,
    MAX(total_price) AS max_sale
FROM sales;

-- DISTINCT COUNT: Count unique customers
SELECT COUNT(DISTINCT customer_id) AS unique_customers FROM sales;

-- Example 2: Basic GROUP BY
-- Group by product_id to get sales per product
SELECT 
    product_id,
    COUNT(*) AS sale_count,
    SUM(quantity) AS units_sold,
    SUM(total_price) AS total_revenue
FROM sales
GROUP BY product_id
ORDER BY total_revenue DESC;

-- Group by sale_date to get daily sales
SELECT 
    sale_date,
    COUNT(*) AS transaction_count,
    SUM(total_price) AS daily_revenue
FROM sales
GROUP BY sale_date
ORDER BY sale_date;

-- Example 3: HAVING Clause
-- Find products with more than 1 sale
SELECT 
    product_id,
    COUNT(*) AS sale_count
FROM sales
GROUP BY product_id
HAVING COUNT(*) > 1
ORDER BY sale_count DESC;

-- Find products with total revenue over $100
SELECT 
    product_id,
    SUM(total_price) AS total_revenue
FROM sales
GROUP BY product_id
HAVING SUM(total_price) > 100
ORDER BY total_revenue DESC;

-- Example 4: WHERE vs HAVING
-- Combine WHERE and GROUP BY: first filter, then group
-- Find sales after Jan 20 grouped by product
SELECT 
    product_id,
    COUNT(*) AS sale_count,
    SUM(total_price) AS total_revenue
FROM sales
WHERE sale_date > '2023-01-20'
GROUP BY product_id;

-- Combine GROUP BY and HAVING: first group, then filter the groups
-- Find products with average price > $20, considering only sales after Jan 15
SELECT 
    product_id,
    AVG(unit_price) AS avg_price
FROM sales
WHERE sale_date > '2023-01-15'
GROUP BY product_id
HAVING AVG(unit_price) > 20;

-- Example 5: GROUP BY with Multiple Columns
-- Group by multiple columns to get more detailed breakdown
SELECT 
    product_id,
    sale_date,
    COUNT(*) AS sale_count,
    SUM(quantity) AS units_sold,
    SUM(total_price) AS total_revenue
FROM sales
GROUP BY product_id, sale_date
ORDER BY product_id, sale_date;

-- Example 6: Aggregate Functions with JOINs
-- Create products table for reference
CREATE TABLE products (
    product_id SERIAL PRIMARY KEY,
    product_name VARCHAR(100),
    category VARCHAR(50),
    supplier VARCHAR(100)
);

-- Insert sample product data
INSERT INTO products (product_id, product_name, category, supplier)
VALUES 
    (1, 'Basic T-shirt', 'Clothing', 'FashionCo'),
    (2, 'Premium Headphones', 'Electronics', 'AudioTech'),
    (3, 'Notebook Set', 'Stationery', 'OfficeSupplies'),
    (4, 'Wireless Mouse', 'Electronics', 'TechGear'),
    (5, 'Coffee Mug', 'Kitchenware', 'HomePlus');

-- JOIN and aggregate to get sales by product name and category
SELECT 
    p.product_name,
    p.category,
    COUNT(*) AS sale_count,
    SUM(s.quantity) AS units_sold,
    SUM(s.total_price) AS total_revenue
FROM sales s
JOIN products p ON s.product_id = p.product_id
GROUP BY p.product_name, p.category
ORDER BY total_revenue DESC;

-- Aggregation by category
SELECT 
    p.category,
    COUNT(*) AS sale_count,
    SUM(s.quantity) AS units_sold,
    SUM(s.total_price) AS total_revenue,
    AVG(s.unit_price) AS avg_unit_price
FROM sales s
JOIN products p ON s.product_id = p.product_id
GROUP BY p.category
ORDER BY total_revenue DESC;

-- Example 7: Advanced Grouping Techniques
-- Create date dimension table for time-based analysis
CREATE TABLE date_dim (
    date_id DATE PRIMARY KEY,
    day_of_week VARCHAR(10),
    month VARCHAR(10),
    quarter VARCHAR(2),
    year INTEGER
);

-- Insert some sample dates
INSERT INTO date_dim (date_id, day_of_week, month, quarter, year)
VALUES 
    ('2023-01-15', 'Sunday', 'January', 'Q1', 2023),
    ('2023-01-16', 'Monday', 'January', 'Q1', 2023),
    ('2023-01-17', 'Tuesday', 'January', 'Q1', 2023),
    ('2023-01-18', 'Wednesday', 'January', 'Q1', 2023),
    ('2023-01-19', 'Thursday', 'January', 'Q1', 2023),
    ('2023-01-20', 'Friday', 'January', 'Q1', 2023),
    ('2023-01-21', 'Saturday', 'January', 'Q1', 2023),
    ('2023-01-22', 'Sunday', 'January', 'Q1', 2023),
    ('2023-01-23', 'Monday', 'January', 'Q1', 2023),
    ('2023-01-24', 'Tuesday', 'January', 'Q1', 2023);

-- Multi-level grouping with dates
SELECT 
    dd.day_of_week,
    SUM(s.total_price) AS total_revenue,
    COUNT(*) AS transaction_count
FROM sales s
JOIN date_dim dd ON s.sale_date = dd.date_id
GROUP BY dd.day_of_week
ORDER BY total_revenue DESC;
