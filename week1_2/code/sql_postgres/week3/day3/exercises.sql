-- Week 3, Day 3: JSON and JSONB Data Types
-- Exercises

-- Setup tables and data for exercises
-- Note: If you've already run the examples.sql file, these tables might already exist

-- Products table
CREATE TABLE IF NOT EXISTS products (
    product_id SERIAL PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    category VARCHAR(50) NOT NULL,
    price NUMERIC(10, 2) NOT NULL,
    attributes JSONB,  -- For dynamic product attributes
    specifications JSONB -- For detailed technical specs
);

-- Insert sample data if table is empty
INSERT INTO products (name, category, price, attributes, specifications)
SELECT * FROM (VALUES
    (
        'Smartphone X', 
        'Electronics', 
        799.99, 
        '{"color": "black", "storage": "128GB", "memory": "8GB"}',
        '{"dimensions": {"height": 146.7, "width": 71.5, "depth": 7.4}, "display": {"type": "OLED", "size": 6.1, "resolution": "1170x2532"}, "camera": {"main": "12MP", "ultrawide": "12MP", "telephoto": "12MP"}}'
    ),
    (
        'Laptop Pro', 
        'Electronics', 
        1299.99, 
        '{"color": "silver", "storage": "512GB", "memory": "16GB"}',
        '{"processor": "Intel Core i7", "graphics": "Integrated", "ports": ["USB-C", "Thunderbolt", "HDMI"], "battery": "Up to 10 hours"}'
    ),
    (
        'Running Shoes', 
        'Footwear', 
        129.99, 
        '{"color": "blue", "size": 10, "gender": "unisex"}',
        '{"material": "synthetic", "sole": "rubber", "weight": "10.2oz", "features": ["waterproof", "shock absorption", "breathable"]}'
    ),
    (
        'Coffee Maker', 
        'Appliances', 
        89.99, 
        '{"color": "black", "capacity": "12 cups", "programmable": true}',
        '{"power": "1000W", "features": ["auto-shutoff", "brew strength control", "self-cleaning"], "dimensions": {"height": 14.5, "width": 9.0, "depth": 7.75}}'
    ),
    (
        'Wireless Headphones', 
        'Electronics', 
        199.99, 
        '{"color": "white", "type": "over-ear", "wireless": true}',
        '{"battery": "20 hours", "features": ["noise cancellation", "bluetooth 5.0", "touch controls"], "connectivity": ["bluetooth", "3.5mm jack"]}'
    )
) AS p
WHERE NOT EXISTS (SELECT 1 FROM products LIMIT 1);

-- Users table
CREATE TABLE IF NOT EXISTS users (
    user_id SERIAL PRIMARY KEY,
    username VARCHAR(50) UNIQUE NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    profile JSONB,
    preferences JSONB
);

-- Insert sample data if table is empty
INSERT INTO users (username, email, profile, preferences)
SELECT * FROM (VALUES
    (
        'john_doe',
        'john.doe@example.com',
        '{
            "first_name": "John",
            "last_name": "Doe",
            "age": 32,
            "address": {
                "street": "123 Main St",
                "city": "Boston",
                "state": "MA",
                "zipcode": "02108"
            },
            "phone": "555-123-4567",
            "social_media": {
                "twitter": "@johndoe",
                "linkedin": "linkedin.com/in/johndoe"
            }
        }',
        '{
            "theme": "dark",
            "notifications": {
                "email": true,
                "sms": false,
                "push": true
            },
            "language": "en-US",
            "dashboard": {
                "widgets": ["weather", "news", "calendar"],
                "layout": "grid"
            }
        }'
    ),
    (
        'jane_smith',
        'jane.smith@example.com',
        '{
            "first_name": "Jane",
            "last_name": "Smith",
            "age": 28,
            "address": {
                "street": "456 Park Ave",
                "city": "New York",
                "state": "NY",
                "zipcode": "10022"
            },
            "phone": "555-987-6543",
            "social_media": {
                "instagram": "@janesmith",
                "facebook": "facebook.com/janesmith"
            }
        }',
        '{
            "theme": "light",
            "notifications": {
                "email": true,
                "sms": true,
                "push": false
            },
            "language": "en-US",
            "dashboard": {
                "widgets": ["tasks", "analytics", "messages"],
                "layout": "list"
            }
        }'
    ),
    (
        'bob_johnson',
        'bob.johnson@example.com',
        '{
            "first_name": "Bob",
            "last_name": "Johnson",
            "age": 45,
            "address": {
                "street": "789 Oak Dr",
                "city": "Chicago",
                "state": "IL",
                "zipcode": "60601"
            },
            "phone": "555-456-7890"
        }',
        '{
            "theme": "system",
            "notifications": {
                "email": false,
                "sms": false,
                "push": false
            },
            "language": "en-US",
            "dashboard": {
                "widgets": ["weather", "stocks", "news"],
                "layout": "grid"
            }
        }'
    )
) AS u
WHERE NOT EXISTS (SELECT 1 FROM users LIMIT 1);

