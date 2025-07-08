-- Example 1: Basic Transaction Structure
-- Create a sample banking database
CREATE TABLE accounts (
    account_id SERIAL PRIMARY KEY,
    customer_name VARCHAR(100),
    balance NUMERIC(12, 2) CHECK (balance >= 0)
);

-- Insert sample data
INSERT INTO accounts (customer_name, balance)
VALUES 
    ('Alice', 1000.00),
    ('Bob', 500.00),
    ('Charlie', 1500.00),
    ('Diana', 2000.00);

-- Basic transaction to transfer money between accounts
BEGIN;
    -- Deduct from sender
    UPDATE accounts 
    SET balance = balance - 100.00 
    WHERE account_id = 1;
    
    -- Add to recipient
    UPDATE accounts 
    SET balance = balance + 100.00 
    WHERE account_id = 2;
    
    -- Check if sender's balance is still valid
    -- If the CHECK constraint fails, the entire transaction will be rolled back
COMMIT;

-- Check the results
SELECT * FROM accounts WHERE account_id IN (1, 2);

-- Transaction with explicit savepoints
BEGIN;
    UPDATE accounts SET balance = balance - 50.00 WHERE account_id = 3;
    
    SAVEPOINT before_second_update;
    
    UPDATE accounts SET balance = balance + 50.00 WHERE account_id = 4;
    
    -- Decide to revert just the second update
    ROLLBACK TO SAVEPOINT before_second_update;
    
    -- Do something else instead
    UPDATE accounts SET balance = balance + 50.00 WHERE account_id = 1;
COMMIT;

-- Check the results
SELECT * FROM accounts WHERE account_id IN (1, 3, 4);

-- Example of a failed transaction that gets rolled back
BEGIN;
    -- This will succeed
    UPDATE accounts SET balance = balance - 400.00 WHERE account_id = 2;
    
    -- This will fail due to CHECK constraint (balance cannot go negative)
    UPDATE accounts SET balance = balance - 1200.00 WHERE account_id = 3;
COMMIT;
-- The entire transaction will be rolled back

-- Check that nothing changed
SELECT * FROM accounts WHERE account_id IN (2, 3);

-- Example 2: Transaction Isolation Levels
-- Show the current isolation level
SHOW transaction_isolation;

-- Examples of different isolation levels
-- These should be run in separate terminal sessions to see the effects

-- Session 1: READ COMMITTED example (default)
BEGIN;
    SELECT balance FROM accounts WHERE account_id = 1;
    -- Will initially see the current balance
    
    -- Now Session 2 makes and commits a change
    -- Session 1 runs the same query again
    SELECT balance FROM accounts WHERE account_id = 1;
    -- Will see the updated balance committed by Session 2
COMMIT;

-- Session 2: Make a change during Session 1's transaction
BEGIN;
    UPDATE accounts SET balance = balance + 200 WHERE account_id = 1;
COMMIT;

-- Session 1: REPEATABLE READ example
BEGIN TRANSACTION ISOLATION LEVEL REPEATABLE READ;
    SELECT balance FROM accounts WHERE account_id = 1;
    -- Will see the current balance
    
    -- Now Session 2 makes and commits a change
    -- Session 1 runs the same query again
    SELECT balance FROM accounts WHERE account_id = 1;
    -- Will still see the original balance from when transaction started
COMMIT;

-- Session 1: SERIALIZABLE example
BEGIN TRANSACTION ISOLATION LEVEL SERIALIZABLE;
    SELECT SUM(balance) FROM accounts;
    
    -- Session 2 inserts a new account
    -- Session 1 updates all accounts
    UPDATE accounts SET balance = balance * 1.1;
    -- This might fail with serialization error if session 2 committed a relevant change
COMMIT;

-- Example 3: Handling Concurrency Issues
-- Create a simple inventory table
CREATE TABLE inventory (
    product_id SERIAL PRIMARY KEY,
    product_name VARCHAR(100),
    quantity INTEGER CHECK (quantity >= 0)
);

INSERT INTO inventory (product_name, quantity)
VALUES 
    ('Laptop', 10),
    ('Smartphone', 20),
    ('Headphones', 30);

-- Example of a race condition (run in two separate sessions)
-- Session 1
BEGIN;
    SELECT quantity FROM inventory WHERE product_id = 1;
    -- See: 10 laptops available
    
    -- Session 1 pauses here to think...
    -- Meanwhile, Session 2 buys 3 laptops and commits
    
    -- Session 1 resumes and tries to buy 8 laptops
    UPDATE inventory SET quantity = quantity - 8 WHERE product_id = 1;
    -- This might succeed but lead to inventory issues if check constraint wasn't in place
