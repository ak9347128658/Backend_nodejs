-- Exercise 1: Checking PostgreSQL version
SELECT version();

-- Exercise 2: Create a database named "practice_db"
CREATE DATABASE practice_db;

-- Exercise 3: Create a user named "practice_user" with a password
CREATE USER practice_user WITH PASSWORD 'practice_password';

-- Exercise 4: Grant the new user permission to connect to "practice_db"
GRANT CONNECT ON DATABASE practice_db TO practice_user;

-- Exercise 5: List all databases (use \l in psql)
-- \l

-- Exercise 6: Get PostgreSQL server information
SELECT current_database(), current_user, inet_server_addr(), inet_server_port(), current_timestamp;

-- Exercise 7: Show the size of all databases
SELECT 
    pg_database.datname AS database_name, 
    pg_size_pretty(pg_database_size(pg_database.datname)) AS size
FROM pg_database
ORDER BY pg_database_size(pg_database.datname) DESC;
