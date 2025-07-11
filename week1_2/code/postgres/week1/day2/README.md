

# Day 2: Data Types and Table Creation in PostgreSQL

This document provides a detailed explanation of the key concepts covered in Day 2 of Week 1 for learning PostgreSQL. It is designed to be beginner-friendly, with clear explanations and multiple examples for each topic to ensure a thorough understanding. The topics include PostgreSQL data types, creating tables, primary keys and foreign keys, constraints, and modifying table structures.

## Topics Covered

1. **PostgreSQL Data Types**  
   Understanding the various data types available in PostgreSQL to store different kinds of data.  
2. **Creating Tables**  
   How to create tables to organize data in a structured format.  
3. **Primary Keys and Foreign Keys**  
   Defining unique identifiers for records and establishing relationships between tables.  
4. **Constraints**  
   Enforcing rules on data to maintain integrity and consistency.  
5. **Modifying Table Structure**  
   Altering existing tables to add, modify, or remove columns and constraints.

---

## 1. PostgreSQL Data Types

PostgreSQL provides a rich set of data types to store different kinds of data. Choosing the right data type is crucial for efficient storage and querying. Below are some commonly used data types:

- **Numeric Types**: Store numbers (e.g., `INTEGER`, `NUMERIC`, `FLOAT`).  
- **INTEGER**:  
    Typically uses 4 bytes with a value range of -2,147,483,648 to 2,147,483,647.

- **NUMERIC**:  
    Supports a user-defined precision and scale, allowing virtually unlimited digits.

- **FLOAT (or DOUBLE PRECISION)**:  
    Uses 8 bytes for storing approximate numeric values.
- **Character Types**: Store text (e.g., `CHAR(n)`, `VARCHAR(1gb)`, `TEXT(can store strings of any length ,upto 1 GB)`).  
- **Date/Time Types**: Store dates and times (e.g., `DATE`, `TIMESTAMP`, `TIME`).  
- **Boolean Type**: Store true/false values (`BOOLEAN`).  
- **Serial Types**: Auto-incrementing integers (e.g., `SERIAL`, `BIGSERIAL`).  

### Table Creation Syntax
`Create table {table name} (
    // here define 
)`


### Examples

1. **INTEGER**: Stores whole numbers.  
   ```sql
   CREATE TABLE students (
       student_id INTEGER,
       age INTEGER
   );
   ```

2. **VARCHAR**: Stores variable-length text with a specified maximum length.  
   ```sql
   CREATE TABLE books (
       book_id SERIAL PRIMARY KEY,
       title VARCHAR(100)
   );
   ```

3. **NUMERIC**: Stores precise decimal numbers.  
   ```sql
   CREATE TABLE transactions (
       transaction_id SERIAL PRIMARY KEY,
       amount NUMERIC(10, 2)
   );
   ```

4. **DATE**: Stores calendar dates.  
   ```sql
   CREATE TABLE events (
       event_id SERIAL PRIMARY KEY,
       event_date DATE
   );
   ```

5. **TIMESTAMP**: Stores date and time with timezone support.  
   ```sql
   CREATE TABLE logs (
       log_id SERIAL PRIMARY KEY,
       created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
   );
   ```

### Explanation
- Use `INTEGER` for whole numbers like counts or IDs.  
- Use `VARCHAR(n)` for text with a maximum length of `n` characters.  
- Use `NUMERIC(precision, scale)` for exact decimal numbers (e.g., `NUMERIC(10, 2)` for up to 10 digits, 2 after the decimal).  
- Use `DATE` for calendar dates and `TIMESTAMP` for precise date-time values.  
- Use `SERIAL` for auto-incrementing IDs, commonly used for primary keys.

---

## 2. Creating Tables

Tables are the core structure in a relational database, used to store data in rows and columns. The `CREATE TABLE` statement defines the table's structure, including column names, data types, and constraints.

### Examples

1. **Basic Table**: A simple table for storing customer information.  
   ```sql
   CREATE TABLE customers (
       customer_id SERIAL PRIMARY KEY,
       first_name VARCHAR(50),
       last_name VARCHAR(50)
   );
   ```

2. **Table with Multiple Columns**: A table for inventory items.  
   ```sql
   CREATE TABLE inventory (
       item_id SERIAL PRIMARY KEY,
       item_name VARCHAR(100),
       quantity INTEGER,
       price NUMERIC(8, 2)
   );
   ```

3. **Table with Default Values**: A table for tasks with a default status.  
   ```sql
   CREATE TABLE tasks (
       task_id SERIAL PRIMARY KEY,
       task_name VARCHAR(100),
       status VARCHAR(20) DEFAULT 'Pending'
   );
   ```

4. **Table with Mixed Data Types**: A table for user profiles.  
   ```sql
   CREATE TABLE user_profiles (
       user_id SERIAL PRIMARY KEY,
       username VARCHAR(50),
       birth_date DATE,
       is_active BOOLEAN DEFAULT TRUE
   );
   ```

