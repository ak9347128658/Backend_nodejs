-- Exercises for Day 1: Triggers and Events

-- Exercise 1: Create a Basic Audit Trigger
-- Create a products table
CREATE TABLE products (
    product_id SERIAL PRIMARY KEY,
    product_name VARCHAR(100),
    category VARCHAR(50),
    price NUMERIC(10, 2),
    stock_quantity INTEGER,
    last_updated TIMESTAMP DEFAULT current_timestamp
);

-- Create a product_audit table
CREATE TABLE product_audit (
    audit_id SERIAL PRIMARY KEY,
    product_id INTEGER,
    action VARCHAR(10),
    changed_by VARCHAR(50),
    changed_at TIMESTAMP,
    old_price NUMERIC(10, 2),
    new_price NUMERIC(10, 2),
    old_quantity INTEGER,
    new_quantity INTEGER
);

-- Create a trigger function to track price and stock changes
CREATE OR REPLACE FUNCTION audit_product_changes()
RETURNS TRIGGER AS $$
BEGIN
    IF TG_OP = 'INSERT' THEN
        INSERT INTO product_audit (
            product_id, action, changed_by, changed_at, 
            new_price, new_quantity
        ) VALUES (
            NEW.product_id, 'INSERT', current_user, current_timestamp, 
            NEW.price, NEW.stock_quantity
        );
    ELSIF TG_OP = 'UPDATE' THEN
        -- Only audit if price or quantity changed
        IF (OLD.price != NEW.price OR OLD.stock_quantity != NEW.stock_quantity) THEN
            INSERT INTO product_audit (
                product_id, action, changed_by, changed_at, 
                old_price, new_price, old_quantity, new_quantity
            ) VALUES (
                NEW.product_id, 'UPDATE', current_user, current_timestamp, 
                OLD.price, NEW.price, OLD.stock_quantity, NEW.stock_quantity
            );
        END IF;
    ELSIF TG_OP = 'DELETE' THEN
        INSERT INTO product_audit (
            product_id, action, changed_by, changed_at, 
            old_price, old_quantity
        ) VALUES (
            OLD.product_id, 'DELETE', current_user, current_timestamp, 
            OLD.price, OLD.stock_quantity
        );
    END IF;
    RETURN NULL;
END;
$$ LANGUAGE plpgsql;

-- Create the trigger
CREATE TRIGGER product_audit_trigger
AFTER INSERT OR UPDATE OR DELETE ON products
FOR EACH ROW EXECUTE FUNCTION audit_product_changes();

-- Test the trigger
-- Insert products
INSERT INTO products (product_name, category, price, stock_quantity)
VALUES 
    ('Laptop', 'Electronics', 899.99, 25),
    ('Smartphone', 'Electronics', 499.99, 50),
    ('Headphones', 'Accessories', 79.99, 100);

-- Update products
UPDATE products SET price = 949.99 WHERE product_name = 'Laptop';
UPDATE products SET stock_quantity = 20 WHERE product_name = 'Smartphone';
UPDATE products SET price = 89.99, stock_quantity = 120 WHERE product_name = 'Headphones';

-- Delete a product
DELETE FROM products WHERE product_name = 'Smartphone';

-- Check the audit log
SELECT * FROM product_audit;

-- Exercise 2: Create a Trigger to Automatically Update Timestamps
-- Create a function to update the timestamp
CREATE OR REPLACE FUNCTION update_product_timestamp()
RETURNS TRIGGER AS $$
BEGIN
    NEW.last_updated = current_timestamp;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Create the trigger
CREATE TRIGGER update_product_last_updated
BEFORE UPDATE ON products
FOR EACH ROW EXECUTE FUNCTION update_product_timestamp();

-- Test the trigger
-- Check current timestamp
SELECT product_name, last_updated FROM products;

-- Update a product without specifying last_updated
UPDATE products SET price = 999.99 WHERE product_name = 'Laptop';

-- Verify the timestamp was updated automatically
SELECT product_name, price, last_updated FROM products WHERE product_name = 'Laptop';

-- Exercise 3: Create a Trigger to Enforce Business Rules
-- Create an orders table
CREATE TABLE orders (
    order_id SERIAL PRIMARY KEY,
    product_id INTEGER REFERENCES products(product_id),
    order_quantity INTEGER,
    order_date TIMESTAMP DEFAULT current_timestamp
);

-- Create a function to enforce stock quantity rules
CREATE OR REPLACE FUNCTION check_stock_availability()
RETURNS TRIGGER AS $$
DECLARE
    available_stock INTEGER;
BEGIN
    -- Get current stock level
    SELECT stock_quantity INTO available_stock
    FROM products
    WHERE product_id = NEW.product_id;
    
    -- Check if enough stock is available
    IF available_stock < NEW.order_quantity THEN
        RAISE EXCEPTION 'Not enough stock available. Requested: %, Available: %', 
                        NEW.order_quantity, available_stock;
    END IF;
    
    -- Update the stock quantity
    UPDATE products
    SET stock_quantity = stock_quantity - NEW.order_quantity
    WHERE product_id = NEW.product_id;
    
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Create the trigger
CREATE TRIGGER enforce_stock_availability
BEFORE INSERT ON orders
FOR EACH ROW EXECUTE FUNCTION check_stock_availability();

-- Test the trigger
-- Try to place valid orders
INSERT INTO orders (product_id, order_quantity)
SELECT product_id, 5 FROM products WHERE product_name = 'Laptop';

