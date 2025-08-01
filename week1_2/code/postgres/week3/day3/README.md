# Day 4: Window Functions

## Topics Covered

1. Introduction to window functions
2. OVER clause and window definition
3. Ranking functions (ROW_NUMBER, RANK, DENSE_RANK, NTILE)
4. Aggregate window functions (SUM, AVG, COUNT, MAX, MIN)
5. Value window functions (LEAD, LAG, FIRST_VALUE, LAST_VALUE)
6. Window frame specification (ROWS, RANGE)
7. PARTITION BY vs GROUP BY
8. Practical applications of window functions

## Examples and Exercises

### Example 1: Introduction to Window Functions

Window functions perform calculations across a set of rows related to the current row without collapsing those rows like GROUP BY does. This allows you to retrieve regular columns along with aggregate calculations.

```sql
-- Create and populate a sample employees table
CREATE TABLE employees (
    employee_id SERIAL PRIMARY KEY,
    first_name VARCHAR(50),
    last_name VARCHAR(50),
    department VARCHAR(50),
    salary NUMERIC(10, 2),
    hire_date DATE
);

INSERT INTO employees (first_name, last_name, department, salary, hire_date) VALUES
('John', 'Smith', 'HR', 65000.00, '2018-06-15'),
('Jane', 'Doe', 'IT', 78000.00, '2019-03-20'),
('Michael', 'Johnson', 'Finance', 72000.00, '2017-11-10'),
('Emily', 'Williams', 'IT', 82000.00, '2020-01-05'),
('Robert', 'Brown', 'Marketing', 68000.00, '2018-09-30'),
('Sarah', 'Miller', 'HR', 59000.00, '2021-02-12'),
('David', 'Anderson', 'Finance', 85000.00, '2016-07-25'),
('Jennifer', 'Wilson', 'Marketing', 71000.00, '2019-05-18'),
('James', 'Taylor', 'IT', 90000.00, '2017-04-03'),
('Lisa', 'Thomas', 'HR', 62000.00, '2020-08-22');

-- Basic window function example
-- This query shows each employee along with the average salary across all employees
SELECT 
    employee_id,
    first_name,
    last_name,
    department,
    salary,
    AVG(salary) OVER() AS avg_company_salary
FROM 
    employees;
```

In this example, `AVG(salary) OVER()` calculates the average salary across the entire result set, and the value is included in each row of the result.

### Example 2: PARTITION BY Clause

The PARTITION BY clause divides the result set into partitions to which the window function is applied.

```sql
-- Calculate average salary by department
SELECT 
    employee_id,
    first_name,
    last_name,
    department,
    salary,
    AVG(salary) OVER(PARTITION BY department) AS avg_department_salary
FROM 
    employees;

-- Calculate multiple window functions at once
SELECT 
    employee_id,
    first_name,
    last_name,
    department,
    salary,
    AVG(salary) OVER(PARTITION BY department) AS avg_department_salary,
    MAX(salary) OVER(PARTITION BY department) AS max_department_salary,
    MIN(salary) OVER(PARTITION BY department) AS min_department_salary,
    COUNT(*) OVER(PARTITION BY department) AS department_employee_count
FROM 
    employees;
```

The `PARTITION BY department` clause divides the result set into groups based on the department, and the window function is applied to each group separately.

### Example 3: Ranking Functions

Ranking functions assign a rank to each row within a partition based on the values in the specified column(s).

```sql
-- ROW_NUMBER: Assigns a unique sequential integer to each row
SELECT 
    employee_id,
    first_name,
    last_name,
    department,
    salary,
    ROW_NUMBER() OVER(ORDER BY salary DESC) AS overall_salary_rank,
    ROW_NUMBER() OVER(PARTITION BY department ORDER BY salary DESC) AS department_salary_rank
FROM 
    employees;

-- RANK: Assigns the same rank to rows with equal values, leaving gaps
SELECT 
    employee_id,
    first_name,
    last_name,
    department,
    salary,
    RANK() OVER(ORDER BY salary DESC) AS overall_salary_rank,
    RANK() OVER(PARTITION BY department ORDER BY salary DESC) AS department_salary_rank
FROM 
    employees;

-- DENSE_RANK: Assigns the same rank to rows with equal values, without gaps
SELECT 
    employee_id,
    first_name,
    last_name,
    department,
    salary,
    DENSE_RANK() OVER(ORDER BY salary DESC) AS overall_salary_rank,
    DENSE_RANK() OVER(PARTITION BY department ORDER BY salary DESC) AS department_salary_rank
FROM 
    employees;

-- NTILE: Divides the rows into a specified number of groups (as equal as possible)
SELECT 
    employee_id,
    first_name,
    last_name,
    department,
    salary,
    NTILE(4) OVER(ORDER BY salary DESC) AS salary_quartile
FROM 
    employees;
```

