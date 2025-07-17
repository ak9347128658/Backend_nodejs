

# Day 1: Grouping and Aggregations in PostgreSQL

Welcome to Day 1 of Week 2 in our PostgreSQL learning journey! Today, we dive into **Grouping and Aggregations**, essential techniques for summarizing and analyzing data in a database. This document is designed to be beginner-friendly, with clear explanations, practical examples, and exercises to help you master these concepts. By the end, you'll be able to use aggregate functions, group data, filter grouped results, and combine these techniques with joins for powerful data analysis.

## Topics Covered

1. **Aggregate Functions (COUNT, SUM, AVG, MIN, MAX)**: Learn how to summarize data using built-in functions.
2. **GROUP BY Clause**: Group rows with the same values into summary rows.
3. **HAVING Clause**: Filter grouped data based on conditions.
4. **Filtering Before and After Grouping (WHERE vs. HAVING)**: Understand the order of operations in SQL queries.
5. **Grouping Sets**: Advanced grouping for multiple levels of aggregation in a single query.
6. **Aggregate Functions with JOINs**: Combine aggregations with table joins for richer insights.

## Understanding the Sample Database

To make learning hands-on, we'll use a sample database with three tables: `sales`, `products`, and `date_dim`. Here's a quick overview:

- **sales**: Stores sales transactions with columns for `sale_id`, `product_id`, `customer_id`, `sale_date`, `quantity`, `unit_price`, and `total_price`.
- **products**: Contains product details like `product_id`, `product_name`, `category`, and `supplier`.
- **date_dim**: A date dimension table for time-based analysis, with columns like `date_id`, `day_of_week`, `month`, `quarter`, and `year`.

We'll create these tables and insert sample data to demonstrate each concept.

### Setting Up the Sample Database

Let's start by creating and populating the tables. Run the following SQL to set up the environment:

```sql
-- Create sales table
CREATE TABLE sales (
    sale_id SERIAL PRIMARY KEY,
    product_id INTEGER,
    customer_id INTEGER,
    sale_date DATE,
    quantity INTEGER,
    unit_price NUMERIC(10, 2),
    total_price NUMERIC(10, 2)
);

-- Insert sample sales data
INSERT INTO sales (product_id, customer_id, sale_date, quantity, unit_price, total_price)
VALUES 
    (1, 101, '2023-01-15', 2, 25.99, 51.98),
    (2, 102, '2023-01-16', 1, 149.99, 149.99),
    (3, 103, '2023-01-17', 3, 12.50, 37.50),
    (1, 104, '2023-01-18', 1, 25.99, 25.99),
    (4, 105, '2023-01-19', 2, 34.99, 69.98),
    (2, 106, '2023-01-20', 1, 149.99, 149.99),
    (5, 107, '2023-01-21', 4, 9.99, 39.96),
    (3, 108, '2023-01-22', 2, 12.50, 25.00),
    (1, 109, '2023-01-23', 3, 25.99, 77.97),
    (4, 110, '2023-01-24', 1, 34.99, 34.99);

-- Create products table
CREATE TABLE products (
    product_id SERIAL PRIMARY KEY,
    product_name VARCHAR(100),
    category VARCHAR(50),
    supplier VARCHAR(100)
);

-- Insert sample product data
INSERT INTO products (product_id, product_name, category, supplier)
VALUES 
    (1, 'Basic T-shirt', 'Clothing', 'FashionCo'),
    (2, 'Premium Headphones', 'Electronics', 'AudioTech'),
    (3, 'Notebook Set', 'Stationery', 'OfficeSupplies'),
    (4, 'Wireless Mouse', 'Electronics', 'TechGear'),
    (5, 'Coffee Mug', 'Kitchenware', 'HomePlus');

-- Create date dimension table
CREATE TABLE date_dim (
    date_id DATE PRIMARY KEY,
    day_of_week VARCHAR(10),
    month VARCHAR(10),
    quarter VARCHAR(2),
    year INTEGER
);

-- Insert sample dates
INSERT INTO date_dim (date_id, day_of_week, month, quarter, year)
VALUES 
    ('2023-01-15', 'Sunday', 'January', 'Q1', 2023),
    ('2023-01-16', 'Monday', 'January', 'Q1', 2023),
    ('2023-01-17', 'Tuesday', 'January', 'Q1', 2023),
    ('2023-01-18', 'Wednesday', 'January', 'Q1', 2023),
    ('2023-01-19', 'Thursday', 'January', 'Q1', 2023),
    ('2023-01-20', 'Friday', 'January', 'Q1', 2023),
    ('2023-01-21', 'Saturday', 'January', 'Q1', 2023),
    ('2023-01-22', 'Sunday', 'January', 'Q1', 2023),
    ('2023-01-23', 'Monday', 'January', 'Q1', 2023),
    ('2023-01-24', 'Tuesday', 'January', 'Q1', 2023);
```

