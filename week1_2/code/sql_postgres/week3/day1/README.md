# Day 1: Triggers and Events

## Topics Covered

1. What are database triggers
2. Creating triggers
3. Types of triggers (BEFORE, AFTER, INSTEAD OF)
4. Row-level vs. statement-level triggers
5. Use cases for triggers
6. Best practices for using triggers

## Examples and Exercises

### Example 1: Basic AFTER INSERT Trigger

```sql
-- Create a table to store products
CREATE TABLE products (
    product_id SERIAL PRIMARY KEY,
    product_name VARCHAR(100) NOT NULL,
    category VARCHAR(50),
    price NUMERIC(10, 2) CHECK (price >= 0),
    stock_quantity INTEGER DEFAULT 0,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Create a table to log product changes
CREATE TABLE product_audit_log (
    log_id SERIAL PRIMARY KEY,
    product_id INTEGER,
    action VARCHAR(10),
    user_name VARCHAR(100),
    timestamp TIMESTAMP,
    old_data JSONB,
    new_data JSONB
);

-- Create a function for the INSERT trigger
CREATE OR REPLACE FUNCTION log_product_insert()
RETURNS TRIGGER AS $$
BEGIN
    INSERT INTO product_audit_log (
        product_id,
        action,
        user_name,
        timestamp,
        old_data,
        new_data
    )
    VALUES (
        NEW.product_id,
        'INSERT',
        current_user,
        current_timestamp,
        NULL,
        row_to_json(NEW)
    );
    
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Create the AFTER INSERT trigger
CREATE TRIGGER after_product_insert
AFTER INSERT ON products
FOR EACH ROW
EXECUTE FUNCTION log_product_insert();

-- Test the trigger with an insert
INSERT INTO products (product_name, category, price, stock_quantity)
VALUES ('Wireless Earbuds', 'Electronics', 99.99, 50);
```

### Example 2: BEFORE UPDATE Trigger

```sql
-- Create a function to automatically update the updated_at timestamp
CREATE OR REPLACE FUNCTION update_modified_timestamp()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = CURRENT_TIMESTAMP;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Create the BEFORE UPDATE trigger
CREATE TRIGGER before_product_update
BEFORE UPDATE ON products
FOR EACH ROW
EXECUTE FUNCTION update_modified_timestamp();

-- Create a function for the UPDATE audit log
CREATE OR REPLACE FUNCTION log_product_update()
RETURNS TRIGGER AS $$
BEGIN
    INSERT INTO product_audit_log (
        product_id,
        action,
        user_name,
        timestamp,
        old_data,
        new_data
    )
    VALUES (
        NEW.product_id,
        'UPDATE',
        current_user,
        current_timestamp,
        row_to_json(OLD),
        row_to_json(NEW)
    );
    
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Create the AFTER UPDATE trigger
CREATE TRIGGER after_product_update
AFTER UPDATE ON products
FOR EACH ROW
EXECUTE FUNCTION log_product_update();

-- Test the triggers with an update
UPDATE products
SET price = 89.99, stock_quantity = 45
WHERE product_id = 1;
```

### Example 3: AFTER DELETE Trigger

```sql
-- Create a function for the DELETE audit log
CREATE OR REPLACE FUNCTION log_product_delete()
RETURNS TRIGGER AS $$
BEGIN
    INSERT INTO product_audit_log (
        product_id,
        action,
        user_name,
        timestamp,
        old_data,
        new_data
    )
    VALUES (
        OLD.product_id,
        'DELETE',
        current_user,
        current_timestamp,
        row_to_json(OLD),
        NULL
    );
    
    RETURN OLD;
END;
$$ LANGUAGE plpgsql;

-- Create the AFTER DELETE trigger
CREATE TRIGGER after_product_delete
AFTER DELETE ON products
FOR EACH ROW
EXECUTE FUNCTION log_product_delete();

-- Create a products_archive table
CREATE TABLE products_archive (
    product_id INTEGER PRIMARY KEY,
    product_name VARCHAR(100) NOT NULL,
    category VARCHAR(50),
    price NUMERIC(10, 2),
    deleted_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Create a function to archive products before deletion
CREATE OR REPLACE FUNCTION archive_product()
RETURNS TRIGGER AS $$
BEGIN
    INSERT INTO products_archive (
        product_id,
        product_name,
        category,
        price,
        deleted_at
    )
    VALUES (
        OLD.product_id,
        OLD.product_name,
        OLD.category,
        OLD.price,
        CURRENT_TIMESTAMP
    );
    
    RETURN OLD;
END;
$$ LANGUAGE plpgsql;

-- Create the BEFORE DELETE trigger
CREATE TRIGGER before_product_delete
BEFORE DELETE ON products
FOR EACH ROW
EXECUTE FUNCTION archive_product();

-- Test the triggers with a delete
DELETE FROM products
WHERE product_id = 1;
```

