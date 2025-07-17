

# Day 2: Subqueries and Common Table Expressions (CTEs) in PostgreSQL

This document is designed to help you understand **Subqueries** and **Common Table Expressions (CTEs)** in PostgreSQL. We'll break down each topic with clear explanations, practical examples, and exercises to solidify your understanding. This guide assumes you have a basic understanding of SQL and PostgreSQL, but we'll keep things simple and approachable for beginners.

---

## Topics Covered

1. **Subqueries in WHERE Clause**  
   - Filtering data based on results from another query.
2. **Subqueries in SELECT Clause**  
   - Including computed values from subqueries in your result set.
3. **Subqueries in FROM Clause**  
   - Treating subquery results as temporary tables.
4. **Correlated Subqueries**  
   - Subqueries that reference columns from the outer query.
5. **EXISTS and NOT EXISTS**  
   - Checking for the existence or absence of rows in a subquery.
6. **Common Table Expressions (CTEs)**  
   - Temporary result sets that simplify complex queries.
7. **Recursive CTEs**  
   - Handling hierarchical or recursive data structures.

---

## Setup: Sample Database

To follow along with the examples, we'll use two sample tables: `employees` and `departments`. Below is the SQL to create and populate these tables:

```sql
-- Create employees table
CREATE TABLE employees (
    employee_id SERIAL PRIMARY KEY,
    first_name VARCHAR(50),
    last_name VARCHAR(50),
    department_id INTEGER,
    salary NUMERIC(10, 2),
    hire_date DATE
);

-- Create departments table
CREATE TABLE departments (
    department_id SERIAL PRIMARY KEY,
    department_name VARCHAR(100),
    location VARCHAR(100)
);

-- Insert sample data into departments
INSERT INTO departments (department_name, location)
VALUES 
    ('Engineering', 'Building A'),
    ('Marketing', 'Building B'),
    ('Finance', 'Building C'),
    ('Human Resources', 'Building B');

-- Insert sample data into employees
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
```

Run these commands in your PostgreSQL environment to create the tables and insert the data. We'll use this data for all examples.

---

## Topic 1: Subqueries in WHERE Clause

### Explanation
A **subquery** in the `WHERE` clause is a query nested inside another query, used to filter rows based on the result of the subquery. The subquery runs first, and its result is used to evaluate the condition in the `WHERE` clause of the outer query. Subqueries in `WHERE` clauses are often used with operators like `=`, `>`, `<`, `IN`, or `NOT IN`.

### Why Use It?
- To compare a value against an aggregated result (e.g., average, maximum).
- To filter rows based on data from another table.
- To check membership in a set of values.

### Examples

1. **Find employees with a salary higher than the company-wide average salary**
   ```sql
   SELECT 
       employee_id,
       first_name,
       last_name,
       salary
   FROM employees
   WHERE salary > (SELECT AVG(salary) FROM employees)
   ORDER BY salary DESC;
   ```
   **Explanation**: The subquery `(SELECT AVG(salary) FROM employees)` calculates the average salary across all employees. The outer query then selects employees whose salary exceeds this average.

2. **Find employees in the Engineering department**
   ```sql
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
   ```
   **Explanation**: The subquery retrieves the `department_id` for the Engineering department. The outer query uses this ID to select employees in that department.

