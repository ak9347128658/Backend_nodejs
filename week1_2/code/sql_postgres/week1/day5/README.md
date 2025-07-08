# Day 5: Advanced Querying - JOINs

## Topics Covered

1. Types of JOINs (INNER, LEFT, RIGHT, FULL)
2. JOIN syntax and usage
3. Self-JOINs
4. Multi-table JOINs
5. JOINs with WHERE conditions
6. Using aliases with JOINs

## Examples and Exercises

### Example 1: Basic INNER JOIN

```sql
-- Create sample tables
CREATE TABLE departments (
    department_id SERIAL PRIMARY KEY,
    department_name VARCHAR(100)
);

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
    ('Operations');

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
    ('Jennifer', 'Anderson', 2, 69000);

-- INNER JOIN: returns rows when there is a match in both tables
SELECT 
    e.employee_id,
    e.first_name,
    e.last_name,
    d.department_name,
    e.salary
FROM employees e
INNER JOIN departments d ON e.department_id = d.department_id;
```

### Example 2: LEFT JOIN

```sql
-- Insert an employee with no department
INSERT INTO employees (first_name, last_name, department_id, salary)
VALUES ('Thomas', 'Moore', NULL, 70000);

-- LEFT JOIN: returns all rows from the left table and matching rows from the right table
SELECT 
    e.employee_id,
    e.first_name,
    e.last_name,
    d.department_name,
    e.salary
FROM employees e
LEFT JOIN departments d ON e.department_id = d.department_id;
```

### Example 3: RIGHT JOIN

```sql
-- Add a department with no employees
INSERT INTO departments (department_name)
VALUES ('Research');

-- RIGHT JOIN: returns all rows from the right table and matching rows from the left table
SELECT 
    e.employee_id,
    e.first_name,
    e.last_name,
    d.department_name,
    e.salary
FROM employees e
RIGHT JOIN departments d ON e.department_id = d.department_id;
```

### Example 4: FULL JOIN

```sql
-- FULL JOIN: returns rows when there is a match in either the left or right table
SELECT 
    e.employee_id,
    e.first_name,
    e.last_name,
    d.department_name,
    e.salary
FROM employees e
FULL JOIN departments d ON e.department_id = d.department_id;
```

### Example 5: Self-JOIN

```sql
-- Create a table with a self-referencing relationship
CREATE TABLE employees_with_managers (
    employee_id SERIAL PRIMARY KEY,
    first_name VARCHAR(50),
    last_name VARCHAR(50),
    manager_id INTEGER REFERENCES employees_with_managers(employee_id),
    title VARCHAR(100)
);

-- Insert sample data
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

-- Self-JOIN to get employees and their managers
SELECT 
    e.employee_id,
    e.first_name || ' ' || e.last_name AS employee_name,
    e.title AS employee_title,
    m.first_name || ' ' || m.last_name AS manager_name,
    m.title AS manager_title
FROM employees_with_managers e
LEFT JOIN employees_with_managers m ON e.manager_id = m.employee_id;
```

### Example 6: Multi-table JOINs

```sql
-- Create additional tables
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

-- Insert sample data
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
    (9, 1, 'Developer'),
    (2, 2, 'Project Lead'),
    (6, 2, 'Analyst'),
    (10, 2, 'Tester'),
    (3, 3, 'Project Lead'),
    (7, 3, 'Financial Analyst'),
    (4, 4, 'Project Lead'),
    (8, 4, 'Creative Designer');

-- Multi-table JOIN to get employee, department, and project information
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
ORDER BY p.project_name, ep.role;
```

### Example 7: JOINs with WHERE Conditions

```sql
-- Find all IT employees working on the Website Redesign project
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

## Practice Exercises

1. Using the "retail_store" database:
   - Join customers and orders to find which customers have placed orders
   - Join orders, order_items, and products to see what products were ordered
   - Join products and categories to list products with their category names

2. Create a new table called `staff` with a self-referencing relationship for managers, then:
   - Write a query to show each staff member and their manager
   - Find all staff members who don't have a manager (top-level)
   - Find all managers and count how many staff report to each

3. Write advanced JOIN queries:
   - Find customers who have never placed an order (using LEFT JOIN)
   - Find products that have never been ordered (using LEFT JOIN)
   - Find categories that don't have any products (using RIGHT JOIN)

4. Write a multi-table JOIN query to create a complete order report with:
   - Order ID
   - Order date
   - Customer name
   - Product name
   - Category name
   - Quantity
   - Unit price
   - Total item price (quantity * unit price)

5. Challenge: Calculate the total revenue by category. Include all categories, even those with no sales.

## Additional Resources

- [PostgreSQL JOIN Documentation](https://www.postgresql.org/docs/current/tutorial-join.html)
- [Visual Explanation of SQL JOINs](https://blog.codinghorror.com/a-visual-explanation-of-sql-joins/)
- [PostgreSQL Self-Joins](https://www.postgresql.org/docs/current/tutorial-agg.html)