### Example 4: Statement-Level Trigger

```sql
-- Create a table to track database activity
CREATE TABLE db_activity_log (
    log_id SERIAL PRIMARY KEY,
    table_name VARCHAR(100),
    action VARCHAR(10),
    user_name VARCHAR(100),
    timestamp TIMESTAMP,
    row_count INTEGER
);

-- Create a function for tracking table modifications
CREATE OR REPLACE FUNCTION log_table_modification()
RETURNS TRIGGER AS $$
DECLARE
    row_count INTEGER;
BEGIN
    -- Get the number of affected rows
    IF TG_OP = 'DELETE' THEN
        row_count := OLD.xmin;
    ELSE
        row_count := NEW.xmin;
    END IF;
    
    -- Log the operation
    INSERT INTO db_activity_log (
        table_name,
        action,
        user_name,
        timestamp,
        row_count
    )
    VALUES (
        TG_TABLE_NAME,
        TG_OP,
        current_user,
        current_timestamp,
        row_count
    );
    
    RETURN NULL;
END;
$$ LANGUAGE plpgsql;

-- Create a statement-level trigger for INSERT operations
CREATE TRIGGER log_products_insert_statement
AFTER INSERT ON products
FOR EACH STATEMENT
EXECUTE FUNCTION log_table_modification();

-- Create a statement-level trigger for UPDATE operations
CREATE TRIGGER log_products_update_statement
AFTER UPDATE ON products
FOR EACH STATEMENT
EXECUTE FUNCTION log_table_modification();

-- Create a statement-level trigger for DELETE operations
CREATE TRIGGER log_products_delete_statement
AFTER DELETE ON products
FOR EACH STATEMENT
EXECUTE FUNCTION log_table_modification();

-- Test with a bulk insert
INSERT INTO products (product_name, category, price, stock_quantity)
VALUES 
    ('Smartphone', 'Electronics', 699.99, 30),
    ('Bluetooth Speaker', 'Electronics', 79.99, 50),
    ('Tablet', 'Electronics', 349.99, 25);
```

### Example 5: Conditional Trigger

```sql
-- Create a table for inventory transactions
CREATE TABLE inventory_transactions (
    transaction_id SERIAL PRIMARY KEY,
    product_id INTEGER REFERENCES products(product_id),
    transaction_type VARCHAR(10) CHECK (transaction_type IN ('IN', 'OUT')),
    quantity INTEGER CHECK (quantity > 0),
    transaction_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Create a function to update product inventory
CREATE OR REPLACE FUNCTION update_product_inventory()
RETURNS TRIGGER AS $$
BEGIN
    -- If inventory is coming in, increase stock quantity
    IF NEW.transaction_type = 'IN' THEN
        UPDATE products
        SET stock_quantity = stock_quantity + NEW.quantity
        WHERE product_id = NEW.product_id;
    -- If inventory is going out, decrease stock quantity
    ELSIF NEW.transaction_type = 'OUT' THEN
        -- Check if there's enough inventory
        IF (SELECT stock_quantity FROM products WHERE product_id = NEW.product_id) < NEW.quantity THEN
            RAISE EXCEPTION 'Not enough inventory for product ID %', NEW.product_id;
        END IF;
        
        UPDATE products
        SET stock_quantity = stock_quantity - NEW.quantity
        WHERE product_id = NEW.product_id;
    END IF;
    
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Create the AFTER INSERT trigger
CREATE TRIGGER after_inventory_transaction
AFTER INSERT ON inventory_transactions
FOR EACH ROW
EXECUTE FUNCTION update_product_inventory();

-- Test with inventory transactions
INSERT INTO inventory_transactions (product_id, transaction_type, quantity)
VALUES (2, 'IN', 10);

INSERT INTO inventory_transactions (product_id, transaction_type, quantity)
VALUES (2, 'OUT', 5);
```

### Example 6: Trigger with Exception Handling

