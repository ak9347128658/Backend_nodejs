-- Week 3, Day 4: Window Functions
-- Exercises

-- Setup data for exercises
-- Create employee table if it doesn't exist
CREATE TABLE IF NOT EXISTS employees (
    employee_id SERIAL PRIMARY KEY,
    first_name VARCHAR(50),
    last_name VARCHAR(50),
    department VARCHAR(50),
    salary NUMERIC(10, 2),
    hire_date DATE
);

-- Clear the table if it has data
TRUNCATE employees RESTART IDENTITY;

-- Insert sample data
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
('Lisa', 'Thomas', 'HR', 62000.00, '2020-08-22'),
('William', 'Moore', 'Finance', 69000.00, '2018-03-15'),
('Elizabeth', 'Clark', 'IT', 75000.00, '2019-11-08'),
('Richard', 'Lewis', 'Marketing', 66000.00, '2017-09-22'),
('Susan', 'Walker', 'HR', 72000.00, '2016-12-10'),
('Joseph', 'Young', 'Finance', 79000.00, '2020-05-19');

-- Create a sales table for time-series exercises
CREATE TABLE IF NOT EXISTS regional_sales (
    sales_id SERIAL PRIMARY KEY,
    region VARCHAR(50),
    product VARCHAR(50),
    sale_date DATE,
    amount NUMERIC(10, 2)
);

-- Clear the table if it has data
TRUNCATE regional_sales RESTART IDENTITY;

-- Insert sample data
INSERT INTO regional_sales (region, product, sale_date, amount) VALUES
('North', 'Laptop', '2022-01-15', 5200.00),
('South', 'Laptop', '2022-01-20', 4800.00),
('East', 'Laptop', '2022-01-22', 5100.00),
('West', 'Laptop', '2022-01-25', 5500.00),
('North', 'Smartphone', '2022-01-18', 3200.00),
('South', 'Smartphone', '2022-01-23', 3000.00),
('East', 'Smartphone', '2022-01-27', 3300.00),
('West', 'Smartphone', '2022-01-30', 3400.00),
('North', 'Tablet', '2022-02-05', 2200.00),
('South', 'Tablet', '2022-02-08', 2100.00),
('East', 'Tablet', '2022-02-10', 2300.00),
('West', 'Tablet', '2022-02-12', 2400.00),
('North', 'Laptop', '2022-02-15', 5300.00),
('South', 'Laptop', '2022-02-18', 4900.00),
('East', 'Laptop', '2022-02-20', 5200.00),
('West', 'Laptop', '2022-02-22', 5600.00),
('North', 'Smartphone', '2022-02-25', 3300.00),
('South', 'Smartphone', '2022-02-28', 3100.00),
('East', 'Smartphone', '2022-03-05', 3400.00),
('West', 'Smartphone', '2022-03-08', 3500.00),
('North', 'Tablet', '2022-03-10', 2300.00),
('South', 'Tablet', '2022-03-12', 2200.00),
('East', 'Tablet', '2022-03-15', 2400.00),
('West', 'Tablet', '2022-03-18', 2500.00);

-- Create a students table for educational examples
CREATE TABLE IF NOT EXISTS students (
    student_id SERIAL PRIMARY KEY,
    student_name VARCHAR(100),
    class VARCHAR(50),
    subject VARCHAR(50),
    score INTEGER
);

-- Clear the table if it has data
TRUNCATE students RESTART IDENTITY;

-- Insert sample data
INSERT INTO students (student_name, class, subject, score) VALUES
('Alice', 'Class A', 'Math', 85),
('Alice', 'Class A', 'Science', 92),
('Alice', 'Class A', 'English', 78),
('Bob', 'Class A', 'Math', 90),
('Bob', 'Class A', 'Science', 85),
('Bob', 'Class A', 'English', 88),
('Charlie', 'Class A', 'Math', 75),
('Charlie', 'Class A', 'Science', 80),
('Charlie', 'Class A', 'English', 70),
('David', 'Class B', 'Math', 92),
('David', 'Class B', 'Science', 88),
('David', 'Class B', 'English', 94),
('Eva', 'Class B', 'Math', 78),
('Eva', 'Class B', 'Science', 82),
('Eva', 'Class B', 'English', 84),
('Frank', 'Class B', 'Math', 88),
('Frank', 'Class B', 'Science', 90),
('Frank', 'Class B', 'English', 86);

