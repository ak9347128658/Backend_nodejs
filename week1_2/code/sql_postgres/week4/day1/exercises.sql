-- Week 4 - Day 1: Exercises on Advanced PostgreSQL Features
-- Complete the following exercises to practice custom data types, inheritance, partitioning, extensions, and advisory locks.

-- PART 1: CUSTOM DATA TYPES

-- Exercise 1: Create a domain type for phone numbers that must match the pattern '+<countrycode>-<number>' (e.g., '+1-5551234567').
-- Use this domain in a contacts table and try inserting both valid and invalid values.

-- Exercise 2: Create a composite type for a book (title, author, year) and use it in a library table. Insert at least two rows and query the title and author from the composite column.

-- Exercise 3: Create an ENUM type for employee roles ('developer', 'manager', 'analyst', 'intern'). Use it in an employees table and insert at least one row for each role. Query all managers.

-- Exercise 4: Create a table for event scheduling using a built-in range type (tsrange for timestamp ranges). Insert at least two events and write a query to find events that overlap with a given time range.

-- PART 2: INHERITANCE

-- Exercise 5: Create a parent table for publications (id, title, published_date) and two child tables: books (isbn, pages) and magazines (issue, frequency). Insert data and query all publications, showing which table each row comes from.

-- PART 3: PARTITIONING

-- Exercise 6: Create a partitioned table for website visits by month (use RANGE partitioning on visit_date). Create at least two partitions and insert sample data. Query visits for a specific month.

-- Exercise 7: Create a LIST partitioned table for orders by region ('North', 'South', 'East', 'West'). Insert data and query all orders from the 'East' region.

-- PART 4: EXTENSIONS

-- Exercise 8: Install the citext extension (case-insensitive text) and create a users table with a citext email column. Insert emails with different cases and show that queries are case-insensitive.

-- Exercise 9: Install the uuid-ossp extension and create a table with a UUID primary key. Insert a row and show the generated UUID.

-- PART 5: ADVISORY LOCKS

-- Exercise 10: Write a function that uses a transaction-level advisory lock to safely increment a counter in a table. Demonstrate its use by calling it multiple times and showing the counter value increases correctly.

-- BONUS: Combine at least two advanced features (e.g., use a custom type in a partitioned table, or use an extension with inheritance) in a single example.
