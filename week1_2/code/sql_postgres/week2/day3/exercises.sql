-- Week 2, Day 3: Indexes and Query Optimization Exercises

-- Create the necessary tables for exercises
-- E-commerce database schema
CREATE TABLE customers (
    customer_id SERIAL PRIMARY KEY,
    first_name VARCHAR(50),
    last_name VARCHAR(50),
    email VARCHAR(100) UNIQUE,
    phone VARCHAR(20),
    address TEXT,
    city VARCHAR(50),
    state VARCHAR(50),
    zip_code VARCHAR(20),
    created_at TIMESTAMP DEFAULT current_timestamp
);

CREATE TABLE product_categories (
    category_id SERIAL PRIMARY KEY,
    category_name VARCHAR(100) UNIQUE,
    description TEXT
);

CREATE TABLE products (
    product_id SERIAL PRIMARY KEY,
    product_name VARCHAR(100),
    description TEXT,
    category_id INTEGER REFERENCES product_categories(category_id),
    price DECIMAL(10, 2),
    stock_quantity INTEGER,
    created_at TIMESTAMP DEFAULT current_timestamp,
    tags TEXT[]
);

CREATE TABLE orders (
    order_id SERIAL PRIMARY KEY,
    customer_id INTEGER REFERENCES customers(customer_id),
    order_date TIMESTAMP DEFAULT current_timestamp,
    status VARCHAR(20),
    total_amount DECIMAL(10, 2)
);

CREATE TABLE order_items (
    item_id SERIAL PRIMARY KEY,
    order_id INTEGER REFERENCES orders(order_id),
    product_id INTEGER REFERENCES products(product_id),
    quantity INTEGER,
    unit_price DECIMAL(10, 2),
    subtotal DECIMAL(10, 2)
);

-- Insert sample data
-- Categories
INSERT INTO product_categories (category_name, description)
VALUES 
    ('Electronics', 'Electronic devices and accessories'),
    ('Clothing', 'All types of clothing and fashion items'),
    ('Books', 'Books, e-books, and publications'),
    ('Home & Kitchen', 'Items for home and kitchen use'),
    ('Sports & Outdoors', 'Sports equipment and outdoor gear');

-- Generate customers
DO $$
DECLARE
    i INTEGER;
    domains TEXT[] := ARRAY['gmail.com', 'yahoo.com', 'hotmail.com', 'outlook.com', 'example.com'];
    domain TEXT;
    first_names TEXT[] := ARRAY['John', 'Jane', 'Michael', 'Emily', 'David', 'Sarah', 'Robert', 'Jennifer', 'William', 'Elizabeth'];
    last_names TEXT[] := ARRAY['Smith', 'Johnson', 'Williams', 'Jones', 'Brown', 'Davis', 'Miller', 'Wilson', 'Moore', 'Taylor'];
    first_name TEXT;
    last_name TEXT;
    cities TEXT[] := ARRAY['New York', 'Los Angeles', 'Chicago', 'Houston', 'Phoenix', 'Philadelphia', 'San Antonio', 'San Diego', 'Dallas', 'San Jose'];
    states TEXT[] := ARRAY['NY', 'CA', 'IL', 'TX', 'AZ', 'PA', 'TX', 'CA', 'TX', 'CA'];
BEGIN
    FOR i IN 1..5000 LOOP
        first_name := first_names[1 + floor(random() * array_length(first_names, 1))];
        last_name := last_names[1 + floor(random() * array_length(last_names, 1))];
        domain := domains[1 + floor(random() * array_length(domains, 1))];
        
        INSERT INTO customers (
            first_name,
            last_name,
            email,
            phone,
            address,
            city,
            state,
            zip_code
        ) VALUES (
            first_name,
            last_name,
            lower(first_name || '.' || last_name || i || '@' || domain),
            '555-' || lpad((1000 + i % 9000)::TEXT, 4, '0'),
            (100 + i % 9900) || ' ' || (ARRAY['Main', 'Oak', 'Pine', 'Maple', 'Cedar'])[1 + i % 5] || ' ' || 
                (ARRAY['St', 'Ave', 'Blvd', 'Rd', 'Ln'])[1 + i % 5],
            cities[1 + i % array_length(cities, 1)],
            states[1 + i % array_length(states, 1)],
            lpad((10000 + i % 90000)::TEXT, 5, '0')
        );
    END LOOP;