-- Events table
CREATE TABLE IF NOT EXISTS events (
    event_id SERIAL PRIMARY KEY,
    event_type VARCHAR(50) NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    data JSONB
);

-- Insert sample data if table is empty
INSERT INTO events (event_type, data)
SELECT * FROM (VALUES
    (
        'user_registration',
        '{
            "user_id": 101,
            "username": "new_user_1",
            "email": "new1@example.com",
            "registration_source": "web",
            "ip_address": "192.168.1.1",
            "device": {
                "type": "desktop",
                "browser": "Chrome",
                "os": "Windows"
            }
        }'
    ),
    (
        'purchase',
        '{
            "user_id": 102,
            "order_id": "ORD-12345",
            "total": 299.99,
            "items": [
                {"product_id": 1, "quantity": 1, "price": 199.99},
                {"product_id": 3, "quantity": 2, "price": 49.99}
            ],
            "payment": {
                "method": "credit_card",
                "last_four": "4242",
                "status": "approved"
            },
            "shipping": {
                "address": "123 Main St, Boston, MA 02108",
                "method": "express",
                "tracking_number": "TRK123456789"
            }
        }'
    ),
    (
        'error',
        '{
            "code": 500,
            "message": "Internal Server Error",
            "service": "payment_processor",
            "request_id": "req-abc-123",
            "stack_trace": "Error: Failed to connect to payment gateway\n    at PaymentService.processPayment (/app/services/payment.js:42:15)\n    at OrderController.checkout (/app/controllers/order.js:76:23)",
            "user_id": 103,
            "order_id": "ORD-67890"
        }'
    )
) AS e
WHERE NOT EXISTS (SELECT 1 FROM events LIMIT 1);

-- Exercise 1: Basic JSON Querying
-- Write a query to find all products with more than 8GB of memory (from attributes)
-- Output: product_id, name, memory amount

-- Your solution here:


-- Exercise 2: Nested JSON Properties
-- Write a query to extract the display resolution from the specifications of each electronic product.
-- Output: name, display resolution

-- Your solution here:


-- Exercise 3: Array Elements in JSON
-- Write a query that lists all the features of each product from specifications.
-- The result should have one row per feature per product.
-- Output: product name, feature

-- Your solution here:


-- Exercise 4: JSON Containment Operators
-- Write a query to find all products that have both "waterproof" and "breathable" in their features.
-- Use the @> containment operator.
-- Output: product name, price

-- Your solution here:


-- Exercise 5: JSON Modification
-- Update the Smartphone X product to add "5G" to its list of features in specifications.
-- You'll need to use jsonb_set and the array append functionality.
-- Then write a query to verify the change.

-- Your solution here:


-- Exercise 6: Conditional JSON Queries
-- Write a query to find all users whose notification preferences include enabled email notifications but disabled SMS notifications.
-- Output: user_id, username, email

