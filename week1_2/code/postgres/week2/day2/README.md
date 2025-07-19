

# Day 2: Subqueries and Common Table Expressions (CTEs) in PostgreSQL

This document introduces **Subqueries** and **Common Table Expressions (CTEs)** in PostgreSQL, designed to help students understand these concepts through clear explanations, practical examples, and visual Mermaid.js diagrams. The guide assumes a basic understanding of SQL and PostgreSQL but is beginner-friendly.

---

## Topics Covered

1. **Subqueries in WHERE Clause**  
   - Filtering data based on results from another query.
2. **Subqueries in SELECT Clause**  
   - Including computed values from subqueries in the result set.
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

We'll use two sample tables: `employees` and `departments`. Below is the SQL to create and populate these tables:

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

Run these commands in your PostgreSQL environment to set up the tables. These tables will be used in all examples.

---

## Topic 1: Subqueries in WHERE Clause

### Explanation
A subquery in the `WHERE` clause is a nested query that filters rows based on its results. It runs first, and its output is used by the outer query's `WHERE` condition, often with operators like `=`, `>`, `<`, `IN`, or `NOT IN`.

### Why Use It?
- Compare values against aggregates (e.g., average salary).
- Filter based on data from another table.
- Check membership in a set of values.

### Examples

1. **Find employees with a salary higher than the company-wide average**
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
   **Explanation**: The subquery calculates the average salary. The outer query selects employees with salaries above this average.
   ```mermaid
   graph TD
       A[Outer Query: SELECT ... FROM employees] -->|WHERE salary >| B[Subquery: SELECT AVG(salary) FROM employees]
       B -->|Returns average| C[Filter employees]
       C -->|Output| D[Result: Employees with above-average salary]
   ```

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
   **Explanation**: The subquery retrieves the `department_id` for Engineering, used to filter employees in the outer query.
   ```mermaid
   graph TD
       A[Outer Query: SELECT ... FROM employees] -->|WHERE department_id =| B[Subquery: SELECT department_id FROM departments]
       B -->|Returns department_id| C[Filter employees]
       C -->|Output| D[Result: Engineering employees]
   ```

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
   **Explanation**: The subquery returns `department_id`s for departments in Building B, and the outer query uses `IN` to filter employees.
   ```mermaid
   graph TD
       A[Outer Query: SELECT ... FROM employees] -->|WHERE department_id IN| B[Subquery: SELECT department_id FROM departments]
       B -->|Returns list of department_ids| C[Filter employees]
       C -->|Output| D[Result: Employees in Building B]
   ```

4. **Find employees hired before the most recent hire**
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
   **Explanation**: The subquery finds the latest `hire_date`, and the outer query selects employees hired before it.
   ```mermaid
   graph TD
       A[Outer Query: SELECT ... FROM employees] -->|WHERE hire_date <| B[Subquery: SELECT MAX(hire_date) FROM employees]
       B -->|Returns latest hire_date| C[Filter employees]
       C -->|Output| D[Result: Employees before latest hire]
   ```

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
   **Explanation**: The inner subquery finds the `department_id` for Finance, the outer subquery finds the minimum salary in Finance, and the main query selects employees with higher salaries.
   ```mermaid
   graph TD
       A[Outer Query: SELECT ... FROM employees] -->|WHERE salary >| B[Subquery: SELECT MIN(salary) FROM employees]
       B -->|WHERE department_id =| C[Subquery: SELECT department_id FROM departments]
       C -->|Returns Finance department_id| B
       B -->|Returns min salary| D[Filter employees]
       D -->|Output| E[Result: Employees above Finance min salary]
   ```

---

## Topic 2: Subqueries in SELECT Clause

### Explanation
A subquery in the `SELECT` clause computes a value for each row in the result set. These are often **correlated**, referencing columns from the outer query and running for each row.

### Why Use It?
- Include related data (e.g., department names) without joins.
- Compute row-specific values (e.g., differences from averages).

