

# Day 5: Advanced Querying - JOINs

Welcome to Day 5 of our PostgreSQL learning journey! Today, we're diving into **JOINs**, a powerful SQL feature that allows you to combine data from multiple tables based on related columns. JOINs are essential for querying relational databases, as they let you retrieve comprehensive datasets by linking tables together. This document is designed to be beginner-friendly, with clear explanations, practical examples, and exercises to solidify your understanding.

## Topics Covered

1. **Types of JOINs (INNER, LEFT, RIGHT, FULL)**: Understanding the different types of JOINs and when to use them.
2. **JOIN Syntax and Usage**: Learning the structure and mechanics of writing JOIN queries.
3. **Self-JOINs**: Using a table to join with itself to explore hierarchical relationships.
4. **Multi-table JOINs**: Combining three or more tables in a single query.
5. **JOINs with WHERE Conditions**: Filtering JOIN results with specific conditions.
6. **Using Aliases with JOINs**: Simplifying queries with table and column aliases.

## 1. Types of JOINs (INNER, LEFT, RIGHT, FULL)

### Explanation
JOINs combine rows from two or more tables based on a related column (e.g., a foreign key). PostgreSQL supports four main types of JOINs:

- **INNER JOIN**: Returns only the rows where there is a match in both tables.
- **LEFT JOIN** (or LEFT OUTER JOIN): Returns all rows from the left table, and matching rows from the right table. If there's no match, NULL is returned for right table columns.
- **RIGHT JOIN** (or RIGHT OUTER JOIN): Returns all rows from the right table, and matching rows from the left table. If there's no match, NULL is returned for left table columns.
- **FULL JOIN** (or FULL OUTER JOIN): Returns all rows when there is a match in either table. If there's no match, NULL is returned for the non-matching side.

### Setup for Examples
Let's create sample tables to demonstrate JOINs:

```sql
-- Create departments table
CREATE TABLE departments (
    department_id SERIAL PRIMARY KEY,
    department_name VARCHAR(100)
);

-- Create employees table
CREATE TABLE employees (
    employee_id SERIAL PRIMARY KEY,
    first_name VARCHAR(50),
    last_name VARCHAR(50),
    department_id INTEGER REFERENCES departments(department_id),
    salary NUMERIC(10, 2)
);

-- Insert sample data
INSERT INTO departments (department_name)
VALUES 
    ('IT'),
    ('HR'),
    ('Finance'),
    ('Marketing'),
    ('Operations'),
    ('Research');

INSERT INTO employees (first_name, last_name, department_id, salary)
VALUES 
    ('John', 'Doe', 1, 75000),
    ('Jane', 'Smith', 2, 65000),
    ('Michael', 'Johnson', 3, 85000),
    ('Emily', 'Williams', 4, 72000),
    ('Robert', 'Brown', 1, 78000),
    ('Sarah', 'Davis', 2, 67000),
    ('David', 'Miller', 3, 90000),
    ('Jessica', 'Wilson', 4, 74000),
    ('James', 'Taylor', 1, 80000),
    ('Jennifer', 'Anderson', 2, 69000),
    ('Thomas', 'Moore', NULL, 70000);
```

### Example 1: INNER JOIN
An INNER JOIN retrieves rows where there is a match in both tables.

```sql
SELECT 
    e.employee_id,
    e.first_name || ' ' || e.last_name AS employee_name,
    d.department_name,
    e.salary
FROM employees e
INNER JOIN departments d ON e.department_id = d.department_id
ORDER BY e.employee_id;
```
**Explanation**: This query joins `employees` and `departments` where `department_id` matches. Only employees with a valid department are included. Thomas Moore (with `department_id = NULL`) is excluded.

### Example 2: LEFT JOIN
A LEFT JOIN includes all rows from the left table (`employees`), even if there's no match in the right table (`departments`).

```sql
SELECT 
    e.employee_id,
    e.first_name || ' ' || e.last_name AS employee_name,
    d.department_name,
    e.salary
FROM employees e
LEFT JOIN departments d ON e.department_id = d.department_id
ORDER BY e.employee_id;
```
**Explanation**: This query includes all employees, even those without a department (e.g., Thomas Moore). For unmatched rows, `department_name` is NULL.

### Example 3: RIGHT JOIN
A RIGHT JOIN includes all rows from the right table (`departments`), even if there's no match in the left table (`employees`).

