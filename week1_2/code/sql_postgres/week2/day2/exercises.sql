-- Exercises for Day 2: Subqueries and Common Table Expressions (CTEs)

-- Exercise 1: Subqueries in WHERE Clause
-- Find all employees who earn more than the average salary in their department
SELECT 
    e.employee_id,
    e.first_name,
    e.last_name,
    e.department_id,
    e.salary
FROM employees e
WHERE e.salary > (
    SELECT AVG(salary) 
    FROM employees 
    WHERE department_id = e.department_id
)
ORDER BY e.department_id, e.salary DESC;

-- Find the departments that have more than 2 employees
SELECT 
    d.department_id,
    d.department_name,
    (SELECT COUNT(*) FROM employees WHERE department_id = d.department_id) AS employee_count
FROM departments d
WHERE (
    SELECT COUNT(*) 
    FROM employees 
    WHERE department_id = d.department_id
) > 2;

-- Find employees hired before their department's last hire
SELECT 
    e.employee_id,
    e.first_name,
    e.last_name,
    e.department_id,
    e.hire_date
FROM employees e
WHERE e.hire_date < (
    SELECT MAX(hire_date)
    FROM employees
    WHERE department_id = e.department_id
)
ORDER BY e.department_id, e.hire_date;

-- Exercise 2: Subqueries in FROM Clause
-- Calculate percentage of department total for each employee's salary
SELECT 
    e.employee_id,
    e.first_name,
    e.last_name,
    e.department_id,
    e.salary,
    ROUND((e.salary / dept_totals.total_salary) * 100, 2) AS percent_of_dept_total
FROM 
    employees e
JOIN (
    SELECT 
        department_id, 
        SUM(salary) AS total_salary
    FROM employees
    GROUP BY department_id
) dept_totals ON e.department_id = dept_totals.department_id
ORDER BY e.department_id, percent_of_dept_total DESC;

-- Find employees whose salary is higher than department average
SELECT 
    main.employee_id,
    main.first_name,
    main.last_name,
    main.department_id,
    main.salary,
    dept_avg.avg_salary,
    ROUND(main.salary - dept_avg.avg_salary, 2) AS difference
FROM 
    employees main
JOIN (
    SELECT 
        department_id, 
        AVG(salary) AS avg_salary
    FROM employees
    GROUP BY department_id
) dept_avg ON main.department_id = dept_avg.department_id
WHERE main.salary > dept_avg.avg_salary
ORDER BY difference DESC;

-- Exercise 3: Correlated Subqueries
-- For each employee, find their salary rank within their department
SELECT 
    e.employee_id,
    e.first_name,
    e.last_name,
    e.department_id,
    e.salary,
    (
        SELECT COUNT(*) + 1
        FROM employees e2
        WHERE e2.department_id = e.department_id
        AND e2.salary > e.salary
    ) AS salary_rank_in_dept
FROM employees e
ORDER BY e.department_id, salary_rank_in_dept;

-- Find employees who have the highest salary in their department
SELECT 
    e.employee_id,
    e.first_name,
    e.last_name,
    e.department_id,
    e.salary
FROM employees e
WHERE e.salary = (
    SELECT MAX(salary)
    FROM employees
    WHERE department_id = e.department_id
)
ORDER BY e.department_id;

-- Exercise 4: EXISTS and NOT EXISTS
-- Find departments that have at least one employee with salary > 90000
SELECT 
    d.department_id,
    d.department_name
FROM departments d
WHERE EXISTS (
    SELECT 1
    FROM employees e
    WHERE e.department_id = d.department_id
    AND e.salary > 90000
)
ORDER BY d.department_id;

-- Find employees who don't share a hire year with any other employee
SELECT 
    e1.employee_id,
    e1.first_name,
    e1.last_name,
    e1.hire_date,
    EXTRACT(YEAR FROM e1.hire_date) AS hire_year
FROM employees e1
WHERE NOT EXISTS (
    SELECT 1
    FROM employees e2
    WHERE e2.employee_id != e1.employee_id
    AND EXTRACT(YEAR FROM e2.hire_date) = EXTRACT(YEAR FROM e1.hire_date)
)
ORDER BY e1.hire_date;

