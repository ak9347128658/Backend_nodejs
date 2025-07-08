# Day 3: Data Manipulation - INSERT, UPDATE, DELETE

## Topics Covered

1. Inserting data with INSERT
2. Updating data with UPDATE
3. Deleting data with DELETE
4. RETURNING clause
5. Bulk operations

## Examples and Exercises

### Example 1: Basic Insert

```sql
-- Create a sample table
CREATE TABLE employees (
    employee_id SERIAL PRIMARY KEY,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    email VARCHAR(100) UNIQUE,
    hire_date DATE,
    salary NUMERIC(10, 2)
);

-- Basic insert
INSERT INTO employees (first_name, last_name, email, hire_date, salary)
VALUES ('John', 'Doe', 'john.doe@example.com', '2023-01-15', 75000);
```

### Example 2: Multiple Row Insert

```sql
-- Insert multiple rows at once
INSERT INTO employees (first_name, last_name, email, hire_date, salary)
VALUES 
    ('Jane', 'Smith', 'jane.smith@example.com', '2023-02-01', 82000),
    ('Robert', 'Johnson', 'robert.johnson@example.com', '2023-02-15', 78000),
    ('Emily', 'Williams', 'emily.williams@example.com', '2023-03-01', 85000);
```

### Example 3: Insert with Default Values and RETURNING

```sql
-- Create a table with default values
CREATE TABLE products (
    product_id SERIAL PRIMARY KEY,
    product_name VARCHAR(100) NOT NULL,
    price NUMERIC(10, 2),
    stock_quantity INTEGER DEFAULT 0,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Insert with defaults and RETURNING clause
INSERT INTO products (product_name, price)
VALUES ('Smartphone', 699.99)
RETURNING product_id, product_name, created_at;
```

### Example 4: Insert with Subquery

```sql
-- Create two tables
CREATE TABLE old_employees (
    employee_id SERIAL PRIMARY KEY,
    first_name VARCHAR(50),
    last_name VARCHAR(50),
    department VARCHAR(50),
    hire_date DATE
);

CREATE TABLE employee_archive (
    employee_id INTEGER PRIMARY KEY,
    full_name VARCHAR(100),
    department VARCHAR(50),
    hire_date DATE,
    archived_date DATE
);

-- Insert some data into old_employees
INSERT INTO old_employees (first_name, last_name, department, hire_date)
VALUES 
    ('Michael', 'Brown', 'HR', '2015-06-01'),
    ('Sarah', 'Davis', 'Finance', '2016-11-15');

-- Insert into archive using subquery
INSERT INTO employee_archive (employee_id, full_name, department, hire_date, archived_date)
SELECT 
    employee_id, 
    first_name || ' ' || last_name, 
    department, 
    hire_date, 
    CURRENT_DATE
FROM old_employees
WHERE hire_date < '2020-01-01';
```

### Example 5: UPDATE Operations

```sql
-- Basic update
UPDATE employees
SET salary = 80000
WHERE employee_id = 1;

-- Update multiple columns
UPDATE employees
SET 
    salary = salary * 1.1,
    hire_date = '2023-04-01'
WHERE first_name = 'Jane';

-- Update with calculated values
UPDATE products
SET stock_quantity = stock_quantity - 5
WHERE product_name = 'Smartphone';

-- Update with RETURNING
UPDATE employees
SET salary = 90000
WHERE employee_id = 3
RETURNING employee_id, first_name, last_name, salary AS new_salary;
```

### Example 6: DELETE Operations

```sql
-- Basic delete
DELETE FROM employees
WHERE employee_id = 4;

-- Delete with condition
DELETE FROM products
WHERE stock_quantity = 0;

-- Delete all rows
DELETE FROM employee_archive;

-- Delete with RETURNING
DELETE FROM employees
WHERE hire_date < '2023-02-01'
RETURNING *;
```

## Practice Exercises

1. Using the "retail_store" database created in Day 2:
   - Insert at least 5 records into the `customers` table
   - Insert at least 3 records into the `categories` table
   - Insert at least 10 records into the `products` table
   - Insert at least 3 records into the `orders` table
   - Insert appropriate records into the `order_items` table

2. Perform the following UPDATE operations:
   - Update the price of all products in a specific category by increasing them by 5%
   - Update a customer's contact information
   - Update the status of an order from 'Pending' to 'Shipped'

3. Perform the following DELETE operations:
   - Delete a specific order and its order items (think about the order of operations)
   - Delete all products with zero inventory
   - Delete a category (what happens to the products in this category?)

4. Use the RETURNING clause with each type of operation (INSERT, UPDATE, DELETE)

5. Write a query to move all 'Cancelled' orders to an 'archived_orders' table

## Additional Resources

- [PostgreSQL INSERT Documentation](https://www.postgresql.org/docs/current/sql-insert.html)
- [PostgreSQL UPDATE Documentation](https://www.postgresql.org/docs/current/sql-update.html)
- [PostgreSQL DELETE Documentation](https://www.postgresql.org/docs/current/sql-delete.html)