### Examples

1. **Display employee info with department name**
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
   **Explanation**: The subquery retrieves the `department_name` for each employee’s `department_id`.
   ```mermaid
   graph TD
       A[Outer Query: SELECT ... FROM employees e] -->|For each row| B[Subquery: SELECT department_name FROM departments]
       B -->|Returns department_name| C[Add to result]
       C -->|Output| D[Result: Employees with department names]
   ```

2. **Show employee’s salary and department average**
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
   **Explanation**: The subquery calculates the average salary for each employee’s department.
   ```mermaid
   graph TD
       A[Outer Query: SELECT ... FROM employees e] -->|For each row| B[Subquery: SELECT AVG(salary) FROM employees]
       B -->|Returns dept avg salary| C[Add to result]
       C -->|Output| D[Result: Employees with dept avg salary]
   ```

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
   **Explanation**: The subquery computes the department’s average salary, and the outer query calculates the difference.
   ```mermaid
   graph TD
       A[Outer Query: SELECT ... FROM employees e] -->|For each row| B[Subquery: SELECT AVG(salary) FROM employees]
       B -->|Returns dept avg salary| C[Calculate salary_diff]
       C -->|Output| D[Result: Employees with salary difference]
   ```

4. **Show days since earliest hire in department**
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
   **Explanation**: The subquery finds the earliest `hire_date` in the department, and the outer query calculates the difference in days.
   ```mermaid
   graph TD
       A[Outer Query: SELECT ... FROM employees e] -->|For each row| B[Subquery: SELECT MIN(hire_date) FROM employees]
       B -->|Returns earliest hire_date| C[Calculate days_since_first_hire]
       C -->|Output| D[Result: Employees with days since first hire]
   ```

5. **Display department location**
   ```sql
   SELECT 
       e.employee_id,
       e.first_name,
       e.last_name,
       (SELECT location FROM departments WHERE department_id = e.department_id) AS dept_location
   FROM employees e
   ORDER BY e.department_id;
   ```
   **Explanation**: The subquery retrieves the department’s `location` for each employee.
   ```mermaid
   graph TD
       A[Outer Query: SELECT ... FROM employees e] -->|For each row| B[Subquery: SELECT location FROM departments]
       B -->|Returns dept location| C[Add to result]
       C -->|Output| D[Result: Employees with dept location]
   ```

---

## Topic 3: Subqueries in FROM Clause

### Explanation
A subquery in the `FROM` clause creates a **derived table** (temporary result set) that can be joined or used like a table in the main query.

### Why Use It?
- Simplify complex queries by breaking them into steps.
- Perform aggregations before joining with other tables.

### Examples

1. **Show department statistics**
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
   **Explanation**: The subquery creates a derived table with department statistics, joined with `departments` to include names.
   ```mermaid
   graph TD
       A[Subquery: SELECT ... FROM employees GROUP BY department_id] -->|Derived Table: dept_stats| B[Outer Query: JOIN with departments]
       B -->|Output| C[Result: Department statistics]
   ```

2. **Find employees above department average**
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
   **Explanation**: The subquery calculates department averages, and the main query selects employees above their department’s average.
   ```mermaid
   graph TD
       A[Subquery: SELECT AVG(salary) FROM employees GROUP BY department_id] -->|Derived Table: dept_avgs| B[Outer Query: JOIN with employees, departments]
       B -->|WHERE salary > avg_salary| C[Filter employees]
       C -->|Output| D[Result: Employees above dept average]
   ```

3. **Calculate salary percentage of department total**
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
   **Explanation**: The subquery computes total salary per department, and the main query calculates each employee’s percentage.
   ```mermaid
   graph TD
       A[Subquery: SELECT SUM(salary) FROM employees GROUP BY department_id] -->|Derived Table: dept_totals| B[Outer Query: JOIN with employees]
       B -->|Calculate percent| C[Output]
       C -->|Result| D[Employees with salary percentage]
   ```

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
   **Explanation**: The subquery counts employees per department, and the main query filters departments with more than two employees.
   ```mermaid
   graph TD
       A[Subquery: SELECT COUNT(*) FROM employees GROUP BY department_id] -->|Derived Table: emp_counts| B[Outer Query: JOIN with departments]
       B -->|WHERE employee_count > 2| C[Filter departments]
       C -->|Output| D[Result: Departments with >2 employees]
   ```

