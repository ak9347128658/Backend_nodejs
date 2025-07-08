-- Day 3: Database Security and User Management - Examples

-- Example 1: Creating Roles and Granting Privileges
CREATE ROLE analyst LOGIN PASSWORD 'analystpass';
CREATE ROLE readonly;
GRANT CONNECT ON DATABASE postgres TO analyst;
GRANT USAGE ON SCHEMA public TO analyst;
GRANT SELECT ON ALL TABLES IN SCHEMA public TO analyst;
ALTER DEFAULT PRIVILEGES IN SCHEMA public GRANT SELECT ON TABLES TO analyst;
GRANT readonly TO analyst;

-- Example 2: Revoking Privileges
REVOKE SELECT ON ALL TABLES IN SCHEMA public FROM analyst;

-- Example 3: Role Inheritance
CREATE ROLE manager;
GRANT analyst TO manager;

-- Example 4: Row-Level Security (RLS)
CREATE TABLE confidential_data (
    id SERIAL PRIMARY KEY,
    owner TEXT,
    secret TEXT
);
ALTER TABLE confidential_data ENABLE ROW LEVEL SECURITY;
CREATE POLICY owner_policy ON confidential_data
    USING (owner = current_user);
-- Test: SET ROLE analyst; SELECT * FROM confidential_data;

-- Example 5: Column-Level Encryption (pgcrypto)
CREATE EXTENSION IF NOT EXISTS pgcrypto;
CREATE TABLE users_secure (
    user_id SERIAL PRIMARY KEY,
    username TEXT NOT NULL,
    password_hash TEXT NOT NULL
);
INSERT INTO users_secure (username, password_hash)
VALUES ('alice', crypt('alicepass', gen_salt('bf')));
-- Verify password
SELECT username FROM users_secure WHERE password_hash = crypt('alicepass', password_hash);

-- Example 6: SSL/TLS (conceptual)
-- (Configuration is done in postgresql.conf and pg_hba.conf)
-- SHOW ssl;

-- Example 7: Auditing and Logging
-- Enable logging in postgresql.conf:
-- log_statement = 'all'
-- log_connections = on
-- log_disconnections = on
