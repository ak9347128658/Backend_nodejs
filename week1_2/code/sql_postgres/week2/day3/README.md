# Day 3: Indexes and Query Optimization

## Topics Covered

1. Understanding PostgreSQL indexes
2. Types of indexes (B-tree, Hash, GiST, GIN, BRIN)
3. Creating and managing indexes
4. Query analysis with EXPLAIN and EXPLAIN ANALYZE
5. Query optimization techniques
6. Index maintenance

## Examples and Exercises

### Example 1: Index Basics

```sql
-- Create a sample table for testing indexes
CREATE TABLE users (
    user_id SERIAL PRIMARY KEY,
    username VARCHAR(50) UNIQUE,
    email VARCHAR(100) UNIQUE,
    first_name VARCHAR(50),
    last_name VARCHAR(50),
    date_of_birth DATE,
    created_at TIMESTAMP DEFAULT current_timestamp,
    last_login TIMESTAMP,
    active BOOLEAN DEFAULT true
);

-- Generate test data: 100,000 users
-- This is a simplified example - in a real scenario, use a proper data generation tool
DO $$
DECLARE
    i INTEGER;
    domains TEXT[] := ARRAY['gmail.com', 'yahoo.com', 'hotmail.com', 'outlook.com', 'example.com'];
    domain TEXT;
    first_names TEXT[] := ARRAY['John', 'Jane', 'Michael', 'Emily', 'David', 'Sarah', 'Robert', 'Jennifer', 'William', 'Elizabeth'];
    last_names TEXT[] := ARRAY['Smith', 'Johnson', 'Williams', 'Jones', 'Brown', 'Davis', 'Miller', 'Wilson', 'Moore', 'Taylor'];
    first_name TEXT;
    last_name TEXT;
BEGIN
    FOR i IN 1..100000 LOOP
        -- Select random names and domain
        first_name := first_names[1 + floor(random() * array_length(first_names, 1))];
        last_name := last_names[1 + floor(random() * array_length(last_names, 1))];
        domain := domains[1 + floor(random() * array_length(domains, 1))];
        
        -- Insert user with generated data
        INSERT INTO users (
            username, 
            email, 
            first_name, 
            last_name, 
            date_of_birth,
            last_login,
            active
        ) VALUES (
            lower(first_name || last_name || i),
            lower(first_name || '.' || last_name || i || '@' || domain),
            first_name,
            last_name,
            '1950-01-01'::DATE + (random() * (current_date - '1950-01-01'::DATE))::INTEGER,
            current_timestamp - (random() * 365 * '1 day'::INTERVAL),
            random() > 0.1  -- 90% active
        );
    END LOOP;
END$$;

-- Check the table size
SELECT pg_size_pretty(pg_total_relation_size('users')) AS users_table_size;

-- Run a query without an index
EXPLAIN ANALYZE SELECT * FROM users WHERE email LIKE '%gmail.com';

-- Create an index on email
CREATE INDEX idx_users_email ON users(email);

-- Run the query again with an index
EXPLAIN ANALYZE SELECT * FROM users WHERE email LIKE '%gmail.com';

-- Note: LIKE '%something' (pattern starts with wildcard) cannot use traditional B-tree indexes efficiently
-- Let's try a query that can use the index
EXPLAIN ANALYZE SELECT * FROM users WHERE email LIKE 'john.smith%';

-- Let's try a full text search index for better pattern matching
-- Create a specialized index for text pattern matching
CREATE INDEX idx_users_email_pattern ON users USING gin (email gin_trgm_ops);

-- Need to enable the pg_trgm extension first
CREATE EXTENSION IF NOT EXISTS pg_trgm;

-- Recreate the specialized index
CREATE INDEX idx_users_email_pattern ON users USING gin (email gin_trgm_ops);

-- Run the query again
EXPLAIN ANALYZE SELECT * FROM users WHERE email LIKE '%gmail.com';
```

### Example 2: Different Index Types