3. **Find employees in departments located in Building B**
   ```sql
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
   **Explanation**: The subquery returns a list of `department_id`s for departments in Building B (Marketing and Human Resources). The `IN` operator checks if the employee’s `department_id` is in this list.

4. **Find employees hired before the most recent hire in the company**
   ```sql
   SELECT 
       employee_id,
       first_name,
       last_name,
       hire_date
   FROM employees
   WHERE hire_date < (SELECT MAX(hire_date) FROM employees)
   ORDER BY hire_date;
   ```
   **Explanation**: The subquery finds the latest `hire_date` in the `employees` table. The outer query selects employees hired before this date.

5. **Find employees with a salary greater than the minimum salary in Finance**
   ```sql
   SELECT 
       employee_id,
       first_name,
       last_name,
       salary
   FROM employees
   WHERE salary > (
       SELECT MIN(salary)
       FROM employees
       WHERE department_id = (
           SELECT department_id 
           FROM departments 
           WHERE department_name = 'Finance'
       )
   )
   ORDER BY salary;
   ```
   **Explanation**: The inner subquery finds the `department_id` for Finance. The outer subquery finds the minimum salary in that department. The main query selects employees whose salary exceeds this minimum.

---

## Topic 2: Subqueries in SELECT Clause

### Explanation
A subquery in the `SELECT` clause is used to compute a value for each row in the result set. These subqueries are often **correlated**, meaning they reference a column from the outer query, and they run for each row of the outer query.

### Why Use It?
- To include additional computed data (e.g., department names, averages) in the result set.
- To avoid complex joins when retrieving related data.

### Examples

1. **Display employee info with their department name**
   ```sql
   SELECT 
       e.employee_id,
       e.first_name,
       e.last_name,
       e.salary,
       (SELECT department_name FROM departments WHERE department_id = e.department_id) AS department
   FROM employees e
   ORDER BY e.department_id;
   ```
   **Explanation**: For each employee, the subquery retrieves the `department_name` corresponding to their `department_id`.

2. **Show each employee’s salary and their department’s average salary**
   ```sql
   SELECT 
       e.employee_id,
       e.first_name,
       e.last_name,
       e.salary,
       (SELECT AVG(salary) FROM employees WHERE department_id = e.department_id) AS dept_avg_salary
   FROM employees e
   ORDER BY e.department_id, e.salary DESC;
   ```
   **Explanation**: The subquery calculates the average salary for the employee’s department, which is displayed alongside their details.

3. **Calculate salary difference from department average**
   ```sql
   SELECT 
       e.employee_id,
       e.first_name,
       e.last_name,
       e.salary,
       e.salary - (SELECT AVG(salary) FROM employees WHERE department_id = e.department_id) AS salary_diff
   FROM employees e
   ORDER BY e.department_id, salary_diff DESC;
   ```
   **Explanation**: The subquery computes the department’s average salary, and the outer query subtracts it from the employee’s salary to show the difference.

4. **Show employee’s hire date and days since the earliest hire in their department**
   ```sql
   SELECT 
       e.employee_id,
       e.first_name,
       e.last_name,
       e.hire_date,
       e.hire_date - (SELECT MIN(hire_date) FROM employees WHERE department_id = e.department_id) AS days_since_first_hire
   FROM employees e
   ORDER BY e.department_id, e.hire_date;
   ```
   **Explanation**: The subquery finds the earliest `hire_date` in the employee’s department, and the outer query calculates the difference in days.

5. **Display employee’s name and their department’s location**
   ```sql
   SELECT 
       e.employee_id,
       e.first_name,
       e.last_name,
       (SELECT location FROM departments WHERE department_id = e.department_id) AS dept_location
   FROM employees e
   ORDER BY e.department_id;
   ```
   **Explanation**: The subquery retrieves the `location` of the employee’s department, which is included in the result set.

---

## Topic 3: Subqueries in FROM Clause

### Explanation
A subquery in the `FROM` clause creates a **derived table** (a temporary result set) that can be joined with other tables or used in the main query. This is useful for performing aggregations or transformations before joining with other data.

### Why Use It?
- To simplify complex queries by breaking them into manageable parts.
- To perform aggregations (e.g., averages, counts) and use the results in the main query.

### Examples

1. **Show department statistics (average, min, max salary, and employee count)**
   ```sql
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
   ORDER BY dept_stats.avg_salary DESC;
   ```
   **Explanation**: The subquery creates a derived table with department-level statistics, which is joined with the `departments` table to include department names.

2. **Find employees who earn more than their department’s average salary**
   ```sql
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
   **Explanation**: The subquery calculates the average salary per department, and the main query selects employees whose salary exceeds their department’s average.