## Topic 1: Aggregate Functions (COUNT, SUM, AVG, MIN, MAX)

**Explanation**: Aggregate functions perform calculations on a set of values and return a single result. They are used to summarize data, such as counting rows, summing values, or finding averages. Common aggregate functions in PostgreSQL include:

- **COUNT**: Counts the number of rows or non-null values.
- **SUM**: Adds up numeric values.
- **AVG**: Calculates the average of numeric values.
- **MIN**: Finds the smallest value.
- **MAX**: Finds the largest value.

These functions are often used with the entire table or with grouped data (covered later).

### Examples

1. **Total Number of Sales**
   ```sql
   SELECT COUNT(*) AS total_sales
   FROM sales;
   ```
   *Explanation*: Counts all rows in the `sales` table to determine the total number of sales transactions.

2. **Total Revenue Across All Sales**
   ```sql
   SELECT SUM(total_price) AS total_revenue
   FROM sales;
   ```
   *Explanation*: Sums the `total_price` column to calculate the total revenue from all sales.

3. **Average Sale Amount**
   ```sql
   SELECT AVG(total_price) AS average_sale
   FROM sales;
   ```
   *Explanation*: Computes the average sale amount by dividing the sum of `total_price` by the number of sales.

4. **Minimum and Maximum Sale Amounts**
   ```sql
   SELECT 
       MIN(total_price) AS min_sale,
       MAX(total_price) AS max_sale
   FROM sales;
   ```
   *Explanation*: Finds the smallest and largest values in the `total_price` column.

5. **Count of Unique Customers**
   ```sql
   SELECT COUNT(DISTINCT customer_id) AS unique_customers
   FROM sales;
   ```
   *Explanation*: Uses `DISTINCT` with `COUNT` to count only unique `customer_id` values, showing how many different customers made purchases.

## Topic 2: GROUP BY Clause

**Explanation**: The `GROUP BY` clause groups rows that have the same values in specified columns into summary rows. It is used with aggregate functions to produce summarized results for each group. For example, you can group sales by `product_id` to see total sales per product.

### Examples

1. **Sales Count and Revenue by Product**
   ```sql
   SELECT 
       product_id,
       COUNT(*) AS sale_count,
       SUM(total_price) AS total_revenue
   FROM sales
   GROUP BY product_id
   ORDER BY total_revenue DESC;
   ```
   *Explanation*: Groups sales by `product_id` and calculates the number of sales and total revenue for each product.

2. **Daily Sales Summary**
   ```sql
   SELECT 
       sale_date,
       COUNT(*) AS transaction_count,
       SUM(total_price) AS daily_revenue
   FROM sales
   GROUP BY sale_date
   ORDER BY sale_date;
   ```
   *Explanation*: Groups sales by `sale_date` to show the number of transactions and revenue for each day.

3. **Units Sold by Product**
   ```sql
   SELECT 
       product_id,
       SUM(quantity) AS total_units_sold
   FROM sales
   GROUP BY product_id
   ORDER BY total_units_sold DESC;
   ```
   *Explanation*: Sums the `quantity` column for each `product_id` to show how many units of each product were sold.

4. **Average Sale Amount by Customer**
   ```sql
   SELECT 
       customer_id,
       AVG(total_price) AS avg_sale_amount
   FROM sales
   GROUP BY customer_id
   ORDER BY avg_sale_amount DESC;
   ```
   *Explanation*: Groups by `customer_id` and calculates the average sale amount per customer.

5. **Sales by Weekday**
   ```sql
   SELECT 
       dd.day_of_week,
       COUNT(*) AS sale_count
   FROM sales s
   JOIN date_dim dd ON s.sale_date = dd.date_id
   GROUP BY dd.day_of_week
   ORDER BY sale_count DESC;
   ```
   *Explanation*: Joins `sales` with `date_dim` to group sales by the day of the week, counting transactions per day.

