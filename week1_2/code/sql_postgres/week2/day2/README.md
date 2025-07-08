# Day 2: Subqueries and Common Table Expressions (CTEs)

## Topics Covered

1. Subqueries in SELECT, FROM, and WHERE clauses
2. Correlated subqueries
3. EXISTS and NOT EXISTS
4. Common Table Expressions (CTEs)
5. Recursive CTEs
6. Using CTEs for complex queries

## Examples and Exercises

### Example 1: Subqueries in WHERE Clause

```sql
-- Create and populate sample tables
CREATE TABLE employees (
    employee_id SERIAL PRIMARY KEY,
    first_name VARCHAR(50),
    last_name VARCHAR(50),
    department_id INTEGER,
    salary NUMERIC(10, 2),
    hire_date DATE
);

CREATE TABLE departments (
    department_id SERIAL PRIMARY KEY,
    department_name VARCHAR(100),
    location VARCHAR(100)
);

-- Insert sample data
INSERT INTO departments (department_name, location)
VALUES 
    ('Engineering', 'Building A'),
    ('Marketing', 'Building B'),
    ('Finance', 'Building C'),
    ('Human Resources', 'Building B');

INSERT INTO employees (first_name, last_name, department_id, salary, hire_date)
VALUES 
    ('John', 'Smith', 1, 85000, '2020-06-15'),
    ('Emma', 'Johnson', 1, 92000, '2019-04-20'),
    ('Michael', 'Williams', 2, 78000, '2021-02-10'),
    ('Sophia', 'Brown', 2, 81000, '2018-11-05'),
    ('James', 'Jones', 3, 105000, '2017-08-12'),
    ('Olivia', 'Miller', 3, 95000, '2019-07-22'),
    ('William', 'Davis', 4, 72000, '2020-03-18'),
    ('Ava', 'Garcia', 4, 68000, '2021-01-15'),
    ('Alexander', 'Rodriguez', 1, 89000, '2018-05-28'),
    ('Emily', 'Wilson', 2, 76000, '2020-09-03');

-- Find employees with salary higher than average
SELECT 
    employee_id,
    first_name,
    last_name,
    salary
FROM employees
WHERE salary > (SELECT AVG(salary) FROM employees)
ORDER BY salary DESC;

-- Find employees in the Engineering department
SELECT 
    employee_id,
    first_name,
    last_name,
    salary
FROM employees
WHERE department_id = (
    SELECT department_id 
    FROM departments 
    WHERE department_name = 'Engineering'
);

-- Find employees in departments located in Building B
SELECT 
    employee_id,
    first_name,
    last_name,
    department_id
FROM employees
WHERE department_id IN (
    SELECT department_id 
    FROM departments 
    WHERE location = 'Building B'
);
```

### Example 2: Subqueries in SELECT Clause

```sql
-- Display employee info with department name and department average salary
SELECT 
    e.employee_id,
    e.first_name,
    e.last_name,
    e.salary,
    (SELECT department_name FROM departments WHERE department_id = e.department_id) AS department,
    (SELECT AVG(salary) FROM employees WHERE department_id = e.department_id) AS dept_avg_salary
FROM employees e
ORDER BY e.department_id, e.salary DESC;

-- Calculate salary difference from department average
SELECT 
    e.employee_id,
    e.first_name,
    e.last_name,
    e.department_id,
    e.salary,
    e.salary - (
        SELECT AVG(salary) 
        FROM employees 
        WHERE department_id = e.department_id
    ) AS salary_diff_from_dept_avg
FROM employees e
ORDER BY e.department_id, salary_diff_from_dept_avg DESC;
```

### Example 3: Subqueries in FROM Clause