3. **Calculate the percentage of department’s total salary for each employee**
   ```sql
   SELECT 
       e.employee_id,
       e.first_name,
       e.last_name,
       e.salary,
       ROUND((e.salary / dept_totals.total_salary) * 100, 2) AS percent_of_dept_total
   FROM employees e
   JOIN (
       SELECT department_id, SUM(salary) AS total_salary
       FROM employees
       GROUP BY department_id
   ) AS dept_totals ON e.department_id = dept_totals.department_id
   ORDER BY e.department_id, percent_of_dept_total DESC;
   ```
   **Explanation**: The subquery computes the total salary per department, and the main query calculates each employee’s salary as a percentage of that total.

4. **List departments with more than 2 employees**
   ```sql
   SELECT 
       d.department_name,
       emp_counts.employee_count
   FROM departments d
   JOIN (
       SELECT department_id, COUNT(*) AS employee_count
       FROM employees
       GROUP BY department_id
   ) AS emp_counts ON d.department_id = emp_counts.department_id
   WHERE emp_counts.employee_count > 2;
   ```
   **Explanation**: The subquery counts employees per department, and the main query filters for departments with more than two employees.

5. **Show employees with salaries above the company median**
   ```sql
   SELECT 
       e.employee_id,
       e.first_name,
       e.last_name,
       e.salary
   FROM employees e
   JOIN (
       SELECT percentile_cont(0.5) WITHIN GROUP (ORDER BY salary) AS median_salary
       FROM employees
   ) AS median ON e.salary > median.median_salary
   ORDER BY e.salary DESC;
   ```
   **Explanation**: The subquery calculates the median salary across all employees, and the main query selects employees whose salary exceeds this median.

---

## Topic 4: Correlated Subqueries

### Explanation
A **correlated subquery** is a subquery that references columns from the outer query. It runs repeatedly for each row of the outer query, making it slower but powerful for row-by-row comparisons.

### Why Use It?
- To compare each row against a dynamic condition based on related data.
- To find records that meet criteria relative to their group (e.g., highest salary in a department).

### Examples

1. **Find employees with the highest salary in their department**
   ```sql
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
   ```
   **Explanation**: For each employee, the subquery finds the maximum salary in their department. The outer query checks if the employee’s salary matches this maximum.

2. **Find employees hired first in their department**
   ```sql
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
   **Explanation**: The subquery finds the earliest `hire_date` in the employee’s department, and the outer query selects employees with that date.

3. **Rank employees by salary within their department**
   ```sql
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
       ) AS salary_rank
   FROM employees e
   ORDER BY e.department_id, salary_rank;
   ```
   **Explanation**: The subquery counts how many employees in the same department have a higher salary, adding 1 to determine the rank.

4. **Find employees whose salary is above their department’s minimum by 20%**
   ```sql
   SELECT 
       e.employee_id,
       e.first_name,
       e.last_name,
       e.salary
   FROM employees e
   WHERE e.salary > (
       SELECT MIN(salary) * 1.2
       FROM employees e2
       WHERE e2.department_id = e.department_id
   )
   ORDER BY e.department_id, e.salary;
   ```
   **Explanation**: The subquery finds the minimum salary in the employee’s department and multiplies it by 1.2. The outer query selects employees whose salary exceeds this value.

5. **Find employees hired within 6 months of their department’s first hire**
   ```sql
   SELECT 
       e.employee_id,
       e.first_name,
       e.last_name,
       e.hire_date
   FROM employees e
   WHERE e.hire_date <= (
       SELECT MIN(hire_date) + INTERVAL '6 months'
       FROM employees e2
       WHERE e2.department_id = e.department_id
   )
   ORDER BY e.department_id, e.hire_date;
   ```
   **Explanation**: The subquery finds the earliest `hire_date` in the department and adds 6 months. The outer query selects employees hired within that period.

---

## Topic 5: EXISTS and NOT EXISTS

### Explanation
The `EXISTS` operator checks if a subquery returns at least one row, while `NOT EXISTS` checks if a subquery returns no rows. These are often used in correlated subqueries to test for the presence or absence of related data.

### Why Use It?
- To filter rows based on whether related data exists.
- To identify records with or without matching records in another table.

### Examples

1. **Find departments with at least one employee**
   ```sql
   SELECT 
       d.department_id,
       d.department_name
   FROM departments d
   WHERE EXISTS (
       SELECT 1
       FROM employees e
       WHERE e.department_id = d.department_id
   )
   ORDER BY d.department_id;
   ```
   **Explanation**: The subquery checks if there is at least one employee in the department. If true, the department is included in the result.

2. **Find departments with no employees**
   ```sql
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
   **Explanation**: The subquery checks for employees in the department. If no employees are found, the department is included.

