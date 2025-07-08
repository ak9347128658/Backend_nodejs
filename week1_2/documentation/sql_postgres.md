````markdown
# SQL & PostgreSQL - Comprehensive Guide

This document provides a complete day-by-day guide to SQL and PostgreSQL, covering fundamental concepts to advanced topics with detailed examples, diagrams, and practice questions.

## Day 1: Introduction to Databases and SQL

### What is a Database?

A database is an organized collection of structured information or data, typically stored electronically in a computer system. Databases are designed to efficiently store, retrieve, manage, and manipulate data.

### Types of Databases

1. **Relational Databases**: Organize data in tables with rows and columns (e.g., PostgreSQL, MySQL, Oracle)
2. **NoSQL Databases**: Store data in non-tabular formats (e.g., MongoDB, Cassandra)
3. **Object-Oriented Databases**: Store data as objects (e.g., ObjectDB)
4. **Graph Databases**: Focus on relationships between data points (e.g., Neo4j)
5. **Time-Series Databases**: Optimized for time-stamped data (e.g., InfluxDB)

### What is SQL?

SQL (Structured Query Language) is a standard programming language designed for managing and manipulating data in relational database management systems (RDBMS).

### What is PostgreSQL?

PostgreSQL is an open-source, advanced object-relational database system that extends the SQL language with many features that safely store and scale complicated data workloads.

### Database Architecture Diagram

```
+---------------------+
|    Client Apps      |
| (Applications/Users)|
+----------+----------+
           |
           v
+----------+----------+
|  Database Server    |
| (PostgreSQL)        |
+----------+----------+
           |
           v
+----------+----------+
|   Storage Layer     |
| (Tables, Indexes)   |
+---------------------+
```

### Setting Up PostgreSQL

#### Installation (Windows)