## Topic 3: HAVING Clause

**Explanation**: The `HAVING` clause filters grouped data based on conditions applied to aggregate functions. It is used after `GROUP BY` to filter groups, unlike `WHERE`, which filters individual rows before grouping.

### Examples

1. **Products with Multiple Sales**
   ```sql
   SELECT 
       product_id,
       COUNT(*) AS sale_count
   FROM sales
   GROUP BY product_id
   HAVING COUNT(*) > 1
   ORDER BY sale_count DESC;
   ```
   *Explanation*: Finds products that have been sold more than once by filtering groups with a sale count greater than 1.

2. **High-Revenue Products**
   ```sql
   SELECT 
       product_id,
       SUM(total_price) AS total_revenue
   FROM sales
   GROUP BY product_id
   HAVING SUM(total_price) > 100
   ORDER BY total_revenue DESC;
   ```
   *Explanation*: Identifies products with total revenue exceeding $100.

3. **Customers with High Average Purchases**
   ```sql
   SELECT 
       customer_id,
       AVG(total_price) AS avg_purchase
   FROM sales
   GROUP BY customer_id
   HAVING AVG(total_price) > 50
   ORDER BY avg_purchase DESC;
   ```
   *Explanation*: Finds customers whose average purchase amount is greater than $50.

4. **Days with High Transaction Counts**
   ```sql
   SELECT 
       sale_date,
       COUNT(*) AS transaction_count
   FROM sales
   GROUP BY sale_date
   HAVING COUNT(*) >= 2
   ORDER BY transaction_count DESC;
   ```
   *Explanation*: Shows days with two or more sales transactions.

5. **Categories with High Average Unit Price**
   ```sql
   SELECT 
       p.category,
       AVG(s.unit_price) AS avg_unit_price
   FROM sales s
   JOIN products p ON s.product_id = p.product_id
   GROUP BY p.category
   HAVING AVG(s.unit_price) > 30
   ORDER BY avg_unit_price DESC;
   ```
   *Explanation*: Finds product categories where the average unit price of sales exceeds $30.

## Topic 4: Filtering Before and After Grouping (WHERE vs. HAVING)

**Explanation**: In SQL, filtering can occur before grouping (using `WHERE`) or after grouping (using `HAVING`). `WHERE` filters individual rows before they are grouped, while `HAVING` filters the grouped results based on aggregate conditions. The order of operations in SQL is: `FROM` → `WHERE` → `GROUP BY` → `HAVING` → `SELECT` → `ORDER BY`.

### Examples

1. **Filter Sales by Date, Then Group by Product**
   ```sql
   SELECT 
       product_id,
       COUNT(*) AS sale_count,
       SUM(total_price) AS total_revenue
   FROM sales
   WHERE sale_date > '2023-01-20'
   GROUP BY product_id
   ORDER BY total_revenue DESC;
   ```
   *Explanation*: Filters sales after January 20, 2023, then groups by `product_id` to show sales count and revenue.

2. **Filter by Price, Group, and Filter by Average**
   ```sql
   SELECT 
       product_id,
       AVG(unit_price) AS avg_price
   FROM sales
   WHERE sale_date > '2023-01-15'
   GROUP BY product_id
   HAVING AVG(unit_price) > 20
   ORDER BY avg_price DESC;
   ```
   *Explanation*: Filters sales after January 15, groups by `product_id`, and then filters groups where the average unit price exceeds $20.

3. **High-Quantity Sales by Customer**
   ```sql
   SELECT 
       customer_id,
       SUM(quantity) AS total_quantity
   FROM sales
   WHERE quantity > 1
   GROUP BY customer_id
   HAVING SUM(quantity) > 5
   ORDER BY total_quantity DESC;
   ```
   *Explanation*: Filters sales with quantity greater than 1, groups by `customer_id`, and keeps groups with total quantity over 5.

4. **Recent Sales by Category**
   ```sql
   SELECT 
       p.category,
       COUNT(*) AS sale_count
   FROM sales s
   JOIN products p ON s.product_id = p.product_id
   WHERE s.sale_date >= '2023-01-18'
   GROUP BY p.category
   HAVING COUNT(*) > 1
   ORDER BY sale_count DESC;
   ```
   *Explanation*: Filters sales from January 18 onward, groups by category, and keeps categories with more than one sale.

