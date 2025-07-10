

# Day 4: Basic Querying - SELECT, WHERE, ORDER BY

This document is an in-depth guide to Day 4 of Week 1 in learning PostgreSQL, focusing on fundamental querying techniques using `SELECT`, `WHERE`, `ORDER BY`, `LIMIT`, and `OFFSET`. Each topic is explained clearly, with multiple examples to make it beginner-friendly. The goal is to help you understand how to retrieve and manipulate data effectively in a PostgreSQL database.

## Topics Covered

1. **SELECT Statement Basics**: Learn how to retrieve data from tables.
2. **Column Selection and Aliases**: Select specific columns and rename them for clarity.
3. **Filtering Data with WHERE**: Filter rows based on conditions.
4. **Sorting Data with ORDER BY**: Sort query results in ascending or descending order.
5. **LIMIT and OFFSET for Pagination**: Control the number of rows returned and skip rows for pagination.
6. **Filtering with Various Operators**: Use operators like `=`, `<>`, `>`, `<`, `LIKE`, `IN`, `BETWEEN`, etc., for precise filtering.

## Setup: Sample Database and Table

To follow along, we'll use a sample `employees` table in a PostgreSQL database. Run the following SQL to create and populate the table:

```sql
CREATE TABLE employees (
    id SERIAL PRIMARY KEY,
    first_name VARCHAR(50),
    last_name VARCHAR(50),
    department VARCHAR(50),
    salary NUMERIC(10, 2),
    hire_date DATE
);

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
```

This table contains employee data with columns for ID, first name, last name, department, salary, and hire date. We'll use it for all examples.

## 1. SELECT Statement Basics

The `SELECT` statement retrieves data from a table. It allows you to fetch all columns (`*`) or specific columns and return rows that match your query.

### Explanation
- Use `SELECT *` to retrieve all columns from a table.
- Specify column names (e.g., `SELECT first_name, salary`) to retrieve only those columns.
- The `FROM` clause specifies the table to query.

### Examples
1. **Retrieve all columns and rows**:
   ```sql
   SELECT * FROM employees;
   ```
   *Explanation*: This query returns all columns (`id`, `first_name`, `last_name`, `department`, `salary`, `hire_date`) for all employees.

2. **Select specific columns**:
   ```sql
   SELECT first_name, last_name, department FROM employees;
   ```
   *Explanation*: This query returns only the `first_name`, `last_name`, and `department` columns for all employees.

3. **Select a single column**:
   ```sql
   SELECT department FROM employees;
   ```
   *Explanation*: This query returns only the `department` column for all employees.

4. **Select with a constant value**:
   ```sql
   SELECT first_name, 'Active' AS status FROM employees;
   ```
   *Explanation*: Adds a constant column `status` with the value 'Active' for each row.

5. **Select with an expression**:
   ```sql
   SELECT first_name, salary * 12 AS annual_salary FROM employees;
   ```
   *Explanation*: Calculates the annual salary by multiplying the monthly `salary` by 12.

## 2. Column Selection and Aliases

Aliases rename columns or expressions in the query output, making results easier to read or use in further calculations.

### Explanation
- Use `AS` to assign an alias to a column or expression (e.g., `salary AS AnnualSalary`).
- Aliases can include spaces if enclosed in double quotes (e.g., `AS "Full Name"`).
- Aliases are useful for calculations or concatenations.

### Examples
1. **Basic column alias**:
   ```sql
   SELECT first_name AS "First Name", last_name AS "Last Name" FROM employees;
   ```
   *Explanation*: Renames `first_name` to "First Name" and `last_name` to "Last Name" in the output.

2. **Concatenate columns**:
   ```sql
   SELECT first_name || ' ' || last_name AS "Full Name" FROM employees;
   ```
   *Explanation*: Combines `first_name` and `last_name` with a space to create a "Full Name" column.

3. **Alias with an expression**:
   ```sql
   SELECT salary * 1.1 AS "Salary After Raise" FROM employees;
   ```
   *Explanation*: Calculates a 10% salary increase and names the column "Salary After Raise".

4. **Multiple aliases with expressions**:
   ```sql
   SELECT 
       first_name || ' ' || last_name AS "Full Name",
       salary AS "Current Salary",
       salary * 1.05 AS "Salary After 5% Raise"
   FROM employees;
   ```
   *Explanation*: Combines full name and shows current and projected salaries with aliases.

