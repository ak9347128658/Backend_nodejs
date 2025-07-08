-- Week 2, Day 5: JSON and Arrays in PostgreSQL Exercises

-- Exercise 1: Create a contacts table with JSON data
-- Create the contacts table
CREATE TABLE contacts (
    contact_id SERIAL PRIMARY KEY,
    basic_info JSONB,         -- Name, email, etc.
    addresses JSONB,          -- Multiple addresses
    phone_numbers JSONB,      -- Multiple phone numbers
    tags TEXT[],              -- Categories/tags for the contact
    created_at TIMESTAMP DEFAULT current_timestamp,
    updated_at TIMESTAMP DEFAULT current_timestamp
);

-- Insert sample data
INSERT INTO contacts (basic_info, addresses, phone_numbers, tags)
VALUES 
(
    '{"first_name": "John", "last_name": "Smith", "email": "john.smith@example.com", "birthday": "1985-03-15"}',
    '{"home": {"street": "123 Main St", "city": "Boston", "state": "MA", "zip": "02101", "country": "USA"},
      "work": {"street": "100 Technology Dr", "city": "Boston", "state": "MA", "zip": "02110", "country": "USA"}}',
    '{"mobile": "617-555-1234", "work": "617-555-5678", "home": "617-555-9012"}',
    ARRAY['friend', 'work', 'tech']
),
(
    '{"first_name": "Jane", "last_name": "Doe", "email": "jane.doe@example.com", "birthday": "1990-08-22"}',
    '{"home": {"street": "456 Park Ave", "city": "New York", "state": "NY", "zip": "10022", "country": "USA"}}',
    '{"mobile": "212-555-3456", "home": "212-555-7890"}',
    ARRAY['family', 'school']
),
(
    '{"first_name": "Robert", "last_name": "Johnson", "email": "robert.j@example.com", "birthday": "1978-11-05"}',
    '{"home": {"street": "789 Maple St", "city": "Chicago", "state": "IL", "zip": "60601", "country": "USA"},
      "vacation": {"street": "42 Beach Rd", "city": "Miami", "state": "FL", "zip": "33139", "country": "USA"}}',
    '{"mobile": "312-555-2468", "work": "312-555-1357", "home": "312-555-8642"}',
    ARRAY['friend', 'sports']
),
(
    '{"first_name": "Emily", "last_name": "Wilson", "email": "emily.w@example.com", "birthday": "1992-04-30"}',
    '{"home": {"street": "321 Oak Dr", "city": "San Francisco", "state": "CA", "zip": "94107", "country": "USA"},
      "work": {"street": "555 Market St", "city": "San Francisco", "state": "CA", "zip": "94105", "country": "USA"}}',
    '{"mobile": "415-555-9876", "work": "415-555-5432"}',
    ARRAY['friend', 'tech', 'book-club']
),
(
    '{"first_name": "Michael", "last_name": "Brown", "email": "michael.b@example.com", "birthday": "1980-12-18"}',
    '{"home": {"street": "987 Pine St", "city": "Chicago", "state": "IL", "zip": "60605", "country": "USA"}}',
    '{"mobile": "312-555-6543", "home": "312-555-8765"}',
    ARRAY['work', 'sports', 'neighbor']
);

-- Task 1: Extract specific contact details
-- Get all contacts with their basic information
SELECT 
    contact_id,
    basic_info->>'first_name' AS first_name,
    basic_info->>'last_name' AS last_name,
    basic_info->>'email' AS email,
    basic_info->>'birthday' AS birthday
FROM 
    contacts;

-- Get all home addresses
SELECT 
    contact_id,
    basic_info->>'first_name' || ' ' || basic_info->>'last_name' AS name,
    addresses->'home'->>'street' AS street,
    addresses->'home'->>'city' AS city,
    addresses->'home'->>'state' AS state,
    addresses->'home'->>'zip' AS zip
FROM 
    contacts;