5. **High-Value Sales by Date**
   ```sql
   SELECT 
       sale_date,
       SUM(total_price) AS daily_revenue
   FROM sales
   WHERE total_price > 50
   GROUP BY sale_date
   HAVING SUM(total_price) > 100
   ORDER BY daily_revenue DESC;
   ```
   *Explanation*: Filters sales with individual total prices over $50, groups by date, and keeps days with total revenue over $100.

## Topic 5: Grouping Sets

**Explanation**: Grouping Sets allow you to perform multiple levels of grouping in a single query, producing a result set that combines different aggregations. This is useful for generating reports with subtotals and grand totals without running multiple queries. In PostgreSQL, you can use `GROUPING SETS`, `ROLLUP`, or `CUBE` for advanced grouping.

### Examples

1. **Sales by Product and Date with Grand Total**
   ```sql
   SELECT 
       product_id,
       sale_date,
       SUM(total_price) AS total_revenue
   FROM sales
   GROUP BY GROUPING SETS (
       (product_id, sale_date),
       (product_id),
       ()
   )
   ORDER BY product_id, sale_date;
   ```
   *Explanation*: Groups sales by `product_id` and `sale_date`, by `product_id` alone, and provides a grand total (empty set `()`).

2. **Revenue by Category and Supplier**
   ```sql
   SELECT 
       p.category,
       p.supplier,
       SUM(s.total_price) AS total_revenue
   FROM sales s
   JOIN products p ON s.product_id = p.product_id
   GROUP BY GROUPING SETS (
       (p.category, p.supplier),
       (p.category),
       ()
   )
   ORDER BY p.category, p.supplier;
   ```
   *Explanation*: Shows revenue by category and supplier, by category alone, and a grand total.

3. **Sales Count by Day and Month**
   ```sql
   SELECT 
       dd.day_of_week,
       dd.month,
       COUNT(*) AS sale_count
   FROM sales s
   JOIN date_dim dd ON s.sale_date = dd.date_id
   GROUP BY GROUPING SETS (
       (dd.day_of_week, dd.month),
       (dd.month),
       ()
   )
   ORDER BY dd.month, dd.day_of_week;
   ```
   *Explanation*: Counts sales by day of week and month, by month alone, and a grand total.

4. **Units Sold by Product and Category**
   ```sql
   SELECT 
       p.product_id,
       p.category,
       SUM(s.quantity) AS total_units
   FROM sales s
   JOIN products p ON s.product_id = p.product_id
   GROUP BY GROUPING SETS (
       (p.product_id, p.category),
       (p.category),
       ()
   )
   ORDER BY p.category, p.product_id;
   ```
   *Explanation*: Summarizes units sold by product and category, by category, and a grand total.

5. **Revenue by Quarter and Year**
   ```sql
   SELECT 
       dd.quarter,
       dd.year,
       SUM(s.total_price) AS total_revenue
   FROM sales s
   JOIN date_dim dd ON s.sale_date = dd.date_id
   GROUP BY GROUPING SETS (
       (dd.quarter, dd.year),
       (dd.year),
       ()
   )
   ORDER BY dd.year, dd.quarter;
   ```
   *Explanation*: Shows revenue by quarter and year, by year, and a grand total.

## Topic 6: Aggregate Functions with JOINs

**Explanation**: Combining aggregate functions with `JOIN` operations allows you to summarize data across multiple tables. For example, you can join `sales` with `products` to analyze sales by product name or category.

### Examples

1. **Sales by Product Name and Category**
   ```sql
   SELECT 
       p.product_name,
       p.category,
       COUNT(*) AS sale_count,
       SUM(s.total_price) AS total_revenue
   FROM sales s
   JOIN products p ON s.product_id = p.product_id
   GROUP BY p.product_name, p.category
   ORDER BY total_revenue DESC;
   ```
   *Explanation*: Joins `sales` and `products` to summarize sales count and revenue by product name and category.

2. **Average Unit Price by Category**
   ```sql
   SELECT 
       p.category,
       AVG(s.unit_price) AS avg_unit_price,
       COUNT(*) AS sale_count
   FROM sales s
   JOIN products p ON s.product_id = p.product_id
   GROUP BY p.category
   ORDER BY avg_unit_price DESC;
   ```
   *Explanation*: Calculates the average unit price and sale count per product category.

