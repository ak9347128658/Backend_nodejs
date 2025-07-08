-- Week 2, Day 4: Transactions and Concurrency Control Exercises

-- Exercise 1: Simulate a bank transfer system
-- Create tables for accounts and transactions
CREATE TABLE bank_accounts (
    account_id SERIAL PRIMARY KEY,
    account_number VARCHAR(20) UNIQUE,
    customer_name VARCHAR(100),
    balance NUMERIC(12, 2) CHECK (balance >= 0),
    account_type VARCHAR(20),
    created_at TIMESTAMP DEFAULT current_timestamp
);

CREATE TABLE transactions (
    transaction_id SERIAL PRIMARY KEY,
    transaction_type VARCHAR(20), -- 'deposit', 'withdrawal', 'transfer'
    from_account_id INTEGER REFERENCES bank_accounts(account_id),
    to_account_id INTEGER REFERENCES bank_accounts(account_id),
    amount NUMERIC(12, 2) CHECK (amount > 0),
    transaction_date TIMESTAMP DEFAULT current_timestamp,
    status VARCHAR(20) DEFAULT 'completed', -- 'completed', 'failed', 'pending'
    notes TEXT
);

-- Insert sample accounts
INSERT INTO bank_accounts (account_number, customer_name, balance, account_type)
VALUES 
    ('1001-2345', 'John Smith', 5000.00, 'Checking'),
    ('1001-3456', 'Jane Doe', 7500.00, 'Savings'),
    ('1001-4567', 'Alice Johnson', 3200.00, 'Checking'),
    ('1001-5678', 'Bob Brown', 10000.00, 'Savings'),
    ('1001-6789', 'Charlie Davis', 1500.00, 'Checking');

-- Task 1: Implement a safe money transfer transaction
-- Create a stored procedure for transferring money between accounts
CREATE OR REPLACE PROCEDURE transfer_funds(
    p_from_account VARCHAR(20),
    p_to_account VARCHAR(20),
    p_amount NUMERIC(12, 2),
    OUT p_status VARCHAR(20),
    OUT p_message TEXT
)
LANGUAGE plpgsql
AS $$
DECLARE
    v_from_id INTEGER;
    v_to_id INTEGER;
    v_from_balance NUMERIC(12, 2);
BEGIN
    -- Start a transaction
    BEGIN
        -- Get account IDs
        SELECT account_id, balance INTO v_from_id, v_from_balance
        FROM bank_accounts
        WHERE account_number = p_from_account
        FOR UPDATE;
        
        IF v_from_id IS NULL THEN
            p_status := 'failed';
            p_message := 'Source account not found';
            RETURN;
        END IF;
        
        SELECT account_id INTO v_to_id
        FROM bank_accounts
        WHERE account_number = p_to_account
        FOR UPDATE;
        
        IF v_to_id IS NULL THEN
            p_status := 'failed';
            p_message := 'Destination account not found';
            RETURN;
        END IF;
        
        -- Check sufficient funds
        IF v_from_balance < p_amount THEN
            p_status := 'failed';
            p_message := 'Insufficient funds. Available: ' || v_from_balance || ', Required: ' || p_amount;
            RETURN;
        END IF;
        
        -- Update source account
        UPDATE bank_accounts
        SET balance = balance - p_amount
        WHERE account_id = v_from_id;
        
        -- Update destination account
        UPDATE bank_accounts
        SET balance = balance + p_amount
        WHERE account_id = v_to_id;
        
        -- Record the transaction
        INSERT INTO transactions (
            transaction_type,
            from_account_id,
            to_account_id,
            amount,
            status,
            notes
        ) VALUES (
            'transfer',
            v_from_id,
            v_to_id,
            p_amount,
            'completed',
            'Transfer from ' || p_from_account || ' to ' || p_to_account
        );
        
        p_status := 'completed';
        p_message := 'Successfully transferred ' || p_amount || ' from account ' || p_from_account || ' to account ' || p_to_account;
        
        -- The transaction will be committed if we reach here
    EXCEPTION WHEN OTHERS THEN
        -- Set output parameters
        p_status := 'failed';
        p_message := 'Error: ' || SQLERRM;
        
        -- The transaction will be rolled back
        RAISE;
    END;
END;
$$;

