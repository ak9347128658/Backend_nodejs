-- Day 2: Database Design Principles - Examples

-- Example 1: Normalization
-- 1NF: Atomic values only
CREATE TABLE contacts_1nf (
    contact_id SERIAL PRIMARY KEY,
    name TEXT NOT NULL,
    phone TEXT NOT NULL
);
-- 2NF: Remove partial dependencies
CREATE TABLE orders_2nf (
    order_id SERIAL PRIMARY KEY,
    customer_id INTEGER NOT NULL,
    order_date DATE NOT NULL
);
CREATE TABLE order_items_2nf (
    order_item_id SERIAL PRIMARY KEY,
    order_id INTEGER REFERENCES orders_2nf(order_id),
    product_id INTEGER NOT NULL,
    quantity INTEGER NOT NULL
);
-- 3NF: Remove transitive dependencies
CREATE TABLE employees_3nf (
    employee_id SERIAL PRIMARY KEY,
    name TEXT NOT NULL,
    department_id INTEGER NOT NULL
);
CREATE TABLE departments_3nf (
    department_id SERIAL PRIMARY KEY,
    department_name TEXT NOT NULL
);

-- Example 2: Denormalization
-- Add redundant data for performance
CREATE TABLE sales_denorm (
    sale_id SERIAL PRIMARY KEY,
    product_id INTEGER NOT NULL,
    product_name TEXT NOT NULL, -- denormalized
    sale_date DATE NOT NULL,
    amount NUMERIC(10,2) NOT NULL
);

-- Example 3: ER Modeling
-- Entities: Student, Course, Enrollment
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

-- Example 4: Keys and Constraints
CREATE TABLE products (
    product_id SERIAL PRIMARY KEY,
    sku TEXT UNIQUE NOT NULL,
    name TEXT NOT NULL,
    price NUMERIC(10,2) CHECK (price > 0)
);

-- Example 5: Referential Integrity
CREATE TABLE customers (
    customer_id SERIAL PRIMARY KEY,
    name TEXT NOT NULL
);
CREATE TABLE orders (
    order_id SERIAL PRIMARY KEY,
    customer_id INTEGER REFERENCES customers(customer_id) ON DELETE CASCADE,
    order_date DATE NOT NULL
);

-- Example 6: Indexing
CREATE INDEX idx_products_name ON products(name);

-- Example 7: Partitioning (basic)
CREATE TABLE logs (
    log_id SERIAL PRIMARY KEY,
    log_date DATE NOT NULL,
    message TEXT
) PARTITION BY RANGE (log_date);
CREATE TABLE logs_2025 PARTITION OF logs FOR VALUES FROM ('2025-01-01') TO ('2026-01-01');