-- Get all phone numbers as separate rows
SELECT 
    contact_id,
    basic_info->>'first_name' || ' ' || basic_info->>'last_name' AS name,
    key AS phone_type,
    value AS phone_number
FROM 
    contacts,
    jsonb_each_text(phone_numbers) AS phone;

-- Task 2: Update contact information using JSON operations
-- Add a new address to a contact
UPDATE contacts
SET addresses = addresses || '{"secondary": {"street": "888 Side St", "city": "Boston", "state": "MA", "zip": "02101", "country": "USA"}}'::jsonb
WHERE contact_id = 1;

-- Change an existing phone number
UPDATE contacts
SET phone_numbers = jsonb_set(phone_numbers, '{mobile}', '"617-555-0000"'::jsonb)
WHERE contact_id = 1;

-- Add a nickname to basic_info
UPDATE contacts
SET basic_info = basic_info || '{"nickname": "Johnny"}'::jsonb
WHERE contact_id = 1;

-- Task 3: Search for contacts in a specific city
-- Find all contacts who live in Chicago
SELECT 
    contact_id,
    basic_info->>'first_name' || ' ' || basic_info->>'last_name' AS name,
    addresses
FROM 
    contacts,
    jsonb_each(addresses) AS addr
WHERE 
    addr.value->>'city' = 'Chicago';

-- Find all contacts with a work address
SELECT 
    contact_id,
    basic_info->>'first_name' || ' ' || basic_info->>'last_name' AS name,
    addresses->'work' AS work_address
FROM 
    contacts
WHERE 
    addresses ? 'work';

-- Task 4: Query using tags array
-- Find contacts tagged as both 'friend' and 'tech'
SELECT 
    contact_id,
    basic_info->>'first_name' || ' ' || basic_info->>'last_name' AS name,
    tags
FROM 
    contacts
WHERE 
    tags @> ARRAY['friend', 'tech'];

-- Exercise 2: Work with product inventory
-- Create a product table with array of sizes
CREATE TABLE products (
    product_id SERIAL PRIMARY KEY,
    product_name VARCHAR(100),
    description TEXT,
    base_price NUMERIC(10, 2),
    available_sizes TEXT[],
    categories TEXT[],
    created_at TIMESTAMP DEFAULT current_timestamp
);

-- Create an inventory table with JSONB for stock levels by location
CREATE TABLE inventory (
    inventory_id SERIAL PRIMARY KEY,
    product_id INTEGER REFERENCES products(product_id),
    stock_levels JSONB,  -- {"store1": {"S": 5, "M": 10, "L": 2}, "store2": {"M": 3, "L": 8}}
    last_updated TIMESTAMP DEFAULT current_timestamp
);

-- Insert sample product data
INSERT INTO products (product_name, description, base_price, available_sizes, categories)
VALUES 
    ('Classic T-Shirt', 'Comfortable cotton t-shirt', 19.99, ARRAY['S', 'M', 'L', 'XL'], ARRAY['clothing', 'casual', 'essentials']),
    ('Slim Fit Jeans', 'Modern slim fit denim jeans', 49.99, ARRAY['28', '30', '32', '34', '36'], ARRAY['clothing', 'casual', 'denim']),
    ('Running Shoes', 'Lightweight performance running shoes', 89.99, ARRAY['7', '8', '9', '10', '11', '12'], ARRAY['footwear', 'athletic', 'running']),
    ('Winter Jacket', 'Warm insulated winter jacket', 129.99, ARRAY['S', 'M', 'L', 'XL', 'XXL'], ARRAY['clothing', 'outerwear', 'winter']),
    ('Leather Belt', 'Genuine leather belt', 29.99, ARRAY['32', '34', '36', '38', '40'], ARRAY['accessories', 'leather']);