-- Your solution here:


-- Exercise 7: JSON Aggregation
-- Write a query that groups products by category and creates a JSON array of product names in each category.
-- Output: category, json array of product names

-- Your solution here:


-- Exercise 8: Complex JSON Filtering
-- Find all events where a user made a purchase with more than one item.
-- You'll need to filter the events table based on event_type and then check the length of the items array.
-- Output: event_id, user_id, order_id, number of items

-- Your solution here:


-- Exercise 9: Creating Indexes for JSON
-- Create appropriate indexes to optimize the following query:
-- SELECT * FROM users WHERE preferences @> '{"theme": "dark"}'
-- Write the CREATE INDEX statement and then use EXPLAIN ANALYZE to compare performance before and after.

-- Your solution here:


-- Exercise 10: Custom JSON Functions
-- Create a function called get_user_location that takes a user_id and returns a formatted string with the user's city and state.
-- Example output for user_id 1: "Boston, MA"
-- Then write a query to call this function for all users.

-- Your solution here:


-- Exercise 11: JSON Schema Validation
-- Create a trigger that ensures all product attributes contain at least "color" and "size" keys.
-- Test it by attempting to insert a new product with incomplete attributes.

-- Your solution here:


-- Exercise 12: Extracting Key-Value Pairs
-- Write a query that flattens the attributes of each product into separate rows with key-value pairs.
-- Output: product_name, attribute_name, attribute_value

-- Your solution here:


-- Exercise 13: JSON Path Expressions
-- Write a query using the jsonb_path_exists function to find users who have any social media accounts.
-- Output: user_id, username, has_social_media (boolean)

-- Your solution here:


-- Exercise 14: Converting Row Data to JSON
-- Write a query that converts basic product information (id, name, category, price) to a JSON object for each product.
-- Output: json_data

-- Your solution here:


-- Exercise 15: Advanced JSON Report
-- Create a comprehensive report that shows for each user:
-- - User information (username, full name)
-- - Their location (city, state)
-- - A count of their dashboard widgets
-- - Whether they have enabled any notifications
-- - A list of their dashboard widgets as an array
-- Output all of this information as a single JSON object per user.

-- Your solution here:


-- Solutions