Key differences between ranking functions:
- `ROW_NUMBER()`: Always unique, even with ties (1, 2, 3, 4, 5, ...)
- `RANK()`: Same rank for ties, leaves gaps (1, 2, 2, 4, 5, ...)
- `DENSE_RANK()`: Same rank for ties, no gaps (1, 2, 2, 3, 4, ...)
- `NTILE(n)`: Divides rows into n groups of approximately equal size

### Example 4: Aggregate Window Functions

Aggregate window functions are similar to regular aggregate functions but don't collapse rows.

```sql
-- Running total of salaries
SELECT 
    employee_id,
    first_name,
    last_name,
    department,
    salary,
    SUM(salary) OVER(ORDER BY employee_id) AS running_total
FROM 
    employees;

-- Running total of salaries within each department
SELECT 
    employee_id,
    first_name,
    last_name,
    department,
    salary,
    SUM(salary) OVER(PARTITION BY department ORDER BY employee_id) AS department_running_total
FROM 
    employees;

-- Percentage of department total
SELECT 
    employee_id,
    first_name,
    last_name,
    department,
    salary,
    SUM(salary) OVER(PARTITION BY department) AS department_total,
    ROUND(salary / SUM(salary) OVER(PARTITION BY department) * 100, 2) AS percentage_of_dept_total
FROM 
    employees
ORDER BY 
    department, percentage_of_dept_total DESC;
```

### Example 5: Value Window Functions

Value window functions access values from other rows within the same result set.

```sql
-- LEAD: Access data from subsequent rows
SELECT 
    employee_id,
    first_name,
    last_name,
    department,
    salary,
    LEAD(salary, 1) OVER(PARTITION BY department ORDER BY salary DESC) AS next_lower_salary,
    LEAD(first_name, 1) OVER(PARTITION BY department ORDER BY salary DESC) AS next_lower_salary_employee
FROM 
    employees;

-- LAG: Access data from previous rows
SELECT 
    employee_id,
    first_name,
    last_name,
    department,
    hire_date,
    LAG(hire_date, 1) OVER(PARTITION BY department ORDER BY hire_date) AS prev_hire_date,
    LAG(first_name, 1) OVER(PARTITION BY department ORDER BY hire_date) AS prev_hired_employee
FROM 
    employees;

-- Calculate the difference between current salary and next lower salary
SELECT 
    employee_id,
    first_name,
    last_name,
    department,
    salary,
    LEAD(salary, 1) OVER(PARTITION BY department ORDER BY salary DESC) AS next_lower_salary,
    salary - LEAD(salary, 1, salary) OVER(PARTITION BY department ORDER BY salary DESC) AS salary_difference
FROM 
    employees;

-- FIRST_VALUE: Get the first value in the window frame
SELECT 
    employee_id,
    first_name,
    last_name,
    department,
    salary,
    FIRST_VALUE(salary) OVER(PARTITION BY department ORDER BY salary DESC) AS highest_salary_in_dept
FROM 
    employees;

-- LAST_VALUE: Get the last value in the window frame
-- Note: You need to specify the window frame for LAST_VALUE to work as expected
SELECT 
    employee_id,
    first_name,
    last_name,
    department,
    salary,
    LAST_VALUE(salary) OVER(
        PARTITION BY department 
        ORDER BY salary DESC
        RANGE BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING
    ) AS lowest_salary_in_dept
FROM 
    employees;
```

### Example 6: Window Frame Specification

The window frame clause specifies which rows to include in the window function's calculation relative to the current row.

