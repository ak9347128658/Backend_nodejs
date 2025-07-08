# Day 3: JSON and JSONB Data Types

## Topics Covered

1. Introduction to JSON in PostgreSQL
2. JSON vs. JSONB data types
3. Creating tables with JSON/JSONB columns
4. Storing JSON data
5. Querying JSON data
6. Modifying JSON data
7. JSON operators and functions
8. Indexing JSON data
9. JSON Schema validation
10. Best practices

## Examples and Exercises

### Example 1: JSON vs. JSONB Data Types

PostgreSQL offers two JSON data types: `JSON` and `JSONB`. While both store JSON data, they differ in important ways:

**JSON**:
- Stores an exact copy of the input text
- Preserves whitespace, duplicate keys, and key order
- Slower to process (requires reparsing for each operation)
- No indexing support

**JSONB**:
- Binary format (decomposed binary format)
- Doesn't preserve whitespace, duplicate keys, or key order
- Faster to process (no reparsing needed)
- Supports indexing
- Slightly slower for input due to conversion overhead

```sql
-- Create tables with JSON and JSONB columns
CREATE TABLE json_example (
    id SERIAL PRIMARY KEY,
    data JSON
);

CREATE TABLE jsonb_example (
    id SERIAL PRIMARY KEY,
    data JSONB
);

-- Insert the same data into both tables
INSERT INTO json_example (data) VALUES
('{"name": "John", "age": 30, "city": "New York"}');

INSERT INTO jsonb_example (data) VALUES
('{"name": "John", "age": 30, "city": "New York"}');

-- Check if the data was stored correctly
SELECT * FROM json_example;
SELECT * FROM jsonb_example;

-- Insert data with duplicate keys and specific formatting
INSERT INTO json_example (data) VALUES
('{"name": "Alice", "name": "Bob", "age":  25 }');

INSERT INTO jsonb_example (data) VALUES
('{"name": "Alice", "name": "Bob", "age":  25 }');

-- Compare stored values (note JSONB keeps only the last value for duplicate keys and removes extra whitespace)
SELECT * FROM json_example;
SELECT * FROM jsonb_example;
```

### Example 2: Creating Tables with JSON/JSONB Columns

JSON/JSONB types are perfect for storing semi-structured data, nested objects, and arrays within a relational database.

```sql
-- Create a products table with JSONB for attributes and specifications
CREATE TABLE products (
    product_id SERIAL PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    category VARCHAR(50) NOT NULL,
    price NUMERIC(10, 2) NOT NULL,
    attributes JSONB,  -- For dynamic product attributes
    specifications JSONB -- For detailed technical specs
);

-- Insert products with varying attributes and specifications
INSERT INTO products (name, category, price, attributes, specifications)
VALUES
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
);

-- View the products
SELECT * FROM products;
```

### Example 3: Querying JSON Data - Basic Operations

