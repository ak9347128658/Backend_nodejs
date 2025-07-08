-- Day 5: Full-Text Search and Arrays

-- PART 1: FULL-TEXT SEARCH

-- Example 1: Introduction to Full-Text Search Data Types
-- Create a sample table for documents
CREATE TABLE articles (
    article_id SERIAL PRIMARY KEY,
    title TEXT NOT NULL,
    body TEXT NOT NULL,
    published_date DATE NOT NULL
);

-- Insert some sample data
INSERT INTO articles (title, body, published_date) VALUES
(
    'PostgreSQL Full-Text Search',
    'PostgreSQL provides built-in full-text search functionality. Full-text search provides the capability to identify natural-language documents that satisfy a query and optionally to sort them by relevance to the query.',
    '2023-01-15'
),
(
    'PostgreSQL Advanced Features',
    'PostgreSQL offers many advanced features such as complex JSON operations, window functions, and full-text search capabilities. These features make PostgreSQL a powerful choice for modern applications.',
    '2023-02-20'
),
(
    'Database Indexing Strategies',
    'Proper indexing is crucial for database performance. Different types of indexes like B-tree, Hash, GIN, and GiST serve different purposes and query patterns.',
    '2023-03-10'
),
(
    'SQL Query Optimization',
    'Optimizing SQL queries is essential for application performance. Techniques include proper indexing, query rewriting, and understanding the PostgreSQL query planner.',
    '2023-04-05'
),
(
    'PostgreSQL vs. Other Databases',
    'When comparing PostgreSQL to other database systems like MySQL, Oracle, or SQL Server, PostgreSQL stands out for its standards compliance, extensibility, and advanced features.',
    '2023-05-12'
);

-- Convert a text column to tsvector
SELECT 
    title,
    to_tsvector(title) AS title_vector
FROM 
    articles;

-- Create a tsquery
SELECT to_tsquery('postgresql & features') AS query;

-- Basic matching of tsvector and tsquery
SELECT 
    title,
    to_tsvector(title) @@ to_tsquery('postgresql & features') AS matches
FROM 
    articles;

-- Example 2: Full Document Search
-- Search both title and body
SELECT 
    article_id,
    title,
    published_date,
    to_tsvector(title || ' ' || body) @@ to_tsquery('postgresql & features') AS matches
FROM 
    articles
WHERE 
    to_tsvector(title || ' ' || body) @@ to_tsquery('postgresql & features');

-- Using plainto_tsquery for natural language queries
SELECT 
    article_id,
    title,
    published_date
FROM 
    articles
WHERE 
    to_tsvector(title || ' ' || body) @@ plainto_tsquery('postgresql features');

-- Using phraseto_tsquery for phrase matching
SELECT 
    article_id,
    title,
    published_date
FROM 
    articles
WHERE 
    to_tsvector(title || ' ' || body) @@ phraseto_tsquery('full text search');

-- Using websearch_to_tsquery for web search syntax
SELECT 
    article_id,
    title,
    published_date
FROM 
    articles
WHERE 
    to_tsvector(title || ' ' || body) @@ websearch_to_tsquery('postgresql -mysql');

-- Example 3: Language Support and Dictionaries
-- Specify the language for text search
SELECT 
    title,
    to_tsvector('english', title) AS english_vector
FROM 
    articles;

-- Different languages can give different results
SELECT 
    'The quick brown foxes jumped over the lazy dogs',
    to_tsvector('english', 'The quick brown foxes jumped over the lazy dogs') AS english_vector,
    to_tsvector('simple', 'The quick brown foxes jumped over the lazy dogs') AS simple_vector;

-- Language-specific stemming
SELECT 
    to_tsvector('english', 'run running runs runner') AS english_stemming;

-- Different query types with language support
SELECT 
    article_id,
    title
FROM 
    articles
WHERE 
    to_tsvector('english', title || ' ' || body) @@ to_tsquery('english', 'database & (index | indexing)');

-- Example 4: Ranking Search Results
-- Rank search results by relevance using ts_rank
SELECT 
    article_id,
    title,
    ts_rank(to_tsvector('english', title || ' ' || body), to_tsquery('english', 'postgresql & features')) AS rank