-- Test the transfer procedure
DO $$
DECLARE
    status VARCHAR(20);
    message TEXT;
BEGIN
    CALL transfer_funds('1001-2345', '1001-3456', 1000.00, status, message);
    RAISE NOTICE 'Status: %, Message: %', status, message;
END;
$$;

-- Check account balances after transfer
SELECT account_number, customer_name, balance FROM bank_accounts;

-- Check transaction history
SELECT * FROM transactions;

-- Task 2: Try a transfer that should fail (insufficient funds)
DO $$
DECLARE
    status VARCHAR(20);
    message TEXT;
BEGIN
    CALL transfer_funds('1001-6789', '1001-2345', 2000.00, status, message);
    RAISE NOTICE 'Status: %, Message: %', status, message;
END;
$$;

-- Check that no changes were made
SELECT account_number, customer_name, balance FROM bank_accounts;

-- Exercise 2: Implement an inventory management system
-- Create tables for products, inventory, and orders
CREATE TABLE products (
    product_id SERIAL PRIMARY KEY,
    product_name VARCHAR(100),
    description TEXT,
    price NUMERIC(10, 2),
    created_at TIMESTAMP DEFAULT current_timestamp
);

CREATE TABLE inventory (
    inventory_id SERIAL PRIMARY KEY,
    product_id INTEGER REFERENCES products(product_id),
    warehouse_id INTEGER,
    quantity INTEGER CHECK (quantity >= 0),
    last_updated TIMESTAMP DEFAULT current_timestamp
);

CREATE TABLE customer_orders (
    order_id SERIAL PRIMARY KEY,
    customer_id INTEGER,
    order_date TIMESTAMP DEFAULT current_timestamp,
    status VARCHAR(20) DEFAULT 'pending' -- 'pending', 'processed', 'shipped', 'delivered', 'cancelled'
);

CREATE TABLE order_items (
    item_id SERIAL PRIMARY KEY,
    order_id INTEGER REFERENCES customer_orders(order_id),
    product_id INTEGER REFERENCES products(product_id),
    quantity INTEGER CHECK (quantity > 0),
    unit_price NUMERIC(10, 2),
    status VARCHAR(20) DEFAULT 'pending' -- 'pending', 'processed', 'backordered', 'cancelled'
);

-- Insert sample data
INSERT INTO products (product_name, description, price)
VALUES 
    ('Laptop Pro', 'High-end laptop with 16GB RAM and 1TB SSD', 1299.99),
    ('Smartphone X', 'Latest smartphone with dual camera', 899.99),
    ('Wireless Headphones', 'Noise-cancelling wireless headphones', 199.99),
    ('Tablet Mini', 'Compact tablet with 10-inch display', 499.99),
    ('Smart Watch', 'Fitness tracker and smartwatch', 249.99);

INSERT INTO inventory (product_id, warehouse_id, quantity)
VALUES 
    (1, 1, 50),  -- Laptop Pro
    (2, 1, 100), -- Smartphone X
    (3, 1, 200), -- Wireless Headphones
    (4, 1, 75),  -- Tablet Mini
    (5, 1, 150); -- Smart Watch

-- Task 1: Create a stored procedure to process an order
CREATE OR REPLACE PROCEDURE process_order(
    p_order_id INTEGER,
    OUT p_status VARCHAR(20),
    OUT p_message TEXT
)
LANGUAGE plpgsql
AS $$
DECLARE
    v_item RECORD;
    v_available INTEGER;
    v_total NUMERIC(10, 2) := 0;
    v_all_processed BOOLEAN := TRUE;