-- Insert sample inventory data
INSERT INTO inventory (product_id, stock_levels)
VALUES 
    (1, '{"store1": {"S": 15, "M": 20, "L": 10, "XL": 5}, "store2": {"S": 8, "M": 12, "L": 15, "XL": 10}, "store3": {"S": 5, "M": 10, "L": 8, "XL": 3}, "online": {"S": 50, "M": 75, "L": 60, "XL": 25}}'),
    (2, '{"store1": {"28": 8, "30": 12, "32": 15, "34": 10, "36": 5}, "store2": {"30": 10, "32": 12, "34": 8, "36": 6}, "online": {"28": 25, "30": 40, "32": 50, "34": 40, "36": 20}}'),
    (3, '{"store1": {"7": 5, "8": 8, "9": 10, "10": 8, "11": 5, "12": 3}, "store3": {"8": 6, "9": 8, "10": 10, "11": 7, "12": 4}, "online": {"7": 20, "8": 30, "9": 35, "10": 30, "11": 25, "12": 15}}'),
    (4, '{"store2": {"S": 12, "M": 18, "L": 15, "XL": 10, "XXL": 5}, "store3": {"S": 8, "M": 14, "L": 12, "XL": 8, "XXL": 4}, "online": {"S": 30, "M": 45, "L": 40, "XL": 25, "XXL": 15}}'),
    (5, '{"store1": {"32": 10, "34": 15, "36": 12, "38": 8, "40": 5}, "store2": {"32": 8, "34": 12, "36": 10, "38": 6, "40": 4}, "online": {"32": 25, "34": 35, "36": 30, "38": 20, "40": 15}}');

-- Task 1: Find products available in specific sizes
-- Find all products available in size 'M'
SELECT 
    p.product_id,
    p.product_name,
    p.available_sizes
FROM 
    products p
WHERE 
    p.available_sizes @> ARRAY['M'];

-- Find products where size 'L' is in stock at store1
SELECT 
    p.product_id,
    p.product_name,
    i.stock_levels->'store1' AS store1_stock
FROM 
    products p
JOIN 
    inventory i ON p.product_id = i.product_id
WHERE 
    i.stock_levels->'store1' ? 'L'
    AND (i.stock_levels->'store1'->>'L')::INTEGER > 0;

-- Task 2: Update inventory levels for a specific location
-- Update stock level for a specific product, store, and size
UPDATE inventory
SET 
    stock_levels = jsonb_set(
        stock_levels, 
        '{store1, M}', 
        '25'::jsonb
    ),
    last_updated = current_timestamp
WHERE 
    product_id = 1;

-- Add a new store location with initial stock
UPDATE inventory
SET 
    stock_levels = stock_levels || '{"store4": {"S": 10, "M": 15, "L": 12, "XL": 8}}'::jsonb,
    last_updated = current_timestamp
WHERE 
    product_id = 1;

-- Task 3: Find products with low stock at any location
-- Define low stock as less than 5 items
WITH low_stock AS (
    SELECT 
        product_id,
        key AS store,
        jsonb_object_keys(value) AS size,
        (value->>jsonb_object_keys(value))::INTEGER AS quantity
    FROM 
        inventory,
        jsonb_each(stock_levels) AS store
    WHERE 
        (value->>jsonb_object_keys(value))::INTEGER < 5
)
SELECT 
    p.product_id,
    p.product_name,
    ls.store,
    ls.size,
    ls.quantity
FROM 
    low_stock ls
JOIN 
    products p ON ls.product_id = p.product_id
ORDER BY 
    ls.quantity, p.product_name;

-- Task 4: Calculate total inventory by product
SELECT 
    p.product_id,
    p.product_name,
    SUM((value->>size)::INTEGER) AS total_stock
FROM 
    inventory i
JOIN 
    products p ON i.product_id = p.product_id,
    jsonb_each(i.stock_levels) AS store,
    jsonb_object_keys(store.value) AS size
GROUP BY 
    p.product_id, p.product_name
ORDER BY 
    total_stock DESC;

