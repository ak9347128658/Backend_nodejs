# Day 1: Introduction to Databases and SQL

## Topics Covered

1. What is a database?
2. Types of databases
3. Introduction to SQL
4. Setting up PostgreSQL
5. Basic database operations

## Examples and Exercises

### Example 1: Installing and Connecting to PostgreSQL

```sql
-- After installing PostgreSQL, connect using psql
-- psql -U postgres

-- Check PostgreSQL version
SELECT version();
```

### Example 2: Creating Your First Database

```sql
-- Create a new database
CREATE DATABASE my_first_db;

-- Connect to the database
\c my_first_db

-- Verify connection
SELECT current_database();
```

### Example 3: Basic Database Operations

```sql
-- Create a database
CREATE DATABASE bookstore;

-- Connect to the database
\c bookstore

-- Drop a database (delete)
DROP DATABASE IF EXISTS old_database;

-- List all databases
\l
```

### Example 4: User Management

```sql
-- Create a new user
CREATE USER reader WITH PASSWORD 'secure_password';

-- Grant privileges
GRANT CONNECT ON DATABASE bookstore TO reader;
GRANT SELECT ON ALL TABLES IN SCHEMA public TO reader;

-- List all users
\du
```

### Example 5: Database Information

```sql
-- Show database version
SELECT version();

-- List schemas
\dn

-- Show database size
SELECT pg_size_pretty(pg_database_size(current_database()));

-- Show all tables in current database
\dt
```

## Practice Exercises

1. Install PostgreSQL on your system if you haven't already.
2. Connect to PostgreSQL using the command line or a GUI tool like pgAdmin.
3. Create a database named "practice_db".
4. Create a user named "practice_user" with a password of your choice.
5. Grant the new user permission to connect to "practice_db".
6. List all databases in your PostgreSQL instance.
7. Get information about your PostgreSQL version and server.

## Additional Resources

- [PostgreSQL Official Documentation](https://www.postgresql.org/docs/)
- [PostgreSQL Download Page](https://www.postgresql.org/download/)
- [pgAdmin Download](https://www.pgadmin.org/download/)