1. Download the installer from the [official PostgreSQL website](https://www.postgresql.org/download/windows/)
2. Run the installer and follow the setup wizard
3. Set a password for the default 'postgres' user
4. Select the components to install (PostgreSQL Server, pgAdmin, etc.)
5. Choose a port (default is 5432)

#### Example 1: Connecting to PostgreSQL

```sql
-- Using psql command line
psql -U postgres -h localhost

-- Connection string format
postgresql://username:password@hostname:port/database
```

#### Example 2: Creating Your First Database

```sql
-- Create a new database
CREATE DATABASE my_first_db;

-- Connect to the database
\c my_first_db

-- Verify connection
SELECT current_database();
```

#### Example 3: Basic Database Operations

```sql
-- Create a database
CREATE DATABASE bookstore;

-- Drop a database (delete)
DROP DATABASE IF EXISTS old_database;

-- List all databases
\l

-- Connect to a database
\c bookstore
```

#### Example 4: User Management

```sql
-- Create a new user
CREATE USER reader WITH PASSWORD 'secure_password';

-- Grant privileges
GRANT CONNECT ON DATABASE bookstore TO reader;
GRANT SELECT ON ALL TABLES IN SCHEMA public TO reader;

-- List all users
\du
```

#### Example 5: Database Information

```sql
-- Show database version
SELECT version();

-- List schemas
\dn

-- Show database size
SELECT pg_size_pretty(pg_database_size(current_database()));

-- Show all tables in current database
\dt
```

## Day 2: Data Types and Table Creation

### Common PostgreSQL Data Types

1. **Numeric Types**: INTEGER, BIGINT, NUMERIC, REAL, DOUBLE PRECISION
2. **Character Types**: CHAR(n), VARCHAR(n), TEXT
3. **Date/Time Types**: DATE, TIME, TIMESTAMP, INTERVAL
4. **Boolean Type**: BOOLEAN (true/false)
5. **Binary Data Types**: BYTEA
6. **JSON Types**: JSON, JSONB
7. **Arrays**: Any data type can be used as an array
8. **Special Types**: UUID, CIDR, INET, MACADDR

### Creating Tables

The CREATE TABLE statement is used to create a new table in a database.

#### Table Structure Diagram

```
+------------------+
| TABLE            |
+------------------+
| column1 datatype |
| column2 datatype |
| column3 datatype |
| ...              |
+------------------+
```

#### Example 1: Basic Table Creation

```sql
CREATE TABLE employees (
    employee_id SERIAL PRIMARY KEY,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    email VARCHAR(100) UNIQUE,
    hire_date DATE,
    salary NUMERIC(10, 2)
);
```

#### Example 2: Table with Constraints

```sql
CREATE TABLE products (
    product_id SERIAL PRIMARY KEY,
    product_name VARCHAR(100) NOT NULL,
    category VARCHAR(50) CHECK (category IN ('Electronics', 'Clothing', 'Books', 'Home', 'Other')),
    price NUMERIC(10, 2) CHECK (price > 0),
    stock_quantity INTEGER DEFAULT 0,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
```

#### Example 3: Table with Foreign Key

```sql
CREATE TABLE orders (
    order_id SERIAL PRIMARY KEY,
    customer_id INTEGER REFERENCES customers(customer_id),
    order_date DATE DEFAULT CURRENT_DATE,
    total_amount NUMERIC(12, 2),
    status VARCHAR(20) DEFAULT 'Pending'
);
```

#### Example 4: Creating a Table with a Composite Key

```sql
CREATE TABLE enrollment (
    student_id INTEGER,
    course_id INTEGER,
    enrollment_date DATE,
    grade CHAR(1),
    PRIMARY KEY (student_id, course_id)
);
```

#### Example 5: Table with UUID and JSON

```sql
CREATE TABLE user_profiles (
    user_id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    username VARCHAR(50) UNIQUE NOT NULL,
    preferences JSONB,
    last_login TIMESTAMP,
    active BOOLEAN DEFAULT TRUE
);
```

### Modifying Tables

#### Example: Altering Tables

```sql
-- Add a column
ALTER TABLE employees ADD COLUMN department VARCHAR(50);

-- Modify a column
ALTER TABLE employees ALTER COLUMN email TYPE VARCHAR(150);

-- Add a constraint
ALTER TABLE employees ADD CONSTRAINT unique_email UNIQUE (email);

-- Drop a column
ALTER TABLE employees DROP COLUMN department;

-- Rename a table
ALTER TABLE employees RENAME TO staff;
```

## Day 3: Data Manipulation - INSERT, UPDATE, DELETE

### Inserting Data

The INSERT statement is used to add new rows to a table.

#### Example 1: Basic Insert

```sql
INSERT INTO employees (first_name, last_name, email, hire_date, salary)
VALUES ('John', 'Doe', 'john.doe@example.com', '2023-01-15', 75000);
```

#### Example 2: Multiple Row Insert

```sql
INSERT INTO products (product_name, category, price, stock_quantity)
VALUES 
    ('Smartphone', 'Electronics', 699.99, 50),
    ('T-shirt', 'Clothing', 19.99, 200),
    ('Coffee Mug', 'Home', 9.99, 100);
```

#### Example 3: Insert with Default Values

```sql
INSERT INTO orders (customer_id, total_amount)
VALUES (1001, 125.50);
-- order_date will use CURRENT_DATE, status will be 'Pending'
```

#### Example 4: Insert with Sub-query

```sql
INSERT INTO customer_archive
SELECT * FROM customers
WHERE last_order_date < '2022-01-01';
```

#### Example 5: Insert with Returning Clause

```sql
INSERT INTO employees (first_name, last_name, email)
VALUES ('Jane', 'Smith', 'jane.smith@example.com')
RETURNING employee_id, first_name, last_name;
```

### Updating Data

The UPDATE statement is used to modify existing records in a table.

#### Example 1: Basic Update

```sql
UPDATE employees
SET salary = 80000
WHERE employee_id = 101;
```

#### Example 2: Update Multiple Columns

```sql
UPDATE products
SET price = price * 1.1, 
    stock_quantity = stock_quantity - 5
WHERE category = 'Electronics';
```

#### Example 3: Update with Calculated Values

```sql
UPDATE orders
SET total_amount = (SELECT SUM(price * quantity) FROM order_items WHERE order_items.order_id = orders.order_id)
WHERE order_id = 5001;
```

#### Example 4: Update with Case Expression

```sql
UPDATE employees
SET salary = CASE
    WHEN hire_date < '2020-01-01' THEN salary * 1.15
    WHEN hire_date < '2022-01-01' THEN salary * 1.1
    ELSE salary * 1.05
END;
```

#### Example 5: Update with Returning Clause

```sql
UPDATE products
SET stock_quantity = 0
WHERE expired_date < CURRENT_DATE
RETURNING product_id, product_name, stock_quantity;
```

### Deleting Data

The DELETE statement is used to remove records from a table.

#### Example 1: Basic Delete

```sql
DELETE FROM customers
WHERE customer_id = 1005;
```

#### Example 2: Delete with Condition

```sql
DELETE FROM products
WHERE stock_quantity = 0 AND last_ordered < CURRENT_DATE - INTERVAL '1 year';
```

#### Example 3: Delete with Sub-query

```sql
DELETE FROM orders
WHERE customer_id IN (
    SELECT customer_id FROM customers
    WHERE account_status = 'Inactive'
);
```

#### Example 4: Delete All Rows

```sql
DELETE FROM temp_logs;
-- Deletes all rows but maintains table structure
```

#### Example 5: Delete with Returning Clause

```sql
DELETE FROM employees
WHERE department = 'Marketing'
RETURNING employee_id, first_name, last_name;
```

## Day 4: Querying Data - SELECT and WHERE

### Basic SELECT Statements

The SELECT statement is used to retrieve data from a database.

#### Example 1: Select All Columns

```sql
SELECT * FROM employees;
```

#### Example 2: Select Specific Columns

```sql
SELECT first_name, last_name, email FROM employees;
```

#### Example 3: Select with Column Alias

```sql
SELECT 
    product_name AS "Product",
    price AS "Retail Price",
    price * 0.8 AS "Sale Price"
FROM products;
```

#### Example 4: Select Distinct Values

```sql
SELECT DISTINCT category FROM products;
```

#### Example 5: Select with Calculated Fields

```sql
SELECT 
    first_name,
    last_name,
    salary,
    salary * 0.1 AS bonus,
    salary * 1.1 AS "Salary After Raise"
FROM employees;
```

### Filtering Data with WHERE

The WHERE clause is used to filter records.

#### Example 1: Simple Comparison

```sql
SELECT * FROM products
WHERE price > 100;
```

#### Example 2: Multiple Conditions

```sql
SELECT * FROM employees
WHERE department = 'IT' AND salary > 70000;
```

#### Example 3: IN Operator

```sql
SELECT * FROM orders
WHERE status IN ('Shipped', 'Delivered');
```

#### Example 4: BETWEEN Operator

```sql
SELECT * FROM employees
WHERE hire_date BETWEEN '2022-01-01' AND '2022-12-31';
```

#### Example 5: Pattern Matching with LIKE

```sql
SELECT * FROM customers
WHERE email LIKE '%gmail.com';
```

### Sorting Data with ORDER BY

#### Example: Sorting Results

```sql
-- Sort in ascending order (default)
SELECT * FROM products
ORDER BY price;

-- Sort in descending order
SELECT * FROM employees
ORDER BY salary DESC;

-- Multiple sort criteria
SELECT * FROM orders
ORDER BY order_date DESC, total_amount DESC;
```

## Day 5: Advanced Querying - Joins

### Types of Joins

1. **INNER JOIN**: Returns records with matching values in both tables
2. **LEFT JOIN**: Returns all records from the left table and matched records from the right table
3. **RIGHT JOIN**: Returns all records from the right table and matched records from the left table
4. **FULL JOIN**: Returns all records when there is a match in either left or right table

### Join Diagram

```
INNER JOIN              LEFT JOIN               RIGHT JOIN              FULL JOIN
+-------+-------+      +-------+-------+      +-------+-------+      +-------+-------+
|   A   |   B   |      |   A   |   B   |      |   A   |   B   |      |   A   |   B   |
+-------+-------+      +-------+-------+      +-------+-------+      +-------+-------+
```

#### Example 1: Inner Join

```sql
SELECT o.order_id, c.customer_name, o.order_date, o.total_amount
FROM orders o
INNER JOIN customers c ON o.customer_id = c.customer_id;
```

#### Example 2: Left Join

```sql
SELECT e.employee_id, e.first_name, e.last_name, d.department_name
FROM employees e
LEFT JOIN departments d ON e.department_id = d.department_id;
```

#### Example 3: Right Join

```sql
SELECT p.product_name, c.category_name, p.price
FROM products p
RIGHT JOIN categories c ON p.category_id = c.category_id;
```

#### Example 4: Full Join

```sql
SELECT s.student_name, c.course_name
FROM students s
FULL JOIN enrollments e ON s.student_id = e.student_id
FULL JOIN courses c ON e.course_id = c.course_id;
```

#### Example 5: Self Join

```sql
SELECT e.first_name AS "Employee", m.first_name AS "Manager"
FROM employees e
LEFT JOIN employees m ON e.manager_id = m.employee_id;
```

## Day 6: Grouping and Aggregations

### Aggregate Functions

1. **COUNT()**: Counts the number of rows
2. **SUM()**: Calculates the sum of values
3. **AVG()**: Calculates the average of values
4. **MIN()**: Finds the minimum value
5. **MAX()**: Finds the maximum value

### GROUP BY Clause

The GROUP BY statement groups rows with the same values into summary rows.

#### Example 1: Basic Grouping

```sql
SELECT department, COUNT(*) AS employee_count
FROM employees
GROUP BY department;
```

#### Example 2: Multiple Group By Columns

```sql
SELECT department, job_title, AVG(salary) AS avg_salary
FROM employees
GROUP BY department, job_title;
```

#### Example 3: Grouping with Having Clause

```sql
SELECT category, COUNT(*) AS product_count
FROM products
GROUP BY category
HAVING COUNT(*) > 10;
```

#### Example 4: Grouping with Calculation

```sql
SELECT 
    EXTRACT(YEAR FROM order_date) AS year,
    EXTRACT(MONTH FROM order_date) AS month,
    SUM(total_amount) AS monthly_sales
FROM orders
GROUP BY year, month
ORDER BY year, month;
```

#### Example 5: Grouping with Joins

```sql
SELECT c.category_name, AVG(p.price) AS avg_price, COUNT(p.product_id) AS product_count
FROM products p
JOIN categories c ON p.category_id = c.category_id
GROUP BY c.category_name;
```

## Day 7: Subqueries and Common Table Expressions (CTEs)

### Subqueries

A subquery is a query nested inside another query.

#### Example 1: Subquery in WHERE Clause

```sql
SELECT product_name, price
FROM products
WHERE price > (SELECT AVG(price) FROM products);
```

#### Example 2: Subquery in FROM Clause

```sql
SELECT department, avg_salary
FROM (
    SELECT department, AVG(salary) AS avg_salary
    FROM employees
    GROUP BY department
) AS dept_salaries
WHERE avg_salary > 60000;
```

#### Example 3: Subquery with IN

```sql
SELECT customer_name, email
FROM customers
WHERE customer_id IN (
    SELECT DISTINCT customer_id
    FROM orders
    WHERE total_amount > 1000
);
```

#### Example 4: Correlated Subquery

```sql
SELECT e.first_name, e.last_name, e.salary
FROM employees e
WHERE e.salary > (
    SELECT AVG(salary)
    FROM employees
    WHERE department = e.department
);
```

#### Example 5: Subquery in SELECT Clause

```sql
SELECT 
    product_name,
    price,
    (SELECT AVG(price) FROM products) AS avg_price,
    price - (SELECT AVG(price) FROM products) AS price_diff
FROM products;
```

### Common Table Expressions (CTEs)

CTEs provide a way to write auxiliary statements for use in a larger query.

#### Example 1: Basic CTE

```sql
WITH high_value_orders AS (
    SELECT * FROM orders
    WHERE total_amount > 1000
)
SELECT c.customer_name, COUNT(o.order_id) AS order_count
FROM high_value_orders o
JOIN customers c ON o.customer_id = c.customer_id
GROUP BY c.customer_name;
```

#### Example 2: Multiple CTEs

```sql
WITH 
dept_avg AS (
    SELECT department, AVG(salary) AS avg_salary
    FROM employees
    GROUP BY department
),
high_salary_depts AS (
    SELECT department FROM dept_avg
    WHERE avg_salary > 70000
)
SELECT e.* FROM employees e
JOIN high_salary_depts h ON e.department = h.department;
```

#### Example 3: Recursive CTE

```sql
WITH RECURSIVE org_hierarchy AS (
    -- Base case: select the CEO (no manager)
    SELECT employee_id, first_name, last_name, 0 AS level
    FROM employees
    WHERE manager_id IS NULL
    
    UNION ALL
    
    -- Recursive step: select employees and their managers
    SELECT e.employee_id, e.first_name, e.last_name, oh.level + 1
    FROM employees e
    JOIN org_hierarchy oh ON e.manager_id = oh.employee_id
)
SELECT * FROM org_hierarchy
ORDER BY level, last_name;
```

#### Example 4: CTE for Data Analysis

```sql
WITH monthly_sales AS (
    SELECT 
        EXTRACT(YEAR FROM order_date) AS year,
        EXTRACT(MONTH FROM order_date) AS month,
        SUM(total_amount) AS sales
    FROM orders
    GROUP BY year, month
)
SELECT 
    year, 
    month, 
    sales,
    LAG(sales, 1) OVER (ORDER BY year, month) AS prev_month_sales,
    sales - LAG(sales, 1) OVER (ORDER BY year, month) AS growth
FROM monthly_sales
ORDER BY year, month;
```

#### Example 5: CTE with Window Functions

```sql
WITH dept_salaries AS (
    SELECT 
        department,
        employee_id, 
        first_name,
        last_name,
        salary,
        RANK() OVER (PARTITION BY department ORDER BY salary DESC) AS salary_rank
    FROM employees
)
SELECT * FROM dept_salaries
WHERE salary_rank <= 3;
```

## Day 8: Indexes and Performance Optimization

### What are Indexes?

Indexes are special lookup tables that the database search engine can use to speed up data retrieval.

### Types of Indexes

1. **B-tree index**: Default index type, good for equality and range queries
2. **Hash index**: Good for equality comparisons
3. **GiST index**: Generalized Search Tree, good for full-text search
4. **GIN index**: Generalized Inverted Index, good for composite types
5. **BRIN index**: Block Range Index, good for very large tables

### Index Structure Diagram

```
                  Root
                 /    \
                /      \
           Branch      Branch
          /     \     /     \
         /       \   /       \
       Leaf     Leaf Leaf   Leaf
```

#### Example 1: Creating a B-tree Index

```sql
-- Create an index on a single column
CREATE INDEX idx_employees_last_name ON employees(last_name);
```

#### Example 2: Creating a Unique Index

```sql
-- Create a unique index
CREATE UNIQUE INDEX idx_products_sku ON products(sku);
```

#### Example 3: Creating a Composite Index

```sql
-- Create an index on multiple columns
CREATE INDEX idx_orders_customer_date ON orders(customer_id, order_date);
```

#### Example 4: Creating a Partial Index

```sql
-- Create an index on a subset of rows
CREATE INDEX idx_active_users ON users(user_id) WHERE active = TRUE;
```

#### Example 5: Creating a Functional Index

```sql
-- Create an index on an expression
CREATE INDEX idx_lower_email ON customers(LOWER(email));
```

### Query Performance Analysis

#### Example: EXPLAIN ANALYZE

```sql
-- Analyze query execution plan
EXPLAIN ANALYZE
SELECT * FROM orders
WHERE customer_id = 1001 AND order_date > '2023-01-01';
```

## Day 9: Transactions and Concurrency

### What is a Transaction?

A transaction is a unit of work that is performed against a database. Transactions are characterized by four properties, known as ACID:

1. **Atomicity**: All operations complete successfully or none of them do
2. **Consistency**: Database remains in a consistent state before and after transaction
3. **Isolation**: Transactions operate independently of each other
4. **Durability**: Completed transactions persist even in case of system failure

### Transaction Control

#### Example 1: Basic Transaction

```sql
BEGIN;
    UPDATE accounts SET balance = balance - 100 WHERE account_id = 1001;
    UPDATE accounts SET balance = balance + 100 WHERE account_id = 1002;
COMMIT;
```

#### Example 2: Transaction with Rollback

```sql
BEGIN;
    UPDATE inventory SET quantity = quantity - 5 WHERE product_id = 101;
    
    -- Check if quantity is sufficient
    IF (SELECT quantity FROM inventory WHERE product_id = 101) < 0 THEN
        ROLLBACK;
    ELSE
        COMMIT;
    END IF;
```

#### Example 3: Savepoints

```sql
BEGIN;
    UPDATE products SET price = price * 1.1 WHERE category = 'Electronics';
    SAVEPOINT price_update;
    
    DELETE FROM products WHERE stock_quantity = 0;
    
    -- If we decide to keep the zero stock products
    ROLLBACK TO price_update;
    
    -- Continue with other operations
    UPDATE products SET featured = TRUE WHERE price > 1000;
COMMIT;
```

#### Example 4: Transaction Isolation Levels

```sql
-- Set the isolation level for the current transaction
BEGIN;
    SET TRANSACTION ISOLATION LEVEL READ COMMITTED;
    -- Perform operations
COMMIT;
```

#### Example 5: Explicit Locking

```sql
BEGIN;
    -- Lock the rows to prevent concurrent updates
    SELECT * FROM inventory WHERE product_id = 101 FOR UPDATE;
    
    -- Perform updates
    UPDATE inventory SET quantity = quantity - 10 WHERE product_id = 101;
COMMIT;
```

## Day 10: Stored Procedures and Functions

### What are Stored Procedures?

Stored procedures are prepared SQL code that you can save and reuse.

### What are Functions?

Functions are similar to procedures, but they return a value.

#### Example 1: Creating a Simple Function

```sql
CREATE OR REPLACE FUNCTION get_total_sales(start_date DATE, end_date DATE)
RETURNS NUMERIC AS $$
BEGIN
    RETURN (
        SELECT SUM(total_amount)
        FROM orders
        WHERE order_date BETWEEN start_date AND end_date
    );
END;
$$ LANGUAGE plpgsql;

-- Using the function
SELECT get_total_sales('2023-01-01', '2023-01-31');
```

#### Example 2: Table-Returning Function

```sql
CREATE OR REPLACE FUNCTION get_employees_by_dept(dept_name VARCHAR)
RETURNS TABLE (
    employee_id INTEGER,
    full_name VARCHAR,
    hire_date DATE,
    salary NUMERIC
) AS $$
BEGIN
    RETURN QUERY
    SELECT 
        e.employee_id,
        e.first_name || ' ' || e.last_name,
        e.hire_date,
        e.salary
    FROM employees e
    JOIN departments d ON e.department_id = d.department_id
    WHERE d.department_name = dept_name;
END;
$$ LANGUAGE plpgsql;

-- Using the function
SELECT * FROM get_employees_by_dept('Marketing');
```

#### Example 3: Stored Procedure with Parameters

```sql
CREATE OR REPLACE PROCEDURE transfer_funds(
    sender_id INT,
    receiver_id INT,
    amount NUMERIC
)
AS $$
BEGIN
    -- Check if sender has enough funds
    IF (SELECT balance FROM accounts WHERE account_id = sender_id) < amount THEN
        RAISE EXCEPTION 'Insufficient funds';
    END IF;
    
    -- Perform the transfer
    UPDATE accounts SET balance = balance - amount WHERE account_id = sender_id;
    UPDATE accounts SET balance = balance + amount WHERE account_id = receiver_id;
    
    -- Log the transaction
    INSERT INTO transactions (sender_id, receiver_id, amount, transaction_date)
    VALUES (sender_id, receiver_id, amount, CURRENT_TIMESTAMP);
END;
$$ LANGUAGE plpgsql;

-- Calling the procedure
CALL transfer_funds(1001, 1002, 500);
```

#### Example 4: Function with Error Handling

```sql
CREATE OR REPLACE FUNCTION calculate_discount(
    product_id INT,
    discount_percent NUMERIC
) RETURNS NUMERIC AS $$
DECLARE
    original_price NUMERIC;
    discounted_price NUMERIC;
BEGIN
    -- Get the product price
    SELECT price INTO original_price
    FROM products
    WHERE product_id = calculate_discount.product_id;
    
    -- Check if product exists
    IF original_price IS NULL THEN
        RAISE EXCEPTION 'Product with ID % not found', product_id;
    END IF;
    
    -- Check if discount is valid
    IF discount_percent < 0 OR discount_percent > 100 THEN
        RAISE EXCEPTION 'Discount must be between 0 and 100';
    END IF;
    
    -- Calculate the discounted price
    discounted_price := original_price * (1 - discount_percent / 100);
    
    RETURN discounted_price;
EXCEPTION
    WHEN OTHERS THEN
        RAISE;
END;
$$ LANGUAGE plpgsql;

-- Using the function
SELECT calculate_discount(101, 15);
```

#### Example 5: Trigger Function

```sql
-- Create a function to be used by a trigger
CREATE OR REPLACE FUNCTION update_last_modified()
RETURNS TRIGGER AS $$
BEGIN
    NEW.last_modified = CURRENT_TIMESTAMP;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Create a trigger
CREATE TRIGGER products_update_trigger
BEFORE UPDATE ON products
FOR EACH ROW
EXECUTE FUNCTION update_last_modified();
```

## Day 11: Triggers and Events

### What are Triggers?

Triggers are special types of stored procedures that automatically execute when an event occurs in the database server.

#### Example 1: Insert Trigger

```sql
CREATE OR REPLACE FUNCTION log_new_employee()
RETURNS TRIGGER AS $$
BEGIN
    INSERT INTO employee_audit (employee_id, action, action_date)
    VALUES (NEW.employee_id, 'INSERT', CURRENT_TIMESTAMP);
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER employee_insert_trigger
AFTER INSERT ON employees
FOR EACH ROW
EXECUTE FUNCTION log_new_employee();
```

#### Example 2: Update Trigger

```sql
CREATE OR REPLACE FUNCTION log_salary_changes()
RETURNS TRIGGER AS $$
BEGIN
    IF NEW.salary <> OLD.salary THEN
        INSERT INTO salary_history (employee_id, old_salary, new_salary, change_date)
        VALUES (NEW.employee_id, OLD.salary, NEW.salary, CURRENT_TIMESTAMP);
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER salary_update_trigger
AFTER UPDATE ON employees
FOR EACH ROW
EXECUTE FUNCTION log_salary_changes();
```

#### Example 3: Delete Trigger

```sql
CREATE OR REPLACE FUNCTION archive_deleted_order()
RETURNS TRIGGER AS $$
BEGIN
    INSERT INTO orders_archive
    SELECT *, CURRENT_TIMESTAMP AS deleted_at
    FROM orders
    WHERE order_id = OLD.order_id;
    RETURN OLD;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER order_delete_trigger
BEFORE DELETE ON orders
FOR EACH ROW
EXECUTE FUNCTION archive_deleted_order();
```

#### Example 4: Statement-Level Trigger

```sql
CREATE OR REPLACE FUNCTION check_working_hours()
RETURNS TRIGGER AS $$
BEGIN
    IF EXTRACT(HOUR FROM CURRENT_TIMESTAMP) < 9 OR 
       EXTRACT(HOUR FROM CURRENT_TIMESTAMP) > 17 THEN
        RAISE EXCEPTION 'Database modifications only allowed during business hours (9 AM - 5 PM)';
    END IF;
    RETURN NULL;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER working_hours_trigger
BEFORE UPDATE OR INSERT OR DELETE ON critical_table
FOR EACH STATEMENT
EXECUTE FUNCTION check_working_hours();
```

#### Example 5: Conditional Trigger

```sql
CREATE OR REPLACE FUNCTION validate_product_price()
RETURNS TRIGGER AS $$
BEGIN
    -- Only validate for certain categories
    IF NEW.category IN ('Electronics', 'Appliances') AND NEW.price < 50 THEN
        RAISE EXCEPTION 'Price for % must be at least $50', NEW.category;
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER product_price_validation
BEFORE INSERT OR UPDATE ON products
FOR EACH ROW
EXECUTE FUNCTION validate_product_price();
```

## Day 12: Views and Materialized Views

### What are Views?

A view is a virtual table based on the result-set of an SQL statement. Views allow you to:
- Simplify complex queries
- Restrict access to specific data
- Present data in a different way

#### Example 1: Simple View

```sql
CREATE VIEW employee_details AS
SELECT 
    e.employee_id,
    e.first_name,
    e.last_name,
    e.email,
    d.department_name,
    e.salary
FROM employees e
JOIN departments d ON e.department_id = d.department_id;

-- Using the view
SELECT * FROM employee_details
WHERE department_name = 'Sales';
```

#### Example 2: View with Calculations

```sql
CREATE VIEW product_sales_summary AS
SELECT 
    p.product_id,
    p.product_name,
    p.category,
    SUM(oi.quantity) AS total_sold,
    SUM(oi.quantity * p.price) AS total_revenue
FROM products p
JOIN order_items oi ON p.product_id = oi.product_id
GROUP BY p.product_id, p.product_name, p.category;

-- Using the view
SELECT * FROM product_sales_summary
ORDER BY total_revenue DESC
LIMIT 10;
```

#### Example 3: Updatable View

```sql
CREATE VIEW active_customers AS
SELECT customer_id, customer_name, email, phone
FROM customers
WHERE active = TRUE;

-- Using the view to update data
UPDATE active_customers
SET phone = '555-123-4567'
WHERE customer_id = 1001;
```

#### Example 4: View with Check Option

```sql
CREATE VIEW high_salary_employees AS
SELECT employee_id, first_name, last_name, department, salary
FROM employees
WHERE salary > 70000
WITH CHECK OPTION;

-- This will fail due to CHECK OPTION
INSERT INTO high_salary_employees 
VALUES (1099, 'John', 'Smith', 'IT', 65000);
```

### What are Materialized Views?

Materialized views are similar to regular views, but they store the result set physically. They need to be refreshed when the underlying data changes.

#### Example 5: Materialized View

```sql
CREATE MATERIALIZED VIEW monthly_sales_summary AS
SELECT 
    EXTRACT(YEAR FROM order_date) AS year,
    EXTRACT(MONTH FROM order_date) AS month,
    SUM(total_amount) AS total_sales,
    COUNT(DISTINCT customer_id) AS customer_count
FROM orders
GROUP BY year, month;

-- Refresh the materialized view
REFRESH MATERIALIZED VIEW monthly_sales_summary;

-- Query the materialized view
SELECT * FROM monthly_sales_summary
ORDER BY year DESC, month DESC;
```

## Day 13: PostgreSQL JSON and JSONB

### Working with JSON Data

PostgreSQL provides robust support for JSON (JavaScript Object Notation) data through two data types:
- `JSON`: Stores exact copy of input text
- `JSONB`: Stores binary format, which is more efficient for processing but not order-preserving

#### Example 1: Creating Tables with JSON

```sql
CREATE TABLE user_profiles (
    user_id SERIAL PRIMARY KEY,
    username VARCHAR(50) NOT NULL,
    profile_data JSONB
);
```

#### Example 2: Inserting JSON Data

```sql
INSERT INTO user_profiles (username, profile_data)
VALUES (
    'johndoe',
    '{"name": "John Doe", "age": 30, "interests": ["hiking", "photography", "coding"], "contact": {"email": "john@example.com", "phone": "555-123-4567"}}'
);
```

#### Example 3: Querying JSON Data

```sql
-- Get a specific field
SELECT 
    username,
    profile_data->'name' AS full_name,
    profile_data->'age' AS age
FROM user_profiles;

-- The -> operator returns JSON, ->> returns text
SELECT 
    username,
    profile_data->>'name' AS full_name,
    (profile_data->>'age')::INTEGER AS age
FROM user_profiles
WHERE (profile_data->>'age')::INTEGER > 25;
```

#### Example 4: Updating JSON Data

```sql
-- Update a specific field
UPDATE user_profiles
SET profile_data = jsonb_set(profile_data, '{age}', '31')
WHERE username = 'johndoe';

-- Add a new field
UPDATE user_profiles
SET profile_data = profile_data || '{"premium_member": true}'
WHERE username = 'johndoe';
```

#### Example 5: Advanced JSON Queries

```sql
-- Search within JSON arrays
SELECT username
FROM user_profiles
WHERE profile_data->'interests' @> '"photography"';

-- Search within nested objects
SELECT username
FROM user_profiles
WHERE profile_data->'contact'->>'email' LIKE '%@example.com';

-- Expand JSON arrays
SELECT 
    username,
    jsonb_array_elements_text(profile_data->'interests') AS interest
FROM user_profiles;
```

## Day 14: Window Functions

### What are Window Functions?

Window functions perform calculations across a set of table rows that are related to the current row. Unlike regular aggregate functions, window functions do not cause rows to become grouped into a single output row.

#### Example 1: ROW_NUMBER()

```sql
SELECT 
    employee_id,
    first_name,
    last_name,
    department,
    salary,
    ROW_NUMBER() OVER (ORDER BY salary DESC) AS salary_rank
FROM employees;
```

#### Example 2: RANK() and DENSE_RANK()

```sql
SELECT 
    employee_id,
    first_name,
    last_name,
    department,
    salary,
    RANK() OVER (PARTITION BY department ORDER BY salary DESC) AS dept_salary_rank,
    DENSE_RANK() OVER (ORDER BY salary DESC) AS overall_salary_rank
FROM employees;
```

#### Example 3: Aggregate Window Functions

```sql
SELECT 
    employee_id,
    first_name,
    department,
    salary,
    AVG(salary) OVER (PARTITION BY department) AS dept_avg_salary,
    salary - AVG(salary) OVER (PARTITION BY department) AS diff_from_avg
FROM employees;
```

#### Example 4: NTILE()

```sql
-- Divide employees into 4 salary quartiles
SELECT 
    employee_id,
    first_name,
    salary,
    NTILE(4) OVER (ORDER BY salary DESC) AS salary_quartile
FROM employees;
```

#### Example 5: LAG() and LEAD()

```sql
-- Compare with previous and next rows
SELECT 
    order_id,
    order_date,
    total_amount,
    LAG(total_amount) OVER (ORDER BY order_date) AS prev_order_amount,
    LEAD(total_amount) OVER (ORDER BY order_date) AS next_order_amount,
    total_amount - LAG(total_amount) OVER (ORDER BY order_date) AS amount_change
FROM orders
WHERE customer_id = 1001
ORDER BY order_date;
```

## Day 15: Advanced PostgreSQL Features

### Full-Text Search

PostgreSQL provides powerful full-text search capabilities.

#### Example 1: Basic Full-Text Search

```sql
-- Create a tsvector column
ALTER TABLE products ADD COLUMN search_vector tsvector;

-- Update the search vector
UPDATE products SET search_vector = 
    to_tsvector('english', product_name || ' ' || description);

-- Create a GIN index
CREATE INDEX idx_products_search ON products USING GIN(search_vector);

-- Perform a search
SELECT product_id, product_name
FROM products
WHERE search_vector @@ to_tsquery('english', 'wireless & headphones');
```

### Array Data Type

PostgreSQL supports array data types.

#### Example 2: Working with Arrays

```sql
CREATE TABLE product_tags (
    product_id INTEGER PRIMARY KEY,
    product_name VARCHAR(100),
    tags TEXT[]
);

INSERT INTO product_tags (product_id, product_name, tags)
VALUES (101, 'Wireless Headphones', ARRAY['electronics', 'audio', 'wireless']);

-- Query array elements
SELECT * FROM product_tags
WHERE 'audio' = ANY(tags);

-- Expand arrays
SELECT product_name, unnest(tags) AS tag
FROM product_tags;
```

### Range Types

PostgreSQL supports range data types for representing a range of values.

#### Example 3: Working with Ranges

```sql
CREATE TABLE reservations (
    reservation_id SERIAL PRIMARY KEY,
    room_id INTEGER,
    reservation_period TSRANGE,
    customer_name VARCHAR(100)
);

INSERT INTO reservations (room_id, reservation_period, customer_name)
VALUES (
    101, 
    tsrange('2023-07-10 14:00:00', '2023-07-15 11:00:00'),
    'John Doe'
);

-- Check for overlapping reservations
SELECT * FROM reservations
WHERE room_id = 101 AND 
reservation_period && tsrange('2023-07-12 14:00:00', '2023-07-16 11:00:00');
```

### Inheritance

PostgreSQL supports table inheritance.

#### Example 4: Table Inheritance

```sql
CREATE TABLE vehicles (
    vehicle_id SERIAL PRIMARY KEY,
    manufacturer VARCHAR(100),
    model VARCHAR(100),
    year INTEGER
);

CREATE TABLE cars (
    doors INTEGER,
    fuel_type VARCHAR(50)
) INHERITS (vehicles);

CREATE TABLE motorcycles (
    engine_capacity INTEGER,
    has_sidecar BOOLEAN
) INHERITS (vehicles);

-- Insert data
INSERT INTO cars (manufacturer, model, year, doors, fuel_type)
VALUES ('Toyota', 'Camry', 2022, 4, 'Hybrid');

-- Query all vehicles
SELECT * FROM vehicles;
```

### Custom Data Types

PostgreSQL allows you to define custom data types.

#### Example 5: Enumerated Types

```sql
-- Create an enum type
CREATE TYPE order_status AS ENUM ('Pending', 'Processing', 'Shipped', 'Delivered', 'Cancelled');

-- Use the enum type
CREATE TABLE shipping_orders (
    order_id SERIAL PRIMARY KEY,
    customer_id INTEGER,
    status order_status DEFAULT 'Pending',
    order_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Insert data
INSERT INTO shipping_orders (customer_id, status)
VALUES (1001, 'Processing');

-- Invalid status will cause an error
-- INSERT INTO shipping_orders (customer_id, status)
-- VALUES (1002, 'InTransit');
```

## Practice Questions

### Basic SQL

1. Create a database named `online_bookstore` and tables for `authors`, `books`, and `customers`. Establish appropriate relationships between these tables.

2. Write a query to find all books published after 2020 with a price less than $20.

3. Update the price of all books in the 'Science Fiction' category by increasing them by 10%.

4. Delete all customers who haven't made a purchase in the last 2 years.

5. Write a query to list the top 5 bestselling books along with their authors.

### Intermediate SQL

6. Create a view that shows each author's name, the number of books they've written, and their average book rating.

7. Write a query using a CTE to find customers who have purchased books from at least 3 different categories.

8. Create a function that calculates the total revenue generated by a specific author's books.

9. Implement a trigger that updates the book inventory when a new order is placed.

10. Write a query using window functions to rank books by sales within each category.

### Advanced SQL

11. Create a materialized view that summarizes monthly sales data and includes year-over-year growth percentages.

12. Write a recursive CTE to display a hierarchical category structure (assuming categories can have subcategories).

13. Implement a stored procedure that processes refunds and updates relevant tables (orders, inventory, payment records).

14. Create a function that returns book recommendations for a customer based on their previous purchases.

15. Write a query using full-text search to find books that match specific keywords in their title or description.

Remember to consider performance optimization, data integrity, and error handling in your solutions.
````