PostgreSQL offers two primary ways to query JSON data:
1. Using operators (->>, ->, #>, #>>)
2. Using JSON functions

```sql
-- Operators for JSON/JSONB querying
-- -> Returns JSON object: Gets a JSON object field by key
-- ->> Returns text: Gets a JSON object field by key as text
-- #> Returns JSON object: Gets a JSON object at the specified path
-- #>> Returns text: Gets a JSON object at the specified path as text

-- Query products with 128GB storage
SELECT 
    product_id, 
    name, 
    attributes->>'storage' AS storage
FROM 
    products
WHERE 
    attributes->>'storage' = '128GB';

-- Get the display type of smartphones
SELECT 
    name,
    specifications->'display'->>'type' AS display_type
FROM 
    products
WHERE 
    category = 'Electronics';

-- Get camera details for the Smartphone
SELECT 
    name,
    specifications->'camera' AS camera_specs
FROM 
    products
WHERE 
    name = 'Smartphone X';

-- Extract nested array elements
SELECT 
    name,
    jsonb_array_elements_text(specifications->'ports') AS port
FROM 
    products
WHERE 
    name = 'Laptop Pro';

-- Extract features of the running shoes
SELECT 
    name,
    jsonb_array_elements_text(specifications->'features') AS feature
FROM 
    products
WHERE 
    name = 'Running Shoes';
```

### Example 4: Advanced JSON Querying

```sql
-- Create a table for customer data
CREATE TABLE customers (
    customer_id SERIAL PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    profile JSONB,
    orders JSONB
);

-- Insert sample customer data
INSERT INTO customers (name, email, profile, orders)
VALUES
(
    'John Smith',
    'john.smith@example.com',
    '{
        "age": 35,
        "gender": "male",
        "address": {
            "street": "123 Main St",
            "city": "New York",
            "state": "NY",
            "zipcode": "10001"
        },
        "preferences": {
            "notifications": true,
            "newsletter": false,
            "theme": "dark"
        },
        "payment_methods": [
            {"type": "credit_card", "last_four": "1234", "primary": true},
            {"type": "paypal", "email": "john.smith@example.com", "primary": false}
        ]
    }',
    '[
        {
            "order_id": 1001,
            "date": "2023-05-10",
            "total": 199.99,
            "items": [
                {"product_id": 1, "quantity": 1, "price": 799.99, "discount": 600.00},
                {"product_id": 5, "quantity": 2, "price": 49.99}
            ],
            "status": "delivered"
        },
        {
            "order_id": 1002,
            "date": "2023-06-15",
            "total": 1299.99,
            "items": [
                {"product_id": 2, "quantity": 1, "price": 1299.99}
            ],
            "status": "processing"
        }
    ]'
),
(
    'Jane Doe',
    'jane.doe@example.com',
    '{
        "age": 28,
        "gender": "female",
        "address": {
            "street": "456 Oak Ave",
            "city": "Los Angeles",
            "state": "CA",
            "zipcode": "90001"
        },
        "preferences": {
            "notifications": false,
            "newsletter": true,
            "theme": "light"
        },
        "payment_methods": [
            {"type": "credit_card", "last_four": "5678", "primary": true}
        ]
    }',
    '[
        {
            "order_id": 1003,
            "date": "2023-04-20",
            "total": 129.99,
            "items": [
                {"product_id": 3, "quantity": 1, "price": 129.99}
            ],
            "status": "delivered"
        }
    ]'
);

-- Find customers by city in their address
SELECT 
    customer_id, 
    name, 
    profile->'address'->>'city' AS city
FROM 
    customers
WHERE 
    profile->'address'->>'city' = 'New York';

-- Find customers with multiple payment methods
SELECT 
    customer_id, 
    name
FROM 
    customers
WHERE 
    jsonb_array_length(profile->'payment_methods') > 1;

-- Get all orders with status "delivered"
SELECT 
    c.name,
    jsonb_array_elements(c.orders)->>'order_id' AS order_id,
    jsonb_array_elements(c.orders)->>'date' AS order_date,
    jsonb_array_elements(c.orders)->>'total' AS total
FROM 
    customers c,
    jsonb_array_elements(c.orders) AS order_data
WHERE 
    order_data->>'status' = 'delivered';

-- Find customers who purchased a specific product (product_id = 2)
SELECT 
    c.name,
    order_data->>'order_id' AS order_id
FROM 
    customers c,
    jsonb_array_elements(c.orders) AS order_data,
    jsonb_array_elements(order_data->'items') AS item
WHERE 
    item->>'product_id' = '2';

-- Calculate the total spent by each customer
SELECT 
    c.name,
    SUM((jsonb_array_elements(c.orders)->>'total')::numeric) AS total_spent
FROM 
    customers c
GROUP BY 
    c.name;
```

### Example 5: Modifying JSON Data

PostgreSQL provides several functions to update and modify JSON data.

```sql
-- Update a single property in a JSONB object
UPDATE products
SET attributes = jsonb_set(attributes, '{color}', '"red"')
WHERE name = 'Smartphone X';

-- Add a new property to a JSONB object
UPDATE products
SET attributes = attributes || '{"waterproof": true}'
WHERE name = 'Smartphone X';

-- Remove a property from a JSONB object
UPDATE products
SET attributes = attributes - 'waterproof'
WHERE name = 'Smartphone X';

-- Update a nested property
UPDATE customers
SET profile = jsonb_set(
    profile, 
    '{preferences, theme}', 
    '"light"'
)
WHERE name = 'John Smith';

-- Add an element to a JSON array
UPDATE customers
SET profile = jsonb_set(
    profile,
    '{payment_methods}',
    profile->'payment_methods' || '[{"type": "bank_transfer", "account_last_four": "9876", "primary": false}]'
)
WHERE name = 'John Smith';

-- Remove an element from a JSON array (requires a bit more work)
-- Let's say we want to remove the PayPal payment method from John Smith's profile
WITH removed_paypal AS (
    SELECT jsonb_agg(payment)
    FROM (
        SELECT jsonb_array_elements(profile->'payment_methods') AS payment
        FROM customers
        WHERE name = 'John Smith'
    ) p
    WHERE payment->>'type' != 'paypal'
)
UPDATE customers
SET profile = jsonb_set(profile, '{payment_methods}', (SELECT * FROM removed_paypal))
WHERE name = 'John Smith';

-- Add a new order to a customer's orders array
UPDATE customers
SET orders = orders || '[{
    "order_id": 1004,
    "date": "2023-07-01",
    "total": 79.99,
    "items": [
        {"product_id": 4, "quantity": 1, "price": 79.99}
    ],
    "status": "shipped"
}]'
WHERE name = 'Jane Doe';
```

### Example 6: Indexing JSON Data

One of the major advantages of JSONB over JSON is the ability to create indexes on the data, which can significantly improve query performance.

```sql
-- Create a standard B-tree index on a specific JSON property
CREATE INDEX idx_product_storage ON products ((attributes->>'storage'));

-- Create a GIN index for general JSONB querying
CREATE INDEX idx_product_attributes ON products USING GIN (attributes);

-- Create a GIN index with the jsonb_path_ops operator class
-- More efficient for checking containment and existence operations
CREATE INDEX idx_product_specs ON products USING GIN (specifications jsonb_path_ops);

-- Create a GIN index on customer profile
CREATE INDEX idx_customer_profile ON customers USING GIN (profile);

-- Create a GIN index on customer orders
CREATE INDEX idx_customer_orders ON customers USING GIN (orders);

-- Examples of queries that can use these indexes:

-- Query that can use idx_product_storage
SELECT * FROM products WHERE attributes->>'storage' = '128GB';

-- Query that can use idx_product_attributes
SELECT * FROM products WHERE attributes @> '{"color": "red", "storage": "128GB"}';

-- Query that can use idx_product_specs
SELECT * FROM products WHERE specifications @> '{"processor": "Intel Core i7"}';

-- Query that can use idx_customer_profile
SELECT * FROM customers WHERE profile @> '{"address": {"city": "New York"}}';

-- Query that can use idx_customer_orders
SELECT * FROM customers WHERE orders @> '[{"status": "delivered"}]';
```

### Example 7: JSON Schema Validation

While PostgreSQL doesn't have built-in JSON schema validation, we can implement it using check constraints or triggers.

```sql
-- Create a function to validate JSON against a schema
CREATE OR REPLACE FUNCTION validate_json_schema(json_data JSONB, schema JSONB)
RETURNS BOOLEAN AS $$
DECLARE
    required_field TEXT;
BEGIN
    -- Check required fields
    FOR required_field IN SELECT jsonb_array_elements_text(schema->'required')
    LOOP
        IF json_data->required_field IS NULL THEN
            RETURN FALSE;
        END IF;
    END LOOP;

    -- Check property types (simplified example)
    -- In a real implementation, you'd handle nested objects, arrays, and more type checks
    FOR property_name, property_schema IN 
        SELECT * FROM jsonb_each(schema->'properties')
    LOOP
        IF json_data->property_name IS NOT NULL THEN
            -- Check type
            IF property_schema->>'type' = 'string' AND jsonb_typeof(json_data->property_name) != 'string' THEN
                RETURN FALSE;
            ELSIF property_schema->>'type' = 'number' AND jsonb_typeof(json_data->property_name) NOT IN ('number') THEN
                RETURN FALSE;
            ELSIF property_schema->>'type' = 'integer' AND jsonb_typeof(json_data->property_name) != 'number' THEN
                RETURN FALSE;
            ELSIF property_schema->>'type' = 'boolean' AND jsonb_typeof(json_data->property_name) != 'boolean' THEN
                RETURN FALSE;
            ELSIF property_schema->>'type' = 'object' AND jsonb_typeof(json_data->property_name) != 'object' THEN
                RETURN FALSE;
            ELSIF property_schema->>'type' = 'array' AND jsonb_typeof(json_data->property_name) != 'array' THEN
                RETURN FALSE;
            END IF;
        END IF;
    END LOOP;

    RETURN TRUE;
END;
$$ LANGUAGE plpgsql;

-- Create a table with JSON schema validation
CREATE TABLE validated_documents (
    doc_id SERIAL PRIMARY KEY,
    doc_type VARCHAR(50) NOT NULL,
    data JSONB NOT NULL
);

-- Create a trigger function for JSON schema validation
CREATE OR REPLACE FUNCTION validate_document_schema()
RETURNS TRIGGER AS $$
DECLARE
    schema JSONB;
BEGIN
    -- Define schemas for different document types
    CASE NEW.doc_type
        WHEN 'person' THEN
            schema := '{
                "required": ["firstName", "lastName", "age"],
                "properties": {
                    "firstName": {"type": "string"},
                    "lastName": {"type": "string"},
                    "age": {"type": "integer"},
                    "email": {"type": "string"},
                    "address": {"type": "object"}
                }
            }';
        WHEN 'product' THEN
            schema := '{
                "required": ["name", "price"],
                "properties": {
                    "name": {"type": "string"},
                    "price": {"type": "number"},
                    "tags": {"type": "array"},
                    "dimensions": {"type": "object"}
                }
            }';
        ELSE
            RAISE EXCEPTION 'Unknown document type: %', NEW.doc_type;
    END CASE;

    -- Validate the document against the schema
    IF NOT validate_json_schema(NEW.data, schema) THEN
        RAISE EXCEPTION 'Document does not conform to the schema for type %', NEW.doc_type;
    END IF;

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Attach the trigger
CREATE TRIGGER validate_document_schema_trigger
BEFORE INSERT OR UPDATE ON validated_documents
FOR EACH ROW EXECUTE FUNCTION validate_document_schema();

-- Insert valid documents
INSERT INTO validated_documents (doc_type, data) VALUES
('person', '{"firstName": "John", "lastName": "Doe", "age": 30, "email": "john.doe@example.com"}');

INSERT INTO validated_documents (doc_type, data) VALUES
('product', '{"name": "Laptop", "price": 999.99, "tags": ["electronics", "computers"]}');

-- Try to insert invalid documents (will fail)
-- Missing required field
-- INSERT INTO validated_documents (doc_type, data) VALUES
-- ('person', '{"firstName": "Jane", "age": 25}');

-- Wrong type for a field
-- INSERT INTO validated_documents (doc_type, data) VALUES
-- ('person', '{"firstName": "Jane", "lastName": "Smith", "age": "thirty"}');
```

### Example 8: Practical Applications of JSON in PostgreSQL

```sql
-- Application: Event logging system
CREATE TABLE event_logs (
    log_id SERIAL PRIMARY KEY,
    timestamp TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    event_type VARCHAR(50) NOT NULL,
    source VARCHAR(100) NOT NULL,
    data JSONB NOT NULL
);

-- Insert different types of events
INSERT INTO event_logs (event_type, source, data) VALUES
('user.login', 'web_app', '{"user_id": 1001, "ip": "192.168.1.1", "device": "mobile", "browser": "Chrome"}'),
('user.purchase', 'mobile_app', '{"user_id": 1001, "product_id": 2, "amount": 1299.99, "payment_method": "credit_card"}'),
('system.error', 'api_server', '{"code": 500, "message": "Database connection failed", "stack": "Error at line 42..."}');

-- Query for specific events
SELECT * FROM event_logs WHERE event_type = 'user.login';

-- Find errors with a specific code
SELECT timestamp, data->>'message' AS error_message 
FROM event_logs 
WHERE event_type = 'system.error' AND (data->>'code')::int = 500;

-- Application: Dynamic form data
CREATE TABLE form_submissions (
    submission_id SERIAL PRIMARY KEY,
    form_id VARCHAR(50) NOT NULL,
    submitted_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    submitted_by INTEGER NOT NULL,
    form_data JSONB NOT NULL
);

-- Insert form submissions with different structures
INSERT INTO form_submissions (form_id, submitted_by, form_data) VALUES
('contact', 1001, '{"name": "John Smith", "email": "john@example.com", "message": "Hello, I have a question..."}'),
('survey', 1002, '{"age_group": "25-34", "favorite_product": "Laptop Pro", "satisfaction": 5, "feedback": "Great product!"}'),
('job_application', 1003, '{"name": "Jane Doe", "position": "Software Developer", "experience": 5, "skills": ["Java", "SQL", "JavaScript"], "education": [{"degree": "BS", "field": "Computer Science", "year": 2018}]}');

-- Query for specific form submissions
SELECT * FROM form_submissions WHERE form_id = 'job_application';

-- Find job applicants with specific skills
SELECT 
    submission_id, 
    form_data->>'name' AS applicant_name
FROM 
    form_submissions,
    jsonb_array_elements_text(form_data->'skills') AS skill
WHERE 
    form_id = 'job_application' 
    AND skill = 'SQL';

-- Application: Product catalog with varying attributes
-- (We already created this in Example 2)

-- Application: Configuration storage
CREATE TABLE app_configurations (
    app_id VARCHAR(50) PRIMARY KEY,
    version VARCHAR(20) NOT NULL,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    config JSONB NOT NULL
);

INSERT INTO app_configurations (app_id, version, config) VALUES
('web_frontend', '1.2.0', '{
    "theme": {
        "primary_color": "#336699",
        "secondary_color": "#CCDDEE",
        "font_family": "Roboto, sans-serif"
    },
    "features": {
        "dark_mode": true,
        "notifications": true,
        "user_tracking": false
    },
    "api": {
        "endpoint": "https://api.example.com/v2",
        "timeout": 30,
        "retry_attempts": 3
    }
}');

-- Query for specific configuration settings
SELECT config->'theme'->>'primary_color' AS primary_color 
FROM app_configurations 
WHERE app_id = 'web_frontend';

-- Update a specific configuration setting
UPDATE app_configurations
SET config = jsonb_set(config, '{features, dark_mode}', 'false'),
    updated_at = CURRENT_TIMESTAMP
WHERE app_id = 'web_frontend';
```

## Best Practices for Working with JSON in PostgreSQL

1. **Choose JSONB over JSON** for most use cases, as it offers better performance and indexing capabilities.

2. **Normalize when appropriate**:
   - Store frequently queried or updated fields in regular columns
   - Use JSON for flexible, rarely queried attributes or nested structures

3. **Create appropriate indexes**:
   - Use B-tree indexes for specific attributes that are frequently queried
   - Use GIN indexes for complex queries that need to search within JSON structures

4. **Validate JSON data**:
   - Implement schema validation for critical data
   - Use constraints or triggers to enforce data integrity

5. **Be cautious with deeply nested structures**:
   - Deep nesting can make queries complex and slow
   - Consider flattening structures when appropriate

6. **Monitor performance**:
   - JSON operations can be resource-intensive
   - Regularly analyze and optimize queries involving JSON data

7. **Keep JSON documents reasonably sized**:
   - Very large JSON documents can impact performance
   - Consider splitting large documents into logical components

8. **Use appropriate operators**:
   - `->` and `->>` for specific key access
   - `@>` for containment queries (works well with GIN indexes)
   - Use `jsonb_path_ops` for better performance with containment queries

9. **Leverage PostgreSQL JSON functions**:
   - `jsonb_set()` for updating specific fields
   - `jsonb_array_elements()` for working with arrays
   - `jsonb_each()` for iterating through key-value pairs

10. **Document your JSON structures**:
    - Keep schema definitions in code or documentation
    - Document the meaning and expected format of each field

## Exercises

Complete the exercises in the exercises.sql file to practice working with JSON and JSONB data types in PostgreSQL.