BEGIN
    -- Start a transaction
    BEGIN
        -- Check if order exists
        IF NOT EXISTS (SELECT 1 FROM customer_orders WHERE order_id = p_order_id) THEN
            p_status := 'failed';
            p_message := 'Order not found';
            RETURN;
        END IF;
        
        -- Process each order item
        FOR v_item IN SELECT * FROM order_items WHERE order_id = p_order_id FOR UPDATE
        LOOP
            -- Check inventory (with lock)
            SELECT quantity INTO v_available
            FROM inventory
            WHERE product_id = v_item.product_id
            FOR UPDATE;
            
            IF v_available >= v_item.quantity THEN
                -- Update inventory
                UPDATE inventory
                SET quantity = quantity - v_item.quantity,
                    last_updated = current_timestamp
                WHERE product_id = v_item.product_id;
                
                -- Update order item status
                UPDATE order_items
                SET status = 'processed'
                WHERE item_id = v_item.item_id;
                
                -- Add to total
                v_total := v_total + (v_item.quantity * v_item.unit_price);
            ELSE
                -- Mark item as backordered
                UPDATE order_items
                SET status = 'backordered'
                WHERE item_id = v_item.item_id;
                
                v_all_processed := FALSE;
            END IF;
        END LOOP;
        
        -- Update order status
        IF v_all_processed THEN
            UPDATE customer_orders
            SET status = 'processed'
            WHERE order_id = p_order_id;
            
            p_status := 'completed';
            p_message := 'Order processed successfully. Total: ' || v_total;
        ELSE
            UPDATE customer_orders
            SET status = 'partial'
            WHERE order_id = p_order_id;
            
            p_status := 'partial';
            p_message := 'Order partially processed. Some items backordered.';
        END IF;
        
        -- The transaction will be committed if we reach here
    EXCEPTION WHEN OTHERS THEN
        -- Set output parameters
        p_status := 'failed';
        p_message := 'Error processing order: ' || SQLERRM;
        
        -- The transaction will be rolled back
        RAISE;
    END;
END;
$$;

-- Task 2: Create a test order and process it
-- Create a test order
INSERT INTO customer_orders (customer_id) VALUES (101) RETURNING order_id;

-- Add items to the order (assuming order_id 1 from above)
INSERT INTO order_items (order_id, product_id, quantity, unit_price)
VALUES 
    (1, 1, 2, 1299.99), -- 2 Laptop Pros
    (1, 3, 5, 199.99);  -- 5 Wireless Headphones

-- Process the order
DO $$
DECLARE
    status VARCHAR(20);
    message TEXT;
BEGIN
    CALL process_order(1, status, message);
    RAISE NOTICE 'Status: %, Message: %', status, message;
END;
$$;

-- Check inventory after processing
SELECT p.product_name, i.quantity
FROM inventory i
JOIN products p ON i.product_id = p.product_id;

-- Check order status
SELECT * FROM customer_orders;
SELECT * FROM order_items;

-- Task 3: Create a test order that exceeds available inventory
-- Create another test order
INSERT INTO customer_orders (customer_id) VALUES (102) RETURNING order_id;

-- Add items that exceed inventory
INSERT INTO order_items (order_id, product_id, quantity, unit_price)
VALUES 
    (2, 1, 100, 1299.99); -- Try to order 100 Laptop Pros (only 48 left)

-- Process the order
DO $$
DECLARE
    status VARCHAR(20);
    message TEXT;
BEGIN
    CALL process_order(2, status, message);
    RAISE NOTICE 'Status: %, Message: %', status, message;
END;
$$;

-- Check inventory and order status
SELECT p.product_name, i.quantity
FROM inventory i
JOIN products p ON i.product_id = p.product_id;

SELECT * FROM customer_orders;
SELECT * FROM order_items;

-- Exercise 3: Experiment with different isolation levels
-- Create a test table
CREATE TABLE isolation_test (
    id SERIAL PRIMARY KEY,
    name VARCHAR(50),
    value INTEGER
);

INSERT INTO isolation_test (name, value)
VALUES 
    ('A', 10),
    ('B', 20),
    ('C', 30);

-- Task 1: Demonstrate READ COMMITTED behavior
-- Session 1
BEGIN TRANSACTION ISOLATION LEVEL READ COMMITTED;
    -- Read initial value
    SELECT * FROM isolation_test WHERE name = 'A';
    
    -- This would be run in Session 2:
    -- BEGIN;
    -- UPDATE isolation_test SET value = 15 WHERE name = 'A';
    -- COMMIT;
    
    -- Now read again in Session 1
    SELECT * FROM isolation_test WHERE name = 'A';
    -- We'll see the updated value (15) in READ COMMITTED
COMMIT;

