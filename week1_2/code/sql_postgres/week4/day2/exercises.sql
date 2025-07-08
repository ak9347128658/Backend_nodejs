-- Day 2: Database Design Principles - Exercises

-- Exercise 1: Normalize the following table to 3NF:
-- CREATE TABLE sales_raw (
--   id SERIAL PRIMARY KEY,
--   customer_name TEXT,
--   product_name TEXT,
--   product_category TEXT,
--   sale_date DATE,
--   amount NUMERIC(10,2)
-- );
-- Write the normalized schema.

-- Exercise 2: Create an ER diagram for a library system (books, authors, borrowers, loans).

-- Exercise 3: Add a foreign key to ensure that every order in an orders table references a valid customer.

-- Exercise 4: Add a CHECK constraint to ensure that a salary column in an employees table is always positive.

-- Exercise 5: Create a denormalized table for reporting monthly sales totals by product, including product name and category.

-- Exercise 6: Demonstrate ON DELETE CASCADE and ON UPDATE SET NULL with a parent-child table relationship.

-- Exercise 7: Create an index to speed up lookups by email in a users table.

-- Exercise 8: Partition a table of website visits by year using RANGE partitioning.
