# Day 1: Advanced PostgreSQL Features

## Topics Covered

1. **Custom Data Types**
   - Domain types
   - Composite types
   - Enumerated types (ENUM)
   - Range types

2. **Inheritance**
   - Table inheritance
   - Benefits and limitations
   - Querying inherited tables

3. **Partitioning**
   - Range partitioning
   - List partitioning
   - Hash partitioning
   - Managing partitions
   - Partition pruning

4. **Extensions**
   - Overview of popular PostgreSQL extensions
   - Installing and using extensions
   - PostGIS for spatial data
   - pg_stat_statements for query analysis
   - pgcrypto for encryption

5. **Advisory Locks**
   - Understanding advisory locks
   - Application-level locking mechanisms
   - Use cases for advisory locks

## Examples and Exercises

### Example 1: Custom Data Types

#### Domain Types

Domain types are essentially data types with constraints. They're useful for ensuring consistent validation across multiple tables.

```sql
-- Create a domain type for email addresses
CREATE DOMAIN email_address AS VARCHAR(255)
  CHECK (VALUE ~ '^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$');

-- Create a table using the domain
CREATE TABLE users (
  user_id SERIAL PRIMARY KEY,
  name VARCHAR(100) NOT NULL,
  email email_address NOT NULL UNIQUE
);

-- Insert valid and invalid data
INSERT INTO users (name, email) VALUES ('John Doe', 'john.doe@example.com'); -- Valid
-- This will fail due to domain constraint:
-- INSERT INTO users (name, email) VALUES ('Invalid User', 'not-an-email');

-- Example with another domain for positive prices
CREATE DOMAIN positive_price AS NUMERIC(10, 2)
  CHECK (VALUE > 0);

CREATE TABLE products (
  product_id SERIAL PRIMARY KEY,
  name VARCHAR(100) NOT NULL,
  price positive_price NOT NULL
);

-- Valid insert
INSERT INTO products (name, price) VALUES ('Smartphone', 699.99);
-- Invalid insert (will fail)
-- INSERT INTO products (name, price) VALUES ('Free Item', 0);
-- INSERT INTO products (name, price) VALUES ('Negative Price', -10);
```

#### Composite Types

Composite types are similar to structs or records in programming languages. They allow you to define a type consisting of multiple fields.

```sql
-- Create a composite type for addresses
CREATE TYPE address AS (
  street VARCHAR(100),
  city VARCHAR(50),
  state CHAR(2),
  zip VARCHAR(10)
);

-- Create a table using the composite type
CREATE TABLE customers (
  customer_id SERIAL PRIMARY KEY,
  name VARCHAR(100) NOT NULL,
  shipping_address address,
  billing_address address
);

-- Insert data with composite type
INSERT INTO customers (name, shipping_address, billing_address)
VALUES (
  'Jane Smith',
  ROW('123 Main St', 'Boston', 'MA', '02108'),
  ROW('123 Main St', 'Boston', 'MA', '02108')
);

-- Query with composite types
SELECT 
  name, 
  (shipping_address).street AS shipping_street,
  (shipping_address).city AS shipping_city
FROM customers;

-- Update a field in a composite type
UPDATE customers
SET shipping_address.zip = '02109'
WHERE customer_id = 1;
```

#### Enumerated Types (ENUM)

ENUM types are useful when you have a fixed set of possible values.

```sql
-- Create an ENUM type for order status
CREATE TYPE order_status AS ENUM (
  'pending',
  'processing',
  'shipped',
  'delivered',
  'cancelled'
);

-- Create a table using the ENUM
CREATE TABLE orders (
  order_id SERIAL PRIMARY KEY,
  customer_id INTEGER NOT NULL,
  order_date TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  status order_status NOT NULL DEFAULT 'pending'
);

-- Insert with ENUM values
INSERT INTO orders (customer_id, status)
VALUES 
  (1, 'pending'),
  (2, 'processing'),
  (3, 'shipped'),
  (4, 'delivered'),
  (5, 'cancelled');

-- Invalid ENUM value (will fail)
-- INSERT INTO orders (customer_id, status) VALUES (6, 'refunded');

-- Query with ENUM values
SELECT * FROM orders WHERE status = 'shipped';

-- Sort by ENUM order (ENUMs are ordered by their creation position)
SELECT * FROM orders ORDER BY status;

-- Add a new value to an existing ENUM (adding at the end)
ALTER TYPE order_status ADD VALUE 'refunded' AFTER 'cancelled';
```