5. **Alias with date formatting**:
   ```sql
   SELECT 
       first_name,
       hire_date AS "Hire Date",
       hire_date + INTERVAL '1 year' AS "First Anniversary"
   FROM employees;
   ```
   *Explanation*: Shows the hire date and calculates the first anniversary date.

## 3. Filtering Data with WHERE

The `WHERE` clause filters rows based on specified conditions, allowing you to retrieve only the data that meets your criteria.

### Explanation
- Conditions use operators like `=`, `<>`, `>`, `<`, etc.
- Combine conditions with `AND`, `OR`, and `NOT`.
- The `WHERE` clause comes after `FROM` and before `ORDER BY`.

### Examples
1. **Filter by exact match**:
   ```sql
   SELECT * FROM employees WHERE department = 'IT';
   ```
   *Explanation*: Returns all employees in the IT department.

2. **Filter with multiple conditions (AND)**:
   ```sql
   SELECT * FROM employees WHERE department = 'Finance' AND salary > 80000;
   ```
   *Explanation*: Returns employees in Finance with a salary greater than $80,000.

3. **Filter with OR**:
   ```sql
   SELECT * FROM employees WHERE department = 'IT' OR department = 'HR';
   ```
   *Explanation*: Returns employees in either IT or HR departments.

4. **Filter with NOT**:
   ```sql
   SELECT * FROM employees WHERE NOT department = 'Marketing';
   ```
   *Explanation*: Returns employees not in the Marketing department.

5. **Filter by date**:
   ```sql
   SELECT * FROM employees WHERE hire_date < '2020-01-01';
   ```
   *Explanation*: Returns employees hired before January 1, 2020.

## 4. Sorting Data with ORDER BY

The `ORDER BY` clause sorts query results by one or more columns in ascending (`ASC`) or descending (`DESC`) order.

### Explanation
- Default sort order is `ASC` (ascending).
- Use column names or column positions (e.g., `ORDER BY 1` for the first column).
- Multiple columns can be specified for layered sorting.

### Examples
1. **Sort by single column (ascending)**:
   ```sql
   SELECT * FROM employees ORDER BY salary;
   ```
   *Explanation*: Sorts employees by salary in ascending order.

2. **Sort by single column (descending)**:
   ```sql
   SELECT * FROM employees ORDER BY hire_date DESC;
   ```
   *Explanation*: Sorts employees by hire date, most recent first.

3. **Sort by multiple columns**:
   ```sql
   SELECT * FROM employees ORDER BY department ASC, salary DESC;
   ```
   *Explanation*: Sorts by department alphabetically, then by salary in descending order within each department.

4. **Sort by column position**:
   ```sql
   SELECT first_name, last_name, salary FROM employees ORDER BY 3 DESC;
   ```
   *Explanation*: Sorts by the third column (`salary`) in descending order.

5. **Sort with an expression**:
   ```sql
   SELECT first_name, salary * 12 AS annual_salary FROM employees ORDER BY annual_salary DESC;
   ```
   *Explanation*: Sorts by the calculated annual salary in descending order.

## 5. LIMIT and OFFSET for Pagination

`LIMIT` restricts the number of rows returned, and `OFFSET` skips a specified number of rows, enabling pagination.

### Explanation
- `LIMIT n` returns up to `n` rows.
- `OFFSET m` skips the first `m` rows.
- Often used with `ORDER BY` for consistent results.

### Examples
1. **Limit to 5 rows**:
   ```sql
   SELECT * FROM employees ORDER BY id LIMIT 5;
   ```
   *Explanation*: Returns the first 5 employees, sorted by ID.

2. **Skip and limit (basic pagination)**:
   ```sql
   SELECT * FROM employees ORDER BY id LIMIT 3 OFFSET 5;
   ```
   *Explanation*: Skips the first 5 rows and returns the next 3.

3. **Pagination for page 2 (4 items per page)**:
   ```sql
   SELECT * FROM employees ORDER BY id LIMIT 4 OFFSET 4;
   ```
   *Explanation*: Returns rows 5–8 (second page with 4 items per page).