5. **Show employees above company median salary**
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
   **Explanation**: The subquery calculates the median salary, and the main query selects employees above it.
   ```mermaid
   graph TD
       A[Subquery: SELECT percentile_cont(0.5) ... FROM employees] -->|Derived Table: median| B[Outer Query: JOIN with employees]
       B -->|WHERE salary > median_salary| C[Filter employees]
       C -->|Output| D[Result: Employees above median salary]
   ```

---

## Topic 4: Correlated Subqueries

### Explanation
A **correlated subquery** references columns from the outer query and runs for each row, making it slower but useful for row-specific comparisons.

### Why Use It?
- Compare rows against dynamic group-based conditions.
- Find records meeting relative criteria (e.g., highest salary in a department).

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
   **Explanation**: The subquery finds the maximum salary for each employee’s department, and the outer query selects matching employees.
   ```mermaid
   graph TD
       A[Outer Query: SELECT ... FROM employees e] -->|For each row| B[Subquery: SELECT MAX(salary) FROM employees e2]
       B -->|Returns max salary| C[Filter if salary matches]
       C -->|Output| D[Result: Highest-paid employees per dept]
   ```

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
   **Explanation**: The subquery finds the earliest `hire_date` in the department, and the outer query selects employees with that date.
   ```mermaid
   graph TD
       A[Outer Query: SELECT ... FROM employees e] -->|For each row| B[Subquery: SELECT MIN(hire_date) FROM employees e2]
       B -->|Returns earliest hire_date| C[Filter if hire_date matches]
       C -->|Output| D[Result: First-hired employees per dept]
   ```

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
   **Explanation**: The subquery counts employees with higher salaries in the same department to assign a rank.
   ```mermaid
   graph TD
       A[Outer Query: SELECT ... FROM employees e] -->|For each row| B[Subquery: SELECT COUNT(*) + 1 FROM employees e2]
       B -->|Returns rank| C[Add to result]
       C -->|Output| D[Result: Employees with salary ranks]
   ```

4. **Find employees with salary 20% above department minimum**
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
   **Explanation**: The subquery calculates 120% of the department’s minimum salary, and the outer query selects employees above this.
   ```mermaid
   graph TD
       A[Outer Query: SELECT ... FROM employees e] -->|For each row| B[Subquery: SELECT MIN(salary) * 1.2 FROM employees e2]
       B -->|Returns threshold| C[Filter if salary > threshold]
       C -->|Output| D[Result: Employees above 120% of min]
   ```

5. **Find employees hired within 6 months of department’s first hire**
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
   **Explanation**: The subquery adds 6 months to the department’s earliest `hire_date`, and the outer query selects employees hired within that period.
   ```mermaid
   graph TD
       A[Outer Query: SELECT ... FROM employees e] -->|For each row| B[Subquery: SELECT MIN(hire_date) + 6 months FROM employees e2]
       B -->|Returns threshold date| C[Filter if hire_date <= threshold]
       C -->|Output| D[Result: Employees within 6 months of first hire]
   ```

---

## Topic 5: EXISTS and NOT EXISTS

### Explanation
`EXISTS` checks if a subquery returns at least one row, while `NOT EXISTS` checks for no rows. These are often correlated and used to test for related data.

