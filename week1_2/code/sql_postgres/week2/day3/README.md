

# Week 2, Day 3: PostgreSQL Indexes and Query Optimization

This document provides a comprehensive guide to understanding PostgreSQL indexes and query optimization, designed to be beginner-friendly with detailed explanations and multiple examples for each topic. The goal is to make complex concepts accessible and actionable for learners. The content is based on the provided `examples.sql` and `exercises.sql` files, expanded with additional examples and detailed explanations.

## Table of Contents
1. [Introduction to Indexes](#introduction-to-indexes)
2. [Types of Indexes](#types-of-indexes)
3. [Creating and Managing Indexes](#creating-and-managing-indexes)
4. [Query Analysis with EXPLAIN and EXPLAIN ANALYZE](#query-analysis-with-explain-and-explain-analyze)
5. [Query Optimization Techniques](#query-optimization-techniques)
6. [Index Maintenance](#index-maintenance)
7. [Partial Indexes](#partial-indexes)
8. [Functional Indexes](#functional-indexes)
9. [Summary](#summary)
10. [Exercises](#exercises)

---

## Introduction to Indexes

Indexes in PostgreSQL are database objects that improve the speed of data retrieval operations on a table at the cost of additional storage and maintenance overhead. Think of an index like a book's table of contents—it helps you quickly find specific information without scanning every page.

### Why Use Indexes?
- **Speed up queries**: Indexes reduce the amount of data scanned for queries involving `WHERE`, `JOIN`, and `ORDER BY` clauses.
- **Trade-offs**: Indexes increase storage requirements and slow down write operations (`INSERT`, `UPDATE`, `DELETE`) because the index must be updated.
- **Use case**: Best for frequently queried columns, such as primary keys, foreign keys, or columns used in filters.

### Example 1: Basic Index Creation
Create a table and index to speed up email-based searches.

```sql
CREATE TABLE employees (
    employee_id SERIAL PRIMARY KEY,
    email VARCHAR(100) UNIQUE,
    name VARCHAR(50)
);

-- Create an index on the email column
CREATE INDEX idx_employees_email ON employees(email);

-- Query to find an employee by email
EXPLAIN ANALYZE SELECT * FROM employees WHERE email = 'john.doe@example.com';
```

**Explanation**: The `idx_employees_email` index allows PostgreSQL to quickly locate rows where `email = 'john.doe@example.com'` without scanning the entire table.

### Example 2: Index on a Large Table
Generate a large dataset and observe the impact of an index.

```sql
CREATE TABLE orders_log (
    log_id SERIAL PRIMARY KEY,
    order_id INTEGER,
    log_message TEXT,
    created_at TIMESTAMP DEFAULT current_timestamp
);

-- Insert 100,000 rows
INSERT INTO orders_log (order_id, log_message)
SELECT generate_series(1, 100000), 'Log entry ' || generate_series(1, 100000);

-- Query without index
EXPLAIN ANALYZE SELECT * FROM orders_log WHERE order_id = 50000;

-- Create an index
CREATE INDEX idx_orders_log_order_id ON orders_log(order_id);

-- Query with index
EXPLAIN ANALYZE SELECT * FROM orders_log WHERE order_id = 50000;
```

**Explanation**: Without an index, PostgreSQL performs a sequential scan (checking every row). The index allows a faster index scan.

### Example 3: Unique Index
Ensure uniqueness and improve query performance.

```sql
CREATE TABLE products (
    product_id SERIAL PRIMARY KEY,
    product_code VARCHAR(20) UNIQUE,
    product_name VARCHAR(100)
);

-- The UNIQUE constraint automatically creates an index
INSERT INTO products (product_code, product_name) VALUES ('P123', 'Laptop');

-- Query using the unique index
EXPLAIN ANALYZE SELECT * FROM products WHERE product_code = 'P123';
```

**Explanation**: The `UNIQUE` constraint on `product_code` creates a B-tree index automatically, ensuring no duplicate `product_code` values and speeding up searches.

### Example 4: Index on Frequently Filtered Column
Index a column used in frequent `WHERE` clauses.

```sql
CREATE TABLE customers (
    customer_id SERIAL PRIMARY KEY,
    city VARCHAR(50),
    name VARCHAR(50)
);

-- Insert sample data
INSERT INTO customers (city, name)
SELECT (ARRAY['New York', 'Chicago', 'Los Angeles'])[floor(random() * 3 + 1)], 'Customer ' || generate_series(1, 10000);

-- Query without index
EXPLAIN ANALYZE SELECT * FROM customers WHERE city = 'New York';

-- Create index
CREATE INDEX idx_customers_city ON customers(city);

-- Query with index
EXPLAIN ANALYZE SELECT * FROM customers WHERE city = 'New York';
```

**Explanation**: Indexing the `city` column speeds up queries filtering by city, common in reporting or analytics.

### Example 5: Index on Foreign Key
Improve performance for joins involving foreign keys.

```sql
CREATE TABLE orders (
    order_id SERIAL PRIMARY KEY,
    customer_id INTEGER REFERENCES customers(customer_id),
    order_date DATE
);

-- Query joining tables without index
EXPLAIN ANALYZE SELECT o.order_id, c.name
FROM orders o
JOIN customers c ON o.customer_id = c.customer_id
WHERE c.customer_id = 100;

-- Create index on foreign key
CREATE INDEX idx_orders_customer_id ON orders(customer_id);

-- Query with index
EXPLAIN ANALYZE SELECT o.order_id, c.name
FROM orders o
JOIN customers c ON o.customer_id = c.customer_id
WHERE c.customer_id = 100;
```

**Explanation**: Indexing foreign keys like `customer_id` improves performance for joins, a common operation in relational databases.

---

## Types of Indexes

PostgreSQL supports several index types, each suited for specific use cases. Understanding these types helps you choose the right index for your queries.

### B-tree Index
- **Use case**: Default index type, ideal for equality (`=`), range (`<`, `>`, `BETWEEN`), and sorting (`ORDER BY`).
- **Structure**: Balanced tree, efficient for most queries.

**Example 1: B-tree on Numeric Column**

```sql
CREATE INDEX idx_orders_total ON orders(total_amount);

EXPLAIN ANALYZE SELECT * FROM orders WHERE total_amount BETWEEN 100 AND 500;
```

**Explanation**: The B-tree index efficiently handles range queries on `total_amount`.

**Example 2: B-tree on Date Column**

```sql
CREATE INDEX idx_orders_date ON orders(order_date);

EXPLAIN ANALYZE SELECT * FROM orders WHERE order_date = '2025-07-01';
```

**Explanation**: B-tree indexes are effective for exact matches on dates.

**Example 3: B-tree for Sorting**

```sql
CREATE INDEX idx_customers_name ON customers(name);

EXPLAIN ANALYZE SELECT name FROM customers ORDER BY name;
```

**Explanation**: B-tree indexes support efficient sorting operations.

**Example 4: B-tree for Inequality**

```sql
CREATE INDEX idx_products_price ON products(price);

EXPLAIN ANALYZE SELECT * FROM products WHERE price > 200;
```

**Explanation**: B-tree handles inequality comparisons efficiently.

**Example 5: Multi-column B-tree**

```sql
CREATE INDEX idx_customers_city_name ON customers(city, name);

EXPLAIN ANALYZE SELECT * FROM customers WHERE city = 'Chicago' AND name LIKE 'A%';
```

**Explanation**: Multi-column B-tree indexes optimize queries with multiple conditions.

### Hash Index
- **Use case**: Only for equality comparisons (`=`). Less common, as B-tree often suffices.
- **Structure**: Uses a hash function to map values to index entries.

**Example 1: Hash Index on Status**

```sql
CREATE INDEX idx_orders_status_hash ON orders USING HASH (status);

EXPLAIN ANALYZE SELECT * FROM orders WHERE status = 'Delivered';
```

**Explanation**: Hash indexes are fast for exact equality matches but don’t support range queries.

**Example 2: Hash on Product Code**

```sql
CREATE INDEX idx_products_code_hash ON products USING HASH (product_code);

EXPLAIN ANALYZE SELECT * FROM products WHERE product_code = 'P123';
```

**Explanation**: Hash indexes are efficient for unique code lookups.

**Example 3: Hash on Boolean**

```sql
CREATE INDEX idx_customers_active_hash ON customers USING HASH (active);

EXPLAIN ANALYZE SELECT * FROM customers WHERE active = true;
```

**Explanation**: Hash indexes work well for boolean columns with equality checks.

**Example 4: Hash on Email**

```sql
CREATE INDEX idx_employees_email_hash ON employees USING HASH (email);

EXPLAIN ANALYZE SELECT * FROM employees WHERE email = 'john.doe@example.com';
```

**Explanation**: Hash indexes provide fast lookups for unique identifiers like email.

**Example 5: Hash on Category**

```sql
CREATE INDEX idx_products_category_hash ON products USING HASH (category_id);

EXPLAIN ANALYZE SELECT * FROM products WHERE category_id = 1;
```

**Explanation**: Hash indexes are suitable for foreign key equality checks.

### GIN Index
- **Use case**: Ideal for composite data types like arrays, JSONB, or full-text search.
- **Structure**: Generalized Inverted Index, efficient for searching within arrays or documents.

**Example 1: GIN on Tags Array**

```sql
CREATE INDEX idx_products_tags ON products USING GIN (tags);

EXPLAIN ANALYZE SELECT * FROM products WHERE tags @> ARRAY['tech'];
```

**Explanation**: GIN indexes excel at searching for elements within arrays.

**Example 2: GIN for Full-Text Search**

```sql
CREATE INDEX idx_products_description ON products USING GIN (to_tsvector('english', description));

EXPLAIN ANALYZE SELECT * FROM products WHERE to_tsvector('english', description) @@ to_tsquery('quality');
```

**Explanation**: GIN supports full-text search queries.

**Example 3: GIN on JSONB**

```sql
ALTER TABLE products ADD COLUMN metadata JSONB;
CREATE INDEX idx_products_metadata ON products USING GIN (metadata);

EXPLAIN ANALYZE SELECT * FROM products WHERE metadata @> '{"color": "blue"}';
```

**Explanation**: GIN indexes optimize JSONB queries for specific key-value pairs.

**Example 4: GIN on Multiple Tags**

```sql
EXPLAIN ANALYZE SELECT * FROM products WHERE tags @> ARRAY['tech', 'smart'];
```

**Explanation**: GIN handles queries searching for multiple array elements.

**Example 5: GIN with Trigram**

```sql
CREATE EXTENSION IF NOT EXISTS pg_trgm;
CREATE INDEX idx_products_name_trgm ON products USING GIN (product_name gin_trgm_ops);

EXPLAIN ANALYZE SELECT * FROM products WHERE product_name LIKE '%Laptop%';
```

**Explanation**: GIN with `pg_trgm` supports pattern matching for `LIKE` queries with wildcards.

### BRIN Index
- **Use case**: For large tables with naturally ordered data (e.g., timestamps).
- **Structure**: Block Range Index, stores summaries of data ranges.

**Example 1: BRIN on Timestamps**

```sql
CREATE INDEX idx_orders_log_created_brin ON orders_log USING BRIN (created_at);

EXPLAIN ANALYZE SELECT * FROM orders_log WHERE created_at BETWEEN '2025-01-01' AND '2025-01-31';
```

**Explanation**: BRIN indexes are efficient for large, ordered datasets like logs.

**Example 2: BRIN on Sequential IDs**

```sql
CREATE INDEX idx_orders_log_id_brin ON orders_log USING BRIN (log_id);

EXPLAIN ANALYZE SELECT * FROM orders_log WHERE log_id > 90000;
```

**Explanation**: BRIN works well for sequentially increasing IDs.

**Example 3: BRIN on Order Dates**

```sql
CREATE INDEX idx_orders_date_brin ON orders USING BRIN (order_date);

EXPLAIN ANALYZE SELECT * FROM orders WHERE order_date > '2025-01-01';
```

**Explanation**: BRIN is lightweight and effective for date ranges.

**Example 4: BRIN on Large Product Table**

```sql
CREATE INDEX idx_products_id_brin ON products USING BRIN (product_id);

EXPLAIN ANALYZE SELECT * FROM products WHERE product_id > 500;
```

**Explanation**: BRIN reduces index size for large tables with sequential data.

**Example 5: BRIN on Creation Timestamps**

```sql
CREATE INDEX idx_customers_created_brin ON customers USING BRIN (created_at);

EXPLAIN ANALYZE SELECT * FROM customers WHERE created_at > '2024-01-01';
```

**Explanation**: BRIN is ideal for timestamp-based range queries on large tables.

---

## Creating and Managing Indexes

Creating and managing indexes involves defining indexes on appropriate columns and maintaining them to ensure optimal performance.

### Example 1: Simple Index Creation

```sql
CREATE INDEX idx_customers_email ON customers(email);

EXPLAIN ANALYZE SELECT * FROM customers WHERE email = 'john.smith1@gmail.com';
```

**Explanation**: A simple B-tree index on `email` speeds up exact match queries.

### Example 2: Dropping an Index

```sql
DROP INDEX IF EXISTS idx_customers_email;

EXPLAIN ANALYZE SELECT * FROM customers WHERE email = 'john.smith1@gmail.com';
```

**Explanation**: Dropping an unused index reduces maintenance overhead but may slow queries.

### Example 3: Recreating an Index

```sql
REINDEX INDEX idx_customers_city;

EXPLAIN ANALYZE SELECT * FROM customers WHERE city = 'Chicago';
```

**Explanation**: Reindexing rebuilds an index to maintain performance after heavy updates.

### Example 4: Concurrent Index Creation

```sql
CREATE INDEX CONCURRENTLY idx_products_stock ON products(stock_quantity);

EXPLAIN ANALYZE SELECT * FROM products WHERE stock_quantity < 10;
```

**Explanation**: `CONCURRENTLY` allows index creation without locking the table, useful for production databases.

### Example 5: Unique Index with Multiple Columns

```sql
CREATE UNIQUE INDEX idx_products_name_category ON products(product_name, category_id);

EXPLAIN ANALYZE SELECT * FROM products WHERE product_name = 'Laptop Pro' AND category_id = 1;
```

**Explanation**: A unique composite index enforces uniqueness across multiple columns and optimizes queries.

---

## Query Analysis with EXPLAIN and EXPLAIN ANALYZE

`EXPLAIN` shows the query execution plan, while `EXPLAIN ANALYZE` executes the query and provides actual performance metrics.

### Example 1: Basic EXPLAIN

```sql
EXPLAIN SELECT * FROM customers WHERE city = 'New York';
```

**Explanation**: Shows the planned execution path without running the query.

### Example 2: EXPLAIN ANALYZE

```sql
EXPLAIN ANALYZE SELECT * FROM customers WHERE city = 'New York';
```

**Explanation**: Executes the query and shows actual execution time and row counts.

### Example 3: Verbose EXPLAIN

```sql
EXPLAIN (ANALYZE, BUFFERS, FORMAT JSON) SELECT * FROM customers WHERE city = 'New York';
```

**Explanation**: Provides detailed output, including buffer usage, in JSON format.

### Example 4: Comparing Query Plans

```sql
-- Without index
EXPLAIN ANALYZE SELECT * FROM orders WHERE customer_id = 100;

-- Create index
CREATE INDEX idx_orders_cust ON orders(customer_id);

-- With index
EXPLAIN ANALYZE SELECT * FROM orders WHERE customer_id = 100;
```

**Explanation**: Compares sequential scan vs. index scan performance.

### Example 5: Analyzing Joins

```sql
EXPLAIN ANALYZE
SELECT c.name, o.order_id
FROM customers c
JOIN orders o ON c.customer_id = o.customer_id
WHERE c.city = 'Chicago';
```

**Explanation**: Analyzes the performance of a join operation, showing how indexes affect join efficiency.

---

## Query Optimization Techniques

Optimizing queries involves choosing the right indexes, rewriting queries, and understanding query patterns.

### Example 1: Rewrite LIKE to Equality

```sql
-- Inefficient: LIKE with leading wildcard
EXPLAIN ANALYZE SELECT * FROM products WHERE product_name LIKE '%Laptop%';

-- Rewrite for exact match
EXPLAIN ANALYZE SELECT * FROM products WHERE product_name = 'Laptop Pro';
```

**Explanation**: Equality checks are more index-friendly than `LIKE` with leading wildcards.

### Example 2: Use Composite Index for Joins

```sql
CREATE INDEX idx_orders_cust_date ON orders(customer_id, order_date);

EXPLAIN ANALYZE
SELECT o.order_id, c.name
FROM orders o
JOIN customers c ON o.customer_id = c.customer_id
WHERE o.order_date > '2025-01-01';
```

**Explanation**: A composite index optimizes queries involving multiple conditions.

### Example 3: Avoid Functions on Indexed Columns

```sql
-- Inefficient: Function prevents index usage
EXPLAIN ANALYZE SELECT * FROM customers WHERE LOWER(city) = 'new york';

-- Rewrite to use indexed column
EXPLAIN ANALYZE SELECT * FROM customers WHERE city = 'New York';
```

**Explanation**: Functions on columns in predicates prevent index usage unless a functional index exists.

### Example 4: Use Index-Only Scans

```sql
CREATE INDEX idx_customers_city_name_id ON customers(city, name, customer_id);

EXPLAIN ANALYZE SELECT city, name, customer_id FROM customers WHERE city = 'Chicago';
```

**Explanation**: Index-only scans retrieve data directly from the index, avoiding table access.

### Example 5: Optimize Array Searches

```sql
CREATE INDEX idx_products_tags_gin ON products USING GIN (tags);

EXPLAIN ANALYZE SELECT * FROM products WHERE tags @> ARRAY['tech', 'smart'];
```

**Explanation**: GIN indexes optimize searches within arrays, common in tag-based systems.

---

## Index Maintenance

Maintaining indexes ensures they remain efficient and don’t consume unnecessary resources.

### Example 1: List All Indexes

```sql
SELECT indexname, indexdef
FROM pg_indexes
WHERE tablename = 'customers'
ORDER BY indexname;
```

**Explanation**: Lists all indexes on the `customers` table for review.

### Example 2: Check Index Sizes

```sql
SELECT
    pg_size_pretty(pg_relation_size(indexname::text)) as index_size,
    indexname
FROM pg_indexes
WHERE tablename = 'customers'
ORDER BY pg_relation_size(indexname::text) DESC;
```

**Explanation**: Identifies storage usage to detect oversized indexes.

### Example 3: Index Usage Statistics

```sql
SELECT
    s.indexrelname AS indexname,
    pg_size_pretty(pg_relation_size(s.indexrelid)) AS index_size,
    idx_scan AS scans
FROM pg_stat_user_indexes s
WHERE s.relname = 'customers'
ORDER BY scans DESC;
```

**Explanation**: Shows how often indexes are used to identify unused ones.

### Example 4: Rebuild Index

```sql
REINDEX INDEX idx_customers_city;
```

**Explanation**: Rebuilds an index to optimize performance after heavy updates.

### Example 5: Drop Unused Index

```sql
DROP INDEX IF EXISTS idx_products_stock;
```

**Explanation**: Removes unused indexes to reduce maintenance overhead.

---

## Partial Indexes

Partial indexes only index a subset of rows based on a condition, reducing index size and maintenance.

### Example 1: Index Active Customers

```sql
CREATE INDEX idx_customers_active ON customers(customer_id) WHERE active = true;

EXPLAIN ANALYZE SELECT * FROM customers WHERE active = true AND customer_id < 1000;
```

**Explanation**: Indexes only active customers, reducing index size.

### Example 2: Index Recent Orders

```sql
CREATE INDEX idx_orders_recent ON orders(order_id)
WHERE order_date > current_date - INTERVAL '30 days';

EXPLAIN ANALYZE SELECT * FROM orders WHERE order_date > current_date - INTERVAL '15 days';
(ticket: INTERVAL '30 days';
```

**Explanation**: Optimizes queries for recent orders with a smaller index.

### Example 3: Index High-Value Orders

```sql
CREATE INDEX idx_high_value_orders ON orders(total_amount)
WHERE total_amount > 500;

EXPLAIN ANALYZE SELECT * FROM orders WHERE total_amount > 500;
```

**Explanation**: Indexes only high-value orders, improving performance.

### Example 4: Index Specific Status

```sql
CREATE INDEX idx_orders_pending ON orders(order_id) WHERE status = 'Pending';

EXPLAIN ANALYZE SELECT * FROM orders WHERE status = 'Pending';
```

**Explanation**: Targets specific order statuses for efficiency.

### Example 5: Index Recent Customers

```sql
CREATE INDEX idx_customers_recent ON customers(created_at)
WHERE created_at > current_date - INTERVAL '90 days';

EXPLAIN ANALYZE SELECT * FROM customers WHERE created_at > current_date - INTERVAL '60 days';
```

**Explanation**: Indexes recently added customers, reducing index size.

---

## Functional Indexes

Functional indexes index the result of a function on a column, enabling efficient queries on transformed data.

### Example 1: Case-Insensitive Search

```sql
CREATE INDEX idx_customers_name_lower ON customers(LOWER(name));

EXPLAIN ANALYZE SELECT * FROM customers WHERE LOWER(name) = 'john doe';
```

**Explanation**: Enables case-insensitive searches using an index.

### Example 2: Year Extraction

```sql
CREATE INDEX idx_customers_birth_year ON customers(EXTRACT(YEAR FROM date_of_birth));

EXPLAIN ANALYZE SELECT * FROM customers WHERE EXTRACT(YEAR FROM date_of_birth) = 1990;
```

**Explanation**: Indexes the year of birth for efficient queries.

### Example 3: Truncated Email

```sql
CREATE INDEX idx_employees_email_prefix ON employees(LEFT(email, 10));

EXPLAIN ANALYZE SELECT * FROM employees WHERE LEFT(email, 10) = 'john.smith';
```

**Explanation**: Indexes the first 10 characters of email for prefix searches.

### Example 4: Concatenated Names

```sql
CREATE INDEX idx_customers_full_name ON customers(LOWER(first_name || ' ' || last_name));

EXPLAIN ANALYZE SELECT * FROM customers WHERE LOWER(first_name || ' ' || last_name) = 'john smith';
```

**Explanation**: Indexes concatenated names for full-name searches.

### Example 5: Date Truncation

```sql
CREATE INDEX idx_orders_month ON orders(date_trunc('month', order_date));

EXPLAIN ANALYZE SELECT * FROM orders WHERE date_trunc('month', order_date) = '2025-07-01';
```

**Explanation**: Indexes truncated dates for monthly aggregations.

---

## Summary

Indexes are critical for optimizing PostgreSQL query performance but require careful management:
- **B-tree**: Default choice for equality and range queries.
- **Hash**: For simple equality checks.
- **GIN**: For arrays, JSONB, and full-text search.
- **BRIN**: For large, ordered datasets.
- **Partial Indexes**: Reduce size by indexing specific rows.
- **Functional Indexes**: Optimize queries on transformed data.
- **Maintenance**: Monitor size, usage, and rebuild as needed.
- **EXPLAIN ANALYZE**: Essential for understanding query performance.

Always analyze query patterns with `EXPLAIN ANALYZE` to choose the right indexes, and regularly review index usage to avoid unnecessary overhead.

## Exercises

The `exercises.sql` file contains practical exercises to apply these concepts:
1. Analyze query performance without indexes.
2. Create indexes to improve performance.
3. Re-analyze queries to compare performance.
4. Create composite indexes for multi-column queries.
5. Create partial indexes for specific conditions.
6. Create functional indexes for transformed data.
7. Analyze index sizes and usage statistics.