END$$;

-- Generate products
DO $$
DECLARE
    i INTEGER;
    category_id INTEGER;
    product_base TEXT;
    tags TEXT[][];
    tag_set TEXT[];
    price DECIMAL(10, 2);
BEGIN
    -- Sample product bases and tags by category
    tags := ARRAY[
        ARRAY['electronics', 'gadget', 'tech', 'smart', 'wireless', 'bluetooth', 'battery', 'charger', 'digital'],
        ARRAY['apparel', 'fashion', 'clothes', 'cotton', 'polyester', 'style', 'trendy', 'seasonal', 'casual', 'formal'],
        ARRAY['literature', 'education', 'fiction', 'non-fiction', 'hardcover', 'paperback', 'bestseller', 'author', 'publishing'],
        ARRAY['kitchen', 'cookware', 'appliance', 'utensil', 'storage', 'cleaning', 'furniture', 'decor', 'bedroom', 'bathroom'],
        ARRAY['fitness', 'sports', 'outdoor', 'exercise', 'camping', 'hiking', 'water', 'equipment', 'game', 'recreation']
    ];
    
    FOR i IN 1..1000 LOOP
        -- Determine category
        category_id := 1 + i % 5;
        
        -- Get tags for this category
        tag_set := tags[category_id];
        
        -- Set base product name by category
        CASE category_id
            WHEN 1 THEN product_base := (ARRAY['Smartphone', 'Laptop', 'Tablet', 'Headphones', 'Speaker', 'Camera', 'TV', 'Monitor', 'Keyboard', 'Mouse'])[1 + i % 10];
            WHEN 2 THEN product_base := (ARRAY['T-shirt', 'Jeans', 'Dress', 'Shirt', 'Jacket', 'Sweater', 'Socks', 'Hat', 'Shoes', 'Scarf'])[1 + i % 10];
            WHEN 3 THEN product_base := (ARRAY['Novel', 'Cookbook', 'Biography', 'History Book', 'Science Book', 'Poetry', 'Reference', 'Art Book', 'Travel Guide', 'Dictionary'])[1 + i % 10];
            WHEN 4 THEN product_base := (ARRAY['Pot', 'Pan', 'Blender', 'Toaster', 'Plate Set', 'Knife Set', 'Coffee Maker', 'Microwave', 'Chair', 'Table'])[1 + i % 10];
            WHEN 5 THEN product_base := (ARRAY['Treadmill', 'Bicycle', 'Tennis Racket', 'Basketball', 'Soccer Ball', 'Tent', 'Sleeping Bag', 'Fishing Rod', 'Yoga Mat', 'Weights'])[1 + i % 10];
        END CASE;
        
        -- Generate random price based on category
        CASE category_id
            WHEN 1 THEN price := 100 + (random() * 900);
            WHEN 2 THEN price := 20 + (random() * 180);
            WHEN 3 THEN price := 10 + (random() * 90);
            WHEN 4 THEN price := 30 + (random() * 270);
            WHEN 5 THEN price := 25 + (random() * 475);
        END CASE;
        
        -- Round price to 2 decimal places
        price := round(price::numeric, 2);
        
        -- Insert product
        INSERT INTO products (
            product_name,
            description,
            category_id,
            price,
            stock_quantity,
            tags
        ) VALUES (
            product_base || ' ' || (ARRAY['Pro', 'Max', 'Ultra', 'Elite', 'Premium', 'Basic', 'Standard', 'Deluxe', 'Advanced', 'Starter'])[1 + i % 10],
            'This is a high-quality ' || lower(product_base) || ' designed for everyday use.',
            category_id,
            price,
            50 + (random() * 450)::INTEGER,
            ARRAY[
                tag_set[1 + floor(random() * array_length(tag_set, 1))],
                tag_set[1 + floor(random() * array_length(tag_set, 1))],
                tag_set[1 + floor(random() * array_length(tag_set, 1))]
            ]
        );
    END LOOP;