4. **Limit with sorting**:
   ```sql
   SELECT * FROM employees ORDER BY salary DESC LIMIT 3;
   ```
   *Explanation*: Returns the top 3 highest-paid employees.

5. **Offset with filtering**:
   ```sql
   SELECT * FROM employees WHERE department = 'IT' ORDER BY salary DESC LIMIT 2 OFFSET 1;
   ```
   *Explanation*: Skips the highest-paid IT employee and returns the next two.

## 6. Filtering with Various Operators

PostgreSQL supports operators like `=`, `<>`, `>`, `<`, `LIKE`, `IN`, `BETWEEN`, and `ILIKE` for flexible filtering.

### Explanation
- `=` checks for equality; `<>` or `!=` checks for inequality.
- `>`, `<`, `>=`, `<=` compare numeric or date values.
- `LIKE` and `ILIKE` match patterns (`ILIKE` is case-insensitive).
- `IN` checks if a value is in a list.
- `BETWEEN` checks if a value is within a range.

### Examples
1. **Equality and inequality**:
   ```sql
   SELECT * FROM employees WHERE department <> 'Finance';
   ```
   *Explanation*: Returns employees not in the Finance department.

2. **Range with BETWEEN**:
   ```sql
   SELECT * FROM employees WHERE salary BETWEEN 70000 AND 80000;
   ```
   *Explanation*: Returns employees with salaries between $70,000 and $80,000 (inclusive).

3. **List with IN**:
   ```sql
   SELECT * FROM employees WHERE department IN ('IT', 'Finance');
   ```
   *Explanation*: Returns employees in IT or Finance departments.

4. **Pattern matching with LIKE**:
   ```sql
   SELECT * FROM employees WHERE first_name LIKE 'J%';
   ```
   *Explanation*: Returns employees whose first names start with 'J'.

5. **Case-insensitive matching with ILIKE**:
   ```sql
   SELECT * FROM employees WHERE department ILIKE 'it';
   ```
   *Explanation*: Returns employees in the IT department, ignoring case.

## Practice Exercises

Using the `retail_store` database (assumed to have `customers`, `products`, `orders`, and `categories` tables from previous days), try these exercises to apply your knowledge.

1. **Basic SELECT and WHERE**:
   - Select all customers' full names and contact information (email, phone, address).
   - Find products costing more than $150.
   - List orders with status 'Pending' or 'Processing'.
   - Find products in the 'Clothing' category.
   - List customers whose email ends with 'gmail.com'.

2. **Using Operators**:
   - Find products with inventory between 50 and 200 units.
   - Find customers registered after January 1, 2022.
   - Find orders with a total amount less than $100.
   - Find products with names containing 'phone'.
   - Find orders placed in 2024.

3. **Sorting with ORDER BY**:
   - List products by inventory count, lowest to highest.
   - List customers by registration date, oldest to newest.
   - List orders by total amount, highest to lowest.
   - List products by category name alphabetically, then by price descending.
   - List customers by email alphabetically.

4. **Pagination with LIMIT and OFFSET**:
   - Get the 4 cheapest products.
   - Get products 11–15 in terms of price (third page, 5 items per page).
   - Get the 5 oldest orders.
   - Get the 3 highest-paid employees in HR.
   - Get products 6–10 in the 'Electronics' category by price.

5. **Challenge**:
   - Find the top 5 categories by total inventory count.
   - Calculate the total order amount per customer, sorted by total descending.
   - Find the 3 most expensive products in each category.

## Additional Resources

- [PostgreSQL SELECT Documentation](https://www.postgresql.org/docs/current/sql-select.html)
- [PostgreSQL WHERE Documentation](https://www.postgresql.org/docs/current/queries-table-expressions.html#QUERIES-WHERE)
- [PostgreSQL Pattern Matching Documentation](https://www.postgresql.org/docs/current/functions-matching.html)
- [PostgreSQL ORDER BY Documentation](https://www.postgresql.org/docs/current/queries-order.html)
- [PostgreSQL LIMIT and OFFSET](https://www.postgresql.org/docs/current/queries-limit.html)

This guide provides a solid foundation for querying in PostgreSQL. Practice the examples and exercises to build confidence, and refer to the documentation for deeper exploration.

