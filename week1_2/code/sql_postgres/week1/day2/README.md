# Day 2: Data Types and Table Creation

## Topics Covered

1. PostgreSQL data types
2. Creating tables
3. Primary keys and foreign keys
4. Constraints
5. Modifying table structure

## Examples and Exercises

### Example 1: Basic Table Creation

```sql
CREATE TABLE employees (
    employee_id SERIAL PRIMARY KEY,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    email VARCHAR(100) UNIQUE,
    hire_date DATE,
    salary NUMERIC(10, 2)
);
```

### Example 2: Table with Constraints

```sql
CREATE TABLE products (
    product_id SERIAL PRIMARY KEY,
    product_name VARCHAR(100) NOT NULL,
    category VARCHAR(50) CHECK (category IN ('Electronics', 'Clothing', 'Books', 'Home', 'Other')),
    price NUMERIC(10, 2) CHECK (price > 0),
    stock_quantity INTEGER DEFAULT 0,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
```

### Example 3: Table with Foreign Key

```sql
-- Create departments table first
CREATE TABLE departments (
    department_id SERIAL PRIMARY KEY,
    department_name VARCHAR(100) NOT NULL,
    location VARCHAR(100)
);

-- Create employees table with foreign key
CREATE TABLE employees (
    employee_id SERIAL PRIMARY KEY,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    department_id INTEGER,
    FOREIGN KEY (department_id) REFERENCES departments(department_id)
);
```

### Example 4: Creating a Table with a Composite Key

```sql
CREATE TABLE course_enrollment (
    student_id INTEGER,
    course_id INTEGER,
    enrollment_date DATE,
    grade CHAR(1),
    PRIMARY KEY (student_id, course_id)
);
```

### Example 5: Modifying Tables

```sql
-- Add a column
ALTER TABLE employees ADD COLUMN phone VARCHAR(20);

-- Modify a column
ALTER TABLE employees ALTER COLUMN phone TYPE VARCHAR(30);

-- Add a constraint
ALTER TABLE employees ADD CONSTRAINT unique_email UNIQUE (email);

-- Drop a column
ALTER TABLE employees DROP COLUMN IF EXISTS temp_column;

-- Rename a column
ALTER TABLE employees RENAME COLUMN phone TO contact_number;
```

## Practice Exercises

1. Create a database called "retail_store".
2. Within this database, create the following tables with appropriate data types and constraints:
   - `customers` (id, first_name, last_name, email, phone, address)
   - `categories` (id, name, description)
   - `products` (id, name, description, price, stock_quantity, category_id)
   - `orders` (id, customer_id, order_date, total_amount, status)
   - `order_items` (order_id, product_id, quantity, unit_price)
3. Ensure all tables have primary keys.
4. Add appropriate foreign key relationships.
5. Add at least one CHECK constraint to a table.
6. Add a UNIQUE constraint to a column.
7. Modify one of your tables to add a new column.
8. Rename a column in one of your tables.

## Additional Resources

- [PostgreSQL Data Types Documentation](https://www.postgresql.org/docs/current/datatype.html)
- [CREATE TABLE Documentation](https://www.postgresql.org/docs/current/sql-createtable.html)
- [ALTER TABLE Documentation](https://www.postgresql.org/docs/current/sql-altertable.html)