#### Range Types

Range types represent a range of values, such as a date range or a numeric range.

```sql
-- Create a table using built-in range types
CREATE TABLE reservations (
  reservation_id SERIAL PRIMARY KEY,
  room_id INTEGER NOT NULL,
  reserved_during DATERANGE NOT NULL,
  price_per_night NUMRANGE NOT NULL
);

-- Insert ranges
INSERT INTO reservations (room_id, reserved_during, price_per_night)
VALUES
  (101, '[2023-01-10, 2023-01-15)', '[100, 150)'),
  (102, '[2023-01-12, 2023-01-20)', '[120, 180)'),
  (103, '[2023-02-01, 2023-02-05)', '[90, 130)');

-- Query using range operators
-- Find reservations that include January 13th
SELECT * 
FROM reservations 
WHERE reserved_during @> '2023-01-13'::DATE;

-- Find reservations that overlap with a specific period
SELECT * 
FROM reservations 
WHERE reserved_during && '[2023-01-14, 2023-01-25)'::DATERANGE;

-- Find rooms with a price range that contains 125
SELECT * 
FROM reservations 
WHERE price_per_night @> 125;

-- Creating a custom range type
CREATE TYPE temperature_range AS RANGE (
  SUBTYPE = NUMERIC
);

CREATE TABLE climate_readings (
  reading_id SERIAL PRIMARY KEY,
  location VARCHAR(100) NOT NULL,
  reading_date DATE NOT NULL,
  temperature temperature_range NOT NULL
);

INSERT INTO climate_readings (location, reading_date, temperature)
VALUES 
  ('Boston', '2023-01-15', '[28, 35]'),
  ('Miami', '2023-01-15', '[65, 78]');
```

### Example 2: Table Inheritance

Table inheritance allows you to create parent-child table relationships where child tables inherit columns from parent tables.

```sql
-- Create a parent table
CREATE TABLE vehicles (
  vehicle_id SERIAL PRIMARY KEY,
  manufacturer VARCHAR(100) NOT NULL,
  model VARCHAR(100) NOT NULL,
  year INTEGER NOT NULL,
  price NUMERIC(10, 2) NOT NULL
);

-- Create child tables that inherit from vehicles
CREATE TABLE cars (
  num_doors INTEGER NOT NULL,
  body_style VARCHAR(50) NOT NULL,
  transmission VARCHAR(20) NOT NULL
) INHERITS (vehicles);

CREATE TABLE trucks (
  payload_capacity NUMERIC(10, 2) NOT NULL,
  bed_length NUMERIC(5, 2) NOT NULL,
  towing_capacity NUMERIC(10, 2) NOT NULL
) INHERITS (vehicles);

CREATE TABLE motorcycles (
  engine_displacement INTEGER NOT NULL,
  has_sidecar BOOLEAN NOT NULL DEFAULT FALSE
) INHERITS (vehicles);

-- Insert data into the tables
-- Cars
INSERT INTO cars (manufacturer, model, year, price, num_doors, body_style, transmission)
VALUES 
  ('Toyota', 'Camry', 2022, 25000.00, 4, 'Sedan', 'Automatic'),
  ('Honda', 'Civic', 2021, 22000.00, 4, 'Sedan', 'CVT'),
  ('Ford', 'Mustang', 2023, 45000.00, 2, 'Coupe', 'Manual');

-- Trucks
INSERT INTO trucks (manufacturer, model, year, price, payload_capacity, bed_length, towing_capacity)
VALUES 
  ('Ford', 'F-150', 2022, 35000.00, 2000.00, 6.5, 10000.00),
  ('Chevrolet', 'Silverado', 2022, 38000.00, 2200.00, 5.8, 12000.00);

-- Motorcycles
INSERT INTO motorcycles (manufacturer, model, year, price, engine_displacement, has_sidecar)
VALUES 
  ('Harley-Davidson', 'Street Glide', 2021, 22000.00, 1868, FALSE),
  ('BMW', 'R1250GS', 2022, 18000.00, 1254, FALSE),
  ('Ural', 'Gear Up', 2020, 16000.00, 749, TRUE);

-- Query all vehicles (includes all child tables)
SELECT * FROM vehicles;

-- Query only specific vehicle types
SELECT * FROM ONLY vehicles; -- Only records directly in the vehicles table (none in this case)
SELECT * FROM cars;
SELECT * FROM trucks;
SELECT * FROM motorcycles;

-- Query with TABLEOID to see which table each record comes from
SELECT 
  tableoid::regclass AS table_name,
  vehicle_id,
  manufacturer,
  model
FROM vehicles;

-- Join with child-specific columns
SELECT 
  v.vehicle_id,
  v.manufacturer,
  v.model,
  v.year,
  v.price,
  c.num_doors,
  c.body_style
FROM vehicles v
JOIN cars c ON v.vehicle_id = c.vehicle_id
WHERE v.price < 30000.00;
```