END$$;

-- Generate orders and order items
DO $$
DECLARE
    i INTEGER;
    j INTEGER;
    customer_count INTEGER;
    product_count INTEGER;
    order_id INTEGER;
    product_id INTEGER;
    quantity INTEGER;
    unit_price DECIMAL(10, 2);
    subtotal DECIMAL(10, 2);
    total DECIMAL(10, 2);
    statuses TEXT[] := ARRAY['Pending', 'Processing', 'Shipped', 'Delivered', 'Cancelled'];
    status TEXT;
BEGIN
    -- Get counts
    SELECT COUNT(*) INTO customer_count FROM customers;
    SELECT COUNT(*) INTO product_count FROM products;
    
    -- Generate 10,000 orders
    FOR i IN 1..10000 LOOP
        -- Reset total for new order
        total := 0;
        
        -- Randomly select a status
        status := statuses[1 + floor(random() * array_length(statuses, 1))];
        
        -- Create order
        INSERT INTO orders (
            customer_id,
            order_date,
            status,
            total_amount
        ) VALUES (
            1 + floor(random() * customer_count),
            current_timestamp - (random() * 365 * '1 day'::INTERVAL),
            status,
            0  -- Will update after adding items
        ) RETURNING order_id INTO order_id;
        
        -- Add 1-5 items to each order
        FOR j IN 1..(1 + floor(random() * 5)) LOOP
            -- Select random product
            product_id := 1 + floor(random() * product_count);
            
            -- Get product price
            SELECT price INTO unit_price FROM products WHERE product_id = product_id;
            
            -- Random quantity 1-5
            quantity := 1 + floor(random() * 5);
            
            -- Calculate subtotal
            subtotal := unit_price * quantity;
            
            -- Add to total
            total := total + subtotal;
            
            -- Add order item
            INSERT INTO order_items (
                order_id,
                product_id,
                quantity,
                unit_price,
                subtotal
            ) VALUES (
                order_id,
                product_id,
                quantity,
                unit_price,
                subtotal
            );
        END LOOP;
        
        -- Update order total
        UPDATE orders SET total_amount = total WHERE order_id = order_id;
    END LOOP;
END$$;

-- Exercise 1: Analyze queries without indexes
-- Run and analyze the performance of these queries

-- Query 1: Find all orders for a specific customer with their items
EXPLAIN ANALYZE
SELECT o.order_id, o.order_date, o.status, oi.product_id, p.product_name, oi.quantity, oi.unit_price, oi.subtotal
FROM orders o
JOIN order_items oi ON o.order_id = oi.order_id
JOIN products p ON oi.product_id = p.product_id
WHERE o.customer_id = 100
ORDER BY o.order_date DESC;

-- Query 2: Find products in a specific price range with a certain tag
EXPLAIN ANALYZE
SELECT p.product_id, p.product_name, p.price, p.tags
FROM products p
WHERE p.price BETWEEN 50 AND 100
AND p.tags @> ARRAY['tech']
ORDER BY p.price;

-- Query 3: Find customers in a specific city who have placed orders above $500
EXPLAIN ANALYZE
SELECT c.customer_id, c.first_name, c.last_name, c.email, o.order_id, o.total_amount
FROM customers c
JOIN orders o ON c.customer_id = o.customer_id
WHERE c.city = 'New York'
AND o.total_amount > 500
ORDER BY o.total_amount DESC;

-- Exercise 2: Create appropriate indexes
-- Create indexes to improve the performance of the above queries

-- Index for Query 1
CREATE INDEX idx_orders_customer_id ON orders(customer_id);
CREATE INDEX idx_order_items_order_id ON order_items(order_id);

-- Index for Query 2
CREATE INDEX idx_products_price ON products(price);
CREATE INDEX idx_products_tags ON products USING GIN(tags);