-- Task 2: Demonstrate REPEATABLE READ behavior
-- Session 1
BEGIN TRANSACTION ISOLATION LEVEL REPEATABLE READ;
    -- Read initial value
    SELECT * FROM isolation_test WHERE name = 'B';
    
    -- This would be run in Session 2:
    -- BEGIN;
    -- UPDATE isolation_test SET value = 25 WHERE name = 'B';
    -- COMMIT;
    
    -- Now read again in Session 1
    SELECT * FROM isolation_test WHERE name = 'B';
    -- We'll still see the original value (20) in REPEATABLE READ
COMMIT;

-- Task 3: Demonstrate SERIALIZABLE behavior
-- Session 1
BEGIN TRANSACTION ISOLATION LEVEL SERIALIZABLE;
    -- Get sum
    SELECT SUM(value) FROM isolation_test;
    
    -- This would be run in Session 2:
    -- BEGIN TRANSACTION ISOLATION LEVEL SERIALIZABLE;
    -- INSERT INTO isolation_test (name, value) VALUES ('D', 40);
    -- COMMIT;
    
    -- Now try to update based on the sum in Session 1
    UPDATE isolation_test SET value = value * 2 WHERE name = 'C';
    -- This might fail in SERIALIZABLE if Session 2's insert is committed
COMMIT;

-- Exercise 4: Implement optimistic concurrency control
-- Create a product catalog with versioning
CREATE TABLE product_catalog (
    product_id SERIAL PRIMARY KEY,
    product_name VARCHAR(100),
    description TEXT,
    price NUMERIC(10, 2),
    stock_quantity INTEGER,
    version INTEGER DEFAULT 1,
    last_updated TIMESTAMP DEFAULT current_timestamp
);

-- Insert sample data
INSERT INTO product_catalog (product_name, description, price, stock_quantity)
VALUES 
    ('Premium Laptop', 'High-end laptop for professionals', 1499.99, 50),
    ('Basic Tablet', 'Affordable tablet for everyday use', 299.99, 100);

-- Task 1: Create a function to update product details with optimistic locking
CREATE OR REPLACE FUNCTION update_product_optimistic(
    p_product_id INTEGER,
    p_product_name VARCHAR(100),
    p_description TEXT,
    p_price NUMERIC(10, 2),
    p_stock_quantity INTEGER,
    p_version INTEGER,
    OUT p_success BOOLEAN,
    OUT p_message TEXT,
    OUT p_new_version INTEGER
)
RETURNS RECORD
LANGUAGE plpgsql
AS $$
DECLARE
    v_current_version INTEGER;
BEGIN
    -- Get current version
    SELECT version INTO v_current_version
    FROM product_catalog
    WHERE product_id = p_product_id;
    
    IF v_current_version IS NULL THEN
        p_success := FALSE;
        p_message := 'Product not found';
        RETURN;
    END IF;
    
    -- Check version
    IF v_current_version != p_version THEN
        p_success := FALSE;
        p_message := 'Product has been modified since you last retrieved it. Current version: ' || v_current_version;
        p_new_version := v_current_version;
        RETURN;
    END IF;
    
    -- Update with version increment
    UPDATE product_catalog
    SET product_name = p_product_name,
        description = p_description,
        price = p_price,
        stock_quantity = p_stock_quantity,
        version = version + 1,
        last_updated = current_timestamp
    WHERE product_id = p_product_id
    AND version = p_version;
    
    IF FOUND THEN
        p_success := TRUE;
        p_message := 'Product updated successfully';
        p_new_version := p_version + 1;
    ELSE
        p_success := FALSE;
        p_message := 'Product update failed. Concurrent modification detected.';
        
        -- Get the new version
        SELECT version INTO p_new_version
        FROM product_catalog
        WHERE product_id = p_product_id;
    END IF;
END;
$$;

-- Task 2: Test optimistic concurrency control
-- Simulate two users trying to update the same product
-- First, get the current product data
SELECT * FROM product_catalog WHERE product_id = 1;

-- User 1 updates the product
DO $$
DECLARE
    v_success BOOLEAN;
    v_message TEXT;
    v_new_version INTEGER;
BEGIN
    SELECT * FROM update_product_optimistic(
        1,                                       -- product_id
        'Premium Laptop Deluxe',                 -- new name
        'High-end laptop for professionals',     -- description (unchanged)
        1599.99,                                 -- new price
        45,                                      -- new stock
        1                                        -- current version
    ) INTO v_success, v_message, v_new_version;
    
    RAISE NOTICE 'User 1 update: Success=%, Message=%, New Version=%', v_success, v_message, v_new_version;