```sql
SELECT 
    e.employee_id,
    e.first_name || ' ' || e.last_name AS employee_name,
    d.department_name,
    e.salary
FROM employees e
RIGHT JOIN departments d ON e.department_id = d.department_id
ORDER BY d.department_id;
```
**Explanation**: This query includes all departments, even those with no employees (e.g., Research). For unmatched departments, employee columns are NULL.

### Example 4: FULL JOIN
A FULL JOIN includes all rows from both tables, with NULLs for non-matching rows.

```sql
SELECT 
    e.employee_id,
    e.first_name || ' ' || e.last_name AS employee_name,
    d.department_name,
    e.salary
FROM employees e
FULL JOIN departments d ON e.department_id = d.department_id
ORDER BY d.department_id, e.employee_id;
```
**Explanation**: This query shows all employees and all departments, including employees without departments (e.g., Thomas Moore) and departments without employees (e.g., Research).

### Example 5: Comparing JOIN Types
This example demonstrates how different JOINs affect the result using the same condition.

```sql
-- INNER JOIN (only matching rows)
SELECT 'INNER' AS join_type, e.first_name, d.department_name
FROM employees e
INNER JOIN departments d ON e.department_id = d.department_id
WHERE e.first_name = 'John'
UNION
-- LEFT JOIN (all employees)
SELECT 'LEFT' AS join_type, e.first_name, d.department_name
FROM employees e
LEFT JOIN departments d ON e.department_id = d.department_id
WHERE e.first_name = 'Thomas'
UNION
-- RIGHT JOIN (all departments)
SELECT 'RIGHT' AS join_type, e.first_name, d.department_name
FROM employees e
RIGHT JOIN departments d ON e.department_id = d.department_id
WHERE d.department_name = 'Research';
```
**Explanation**: This query compares JOIN types by showing how John (in IT), Thomas (no department), and Research (no employees) are handled.

## 2. JOIN Syntax and Usage

### Explanation
The basic syntax for a JOIN in PostgreSQL is:

```sql
SELECT columns
FROM table1
[JOIN_TYPE] JOIN table2
ON table1.column = table2.column
[WHERE conditions];
```

- **JOIN_TYPE**: INNER, LEFT, RIGHT, or FULL.
- **ON**: Specifies the condition for matching rows (usually a foreign key relationship).
- Always use table aliases (e.g., `e` for `employees`) to make queries concise and readable.

### Example 1: Simple INNER JOIN
Join employees with their departments.

```sql
SELECT 
    e.first_name,
    e.last_name,
    d.department_name
FROM employees e
INNER JOIN departments d ON e.department_id = d.department_id
WHERE e.salary > 70000;
```

### Example 2: LEFT JOIN with Multiple Conditions
Include all employees, even those without a department, with a salary filter.

```sql
SELECT 
    e.first_name,
    e.last_name,
    d.department_name
FROM employees e
LEFT JOIN departments d ON e.department_id = d.department_id AND d.department_name != 'Operations'
WHERE e.salary >= 70000;
```

### Example 3: RIGHT JOIN with Ordering
List all departments, including those without employees, sorted by department name.

```sql
SELECT 
    d.department_name,
    COUNT(e.employee_id) AS employee_count
FROM employees e
RIGHT JOIN departments d ON e.department_id = d.department_id
GROUP BY d.department_name
ORDER BY d.department_name;
```

### Example 4: FULL JOIN with Aggregation
Count employees per department, including unmatched rows.

```sql
SELECT 
    d.department_name,
    COALESCE(COUNT(e.employee_id), 0) AS employee_count
FROM employees e
FULL JOIN departments d ON e.department_id = d.department_id
GROUP BY d.department_name;
```

### Example 5: JOIN with Multiple Columns
Join tables using multiple columns (hypothetical example with an additional key).

```sql
CREATE TABLE employee_details (
    employee_id INTEGER,
    dept_id INTEGER,
    detail VARCHAR(100),
    FOREIGN KEY (employee_id, dept_id) REFERENCES employees(employee_id, department_id)
);

INSERT INTO employee_details (employee_id, dept_id, detail)
VALUES (1, 1, 'Senior Developer');

SELECT 
    e.first_name,
    d.department_name,
    ed.detail
FROM employees e
INNER JOIN departments d ON e.department_id = d.department_id
INNER JOIN employee_details ed ON e.employee_id = ed.employee_id AND e.department_id = ed.dept_id;
```

## 3. Self-JOINs

### Explanation
A **Self-JOIN** is when a table is joined with itself, useful for hierarchical data (e.g., employees and their managers). The table is aliased twice to distinguish the two instances.