FROM 
    articles
WHERE 
    to_tsvector('english', title || ' ' || body) @@ to_tsquery('english', 'postgresql & features')
ORDER BY 
    rank DESC;

-- Using ts_rank_cd which considers document structure
SELECT 
    article_id,
    title,
    ts_rank_cd(to_tsvector('english', title || ' ' || body), to_tsquery('english', 'postgresql & features')) AS rank
FROM 
    articles
WHERE 
    to_tsvector('english', title || ' ' || body) @@ to_tsquery('english', 'postgresql & features')
ORDER BY 
    rank DESC;

-- Normalizing rank values
SELECT 
    article_id,
    title,
    ts_rank(to_tsvector('english', title || ' ' || body), to_tsquery('english', 'postgresql & features'), 1) AS rank_normalized
FROM 
    articles
WHERE 
    to_tsvector('english', title || ' ' || body) @@ to_tsquery('english', 'postgresql & features')
ORDER BY 
    rank_normalized DESC;

-- Weighting document parts differently
SELECT 
    article_id,
    title,
    ts_rank(
        setweight(to_tsvector('english', title), 'A') || 
        setweight(to_tsvector('english', body), 'B'),
        to_tsquery('english', 'postgresql & features')
    ) AS rank
FROM 
    articles
WHERE 
    setweight(to_tsvector('english', title), 'A') || 
    setweight(to_tsvector('english', body), 'B') @@ to_tsquery('english', 'postgresql & features')
ORDER BY 
    rank DESC;

-- Example 5: Optimizing Full-Text Search with Indexes
-- Add tsvector columns for better performance
ALTER TABLE articles 
ADD COLUMN textsearch tsvector 
GENERATED ALWAYS AS (to_tsvector('english', title || ' ' || body)) STORED;

-- Create a GIN index on the tsvector column
CREATE INDEX textsearch_idx ON articles USING GIN (textsearch);

-- Now searches can use the index
EXPLAIN ANALYZE
SELECT 
    article_id,
    title
FROM 
    articles
WHERE 
    textsearch @@ to_tsquery('english', 'postgresql & features');

-- Alternative approach: functional index
CREATE INDEX articles_title_body_idx ON articles 
USING GIN (to_tsvector('english', title || ' ' || body));

-- Using the function index
EXPLAIN ANALYZE
SELECT 
    article_id,
    title
FROM 
    articles
WHERE 
    to_tsvector('english', title || ' ' || body) @@ to_tsquery('english', 'postgresql & features');

-- Example 6: Highlighting Search Results
-- Create a sample query
SELECT to_tsquery('english', 'postgresql & features') AS query;

-- Highlight matches in text
SELECT 
    article_id,
    title,
    ts_headline(
        'english',
        body,
        to_tsquery('english', 'postgresql & features'),
        'StartSel = <b>, StopSel = </b>, MaxWords=50, MinWords=5'
    ) AS highlighted_body
FROM 
    articles
WHERE 
    to_tsvector('english', title || ' ' || body) @@ to_tsquery('english', 'postgresql & features');

-- Customizing ts_headline output
SELECT 
    article_id,
    title,
    ts_headline(
        'english',
        body,
        to_tsquery('english', 'postgresql & features'),
        'StartSel = <mark>, StopSel = </mark>, MaxFragments=2, FragmentDelimiter=...'
    ) AS highlighted_body
FROM 
    articles
WHERE 
    to_tsvector('english', title || ' ' || body) @@ to_tsquery('english', 'postgresql & features');

-- Example 7: Advanced Full-Text Search Techniques
-- Using lexemes directly
SELECT 
    article_id,
    title
FROM 
    articles
WHERE 
    to_tsvector('english', title || ' ' || body) @@ to_tsquery('english', 'postgresql:* & database');

-- Negation in queries
SELECT 
    article_id,
    title
FROM 
    articles
WHERE 
    to_tsvector('english', title || ' ' || body) @@ to_tsquery('english', 'database & !mysql');

