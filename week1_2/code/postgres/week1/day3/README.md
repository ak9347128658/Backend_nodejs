

# Day 3: Data Manipulation in PostgreSQL - INSERT, UPDATE, DELETE

Welcome to Day 3 of Week 1 in our PostgreSQL learning journey! Today, we'll dive into the core operations for manipulating data in a database: **INSERT**, **UPDATE**, and **DELETE**. We'll also explore the powerful **RETURNING** clause and how to perform **bulk operations**. This guide is designed to be beginner-friendly, with detailed explanations and plenty of examples to help you understand each concept.

## Topics Covered

1. **Inserting Data with INSERT**: Adding new records to a table.
2. **Updating Data with UPDATE**: Modifying existing records in a table.
3. **Deleting Data with DELETE**: Removing records from a table.
4. **RETURNING Clause**: Retrieving data affected by INSERT, UPDATE, or DELETE operations.
5. **Bulk Operations**: Efficiently handling multiple records in a single query.

## Prerequisites

Before starting, ensure you have a PostgreSQL database set up (we'll use the `retail_store` database from Day 2). If you need to recreate it, refer to the `exercises.sql` file for the schema.

---

## 1. Inserting Data with INSERT

The `INSERT` statement adds new rows (records) to a table. You specify the table, the columns to insert data into, and the values for those columns. This is how you populate your database with data.

### Key Points
- Use `INSERT INTO table_name (columns) VALUES (values)` for a single row.
- For multiple rows, list multiple sets of values in a single `VALUES` clause.
- You can omit columns with default values or auto-incrementing fields (e.g., `SERIAL`).
- Use subqueries to insert data derived from other tables.

### Examples

#### Example 1: Basic Single Row Insert
Insert a single employee into the `employees` table.

```sql
INSERT INTO employees (first_name, last_name, email, hire_date, salary)
VALUES ('Alice', 'Johnson', 'alice.johnson@example.com', '2025-01-10', 65000.00);
```

#### Example 2: Insert with Default Values
Insert a product into the `products` table, letting `stock_quantity` and `created_at` use their default values.

```sql
INSERT INTO products (product_name, price)
VALUES ('Tablet', 499.99);
```

#### Example 3: Multiple Row Insert
Insert three customers at once into the `customers` table.

```sql
INSERT INTO customers (first_name, last_name, email, phone, address)
VALUES 
    ('Bob', 'Smith', 'bob.smith@example.com', '555-111-2222', '123 Oak St, City'),
    ('Carol', 'Lee', 'carol.lee@example.com', '555-222-3333', '456 Pine St, City'),
    ('David', 'Kim', 'david.kim@example.com', '555-333-4444', '789 Maple St, City');
```

#### Example 4: Insert with Subquery
Copy employees hired before 2020 from `old_employees` to `employee_archive`.

```sql
INSERT INTO employee_archive (employee_id, full_name, department, hire_date, archived_date)
SELECT 
    employee_id, 
    first_name || ' ' || last_name, 
    department, 
    hire_date, 
    CURRENT_DATE
FROM old_employees
WHERE hire_date < '2020-01-01';
```

#### Example 5: Insert with Partial Columns
Insert a category, omitting the `description` column (which allows NULL).

```sql
INSERT INTO categories (name)
VALUES ('Books');
```

---

## 2. Updating Data with UPDATE

The `UPDATE` statement modifies existing records in a table. You specify which table to update, the columns to change, and a `WHERE` clause to target specific rows.

### Key Points
- Use `UPDATE table_name SET column = value WHERE condition`.
- You can update multiple columns in one query.
- Use calculations or expressions to compute new values.
- Always include a `WHERE` clause to avoid updating all rows unintentionally.

### Examples

#### Example 1: Basic Update
Increase the salary of an employee with `employee_id = 1`.

```sql
UPDATE employees
SET salary = 70000.00
WHERE employee_id = 1;
```

#### Example 2: Update Multiple Columns
Update both the email and phone number of a customer.

```sql
UPDATE customers
SET 
    email = 'new.john.doe@example.com',
    phone = '555-987-6543'
WHERE id = 1;
```

#### Example 3: Update with Calculation
Increase the price of all products in the `Electronics` category by 10%.

```sql
UPDATE products
SET price = price * 1.10
WHERE category_id = (SELECT id FROM categories WHERE name = 'Electronics');
```

#### Example 4: Update with a Condition
Set the status of all orders placed before July 1, 2025, to `Delivered`.

```sql
UPDATE orders
SET status = 'Delivered'
WHERE order_date < '2025-07-01';
```

#### Example 5: Update Using a Subquery
Increase inventory by 10 for products with fewer than 20 items in stock.

```sql
UPDATE products
SET inventory_count = inventory_count + 10
WHERE id IN (SELECT id FROM products WHERE inventory_count < 20);
```

---

## 3. Deleting Data with DELETE

The `DELETE` statement removes rows from a table based on a condition. Like `UPDATE`, it’s critical to use a `WHERE` clause to avoid deleting all rows.

### Key Points
- Use `DELETE FROM table_name WHERE condition`.
- Foreign key constraints (e.g., `ON DELETE CASCADE`) can automatically delete related rows.
- Deleting all rows without a `WHERE` clause empties the table (but keeps the structure).

### Examples

#### Example 1: Basic Delete
Remove an employee by their ID.

```sql
DELETE FROM employees
WHERE employee_id = 2;
```

#### Example 2: Delete with Condition
Remove products with zero inventory.

```sql
DELETE FROM products
WHERE inventory_count = 0;
```

#### Example 3: Delete Order and Related Items
Delete an order (related `order_items` are automatically deleted due to `ON DELETE CASCADE`).

```sql
DELETE FROM orders
WHERE id = 1;
```

#### Example 4: Delete Old Records
Remove customers who registered before 2023.

```sql
DELETE FROM customers
WHERE registration_date < '2023-01-01';
```

#### Example 5: Delete with Subquery
Remove products in categories with fewer than 5 products.

```sql
DELETE FROM products
WHERE category_id IN (
    SELECT category_id 
    FROM products 
    GROUP BY category_id 
    HAVING COUNT(*) < 5
);
```

---

## 4. RETURNING Clause

The `RETURNING` clause allows you to retrieve the rows affected by an `INSERT`, `UPDATE`, or `DELETE` operation. It’s like running a `SELECT` query on the modified rows immediately after the operation.

### Key Points
- Use `RETURNING column1, column2` or `RETURNING *` to return all columns.
- Useful for confirming changes or capturing generated values (e.g., `SERIAL` IDs).
- Can be used with all three operations: `INSERT`, `UPDATE`, and `DELETE`.

### Examples

#### Example 1: INSERT with RETURNING
Insert a product and return its ID and creation timestamp.

```sql
INSERT INTO products (product_name, price)
VALUES ('Headphones', 99.99)
RETURNING product_id, created_at;
```

#### Example 2: UPDATE with RETURNING
Update a customer’s address and return the updated details.

```sql
UPDATE customers
SET address = '999 New St, City'
WHERE id = 3
RETURNING id, first_name, last_name, address;
```

#### Example 3: DELETE with RETURNING
Delete an order and return its details.

```sql
DELETE FROM orders
WHERE id = 3
RETURNING id, customer_id, total_amount;
```

#### Example 4: INSERT with RETURNING All Columns
Insert a new employee and return all columns.

```sql
INSERT INTO employees (first_name, last_name, email, hire_date, salary)
VALUES ('Eve', 'Taylor', 'eve.taylor@example.com', '2025-02-01', 72000)
RETURNING *;
```

#### Example 5: UPDATE with RETURNING Calculated Value
Update product prices and return the new and old prices.

```sql
UPDATE products
SET price = price * 1.15
WHERE category_id = 2
RETURNING product_name, price AS new_price, price / 1.15 AS old_price;
```

---

## 5. Bulk Operations

Bulk operations allow you to insert, update, or delete multiple rows efficiently in a single query. This is faster than running individual queries for each row.

### Key Points
- Use multi-row `INSERT` for adding multiple records.
- Use subqueries or joins in `UPDATE` and `DELETE` to affect multiple rows.
- Bulk operations reduce database overhead and improve performance.

### Examples

#### Example 1: Bulk Insert
Insert multiple products at once.

```sql
INSERT INTO products (product_name, price, inventory_count, category_id)
VALUES 
    ('Mouse', 29.99, 100, 1),
    ('Keyboard', 59.99, 80, 1),
    ('Monitor', 199.99, 30, 1),
    ('Webcam', 79.99, 50, 1);
```

#### Example 2: Bulk Update with Join
Update prices for all products in a category using a join.

```sql
UPDATE products
SET price = price * 1.08
FROM categories
WHERE products.category_id = categories.id AND categories.name = 'Clothing';
```

#### Example 3: Bulk Delete with Subquery
Delete all orders from customers who haven’t ordered since 2024.

```sql
DELETE FROM orders
WHERE customer_id IN (
    SELECT id 
    FROM customers 
    WHERE registration_date < '2024-01-01'
);
```

#### Example 4: Bulk Insert with Subquery
Archive all orders older than one year into `archived_orders`.

```sql
INSERT INTO archived_orders (id, customer_id, order_date, total_amount, status)
SELECT id, customer_id, order_date, total_amount, status
FROM orders
WHERE order_date < CURRENT_DATE - INTERVAL '1 year';
```

#### Example 5: Bulk Update with Multiple Conditions
Update the status of multiple orders based on their total amount.

```sql
UPDATE orders
SET status = 'Processing'
WHERE total_amount > 1000 AND status = 'Pending';
```

---

## Practice Exercises

Try these exercises to reinforce your learning. Use the `retail_store` database.

1. **Insert Operations**
   - Insert 5 new customers with unique emails and addresses.
   - Add 3 new categories (e.g., Books, Toys, Appliances).
   - Insert 10 new products across different categories.
   - Create 3 new orders for different customers.
   - Add order items for each order, linking to existing products.

2. **Update Operations**
   - Increase the price of all products in the `Home & Kitchen` category by 5%.
   - Update the phone and email for a specific customer.
   - Change the status of all orders placed before July 2025 to `Delivered`.

3. **Delete Operations**
   - Delete a specific order and ensure its order items are also deleted (verify `ON DELETE CASCADE`).
   - Remove all products with zero inventory.
   - Attempt to delete a category and observe what happens to its products (hint: foreign key constraints).

4. **RETURNING Clause**
   - Insert a new product and return its ID and creation date.
   - Update a customer’s address and return the updated details.
   - Delete an order and return its details.

5. **Bulk Operations**
   - Insert 5 new products in one query.
   - Update the inventory of all products in a specific category.
   - Move all `Cancelled` orders to the `archived_orders` table and delete them from `orders`.

---

## Additional Resources

- [PostgreSQL INSERT Documentation](https://www.postgresql.org/docs/current/sql-insert.html)
- [PostgreSQL UPDATE Documentation](https://www.postgresql.org/docs/current/sql-update.html)
- [PostgreSQL DELETE Documentation](https://www.postgresql.org/docs/current/sql-delete.html)
- [PostgreSQL Tutorial](https://www.postgresqltutorial.com/)
- [SQL Style Guide](https://www.sqlstyle.guide/)

Happy querying! By the end of today, you’ll be confident in manipulating data in PostgreSQL.