```sql
-- Create a table for orders
CREATE TABLE orders (
    order_id SERIAL PRIMARY KEY,
    customer_id INTEGER,
    order_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    total_amount NUMERIC(12, 2) DEFAULT 0
);

-- Create a table for order items
CREATE TABLE order_items (
    order_id INTEGER REFERENCES orders(order_id),
    product_id INTEGER REFERENCES products(product_id),
    quantity INTEGER CHECK (quantity > 0),
    unit_price NUMERIC(10, 2),
    PRIMARY KEY (order_id, product_id)
);

-- Create a function to check and update inventory when order items are added
CREATE OR REPLACE FUNCTION check_inventory_for_order()
RETURNS TRIGGER AS $$
DECLARE
    available_quantity INTEGER;
BEGIN
    -- Get available quantity
    SELECT stock_quantity INTO available_quantity
    FROM products
    WHERE product_id = NEW.product_id;
    
    -- Check if there's enough inventory
    IF available_quantity < NEW.quantity THEN
        RAISE EXCEPTION 'Not enough inventory for product ID %. Available: %, Requested: %', 
            NEW.product_id, available_quantity, NEW.quantity;
    END IF;
    
    -- Update inventory
    UPDATE products
    SET stock_quantity = stock_quantity - NEW.quantity
    WHERE product_id = NEW.product_id;
    
    -- Update order total
    UPDATE orders
    SET total_amount = total_amount + (NEW.quantity * NEW.unit_price)
    WHERE order_id = NEW.order_id;
    
    -- Log the transaction
    INSERT INTO inventory_transactions (product_id, transaction_type, quantity)
    VALUES (NEW.product_id, 'OUT', NEW.quantity);
    
    RETURN NEW;
EXCEPTION
    WHEN others THEN
        -- Log error
        RAISE NOTICE 'Error processing order item: %', SQLERRM;
        RETURN NULL;
END;
$$ LANGUAGE plpgsql;

-- Create the AFTER INSERT trigger
CREATE TRIGGER after_order_item_insert
AFTER INSERT ON order_items
FOR EACH ROW
EXECUTE FUNCTION check_inventory_for_order();

-- Test with order and order items
INSERT INTO orders (customer_id)
VALUES (101);

-- This should work
INSERT INTO order_items (order_id, product_id, quantity, unit_price)
VALUES (1, 2, 3, (SELECT price FROM products WHERE product_id = 2));

-- This should fail if stock_quantity < 1000
INSERT INTO order_items (order_id, product_id, quantity, unit_price)
VALUES (1, 3, 1000, (SELECT price FROM products WHERE product_id = 3));
```

### Example 7: Disabling and Re-enabling Triggers

```sql
-- Disable all triggers on a table
ALTER TABLE products DISABLE TRIGGER ALL;

-- Disable a specific trigger
ALTER TABLE products DISABLE TRIGGER before_product_update;

-- Re-enable a specific trigger
ALTER TABLE products ENABLE TRIGGER before_product_update;

-- Re-enable all triggers on a table
ALTER TABLE products ENABLE TRIGGER ALL;

-- Check which triggers are enabled/disabled
SELECT 
    t.tgname AS trigger_name,
    t.tgenabled AS enabled,
    c.relname AS table_name,
    p.proname AS function_name
FROM pg_trigger t
JOIN pg_class c ON t.tgrelid = c.oid
JOIN pg_proc p ON t.tgfoid = p.oid
JOIN pg_namespace n ON c.relnamespace = n.oid
WHERE n.nspname = 'public'
ORDER BY c.relname, t.tgname;
```

## Practice Exercises

1. Trigger Basics:
   - Create a table for customers and a customer_audit_log table
   - Implement AFTER INSERT, UPDATE, and DELETE triggers to log changes to customer data
   - Test the triggers with various operations

2. Practical Triggers:
   - Create a table for products with a status field ('active', 'discontinued')
   - Implement a trigger that prevents deletion of active products
   - Implement a trigger that automatically updates related tables when a product status changes

3. Advanced Trigger Scenarios:
   - Create a complete order processing system with:
     - Triggers that validate inventory levels before confirming an order
     - Triggers that update inventory when orders are processed
     - Triggers that calculate order totals when items are added or removed

4. Working with Exceptions:
   - Enhance the order processing triggers to handle various error conditions
   - Implement appropriate error messages for different scenarios
   - Create a log of attempted operations that failed due to trigger validations

5. Challenge: Implement a trigger-based solution for maintaining materialized data.
   - Create a table that stores aggregate data (e.g., daily sales by product category)
   - Implement triggers that automatically update this table when individual transactions occur
   - Test the system with various operations and ensure consistency

## Additional Resources

- [PostgreSQL Trigger Documentation](https://www.postgresql.org/docs/current/triggers.html)
- [PostgreSQL Trigger Functions](https://www.postgresql.org/docs/current/plpgsql-trigger.html)
- [Best Practices for PostgreSQL Triggers](https://www.postgresql.org/docs/current/plpgsql-implementation.html)
