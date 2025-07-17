

# Day 1: Grouping and Aggregations in PostgreSQL

Welcome to Day 1 of Week 2 in our PostgreSQL learning journey! Today, we'll explore **Grouping and Aggregations**, which help you summarize and analyze data in a database. This guide is designed for beginners, with simple explanations, hands-on examples, and visual diagrams to make learning fun and clear. By the end, you'll know how to summarize data, group it, filter results, and combine these skills with table joins for awesome data insights!

## What You'll Learn

1. **Aggregate Functions (COUNT, SUM, AVG, MIN, MAX)**: Summarize data with built-in tools.
2. **GROUP BY Clause**: Organize data into groups for summarizing.
3. **HAVING Clause**: Filter grouped data based on conditions.
4. **WHERE vs. HAVING**: Learn when to filter before or after grouping.
5. **Grouping Sets**: Create multiple summary levels in one query.
6. **Aggregations with JOINs**: Combine data from multiple tables for deeper analysis.

## Our Sample Database

We'll use a simple database with three tables: `sales`, `products`, and `date_dim`. Here's what they contain:

- **sales**: Tracks sales with columns like `sale_id`, `product_id`, `customer_id`, `sale_date`, `quantity`, `unit_price`, and `total_price`.
- **products**: Lists products with `product_id`, `product_name`, `category`, and `supplier`.
- **date_dim**: Helps with date analysis, with columns like `date_id`, `day_of_week`, `month`, `quarter`, and `year`.

Let's set these up so you can follow along!

### Setting Up the Sample Database

Run this SQL code to create and fill the tables:

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

## Visual Explanations

These text-based diagrams show the big picture of how SQL processes grouping and aggregations.

### Diagram 1: How GROUP BY Works
This shows how `GROUP BY` organizes rows into groups before summarizing them.

```
Rows in Table
  |
  v
[Group by Column]
  |--> Group 1 (e.g., product_id = 1) --> Aggregate (e.g., COUNT, SUM)
  |--> Group 2 (e.g., product_id = 2) --> Aggregate
  |--> Group 3 (e.g., product_id = 3) --> Aggregate
  |
  v
Summarized Results
```

### Diagram 2: WHERE vs. HAVING
This explains filtering before (`WHERE`) and after (`HAVING`) grouping.

```
Raw Data
  |
  v
[WHERE: Filter Rows]
  |--> Keep rows where condition is true
  |
  v
[GROUP BY: Group Rows]
  |--> Create groups
  |
  v
[Aggregate: COUNT, SUM, etc.]
  |
  v
[HAVING: Filter Groups]
  |--> Keep groups where condition is true
  |
  v
Final Results
```

### Diagram 3: SQL Query Execution Order
This shows the order SQL processes a query.

```
1. FROM (Get data from tables)
  |
2. JOIN (Combine tables)
  |
3. WHERE (Filter individual rows)
  |
4. GROUP BY (Group rows)
  |
5. HAVING (Filter groups)
  |
6. SELECT (Choose columns and aggregates)
  |
7. ORDER BY (Sort results)
  |
Final Output
```

## Topic 1: Aggregate Functions (COUNT, SUM, AVG, MIN, MAX)

**What They Do**: Aggregate functions take many values and return one result, like counting rows or finding an average.

- **COUNT**: Counts rows or non-null values.
- **SUM**: Adds up numbers.
- **AVG**: Finds the average.
- **MIN**: Finds the smallest value.
- **MAX**: Finds the largest value.

### Examples

1. **Total Number of Sales**
   ```sql
   SELECT COUNT(*) AS total_sales
   FROM sales;
   ```
   *What it does*: Counts all rows in the `sales` table.
   
   **Diagram: How COUNT Works**
   ```
   sales Table
   | sale_id | product_id | ... |
   |---------|------------|-----|
   |    1    |     1      | ... |
   |    2    |     2      | ... |
   |   ...   |    ...     | ... |
        |
        v
   COUNT(*) --> 10 rows (total_sales = 10)
   ```