-- Exercise 5: Common Table Expressions (CTEs)
-- Calculate department statistics using a CTE
WITH dept_stats AS (
    SELECT 
        department_id,
        COUNT(*) AS employee_count,
        AVG(salary) AS avg_salary,
        MIN(salary) AS min_salary,
        MAX(salary) AS max_salary,
        SUM(salary) AS total_salary
    FROM employees
    GROUP BY department_id
)
SELECT 
    d.department_id,
    d.department_name,
    ds.employee_count,
    ROUND(ds.avg_salary, 2) AS avg_salary,
    ds.min_salary,
    ds.max_salary,
    ds.total_salary
FROM departments d
JOIN dept_stats ds ON d.department_id = ds.department_id
ORDER BY d.department_id;

-- Find employees hired in the same year as the most employees were hired
WITH hire_years AS (
    SELECT 
        EXTRACT(YEAR FROM hire_date) AS year,
        COUNT(*) AS hire_count
    FROM employees
    GROUP BY EXTRACT(YEAR FROM hire_date)
),
max_year AS (
    SELECT year
    FROM hire_years
    ORDER BY hire_count DESC
    LIMIT 1
)
SELECT 
    e.employee_id,
    e.first_name,
    e.last_name,
    e.hire_date,
    EXTRACT(YEAR FROM e.hire_date) AS hire_year
FROM employees e
WHERE EXTRACT(YEAR FROM e.hire_date) = (SELECT year FROM max_year)
ORDER BY e.hire_date;

-- Exercise 6: Recursive CTEs
-- Create a sample hierarchy table
CREATE TABLE employee_hierarchy (
    employee_id SERIAL PRIMARY KEY,
    employee_name VARCHAR(100),
    manager_id INTEGER NULL
);

INSERT INTO employee_hierarchy (employee_id, employee_name, manager_id) VALUES
(1, 'CEO', NULL),
(2, 'CTO', 1),
(3, 'CFO', 1),
(4, 'CIO', 1),
(5, 'Engineering Director', 2),
(6, 'UX Director', 2),
(7, 'Finance Director', 3),
(8, 'IT Director', 4),
(9, 'Senior Engineer', 5),
(10, 'Junior Engineer', 9),
(11, 'UX Designer', 6),
(12, 'Accountant', 7),
(13, 'IT Support', 8);

-- Find all employees under the CTO (employee_id = 2)
WITH RECURSIVE org_hierarchy AS (
    -- Base case: the CTO
    SELECT 
        employee_id, 
        employee_name, 
        manager_id, 
        0 AS level,
        employee_name AS path
    FROM employee_hierarchy
    WHERE employee_id = 2
    
    UNION ALL
    
    -- Recursive case: employees reporting to the current level
    SELECT 
        e.employee_id, 
        e.employee_name, 
        e.manager_id, 
        oh.level + 1,
        oh.path || ' > ' || e.employee_name
    FROM employee_hierarchy e
    JOIN org_hierarchy oh ON e.manager_id = oh.employee_id
)
SELECT 
    employee_id,
    employee_name,
    manager_id,
    level,
    path
FROM org_hierarchy
ORDER BY level, employee_id;

-- Display the entire organizational hierarchy
WITH RECURSIVE full_hierarchy AS (
    -- Base case: employees with no manager (CEO)
    SELECT 
        employee_id, 
        employee_name, 
        manager_id, 
        0 AS level,
        ARRAY[employee_id] AS path_array,
        employee_name AS path
    FROM employee_hierarchy
    WHERE manager_id IS NULL
    
    UNION ALL
    
    -- Recursive case: employees with managers
    SELECT 
        e.employee_id, 
        e.employee_name, 
        e.manager_id, 
        fh.level + 1,
        fh.path_array || e.employee_id,
        fh.path || ' > ' || e.employee_name
    FROM employee_hierarchy e
    JOIN full_hierarchy fh ON e.manager_id = fh.employee_id
)
SELECT 
    employee_id,
    employee_name,
    manager_id,
    level,
    path
FROM full_hierarchy
ORDER BY path_array;

-- Clean up the test table
DROP TABLE employee_hierarchy;