5. **Table for Logging**: A table for tracking user actions.  
   ```sql
   CREATE TABLE user_logs (
       log_id SERIAL PRIMARY KEY,
       user_id INTEGER,
       action VARCHAR(100),
       action_time TIMESTAMP DEFAULT CURRENT_TIMESTAMP
   );
   ```

### Explanation
- The `CREATE TABLE` statement specifies the table name and its columns.  
- Each column is defined with a name and a data type.  
- Use `SERIAL` for auto-incrementing IDs, which are ideal for primary keys.  
- Default values (e.g., `DEFAULT 'Pending'`) ensure columns have a value if none is provided during insertion.

---

## 3. Primary Keys and Foreign Keys

- **Primary Key**: A unique identifier for each record in a table. It ensures no two rows have the same key value and cannot be `NULL`.  
- **Foreign Key**: A column that references the primary key of another table, establishing a relationship between tables.

### Examples

1. **Primary Key with SERIAL**: A table with a single primary key.  
   ```sql
   CREATE TABLE users (
       user_id SERIAL PRIMARY KEY,
       username VARCHAR(50) NOT NULL
   );
   ```

2. **Composite Primary Key**: A table with a composite key (multiple columns).  
   ```sql
   CREATE TABLE enrollments (
       student_id INTEGER,
       course_id INTEGER,
       enrollment_date DATE,
       PRIMARY KEY (student_id, course_id)
   );
   ```

3. **Foreign Key Reference**: A table referencing another table’s primary key.  
   ```sql
   CREATE TABLE departments (
       dept_id SERIAL PRIMARY KEY,
       dept_name VARCHAR(100)
   );

   CREATE TABLE employees (
       emp_id SERIAL PRIMARY KEY,
       first_name VARCHAR(50),
       dept_id INTEGER,
       FOREIGN KEY (dept_id) REFERENCES departments(dept_id)
   );
   ```

4. **Multiple Foreign Keys**: A table with multiple relationships.  
   ```sql
   CREATE TABLE orders (
       order_id SERIAL PRIMARY KEY,
       customer_id INTEGER,
       employee_id INTEGER,
       order_date DATE,
       FOREIGN KEY (customer_id) REFERENCES customers(id),
       FOREIGN KEY (employee_id) REFERENCES employees(emp_id)
   );
   ```

5. **Self-Referencing Foreign Key**: A table where a column references its own primary key.  
   ```sql
   CREATE TABLE employees (
       emp_id SERIAL PRIMARY KEY,
       name VARCHAR(50),
       manager_id INTEGER,
       FOREIGN KEY (manager_id) REFERENCES employees(emp_id)
   );
   ```

### Explanation
- A primary key ensures each record is unique and can be used to reference records in other tables.  
- A foreign key links two tables, enforcing referential integrity (e.g., you cannot insert an employee with a non-existent department ID).  
- Composite keys are used when a single column isn’t enough to uniquely identify a record.  
- Self-referencing foreign keys are useful for hierarchical data, like an employee reporting to another employee.

---

## 4. Constraints

Constraints enforce rules on data to maintain integrity and consistency. Common constraints include `NOT NULL`, `UNIQUE`, `CHECK`, `PRIMARY KEY`, and `FOREIGN KEY`.

### Examples

1. **NOT NULL Constraint**: Ensures a column cannot be empty.  
   ```sql
   CREATE TABLE students (
       student_id SERIAL PRIMARY KEY,
       first_name VARCHAR(50) NOT NULL,
       last_name VARCHAR(50) NOT NULL
   );
   ```

2. **UNIQUE Constraint**: Ensures all values in a column are unique.  
   ```sql
   CREATE TABLE accounts (
       account_id SERIAL PRIMARY KEY,
       email VARCHAR(100) UNIQUE,
       username VARCHAR(50)
   );
   ```

3. **CHECK Constraint**: Enforces a condition on a column’s values.  
   ```sql
   CREATE TABLE products (
       product_id SERIAL PRIMARY KEY,
       price NUMERIC(10, 2) CHECK (price > 0)
   );
   ```

4. **DEFAULT Constraint**: Sets a default value for a column.  
   ```sql
   CREATE TABLE orders (
       order_id SERIAL PRIMARY KEY,
       status VARCHAR(20) DEFAULT 'Pending'
   );
   ```

5. **Combined Constraints**: A table with multiple constraints.  
   ```sql
   CREATE TABLE inventory (
       item_id SERIAL PRIMARY KEY,
       item_name VARCHAR(100) NOT NULL,
       category VARCHAR(50) CHECK (category IN ('Electronics', 'Clothing', 'Books')),
       stock INTEGER DEFAULT 0 CHECK (stock >= 0)
   );
   ```

### Explanation
- `NOT NULL` ensures a column always has a value.  
- `UNIQUE` prevents duplicate values in a column (e.g., no two users can have the same email).  
- `CHECK` enforces specific conditions (e.g., price must be positive).  
- `DEFAULT` provides a fallback value if none is specified.  
- Constraints can be combined to enforce complex rules on data.

---

## 5. Modifying Table Structure

The `ALTER TABLE` statement allows you to modify an existing table’s structure, such as adding columns, changing data types, or adding/removing constraints.

### Examples