```sql
-- Default window frame for ordered windows is RANGE BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
-- Running total with explicit window frame
SELECT 
    employee_id,
    first_name,
    last_name,
    department,
    salary,
    SUM(salary) OVER(
        ORDER BY employee_id 
        ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
    ) AS running_total
FROM 
    employees;

-- Moving average of the current row and the previous two rows
SELECT 
    employee_id,
    first_name,
    last_name,
    department,
    salary,
    AVG(salary) OVER(
        ORDER BY employee_id 
        ROWS BETWEEN 2 PRECEDING AND CURRENT ROW
    ) AS moving_avg_3_rows
FROM 
    employees;

-- Calculate a centered average (current row, 1 before, 1 after)
SELECT 
    employee_id,
    first_name,
    last_name,
    department,
    salary,
    AVG(salary) OVER(
        ORDER BY employee_id 
        ROWS BETWEEN 1 PRECEDING AND 1 FOLLOWING
    ) AS centered_avg
FROM 
    employees;

-- Using RANGE instead of ROWS
-- RANGE considers values that are the same as the ordering value
-- In this example, if two employees have the same hire date, they will be included in the same window
CREATE TABLE employees_with_duplicates AS
SELECT * FROM employees;
INSERT INTO employees_with_duplicates (first_name, last_name, department, salary, hire_date)
VALUES ('Thomas', 'Harris', 'IT', 75000, '2019-03-20');

SELECT 
    employee_id,
    first_name,
    last_name,
    department,
    hire_date,
    COUNT(*) OVER(
        ORDER BY hire_date 
        ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
    ) AS running_count_rows,
    COUNT(*) OVER(
        ORDER BY hire_date 
        RANGE BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
    ) AS running_count_range
FROM 
    employees_with_duplicates
ORDER BY 
    hire_date;
```

### Example 7: Named Windows

You can define a window specification once and reuse it with multiple window functions.

```sql
-- Using a named window
SELECT 
    employee_id,
    first_name,
    last_name,
    department,
    salary,
    AVG(salary) OVER dept_window AS avg_dept_salary,
    MAX(salary) OVER dept_window AS max_dept_salary,
    MIN(salary) OVER dept_window AS min_dept_salary,
    COUNT(*) OVER dept_window AS dept_employee_count
FROM 
    employees
WINDOW dept_window AS (PARTITION BY department);

-- Named window with additional options
SELECT 
    employee_id,
    first_name,
    last_name,
    department,
    salary,
    hire_date,
    RANK() OVER dept_salary_window AS dept_salary_rank,
    DENSE_RANK() OVER dept_salary_window AS dept_salary_dense_rank,
    ROW_NUMBER() OVER dept_salary_window AS dept_salary_row_number
FROM 
    employees
WINDOW 
    dept_window AS (PARTITION BY department),
    dept_salary_window AS (dept_window ORDER BY salary DESC);
```

### Example 8: Practical Applications

#### Identifying Top N Per Group

```sql
-- Find the top 2 highest paid employees in each department
WITH ranked_employees AS (
    SELECT 
        employee_id,
        first_name,
        last_name,
        department,
        salary,
        ROW_NUMBER() OVER(PARTITION BY department ORDER BY salary DESC) AS salary_rank
    FROM 
        employees
)
SELECT 
    employee_id,
    first_name,
    last_name,
    department,
    salary
FROM 
    ranked_employees
WHERE 
    salary_rank <= 2;
```

#### Calculating Growth or Change

```sql
-- Create and populate a sample sales table
CREATE TABLE monthly_sales (
    month DATE PRIMARY KEY,
    sales_amount NUMERIC(12, 2)
);

INSERT INTO monthly_sales (month, sales_amount) VALUES
('2022-01-01', 120000),
('2022-02-01', 115000),
('2022-03-01', 130000),
('2022-04-01', 140000),
('2022-05-01', 135000),
('2022-06-01', 150000),
('2022-07-01', 160000),
('2022-08-01', 165000),
('2022-09-01', 170000),
('2022-10-01', 175000),
('2022-11-01', 180000),
('2022-12-01', 190000);

-- Calculate month-over-month growth
SELECT 
    month,
    sales_amount,
    LAG(sales_amount, 1) OVER(ORDER BY month) AS prev_month_sales,
    sales_amount - LAG(sales_amount, 1) OVER(ORDER BY month) AS absolute_change,
    ROUND(
        (sales_amount - LAG(sales_amount, 1) OVER(ORDER BY month)) / 
        LAG(sales_amount, 1) OVER(ORDER BY month) * 100,
        2
    ) AS percentage_change
FROM 
    monthly_sales;

-- Calculate year-to-date total
SELECT 
    month,
    sales_amount,
    SUM(sales_amount) OVER(ORDER BY month ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) AS ytd_sales
FROM 
    monthly_sales;

-- Calculate 3-month moving average
SELECT 
    month,
    sales_amount,
    ROUND(
        AVG(sales_amount) OVER(ORDER BY month ROWS BETWEEN 2 PRECEDING AND CURRENT ROW),
        2
    ) AS moving_avg_3_month
FROM 
    monthly_sales;
```

