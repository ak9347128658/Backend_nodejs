-- Example 1: Basic Insert
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

-- Example 2: Multiple Row Insert
INSERT INTO employees (first_name, last_name, email, hire_date, salary)
VALUES 
    ('Jane', 'Smith', 'jane.smith@example.com', '2023-02-01', 82000),
    ('Robert', 'Johnson', 'robert.johnson@example.com', '2023-02-15', 78000),
    ('Emily', 'Williams', 'emily.williams@example.com', '2023-03-01', 85000);

-- Example 3: Insert with Default Values and RETURNING
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

-- Example 4: Insert with Subquery
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

-- Example 5: UPDATE Operations
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

-- Example 6: DELETE Operations
-- Basic delete
DELETE FROM employees
WHERE employee_id = 4;

-- Delete with condition
DELETE FROM products
WHERE stock_quantity = 0;

-- Delete with RETURNING
DELETE FROM employees
WHERE hire_date < '2023-02-01'
RETURNING *;