-- Exercise 3: Implement a blog system
-- Create a posts table with tags as an array
CREATE TABLE blog_posts (
    post_id SERIAL PRIMARY KEY,
    title VARCHAR(200),
    content TEXT,
    author_id INTEGER,
    tags TEXT[],
    published_at TIMESTAMP DEFAULT current_timestamp,
    updated_at TIMESTAMP DEFAULT current_timestamp
);

-- Create a comments table with JSONB for nested comments
CREATE TABLE blog_comments (
    comment_id SERIAL PRIMARY KEY,
    post_id INTEGER REFERENCES blog_posts(post_id),
    parent_id INTEGER REFERENCES blog_comments(comment_id) NULL,
    content TEXT,
    author_id INTEGER,
    metadata JSONB,  -- Additional data like user agent, IP, etc.
    replies JSONB,   -- Nested replies structure
    created_at TIMESTAMP DEFAULT current_timestamp
);

-- Insert sample blog posts
INSERT INTO blog_posts (title, content, author_id, tags)
VALUES 
    ('Getting Started with PostgreSQL JSON', 'PostgreSQL offers powerful JSON capabilities...', 101, ARRAY['postgresql', 'json', 'database', 'tutorial']),
    ('Advanced SQL Techniques', 'Take your SQL skills to the next level...', 102, ARRAY['sql', 'database', 'advanced']),
    ('Web Development Best Practices', 'Modern web development requires...', 101, ARRAY['web', 'development', 'frontend', 'backend']),
    ('Introduction to Array Data Types', 'Arrays in databases provide flexibility...', 103, ARRAY['postgresql', 'arrays', 'database']),
    ('Building RESTful APIs', 'Learn how to design and implement RESTful APIs...', 102, ARRAY['api', 'rest', 'web', 'backend']);

-- Insert sample comments
INSERT INTO blog_comments (post_id, parent_id, content, author_id, metadata, replies)
VALUES 
    (1, NULL, 'Great article! Very helpful.', 201, '{"browser": "Chrome", "os": "Windows"}', '[]'::jsonb),
    (1, NULL, 'I have a question about JSONB indexing.', 202, '{"browser": "Firefox", "os": "MacOS"}', 
     '[
        {"id": 1, "author_id": 101, "content": "What would you like to know?", "created_at": "2023-05-15T10:30:00Z"},
        {"id": 2, "author_id": 202, "content": "How do I index nested JSONB fields?", "created_at": "2023-05-15T11:15:00Z"},
        {"id": 3, "author_id": 101, "content": "You can use the GIN index with the jsonb_path_ops operator class.", "created_at": "2023-05-15T12:00:00Z"}
     ]'::jsonb),
    (2, NULL, 'Would love to see more examples!', 203, '{"browser": "Safari", "os": "iOS"}', '[]'::jsonb),
    (3, NULL, 'I disagree with point #3.', 204, '{"browser": "Edge", "os": "Windows"}', 
     '[
        {"id": 1, "author_id": 101, "content": "Can you elaborate why?", "created_at": "2023-05-16T09:45:00Z"},
        {"id": 2, "author_id": 204, "content": "I think modern frameworks handle this differently.", "created_at": "2023-05-16T10:30:00Z"}
     ]'::jsonb),
    (3, NULL, 'Thanks for sharing these insights!', 205, '{"browser": "Chrome", "os": "Android"}', '[]'::jsonb),
    (4, NULL, 'Arrays are underutilized in database design.', 202, '{"browser": "Firefox", "os": "Linux"}', '[]'::jsonb),
    (5, NULL, 'Have you considered GraphQL as an alternative?', 203, '{"browser": "Chrome", "os": "MacOS"}', 
     '[
        {"id": 1, "author_id": 102, "content": "GraphQL is great but has different use cases.", "created_at": "2023-05-17T14:20:00Z"},
        {"id": 2, "author_id": 203, "content": "I see. Would love an article comparing them!", "created_at": "2023-05-17T15:05:00Z"}
     ]'::jsonb);

-- Task 1: Find posts with specific tags
-- Find all posts tagged with 'postgresql'
SELECT 
    post_id,
    title,
    tags