2. **Total Revenue**
   ```sql
   SELECT SUM(total_price) AS total_revenue
   FROM sales;
   ```
   *What it does*: Adds up all `total_price` values.

   **Diagram: How SUM Works**
   ```
   sales Table
   | total_price |
   |-------------|
   |   51.98     |
   |   149.99    |
   |   ...       |
        |
        v
   SUM(total_price) --> Add all values --> total_revenue
   ```

3. **Average Sale Amount**
   ```sql
   SELECT AVG(total_price) AS average_sale
   FROM sales;
   ```
   *What it does*: Calculates the average of `total_price`.

4. **Smallest and Largest Sales**
   ```sql
   SELECT 
       MIN(total_price) AS min_sale,
       MAX(total_price) AS max_sale
   FROM sales;
   ```
   *What it does*: Finds the smallest and largest `total_price`.

5. **Unique Customers**
   ```sql
   SELECT COUNT(DISTINCT customer_id) AS unique_customers
   FROM sales;
   ```
   *What it does*: Counts unique `customer_id` values.

## Topic 2: GROUP BY Clause

**What It Does**: `GROUP BY` organizes rows with the same value in a column into groups, then summarizes each group.

### Examples

1. **Sales and Revenue by Product**
   ```sql
   SELECT 
       product_id,
       COUNT(*) AS sale_count,
       SUM(total_price) AS total_revenue
   FROM sales
   GROUP BY product_id
   ORDER BY total_revenue DESC;
   ```
   *What it does*: Groups sales by `product_id` and shows count and revenue per product.

   **Diagram: How GROUP BY Works for This Query**
   ```
   sales Table
   | product_id | total_price |
   |------------|-------------|
   |     1      |   51.98     |
   |     1      |   25.99     |
   |     2      |   149.99    |
   |     ...    |   ...       |
        |
        v
   GROUP BY product_id
   |--> Group: product_id=1 | COUNT=3, SUM=155.94
   |--> Group: product_id=2 | COUNT=2, SUM=299.98
   |--> ...
        |
        v
   Result: | product_id | sale_count | total_revenue |
           |------------|------------|---------------|
           |     1      |     3      |    155.94     |
           |     2      |     2      |    299.98     |
   ```

2. **Daily Sales**
   ```sql
   SELECT 
       sale_date,
       COUNT(*) AS transaction_count,
       SUM(total_price) AS daily_revenue
   FROM sales
   GROUP BY sale_date
   ORDER BY sale_date;
   ```
   *What it does*: Groups sales by date to show transactions and revenue per day.

3. **Units Sold by Product**
   ```sql
   SELECT 
       product_id,
       SUM(quantity) AS total_units_sold
   FROM sales
   GROUP BY product_id
   ORDER BY total_units_sold DESC;
   ```
   *What it does*: Shows total units sold per product.

4. **Average Sale by Customer**
   ```sql
   SELECT 
       customer_id,
       AVG(total_price) AS avg_sale_amount
   FROM sales
   GROUP BY customer_id
   ORDER BY avg_sale_amount DESC;
   ```
   *What it does*: Finds the average sale amount per customer.

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
   *What it does*: Groups sales by day of the week.

## Topic 3: HAVING Clause

**What It Does**: `HAVING` filters groups after `GROUP BY` based on aggregate conditions.

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
   *What it does*: Shows products with more than one sale.

   **Diagram: How HAVING Works**
   ```
   sales Table
        |
        v
   GROUP BY product_id
   |--> Group: product_id=1 | COUNT=3
   |--> Group: product_id=2 | COUNT=2
   |--> Group: product_id=3 | COUNT=2
   |--> Group: product_id=4 | COUNT=2
   |--> Group: product_id=5 | COUNT=1
        |
        v
   HAVING COUNT(*) > 1
   |--> Keep: product_id=1,2,3,4
   |--> Discard: product_id=5
        |
        v
   Result: | product_id | sale_count |
           |------------|------------|
           |     1      |     3      |
           |     2      |     2      |
           |     3      |     2      |
           |     4      |     2      |
   ```

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
   *What it does*: Finds products with over $100 in sales.