### Example 3: Table Partitioning

Partitioning divides large tables into smaller, more manageable pieces while maintaining the appearance of a single table.

```sql
-- Range Partitioning Example
-- Create a partitioned table for sales data
CREATE TABLE sales (
    sale_id SERIAL,
    product_id INTEGER NOT NULL,
    sale_date DATE NOT NULL,
    amount NUMERIC(10, 2) NOT NULL,
    customer_id INTEGER NOT NULL,
    PRIMARY KEY (sale_id, sale_date)
) PARTITION BY RANGE (sale_date);

-- Create partitions for different date ranges
CREATE TABLE sales_2021 PARTITION OF sales
    FOR VALUES FROM ('2021-01-01') TO ('2022-01-01');

CREATE TABLE sales_2022 PARTITION OF sales
    FOR VALUES FROM ('2022-01-01') TO ('2023-01-01');

CREATE TABLE sales_2023 PARTITION OF sales
    FOR VALUES FROM ('2023-01-01') TO ('2024-01-01');

-- Insert data into the partitioned table
INSERT INTO sales (product_id, sale_date, amount, customer_id)
VALUES
    (101, '2021-05-10', 250.00, 1001),
    (102, '2021-11-20', 125.50, 1002),
    (103, '2022-02-15', 340.00, 1003),
    (104, '2022-07-05', 190.75, 1004),
    (105, '2023-01-25', 460.25, 1005),
    (106, '2023-03-14', 275.00, 1006);

-- View partitions
SELECT 
    tableoid::regclass AS partition_name,
    count(*) AS row_count
FROM 
    sales
GROUP BY 
    tableoid;

-- Query the entire table (PostgreSQL will use partition pruning)
EXPLAIN ANALYZE
SELECT * FROM sales WHERE sale_date BETWEEN '2022-01-01' AND '2022-12-31';

-- List Partitioning Example
-- Create a partitioned table for regional customer data
CREATE TABLE customers (
    customer_id SERIAL,
    name VARCHAR(100) NOT NULL,
    email VARCHAR(255) NOT NULL,
    region VARCHAR(2) NOT NULL,
    join_date DATE NOT NULL,
    PRIMARY KEY (customer_id, region)
) PARTITION BY LIST (region);

-- Create partitions for different regions
CREATE TABLE customers_east PARTITION OF customers
    FOR VALUES IN ('EA', 'NE');

CREATE TABLE customers_west PARTITION OF customers
    FOR VALUES IN ('WE', 'NW');

CREATE TABLE customers_south PARTITION OF customers
    FOR VALUES IN ('SE', 'SW');

-- Insert data into different partitions
INSERT INTO customers (name, email, region, join_date)
VALUES
    ('John Smith', 'john@example.com', 'EA', '2021-05-10'),
    ('Jane Doe', 'jane@example.com', 'WE', '2021-06-15'),
    ('Bob Johnson', 'bob@example.com', 'SE', '2022-01-05'),
    ('Alice Brown', 'alice@example.com', 'NE', '2022-03-20'),
    ('Charlie Davis', 'charlie@example.com', 'NW', '2022-07-30'),
    ('Eva Garcia', 'eva@example.com', 'SW', '2023-02-12');

-- View partitions
SELECT 
    tableoid::regclass AS partition_name,
    count(*) AS row_count
FROM 
    customers
GROUP BY 
    tableoid;

-- Hash Partitioning Example
-- Create a partitioned table for product reviews
CREATE TABLE product_reviews (
    review_id SERIAL,
    product_id INTEGER NOT NULL,
    customer_id INTEGER NOT NULL,
    rating INTEGER NOT NULL,
    review_date DATE NOT NULL,
    comment TEXT,
    PRIMARY KEY (review_id, product_id)
) PARTITION BY HASH (product_id);

-- Create 4 hash partitions
CREATE TABLE product_reviews_p0 PARTITION OF product_reviews
    FOR VALUES WITH (MODULUS 4, REMAINDER 0);

CREATE TABLE product_reviews_p1 PARTITION OF product_reviews
    FOR VALUES WITH (MODULUS 4, REMAINDER 1);

CREATE TABLE product_reviews_p2 PARTITION OF product_reviews
    FOR VALUES WITH (MODULUS 4, REMAINDER 2);

CREATE TABLE product_reviews_p3 PARTITION OF product_reviews
    FOR VALUES WITH (MODULUS 4, REMAINDER 3);

-- Insert some sample data
INSERT INTO product_reviews (product_id, customer_id, rating, review_date, comment)
VALUES
    (101, 1001, 5, '2023-01-10', 'Excellent product!'),
    (102, 1002, 4, '2023-01-15', 'Very good, but could be better.'),
    (103, 1003, 5, '2023-01-20', 'Absolutely love it!'),
    (104, 1004, 3, '2023-01-25', 'It''s okay, but overpriced.'),
    (105, 1005, 4, '2023-02-01', 'Good quality for the price.'),
    (106, 1006, 2, '2023-02-05', 'Disappointed with durability.'),
    (107, 1007, 5, '2023-02-10', 'Perfect for my needs!'),
    (108, 1008, 4, '2023-02-15', 'Works as advertised.');

-- View partitions
SELECT 
    tableoid::regclass AS partition_name,
    count(*) AS row_count
FROM 
    product_reviews
GROUP BY 
    tableoid;

-- Managing Partitions
-- Add a new partition for sales in 2024
CREATE TABLE sales_2024 PARTITION OF sales
    FOR VALUES FROM ('2024-01-01') TO ('2025-01-01');

-- Detach a partition (without removing the data)
ALTER TABLE sales DETACH PARTITION sales_2021;

-- Attach an existing table as a partition
ALTER TABLE sales ATTACH PARTITION sales_2021
    FOR VALUES FROM ('2021-01-01') TO ('2022-01-01');

-- Creating a default partition for values that don't match other partitions
CREATE TABLE sales_default PARTITION OF sales DEFAULT;

-- Insert data that doesn't match any explicit partition range
INSERT INTO sales (product_id, sale_date, amount, customer_id)
VALUES (107, '2025-01-15', 550.00, 1007);

-- Verify it went to the default partition
SELECT 
    tableoid::regclass AS partition_name,
    *
FROM 
    sales
WHERE 
    sale_date >= '2025-01-01';
```