INSERT INTO orders (product_id, order_quantity)
SELECT product_id, 10 FROM products WHERE product_name = 'Headphones';

-- Check updated stock quantities
SELECT product_name, stock_quantity FROM products;

-- Try to place an order that exceeds available stock (should fail)
-- This should raise an exception
INSERT INTO orders (product_id, order_quantity)
SELECT product_id, 100 FROM products WHERE product_name = 'Laptop';

-- Exercise 4: Create a Trigger for Data Validation
-- Create a customers table
CREATE TABLE customers (
    customer_id SERIAL PRIMARY KEY,
    first_name VARCHAR(50),
    last_name VARCHAR(50),
    email VARCHAR(100),
    phone VARCHAR(20),
    created_at TIMESTAMP DEFAULT current_timestamp
);

-- Create a function to validate email format
CREATE OR REPLACE FUNCTION validate_customer_data()
RETURNS TRIGGER AS $$
BEGIN
    -- Validate email format (basic check)
    IF NEW.email !~ '^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$' THEN
        RAISE EXCEPTION 'Invalid email format: %', NEW.email;
    END IF;
    
    -- Validate phone format (assuming a simple format like XXX-XXX-XXXX)
    IF NEW.phone !~ '^[0-9]{3}-[0-9]{3}-[0-9]{4}$' THEN
        RAISE EXCEPTION 'Invalid phone format: %. Required format: XXX-XXX-XXXX', NEW.phone;
    END IF;
    
    -- Convert names to proper case
    NEW.first_name = INITCAP(NEW.first_name);
    NEW.last_name = INITCAP(NEW.last_name);
    
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Create the trigger
CREATE TRIGGER validate_customer_trigger
BEFORE INSERT OR UPDATE ON customers
FOR EACH ROW EXECUTE FUNCTION validate_customer_data();

-- Test the trigger
-- Valid customer data
INSERT INTO customers (first_name, last_name, email, phone)
VALUES ('john', 'smith', 'john.smith@example.com', '123-456-7890');

-- Check proper case conversion
SELECT * FROM customers;

-- Invalid email format (should fail)
-- This should raise an exception
INSERT INTO customers (first_name, last_name, email, phone)
VALUES ('Jane', 'Doe', 'jane.doe@invalid', '123-456-7890');

-- Invalid phone format (should fail)
-- This should raise an exception
INSERT INTO customers (first_name, last_name, email, phone)
VALUES ('Bob', 'Johnson', 'bob.johnson@example.com', '1234567890');

-- Exercise 5: Create a Trigger for Maintaining Referential Integrity
-- Create a customer_addresses table
CREATE TABLE customer_addresses (
    address_id SERIAL PRIMARY KEY,
    customer_id INTEGER REFERENCES customers(customer_id) ON DELETE CASCADE,
    address_type VARCHAR(20), -- 'billing', 'shipping', etc.
    street VARCHAR(100),
    city VARCHAR(50),
    state VARCHAR(50),
    zip_code VARCHAR(20),
    is_default BOOLEAN DEFAULT false
);

-- Create a function to ensure only one default address per customer
CREATE OR REPLACE FUNCTION manage_default_address()
RETURNS TRIGGER AS $$
BEGIN
    -- If the new/updated address is set as default
    IF NEW.is_default = true THEN
        -- Set all other addresses of this customer to non-default
        UPDATE customer_addresses
        SET is_default = false
        WHERE customer_id = NEW.customer_id
        AND address_id != NEW.address_id;
    END IF;
    
    -- Ensure each customer has at least one default address
    IF NOT EXISTS (
        SELECT 1 FROM customer_addresses 
        WHERE customer_id = NEW.customer_id AND is_default = true
    ) THEN
        -- If no default exists, make this one the default
        NEW.is_default := true;
    END IF;
    
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Create the trigger
CREATE TRIGGER enforce_one_default_address
BEFORE INSERT OR UPDATE ON customer_addresses
FOR EACH ROW EXECUTE FUNCTION manage_default_address();

-- Test the trigger
-- Add addresses for a customer
INSERT INTO customer_addresses (customer_id, address_type, street, city, state, zip_code, is_default)
VALUES 
    ((SELECT customer_id FROM customers LIMIT 1), 'billing', '123 Main St', 'New York', 'NY', '10001', true),
    ((SELECT customer_id FROM customers LIMIT 1), 'shipping', '456 Broadway', 'New York', 'NY', '10002', false);

-- Check current default status
SELECT customer_id, address_type, street, is_default FROM customer_addresses;

-- Update the non-default address to be the default
UPDATE customer_addresses 
SET is_default = true 
WHERE address_type = 'shipping';

-- Verify the default status changed for both addresses
SELECT customer_id, address_type, street, is_default FROM customer_addresses;

-- Cleanup (comment these out if you want to keep testing)
-- DROP TRIGGER product_audit_trigger ON products;
-- DROP TRIGGER update_product_last_updated ON products;
-- DROP TRIGGER enforce_stock_availability ON orders;
-- DROP TRIGGER validate_customer_trigger ON customers;
-- DROP TRIGGER enforce_one_default_address ON customer_addresses;
-- DROP FUNCTION audit_product_changes();
-- DROP FUNCTION update_product_timestamp();
-- DROP FUNCTION check_stock_availability();
-- DROP FUNCTION validate_customer_data();
-- DROP FUNCTION manage_default_address();
-- DROP TABLE customer_addresses;
-- DROP TABLE orders;
-- DROP TABLE customers;
-- DROP TABLE product_audit;
-- DROP TABLE products;
