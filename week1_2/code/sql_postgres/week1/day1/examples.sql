-- Example 1: Checking PostgreSQL version
SELECT version();

-- Example 2: Creating a database
CREATE DATABASE my_first_db;
-- Connect to the database with: \c my_first_db

-- Example 3: Basic database operations
CREATE DATABASE bookstore;
-- List all databases with: \l
-- Drop a database
DROP DATABASE IF EXISTS old_database;

-- Example 4: User management
CREATE USER reader WITH PASSWORD 'secure_password';
GRANT CONNECT ON DATABASE bookstore TO reader;
GRANT SELECT ON ALL TABLES IN SCHEMA public TO reader;
-- List all users with: \du

-- Example 5: Database information commands
-- Show schemas with: \dn
-- Show tables with: \dt
-- Show database size
SELECT pg_size_pretty(pg_database_size(current_database()));