```sql
-- Use a subquery to create a derived table of department statistics
SELECT 
    d.department_name,
    dept_stats.avg_salary,
    dept_stats.min_salary,
    dept_stats.max_salary,
    dept_stats.employee_count
FROM departments d
JOIN (
    SELECT 
        department_id,
        AVG(salary) AS avg_salary,
        MIN(salary) AS min_salary,
        MAX(salary) AS max_salary,
        COUNT(*) AS employee_count
    FROM employees
    GROUP BY department_id
) AS dept_stats ON d.department_id = dept_stats.department_id
ORDER BY avg_salary DESC;

-- Find employees who earn more than their department average
SELECT 
    e.employee_id,
    e.first_name,
    e.last_name,
    e.salary,
    d.department_name,
    dept_avgs.avg_salary
FROM employees e
JOIN departments d ON e.department_id = d.department_id
JOIN (
    SELECT department_id, AVG(salary) AS avg_salary
    FROM employees
    GROUP BY department_id
) AS dept_avgs ON e.department_id = dept_avgs.department_id
WHERE e.salary > dept_avgs.avg_salary
ORDER BY d.department_name, e.salary DESC;
```

### Example 4: Correlated Subqueries

```sql
-- Find employees with the highest salary in their department
SELECT 
    e.employee_id,
    e.first_name,
    e.last_name,
    e.department_id,
    e.salary
FROM employees e
WHERE e.salary = (
    SELECT MAX(salary)
    FROM employees e2
    WHERE e2.department_id = e.department_id
)
ORDER BY e.department_id;

-- Find employees hired first in their department
SELECT 
    e.employee_id,
    e.first_name,
    e.last_name,
    e.department_id,
    e.hire_date
FROM employees e
WHERE e.hire_date = (
    SELECT MIN(hire_date)
    FROM employees e2
    WHERE e2.department_id = e.department_id
)
ORDER BY e.department_id;
```

### Example 5: EXISTS and NOT EXISTS

```sql
-- Find departments that have at least one employee
SELECT 
    d.department_id,
    d.department_name
FROM departments d
WHERE EXISTS (
    SELECT 1
    FROM employees e
    WHERE e.department_id = d.department_id
);

-- Find departments that have no employees
SELECT 
    d.department_id,
    d.department_name
FROM departments d
WHERE NOT EXISTS (
    SELECT 1
    FROM employees e
    WHERE e.department_id = d.department_id
);
```

### Example 6: Common Table Expressions (CTEs)

```sql
-- Basic CTE to calculate department statistics
WITH dept_stats AS (
    SELECT 
        department_id,
        COUNT(*) AS employee_count,
        AVG(salary) AS avg_salary,
        SUM(salary) AS total_salary
    FROM employees
    GROUP BY department_id
)
SELECT 
    d.department_name,
    ds.employee_count,
    ds.avg_salary,
    ds.total_salary
FROM dept_stats ds
JOIN departments d ON ds.department_id = d.department_id
ORDER BY ds.total_salary DESC;

-- Multiple CTEs in a single query
WITH 
dept_avg_salary AS (
    SELECT 
        department_id, 
        AVG(salary) AS avg_salary
    FROM employees
    GROUP BY department_id
),
high_earners AS (
    SELECT 
        e.employee_id,
        e.first_name,
        e.last_name,
        e.department_id,
        e.salary
    FROM employees e
    JOIN dept_avg_salary das ON e.department_id = das.department_id
    WHERE e.salary > das.avg_salary * 1.1
)
SELECT 
    he.employee_id,
    he.first_name,
    he.last_name,
    d.department_name,
    he.salary,
    das.avg_salary AS dept_avg_salary,
    he.salary - das.avg_salary AS salary_difference
FROM high_earners he
JOIN departments d ON he.department_id = d.department_id
JOIN dept_avg_salary das ON he.department_id = das.department_id
ORDER BY salary_difference DESC;
```

### Example 7: Recursive CTEs