/*
-- Exercise 1 Solution: Basic JSON Querying
SELECT 
    product_id, 
    name, 
    attributes->>'memory' AS memory
FROM 
    products
WHERE 
    (attributes->>'memory')::text LIKE '%GB' 
    AND CAST(REGEXP_REPLACE(attributes->>'memory', 'GB', '') AS INTEGER) > 8;

-- Exercise 2 Solution: Nested JSON Properties
SELECT 
    name, 
    specifications->'display'->>'resolution' AS display_resolution
FROM 
    products
WHERE 
    category = 'Electronics' 
    AND specifications->'display'->>'resolution' IS NOT NULL;

-- Exercise 3 Solution: Array Elements in JSON
SELECT 
    p.name,
    feature
FROM 
    products p,
    jsonb_array_elements_text(p.specifications->'features') AS feature
ORDER BY 
    p.name, feature;

-- Exercise 4 Solution: JSON Containment Operators
SELECT 
    name, 
    price
FROM 
    products
WHERE 
    specifications->'features' @> '["waterproof", "breathable"]'::jsonb;

-- Exercise 5 Solution: JSON Modification
-- Update to add "5G" to features
UPDATE products
SET specifications = jsonb_set(
    specifications,
    '{features}',
    specifications->'features' || '"5G"'::jsonb
)
WHERE name = 'Smartphone X';

-- Verify the change
SELECT 
    name, 
    jsonb_array_elements_text(specifications->'features') AS feature
FROM 
    products
WHERE 
    name = 'Smartphone X';

-- Exercise 6 Solution: Conditional JSON Queries
SELECT 
    user_id, 
    username, 
    email
FROM 
    users
WHERE 
    preferences->'notifications'->>'email' = 'true'
    AND preferences->'notifications'->>'sms' = 'false';

-- Exercise 7 Solution: JSON Aggregation
SELECT 
    category,
    jsonb_agg(name) AS product_names
FROM 
    products
GROUP BY 
    category;

-- Exercise 8 Solution: Complex JSON Filtering
SELECT 
    event_id,
    (data->>'user_id')::integer AS user_id,
    data->>'order_id' AS order_id,
    jsonb_array_length(data->'items') AS number_of_items
FROM 
    events
WHERE 
    event_type = 'purchase'
    AND jsonb_array_length(data->'items') > 1;

-- Exercise 9 Solution: Creating Indexes for JSON
-- Create the index
CREATE INDEX idx_user_preferences_theme ON users USING GIN (preferences);

-- Check query performance before
EXPLAIN ANALYZE SELECT * FROM users WHERE preferences @> '{"theme": "dark"}';

-- Exercise 10 Solution: Custom JSON Functions
CREATE OR REPLACE FUNCTION get_user_location(p_user_id INTEGER)
RETURNS TEXT AS $$
DECLARE
    location TEXT;
BEGIN
    SELECT 
        profile->'address'->>'city' || ', ' || profile->'address'->>'state' INTO location
    FROM 
        users
    WHERE 
        user_id = p_user_id;
    
    RETURN location;
END;
$$ LANGUAGE plpgsql;

-- Test the function
SELECT 
    user_id, 
    username, 
    get_user_location(user_id) AS location
FROM 
    users;

-- Exercise 11 Solution: JSON Schema Validation
CREATE OR REPLACE FUNCTION validate_product_attributes()
RETURNS TRIGGER AS $$
BEGIN
    IF NEW.attributes IS NULL OR 
       NEW.attributes->>'color' IS NULL OR 
       NEW.attributes->>'size' IS NULL THEN
        RAISE EXCEPTION 'Product attributes must include color and size';
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER validate_product_attributes_trigger
BEFORE INSERT OR UPDATE ON products
FOR EACH ROW EXECUTE FUNCTION validate_product_attributes();

-- Test the trigger (this will fail)
-- INSERT INTO products (name, category, price, attributes, specifications)
-- VALUES (
--     'Test Product', 
--     'Test Category', 
--     99.99, 
--     '{"color": "red"}',
--     '{}'
-- );

-- Exercise 12 Solution: Extracting Key-Value Pairs
SELECT 
    p.name,
    (attr).key AS attribute_name,
    (attr).value AS attribute_value
FROM 
    products p,
    jsonb_each(p.attributes) AS attr
ORDER BY 
    p.name, attribute_name;

-- Exercise 13 Solution: JSON Path Expressions
SELECT 
    user_id,
    username,
    jsonb_path_exists(profile, '$.social_media[*]') AS has_social_media
FROM 
    users;

-- Exercise 14 Solution: Converting Row Data to JSON
SELECT 
    jsonb_build_object(
        'id', product_id,
        'name', name,
        'category', category,
        'price', price
    ) AS json_data
FROM 
    products;

-- Exercise 15 Solution: Advanced JSON Report
SELECT 
    jsonb_build_object(
        'user_info', jsonb_build_object(
            'username', username,
            'full_name', profile->>'first_name' || ' ' || profile->>'last_name'
        ),
        'location', jsonb_build_object(
            'city', profile->'address'->>'city',
            'state', profile->'address'->>'state'
        ),
        'dashboard', jsonb_build_object(
            'widget_count', jsonb_array_length(preferences->'dashboard'->'widgets'),
            'widgets', preferences->'dashboard'->'widgets',
            'layout', preferences->'dashboard'->>'layout'
        ),
        'notifications', jsonb_build_object(
            'has_enabled_notifications', 
            (preferences->'notifications'->>'email' = 'true' OR 
             preferences->'notifications'->>'sms' = 'true' OR 
             preferences->'notifications'->>'push' = 'true')
        )
    ) AS user_report
FROM 
    users;
*/