-- Exercise 1: Basic Window Function
-- Write a query to display each employee's salary along with the average salary for their department
-- and the difference between the employee's salary and their department average.

-- Your solution here:


-- Exercise 2: Ranking Functions
-- Write a query to rank employees by salary within each department.
-- Include employee_id, name, department, salary, and three types of rankings:
-- - ROW_NUMBER
-- - RANK
-- - DENSE_RANK

-- Your solution here:


-- Exercise 3: Aggregate Window Functions
-- Write a query to display each employee along with:
-- - Their salary
-- - The running total of salaries by department (ordered by employee_id)
-- - The percentage their salary makes up of their department's total

-- Your solution here:


-- Exercise 4: Window Functions with PARTITION BY and ORDER BY
-- Write a query to find the highest and lowest paid employee in each department.
-- Use a single query with window functions.

-- Your solution here:


-- Exercise 5: Moving Average
-- Using the regional_sales table, calculate a 3-month moving average of sales amount for each region.
-- Order by region and sale_date.

-- Your solution here:


-- Exercise 6: First and Last Values
-- For each department, show the earliest and latest hired employees.
-- Include department, earliest hire (employee name and date), and latest hire (employee name and date).

-- Your solution here:


-- Exercise 7: LEAD and LAG Functions
-- For each employee, show their salary along with the salary of the next higher paid and next lower paid
-- employee in the same department. Include NULL if there isn't a next higher or lower paid employee.

-- Your solution here:


-- Exercise 8: Percentiles with NTILE
-- Divide employees into 3 salary tiers within each department.
-- Show employee name, department, salary, and their tier (1, 2, or 3).

-- Your solution here:


-- Exercise 9: Cumulative Distribution
-- Calculate the cumulative distribution of salaries overall and within each department.
-- (This will show the percentage of employees with salaries less than or equal to each employee's salary.)

-- Your solution here:


-- Exercise 10: Top N per Group
-- Write a query to find the top 2 highest scoring students for each subject from the students table.
-- Include student_name, subject, score, and their rank.

-- Your solution here:


-- Exercise 11: Running Totals with Window Frames
-- Calculate a running total of sales amount for each region, ordered by sale_date.
-- Show region, sale_date, amount, and the running total.

-- Your solution here:


-- Exercise 12: Custom Window Frames
-- For each sale in the regional_sales table, calculate the average sales amount for that sale
-- plus the sale just before and after it (chronologically) within the same region.

-- Your solution here:


-- Exercise 13: Named Windows
-- Rewrite Exercise 10 (Top N per Group) using a named window.

-- Your solution here:


-- Exercise 14: Yearly Growth Rate
-- Calculate the year-over-year growth rate for each product in the regional_sales table.
-- Show product, year, total sales for the year, and the percentage growth from the previous year.

-- Your solution here:


-- Exercise 15: Identifying Salary Gaps
-- Find the largest salary gap between consecutively ranked employees in each department.
-- Include department, employee names, their salaries, and the salary gap.

-- Your solution here:


-- Solutions:

/*
-- Exercise 1 Solution: Basic Window Function
SELECT 
    employee_id,
    first_name,
    last_name,
    department,
    salary,
    ROUND(AVG(salary) OVER(PARTITION BY department), 2) AS dept_avg_salary,
    ROUND(salary - AVG(salary) OVER(PARTITION BY department), 2) AS salary_diff
FROM 
    employees
ORDER BY 
    department, salary DESC;

-- Exercise 2 Solution: Ranking Functions
SELECT 
    employee_id,
    first_name || ' ' || last_name AS employee_name,
    department,
    salary,
    ROW_NUMBER() OVER(PARTITION BY department ORDER BY salary DESC) AS row_num,
    RANK() OVER(PARTITION BY department ORDER BY salary DESC) AS rank,
    DENSE_RANK() OVER(PARTITION BY department ORDER BY salary DESC) AS dense_rank
FROM 
    employees
ORDER BY 
    department, salary DESC;

-- Exercise 3 Solution: Aggregate Window Functions
SELECT 
    employee_id,
    first_name || ' ' || last_name AS employee_name,
    department,
    salary,
    SUM(salary) OVER(PARTITION BY department ORDER BY employee_id) AS running_total,
    ROUND(salary / SUM(salary) OVER(PARTITION BY department) * 100, 2) AS percentage_of_dept_total
FROM 
    employees
ORDER BY 
    department, employee_id;

-- Exercise 4 Solution: Window Functions with PARTITION BY and ORDER BY
WITH ranked_employees AS (
    SELECT 
        department,
        first_name || ' ' || last_name AS employee_name,
        salary,
        ROW_NUMBER() OVER(PARTITION BY department ORDER BY salary DESC) AS highest_rank,
        ROW_NUMBER() OVER(PARTITION BY department ORDER BY salary ASC) AS lowest_rank
    FROM 
        employees
)
SELECT 
    department,
    MAX(CASE WHEN highest_rank = 1 THEN employee_name END) AS highest_paid_employee,
    MAX(CASE WHEN highest_rank = 1 THEN salary END) AS highest_salary,
    MAX(CASE WHEN lowest_rank = 1 THEN employee_name END) AS lowest_paid_employee,
    MAX(CASE WHEN lowest_rank = 1 THEN salary END) AS lowest_salary
FROM 
    ranked_employees
GROUP BY 
    department
ORDER BY 
    department;

-- Exercise 5 Solution: Moving Average
SELECT 
    region,
    sale_date,
    amount,
    ROUND(
        AVG(amount) OVER(
            PARTITION BY region 
            ORDER BY sale_date 
            ROWS BETWEEN 2 PRECEDING AND CURRENT ROW
        ), 
        2
    ) AS moving_avg_3_month
FROM 
    regional_sales
ORDER BY 
    region, sale_date;

-- Exercise 6 Solution: First and Last Values
WITH hire_info AS (
    SELECT 
        department,
        first_name || ' ' || last_name AS employee_name,
        hire_date,
        FIRST_VALUE(first_name || ' ' || last_name) OVER(
            PARTITION BY department 
            ORDER BY hire_date
            RANGE BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING
        ) AS earliest_hire_name,
        FIRST_VALUE(hire_date) OVER(
            PARTITION BY department 
            ORDER BY hire_date
            RANGE BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING
        ) AS earliest_hire_date,
        LAST_VALUE(first_name || ' ' || last_name) OVER(
            PARTITION BY department 
            ORDER BY hire_date
            RANGE BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING
        ) AS latest_hire_name,
        LAST_VALUE(hire_date) OVER(
            PARTITION BY department 
            ORDER BY hire_date
            RANGE BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING
        ) AS latest_hire_date
    FROM 
        employees
)
SELECT DISTINCT
    department,
    earliest_hire_name,
    earliest_hire_date,
    latest_hire_name,
    latest_hire_date
FROM 
    hire_info
ORDER BY 
    department;

-- Exercise 7 Solution: LEAD and LAG Functions
SELECT 
    employee_id,
    first_name || ' ' || last_name AS employee_name,
    department,
    salary,
    LEAD(first_name || ' ' || last_name) OVER(
        PARTITION BY department 
        ORDER BY salary
    ) AS next_higher_paid_employee,
    LEAD(salary) OVER(
        PARTITION BY department 
        ORDER BY salary
    ) AS next_higher_salary,
    LAG(first_name || ' ' || last_name) OVER(
        PARTITION BY department 
        ORDER BY salary
    ) AS next_lower_paid_employee,
    LAG(salary) OVER(
        PARTITION BY department 
        ORDER BY salary
    ) AS next_lower_salary
FROM 
    employees
ORDER BY 
    department, salary;

-- Exercise 8 Solution: Percentiles with NTILE
SELECT 
    employee_id,
    first_name || ' ' || last_name AS employee_name,
    department,
    salary,
    NTILE(3) OVER(PARTITION BY department ORDER BY salary DESC) AS salary_tier
FROM 
    employees
ORDER BY 
    department, salary_tier, salary DESC;

-- Exercise 9 Solution: Cumulative Distribution
SELECT 
    employee_id,
    first_name || ' ' || last_name AS employee_name,
    department,
    salary,
    ROUND(CUME_DIST() OVER(ORDER BY salary) * 100, 2) AS overall_percentile,
    ROUND(CUME_DIST() OVER(PARTITION BY department ORDER BY salary) * 100, 2) AS department_percentile
FROM 
    employees
ORDER BY 
    department, salary;

-- Exercise 10 Solution: Top N per Group
WITH ranked_students AS (
    SELECT 
        student_name,
        subject,
        score,
        RANK() OVER(PARTITION BY subject ORDER BY score DESC) AS rank
    FROM 
        students
)
SELECT 
    student_name,
    subject,
    score,
    rank
FROM 
    ranked_students
WHERE 
    rank <= 2
ORDER BY 
    subject, rank;

-- Exercise 11 Solution: Running Totals with Window Frames
SELECT 
    region,
    sale_date,
    amount,
    SUM(amount) OVER(
        PARTITION BY region 
        ORDER BY sale_date 
        ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
    ) AS running_total
FROM 
    regional_sales
ORDER BY 
    region, sale_date;

-- Exercise 12 Solution: Custom Window Frames
SELECT 
    region,
    sale_date,
    amount,
    ROUND(
        AVG(amount) OVER(
            PARTITION BY region 
            ORDER BY sale_date 
            ROWS BETWEEN 1 PRECEDING AND 1 FOLLOWING
        ), 
        2
    ) AS three_point_avg
FROM 
    regional_sales
ORDER BY 
    region, sale_date;

-- Exercise 13 Solution: Named Windows
WITH ranked_students AS (
    SELECT 
        student_name,
        subject,
        score,
        RANK() OVER subject_score_window AS rank
    FROM 
        students
    WINDOW subject_score_window AS (PARTITION BY subject ORDER BY score DESC)
)
SELECT 
    student_name,
    subject,
    score,
    rank
FROM 
    ranked_students
WHERE 
    rank <= 2
ORDER BY 
    subject, rank;

-- Exercise 14 Solution: Yearly Growth Rate
WITH yearly_sales AS (
    SELECT 
        product,
        EXTRACT(YEAR FROM sale_date) AS year,
        SUM(amount) AS yearly_sales
    FROM 
        regional_sales
    GROUP BY 
        product, EXTRACT(YEAR FROM sale_date)
)
SELECT 
    product,
    year,
    yearly_sales,
    LAG(yearly_sales) OVER(PARTITION BY product ORDER BY year) AS prev_year_sales,
    CASE 
        WHEN LAG(yearly_sales) OVER(PARTITION BY product ORDER BY year) IS NULL THEN NULL
        ELSE ROUND(
            (yearly_sales - LAG(yearly_sales) OVER(PARTITION BY product ORDER BY year)) / 
            LAG(yearly_sales) OVER(PARTITION BY product ORDER BY year) * 100, 
            2
        ) 
    END AS growth_percentage
FROM 
    yearly_sales
ORDER BY 
    product, year;

-- Exercise 15 Solution: Identifying Salary Gaps
WITH ranked_employees AS (
    SELECT 
        department,
        first_name || ' ' || last_name AS employee_name,
        salary,
        LAG(first_name || ' ' || last_name) OVER(PARTITION BY department ORDER BY salary DESC) AS higher_paid_employee,
        LAG(salary) OVER(PARTITION BY department ORDER BY salary DESC) AS higher_salary,
        salary - LAG(salary) OVER(PARTITION BY department ORDER BY salary DESC) AS salary_gap
    FROM 
        employees
)
SELECT 
    department,
    higher_paid_employee AS higher_employee,
    higher_salary,
    employee_name AS lower_employee,
    salary AS lower_salary,
    ABS(salary_gap) AS salary_gap
FROM 
    ranked_employees
WHERE 
    higher_paid_employee IS NOT NULL
ORDER BY 
    ABS(salary_gap) DESC;
*/