3. **Find departments with employees earning over 90000**
   ```sql
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
   ```
   **Explanation**: The subquery checks for employees in the department with a salary above 90000. Departments with such employees are selected.

4. **Find employees who don’t share a hire year with others**
   ```sql
   SELECT 
       e.employee_id,
       e.first_name,
       e.last_name,
       EXTRACT(YEAR FROM e.hire_date) AS hire_year
   FROM employees e
   WHERE NOT EXISTS (
       SELECT 1
       FROM employees e2
       WHERE e2.employee_id != e.employee_id
       AND EXTRACT(YEAR FROM e2.hire_date) = EXTRACT(YEAR FROM e.hire_date)
   )
   ORDER BY hire_year;
   ```
   **Explanation**: The subquery checks if any other employee was hired in the same year. If none exist, the employee is included.

5. **Find departments with employees hired in 2020**
   ```sql
   SELECT 
       d.department_id,
       d.department_name
   FROM departments d
   WHERE EXISTS (
       SELECT 1
       FROM employees e
       WHERE e.department_id = d.department_id
       AND EXTRACT(YEAR FROM e.hire_date) = 2020
   )
   ORDER BY d.department_id;
   ```
   **Explanation**: The subquery checks for employees hired in 2020 in each department. Departments with such employees are returned.

---

## Topic 6: Common Table Expressions (CTEs)

### Explanation
A **Common Table Expression (CTE)** is a temporary result set defined within a `WITH` clause. It can be referenced multiple times in the main query, making complex queries more readable and maintainable.

### Why Use It?
- To break down complex queries into reusable parts.
- To improve query readability and organization.
- To perform calculations that need to be reused in multiple parts of a query.

### Examples

1. **Calculate department statistics**
   ```sql
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
       ROUND(ds.avg_salary, 2) AS avg_salary,
       ds.total_salary
   FROM dept_stats ds
   JOIN departments d ON ds.department_id = d.department_id
   ORDER BY ds.total_salary DESC;
   ```
   **Explanation**: The CTE `dept_stats` computes department-level statistics, which are joined with the `departments` table to include department names.

2. **Find employees earning more than 10% above their department’s average**
   ```sql
   WITH dept_avg_salary AS (
       SELECT 
           department_id, 
           AVG(salary) AS avg_salary
       FROM employees
       GROUP BY department_id
   )
   SELECT 
       e.employee_id,
       e.first_name,
       e.last_name,
       e.salary,
       d.department_name,
       das.avg_salary,
       e.salary - das.avg_salary AS salary_difference
   FROM employees e
   JOIN departments d ON e.department_id = d.department_id
   JOIN dept_avg_salary das ON e.department_id = das.department_id
   WHERE e.salary > das.avg_salary * 1.1
   ORDER BY salary_difference DESC;
   ```
   **Explanation**: The CTE calculates the average salary per department, and the main query selects employees whose salary is more than 10% above this average.

3. **Rank employees by hire date within their department**
   ```sql
   WITH hire_rank AS (
       SELECT 
           employee_id,
           first_name,
           last_name,
           department_id,
           hire_date,
           RANK() OVER (PARTITION BY department_id ORDER BY hire_date) AS hire_rank
       FROM employees
   )
   SELECT 
       hr.employee_id,
       hr.first_name,
       hr.last_name,
       d.department_name,
       hr.hire_date,
       hr.hire_rank
   FROM hire_rank hr
   JOIN departments d ON hr.department_id = d.department_id
   WHERE hr.hire_rank = 1;
   ```
   **Explanation**: The CTE assigns a rank to employees based on their hire date within their department. The main query selects the first hired employee per department.