```sql
-- B-tree index (default) - good for equality and range queries
CREATE INDEX idx_users_dob ON users(date_of_birth);

-- Hash index - good only for equality comparisons
CREATE INDEX idx_users_active_hash ON users USING HASH (active);

-- GIN index - good for composite values like arrays, jsonb
-- Let's add a column that stores arrays
ALTER TABLE users ADD COLUMN interests TEXT[];

-- Update some users with interests
UPDATE users SET interests = ARRAY['sports', 'music', 'travel'] WHERE user_id % 5 = 0;
UPDATE users SET interests = ARRAY['reading', 'cooking', 'movies'] WHERE user_id % 5 = 1;
UPDATE users SET interests = ARRAY['technology', 'gaming', 'science'] WHERE user_id % 5 = 2;
UPDATE users SET interests = ARRAY['art', 'photography', 'fashion'] WHERE user_id % 5 = 3;
UPDATE users SET interests = ARRAY['fitness', 'health', 'outdoors'] WHERE user_id % 5 = 4;

-- Create GIN index for array column
CREATE INDEX idx_users_interests ON users USING GIN (interests);

-- Query that uses the GIN index
EXPLAIN ANALYZE SELECT * FROM users WHERE interests @> ARRAY['music'];

-- BRIN index - good for very large tables with natural ordering
CREATE INDEX idx_users_created_at_brin ON users USING BRIN (created_at);

-- Query that might use the BRIN index
EXPLAIN ANALYZE SELECT * FROM users 
WHERE created_at BETWEEN '2023-01-01' AND '2023-01-31';
```

### Example 3: Composite Indexes and Index-Only Scans

```sql
-- Create a composite index on last_name, first_name
CREATE INDEX idx_users_name ON users(last_name, first_name);

-- Query using both columns
EXPLAIN ANALYZE SELECT * FROM users 
WHERE last_name = 'Smith' AND first_name = 'John';

-- Query using only the first column of the index
EXPLAIN ANALYZE SELECT * FROM users WHERE last_name = 'Smith';

-- Query using only the second column (won't use the index efficiently)
EXPLAIN ANALYZE SELECT * FROM users WHERE first_name = 'John';

-- Create an index to support index-only scans
CREATE INDEX idx_users_name_id ON users(last_name, first_name, user_id);

-- Query that can use index-only scan
EXPLAIN ANALYZE SELECT last_name, first_name, user_id 
FROM users WHERE last_name = 'Smith';
```

### Example 4: EXPLAIN and EXPLAIN ANALYZE

```sql
-- Basic EXPLAIN (shows the query plan without executing the query)
EXPLAIN SELECT * FROM users WHERE email = 'john.smith1@gmail.com';

-- EXPLAIN ANALYZE (executes the query and shows actual timing)
EXPLAIN ANALYZE SELECT * FROM users WHERE email = 'john.smith1@gmail.com';

-- EXPLAIN with more verbose output
EXPLAIN (ANALYZE, BUFFERS, FORMAT JSON) 
SELECT * FROM users WHERE email = 'john.smith1@gmail.com';

-- Compare different query approaches
-- Approach 1: Using LIKE
EXPLAIN ANALYZE SELECT * FROM users 
WHERE email LIKE 'john.smith%';

-- Approach 2: Using regular expression
EXPLAIN ANALYZE SELECT * FROM users 
WHERE email ~ '^john\.smith';

-- Approach 3: Using equality check with string concatenation
EXPLAIN ANALYZE SELECT * FROM users 
WHERE left(email, 11) = 'john.smith';
```

### Example 5: Index Maintenance

```sql
-- List all indexes in the database
SELECT
    indexname,
    indexdef
FROM
    pg_indexes
WHERE
    tablename = 'users'
ORDER BY
    indexname;

-- Get index size information
SELECT
    pg_size_pretty(pg_relation_size(indexname::text)) as index_size,
    indexname
FROM
    pg_indexes
WHERE
    tablename = 'users'
ORDER BY
    pg_relation_size(indexname::text) DESC;

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
    s.relname = 'users'
ORDER BY
    scans DESC;

-- Rebuild an index
REINDEX INDEX idx_users_email;

-- Drop unused indexes (be careful!)
DROP INDEX IF EXISTS idx_users_email_pattern;
```

## Summary

Indexes are essential for database performance optimization. PostgreSQL offers various index types tailored for different query patterns. The key concepts to remember are:

1. B-tree indexes are the default and work well for most cases, especially equality and range queries
2. Specialized indexes like GIN, GiST, and BRIN serve specific use cases
3. Use EXPLAIN ANALYZE to understand query execution plans
4. Create indexes based on your actual query patterns
5. Monitor and maintain your indexes regularly
6. Not all indexes improve performance - they add overhead to writes

For best performance:
- Index columns used in WHERE, JOIN, and ORDER BY clauses
- Consider composite indexes for multi-column conditions
- Use appropriate index types for different data types and query patterns
- Regularly monitor index usage and size
- Remove unused indexes to reduce write overhead

## Exercises

See the [exercises.sql](exercises.sql) file for practice problems related to indexes and query optimization.