-- Proximity search (words must be within a certain distance)
SELECT 
    article_id,
    title
FROM 
    articles
WHERE 
    to_tsvector('english', title || ' ' || body) @@ to_tsquery('english', 'postgresql <-> features');

-- Showing the lexemes in a document
SELECT 
    title,
    regexp_replace(
        to_tsvector('english', title)::text,
        '\'', '', 'g'
    ) AS lexemes
FROM 
    articles;

-- Creating a trigger to automatically update the tsvector column
CREATE OR REPLACE FUNCTION articles_trigger()
RETURNS trigger AS $$
BEGIN
    NEW.textsearch := to_tsvector('english', NEW.title || ' ' || NEW.body);
    RETURN NEW;
END
$$ LANGUAGE plpgsql;

CREATE TRIGGER tsvectorupdate 
BEFORE INSERT OR UPDATE ON articles
FOR EACH ROW EXECUTE FUNCTION articles_trigger();

-- PART 2: ARRAYS IN POSTGRESQL

-- Example 1: Creating Tables with Array Columns
-- Create a table with an array column
CREATE TABLE products (
    product_id SERIAL PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    price NUMERIC(10, 2) NOT NULL,
    tags TEXT[] -- Array of text
);

-- Insert data with arrays
INSERT INTO products (name, price, tags) VALUES
('Smartphone', 699.99, ARRAY['electronics', 'mobile', 'communication']),
('Laptop', 1299.99, ARRAY['electronics', 'computer', 'portable']),
('Headphones', 149.99, ARRAY['electronics', 'audio', 'accessories']),
('T-shirt', 19.99, ARRAY['clothing', 'casual', 'cotton']),
('Running Shoes', 89.99, ARRAY['footwear', 'sports', 'running']),
('Coffee Maker', 59.99, ARRAY['kitchen', 'appliances', 'brewing']),
('Novel Book', 14.99, ARRAY['books', 'fiction', 'entertainment']),
('Yoga Mat', 29.99, ARRAY['fitness', 'yoga', 'exercise']);

-- Querying the table
SELECT * FROM products;

-- Example 2: Accessing Array Elements
-- Access specific array elements (1-based indexing)
SELECT 
    name,
    tags,
    tags[1] AS first_tag,
    tags[2] AS second_tag
FROM 
    products;

-- Slicing arrays
SELECT 
    name,
    tags,
    tags[1:2] AS first_two_tags
FROM 
    products;

-- Array length
SELECT 
    name,
    tags,
    array_length(tags, 1) AS number_of_tags
FROM 
    products;

-- Unnesting arrays (converting array to rows)
SELECT 
    name,
    unnest(tags) AS tag
FROM 
    products;

-- Aggregating unnested arrays with GROUP BY
SELECT 
    unnest(tags) AS tag,
    COUNT(*) AS product_count
FROM 
    products
GROUP BY 
    tag
ORDER BY 
    product_count DESC;

-- Example 3: Searching Arrays
-- Checking if an array contains a value
SELECT 
    name,
    tags,
    'electronics' = ANY(tags) AS is_electronic
FROM 
    products;

-- Using the contains operator (@>)
SELECT 
    name,
    tags
FROM 
    products
WHERE 
    tags @> ARRAY['electronics'];

-- Using the overlap operator (&&)
SELECT 
    name,
    tags
FROM 
    products
WHERE 
    tags && ARRAY['electronics', 'clothing'];

-- Finding products that have all specified tags
SELECT 
    name,
    tags
FROM 
    products
WHERE 
    tags @> ARRAY['electronics', 'portable'];

-- Finding products that have any of the specified tags
SELECT 
    name,
    tags
FROM 
    products
WHERE 
    tags && ARRAY['electronics', 'fitness'];

-- Example 4: Modifying Arrays
-- Adding an element to an array
UPDATE products
SET tags = array_append(tags, 'sale')
WHERE price < 50.00;

-- Removing an element from an array
UPDATE products
SET tags = array_remove(tags, 'sale')
WHERE name = 'Novel Book';

-- Concatenating arrays
UPDATE products
SET tags = tags || ARRAY['premium']
WHERE price > 1000.00;