END;
$$;

-- Check the updated product
SELECT * FROM product_catalog WHERE product_id = 1;

-- User 2 tries to update with outdated version
DO $$
DECLARE
    v_success BOOLEAN;
    v_message TEXT;
    v_new_version INTEGER;
BEGIN
    SELECT * FROM update_product_optimistic(
        1,                                       -- product_id
        'Premium Laptop Pro',                    -- different name
        'High-end laptop with extra features',   -- different description
        1549.99,                                 -- different price
        48,                                      -- different stock
        1                                        -- outdated version
    ) INTO v_success, v_message, v_new_version;
    
    RAISE NOTICE 'User 2 update: Success=%, Message=%, New Version=%', v_success, v_message, v_new_version;
END;
$$;

-- Check that the product still has User 1's changes
SELECT * FROM product_catalog WHERE product_id = 1;

-- Exercise 5: Simulate and resolve deadlocks
-- Create tables for deadlock demonstration
CREATE TABLE departments (
    department_id SERIAL PRIMARY KEY,
    department_name VARCHAR(100),
    budget NUMERIC(12, 2)
);

CREATE TABLE employees (
    employee_id SERIAL PRIMARY KEY,
    department_id INTEGER REFERENCES departments(department_id),
    employee_name VARCHAR(100),
    salary NUMERIC(10, 2)
);

-- Insert sample data
INSERT INTO departments (department_name, budget)
VALUES 
    ('Engineering', 1000000),
    ('Marketing', 750000),
    ('Finance', 500000);

INSERT INTO employees (department_id, employee_name, salary)
VALUES 
    (1, 'John Engineer', 85000),
    (1, 'Jane Developer', 90000),
    (2, 'Bob Marketer', 75000),
    (2, 'Alice Designer', 80000),
    (3, 'Charlie Accountant', 95000),
    (3, 'Diana Analyst', 85000);

-- Task 1: Create a function that can cause deadlocks
CREATE OR REPLACE FUNCTION update_employee_department(
    p_employee_id INTEGER,
    p_salary NUMERIC(10, 2),
    p_department_id INTEGER,
    p_budget_change NUMERIC(12, 2)
)
RETURNS VOID
LANGUAGE plpgsql
AS $$
BEGIN
    -- Update employee first
    UPDATE employees
    SET salary = p_salary,
        department_id = p_department_id
    WHERE employee_id = p_employee_id;
    
    -- Then update department budget
    UPDATE departments
    SET budget = budget + p_budget_change
    WHERE department_id = p_department_id;
END;
$$;

-- Create another function with reversed lock order
CREATE OR REPLACE FUNCTION update_department_employees(
    p_department_id INTEGER,
    p_budget NUMERIC(12, 2),
    p_employee_ids INTEGER[],
    p_salary_increase NUMERIC(10, 2)
)
RETURNS VOID
LANGUAGE plpgsql
AS $$
BEGIN
    -- Update department first
    UPDATE departments
    SET budget = p_budget
    WHERE department_id = p_department_id;
    
    -- Then update employees
    UPDATE employees
    SET salary = salary + p_salary_increase
    WHERE department_id = p_department_id
    AND employee_id = ANY(p_employee_ids);
END;
$$;

-- Task 2: Fix the deadlock-prone functions
-- Create improved versions with consistent lock ordering
CREATE OR REPLACE FUNCTION update_employee_department_safe(
    p_employee_id INTEGER,
    p_salary NUMERIC(10, 2),
    p_department_id INTEGER,
    p_budget_change NUMERIC(12, 2)
)
RETURNS VOID
LANGUAGE plpgsql
AS $$
BEGIN
    -- Always update department first (establishing consistent order)
    UPDATE departments
    SET budget = budget + p_budget_change
    WHERE department_id = p_department_id;
    
    -- Then update employee
    UPDATE employees
    SET salary = p_salary,
        department_id = p_department_id
    WHERE employee_id = p_employee_id;
END;
$$;