### Why Use It?
- Filter rows based on the presence or absence of related data.
- Identify records with or without matches in another table.

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
   **Explanation**: The subquery checks for employees in each department, including departments with matches.
   ```mermaid
   graph TD
       A[Outer Query: SELECT ... FROM departments d] -->|For each row| B[Subquery: SELECT 1 FROM employees e]
       B -->|True/False| C[Include if EXISTS]
       C -->|Output| D[Result: Departments with employees]
   ```

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
   **Explanation**: The subquery checks for employees; departments with no matches are included.
   ```mermaid
   graph TD
       A[Outer Query: SELECT ... FROM departments d] -->|For each row| B[Subquery: SELECT 1 FROM employees e]
       B -->|True/False| C[Include if NOT EXISTS]
       C -->|Output| D[Result: Departments with no employees]
   ```

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
   **Explanation**: The subquery checks for high-earning employees in each department.
   ```mermaid
   graph TD
       A[Outer Query: SELECT ... FROM departments d] -->|For each row| B[Subquery: SELECT 1 FROM employees e WHERE salary > 90000]
       B -->|True/False| C[Include if EXISTS]
       C -->|Output| D[Result: Departments with high earners]
   ```

4. **Find employees with unique hire years**
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
   **Explanation**: The subquery checks for other employees hired in the same year; employees with unique hire years are selected.
   ```mermaid
   graph TD
       A[Outer Query: SELECT ... FROM employees e] -->|For each row| B[Subquery: SELECT 1 FROM employees e2 WHERE same hire year]
       B -->|True/False| C[Include if NOT EXISTS]
       C -->|Output| D[Result: Employees with unique hire years]
   ```

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
   **Explanation**: The subquery checks for employees hired in 2020, and departments with such employees are selected.
   ```mermaid
   graph TD
       A[Outer Query: SELECT ... FROM departments d] -->|For each row| B[Subquery: SELECT 1 FROM employees e WHERE hire_year = 2020]
       B -->|True/False| C[Include if EXISTS]
       C -->|Output| D[Result: Departments with 2020 hires]
   ```

---

## Topic 6: Common Table Expressions (CTEs)

### Explanation
A **CTE** is a temporary result set defined in a `WITH` clause, reusable in the main query, improving readability and maintainability.

### Why Use It?
- Break down complex queries into modular parts.
- Reuse intermediate results multiple times.
- Enhance query clarity.

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
   **Explanation**: The CTE computes department statistics, joined with `departments` for names.
   ```mermaid
   graph TD
       A[CTE: WITH dept_stats AS (...)] -->|Temporary Result: dept_stats| B[Main Query: JOIN with departments]
       B -->|Output| C[Result: Department statistics]
   ```

2. **Find employees earning 10% above department average**
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
   **Explanation**: The CTE calculates department averages, and the main query selects employees above 110% of the average.
   ```mermaid
   graph TD
       A[CTE: WITH dept_avg_salary AS (...)] -->|Temporary Result: dept_avg_salary| B[Main Query: JOIN with employees, departments]
       B -->|WHERE salary > avg_salary * 1.1| C[Filter employees]
       C -->|Output| D[Result: Employees above 110% of dept avg]
   ```

3. **Rank employees by hire date**
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
   **Explanation**: The CTE ranks employees by hire date per department, and the main query selects the earliest hires.
   ```mermaid
   graph TD
       A[CTE: WITH hire_rank AS (...)] -->|Temporary Result: hire_rank| B[Main Query: JOIN with departments]
       B -->|WHERE hire_rank = 1| C[Filter first hires]
       C -->|Output| D[Result: First-hired employees per dept]
   ```

4. **Calculate running total of salaries**
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
   **Explanation**: The CTE calculates a running total of salaries per department, ordered by salary.
   ```mermaid
   graph TD
       A[CTE: WITH salary_sums AS (...)] -->|Temporary Result: salary_sums| B[Main Query: JOIN with departments]
       B -->|Output| C[Result: Employees with running salary totals]
   ```

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
   **Explanation**: The CTE counts employees per department, and the main query selects departments above the average count.
   ```mermaid
   graph TD
       A[CTE: WITH dept_counts AS (...)] -->|Temporary Result: dept_counts| B[Main Query: JOIN with departments]
       B -->|WHERE employee_count > AVG| C[Filter departments]
       C -->|Output| D[Result: Departments with above-average count]
   ```