```sql
-- Create a table with hierarchical data
CREATE TABLE employees_hierarchy (
    employee_id SERIAL PRIMARY KEY,
    name VARCHAR(100),
    manager_id INTEGER REFERENCES employees_hierarchy(employee_id),
    level VARCHAR(50)
);

-- Insert sample data
INSERT INTO employees_hierarchy (employee_id, name, manager_id, level)
VALUES 
    (1, 'John CEO', NULL, 'CEO'),
    (2, 'Mary CTO', 1, 'CTO'),
    (3, 'Steve CFO', 1, 'CFO'),
    (4, 'Jane Engineering Director', 2, 'Director'),
    (5, 'Mike Finance Director', 3, 'Director'),
    (6, 'Sarah Engineering Manager', 4, 'Manager'),
    (7, 'Tom Finance Manager', 5, 'Manager'),
    (8, 'Alex Developer', 6, 'Staff'),
    (9, 'Lisa Developer', 6, 'Staff'),
    (10, 'Kevin Accountant', 7, 'Staff'),
    (11, 'Rachel Developer', 6, 'Staff'),
    (12, 'David Accountant', 7, 'Staff');

-- Simple recursive CTE to traverse employee hierarchy
WITH RECURSIVE employee_tree AS (
    -- Base case: CEO (no manager)
    SELECT 
        employee_id, 
        name, 
        manager_id, 
        level,
        1 AS depth,
        name AS path
    FROM employees_hierarchy
    WHERE manager_id IS NULL
    
    UNION ALL
    
    -- Recursive case: join employees with their managers
    SELECT 
        e.employee_id, 
        e.name, 
        e.manager_id, 
        e.level,
        et.depth + 1,
        et.path || ' > ' || e.name
    FROM employees_hierarchy e
    JOIN employee_tree et ON e.manager_id = et.employee_id
)
SELECT 
    employee_id,
    name,
    level,
    depth,
    path
FROM employee_tree
ORDER BY path;

-- Find all reports (direct and indirect) for a specific manager
WITH RECURSIVE subordinates AS (
    -- Base case: direct reports to manager with ID 4 (Jane)
    SELECT 
        employee_id, 
        name, 
        manager_id, 
        level,
        1 AS depth
    FROM employees_hierarchy
    WHERE manager_id = 4
    
    UNION ALL
    
    -- Recursive case: reports of reports
    SELECT 
        e.employee_id, 
        e.name, 
        e.manager_id, 
        e.level,
        s.depth + 1
    FROM employees_hierarchy e
    JOIN subordinates s ON e.manager_id = s.employee_id
)
SELECT 
    employee_id,
    name,
    level,
    depth
FROM subordinates
ORDER BY depth, name;
```

## Practice Exercises

1. Using the "retail_store" database:
   - Find all products with a price higher than the average price
   - Find orders with a total amount greater than the average order amount
   - Find all customers who have placed more than the average number of orders
   - Find products that belong to the category with the most products
   - Find orders that contain the most expensive product

2. Write queries using correlated subqueries:
   - Find the most recent order for each customer
   - Find the product with the highest price in each category
   - Find customers who have ordered all products in a specific category

3. Use EXISTS and NOT EXISTS:
   - Find customers who have never placed an order
   - Find products that have never been ordered
   - Find customers who have ordered a specific product
   - Find customers who have placed orders in all categories

4. Write queries using CTEs:
   - Calculate the running total of orders by date
   - Find customers who spend more than the average customer
   - Rank products by price within each category
   - Calculate the percentage of total revenue that each product represents

5. Challenge: Create a recursive CTE to handle a product category hierarchy (assuming categories can have subcategories) and display the full category path for each product.

## Additional Resources

- [PostgreSQL Subquery Documentation](https://www.postgresql.org/docs/current/queries-subqueries.html)
- [PostgreSQL CTE Documentation](https://www.postgresql.org/docs/current/queries-with.html)
- [PostgreSQL Recursive Queries Documentation](https://www.postgresql.org/docs/current/queries-with.html#QUERIES-WITH-RECURSIVE)