3. **High-Spending Customers**
   ```sql
   SELECT 
       customer_id,
       AVG(total_price) AS avg_purchase
   FROM sales
   GROUP BY customer_id
   HAVING AVG(total_price) > 50
   ORDER BY avg_purchase DESC;
   ```
   *What it does*: Shows customers with average purchases over $50.

4. **Busy Days**
   ```sql
   SELECT 
       sale_date,
       COUNT(*) AS transaction_count
   FROM sales
   GROUP BY sale_date
   HAVING COUNT(*) >= 2
   ORDER BY transaction_count DESC;
   ```
   *What it does*: Finds days with 2 or more sales.

5. **Expensive Categories**
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
   *What it does*: Shows categories with average unit prices over $30.

## Topic 4: WHERE vs. HAVING

**What It Does**: `WHERE` filters rows before grouping, `HAVING` filters groups after grouping. SQL order: `FROM` → `WHERE` → `GROUP BY` → `HAVING` → `SELECT` → `ORDER BY`.

### Examples

1. **Recent Sales by Product**
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
   *What it does*: Filters sales after January 20, then groups by product.

   **Diagram: WHERE and GROUP BY**
   ```
   sales Table
   | product_id | sale_date  | total_price |
   |------------|------------|-------------|
   |     1      | 2023-01-15 |   51.98     |
   |     1      | 2023-01-23 |   77.97     |
   |     ...    |  ...       |   ...       |
        |
        v
   WHERE sale_date > '2023-01-20'
   |--> Keep rows after Jan 20
        |
        v
   GROUP BY product_id
   |--> Group: product_id=1 | COUNT=1, SUM=77.97
   |--> ...
        |
        v
   Result: | product_id | sale_count | total_revenue |
           |------------|------------|---------------|
           |     1      |     1      |    77.97      |
           |    ...     |    ...     |    ...        |
   ```

2. **Filtered Average Prices**
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
   *What it does*: Filters sales after January 15, groups by product, keeps groups with average price over $20.

3. **High-Quantity Sales**
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
   *What it does*: Filters sales with quantity over 1, groups by customer, keeps customers with total quantity over 5.

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
   *What it does*: Filters sales from January 18, groups by category, keeps categories with multiple sales.

5. **High-Value Days**
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
   *What it does*: Filters sales over $50, groups by date, keeps days with over $100 in revenue.

## Topic 5: Grouping Sets

**What It Does**: Grouping Sets summarize data at multiple levels in one query, like totals by product and date, just by product, and overall.

### Examples

1. **Sales by Product and Date**
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
   *What it does*: Shows revenue by product and date, by product, and a grand total.

   **Diagram: How GROUPING SETS Works**
   ```
   sales Table
        |
        v
   GROUP BY GROUPING SETS
   |--> (product_id, sale_date) | SUM(total_price) per product and date
   |--> (product_id)            | SUM(total_price) per product
   |--> ()                     | SUM(total_price) for all rows
        |
        v
   Result: | product_id | sale_date  | total_revenue |
           |------------|------------|---------------|
           |     1      | 2023-01-15 |    51.98      |
           |     1      | 2023-01-18 |    25.99      |
           |     1      | NULL       |    155.94     |
           |    ...     | ...        |    ...        |
           |    NULL    | NULL       |    663.35     |
   ```

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
   *What it does*: Shows revenue by category and supplier, by category, and a grand total.

3. **Sales by Day and Month**
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
   *What it does*: Counts sales by day and month, by month, and a grand total.

4. **Units by Product and Category**
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
   *What it does*: Shows units sold by product and category, by category, and a grand total.

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
   *What it does*: Shows revenue by quarter and year, by year, and a grand total.

## Topic 6: Aggregate Functions with JOINs

**What It Does**: Combine `JOIN` with aggregates to summarize data across tables.

### Examples