### Example 4: PostgreSQL Extensions

Extensions provide additional functionality to PostgreSQL.

```sql
-- List available extensions
SELECT * FROM pg_available_extensions;

-- List installed extensions
SELECT * FROM pg_extension;

-- Installing the pgcrypto extension for encryption functions
CREATE EXTENSION IF NOT EXISTS pgcrypto;

-- Using pgcrypto functions
SELECT gen_random_uuid() AS random_uuid;

-- Hash a password with pgcrypto
SELECT crypt('mysecretpassword', gen_salt('bf'));

-- Verify a password hash
SELECT 
    crypt('mysecretpassword', '$2a$06$3BVJRQt3HCMCwR4y1uFpO.xwZKjRk9MTL9MKPwkqICwGrHDGOsQOu') = 
    '$2a$06$3BVJRQt3HCMCwR4y1uFpO.xwZKjRk9MTL9MKPwkqICwGrHDGOsQOu' 
    AS password_matches;

-- Installing the pg_stat_statements extension for query analysis
CREATE EXTENSION IF NOT EXISTS pg_stat_statements;

-- View query statistics (after some queries have been run)
SELECT 
    query,
    calls,
    total_exec_time,
    mean_exec_time,
    rows
FROM 
    pg_stat_statements
ORDER BY 
    total_exec_time DESC
LIMIT 10;

-- Reset the statistics
SELECT pg_stat_statements_reset();

-- Uninstalling an extension
DROP EXTENSION IF EXISTS pg_stat_statements;

-- Basic example of PostGIS (spatial extension)
-- Note: This is a simplified example, actual installation may require additional steps
-- CREATE EXTENSION IF NOT EXISTS postgis;

-- Creating a spatial table (if PostGIS is installed)
-- CREATE TABLE locations (
--     id SERIAL PRIMARY KEY,
--     name VARCHAR(100) NOT NULL,
--     location GEOMETRY(Point, 4326)
-- );

-- Insert a point (longitude, latitude)
-- INSERT INTO locations (name, location)
-- VALUES ('PostgreSQL HQ', ST_SetSRID(ST_MakePoint(-122.0816, 37.3908), 4326));

-- Calculating distance between points
-- SELECT 
--     a.name AS location1,
--     b.name AS location2,
--     ST_Distance(
--         a.location::geography,
--         b.location::geography
--     ) / 1000 AS distance_km
-- FROM 
--     locations a,
--     locations b
-- WHERE 
--     a.id < b.id;

-- Installing hstore for key-value data
CREATE EXTENSION IF NOT EXISTS hstore;

-- Using hstore
CREATE TABLE products_with_attributes (
    product_id SERIAL PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    attributes hstore
);

INSERT INTO products_with_attributes (name, attributes)
VALUES 
    ('Smartphone', 'color => "black", memory => "128GB", camera => "48MP"'),
    ('Laptop', 'color => "silver", cpu => "i7", ram => "16GB", storage => "512GB"');

-- Query with hstore
SELECT 
    name,
    attributes -> 'color' AS color,
    attributes -> 'memory' AS memory
FROM 
    products_with_attributes;

-- Find products with specific attributes
SELECT * 
FROM products_with_attributes 
WHERE attributes @> 'color => "silver"';
```