FROM 
    blog_posts
WHERE 
    tags @> ARRAY['postgresql'];

-- Find posts with either 'web' or 'api' tags
SELECT 
    post_id,
    title,
    tags
FROM 
    blog_posts
WHERE 
    tags && ARRAY['web', 'api'];

-- Task 2: Count comments per post, including nested comments
WITH comment_counts AS (
    SELECT 
        post_id,
        COUNT(*) AS top_level_comments,
        SUM(jsonb_array_length(replies)) AS nested_replies
    FROM 
        blog_comments
    GROUP BY 
        post_id
)
SELECT 
    p.post_id,
    p.title,
    COALESCE(cc.top_level_comments, 0) AS top_level_comments,
    COALESCE(cc.nested_replies, 0) AS nested_replies,
    COALESCE(cc.top_level_comments, 0) + COALESCE(cc.nested_replies, 0) AS total_comments
FROM 
    blog_posts p
LEFT JOIN 
    comment_counts cc ON p.post_id = cc.post_id
ORDER BY 
    total_comments DESC;

-- Task 3: Find the most active commenters
WITH all_commenters AS (
    -- Top-level commenters
    SELECT 
        author_id,
        COUNT(*) AS comment_count
    FROM 
        blog_comments
    GROUP BY 
        author_id
    
    UNION ALL
    
    -- Nested reply commenters
    SELECT 
        (reply->>'author_id')::INTEGER AS author_id,
        COUNT(*) AS comment_count
    FROM 
        blog_comments,
        jsonb_array_elements(replies) AS reply
    GROUP BY 
        (reply->>'author_id')::INTEGER
)
SELECT 
    author_id,
    SUM(comment_count) AS total_comments
FROM 
    all_commenters
GROUP BY 
    author_id
ORDER BY 
    total_comments DESC
LIMIT 5;

-- Task 4: Find all comments for a specific post, including nested replies
WITH all_comments AS (
    -- Top-level comments
    SELECT 
        post_id,
        comment_id,
        parent_id,
        content,
        author_id,
        created_at,
        0 AS level,
        comment_id::TEXT AS path
    FROM 
        blog_comments
    WHERE 
        parent_id IS NULL
    
    UNION ALL
    
    -- Nested replies as separate rows
    SELECT 
        bc.post_id,
        bc.comment_id,
        bc.comment_id AS parent_id,
        reply->>'content' AS content,
        (reply->>'author_id')::INTEGER AS author_id,
        (reply->>'created_at')::TIMESTAMP AS created_at,
        1 AS level,
        bc.comment_id::TEXT || '.' || (reply->>'id')::TEXT AS path
    FROM 
        blog_comments bc,
        jsonb_array_elements(bc.replies) AS reply
)
SELECT 
    post_id,
    level,
    author_id,
    content,
    created_at
FROM 
    all_comments
WHERE 
    post_id = 1
ORDER BY 
    path, level, created_at;

-- Exercise 4: Create a restaurant menu system
-- Create a menu items table
CREATE TABLE menu_items (
    item_id SERIAL PRIMARY KEY,
    name VARCHAR(100),
    description TEXT,
    base_price NUMERIC(6, 2),
    variations JSONB,  -- Different sizes, options, etc.
    ingredients TEXT[],
    categories TEXT[],
    nutritional_info JSONB,
    available BOOLEAN DEFAULT true,
    created_at TIMESTAMP DEFAULT current_timestamp
);