COMMIT;

-- Session 2
BEGIN;
    UPDATE inventory SET quantity = quantity - 3 WHERE product_id = 1;
COMMIT;

-- Fix with explicit locking
-- Session 1
BEGIN;
    -- Lock the row with FOR UPDATE to prevent other transactions from modifying it
    SELECT quantity FROM inventory WHERE product_id = 1 FOR UPDATE;
    -- See current laptop quantity
    
    -- Now any other session trying to update this row will wait
    -- Session 1 pauses here to think...
    
    -- Session 1 resumes and buys laptops
    UPDATE inventory SET quantity = quantity - 8 WHERE product_id = 1;
COMMIT;

-- Other locking modes
-- FOR SHARE - allows other transactions to read but not update
BEGIN;
    SELECT quantity FROM inventory WHERE product_id = 1 FOR SHARE;
    -- Other transactions can also acquire FOR SHARE locks
    -- but no transaction can update until all FOR SHARE locks are released
COMMIT;

-- NOWAIT option - fails immediately if lock cannot be acquired
BEGIN;
    SELECT quantity FROM inventory WHERE product_id = 1 FOR UPDATE NOWAIT;
    -- If another transaction has locked this row, this will fail immediately
    -- rather than waiting for the lock to be released
COMMIT;

-- SKIP LOCKED - skips rows that cannot be locked
BEGIN;
    SELECT * FROM inventory WHERE quantity > 0 FOR UPDATE SKIP LOCKED;
    -- This is useful for queue-like processing where you want to skip
    -- items that are currently being processed by another transaction
COMMIT;

-- Example 4: Deadlock Prevention and Handling
-- Create tables for deadlock demonstration
CREATE TABLE orders (
    order_id SERIAL PRIMARY KEY,
    customer_id INTEGER,
    total_amount NUMERIC(10, 2)
);

CREATE TABLE order_items (
    item_id SERIAL PRIMARY KEY,
    order_id INTEGER REFERENCES orders(order_id),
    product_id INTEGER,
    quantity INTEGER,
    unit_price NUMERIC(10, 2)
);

-- Insert sample data
INSERT INTO orders (customer_id, total_amount)
VALUES 
    (101, 0),
    (102, 0);

INSERT INTO order_items (order_id, product_id, quantity, unit_price)
VALUES 
    (1, 1, 2, 25.00),
    (1, 2, 1, 50.00),
    (2, 1, 3, 25.00),
    (2, 3, 2, 15.00);

-- Deadlock scenario (run in two separate sessions)
-- Session 1
BEGIN;
    UPDATE orders SET total_amount = 100.00 WHERE order_id = 1;
    
    -- Session 1 pauses here
    -- Meanwhile, Session 2 locks order_items row for order 2
    
    -- Session 1 now tries to update order_items for order 1
    UPDATE order_items SET quantity = 3 WHERE item_id = 1;
COMMIT;

-- Session 2
BEGIN;
    UPDATE order_items SET quantity = 5 WHERE item_id = 3; -- For order_id 2
    
    -- Session 2 pauses here
    -- Meanwhile, Session 1 has locked orders row for order 1
    
    -- Session 2 now tries to update orders for order 2
    UPDATE orders SET total_amount = 125.00 WHERE order_id = 2;
    -- Deadlock! One transaction will be chosen as the victim and rolled back
COMMIT;

-- Preventing deadlocks by consistent lock ordering
-- Session 1
BEGIN;
    -- First, lock any rows in orders that will be modified
    UPDATE orders SET total_amount = 100.00 WHERE order_id = 1;
    
    -- Then lock rows in order_items
    UPDATE order_items SET quantity = 3 WHERE item_id = 1;
COMMIT;

-- Session 2 (follows the same pattern)
BEGIN;
    -- First, lock any rows in orders that will be modified
    UPDATE orders SET total_amount = 125.00 WHERE order_id = 2;
    
    -- Then lock rows in order_items
    UPDATE order_items SET quantity = 5 WHERE item_id = 3;
COMMIT;

-- Example 5: Advisory Locks
-- PostgreSQL advisory locks are application-defined locks that can be used
-- to coordinate access to resources not directly tied to a database row

