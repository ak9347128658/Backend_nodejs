-- Example 1: JSON Basics
-- Create a table with JSON and JSONB columns
CREATE TABLE customer_data (
    customer_id SERIAL PRIMARY KEY,
    info JSON,              -- JSON datatype (stored as text)
    profile JSONB,          -- JSONB datatype (stored in binary format, more efficient)
    created_at TIMESTAMP DEFAULT current_timestamp
);

-- Insert data using JSON literals
INSERT INTO customer_data (info, profile)
VALUES 
(
    '{"name": "John Smith", "email": "john@example.com", "age": 35}',
    '{"address": {"street": "123 Main St", "city": "Boston", "state": "MA", "zip": "02101"}, 
      "preferences": {"theme": "dark", "notifications": true}}'
),
(
    '{"name": "Jane Doe", "email": "jane@example.com", "age": 28}',
    '{"address": {"street": "456 Park Ave", "city": "New York", "state": "NY", "zip": "10022"}, 
      "preferences": {"theme": "light", "notifications": false}}'
),
(
    '{"name": "Bob Johnson", "email": "bob@example.com", "age": 42}',
    '{"address": {"street": "789 Broad St", "city": "Chicago", "state": "IL", "zip": "60601"}, 
      "preferences": {"theme": "light", "notifications": true}}'
);

-- Extract values from JSON
SELECT 
    customer_id,
    info->>'name' AS name,
    info->>'email' AS email,
    (info->>'age')::INTEGER AS age  -- Cast to integer
FROM 
    customer_data;

-- Extract nested values from JSONB
SELECT 
    customer_id,
    profile->'address'->>'city' AS city,
    profile->'address'->>'state' AS state,
    profile->'preferences'->>'theme' AS theme
FROM 
    customer_data;

-- Difference between -> and ->>
-- -> returns a JSON object
-- ->> returns text
SELECT 
    customer_id,
    profile->'address' AS address_json,       -- Returns JSON
    profile->>'address' AS address_text       -- Returns text
FROM 
    customer_data;

-- Example 2: JSON Operations and Querying
-- Filter records based on JSON values
SELECT 
    customer_id,
    info->>'name' AS name
FROM 
    customer_data
WHERE 
    (info->>'age')::INTEGER > 30;

-- Filter by nested JSONB values
SELECT 
    customer_id,
    info->>'name' AS name,
    profile->'address'->>'city' AS city
FROM 
    customer_data
WHERE 
    profile->'address'->>'state' = 'NY';

-- Check for key existence
SELECT 
    customer_id,
    info->>'name' AS name
FROM 
    customer_data
WHERE 
    profile ? 'preferences';

-- Check for path existence
SELECT 
    customer_id,
    info->>'name' AS name
FROM 
    customer_data
WHERE 
    profile @> '{"preferences": {"theme": "light"}}';

-- Update JSON values
UPDATE customer_data
SET profile = profile || '{"preferences": {"theme": "dark"}}'::jsonb
WHERE customer_id = 2;

-- Remove a key from JSONB
UPDATE customer_data
SET profile = profile - 'preferences'
WHERE customer_id = 3;

-- Add a new key to JSONB
UPDATE customer_data
SET profile = profile || '{"last_login": "2023-05-15T14:30:00"}'::jsonb;

-- Check the results after updates
SELECT 
    customer_id,
    info->>'name' AS name,
    profile->'preferences'->>'theme' AS theme,
    profile->'last_login' AS last_login
FROM 
    customer_data;

-- Creating JSON from row data
SELECT 
    customer_id,
    json_build_object(
        'id', customer_id,
        'name', info->>'name',
        'contact', json_build_object(
            'email', info->>'email',
            'address', profile->'address'
        )
    ) AS customer_json
FROM 
    customer_data;

-- Example 3: Indexing JSON
-- Create a GIN index for JSONB containment operations
CREATE INDEX idx_profile_gin ON customer_data USING GIN (profile);

-- Create a GIN index for specific JSONB path
CREATE INDEX idx_profile_preferences_gin ON customer_data USING GIN ((profile->'preferences'));