---

## Topic 7: Recursive CTEs

### Explanation
A **Recursive CTE** refers to itself to handle hierarchical or recursive data, with a **base case** (initial rows) and a **recursive case** (rows built from previous results).

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
   **Explanation**: The base case selects the CEO, and the recursive case builds the hierarchy by joining employees with their managers.
   ```mermaid
   graph TD
       A[Base Case: SELECT ... WHERE manager_id IS NULL] -->|CEO| B[Recursive CTE]
       B -->|UNION ALL| C[Recursive Case: JOIN with employee_tree]
       C -->|Iterate| B
       B -->|Output| D[Result: Full hierarchy]
   ```

2. **Find all reports under the CTO (employee_id = 2)**
   ```sql
   WITH RECURSIVE subordinates AS (
       SELECT 
           employee_id, 
           name, 
           manager_id, 
           level,
           1 AS depth
       FROM employees_hierarchy
       WHERE manager_id = 2
       
       UNION ALL
       
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
   **Explanation**: The base case selects direct reports of the CTO, and the recursive case finds their reports.
   ```mermaid
   graph TD
       A[Base Case: SELECT ... WHERE manager_id = 2] -->|CTO's reports| B[Recursive CTE]
       B -->|UNION ALL| C[Recursive Case: JOIN with subordinates]
       C -->|Iterate| B
       B -->|Output| D[Result: CTO's subordinates]
   ```

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
   **Explanation**: The CTE builds the hierarchy, and the main query counts reports per manager.
   ```mermaid
   graph TD
       A[Base Case: SELECT ... WHERE manager_id IS NULL] -->|CEO| B[Recursive CTE]
       B -->|UNION ALL| C[Recursive Case: JOIN with hierarchy]
       C -->|Iterate| B
       B -->|Temporary Result| D[Main Query: GROUP BY manager_id]
       D -->|Output| E[Result: Manager report counts]
   ```

4. **Show hierarchy with indentation**
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
   **Explanation**: The CTE builds the hierarchy, and `REPEAT` indents names based on depth.
   ```mermaid
   graph TD
       A[Base Case: SELECT ... WHERE manager_id IS NULL] -->|CEO| B[Recursive CTE]
       B -->|UNION ALL| C[Recursive Case: JOIN with employee_tree]
       C -->|Iterate| B
       B -->|Temporary Result| D[Main Query: Indent names]
       D -->|Output| E[Result: Indented hierarchy]
   ```

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
   **Explanation**: The CTE calculates hierarchy depth, and the main query selects employees at the maximum depth.
   ```mermaid
   graph TD
       A[Base Case: SELECT ... WHERE manager_id IS NULL] -->|CEO| B[Recursive CTE]
       B -->|UNION ALL| C[Recursive Case: JOIN with employee_tree]
       C -->|Iterate| B
       B -->|Temporary Result| D[Main Query: WHERE depth = MAX(depth)]
       D -->|Output| E[Result: Deepest hierarchy level]
   ```

---

## Practice Exercises

Using the `retail_store` database (with tables: `products`, `orders`, `order_details`, `customers`, `categories`), try these exercises:

1. **Subqueries in WHERE Clause**
   - Find products with a price higher than the average price.
   - Find orders with a total amount greater than the average order amount.
   - Find customers who have placed more than the average number of orders.
   - Find products in the category with the most products.
   - Find orders containing the most expensive product.

2. **Subqueries in SELECT Clause**
   - Display each order with its customer’s name.
   - Show each product’s price and its category’s average price.
   - Calculate the discount percentage for each order (assume a discount column).
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

This guide provides a comprehensive introduction to subqueries and CTEs in PostgreSQL, enhanced with Mermaid.js diagrams to visualize query logic. Work through the examples and exercises to build your skills, and refer to the additional resources for further learning.