-- Insert sample menu items
INSERT INTO menu_items (name, description, base_price, variations, ingredients, categories, nutritional_info)
VALUES 
    ('Margherita Pizza', 'Classic pizza with tomato sauce, mozzarella, and basil', 12.99,
     '{"sizes": {"Small": 12.99, "Medium": 15.99, "Large": 18.99}, 
       "options": {"Extra Cheese": 1.50, "Gluten-Free Crust": 3.00, "Thin Crust": 0.00}}',
     ARRAY['dough', 'tomato sauce', 'mozzarella cheese', 'basil', 'olive oil'],
     ARRAY['pizza', 'vegetarian', 'italian'],
     '{"calories": 270, "protein": 12, "carbs": 30, "fat": 10}'),
     
    ('Caesar Salad', 'Fresh romaine lettuce with Caesar dressing, croutons, and parmesan', 9.99,
     '{"sizes": {"Side": 5.99, "Regular": 9.99, "Family": 15.99}, 
       "options": {"Add Chicken": 3.00, "Add Shrimp": 4.50, "No Croutons": 0.00}}',
     ARRAY['romaine lettuce', 'caesar dressing', 'croutons', 'parmesan cheese'],
     ARRAY['salad', 'starter'],
     '{"calories": 180, "protein": 5, "carbs": 12, "fat": 15}'),
     
    ('Beef Burger', 'Juicy beef patty with lettuce, tomato, and special sauce', 14.99,
     '{"sizes": {"Single": 14.99, "Double": 18.99}, 
       "options": {"Cheese": 1.00, "Bacon": 2.00, "Avocado": 1.50, "Gluten-Free Bun": 2.00}}',
     ARRAY['beef patty', 'lettuce', 'tomato', 'onion', 'special sauce', 'bun'],
     ARRAY['burger', 'beef', 'main'],
     '{"calories": 580, "protein": 30, "carbs": 40, "fat": 35}'),
     
    ('Spaghetti Carbonara', 'Classic carbonara with pancetta, egg, and parmesan', 16.99,
     '{"sizes": {"Regular": 16.99, "Large": 19.99}, 
       "options": {"Extra Pancetta": 2.50, "Extra Cheese": 1.00, "Gluten-Free Pasta": 2.00}}',
     ARRAY['spaghetti', 'eggs', 'pancetta', 'parmesan cheese', 'black pepper'],
     ARRAY['pasta', 'italian', 'main'],
     '{"calories": 650, "protein": 25, "carbs": 80, "fat": 28}'),
     
    ('Chocolate Brownie', 'Rich chocolate brownie with vanilla ice cream', 7.99,
     '{"options": {"Add Ice Cream": 2.00, "Add Whipped Cream": 1.00, "Add Caramel Sauce": 0.50}}',
     ARRAY['chocolate', 'flour', 'sugar', 'eggs', 'butter'],
     ARRAY['dessert', 'chocolate'],
     '{"calories": 420, "protein": 5, "carbs": 65, "fat": 18}');

-- Task 1: Query for items containing specific ingredients
-- Find all menu items containing 'cheese'
SELECT 
    item_id,
    name,
    ingredients
FROM 
    menu_items
WHERE 
    ingredients @> ARRAY['cheese'] OR
    array_to_string(ingredients, ',') LIKE '%cheese%';

-- Task 2: Find all items within a price range
-- Find items with base price between $10 and $15
SELECT 
    item_id,
    name,
    base_price
FROM 
    menu_items
WHERE 
    base_price BETWEEN 10 AND 15
ORDER BY 
    base_price;

-- Task 3: Find all variations of a menu item
SELECT 
    item_id,
    name,
    jsonb_object_keys(variations->'sizes') AS size,
    (variations->'sizes'->jsonb_object_keys(variations->'sizes'))::NUMERIC AS price
FROM 
    menu_items
WHERE 
    item_id = 1  -- Margherita Pizza
ORDER BY 
    price;

-- Task 4: Update prices for specific variations
-- Increase all pizza prices by 10%
UPDATE menu_items
SET variations = jsonb_set(
    variations, 
    '{sizes, Small}', 
    ((variations->'sizes'->>'Small')::NUMERIC * 1.1)::TEXT::jsonb
)
WHERE categories @> ARRAY['pizza'] AND variations->'sizes' ? 'Small';

UPDATE menu_items
SET variations = jsonb_set(
    variations, 
    '{sizes, Medium}', 
    ((variations->'sizes'->>'Medium')::NUMERIC * 1.1)::TEXT::jsonb
)
WHERE categories @> ARRAY['pizza'] AND variations->'sizes' ? 'Medium';