### Example 5: Advisory Locks

Advisory locks provide a mechanism for applications to coordinate their activities.

```sql
-- Acquire an advisory lock (exclusive)
SELECT pg_advisory_lock(100);

-- Try to acquire the same lock (this will block until the first lock is released)
-- In another session: SELECT pg_advisory_lock(100);

-- Release the lock
SELECT pg_advisory_unlock(100);

-- Try a non-blocking lock acquisition
SELECT pg_try_advisory_lock(101) AS lock_acquired;

-- Using locks with multiple keys
SELECT pg_advisory_lock(1, 2);  -- Two-key version
SELECT pg_advisory_unlock(1, 2);

-- Session-level locks (automatically released at end of session)
SELECT pg_advisory_lock_shared(102);  -- Shared lock
SELECT pg_advisory_unlock_shared(102);

-- Transaction-level locks (automatically released at end of transaction)
BEGIN;
SELECT pg_advisory_xact_lock(103);
-- Do some work that requires coordination
COMMIT;  -- Lock is automatically released

-- Example of application-level locking
-- Function to safely increment a counter
CREATE OR REPLACE FUNCTION safe_increment_counter(counter_name TEXT)
RETURNS INTEGER AS $$
DECLARE
    counter_id INTEGER;
    current_value INTEGER;
BEGIN
    -- Get or create counter ID
    SELECT id INTO counter_id FROM counters WHERE name = counter_name;
    
    IF NOT FOUND THEN
        INSERT INTO counters (name, value) VALUES (counter_name, 0) RETURNING id INTO counter_id;
    END IF;
    
    -- Acquire lock for this counter
    PERFORM pg_advisory_lock(counter_id);
    
    -- Get current value
    SELECT value INTO current_value FROM counters WHERE id = counter_id;
    
    -- Increment
    UPDATE counters SET value = value + 1 WHERE id = counter_id;
    
    -- Release lock
    PERFORM pg_advisory_unlock(counter_id);
    
    RETURN current_value + 1;
END;
$$ LANGUAGE plpgsql;

-- Create counters table
CREATE TABLE IF NOT EXISTS counters (
    id SERIAL PRIMARY KEY,
    name TEXT UNIQUE NOT NULL,
    value INTEGER NOT NULL DEFAULT 0
);

-- Use the function
SELECT safe_increment_counter('visitors');
SELECT safe_increment_counter('visitors');
SELECT safe_increment_counter('visitors');
```