-- Replacing an array element
UPDATE products
SET tags[1] = 'tech'
WHERE tags[1] = 'electronics' AND name = 'Smartphone';

-- Adding multiple elements
UPDATE products
SET tags = tags || ARRAY['gift', 'popular']
WHERE name IN ('Headphones', 'Running Shoes');

-- Clear the array (set to empty)
UPDATE products
SET tags = ARRAY[]::TEXT[]
WHERE name = 'Coffee Maker';

-- Reset the Coffee Maker tags
UPDATE products
SET tags = ARRAY['kitchen', 'appliances', 'brewing']
WHERE name = 'Coffee Maker';

-- Example 5: Array Functions and Operators
-- Create another table for demonstration
CREATE TABLE orders (
    order_id SERIAL PRIMARY KEY,
    customer_id INTEGER NOT NULL,
    order_date DATE NOT NULL,
    product_ids INTEGER[],
    quantities INTEGER[]
);

INSERT INTO orders (customer_id, order_date, product_ids, quantities) VALUES
(1, '2023-01-15', ARRAY[1, 3], ARRAY[1, 2]),
(2, '2023-01-20', ARRAY[2, 5, 7], ARRAY[1, 1, 3]),
(3, '2023-02-05', ARRAY[4, 6], ARRAY[2, 1]),
(1, '2023-02-15', ARRAY[1, 2, 3], ARRAY[1, 1, 1]),
(4, '2023-03-10', ARRAY[5, 8], ARRAY[2, 1]);

-- array_position: Find the position of an element
SELECT 
    name,
    tags,
    array_position(tags, 'electronics') AS electronics_position
FROM 
    products;

-- array_positions: Find all positions of an element
SELECT 
    name,
    tags,
    array_positions(tags, 'electronics') AS electronics_positions
FROM 
    products;

-- array_cat: Concatenate two arrays
SELECT 
    o.order_id,
    o.product_ids,
    o.quantities,
    array_cat(o.product_ids, o.quantities) AS combined_array
FROM 
    orders o;

-- array_dims: Get array dimensions
SELECT 
    order_id,
    product_ids,
    array_dims(product_ids) AS dimensions
FROM 
    orders;

-- array_ndims: Get number of dimensions
SELECT 
    order_id,
    product_ids,
    array_ndims(product_ids) AS num_dimensions
FROM 
    orders;

-- array_to_string: Convert array to string
SELECT 
    name,
    array_to_string(tags, ', ', 'N/A') AS tags_string
FROM 
    products;

-- string_to_array: Convert string to array
SELECT 
    'apple,banana,orange',
    string_to_array('apple,banana,orange', ',') AS fruit_array;

-- array_agg: Aggregate values into an array
SELECT 
    customer_id,
    array_agg(order_id) AS order_ids,
    array_agg(order_date) AS order_dates
FROM 
    orders
GROUP BY 
    customer_id;

-- array_fill: Create array filled with values
SELECT array_fill(42, ARRAY[3]) AS filled_array; -- Create array [42,42,42]

-- array_upper/array_lower: Get array bounds
SELECT 
    name,
    array_lower(tags, 1) AS lower_bound,
    array_upper(tags, 1) AS upper_bound
FROM 
    products;

-- Example 6: Array Operators
-- Equality: Check if arrays are equal
SELECT 
    ARRAY[1, 2, 3] = ARRAY[1, 2, 3] AS are_equal,
    ARRAY[1, 2, 3] = ARRAY[3, 2, 1] AS are_equal_different_order;

-- Contains: Check if left array contains right array
SELECT 
    ARRAY[1, 2, 3, 4] @> ARRAY[2, 3] AS left_contains_right,
    ARRAY[1, 2] @> ARRAY[1, 2, 3] AS right_contains_left;

-- Contained by: Check if left array is contained by right array
SELECT 
    ARRAY[2, 3] <@ ARRAY[1, 2, 3, 4] AS left_contained_by_right,
    ARRAY[1, 2, 3] <@ ARRAY[1, 2] AS right_contained_by_left;

