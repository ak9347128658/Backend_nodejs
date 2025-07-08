-- Examples for Day 1: Triggers and Events

-- Example 1: Basic Trigger Structure
-- Create a sample table for auditing
CREATE TABLE employees (
    employee_id SERIAL PRIMARY KEY,
    first_name VARCHAR(50),
    last_name VARCHAR(50),
    department VARCHAR(50),
    salary NUMERIC(10,2),
    hire_date DATE,
    last_updated TIMESTAMP
);

-- Create an audit table to track changes
CREATE TABLE employee_audit (
    audit_id SERIAL PRIMARY KEY,
    employee_id INTEGER,
    action VARCHAR(20),
    changed_by VARCHAR(50),
    changed_at TIMESTAMP,
    old_data JSONB,
    new_data JSONB
);

-- Create a function to be used by the trigger
CREATE OR REPLACE FUNCTION log_employee_change()
RETURNS TRIGGER AS $$
BEGIN
    IF TG_OP = 'INSERT' THEN
        INSERT INTO employee_audit (
            employee_id, action, changed_by, changed_at, new_data
        ) VALUES (
            NEW.employee_id, 
            'INSERT', 
            current_user, 
            current_timestamp, 
            to_jsonb(NEW)
        );
        RETURN NEW;
    ELSIF TG_OP = 'UPDATE' THEN
        INSERT INTO employee_audit (
            employee_id, action, changed_by, changed_at, old_data, new_data
        ) VALUES (
            NEW.employee_id, 
            'UPDATE', 
            current_user, 
            current_timestamp, 
            to_jsonb(OLD),
            to_jsonb(NEW)
        );
        RETURN NEW;
    ELSIF TG_OP = 'DELETE' THEN
        INSERT INTO employee_audit (
            employee_id, action, changed_by, changed_at, old_data
        ) VALUES (
            OLD.employee_id, 
            'DELETE', 
            current_user, 
            current_timestamp, 
            to_jsonb(OLD)
        );
        RETURN OLD;
    END IF;
END;
$$ LANGUAGE plpgsql;

-- Create the trigger
CREATE TRIGGER employee_audit_trigger
AFTER INSERT OR UPDATE OR DELETE ON employees
FOR EACH ROW EXECUTE FUNCTION log_employee_change();

-- Test the trigger
-- Insert data
INSERT INTO employees (first_name, last_name, department, salary, hire_date, last_updated)
VALUES 
('John', 'Smith', 'Engineering', 85000, '2022-01-15', current_timestamp),
('Sarah', 'Johnson', 'Marketing', 75000, '2022-02-20', current_timestamp);

-- Update data
UPDATE employees 
SET salary = 90000, last_updated = current_timestamp
WHERE first_name = 'John';

-- Delete data
DELETE FROM employees 
WHERE first_name = 'Sarah';

-- Check the audit log
SELECT * FROM employee_audit;

-- Example 2: Before vs. After Triggers
-- Create a function to update the 'last_updated' timestamp
CREATE OR REPLACE FUNCTION update_last_updated()
RETURNS TRIGGER AS $$
BEGIN
    NEW.last_updated = current_timestamp;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Create a BEFORE trigger
CREATE TRIGGER update_employee_timestamp
BEFORE UPDATE ON employees
FOR EACH ROW EXECUTE FUNCTION update_last_updated();

-- Test the BEFORE trigger
INSERT INTO employees (first_name, last_name, department, salary, hire_date, last_updated)
VALUES ('Emily', 'Brown', 'Finance', 78000, '2022-03-10', current_timestamp);

-- Update without specifying last_updated
UPDATE employees 
SET salary = 80000
WHERE first_name = 'Emily';

-- Check if last_updated was automatically updated
SELECT first_name, last_name, salary, last_updated 
FROM employees 
WHERE first_name = 'Emily';

-- Example 3: Statement-Level vs. Row-Level Triggers
-- Create a table to log general database activities
CREATE TABLE activity_log (
    log_id SERIAL PRIMARY KEY,
    table_name VARCHAR(50),
    operation VARCHAR(20),
    operation_timestamp TIMESTAMP,
    number_of_rows INTEGER
);