UPDATE menu_items
SET variations = jsonb_set(
    variations, 
    '{sizes, Large}', 
    ((variations->'sizes'->>'Large')::NUMERIC * 1.1)::TEXT::jsonb
)
WHERE categories @> ARRAY['pizza'] AND variations->'sizes' ? 'Large';

-- Exercise 5: Analytics challenge
-- Create a user_events table with JSONB data
CREATE TABLE user_events (
    event_id SERIAL PRIMARY KEY,
    user_id INTEGER,
    event_type VARCHAR(50),
    event_data JSONB,
    session_id VARCHAR(50),
    timestamp TIMESTAMP DEFAULT current_timestamp
);

-- Insert sample events data
INSERT INTO user_events (user_id, event_type, event_data, session_id, timestamp)
VALUES 
    (101, 'page_view', 
     '{"page": "home", "referrer": "google", "device": "mobile", "browser": "chrome"}', 
     'sess_1001', '2023-05-10 09:15:00'),
    (101, 'search', 
     '{"query": "summer shoes", "filters": {"category": "footwear", "size": "9", "color": "blue"}}', 
     'sess_1001', '2023-05-10 09:17:30'),
    (101, 'product_view', 
     '{"product_id": 5123, "product_name": "Blue Canvas Shoes", "price": 49.99, "category": "footwear"}', 
     'sess_1001', '2023-05-10 09:20:00'),
    (101, 'add_to_cart', 
     '{"product_id": 5123, "product_name": "Blue Canvas Shoes", "price": 49.99, "quantity": 1}', 
     'sess_1001', '2023-05-10 09:22:15'),
    (101, 'checkout', 
     '{"cart_total": 49.99, "shipping": 4.99, "tax": 5.50, "payment_method": "credit_card"}', 
     'sess_1001', '2023-05-10 09:25:00'),
    (101, 'purchase', 
     '{"order_id": "ORD-1234", "total": 60.48, "items": [{"product_id": 5123, "quantity": 1, "price": 49.99}]}', 
     'sess_1001', '2023-05-10 09:26:30'),
     
    (102, 'page_view', 
     '{"page": "home", "referrer": "direct", "device": "desktop", "browser": "firefox"}', 
     'sess_1002', '2023-05-10 10:05:00'),
    (102, 'search', 
     '{"query": "winter jacket", "filters": {"category": "outerwear", "size": "M", "color": "black"}}', 
     'sess_1002', '2023-05-10 10:08:45'),
    (102, 'page_view', 
     '{"page": "category", "category": "outerwear", "referrer": "internal", "device": "desktop"}', 
     'sess_1002', '2023-05-10 10:10:15'),
    (102, 'product_view', 
     '{"product_id": 2187, "product_name": "Black Winter Parka", "price": 129.99, "category": "outerwear"}', 
     'sess_1002', '2023-05-10 10:12:30'),
    (102, 'add_to_wishlist', 
     '{"product_id": 2187, "product_name": "Black Winter Parka", "price": 129.99}', 
     'sess_1002', '2023-05-10 10:13:45'),
     
    (103, 'page_view', 
     '{"page": "home", "referrer": "email", "device": "tablet", "browser": "safari"}', 
     'sess_1003', '2023-05-10 11:30:00'),
    (103, 'page_view', 
     '{"page": "category", "category": "electronics", "referrer": "internal", "device": "tablet"}', 
     'sess_1003', '2023-05-10 11:32:15'),
    (103, 'product_view', 
     '{"product_id": 3456, "product_name": "Wireless Headphones", "price": 89.99, "category": "electronics"}', 
     'sess_1003', '2023-05-10 11:35:00'),
    (103, 'add_to_cart', 
     '{"product_id": 3456, "product_name": "Wireless Headphones", "price": 89.99, "quantity": 1}', 
     'sess_1003', '2023-05-10 11:36:30'),
    (103, 'remove_from_cart', 
     '{"product_id": 3456, "product_name": "Wireless Headphones", "price": 89.99, "quantity": 1}', 
     'sess_1003', '2023-05-10 11:38:45'),
    (103, 'search', 
     '{"query": "bluetooth speaker", "filters": {"category": "electronics", "price_range": "50-100"}}', 
     'sess_1003', '2023-05-10 11:40:00'),
    (103, 'product_view', 
     '{"product_id": 3982, "product_name": "Portable Bluetooth Speaker", "price": 59.99, "category": "electronics"}', 
     'sess_1003', '2023-05-10 11:42:30'),
    (103, 'add_to_cart', 
     '{"product_id": 3982, "product_name": "Portable Bluetooth Speaker", "price": 59.99, "quantity": 1}', 
     'sess_1003', '2023-05-10 11:44:15'),
    (103, 'checkout', 
     '{"cart_total": 59.99, "shipping": 0.00, "tax": 6.00, "payment_method": "paypal"}', 
     'sess_1003', '2023-05-10 11:47:00'),
    (103, 'purchase', 
     '{"order_id": "ORD-1235", "total": 65.99, "items": [{"product_id": 3982, "quantity": 1, "price": 59.99}]}', 
     'sess_1003', '2023-05-10 11:48:30');

