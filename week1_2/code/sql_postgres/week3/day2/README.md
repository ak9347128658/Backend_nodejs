# Day 2: Views and Materialized Views

## Topics Covered

1. Introduction to database views
2. Creating and managing views
3. Updatable views and rules
4. Materialized views
5. Refreshing materialized views
6. Performance considerations
7. Security and views

## Examples and Exercises

### Example 1: Creating a Basic View

Views are virtual tables that represent the result of a stored query. They don't store data themselves but provide a way to simplify complex queries and restrict access to specific data.

```sql
-- Create a simple customer information view
CREATE VIEW customer_info AS
SELECT 
    customer_id, 
    first_name, 
    last_name, 
    email, 
    city, 
    country
FROM 
    customers c
JOIN 
    addresses a ON c.address_id = a.address_id;

-- Using the view
SELECT * FROM customer_info WHERE country = 'USA';
```

Views make complex queries reusable and can hide the complexity of joins and conditions from end users.

### Example 2: Creating a View with Computed Columns

Views can include computed columns and expressions, not just direct columns from tables.

```sql
-- Create a view with calculated fields
CREATE VIEW order_summary AS
SELECT 
    o.order_id,
    c.first_name || ' ' || c.last_name AS customer_name,
    COUNT(oi.item_id) AS items_count,
    SUM(oi.quantity * oi.unit_price) AS total_amount,
    o.order_date,
    CASE 
        WHEN o.status = 'D' THEN 'Delivered'
        WHEN o.status = 'P' THEN 'Processing'
        WHEN o.status = 'S' THEN 'Shipped'
        ELSE 'Unknown'
    END AS status_description
FROM 
    orders o
JOIN 
    customers c ON o.customer_id = c.customer_id
JOIN 
    order_items oi ON o.order_id = oi.order_id
GROUP BY 
    o.order_id, c.first_name, c.last_name, o.order_date, o.status;

-- Query the view
SELECT * FROM order_summary WHERE total_amount > 1000;
```

### Example 3: Updatable Views

Some views can be updated directly, which affects the underlying tables. For a view to be updatable, it must meet certain criteria.

```sql
-- Create an updatable view
CREATE VIEW active_employees AS
SELECT 
    employee_id,
    first_name,
    last_name,
    email,
    department_id,
    salary
FROM 
    employees
WHERE 
    is_active = TRUE;

-- Insert through the view
INSERT INTO active_employees (
    employee_id, first_name, last_name, email, department_id, salary, is_active
) VALUES (
    101, 'John', 'Smith', 'john.smith@example.com', 3, 75000, TRUE
);

-- Update through the view
UPDATE active_employees SET salary = 80000 WHERE employee_id = 101;

-- Delete through the view
DELETE FROM active_employees WHERE employee_id = 101;
```

Views are updatable when they reference a single table and include the primary key, don't use aggregations, DISTINCT, GROUP BY, HAVING, or window functions, and don't use set operations (UNION, INTERSECT, EXCEPT).

### Example 4: Views with Check Option

The WITH CHECK OPTION prevents inserts or updates through a view that would create rows that are not visible through the view.

```sql
-- Create a view with check option
CREATE VIEW high_salary_employees AS
SELECT 
    employee_id,
    first_name,
    last_name,
    department_id,
    salary
FROM 
    employees
WHERE 
    salary > 50000
WITH CHECK OPTION;

-- This will succeed
INSERT INTO high_salary_employees VALUES (102, 'Jane', 'Doe', 2, 60000);

-- This will fail because the salary doesn't meet the view's criteria
INSERT INTO high_salary_employees VALUES (103, 'Bob', 'Johnson', 1, 45000);
```

The CHECK OPTION ensures data integrity when modifying data through views.

### Example 5: Materialized Views

Materialized views store the result of a query physically, improving performance for complex queries but requiring periodic refreshing.

```sql
-- Create a materialized view for sales analytics
CREATE MATERIALIZED VIEW monthly_sales_summary AS
SELECT 
    DATE_TRUNC('month', o.order_date) AS month,
    p.category_id,
    c.category_name,
    SUM(oi.quantity * oi.unit_price) AS total_sales,
    COUNT(DISTINCT o.customer_id) AS unique_customers
FROM 
    orders o
JOIN 
    order_items oi ON o.order_id = oi.order_id
JOIN 
    products p ON oi.product_id = p.product_id
JOIN 
    categories c ON p.category_id = c.category_id
WHERE 
    o.order_date >= '2023-01-01' AND o.order_date < '2024-01-01'
GROUP BY 
    DATE_TRUNC('month', o.order_date), p.category_id, c.category_name;

-- Query the materialized view
SELECT * FROM monthly_sales_summary WHERE total_sales > 10000;
```

Materialized views are especially useful for data warehousing and reporting scenarios where the underlying data doesn't change frequently.

### Example 6: Refreshing Materialized Views

Materialized views need to be refreshed to include changes in the underlying tables.

```sql
-- Refresh a materialized view completely
REFRESH MATERIALIZED VIEW monthly_sales_summary;

-- Refresh a materialized view concurrently (without locking)
REFRESH MATERIALIZED VIEW CONCURRENTLY monthly_sales_summary;
```

CONCURRENTLY allows users to continue querying the materialized view while it's being refreshed, but requires a unique index on the materialized view.

### Example 7: Using Indexes with Materialized Views

Adding indexes to materialized views can significantly improve query performance.

```sql
-- Create an index on a materialized view
CREATE INDEX idx_monthly_sales_category
ON monthly_sales_summary(category_id);

-- Create a unique index to enable concurrent refreshes
CREATE UNIQUE INDEX idx_monthly_sales_month_category
ON monthly_sales_summary(month, category_id);
```

Proper indexing of materialized views follows the same principles as regular table indexing.

## Practical Uses

1. **Data Abstraction**: Views provide a way to abstract complex data structures and present a simplified interface to users.

2. **Security**: Views can restrict access to specific columns or rows, providing an additional layer of security.

3. **Performance Optimization**: Materialized views can dramatically improve query performance for complex analytical queries.

4. **Data Consistency**: Views ensure consistent formatting and calculation of derived data across applications.

5. **Legacy System Support**: Views can provide backward compatibility when database schemas evolve.

## Best Practices

1. **Keep View Definitions Simple**: Overly complex views can be difficult to maintain and may perform poorly.

2. **Document Your Views**: Include comments in view definitions to explain their purpose and usage.

3. **Index Materialized Views**: Add appropriate indexes to materialized views based on query patterns.

4. **Schedule Regular Refreshes**: For materialized views, implement a regular refresh schedule based on data volatility.

5. **Use WITH CHECK OPTION**: For updatable views, use the CHECK OPTION to maintain data integrity.

6. **Monitor Performance**: Regularly check the performance of queries against views and optimize as needed.

7. **Avoid Nesting Too Deep**: While views can reference other views, too many levels of nesting can impact performance.

## Exercises

Complete the exercises in the exercises.sql file to practice working with views and materialized views in PostgreSQL.