#### Identifying Gaps and Islands

```sql
-- Create and populate a sample attendance table
CREATE TABLE employee_attendance (
    employee_id INTEGER,
    attendance_date DATE,
    PRIMARY KEY (employee_id, attendance_date)
);

INSERT INTO employee_attendance (employee_id, attendance_date) VALUES
(1, '2023-01-01'),
(1, '2023-01-02'),
(1, '2023-01-03'),
(1, '2023-01-06'),
(1, '2023-01-07'),
(1, '2023-01-10'),
(2, '2023-01-01'),
(2, '2023-01-02'),
(2, '2023-01-04'),
(2, '2023-01-05'),
(2, '2023-01-06');

-- Identify consecutive attendance dates (islands)
WITH attendance_groups AS (
    SELECT 
        employee_id,
        attendance_date,
        attendance_date - (ROW_NUMBER() OVER(PARTITION BY employee_id ORDER BY attendance_date))::INTEGER AS group_id
    FROM 
        employee_attendance
)
SELECT 
    employee_id,
    MIN(attendance_date) AS start_date,
    MAX(attendance_date) AS end_date,
    MAX(attendance_date) - MIN(attendance_date) + 1 AS consecutive_days
FROM 
    attendance_groups
GROUP BY 
    employee_id, group_id
ORDER BY 
    employee_id, start_date;
```

#### Calculating Percentiles

```sql
-- Create and populate a sample test scores table
CREATE TABLE test_scores (
    student_id INTEGER,
    subject VARCHAR(50),
    score INTEGER,
    PRIMARY KEY (student_id, subject)
);

INSERT INTO test_scores (student_id, subject, score) VALUES
(1, 'Math', 85),
(1, 'English', 92),
(1, 'Science', 78),
(2, 'Math', 90),
(2, 'English', 88),
(2, 'Science', 94),
(3, 'Math', 75),
(3, 'English', 82),
(3, 'Science', 80),
(4, 'Math', 95),
(4, 'English', 91),
(4, 'Science', 88),
(5, 'Math', 82),
(5, 'English', 89),
(5, 'Science', 86);

-- Calculate percentile rank for each student in each subject
SELECT 
    student_id,
    subject,
    score,
    ROUND(
        PERCENT_RANK() OVER(PARTITION BY subject ORDER BY score),
        4
    ) * 100 AS percentile_rank
FROM 
    test_scores;

-- Assign a quartile to each score within each subject
SELECT 
    student_id,
    subject,
    score,
    NTILE(4) OVER(PARTITION BY subject ORDER BY score) AS quartile
FROM 
    test_scores;
```

#### Comparing Current Values to Overall Statistics

```sql
-- Compare each employee's salary to the company statistics
SELECT 
    employee_id,
    first_name,
    last_name,
    department,
    salary,
    ROUND(AVG(salary) OVER(), 2) AS avg_salary,
    ROUND(salary - AVG(salary) OVER(), 2) AS diff_from_avg,
    ROUND(salary / AVG(salary) OVER() * 100, 2) AS percent_of_avg,
    MIN(salary) OVER() AS min_salary,
    MAX(salary) OVER() AS max_salary,
    ROUND(
        (salary - MIN(salary) OVER()) / (MAX(salary) OVER() - MIN(salary) OVER()) * 100,
        2
    ) AS percentile
FROM 
    employees;
```

## Window Functions vs. GROUP BY

| Window Functions | GROUP BY |
|------------------|----------|
| Rows are not collapsed | Rows are collapsed into groups |
| Can include all original columns | Can only include grouped columns and aggregate values |
| Calculation based on related rows | Calculation based on all rows in a group |
| Results can show running/moving calculations | Results show only final aggregates |
| Can partition and order data | Can only group data |
| Often used for analysis within a set | Often used for summarizing data |

## Best Practices

1. **Use named windows** for clarity and reusability when applying multiple window functions with the same partitioning and ordering.

2. **Be explicit about window frames** especially when using functions like LAST_VALUE that are affected by the default frame.

3. **Consider performance implications** for large datasets, as window functions can be resource-intensive.

4. **Use CTEs to improve readability** when working with complex window function queries.

5. **Be aware of NULL handling** in window functions, especially with ranking and aggregation.

6. **Understand the difference between ROWS and RANGE** in window frame specifications.

7. **Combine window functions with other SQL features** like CTEs, subqueries, and regular aggregations for powerful analysis.

## Exercises

Complete the exercises in the exercises.sql file to practice working with window functions in PostgreSQL.