-- Task 1: Analyze user behavior patterns
-- Count events by type
SELECT 
    event_type,
    COUNT(*) AS event_count
FROM 
    user_events
GROUP BY 
    event_type
ORDER BY 
    event_count DESC;

-- Task 2: Analyze events by user, device, and browser
SELECT 
    user_id,
    event_data->>'device' AS device,
    event_data->>'browser' AS browser,
    COUNT(*) AS event_count
FROM 
    user_events
WHERE 
    event_data->>'device' IS NOT NULL
GROUP BY 
    user_id, event_data->>'device', event_data->>'browser'
ORDER BY 
    user_id, event_count DESC;

-- Task 3: Find the most common search queries
SELECT 
    event_data->>'query' AS search_query,
    COUNT(*) AS search_count
FROM 
    user_events
WHERE 
    event_type = 'search'
GROUP BY 
    event_data->>'query'
ORDER BY 
    search_count DESC;

-- Task 4: Calculate conversion rate (purchase / checkout ratio)
WITH checkout_counts AS (
    SELECT 
        COUNT(*) AS checkout_count
    FROM 
        user_events
    WHERE 
        event_type = 'checkout'
),
purchase_counts AS (
    SELECT 
        COUNT(*) AS purchase_count
    FROM 
        user_events
    WHERE 
        event_type = 'purchase'
)
SELECT 
    cc.checkout_count,
    pc.purchase_count,
    ROUND((pc.purchase_count::NUMERIC / cc.checkout_count::NUMERIC) * 100, 2) AS conversion_rate_percent
FROM 
    checkout_counts cc, purchase_counts pc;

-- Task 5: Find the most common event sequences
WITH numbered_events AS (
    SELECT 
        user_id,
        session_id,
        event_type,
        timestamp,
        ROW_NUMBER() OVER (PARTITION BY session_id ORDER BY timestamp) AS event_number
    FROM 
        user_events
)
SELECT 
    ne1.event_type AS first_event,
    ne2.event_type AS second_event,
    COUNT(*) AS sequence_count
FROM 
    numbered_events ne1
JOIN 
    numbered_events ne2 ON ne1.session_id = ne2.session_id
                        AND ne1.event_number = ne2.event_number - 1
GROUP BY 
    first_event, second_event
ORDER BY 
    sequence_count DESC;

-- Cleanup (comment out if you want to keep the tables)
-- DROP TABLE contacts;
-- DROP TABLE products;
-- DROP TABLE inventory;
-- DROP TABLE blog_posts;
-- DROP TABLE blog_comments;
-- DROP TABLE menu_items;
-- DROP TABLE user_events;
