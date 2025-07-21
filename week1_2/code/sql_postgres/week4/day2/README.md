

# Day 2: Database Design Principles

This document provides a comprehensive guide to **Database Design Principles** for PostgreSQL, tailored for Week 4, Day 2 of our SQL course. It includes detailed explanations, at least five examples per topic with accompanying Mermaid JS diagrams for visualization, and practice exercises to reinforce learning. The goal is to make complex concepts accessible and engaging for students through clear text and visual aids.

---

## Topics Covered

1. **Normalization**
2. **Denormalization**
3. **Entity-Relationship (ER) Modeling**
4. **Keys and Constraints**
5. **Referential Integrity**
6. **Designing for Performance**
7. **Best Practices**

---

## 1. Normalization

**Definition**: Normalization organizes data to eliminate redundancy and ensure data integrity by decomposing tables into smaller, related ones based on normal forms (1NF, 2NF, 3NF, BCNF).

### Why Normalize?
- Reduces data redundancy.
- Prevents anomalies during INSERT, UPDATE, and DELETE operations.
- Ensures data consistency.

### Normal Forms Explained
- **1NF (First Normal Form)**: Ensures atomic (indivisible) values and unique rows.
- **2NF (Second Normal Form)**: Requires 1NF and eliminates partial dependencies.
- **3NF (Third Normal Form)**: Requires 2NF and eliminates transitive dependencies.
- **BCNF (Boyce-Codd Normal Form)**: A stricter 3NF where every determinant is a candidate key.

### Examples with Mermaid Diagrams

1. **1NF Example**: Converting a table with non-atomic values.
   ```sql
   -- Non-1NF: Multiple phone numbers in one column
   CREATE TABLE contacts_non_1nf (
       contact_id SERIAL PRIMARY KEY,
       name TEXT,
       phones TEXT -- e.g., "123-456-7890, 987-654-3210"
   );
   -- 1NF: Split phones into atomic values
   CREATE TABLE contacts_1nf (
       contact_id SERIAL PRIMARY KEY,
       name TEXT NOT NULL,
       phone TEXT NOT NULL
   );
   ```
   **Mermaid Diagram**:
   ```mermaid
   erDiagram
       CONTACTS_NON_1NF {
           int contact_id PK
           string name
           string phones
       }
       CONTACTS_1NF {
           int contact_id PK
           string name
           string phone
       }
   ```

2. **2NF Example**: Separating partial dependencies.
   ```sql
   -- Non-2NF: Order details mixed with product info
   CREATE TABLE orders_non_2nf (
       order_id SERIAL PRIMARY KEY,
       customer_id INTEGER,
       product_id INTEGER,
       product_name TEXT, -- Depends only on product_id
       order_date DATE
   );
   -- 2NF: Split into orders and order_items
   CREATE TABLE orders_2nf (
       order_id SERIAL PRIMARY KEY,
       customer_id INTEGER NOT NULL,
       order_date DATE NOT NULL
   );
   CREATE TABLE order_items_2nf (
       order_item_id SERIAL PRIMARY KEY,
       order_id INTEGER REFERENCES orders_2nf(order_id),
       product_id INTEGER NOT NULL,
       product_name TEXT NOT NULL
   );
   ```
   **Mermaid Diagram**:
   ```mermaid
   erDiagram
       ORDERS_NON_2NF {
           int order_id PK
           int customer_id
           int product_id
           string product_name
           date order_date
       }
       ORDERS_2NF ||--o{ ORDER_ITEMS_2NF : contains
       ORDERS_2NF {
           int order_id PK
           int customer_id
           date order_date
       }
       ORDER_ITEMS_2NF {
           int order_item_id PK
           int order_id FK
           int product_id
           string product_name
       }
   ```