-- Create a GIN index with the jsonb_path_ops operator class (more efficient for @> operator)
CREATE INDEX idx_profile_path_ops ON customer_data USING GIN (profile jsonb_path_ops);

-- Create a btree index on a JSON field (extracted as text)
CREATE INDEX idx_customer_email ON customer_data ((info->>'email'));

-- Query using the GIN index
EXPLAIN ANALYZE
SELECT * FROM customer_data
WHERE profile @> '{"preferences": {"theme": "light"}}';

-- Compare with a query that can't use the index efficiently
EXPLAIN ANALYZE
SELECT * FROM customer_data
WHERE profile->'preferences'->>'notifications' = 'true';

-- Example 4: Working with Arrays
-- Create a table with array columns
CREATE TABLE product_data (
    product_id SERIAL PRIMARY KEY,
    product_name VARCHAR(100),
    tags TEXT[],              -- Array of text
    prices NUMERIC[],         -- Array of numbers
    dimensions INTEGER[],     -- Array of integers
    created_at TIMESTAMP DEFAULT current_timestamp
);

-- Insert data with arrays
INSERT INTO product_data (product_name, tags, prices, dimensions)
VALUES 
    ('Laptop Pro', 
     ARRAY['electronics', 'computer', 'premium'], 
     ARRAY[999.99, 1099.99, 1299.99],
     ARRAY[13, 9, 1]),
     
    ('Smartphone X', 
     ARRAY['electronics', 'phone', 'mobile'], 
     ARRAY[799.99, 849.99],
     ARRAY[6, 3, 0]),
     
    ('Desk Chair', 
     ARRAY['furniture', 'office', 'ergonomic'], 
     ARRAY[199.99, 249.99, 299.99],
     ARRAY[30, 25, 45]),
     
    ('Coffee Maker', 
     ARRAY['appliance', 'kitchen', 'coffee'], 
     ARRAY[49.99, 69.99],
     ARRAY[10, 8, 12]);

-- Access array elements (1-based indexing)
SELECT 
    product_name,
    tags[1] AS first_tag,
    prices[1] AS base_price,
    dimensions[1] AS width,
    dimensions[2] AS depth,
    dimensions[3] AS height
FROM 
    product_data;

-- Array length
SELECT 
    product_name,
    array_length(tags, 1) AS tag_count,
    array_length(prices, 1) AS price_count
FROM 
    product_data;

-- Contains operator
SELECT 
    product_name,
    tags
FROM 
    product_data
WHERE 
    tags @> ARRAY['electronics'];

-- Overlap operator
SELECT 
    product_name,
    tags
FROM 
    product_data
WHERE 
    tags && ARRAY['kitchen', 'office'];

-- Unnest arrays (convert to rows)
SELECT 
    product_name,
    unnest(tags) AS tag
FROM 
    product_data;

-- Array modification
UPDATE product_data
SET tags = array_append(tags, 'sale')
WHERE product_id = 1;

UPDATE product_data
SET prices = array_prepend(599.99, prices)
WHERE product_id = 2;

UPDATE product_data
SET tags = array_remove(tags, 'office')
WHERE product_id = 3;

-- Check the results after array modifications
SELECT product_id, product_name, tags, prices
FROM product_data;

-- Create and use a GIN index for array
CREATE INDEX idx_product_tags ON product_data USING GIN (tags);

EXPLAIN ANALYZE
SELECT * FROM product_data
WHERE tags @> ARRAY['electronics'];

-- Example 5: Array Functions and Aggregation
-- Create a sample orders table
CREATE TABLE orders (
    order_id SERIAL PRIMARY KEY,
    customer_id INTEGER,
    products INTEGER[],  -- Array of product IDs
    quantities INTEGER[],  -- Corresponding quantities
    order_date TIMESTAMP DEFAULT current_timestamp
);

-- Insert sample data
INSERT INTO orders (customer_id, products, quantities)
VALUES 
    (1, ARRAY[1, 3, 4], ARRAY[1, 2, 1]),
    (2, ARRAY[2, 3], ARRAY[1, 1]),
    (1, ARRAY[1, 2], ARRAY[1, 1]),
    (3, ARRAY[4], ARRAY[3]);