-- Update the other function to use the same lock order
CREATE OR REPLACE FUNCTION update_department_employees_safe(
    p_department_id INTEGER,
    p_budget NUMERIC(12, 2),
    p_employee_ids INTEGER[],
    p_salary_increase NUMERIC(10, 2)
)
RETURNS VOID
LANGUAGE plpgsql
AS $$
BEGIN
    -- Always update department first (same order as the other function)
    UPDATE departments
    SET budget = p_budget
    WHERE department_id = p_department_id;
    
    -- Then update employees
    UPDATE employees
    SET salary = salary + p_salary_increase
    WHERE department_id = p_department_id
    AND employee_id = ANY(p_employee_ids);
END;
$$;

-- Task 3: Implement a retry mechanism for deadlock handling
CREATE OR REPLACE FUNCTION transfer_employee_with_retry(
    p_employee_id INTEGER,
    p_new_department_id INTEGER,
    p_new_salary NUMERIC(10, 2),
    p_max_retries INTEGER DEFAULT 3
)
RETURNS BOOLEAN
LANGUAGE plpgsql
AS $$
DECLARE
    v_old_department_id INTEGER;
    v_old_salary NUMERIC(10, 2);
    v_retry_count INTEGER := 0;
    v_success BOOLEAN := FALSE;
BEGIN
    -- Get employee's current department and salary
    SELECT department_id, salary INTO v_old_department_id, v_old_salary
    FROM employees
    WHERE employee_id = p_employee_id;
    
    -- Keep trying until success or max retries reached
    WHILE v_retry_count < p_max_retries AND NOT v_success LOOP
        BEGIN
            -- Start a transaction
            BEGIN
                -- Always update departments in order of department_id to prevent deadlocks
                IF v_old_department_id < p_new_department_id THEN
                    -- Update old department (decrease budget by old salary)
                    UPDATE departments
                    SET budget = budget - v_old_salary
                    WHERE department_id = v_old_department_id;
                    
                    -- Update new department (increase budget by new salary)
                    UPDATE departments
                    SET budget = budget + p_new_salary
                    WHERE department_id = p_new_department_id;
                ELSE
                    -- Update new department first
                    UPDATE departments
                    SET budget = budget + p_new_salary
                    WHERE department_id = p_new_department_id;
                    
                    -- Update old department
                    UPDATE departments
                    SET budget = budget - v_old_salary
                    WHERE department_id = v_old_department_id;
                END IF;
                
                -- Update employee
                UPDATE employees
                SET department_id = p_new_department_id,
                    salary = p_new_salary
                WHERE employee_id = p_employee_id;
                
                -- If we get here, everything succeeded
                v_success := TRUE;
                COMMIT;
            END;
        EXCEPTION WHEN deadlock_detected THEN
            -- Increment retry count
            v_retry_count := v_retry_count + 1;
            
            -- Log the deadlock
            RAISE NOTICE 'Deadlock detected, retry #%', v_retry_count;
            
            -- Wait a bit before retrying (with random component to avoid synchronized retries)
            PERFORM pg_sleep(0.1 * v_retry_count * random());
        WHEN OTHERS THEN
            -- Some other error occurred
            RAISE EXCEPTION 'Error transferring employee: %', SQLERRM;
        END;
    END LOOP;
    
    RETURN v_success;
END;
$$;

-- Task 4: Test the retry mechanism
SELECT * FROM employees ORDER BY employee_id;
SELECT * FROM departments ORDER BY department_id;

-- Transfer an employee with retry
SELECT transfer_employee_with_retry(1, 2, 95000);

-- Check the results
SELECT * FROM employees WHERE employee_id = 1;
SELECT * FROM departments WHERE department_id IN (1, 2);

-- Cleanup (comment out if you want to keep the tables)
-- DROP FUNCTION transfer_employee_with_retry;
-- DROP FUNCTION update_department_employees_safe;
-- DROP FUNCTION update_employee_department_safe;
-- DROP FUNCTION update_department_employees;
-- DROP FUNCTION update_employee_department;
-- DROP FUNCTION update_product_optimistic;
-- DROP PROCEDURE process_order;
-- DROP PROCEDURE transfer_funds;
-- DROP TABLE order_items;
-- DROP TABLE customer_orders;
-- DROP TABLE inventory;
-- DROP TABLE products;
-- DROP TABLE employees;
-- DROP TABLE departments;
-- DROP TABLE product_catalog;
-- DROP TABLE isolation_test;
-- DROP TABLE transactions;
-- DROP TABLE bank_accounts;