## Best Practices

1. **Custom Data Types:**
   - Use domain types to enforce consistent constraints across your schema
   - Consider using ENUM types for fixed sets of values, but be aware of limitations when values need to change
   - Use composite types to group related attributes when they commonly appear together
   - Use range types for intervals of values to simplify range-based queries

2. **Inheritance:**
   - Use inheritance to model "is-a" relationships
   - Be aware that constraints on parent tables are not automatically enforced on child tables
   - Consider using partitioning instead of inheritance for large tables where the goal is to improve performance
   - Remember that table inheritance doesn't provide true polymorphism

3. **Partitioning:**
   - Choose the right partitioning strategy based on your query patterns
   - Partition on columns that are frequently used in WHERE clauses
   - Don't create too many partitions - hundreds is reasonable, thousands may not be
   - Regularly monitor and manage partitions, adding new ones or archiving old ones as needed
   - Consider using a default partition to catch unexpected values

4. **Extensions:**
   - Only install extensions you need to minimize potential security vulnerabilities
   - Keep extensions updated to benefit from improvements and security fixes
   - Test extensions thoroughly in non-production environments before deploying to production
   - Be aware of the performance impact of extensions, especially those that add triggers or hooks

5. **Advisory Locks:**
   - Use advisory locks for application-level coordination rather than row locking when possible
   - Choose between session-level and transaction-level locks based on your needs
   - Always ensure locks are released, even in error cases
   - Use a consistent ID generation scheme for your locks to avoid conflicts

## Exercises

Complete the exercises in the `exercises.sql` file to practice these advanced PostgreSQL features.

## Additional Resources

1. PostgreSQL Documentation on:
   - [User-Defined Types](https://www.postgresql.org/docs/current/xtypes.html)
   - [Inheritance](https://www.postgresql.org/docs/current/ddl-inherit.html)
   - [Table Partitioning](https://www.postgresql.org/docs/current/ddl-partitioning.html)
   - [Extensions](https://www.postgresql.org/docs/current/external-extensions.html)
   - [Advisory Locks](https://www.postgresql.org/docs/current/functions-admin.html#FUNCTIONS-ADVISORY-LOCKS)

2. Additional Reading:
   - "PostgreSQL 14 Administration Cookbook" by Simon Riggs, Gianni Ciolli
   - "Mastering PostgreSQL 13" by Hans-Jürgen Schönig