-- Count array elements
SELECT 
    order_id,
    array_length(products, 1) AS product_count,
    array_to_string(products, ', ') AS products_list
FROM 
    orders;

-- Find orders containing specific products
SELECT 
    order_id,
    customer_id
FROM 
    orders
WHERE 
    products @> ARRAY[3];  -- Orders that include product ID 3

-- Aggregate arrays from multiple rows
SELECT 
    customer_id,
    array_agg(order_id) AS order_ids,
    array_agg(DISTINCT unnest(products)) AS all_products_ordered
FROM 
    orders
GROUP BY 
    customer_id;

-- Sum array elements
SELECT
    order_id,
    customer_id,
    (SELECT SUM(e) FROM unnest(quantities) AS e) AS total_quantity
FROM
    orders;

-- Join tables with arrays
SELECT 
    o.order_id,
    o.customer_id,
    p.product_name,
    p.tags
FROM 
    orders o
JOIN 
    product_data p ON p.product_id = ANY(o.products);

-- Generate arrays
SELECT generate_series(1, 5) AS num;

SELECT array_agg(num) FROM generate_series(1, 5) AS num;

-- Array comparisons
SELECT 
    o1.order_id AS order1,
    o2.order_id AS order2
FROM 
    orders o1
JOIN 
    orders o2 ON o1.products && o2.products  -- Orders with at least one common product
WHERE 
    o1.order_id < o2.order_id;  -- Avoid duplicates

-- Example 6: Combining JSON and Arrays
-- Create a table with both JSON and array data
CREATE TABLE user_activity (
    activity_id SERIAL PRIMARY KEY,
    user_id INTEGER,
    activities JSONB[],  -- Array of JSONB objects
    log_date DATE DEFAULT current_date
);

-- Insert data
INSERT INTO user_activity (user_id, activities)
VALUES 
    (1, ARRAY[
        '{"type": "login", "time": "09:00:00", "device": "mobile"}',
        '{"type": "search", "time": "09:15:00", "query": "laptops"}',
        '{"type": "view", "time": "09:20:00", "product_id": 1}'
    ]::jsonb[]),
    
    (2, ARRAY[
        '{"type": "login", "time": "10:30:00", "device": "desktop"}',
        '{"type": "view", "time": "10:35:00", "product_id": 3}',
        '{"type": "add_to_cart", "time": "10:40:00", "product_id": 3, "quantity": 1}'
    ]::jsonb[]),
    
    (1, ARRAY[
        '{"type": "login", "time": "14:00:00", "device": "desktop"}',
        '{"type": "view", "time": "14:10:00", "product_id": 2}',
        '{"type": "checkout", "time": "14:30:00", "total": 1399.98}'
    ]::jsonb[]);

-- Query for specific activity types
SELECT 
    activity_id,
    user_id,
    activity
FROM 
    user_activity,
    unnest(activities) AS activity
WHERE 
    activity->>'type' = 'checkout';

-- Find users who viewed a specific product
SELECT DISTINCT
    user_id
FROM 
    user_activity,
    unnest(activities) AS activity
WHERE 
    activity->>'type' = 'view' 
    AND (activity->>'product_id')::INTEGER = 3;

-- Count activities by type for each user
SELECT 
    user_id,
    activity->>'type' AS activity_type,
    COUNT(*) AS activity_count
FROM 
    user_activity,
    unnest(activities) AS activity
GROUP BY 
    user_id, activity->>'type'
ORDER BY 
    user_id, activity_count DESC;

-- Aggregate activity times by user
SELECT 
    user_id,
    json_object_agg(activity->>'type', activity->>'time') AS activity_times
FROM 
    user_activity,
    unnest(activities) AS activity
GROUP BY 
    user_id;

-- Example 7: Advanced JSON Processing
-- Create a table for storing complex JSON
CREATE TABLE event_logs (
    log_id SERIAL PRIMARY KEY,
    event_data JSONB,
    created_at TIMESTAMP DEFAULT current_timestamp
);