1. **Sales by Product and Category**
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
   *What it does*: Shows sales count and revenue by product and category.

   **Diagram: How JOIN and GROUP BY Work**
   ```
   sales Table          products Table
   | product_id | ... |   | product_id | product_name | category |
   |------------|-----|   |------------|--------------|----------|
   |     1      | ... |   |     1      | Basic T-shirt| Clothing |
   |     2      | ... |   |     2      | Headphones   |Electronics|
        |                    |
        v                    v
   JOIN ON product_id
        |
        v
   Combined Table
   | product_id | product_name | category | total_price |
   |------------|--------------|----------|-------------|
   |     1      | Basic T-shirt| Clothing |   51.98     |
   |     ...    | ...          | ...      |   ...       |
        |
        v
   GROUP BY product_name, category
   |--> Group: Basic T-shirt, Clothing | COUNT=3, SUM=155.94
   |--> ...
        |
        v
   Result: | product_name  | category | sale_count | total_revenue |
           |---------------|----------|------------|---------------|
           | Basic T-shirt | Clothing |     3      |    155.94     |
           | ...           | ...      |    ...     |    ...        |
   ```

2. **Average Price by Category**
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
   *What it does*: Shows average price and sale count per category.

3. **Units by Supplier**
   ```sql
   SELECT 
       p.supplier,
       SUM(s.quantity) AS total_units_sold
   FROM sales s
   JOIN products p ON s.product_id = p.product_id
   GROUP BY p.supplier
   ORDER BY total_units_sold DESC;
   ```
   *What it does*: Shows total units sold per supplier.

4. **Sales by Category and Day**
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
   *What it does*: Shows revenue by category and day of the week.

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
   *What it does*: Shows products with over $50 in revenue, grouped by supplier and product.

## Practice Exercises

Try these exercises to test your skills! Use the `sales`, `products`, and `date_dim` tables above (or adapt for a `retail_store` database if available).

### Exercise 1: Basic Aggregations
1. Find total revenue for each product.
2. Calculate average order value per customer.
3. Count orders per customer.
4. Find the category with the most products.
5. Calculate total revenue by order status (if applicable).

### Exercise 2: Using HAVING
1. Find products sold more than 2 times.
2. Identify customers who spent over $500 total.
3. Find categories with average product prices over $50.
4. Find days with more than 3 sales.
5. Identify suppliers with total sales over $200.

### Exercise 3: Combining Filtering and Grouping
1. Find total sales by category for products with quantity > 20 (if applicable).
2. Calculate average order value by month for sales after January 15.
3. Count orders by customer for 2023 sales.
4. Find total revenue by product for sales after January 15, 2023.
5. Calculate average unit price by category for sales with quantity > 2.

### Exercise 4: Multiple Grouping Levels
1. Calculate sales by category and month.
2. Count products in price ranges (0-50, 51-100, 101-200, 200+) by category.
3. Find average order value by customer and order status (if applicable).
4. Summarize sales by supplier and day of week.
5. Calculate total revenue by product and quarter.

### Exercise 5: Challenge
Calculate the percentage of total revenue each product category represents, including categories with zero sales. Use a CTE or subquery to find the grand total and category totals.

## Additional Resources

- [PostgreSQL Aggregate Functions](https://www.postgresql.org/docs/current/functions-aggregate.html)
- [PostgreSQL GROUP BY](https://www.postgresql.org/docs/current/queries-table-expressions.html#QUERIES-GROUP)
- [PostgreSQL HAVING](https://www.postgresql.org/docs/current/queries-table-expressions.html#QUERIES-HAVING)
- [PostgreSQL GROUPING SETS](https://www.postgresql.org/docs/current/queries-table-expressions.html#QUERIES-GROUPING-SETS)

## Tips for Learning

- **Practice**: Run each example and tweak the queries to see what happens.
- **Know Your Data**: Understand the table columns to write better queries.
- **Start Simple**: Begin with basic aggregates, then add `GROUP BY` and `HAVING`.
- **Use Comments**: Add notes to your SQL to explain your steps.
- **Test Small**: Use the sample data to check your queries before trying bigger datasets.

Happy querying, and have fun mastering PostgreSQL grouping and aggregations!