-- Index for Query 3
CREATE INDEX idx_customers_city ON customers(city);
CREATE INDEX idx_orders_total_amount ON orders(total_amount);

-- Exercise 3: Re-analyze the queries with indexes
-- Run the same queries again and compare the performance

-- Re-run Query 1
EXPLAIN ANALYZE
SELECT o.order_id, o.order_date, o.status, oi.product_id, p.product_name, oi.quantity, oi.unit_price, oi.subtotal
FROM orders o
JOIN order_items oi ON o.order_id = oi.order_id
JOIN products p ON oi.product_id = p.product_id
WHERE o.customer_id = 100
ORDER BY o.order_date DESC;

-- Re-run Query 2
EXPLAIN ANALYZE
SELECT p.product_id, p.product_name, p.price, p.tags
FROM products p
WHERE p.price BETWEEN 50 AND 100
AND p.tags @> ARRAY['tech']
ORDER BY p.price;

-- Re-run Query 3
EXPLAIN ANALYZE
SELECT c.customer_id, c.first_name, c.last_name, c.email, o.order_id, o.total_amount
FROM customers c
JOIN orders o ON c.customer_id = o.customer_id
WHERE c.city = 'New York'
AND o.total_amount > 500
ORDER BY o.total_amount DESC;

-- Exercise 4: Create composite indexes
-- Create composite indexes to further improve performance

-- Composite index for Query 1
CREATE INDEX idx_orders_customer_date ON orders(customer_id, order_date DESC);

-- Composite index for Query 3
CREATE INDEX idx_customers_city_id ON customers(city, customer_id);
CREATE INDEX idx_orders_customer_total ON orders(customer_id, total_amount DESC);

-- Exercise 5: Create a partial index
-- Create a partial index for high-value orders

CREATE INDEX idx_high_value_orders ON orders(customer_id, order_date)
WHERE total_amount > 300;

-- Test the partial index
EXPLAIN ANALYZE
SELECT o.order_id, o.order_date, o.status, o.total_amount
FROM orders o
WHERE o.customer_id = 150
AND o.total_amount > 300
ORDER BY o.order_date DESC;

-- Exercise 6: Create a functional index
-- Create a functional index for case-insensitive searches

CREATE INDEX idx_customer_name_lower ON customers(LOWER(first_name), LOWER(last_name));

-- Test the functional index
EXPLAIN ANALYZE
SELECT customer_id, first_name, last_name, email
FROM customers
WHERE LOWER(first_name) = 'john' AND LOWER(last_name) = 'smith';

-- Exercise 7: Analyze index sizes and usage statistics
-- Retrieve information about indexes

-- Check the size of the tables and their indexes
SELECT
    table_name,
    pg_size_pretty(pg_relation_size(quote_ident(table_name))) AS table_size,
    pg_size_pretty(pg_indexes_size(quote_ident(table_name))) AS indexes_size,
    pg_size_pretty(pg_total_relation_size(quote_ident(table_name))) AS total_size
FROM (
    SELECT table_name FROM information_schema.tables
    WHERE table_schema = 'public'
    AND table_type = 'BASE TABLE'
) AS tables
ORDER BY pg_total_relation_size(quote_ident(table_name)) DESC;

-- Get index usage statistics
SELECT
    s.schemaname,
    s.relname AS tablename,
    s.indexrelname AS indexname,
    pg_size_pretty(pg_relation_size(s.indexrelid)) AS index_size,
    idx_scan AS scans,
    idx_tup_read AS tuples_read,
    idx_tup_fetch AS tuples_fetched
FROM
    pg_stat_user_indexes s
JOIN
    pg_index i ON s.indexrelid = i.indexrelid
WHERE
    s.schemaname = 'public'  -- Only look in the public schema
ORDER BY
    s.relname,
    scans DESC;

-- Clean up (comment out if you want to keep the tables and indexes)
-- DROP TABLE order_items;
-- DROP TABLE orders;
-- DROP TABLE products;
-- DROP TABLE product_categories;
-- DROP TABLE customers;