1. **Add a Column**: Adding a new column to an existing table.  
   ```sql
   ALTER TABLE customers ADD COLUMN phone VARCHAR(20);
   ```

2. **Modify a Column’s Data Type**: Changing the data type of a column.  
   ```sql
   ALTER TABLE customers ALTER COLUMN phone TYPE VARCHAR(30);
   ```

3. **Add a Constraint**: Adding a `UNIQUE` constraint to a column.  
   ```sql
   ALTER TABLE customers ADD CONSTRAINT unique_email UNIQUE (email);
   ```

4. **Drop a Column**: Removing a column from a table.  
   ```sql
   ALTER TABLE customers DROP COLUMN IF EXISTS temp_column;
   ```

5. **Rename a Column**: Renaming an existing column.  
   ```sql
   ALTER TABLE customers RENAME COLUMN phone TO contact_number;
   ```

### Explanation
- `ALTER TABLE` is used to modify table structure after creation.  
- Use `ADD COLUMN` to add new columns, specifying the data type.  
- Use `ALTER COLUMN` to change a column’s data type or other properties.  
- Use `ADD CONSTRAINT` to add rules like `UNIQUE` or `CHECK`.  
- Use `DROP COLUMN` to remove unnecessary columns, and `RENAME COLUMN` to change column names.

---

## Practice Exercises

To solidify your understanding, complete the following exercises:

1. **Create a Database**: Create a database called `retail_store`.  
   ```sql
   CREATE DATABASE retail_store;
   ```

2. **Create Tables**: Create the following tables with appropriate data types and constraints:  
   - `customers` (id, first_name, last_name, email, phone, address)  
   - `categories` (id, name, description)  
   - `products` (id, name, description, price, stock_quantity, category_id)  
   - `orders` (id, customer_id, order_date, total_amount, status)  
   - `order_items` (order_id, product_id, quantity, unit_price)  

3. **Add Primary Keys**: Ensure all tables have primary keys.  
4. **Add Foreign Keys**: Establish relationships (e.g., `products.category_id` references `categories.id`).  
5. **Add a CHECK Constraint**: Add a `CHECK` constraint to the `products` table to ensure `price > 0`.  
6. **Add a UNIQUE Constraint**: Add a `UNIQUE` constraint to the `email` column in `customers`.  
7. **Add a New Column**: Add a `registration_date` column to the `customers` table.  
8. **Rename a Column**: Rename `stock_quantity` to `inventory_count` in the `products` table.

### Solution to Exercises

```sql
-- Create database
CREATE DATABASE retail_store;

-- Connect to the database
-- \c retail_store

-- Create customers table
CREATE TABLE customers (
    id SERIAL PRIMARY KEY,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    email VARCHAR(100) UNIQUE,
    phone VARCHAR(20),
    address TEXT
);

-- Create categories table
CREATE TABLE categories (
    id SERIAL PRIMARY KEY,
    name VARCHAR(50) NOT NULL,
    description TEXT
);

-- Create products table
CREATE TABLE products (
    id SERIAL PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    description TEXT,
    price NUMERIC(10, 2) CHECK (price > 0),
    stock_quantity INTEGER DEFAULT 0,
    category_id INTEGER,
    FOREIGN KEY (category_id) REFERENCES categories(id)
);

-- Create orders table
CREATE TABLE orders (
    id SERIAL PRIMARY KEY,
    customer_id INTEGER,
    order_date DATE DEFAULT CURRENT_DATE,
    total_amount NUMERIC(12, 2) CHECK (total_amount >= 0),
    status VARCHAR(20) DEFAULT 'Pending' CHECK (status IN ('Pending', 'Processing', 'Shipped', 'Delivered', 'Cancelled')),
    FOREIGN KEY (customer_id) REFERENCES customers(id)
);

-- Create order_items table
CREATE TABLE order_items (
    order_id INTEGER,
    product_id INTEGER,
    quantity INTEGER CHECK (quantity > 0),
    unit_price NUMERIC(10, 2),
    PRIMARY KEY (order_id, product_id),
    FOREIGN KEY (order_id) REFERENCES orders(id),
    FOREIGN KEY (product_id) REFERENCES products(id)
);

-- Add a new column
ALTER TABLE customers ADD COLUMN registration_date DATE DEFAULT CURRENT_DATE;

-- Rename a column
ALTER TABLE products RENAME COLUMN stock_quantity TO inventory_count;
```

---

## Additional Resources

- [PostgreSQL Data Types Documentation](https://www.postgresql.org/docs/current/datatype.html)  
- [CREATE TABLE Documentation](https://www.postgresql.org/docs/current/sql-createtable.html)  
- [ALTER TABLE Documentation](https://www.postgresql.org/docs/current/sql-altertable.html)  
- [PostgreSQL Constraints](https://www.postgresql.org/docs/current/ddl-constraints.html)  
- [PostgreSQL Tutorial](https://www.postgresqltutorial.com/)

This document provides a comprehensive introduction to PostgreSQL data types, table creation, and management. By working through the examples and exercises, you’ll gain hands-on experience with PostgreSQL’s core features.