-- Create a statement-level trigger function
CREATE OR REPLACE FUNCTION log_employee_activity()
RETURNS TRIGGER AS $$
BEGIN
    INSERT INTO activity_log (
        table_name, 
        operation, 
        operation_timestamp, 
        number_of_rows
    ) VALUES (
        TG_TABLE_NAME,
        TG_OP,
        current_timestamp,
        CASE 
            WHEN TG_OP = 'DELETE' THEN OLD.count
            WHEN TG_OP = 'UPDATE' THEN NEW.count
            WHEN TG_OP = 'INSERT' THEN NEW.count
            ELSE NULL
        END
    );
    RETURN NULL;
END;
$$ LANGUAGE plpgsql;

-- Create a statement-level trigger
CREATE TRIGGER employee_activity_trigger
AFTER INSERT OR UPDATE OR DELETE ON employees
REFERENCING NEW TABLE AS NEW OLD TABLE AS OLD
FOR EACH STATEMENT EXECUTE FUNCTION log_employee_activity();

-- Example 4: Conditional Triggers
-- Create a function for a conditional trigger
CREATE OR REPLACE FUNCTION check_salary_increase()
RETURNS TRIGGER AS $$
BEGIN
    -- Only log if salary increased by more than 10%
    IF (NEW.salary > OLD.salary * 1.1) THEN
        INSERT INTO activity_log (
            table_name,
            operation,
            operation_timestamp,
            number_of_rows
        ) VALUES (
            'employees',
            'LARGE_SALARY_INCREASE',
            current_timestamp,
            1
        );
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Create a trigger for the salary increase check
CREATE TRIGGER check_large_salary_increase
AFTER UPDATE OF salary ON employees
FOR EACH ROW
WHEN (NEW.salary > OLD.salary * 1.1)
EXECUTE FUNCTION check_salary_increase();

-- Test the conditional trigger
-- This should trigger the logging (more than 10% increase)
UPDATE employees 
SET salary = 95000
WHERE first_name = 'John';

-- This should NOT trigger the logging (less than 10% increase)
UPDATE employees 
SET salary = 82000
WHERE first_name = 'Emily';

-- Example 5: Using Triggers for Enforcing Business Rules
-- Create a departments table
CREATE TABLE departments (
    department_id SERIAL PRIMARY KEY,
    department_name VARCHAR(50),
    budget NUMERIC(12,2),
    manager_id INTEGER
);

-- Insert department data
INSERT INTO departments (department_name, budget, manager_id)
VALUES 
('Engineering', 1000000, 1),
('Marketing', 800000, 2),
('Finance', 600000, 3);

-- Create a function to enforce salary caps based on department budget
CREATE OR REPLACE FUNCTION enforce_salary_cap()
RETURNS TRIGGER AS $$
DECLARE
    dept_budget NUMERIC(12,2);
    total_salaries NUMERIC(12,2);
    max_allowed_salary NUMERIC(10,2);
BEGIN
    -- Get department budget
    SELECT budget INTO dept_budget
    FROM departments
    WHERE department_name = NEW.department;
    
    -- Calculate total salaries in the department (excluding the current change)
    SELECT COALESCE(SUM(salary), 0) INTO total_salaries
    FROM employees
    WHERE department = NEW.department
    AND employee_id != COALESCE(NEW.employee_id, -1);
    
    -- Calculate maximum allowed salary (50% of remaining budget)
    max_allowed_salary := (dept_budget - total_salaries) * 0.5;
    
    -- Check if new salary exceeds the maximum allowed
    IF NEW.salary > max_allowed_salary THEN
        RAISE EXCEPTION 'Salary of % exceeds department budget cap. Maximum allowed: %', 
                        NEW.salary, max_allowed_salary;
    END IF;
    
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Create a trigger for salary cap enforcement
CREATE TRIGGER enforce_department_salary_cap
BEFORE INSERT OR UPDATE OF salary, department ON employees
FOR EACH ROW EXECUTE FUNCTION enforce_salary_cap();

-- Cleanup (comment these out if you want to keep testing)
-- DROP TRIGGER employee_audit_trigger ON employees;
-- DROP TRIGGER update_employee_timestamp ON employees;
-- DROP TRIGGER employee_activity_trigger ON employees;
-- DROP TRIGGER check_large_salary_increase ON employees;
-- DROP TRIGGER enforce_department_salary_cap ON employees;
-- DROP FUNCTION log_employee_change();
-- DROP FUNCTION update_last_updated();
-- DROP FUNCTION log_employee_activity();
-- DROP FUNCTION check_salary_increase();
-- DROP FUNCTION enforce_salary_cap();
-- DROP TABLE employee_audit;
-- DROP TABLE activity_log;
-- DROP TABLE employees;
-- DROP TABLE departments;