-- Overlap: Check if arrays have elements in common
SELECT 
    ARRAY[1, 2, 3] && ARRAY[3, 4, 5] AS arrays_overlap,
    ARRAY[1, 2] && ARRAY[3, 4] AS arrays_do_not_overlap;

-- Concatenation: Combine arrays
SELECT 
    ARRAY[1, 2] || ARRAY[3, 4] AS concatenated_arrays,
    ARRAY[1, 2] || 3 AS append_element,
    1 || ARRAY[2, 3] AS prepend_element;

-- Find products with any tags in common with 'Laptop'
WITH laptop_tags AS (
    SELECT tags FROM products WHERE name = 'Laptop'
)
SELECT 
    p.name,
    p.tags
FROM 
    products p, laptop_tags lt
WHERE 
    p.name != 'Laptop' AND
    p.tags && lt.tags
ORDER BY 
    p.name;

-- Example 7: Indexing Arrays
-- Create a GIN index for array containment operations
CREATE INDEX idx_products_tags ON products USING GIN (tags);

-- Using the index for queries
EXPLAIN ANALYZE
SELECT 
    name,
    tags
FROM 
    products
WHERE 
    tags @> ARRAY['electronics'];

-- Create an index for the order product_ids
CREATE INDEX idx_orders_product_ids ON orders USING GIN (product_ids);

-- Query using the index
EXPLAIN ANALYZE
SELECT 
    order_id,
    customer_id,
    order_date
FROM 
    orders
WHERE 
    product_ids @> ARRAY[1];

-- For equality searches, a btree index might be better
CREATE INDEX idx_orders_product_ids_btree ON orders USING btree (product_ids);

-- Query using the btree index
EXPLAIN ANALYZE
SELECT 
    order_id,
    customer_id,
    order_date
FROM 
    orders
WHERE 
    product_ids = ARRAY[1, 3];

-- Example 8: Arrays with JSON
-- Converting between JSON arrays and PostgreSQL arrays
SELECT 
    name,
    tags,
    to_json(tags) AS tags_json
FROM 
    products;

-- Creating an array from JSON
SELECT 
    name,
    ARRAY(SELECT jsonb_array_elements_text('["red", "green", "blue"]'::jsonb)) AS colors
FROM 
    products
WHERE 
    name = 'Smartphone';

-- Storing arrays in JSON
CREATE TABLE product_inventory (
    inventory_id SERIAL PRIMARY KEY,
    product_id INTEGER REFERENCES products(product_id),
    data JSONB
);

INSERT INTO product_inventory (product_id, data) VALUES
(1, '{"colors": ["black", "silver", "gold"], "storage_gb": [64, 128, 256]}'),
(2, '{"colors": ["silver", "space gray"], "storage_gb": [256, 512, 1024]}');

-- Accessing JSON arrays
SELECT 
    p.name,
    pi.data->'colors' AS available_colors,
    pi.data->'storage_gb' AS storage_options
FROM 
    product_inventory pi
JOIN 
    products p ON pi.product_id = p.product_id;

-- Extracting array elements from JSON
SELECT 
    p.name,
    jsonb_array_elements_text(pi.data->'colors') AS color
FROM 
    product_inventory pi
JOIN 
    products p ON pi.product_id = p.product_id;

-- Checking if a JSON array contains a value
SELECT 
    p.name,
    pi.data,
    pi.data->'colors' ? 'black' AS has_black
FROM 
    product_inventory pi
JOIN 
    products p ON pi.product_id = p.product_id;

-- Example 9: Multi-dimensional Arrays
-- Create a table with a 2D array
CREATE TABLE matrix_examples (
    matrix_id SERIAL PRIMARY KEY,
    name TEXT,
    matrix INTEGER[][]
);

-- Insert some 2D arrays
INSERT INTO matrix_examples (name, matrix) VALUES
('2x2 Identity', ARRAY[[1,0],[0,1]]),
('2x3 Rectangle', ARRAY[[1,2,3],[4,5,6]]);

-- Query 2D arrays
SELECT * FROM matrix_examples;