### Setup for Examples
```sql
CREATE TABLE employees_with_managers (
    employee_id SERIAL PRIMARY KEY,
    first_name VARCHAR(50),
    last_name VARCHAR(50),
    manager_id INTEGER REFERENCES employees_with_managers(employee_id),
    title VARCHAR(100)
);

INSERT INTO employees_with_managers (first_name, last_name, manager_id, title)
VALUES 
    ('John', 'CEO', NULL, 'Chief Executive Officer'),
    ('Mary', 'CTO', 1, 'Chief Technology Officer'),
    ('Steve', 'CFO', 1, 'Chief Financial Officer'),
    ('Jane', 'Dev Manager', 2, 'Development Manager'),
    ('Mike', 'Finance Manager', 3, 'Finance Manager'),
    ('Alice', 'Developer', 4, 'Senior Developer'),
    ('Bob', 'Developer', 4, 'Junior Developer'),
    ('Charlie', 'Accountant', 5, 'Senior Accountant');
```

### Example 1: Basic Self-JOIN
List employees and their managers.

```sql
SELECT 
    e.first_name || ' ' || e.last_name AS employee_name,
    e.title,
    m.first_name || ' ' || m.last_name AS manager_name
FROM employees_with_managers e
LEFT JOIN employees_with_managers m ON e.manager_id = m.employee_id;
```

### Example 2: Count Direct Reports
Count how many employees report to each manager.

```sql
SELECT 
    m.first_name || ' ' || m.last_name AS manager_name,
    m.title,
    COUNT(e.employee_id) AS direct_reports
FROM employees_with_managers m
LEFT JOIN employees_with_managers e ON e.manager_id = m.employee_id
GROUP BY m.employee_id, m.first_name, m.last_name, m.title
ORDER BY direct_reports DESC;
```

### Example 3: Filter by Manager Title
List employees whose managers are C-level executives.

```sql
SELECT 
    e.first_name || ' ' || e.last_name AS employee_name,
    e.title,
    m.first_name || ' ' || m.last_name AS manager_name
FROM employees_with_managers e
LEFT JOIN employees_with_managers m ON e.manager_id = m.employee_id
WHERE m.title LIKE 'Chief%';
```

### Example 4: Hierarchical Levels
Identify employees two levels below the CEO.

```sql
SELECT 
    e.first_name || ' ' || e.last_name AS employee_name,
    e.title,
    m1.first_name || ' ' || m1.last_name AS manager_name,
    m2.first_name || ' ' || m2.last_name AS ceo_name
FROM employees_with_managers e
JOIN employees_with_managers m1 ON e.manager_id = m1.employee_id
JOIN employees_with_managers m2 ON m1.manager_id = m2.employee_id
WHERE m2.title = 'Chief Executive Officer';
```

### Example 5: Employees Without Managers
List top-level employees (no manager).

```sql
SELECT 
    e.first_name || ' ' || e.last_name AS employee_name,
    e.title
FROM employees_with_managers e
LEFT JOIN employees_with_managers m ON e.manager_id = m.employee_id
WHERE m.employee_id IS NULL;
```

## 4. Multi-table JOINs

### Explanation
Multi-table JOINs involve combining three or more tables to retrieve complex datasets. Ensure the JOIN conditions are clear to avoid unintended Cartesian products.

### Setup for Examples
```sql
CREATE TABLE projects (
    project_id SERIAL PRIMARY KEY,
    project_name VARCHAR(100),
    department_id INTEGER REFERENCES departments(department_id),
    start_date DATE,
    end_date DATE
);

CREATE TABLE employee_projects (
    employee_id INTEGER REFERENCES employees(employee_id),
    project_id INTEGER REFERENCES projects(project_id),
    role VARCHAR(50),
    PRIMARY KEY (employee_id, project_id)
);

INSERT INTO projects (project_name, department_id, start_date, end_date)
VALUES 
    ('Website Redesign', 1, '2023-01-15', '2023-06-30'),
    ('HR System Update', 2, '2023-02-01', '2023-05-31'),
    ('Financial Reporting Tool', 3, '2023-03-10', '2023-09-30'),
    ('Marketing Campaign', 4, '2023-04-01', '2023-07-31');

INSERT INTO employee_projects (employee_id, project_id, role)
VALUES 
    (1, 1, 'Project Lead'),
    (5, 1, 'Developer'),
    (9, 1,bourbon'),
    (2, 2, 'Project Lead'),
    (6, 2, 'Analyst'),
    (10, 2, 'Tester'),
    (3, 3, 'Project Lead'),
    (7, 3, 'Financial Analyst'),
    (4, 4, 'Project Lead'),
    (8, 4, 'Creative Designer');
```

