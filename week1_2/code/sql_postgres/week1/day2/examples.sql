-- Example 1: Basic Table Creation
CREATE TABLE employees (
    employee_id SERIAL PRIMARY KEY,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    email VARCHAR(100) UNIQUE,
    hire_date DATE,
    salary NUMERIC(10, 2)
);

-- Example 2: Table with Constraints
CREATE TABLE products (
    product_id SERIAL PRIMARY KEY,
    product_name VARCHAR(100) NOT NULL,
    category VARCHAR(50) CHECK (category IN ('Electronics', 'Clothing', 'Books', 'Home', 'Other')),
    price NUMERIC(10, 2) CHECK (price > 0),
    stock_quantity INTEGER DEFAULT 0,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Example 3: Table with Foreign Key
-- Create departments table first
CREATE TABLE departments (
    department_id SERIAL PRIMARY KEY,
    department_name VARCHAR(100) NOT NULL,
    location VARCHAR(100)
);

-- Create employees table with foreign key
CREATE TABLE employees2 (
    employee_id SERIAL PRIMARY KEY,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    department_id INTEGER,
    FOREIGN KEY (department_id) REFERENCES departments(department_id)
);

-- Example 4: Creating a Table with a Composite Key
CREATE TABLE course_enrollment (
    student_id INTEGER,
    course_id INTEGER,
    enrollment_date DATE,
    grade CHAR(1),
    PRIMARY KEY (student_id, course_id)
);

-- Example 5: Modifying Tables
-- Add a column
ALTER TABLE employees ADD COLUMN phone VARCHAR(20);

-- Modify a column
ALTER TABLE employees ALTER COLUMN phone TYPE VARCHAR(30);

-- Add a constraint
ALTER TABLE employees ADD CONSTRAINT unique_email UNIQUE (email);

-- Drop a column
ALTER TABLE employees ADD COLUMN temp_column VARCHAR(10);
ALTER TABLE employees DROP COLUMN IF EXISTS temp_column;

-- Rename a column
ALTER TABLE employees RENAME COLUMN phone TO contact_number;