3. **3NF Example**: Removing transitive dependencies.
   ```sql
   -- Non-3NF: Department name depends on department_id
   CREATE TABLE employees_non_3nf (
       employee_id SERIAL PRIMARY KEY,
       name TEXT,
       department_id INTEGER,
       department_name TEXT -- Transitive dependency
   );
   -- 3NF: Separate departments
   CREATE TABLE departments_3nf (
       department_id SERIAL PRIMARY KEY,
       department_name TEXT NOT NULL
   );
   CREATE TABLE employees_3nf (
       employee_id SERIAL PRIMARY KEY,
       name TEXT NOT NULL,
       department_id INTEGER REFERENCES departments_3nf(department_id)
   );
   ```
   **Mermaid Diagram**:
   ```mermaid
   erDiagram
       EMPLOYEES_NON_3NF {
           int employee_id PK
           string name
           int department_id
           string department_name
       }
       DEPARTMENTS_3NF ||--o{ EMPLOYEES_3NF : employs
       DEPARTMENTS_3NF {
           int department_id PK
           string department_name
       }
       EMPLOYEES_3NF {
           int employee_id PK
           string name
           int department_id FK
       }
   ```

4. **BCNF Example**: Ensuring every determinant is a candidate key.
   ```sql
   -- Non-BCNF: Professor teaches one subject, subject tied to course
   CREATE TABLE teaching_non_bcnf (
       professor_id INTEGER,
       course_id INTEGER,
       subject TEXT, -- subject determines professor
       PRIMARY KEY (professor_id, course_id)
   );
   -- BCNF: Split to enforce determinants
   CREATE TABLE subjects (
       subject_id SERIAL PRIMARY KEY,
       subject_name TEXT NOT NULL,
       professor_id INTEGER NOT NULL
   );
   CREATE TABLE teaching_bcnf (
       professor_id INTEGER REFERENCES subjects(professor_id),
       course_id INTEGER,
       PRIMARY KEY (professor_id, course_id)
   );
   ```
   **Mermaid Diagram**:
   ```mermaid
   erDiagram
       TEACHING_NON_BCNF {
           int professor_id PK
           int course_id PK
           string subject
       }
       SUBJECTS ||--o{ TEACHING_BCNF : teaches
       SUBJECTS {
           int subject_id PK
           string subject_name
           int professor_id
       }
       TEACHING_BCNF {
           int professor_id FK
           int course_id PK
       }
   ```