### Example 1: Basic Multi-table JOIN
List employees, their departments, and projects.

```sql
SELECT 
    e.first_name || ' ' || e.last_name AS employee_name,
    d.department_name,
    p.project_name,
    ep.role
FROM employees e
JOIN departments d ON e.department_id = d.department_id
JOIN employee_projects ep ON e.employee_id = ep.employee_id
JOIN projects p ON ep.project_id = p.project_id
ORDER BY p.project_name;
```

### Example 2: Project Details with Dates
Include project start and end dates.

```sql
SELECT 
    e.first_name || ' ' || e.last_name AS employee_name,
    d.department_name,
    p.project_name,
    ep.role,
    p.start_date,
    p.end_date
FROM employees e
JOIN departments d ON e.department_id = d.department_id
JOIN employee_projects ep ON e.employee_id = ep.employee_id
JOIN projects p ON ep.project_id = p.project_id
WHERE p.end_date > CURRENT_DATE;
```

### Example 3: Employee Project Count
Count projects per employee.

```sql
SELECT 
    e.first_name || ' ' || e.last_name AS employee_name,
    d.department_name,
    COUNT(ep.project_id) AS project_count
FROM employees e
JOIN departments d ON e.department_id = d.department_id
LEFT JOIN employee_projects ep ON e.employee_id = ep.employee_id
LEFT JOIN projects p ON ep.project_id = p.project_id
GROUP BY e.employee_id, e.first_name, e.last_name, d.department_name
ORDER BY project_count DESC;
```

### Example 4: Department Project Summary
Summarize projects by department.

```sql
SELECT 
    d.department_name,
    COUNT(p.project_id) AS project_count,
    AVG(p.end_date - p.start_date) AS avg_project_duration
FROM departments d
LEFT JOIN projects p ON d.department_id = p.department_id
LEFT JOIN employee_projects ep ON p.project_id = ep.project_id
LEFT JOIN employees e ON ep.employee_id = e.employee_id
GROUP BY d.department_name;
```

### Example 5: Employee Roles by Department
List unique roles per department.

```sql
SELECT DISTINCT
    d.department_name,
    ep.role
FROM departments d
JOIN projects p ON d.department_id = p.department_id
JOIN employee_projects ep ON p.project_id = ep.project_id
JOIN employees e ON ep.employee_id = e.employee_id
ORDER BY d.department_name, ep.role;
```

## 5. JOINs with WHERE Conditions

### Explanation
Combining JOINs with WHERE clauses allows you to filter the joined results based on specific conditions.

### Example 1: IT Department Projects
Find IT employees on the Website Redesign project.

```sql
SELECT 
    e.first_name || ' ' || e.last_name AS employee_name,
    d.department_name,
    p.project_name,
    ep.role
FROM employees e
JOIN departments d ON e.department_id = d.department_id
JOIN employee_projects ep ON e.employee_id = ep.employee_id
JOIN projects p ON ep.project_id = p.project_id
WHERE d.department_name = 'IT' AND p.project_name = 'Website Redesign';
```

### Example 2: High Salary Employees
Find employees with salaries above 80000 in specific departments.

```sql
SELECT 
    e.first_name || ' ' || e.last_name AS employee_name,
    d.department_name,
    e.salary
FROM employees e
JOIN departments d ON e.department_id = d.department_id
WHERE e.salary > 80000 AND d.department_name IN ('IT', 'Finance');
```

### Example 3: Active Projects
List employees on projects that are still active.

```sql
SELECT 
    e.first_name || ' ' || e.last_name AS employee_name,
    p.project_name,
    ep.role
FROM employees e
JOIN employee_projects ep ON e.employee_id = ep.employee_id
JOIN projects p ON ep.project_id = p.project_id
WHERE p.end_date > CURRENT_DATE;
```

### Example 4: High-Paid Project Leads
Find project leads with high salaries.

```sql
SELECT 
    e.first_name || ' ' || e.last_name AS employee_name,
    d.department_name,
    p.project_name,
    e.salary
FROM employees e
JOIN departments d ON e.department_id = d.department_id
JOIN employee_projects ep ON e.employee_id = ep.employee_id
JOIN projects p ON ep.project_id = p.project_id
WHERE ep.role = 'Project Lead' AND e.salary > 75000;
```

### Example 5: Non-IT Employees
List employees not in the IT department with project roles.