-- Access specific elements
SELECT 
    name,
    matrix,
    matrix[1][1] AS element_1_1,
    matrix[2][2] AS element_2_2
FROM 
    matrix_examples;

-- Unnest 2D arrays
SELECT 
    name,
    unnest(matrix) AS row
FROM 
    matrix_examples;

-- Create a recursive function to print a matrix
CREATE OR REPLACE FUNCTION print_matrix(m INTEGER[][])
RETURNS TEXT AS $$
DECLARE
    result TEXT := '';
    i INTEGER;
BEGIN
    FOR i IN 1..array_length(m, 1) LOOP
        result := result || array_to_string(m[i], ',') || E'\n';
    END LOOP;
    RETURN result;
END;
$$ LANGUAGE plpgsql;

-- Use the function
SELECT 
    name,
    print_matrix(matrix) AS formatted_matrix
FROM 
    matrix_examples;

-- Example 10: Practical Use Cases for Arrays
-- Example: Order items as arrays instead of separate rows
CREATE TABLE compact_orders (
    order_id SERIAL PRIMARY KEY,
    customer_id INTEGER NOT NULL,
    order_date DATE NOT NULL,
    product_ids INTEGER[],
    quantities INTEGER[],
    prices NUMERIC(10, 2)[]
);

INSERT INTO compact_orders (customer_id, order_date, product_ids, quantities, prices) VALUES
(1, '2023-01-15', ARRAY[1, 3], ARRAY[1, 2], ARRAY[699.99, 149.99]),
(2, '2023-01-20', ARRAY[2, 5, 7], ARRAY[1, 1, 3], ARRAY[1299.99, 89.99, 14.99]);

-- Calculate order total
SELECT 
    order_id,
    customer_id,
    SUM((unnest(prices) * unnest(quantities))) AS order_total
FROM 
    compact_orders
GROUP BY 
    order_id, customer_id;

-- Example: Storing historical data
CREATE TABLE employee_salary_history (
    employee_id INTEGER PRIMARY KEY,
    employee_name TEXT NOT NULL,
    salary_amounts NUMERIC(10, 2)[],
    salary_dates DATE[]
);

INSERT INTO employee_salary_history VALUES
(1, 'John Smith', ARRAY[55000, 60000, 65000], ARRAY['2021-01-01', '2022-01-01', '2023-01-01']),
(2, 'Mary Johnson', ARRAY[65000, 72000], ARRAY['2022-01-01', '2023-01-01']);

-- Display salary history with unnest
SELECT 
    employee_id,
    employee_name,
    unnest(salary_amounts) AS salary,
    unnest(salary_dates) AS effective_date
FROM 
    employee_salary_history
ORDER BY 
    employee_id, effective_date;

-- Example: Tag-based search system
CREATE TABLE articles_with_tags (
    article_id SERIAL PRIMARY KEY,
    title TEXT NOT NULL,
    content TEXT NOT NULL,
    tags TEXT[]
);

INSERT INTO articles_with_tags (title, content, tags) VALUES
('Getting Started with Arrays', 'PostgreSQL arrays are powerful...', ARRAY['postgresql', 'arrays', 'tutorial']),
('Advanced Array Techniques', 'Taking your array skills to the next level...', ARRAY['postgresql', 'arrays', 'advanced']),
('Full-Text Search in PostgreSQL', 'Learn to implement full-text search...', ARRAY['postgresql', 'full-text', 'search']);

-- Create an index for the tags
CREATE INDEX idx_articles_tags ON articles_with_tags USING GIN (tags);

-- Find articles with specific tags
SELECT 
    article_id,
    title,
    tags
FROM 
    articles_with_tags
WHERE 
    tags @> ARRAY['postgresql', 'arrays'];

-- Find articles with any of these tags
SELECT 
    article_id,
    title,
    tags
FROM 
    articles_with_tags
WHERE 
    tags && ARRAY['full-text', 'advanced'];

-- Count articles by tag
SELECT 
    unnest(tags) AS tag,
    COUNT(*) AS article_count
FROM 
    articles_with_tags
GROUP BY 
    tag
ORDER BY 
    article_count DESC, tag;