5. **Pitfall Example**: Over-normalization causing complex queries.
   ```sql
   -- Over-normalized: Splitting address excessively
   CREATE TABLE addresses_over_normalized (
       address_id SERIAL PRIMARY KEY,
       street_id INTEGER,
       city_id INTEGER,
       state_id INTEGER
   );
   CREATE TABLE streets (
       street_id SERIAL PRIMARY KEY,
       street_name TEXT
   );
   -- Better: Combine for simpler queries
   CREATE TABLE addresses (
       address_id SERIAL PRIMARY KEY,
       street TEXT,
       city TEXT,
       state TEXT
   );
   ```
   **Mermaid Diagram**:
   ```mermaid
   erDiagram
       ADDRESSES_OVER_NORMALIZED {
           int address_id PK
           int street_id
           int city_id
           int state_id
       }
       STREETS {
           int street_id PK

System: **Definition**: Denormalization involves adding redundant data to tables to improve query performance, often at the cost of increased storage and potential data inconsistency.

### When to Denormalize?
- For read-heavy applications where speed is critical.
- When joins are too slow for frequent queries.
- For reporting or analytics requiring aggregated data.

### Trade-offs
- **Pros**: Faster reads, simpler queries.
- **Cons**: Increased storage, risk of data anomalies, complex updates.

### Examples with Mermaid Diagrams

1. **Denormalized Sales Table**:
   ```sql
   CREATE TABLE sales_denorm (
       sale_id SERIAL PRIMARY KEY,
       product_id INTEGER NOT NULL,
       product_name TEXT NOT NULL, -- Denormalized
       sale_date DATE NOT NULL,
       amount NUMERIC(10,2) NOT NULL
   );
   ```
   **Mermaid Diagram**:
   ```mermaid
   erDiagram
       SALES_DENORM {
           int sale_id PK
           int product_id
           string product_name
           date sale_date
           decimal amount
       }
   ```

2. **Customer Order Summary**:
   ```sql
   CREATE TABLE customer_orders_denorm (
       customer_id INTEGER PRIMARY KEY,
       customer_name TEXT NOT NULL, -- Denormalized
       total_orders INTEGER NOT NULL,
       total_amount NUMERIC(10,2) NOT NULL
   );
   ```
   **Mermaid Diagram**:
   ```mermaid
   erDiagram
       CUSTOMER_ORDERS_DENORM {
           int customer_id PK
           string customer_name
           int total_orders
           decimal total_amount
       }
   ```

3. **Product Stock with Category**:
   ```sql
   CREATE TABLE products_denorm (
       product_id SERIAL PRIMARY KEY,
       name TEXT NOT NULL,
       category_name TEXT NOT NULL, -- Denormalized
       stock INTEGER NOT NULL
   );
   ```
   **Mermaid Diagram**:
   ```mermaid
   erDiagram
       PRODUCTS_DENORM {
           int product_id PK
           string name
           string category_name
           int stock
       }
   ```

4. **Employee Department Info**:
   ```sql
   CREATE TABLE employees_denorm (
       employee_id SERIAL PRIMARY KEY,
       name TEXT NOT NULL,
       department_name TEXT NOT NULL -- Denormalized
   );
   ```
   **Mermaid Diagram**:
   ```mermaid
   erDiagram
       EMPLOYEES_DENORM {
           int employee_id PK
           string name
           string department_name
       }
   ```

5. **Order Details with Customer**:
   ```sql
   CREATE TABLE orders_denorm (
       order_id SERIAL PRIMARY KEY,
       customer_name TEXT NOT NULL, -- Denormalized
       order_date DATE NOT NULL,
       total_amount NUMERIC(10,2) NOT NULL
   );
   ```
   **Mermaid Diagram**:
   ```mermaid
   erDiagram
       ORDERS_DENORM {
           int order_id PK
           string customer_name
           date order_date
           decimal total_amount
       }
   ```

---

## 3. Entity-Relationship (ER) Modeling

**Definition**: ER modeling represents database structures using entities (objects), relationships (associations), and attributes (properties).

### Components
- **Entities**: Objects like "Student" or "Course".
- **Relationships**: Connections like "enrolls in".
- **Attributes**: Properties like "name" or "course_id".

### Examples with Mermaid Diagrams

1. **Student-Course Enrollment**:
   ```sql
   CREATE TABLE students (
       student_id SERIAL PRIMARY KEY,
       name TEXT NOT NULL
   );
   CREATE TABLE courses (
       course_id SERIAL PRIMARY KEY,
       title TEXT NOT NULL
   );
   CREATE TABLE enrollments (
       enrollment_id SERIAL PRIMARY KEY,
       student_id INTEGER REFERENCES students(student_id),
       course_id INTEGER REFERENCES courses(course_id),
       enrolled_on DATE NOT NULL
   );
   ```
   **Mermaid Diagram**:
   ```mermaid
   erDiagram
       STUDENTS ||--o{ ENROLLMENTS : enrolls
       COURSES ||--o{ ENROLLMENTS : offers
       STUDENTS {
           int student_id PK
           string name
       }
       COURSES {
           int course_id PK
           string title
       }
       ENROLLMENTS {
           int enrollment_id PK
           int student_id FK
           int course_id FK
           date enrolled_on
       }
   ```

2. **Library System**:
   ```sql
   CREATE TABLE authors (
       author_id SERIAL PRIMARY KEY,
       name TEXT NOT NULL
   );
   CREATE TABLE books (
       book_id SERIAL PRIMARY KEY,
       title TEXT NOT NULL,
       author_id INTEGER REFERENCES authors(author_id)
   );
   CREATE TABLE borrowers (
       borrower_id SERIAL PRIMARY KEY,
       name TEXT NOT NULL
   );
   CREATE TABLE loans (
       loan_id SERIAL PRIMARY KEY,
       book_id INTEGER REFERENCES books(book_id),
       borrower_id INTEGER REFERENCES borrowers(borrower_id),
       borrowed_date DATE NOT NULL
   );
   ```
   **Mermaid Diagram**:
   ```mermaid
   erDiagram
       AUTHOR ||--o{ BOOK : writes
       BOOK ||--o{ LOAN : borrowed
       BORROWER ||--o{ LOAN : borrows
       AUTHOR {
           int author_id PK
           string name
       }
       BOOK {
           int book_id PK
           string title
           int author_id FK
       }
       BORROWER {
           int borrower_id PK
           string name
       }
       LOAN {
           int loan_id PK
           int book_id FK
           int borrower_id FK
           date borrowed_date
       }
   ```

3. **Employee-Project Assignment**:
   ```sql
   CREATE TABLE employees (
       employee_id SERIAL PRIMARY KEY,
       name TEXT NOT NULL
   );
   CREATE TABLE projects (
       project_id SERIAL PRIMARY KEY,
       project_name TEXT NOT NULL
   );
   CREATE TABLE assignments (
       assignment_id SERIAL PRIMARY KEY,
       employee_id INTEGER REFERENCES employees(employee_id),
       project_id INTEGER REFERENCES projects(project_id)
   );
   ```
   **Mermaid Diagram**:
   ```mermaid
   erDiagram
       EMPLOYEES ||--o{ ASSIGNMENTS : assigned
       PROJECTS ||--o{ ASSIGNMENTS : includes
       EMPLOYEES {
           int employee_id PK
           string name
       }
       PROJECTS {
           int project_id PK
           string project_name
       }
       ASSIGNMENTS {
           int assignment_id PK
           int employee_id FK
           int project_id FK
       }
   ```

4. **Order-Product Relationship**:
   ```sql
   CREATE TABLE orders (
       order_id SERIAL PRIMARY KEY,
       order_date DATE NOT NULL
   );
   CREATE TABLE products (
       product_id SERIAL PRIMARY KEY,
       name TEXT NOT NULL
   );
   CREATE TABLE order_products (
       order_product_id SERIAL PRIMARY KEY,
       order_id INTEGER REFERENCES orders(order_id),
       product_id INTEGER REFERENCES products(product_id),
       quantity INTEGER NOT NULL
   );
   ```
   **Mermaid Diagram**:
   ```mermaid
   erDiagram
       ORDERS ||--o{ ORDER_PRODUCTS : contains
       PRODUCTS ||--o{ ORDER_PRODUCTS : included
       ORDERS {
           int order_id PK
           date order_date
       }
       PRODUCTS {
           int product_id PK
           string name
       }
       ORDER_PRODUCTS {
           int order_product_id PK
           int order_id FK
           int product_id FK
           int quantity
       }
   ```

5. **Department-Employee Hierarchy**:
   ```sql
   CREATE TABLE departments (
       department_id SERIAL PRIMARY KEY,
       name TEXT NOT NULL
   );
   CREATE TABLE employees (
       employee_id SERIAL PRIMARY KEY,
       name TEXT NOT NULL,
       department_id INTEGER REFERENCES departments(department_id)
   );
   ```
   **Mermaid Diagram**:
   ```mermaid
   erDiagram
       DEPARTMENTS ||--o{ EMPLOYEES : employs
       DEPARTMENTS {
           int department_id PK
           string name
       }
       EMPLOYEES {
           int employee_id PK
           string name
           int department_id FK
       }
   ```

---

## 4. Keys and Constraints

**Definition**: Keys and constraints enforce rules to maintain data integrity and consistency.

### Types
- **Primary Key**: Uniquely identifies each row.
- **Foreign Key**: Links tables to ensure referential integrity.
- **Unique**: Ensures unique values in a column.
- **Check**: Enforces a condition on column values.
- **Not Null**: Prevents null values.

### Examples with Mermaid Diagrams

1. **Primary Key**:
   ```sql
   CREATE TABLE users (
       user_id SERIAL PRIMARY KEY,
       email TEXT NOT NULL
   );
   ```
   **Mermaid Diagram**:
   ```mermaid
   erDiagram
       USERS {
           int user_id PK
           string email
       }
   ```

2. **Foreign Key**:
   ```sql
   CREATE TABLE orders (
       order_id SERIAL PRIMARY KEY,
       customer_id INTEGER REFERENCES customers(customer_id)
   );
   ```
   **Mermaid Diagram**:
   ```mermaid
   erDiagram
       CUSTOMERS ||--o{ ORDERS : places
       CUSTOMERS {
           int customer_id PK
       }
       ORDERS {
           int order_id PK
           int customer_id FK
       }
   ```

3. **Unique Constraint**:
   ```sql
   CREATE TABLE products (
       product_id SERIAL PRIMARY KEY,
       sku TEXT UNIQUE NOT NULL
   );
   ```
   **Mermaid Diagram**:
   ```mermaid
   erDiagram
       PRODUCTS {
           int product_id PK
           string sku UNIQUE
       }
   ```

4. **Check Constraint**:
   ```sql
   CREATE TABLE employees (
       employee_id SERIAL PRIMARY KEY,
       salary NUMERIC(10,2) CHECK (salary > 0)
   );
   ```
   **Mermaid Diagram**:
   ```mermaid
   erDiagram
       EMPLOYEES {
           int employee_id PK
           decimal salary CHECK
       }
   ```

5. **Not Null Constraint**:
   ```sql
   CREATE TABLE customers (
       customer_id SERIAL PRIMARY KEY,
       name TEXT NOT NULL,
       email TEXT NOT NULL
   );
   ```
   **Mermaid Diagram**:
   ```mermaid
   erDiagram
       CUSTOMERS {
           int customer_id PK
           string name NOTNULL
           string email NOTNULL
       }
   ```

---

## 5. Referential Integrity

**Definition**: Referential integrity ensures foreign key values match primary key values in the referenced table, maintaining valid relationships.

### Cascading Actions
- **ON DELETE CASCADE**: Deletes child records when the parent is deleted.
- **ON UPDATE SET NULL**: Sets foreign key to NULL if the parent key is updated.

### Examples with Mermaid Diagrams

1. **ON DELETE CASCADE**:
   ```sql
   CREATE TABLE customers (
       customer_id SERIAL PRIMARY KEY,
       name TEXT NOT NULL
   );
   CREATE TABLE orders (
       order_id SERIAL PRIMARY KEY,
       customer_id INTEGER REFERENCES customers(customer_id) ON DELETE CASCADE
   );
   ```
   **Mermaid Diagram**:
   ```mermaid
   erDiagram
       CUSTOMERS ||--o{ ORDERS : places
       CUSTOMERS {
           int customer_id PK
           string name
       }
       ORDERS {
           int order_id PK
           int customer_id FK "ON DELETE CASCADE"
       }
   ```

2. **ON UPDATE SET NULL**:
   ```sql
   CREATE TABLE departments (
       department_id SERIAL PRIMARY KEY,
       name TEXT NOT NULL
   );
   CREATE TABLE employees (
       employee_id SERIAL PRIMARY KEY,
       department_id INTEGER REFERENCES departments(department_id) ON UPDATE SET NULL
   );
   ```
   **Mermaid Diagram**:
   ```mermaid
   erDiagram
       DEPARTMENTS ||--o{ EMPLOYEES : employs
       DEPARTMENTS {
           int department_id PK
           string name
       }
       EMPLOYEES {
           int employee_id PK
           int department_id FK "ON UPDATE SET NULL"
       }
   ```

3. **ON DELETE RESTRICT**:
   ```sql
   CREATE TABLE projects (
       project_id SERIAL PRIMARY KEY,
       name TEXT NOT NULL
   );
   CREATE TABLE tasks (
       task_id SERIAL PRIMARY KEY,
       project_id INTEGER REFERENCES projects(project_id) ON DELETE RESTRICT
   );
   ```
   **Mermaid Diagram**:
   ```mermaid
   erDiagram
       PROJECTS ||--o{ TASKS : includes
       PROJECTS {
           int project_id PK
           string name
       }
       TASKS {
           int task_id PK
           int project_id FK "ON DELETE RESTRICT"
       }
   ```

4. **ON UPDATE CASCADE**:
   ```sql
   CREATE TABLE vendors (
       vendor_id SERIAL PRIMARY KEY,
       name TEXT NOT NULL
   );
   CREATE TABLE contracts (
       contract_id SERIAL PRIMARY KEY,
       vendor_id INTEGER REFERENCES vendors(vendor_id) ON UPDATE CASCADE
   );
   ```
   **Mermaid Diagram**:
   ```mermaid
   erDiagram
       VENDORS ||--o{ CONTRACTS : signs
       VENDORS {
           int vendor_id PK
           string name
       }
       CONTRACTS {
           int contract_id PK
           int vendor_id FK "ON UPDATE CASCADE"
       }
   ```

5. **Combined Constraints**:
   ```sql
   CREATE TABLE categories (
       category_id SERIAL PRIMARY KEY,
       name TEXT NOT NULL
   );
   CREATE TABLE products (
       product_id SERIAL PRIMARY KEY,
       category_id INTEGER REFERENCES categories(category_id) ON DELETE SET NULL ON UPDATE CASCADE
   );
   ```
   **Mermaid Diagram**:
   ```mermaid
   erDiagram
       CATEGORIES ||--o{ PRODUCTS : categorizes
       CATEGORIES {
           int category_id PK
           string name
       }
       PRODUCTS {
           int product_id PK
           int category_id FK "ON DELETE SET NULL, ON UPDATE CASCADE"
       }
   ```

---

## 6. Designing for Performance

**Definition**: Optimizing database design to improve query speed and efficiency.

### Techniques
- **Indexing**: Speeds up lookups with index structures.
- **Partitioning**: Splits large tables into smaller, manageable parts.
- **Sharding**: Distributes data across multiple databases.

### Examples with Mermaid Diagrams

1. **Index on Email**:
   ```sql
   CREATE INDEX idx_users_email ON users(email);
   ```
   **Mermaid Diagram**:
   ```mermaid
   erDiagram
       USERS {
           int user_id PK
           string email INDEX
       }
   ```

2. **Composite Index**:
   ```sql
   CREATE INDEX idx_orders_date_customer ON orders(order_date, customer_id);
   ```
   **Mermaid Diagram**:
   ```mermaid
   erDiagram
       ORDERS {
           int order_id PK
           date order_date INDEX
           int customer_id INDEX
       }
   ```

3. **Partition by Range**:
   ```sql
   CREATE TABLE logs (
       log_id SERIAL PRIMARY KEY,
       log_date DATE NOT NULL,
       message TEXT
   ) PARTITION BY RANGE (log_date);
   CREATE TABLE logs_2025 PARTITION OF logs FOR VALUES FROM ('2025-01-01') TO ('2026-01-01');
   ```
   **Mermaid Diagram**:
   ```mermaid
   classDiagram
       class LOGS {
           int log_id PK
           date log_date PARTITION
           string message
       }
       class LOGS_2025 {
           int log_id PK
           date log_date "2025-01-01 to 2026-01-01"
           string message
       }
       LOGS ||--o{ LOGS_2025 : partition
   ```

4. **Index on Frequently Searched Column**:
   ```sql
   CREATE INDEX idx_products_price ON products(price);
   ```
   **Mermaid Diagram**:
   ```mermaid
   erDiagram
       PRODUCTS {
           int product_id PK
           decimal price INDEX
       }
   ```

5. **Partition by List**:
   ```sql
   CREATE TABLE orders (
       order_id SERIAL PRIMARY KEY,
       region TEXT NOT NULL,
       order_date DATE
   ) PARTITION BY LIST (region);
   CREATE TABLE orders_north PARTITION OF orders FOR VALUES IN ('North');
   ```
   **Mermaid Diagram**:
   ```mermaid
   classDiagram
       class ORDERS {
           int order_id PK
           string region PARTITION
           date order_date
       }
       class ORDERS_NORTH {
           int order_id PK
           string region "North"
           date order_date
       }
       ORDERS ||--o{ ORDERS_NORTH : partition
   ```

---

## 7. Best Practices

**Definition**: Guidelines to ensure maintainable, scalable, and robust database designs.

### Key Practices
- **Naming Conventions**: Use clear, consistent names (e.g., snake_case, singular table names).
- **Documentation**: Document schema, constraints, and relationships.
- **Avoid Overcomplication**: Balance normalization and performance.
- **Use Constraints**: Enforce data integrity.
- **Regular Backups**: Protect data against loss.

### Examples with Mermaid Diagrams

1. **Naming Convention**:
   ```sql
   CREATE TABLE customer (
       customer_id SERIAL PRIMARY KEY,
       first_name TEXT NOT NULL,
       last_name TEXT NOT NULL
   );
   ```
   **Mermaid Diagram**:
   ```mermaid
   erDiagram
       CUSTOMER {
           int customer_id PK
           string first_name NOTNULL
           string last_name NOTNULL
       }
   ```

2. **Documentation**:
   ```sql
   COMMENT ON TABLE customer IS 'Stores customer information including name and contact details';
   COMMENT ON COLUMN customer.customer_id IS 'Unique identifier for a customer';
   ```
   **Mermaid Diagram**:
   ```mermaid
   erDiagram
       CUSTOMER {
           int customer_id PK "Unique identifier"
           string first_name NOTNULL
           string last_name NOTNULL
       }
   ```

3. **Constraint Usage**:
   ```sql
   CREATE TABLE product (
       product_id SERIAL PRIMARY KEY,
       name TEXT NOT NULL,
       price NUMERIC(10,2) CHECK (price >= 0)
   );
   ```
   **Mermaid Diagram**:
   ```mermaid
   erDiagram
       PRODUCT {
           int product_id PK
           string name NOTNULL
           decimal price CHECK
       }
   ```

4. **Simplified Design**:
   ```sql
   CREATE TABLE address (
       address_id SERIAL PRIMARY KEY,
       customer_id INTEGER REFERENCES customer(customer_id),
       street TEXT NOT NULL,
       city TEXT NOT NULL
   );
   ```
   **Mermaid Diagram**:
   ```mermaid
   erDiagram
       CUSTOMER ||--o{ ADDRESS : has
       CUSTOMER {
           int customer_id PK
       }
       ADDRESS {
           int address_id PK
           int customer_id FK
           string street NOTNULL
           string city NOTNULL
       }
   ```

5. **Backup Strategy**:
   ```sql
   -- Example of a backup command (run externally)
   -- pg_dump -U username dbname > backup.sql
   ```
   **Mermaid Diagram**:
   ```mermaid
   flowchart TD
       A[Database] -->|pg_dump| B[Backup File: backup.sql]
   ```

---

## Exercises and Practice Questions

### Exercise 1: Normalize to 3NF
Normalize the following table to 3NF:
```sql
CREATE TABLE sales_raw (
    id SERIAL PRIMARY KEY,
    customer_name TEXT,
    product_name TEXT,
    product_category TEXT,
    sale_date DATE,
    amount NUMERIC(10,2)
);
```
**Task**: Write the normalized schema with at least three tables.

### Exercise 2: ER Diagram for Library System
Create an ER diagram and SQL schema for a library system with books, authors, borrowers, and loans.

### Exercise 3: Foreign Key Constraint
Add a foreign key to ensure every order in an `orders` table references a valid customer.

### Exercise 4: Check Constraint
Add a CHECK constraint to ensure a `salary` column in an `employees` table is always positive.

### Exercise 5: Denormalized Table
Create a denormalized table for reporting monthly sales totals by product, including product name and category.

### Exercise 6: Cascading Actions
Demonstrate `ON DELETE CASCADE` and `ON UPDATE SET NULL` with a parent-child table relationship.

### Exercise 7: Indexing
Create an index to speed up lookups by email in a `users` table.

### Exercise 8: Partitioning
Partition a table of website visits by year using RANGE partitioning.

### Practice Questions
1. Explain the difference between 2NF and 3NF with an example and a Mermaid diagram.
2. When would you choose to denormalize a database? Provide a scenario with a diagram.
3. Draw an ER diagram for a hospital system (patients, doctors, appointments).
4. Write SQL to create a table with a composite primary key and a check constraint, and include a Mermaid diagram.
5. How does indexing improve performance, and what are its drawbacks? Illustrate with a diagram.

---

## Conclusion
This document provides a detailed, student-friendly guide to PostgreSQL database design principles, with comprehensive explanations, multiple examples, and Mermaid JS diagrams for each example to enhance understanding. Practice the exercises and questions to solidify your knowledge. Experiment with the provided schemas in a test database and refer to the PostgreSQL documentation for further exploration.