```sql
SELECT 
    e.first_name || ' ' || e.last_name AS employee_name,
    d.department_name,
    p.project_name,
    ep.role
FROM employees e
JOIN departments d ON e.department_id = d.department_id
JOIN employee_projects ep ON e.employee_id = ep.employee_id
JOIN projects p ON ep.project_id = p.project_id
WHERE d.department_name != 'IT';
```

## 6. Using Aliases with JOINs

### Explanation
Aliases are shorthand names for tables and columns, making queries more readable and easier to write. Use `AS` or simply a space to define aliases.

### Example 1: Basic Alias Usage
Use aliases for clarity.

```sql
SELECT 
    emp.first_name || ' ' || emp.last_name AS full_name,
    dept.department_name AS dept_name
FROM employees AS emp
INNER JOIN departments AS dept ON emp.department_id = dept.department_id;
```

### Example 2: Column Aliases
Alias computed columns for better readability.

```sql
SELECT 
    e.first_name || ' ' || e.last_name AS employee_full_name,
    d.department_name AS dept_name,
    p.project_name AS proj_name,
    ep.role AS employee_role
FROM employees e
JOIN departments d ON e.department_id = d.department_id
JOIN employee_projects ep ON e.employee_id = ep.employee_id
JOIN projects p ON ep.project_id = p.project_id;
```

### Example 3: Aliases in Self-JOIN
Use clear aliases in a self-join.

```sql
SELECT 
    emp.first_name || ' ' || emp.last_name AS emp_name,
    mgr.first_name || ' ' || mgr.last_name AS mgr_name
FROM employees_with_managers emp
LEFT JOIN employees_with_managers mgr ON emp.manager_id = mgr.employee_id;
```

### Example 4: Aliases with Aggregation
Use aliases in aggregated queries.

```sql
SELECT 
    d.department_name AS dept_name,
    COUNT(e.employee_id) AS emp_count
FROM employees e
RIGHT JOIN departments d ON e.department_id = d.department_id
GROUP BY d.department_name
ORDER BY emp_count DESC;
```

### Example 5: Complex Query with Aliases
Use aliases in a multi-table query.

```sql
SELECT 
    emp.first_name || ' ' || emp.last_name AS employee_name,
    dept.department_name AS department,
    proj.project_name AS project,
    eproj.role AS role,
    proj.start_date AS start
FROM employees emp
JOIN departments dept ON emp.department_id = dept.department_id
JOIN employee_projects eproj ON emp.employee_id = eproj.employee_id
JOIN projects proj ON eproj.project_id = proj.project_id
WHERE proj.end_date > CURRENT_DATE;
```

## Practice Exercises

1. **Using the "retail_store" Database**:
   - Join `customers` and `orders` to list customers who have placed orders.
   - Join `orders`, `order_items`, and `products` to show ordered products.
   - Join `products` and `categories` to list products with category names.
   - Join `customers`, `orders`, and `order_items` to find total spent per customer.
   - Join `products`, `order_items`, and `orders` to find the most ordered products.

2. **Self-Referencing Table**:
   - Create a `staff` table with a manager relationship.
   - Query staff and their managers.
   - Find top-level staff (no manager).
   - Count direct reports per manager.
   - List staff two levels below a specific manager.

3. **Advanced JOIN Queries**:
   - Find customers with no orders (LEFT JOIN).
   - Find products never ordered (LEFT JOIN).
   - Find categories with no products (RIGHT JOIN).
   - Find orders with more than 5 items.
   - Find customers who ordered specific products.

4. **Complete Order Report**:
   - Create a report with order ID, date, customer name, product name, category, quantity, unit price, and total price.
   - Filter for orders above a certain total.
   - Include only orders from the last year.
   - Group by customer to show total orders.
   - Sort by total price descending.

5. **Challenge: Total Revenue by Category**:
   - Calculate total revenue per category, including zero-sales categories.
   - Filter for categories with revenue above a threshold.
   - Include average order size per category.
   - List top 5 revenue-generating categories.
   - Show revenue trends over time by category.

## Additional Resources

- [PostgreSQL JOIN Documentation](https://www.postgresql.org/docs/current/tutorial-join.html)
- [Visual Explanation of SQL JOINs](https://blog.codinghorror.com/a-visual-explanation-of-sql-joins/)
- [PostgreSQL Self-Joins](https://www.postgresql.org/docs/current/tutorial-agg.html)
- [SQL JOIN Tutorial](https://www.w3schools.com/sql/sql_join.asp)
- [PostgreSQL Practice Exercises](https://www.sql-ex.ru/)