-- Create a function that simulates a long-running process
CREATE OR REPLACE FUNCTION process_data(process_id INTEGER)
RETURNS VOID AS $$
BEGIN
    -- Try to acquire an advisory lock
    IF pg_try_advisory_lock(process_id) THEN
        -- Got the lock, do the work
        RAISE NOTICE 'Processing data for process %', process_id;
        
        -- Simulate work by sleeping
        PERFORM pg_sleep(10);
        
        -- Release the lock when done
        PERFORM pg_advisory_unlock(process_id);
        RAISE NOTICE 'Process % completed', process_id;
    ELSE
        -- Could not get the lock, process already running
        RAISE NOTICE 'Process % is already running', process_id;
    END IF;
END;
$$ LANGUAGE plpgsql;

-- Call the function (open multiple sessions to test)
SELECT process_data(1);

-- Another session tries to process the same data
SELECT process_data(1);  -- Should show "Process 1 is already running"

-- Different process ID works fine
SELECT process_data(2);  -- Should run normally

-- Example 6: Optimistic Concurrency Control
-- Create a table with a version column for optimistic concurrency control
CREATE TABLE documents (
    document_id SERIAL PRIMARY KEY,
    title VARCHAR(100),
    content TEXT,
    version INTEGER DEFAULT 1
);

INSERT INTO documents (title, content)
VALUES ('Meeting Notes', 'Initial meeting notes content.');

-- Optimistic concurrency approach (run in two separate sessions)
-- Session 1: User 1 reads the document
BEGIN;
    SELECT document_id, title, content, version 
    FROM documents 
    WHERE document_id = 1;
    -- Gets version 1
    
    -- Session 1 pauses here
    -- Meanwhile, Session 2 updates the document and commits
    
    -- Session 1 tries to update with outdated version
    UPDATE documents 
    SET content = 'Updated by User 1.', version = version + 1
    WHERE document_id = 1 AND version = 1;
    
    -- Check if update succeeded
    -- This will update 0 rows because version is now 2
    DO $$
    DECLARE
        rowcount INTEGER;
    BEGIN
        GET DIAGNOSTICS rowcount = ROW_COUNT;
        IF rowcount = 0 THEN
            RAISE EXCEPTION 'Document was modified by another user';
        END IF;
    END $$;
COMMIT;

-- Session 2: User 2 updates the document
BEGIN;
    UPDATE documents 
    SET content = 'Updated by User 2.', version = version + 1
    WHERE document_id = 1 AND version = 1;
COMMIT;

-- Example 7: Transaction Handling in Stored Procedures
-- Create a stored procedure for bank transfers
CREATE OR REPLACE PROCEDURE transfer_money(
    sender_id INTEGER,
    recipient_id INTEGER,
    amount NUMERIC
)
LANGUAGE plpgsql
AS $$
DECLARE
    sender_balance NUMERIC;
BEGIN
    -- Start a transaction
    BEGIN
        -- Check sender's balance
        SELECT balance INTO sender_balance
        FROM accounts
        WHERE account_id = sender_id
        FOR UPDATE;
        
        -- Validate sufficient funds
        IF sender_balance < amount THEN
            RAISE EXCEPTION 'Insufficient funds. Available: %, Required: %', sender_balance, amount;
        END IF;
        
        -- Deduct from sender
        UPDATE accounts
        SET balance = balance - amount
        WHERE account_id = sender_id;
        
        -- Add to recipient
        UPDATE accounts
        SET balance = balance + amount
        WHERE account_id = recipient_id;
        
        -- Commit the transaction
        COMMIT;
        RAISE NOTICE 'Transfer successful: % from account % to account %', amount, sender_id, recipient_id;
    EXCEPTION WHEN OTHERS THEN
        -- Rollback on any error
        ROLLBACK;
        RAISE EXCEPTION 'Transfer failed: %', SQLERRM;
    END;
END;
$$;

-- Call the stored procedure
CALL transfer_money(1, 2, 200);
CALL transfer_money(3, 4, 1000);

-- This should fail due to insufficient funds
CALL transfer_money(2, 3, 10000);

-- Cleanup (comment out if you want to keep the tables)
-- DROP PROCEDURE transfer_money;
-- DROP FUNCTION process_data;
-- DROP TABLE order_items;
-- DROP TABLE orders;
-- DROP TABLE inventory;
-- DROP TABLE documents;
-- DROP TABLE accounts;