-- Insert sample event data
INSERT INTO event_logs (event_data)
VALUES 
    ('{"event": "page_view", "page": "/products", "user": {"id": 101, "type": "guest"}, "details": {"referrer": "google", "device": "mobile"}}'),
    ('{"event": "add_to_cart", "page": "/products/5", "user": {"id": 202, "type": "registered"}, "details": {"product_id": 5, "quantity": 1, "price": 49.99}}'),
    ('{"event": "checkout", "page": "/checkout", "user": {"id": 202, "type": "registered"}, "details": {"order_id": "ORD-001", "total": 49.99, "items": [{"product_id": 5, "quantity": 1, "price": 49.99}]}}'),
    ('{"event": "page_view", "page": "/products", "user": {"id": 303, "type": "registered"}, "details": {"referrer": "direct", "device": "desktop"}}'),
    ('{"event": "add_to_cart", "page": "/products/2", "user": {"id": 303, "type": "registered"}, "details": {"product_id": 2, "quantity": 2, "price": 29.99}}'),
    ('{"event": "checkout", "page": "/checkout", "user": {"id": 303, "type": "registered"}, "details": {"order_id": "ORD-002", "total": 59.98, "items": [{"product_id": 2, "quantity": 2, "price": 29.99}]}}');

-- Using jsonb_array_elements to expand nested arrays
SELECT 
    log_id,
    event_data->>'event' AS event_type,
    event_data->'user'->>'id' AS user_id,
    jsonb_array_elements(event_data->'details'->'items') AS item
FROM 
    event_logs
WHERE 
    event_data->>'event' = 'checkout';

-- Using jsonb_each to expand JSONB into key-value pairs
SELECT 
    log_id,
    key AS property,
    value AS value
FROM 
    event_logs,
    jsonb_each(event_data->'details') AS properties
WHERE 
    event_data->>'event' = 'page_view';

-- Using jsonb_object_keys to list all keys in a JSONB object
SELECT DISTINCT 
    jsonb_object_keys(event_data->'details') AS detail_properties
FROM 
    event_logs;

-- Aggregating by JSON properties
SELECT 
    event_data->'user'->>'type' AS user_type,
    COUNT(*) AS event_count,
    json_object_agg(event_data->>'event', COUNT(*)) AS event_breakdown
FROM 
    event_logs
GROUP BY 
    event_data->'user'->>'type';

-- Example 8: Performance Considerations

-- Creating a large table with JSON data for performance testing
CREATE TABLE performance_test (
    id SERIAL PRIMARY KEY,
    json_data JSON,
    jsonb_data JSONB
);

-- Insert test data (100 rows)
INSERT INTO performance_test (json_data, jsonb_data)
SELECT 
    json_build_object(
        'id', i,
        'name', 'Test ' || i,
        'properties', json_build_object(
            'value1', random() * 100,
            'value2', random() * 100,
            'nested', json_build_object(
                'deep1', random() * 100,
                'deep2', random() * 100
            )
        ),
        'tags', array_to_json(ARRAY['tag' || (i % 5), 'tag' || (i % 10)])
    ),
    json_build_object(
        'id', i,
        'name', 'Test ' || i,
        'properties', json_build_object(
            'value1', random() * 100,
            'value2', random() * 100,
            'nested', json_build_object(
                'deep1', random() * 100,
                'deep2', random() * 100
            )
        ),
        'tags', array_to_json(ARRAY['tag' || (i % 5), 'tag' || (i % 10)])
    )::jsonb
FROM generate_series(1, 100) AS i;

-- Compare performance of JSON vs JSONB for equality check
EXPLAIN ANALYZE
SELECT * FROM performance_test
WHERE json_data->>'name' = 'Test 50';

EXPLAIN ANALYZE
SELECT * FROM performance_test
WHERE jsonb_data->>'name' = 'Test 50';

-- Create an index and test again
CREATE INDEX idx_jsonb_name ON performance_test ((jsonb_data->>'name'));

EXPLAIN ANALYZE
SELECT * FROM performance_test
WHERE jsonb_data->>'name' = 'Test 50';

-- Cleanup (comment out if you want to keep the tables)
-- DROP TABLE customer_data;
-- DROP TABLE product_data;
-- DROP TABLE orders;
-- DROP TABLE user_activity;
-- DROP TABLE event_logs;
-- DROP TABLE performance_test;
