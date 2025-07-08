-- Example 1: Basic SELECT Statements
-- Create and populate a sample table
CREATE TABLE employees (
    id SERIAL PRIMARY KEY,
    first_name VARCHAR(50),
    last_name VARCHAR(50),
    department VARCHAR(50),
    salary NUMERIC(10, 2),
    hire_date DATE
);

-- Insert sample data
INSERT INTO employees (first_name, last_name, department, salary, hire_date)
VALUES 
    ('John', 'Doe', 'IT', 75000, '2020-01-15'),
    ('Jane', 'Smith', 'HR', 65000, '2019-05-20'),
    ('Michael', 'Johnson', 'Finance', 85000, '2021-03-10'),
    ('Emily', 'Williams', 'Marketing', 72000, '2018-11-05'),
    ('Robert', 'Brown', 'IT', 78000, '2020-08-15'),
    ('Sarah', 'Davis', 'HR', 67000, '2019-10-12'),
    ('David', 'Miller', 'Finance', 90000, '2017-04-22'),
    ('Jessica', 'Wilson', 'Marketing', 74000, '2021-06-30'),
    ('James', 'Taylor', 'IT', 80000, '2018-02-18'),
    ('Jennifer', 'Anderson', 'HR', 69000, '2020-11-15');

-- Select all columns, all rows
SELECT * FROM employees;

-- Select specific columns
SELECT first_name, last_name, department FROM employees;

-- Example 2: Column Aliases
-- Using column aliases
SELECT 
    first_name AS "First Name",
    last_name AS "Last Name",
    department AS "Department"
FROM employees;

-- Using aliases in expressions
SELECT
    first_name || ' ' || last_name AS "Full Name",
    salary AS "Current Salary",
    salary * 1.1 AS "Salary After 10% Raise"
FROM employees;

-- Example 3: Filtering with WHERE
-- Basic WHERE clause
SELECT * FROM employees
WHERE department = 'IT';

-- Multiple conditions with AND
SELECT * FROM employees
WHERE department = 'Finance' AND salary > 80000;

-- Multiple conditions with OR
SELECT * FROM employees
WHERE department = 'IT' OR department = 'HR';

-- Using NOT
SELECT * FROM employees
WHERE NOT department = 'Marketing';

-- Example 4: Comparison Operators
-- Greater than
SELECT * FROM employees
WHERE salary > 75000;

-- Less than or equal to
SELECT * FROM employees
WHERE salary <= 70000;

-- Not equal
SELECT * FROM employees
WHERE department <> 'Finance';

-- BETWEEN operator
SELECT * FROM employees
WHERE salary BETWEEN 70000 AND 80000;

-- IN operator
SELECT * FROM employees
WHERE department IN ('IT', 'Finance');

-- Example 5: Pattern Matching with LIKE
-- Names starting with 'J'
SELECT * FROM employees
WHERE first_name LIKE 'J%';

-- Names ending with 'son'
SELECT * FROM employees
WHERE last_name LIKE '%son';

-- Names containing 'a'
SELECT * FROM employees
WHERE first_name LIKE '%a%';

-- Using ILIKE for case-insensitive matching
SELECT * FROM employees
WHERE department ILIKE 'it';

-- Example 6: Sorting with ORDER BY
-- Sort by single column ascending (default)
SELECT * FROM employees
ORDER BY salary;

-- Sort by single column descending
SELECT * FROM employees
ORDER BY hire_date DESC;

-- Sort by multiple columns
SELECT * FROM employees
ORDER BY department ASC, salary DESC;

-- Sort by column position
SELECT first_name, last_name, salary FROM employees
ORDER BY 3 DESC;

-- Example 7: LIMIT and OFFSET
-- Limit results to 5 rows
SELECT * FROM employees
ORDER BY id
LIMIT 5;

-- Skip first 5 rows, return next 3
SELECT * FROM employees
ORDER BY id
LIMIT 3 OFFSET 5;

-- Pagination example (page 2, 4 items per page)
SELECT * FROM employees
ORDER BY id
LIMIT 4 OFFSET 4;