3. **Total Units Sold by Supplier**
   ```sql
   SELECT 
       p.supplier,
       SUM(s.quantity) AS total_units_sold
   FROM sales s
   JOIN products p ON s.product_id = p.product_id
   GROUP BY p.supplier
   ORDER BY total_units_sold DESC;
   ```
   *Explanation*: Summarizes the total units sold for each supplier.

4. **Sales by Category and Day of Week**
   ```sql
   SELECT 
       p.category,
       dd.day_of_week,
       SUM(s.total_price) AS total_revenue
   FROM sales s
   JOIN products p ON s.product_id = p.product_id
   JOIN date_dim dd ON s.sale_date = dd.date_id
   GROUP BY p.category, dd.day_of_week
   ORDER BY p.category, total_revenue DESC;
   ```
   *Explanation*: Combines `sales`, `products`, and `date_dim` to show revenue by category and day of the week.

5. **High-Revenue Products by Supplier**
   ```sql
   SELECT 
       p.supplier,
       p.product_name,
       SUM(s.total_price) AS total_revenue
   FROM sales s
   JOIN products p ON s.product_id = p.product_id
   GROUP BY p.supplier, p.product_name
   HAVING SUM(s.total_price) > 50
   ORDER BY total_revenue DESC;
   ```
   *Explanation*: Identifies products with total revenue over $50, grouped by supplier and product name.

## Practice Exercises

To solidify your understanding, try these exercises using the `retail_store` database (assumed to have tables: `products`, `order_items`, `orders`, `customers`, `categories`). If you don't have this database, use the `sales`, `products`, and `date_dim` tables created above, adapting the queries as needed.

### Exercise 1: Basic Aggregations
1. Calculate the total revenue for each product.
2. Find the average order value for each customer.
3. Count how many orders each customer has placed.
4. Determine which category has the most products.
5. Find the total revenue by order status.

### Exercise 2: Using HAVING
1. Find products ordered more than 2 times.
2. Identify customers who have spent more than $500 total.
3. Find categories with an average product price over $50.
4. Find days with more than 3 sales transactions.
5. Identify suppliers with total sales revenue over $200.

### Exercise 3: Combining Filtering and Grouping
1. Find total sales by category for products with inventory count > 20.
2. Calculate the average order value by month for orders with status 'Delivered'.
3. Count orders by customer for orders placed in 2023.
4. Find total revenue by product for sales after January 15, 2023.
5. Calculate the average unit price by category for sales with quantity > 2.

### Exercise 4: Multiple Grouping Levels
1. Calculate sales by category and month.
2. Find the number of products in each price range (0-50, 51-100, 101-200, 200+) by category.
3. Determine the average order value by customer and order status.
4. Summarize sales by supplier and day of week.
5. Calculate total revenue by product and quarter.

### Exercise 5: Challenge
Calculate the percentage of total revenue that each product category represents, including categories with zero sales. Use a CTE or subquery to compute the grand total and category totals.

## Additional Resources

- [PostgreSQL Aggregate Functions Documentation](https://www.postgresql.org/docs/current/functions-aggregate.html)
- [PostgreSQL GROUP BY Documentation](https://www.postgresql.org/docs/current/queries-table-expressions.html#QUERIES-GROUP)
- [PostgreSQL HAVING Documentation](https://www.postgresql.org/docs/current/queries-table-expressions.html#QUERIES-HAVING)
- [PostgreSQL GROUPING SETS, ROLLUP, and CUBE](https://www.postgresql.org/docs/current/queries-table-expressions.html#QUERIES-GROUPING-SETS)

## Tips for Learning

- **Practice Regularly**: Run each example and modify the queries to see how results change.
- **Understand the Data**: Familiarize yourself with the table structures to write meaningful queries.
- **Break Down Queries**: Start with simple aggregates, then add `GROUP BY`, `HAVING`, and `JOINs` step-by-step.
- **Use Comments**: Comment your SQL code to clarify your thought process.
- **Test with Small Data**: Use the provided sample data to verify your queries before applying them to larger datasets.

Happy querying, and enjoy exploring the power of grouping and aggregations in PostgreSQL!