4. **Calculate running total of salaries by department**
   ```sql
   WITH salary_sums AS (
       SELECT 
           employee_id,
           first_name,
           last_name,
           department_id,
           salary,
           SUM(salary) OVER (PARTITION BY department_id ORDER BY salary) AS running_total
       FROM employees
   )
   SELECT 
       ss.employee_id,
       ss.first_name,
       ss.last_name,
       d.department_name,
       ss.salary,
       ss.running_total
   FROM salary_sums ss
   JOIN departments d ON ss.department_id = d.department_id
   ORDER BY d.department_name, ss.salary;
   ```
   **Explanation**: The CTE uses a window function to calculate a running total of salaries within each department, ordered by salary.

5. **Find departments with above-average employee count**
   ```sql
   WITH dept_counts AS (
       SELECT 
           department_id,
           COUNT(*) AS employee_count
       FROM employees
       GROUP BY department_id
   )
   SELECT 
       d.department_name,
       dc.employee_count
   FROM dept_counts dc
   JOIN departments d ON dc.department_id = d.department_id
   WHERE dc.employee_count > (
       SELECT AVG(employee_count) 
       FROM dept_counts
   )
   ORDER BY dc.employee_count DESC;
   ```
   **Explanation**: The CTE counts employees per department, and the main query selects departments with an employee count above the average across all departments.

---

## Topic 7: Recursive CTEs

### Explanation
A **Recursive CTE** is a CTE that refers to itself, used to handle hierarchical or recursive data (e.g., organizational charts, category trees). It consists of a **base case** (initial rows) and a **recursive case** (rows derived from previous results).

### Setup: Hierarchical Table
```sql
CREATE TABLE employees_hierarchy (
    employee_id SERIAL PRIMARY KEY,
    name VARCHAR(100),
    manager_id INTEGER REFERENCES employees_hierarchy(employee_id),
    level VARCHAR(50)
);

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
```

### Examples

1. **Traverse the entire employee hierarchy**
   ```sql
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
       
       -- Recursive case: employees reporting to previous level
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
   ```
   **Explanation**: The base case selects the CEO (no manager). The recursive case joins employees with their managers from the previous level, building a path string.

2. **Find all reports under the CTO (employee_id = 2)**
   ```sql
   WITH RECURSIVE subordinates AS (
       -- Base case: direct reports to CTO
       SELECT 
           employee_id, 
           name, 
           manager_id, 
           level,
           1 AS depth
       FROM employees_hierarchy
       WHERE manager_id = 2
       
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
   **Explanation**: The base case selects direct reports of the CTO. The recursive case finds their reports, continuing down the hierarchy.

3. **Count employees under each manager**
   ```sql
   WITH RECURSIVE hierarchy AS (
       SELECT 
           employee_id, 
           name, 
           manager_id,
           1 AS report_count
       FROM employees_hierarchy
       WHERE manager_id IS NULL
       
       UNION ALL
       
       SELECT 
           e.employee_id, 
           e.name, 
           e.manager_id,
           1 AS report_count
       FROM employees_hierarchy e
       JOIN hierarchy h ON e.manager_id = h.employee_id
   )
   SELECT 
       h.manager_id,
       (SELECT name FROM employees_hierarchy WHERE employee_id = h.manager_id) AS manager_name,
       COUNT(*) AS total_reports
   FROM hierarchy h
   WHERE h.manager_id IS NOT NULL
   GROUP BY h.manager_id
   ORDER BY total_reports DESC;
   ```
   **Explanation**: The CTE builds the hierarchy, and the main query counts the number of direct and indirect reports for each manager.

4. **Show hierarchy with level indentation**
   ```sql
   WITH RECURSIVE employee_tree AS (
       SELECT 
           employee_id, 
           name, 
           manager_id, 
           level,
           0 AS depth,
           name AS path
       FROM employees_hierarchy
       WHERE manager_id IS NULL
       
       UNION ALL
       
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
       REPEAT('  ', depth) || name AS indented_name,
       level,
       depth,
       path
   FROM employee_tree
   ORDER BY path;
   ```
   **Explanation**: The CTE builds the hierarchy, and the `REPEAT` function indents names based on their depth for a visual representation.

5. **Find the deepest level in the hierarchy**
   ```sql
   WITH RECURSIVE employee_tree AS (
       SELECT 
           employee_id, 
           name, 
           manager_id, 
           level,
           1 AS depth
       FROM employees_hierarchy
       WHERE manager_id IS NULL
       
       UNION ALL
       
       SELECT 
           e.employee_id, 
           e.name, 
           e.manager_id, 
           e.level,
           et.depth + 1
       FROM employees_hierarchy e
       JOIN employee_tree et ON e.manager_id = et.employee_id
   )
   SELECT 
       employee_id,
       name,
       level,
       depth
   FROM employee_tree
   WHERE depth = (SELECT MAX(depth) FROM employee_tree)
   ORDER BY name;
   ```
   **Explanation**: The CTE calculates the depth of each employee in the hierarchy. The main query selects employees at the maximum depth.

---

## Practice Exercises

To reinforce your learning, try these exercises using the `retail_store` database (assume it has tables: `products`, `orders`, `order_details`, `customers`, `categories`).

1. **Subqueries in WHERE Clause**
   - Find products with a price higher than the average price.
   - Find orders with a total amount greater than the average order amount.
   - Find customers who have placed more than the average number of orders.
   - Find products in the category with the most products.
   - Find orders containing the most expensive product.

2. **Subqueries in SELECT Clause**
   - Display each order with its customer’s name.
   - Show each product’s price and its category’s average price.
   - Calculate the discount percentage for each order (assuming a discount column).
   - Show each customer’s total spending and the average spending across all customers.
   - Display each product with the number of orders it appears in.

3. **Subqueries in FROM Clause**
   - Calculate the total revenue per category.
   - Find customers who spent more than their city’s average spending.
   - List products with above-average order quantities.
   - Show categories with more than 5 products.
   - Calculate the percentage of total sales each order represents.

4. **Correlated Subqueries**
   - Find the most recent order for each customer.
   - Find the product with the highest price in each category.
   - Find customers who have ordered all products in a specific category.
   - Rank orders by total amount within each customer.
   - Find products ordered more frequently than their category’s average.

5. **EXISTS and NOT EXISTS**
   - Find customers who have never placed an order.
   - Find products that have never been ordered.
   - Find customers who have ordered a specific product.
   - Find customers who have placed orders in all categories.
   - Find categories with no products under a certain price.

6. **Common Table Expressions (CTEs)**
   - Calculate the running total of orders by date.
   - Find customers who spend more than the average customer.
   - Rank products by price within each category.
   - Calculate the percentage of total revenue each product represents.
   - Find the top 3 orders by amount per month.

7. **Recursive CTEs**
   - Create a product category hierarchy table and display the full category path for each product.
   - Find all subcategories under a specific parent category.
   - Count the number of products in each category and its subcategories.
   - Show the hierarchy of product categories with indentation.
   - Find the deepest level of the category hierarchy.

---

## Additional Resources

- [PostgreSQL Subquery Documentation](https://www.postgresql.org/docs/current/queries-subqueries.html)
- [PostgreSQL CTE Documentation](https://www.postgresql.org/docs/current/queries-with.html)
- [PostgreSQL Recursive Queries Documentation](https://www.postgresql.org/docs/current/queries-with.html#QUERIES-WITH-RECURSIVE)
- [SQL Tutorial by Mode Analytics](https://mode.com/sql-tutorial/)
- [PostgreSQL Exercises](https://pgexercises.com/)

---

This guide provides a comprehensive introduction to subqueries and CTEs in PostgreSQL, with detailed explanations and practical examples. Work through the examples and exercises to build your skills, and refer to the additional resources for further learning.

