-- Week 3 - Day 5: Exercises on Full-Text Search and Arrays
-- Complete the following exercises to practice working with PostgreSQL Full-Text Search and Arrays

-- PART 1: FULL-TEXT SEARCH EXERCISES

-- Setup: Create a table for blog posts
CREATE TABLE blog_posts (
    post_id SERIAL PRIMARY KEY,
    title TEXT NOT NULL,
    content TEXT NOT NULL,
    author TEXT NOT NULL,
    published_date DATE NOT NULL,
    category TEXT NOT NULL
);

-- Insert sample data
INSERT INTO blog_posts (title, content, author, published_date, category) VALUES
('Getting Started with PostgreSQL', 'PostgreSQL is a powerful open-source relational database system with over 30 years of active development. It is known for its reliability, feature robustness, and performance.', 'John Smith', '2023-01-05', 'Database'),
('Advanced SQL Techniques', 'This article covers advanced SQL techniques including window functions, common table expressions (CTEs), and recursive queries in PostgreSQL.', 'Maria Garcia', '2023-01-15', 'SQL'),
('Database Indexing Fundamentals', 'Proper indexing is crucial for database performance. This post covers B-tree, Hash, GIN, and GiST index types and when to use each one.', 'David Wong', '2023-02-10', 'Database'),
('Full-Text Search in PostgreSQL', 'PostgreSQL offers powerful full-text search capabilities that allow you to identify natural-language documents that satisfy a query and rank them by relevance.', 'Sarah Johnson', '2023-03-05', 'Search'),
('JSON Data Types in PostgreSQL', 'PostgreSQL provides two JSON data types: json and jsonb. This post explains the differences and shows techniques for effectively working with JSON data.', 'Michael Brown', '2023-03-20', 'Data Types'),
('PostgreSQL Performance Tuning', 'This comprehensive guide covers various aspects of PostgreSQL performance tuning, from configuration settings to query optimization and monitoring.', 'Jennifer Lee', '2023-04-10', 'Performance'),
('Building a RESTful API with PostgreSQL', 'Learn how to build a scalable RESTful API with PostgreSQL as the database backend. This tutorial covers schema design, query optimization, and connection pooling.', 'Robert Chen', '2023-05-05', 'Development'),
('PostgreSQL vs MySQL: Choosing the Right Database', 'This comparison of PostgreSQL and MySQL helps you understand the strengths and weaknesses of each database system to make an informed decision for your project.', 'Amanda Wilson', '2023-05-20', 'Database'),
('Data Modeling Best Practices', 'Effective data modeling is essential for database performance and maintainability. This post covers normalization, denormalization, and when to use each approach.', 'Thomas Miller', '2023-06-15', 'Database'),
('PostgreSQL Security Best Practices', 'Security is critical for any database system. Learn about role-based access control, encryption options, and other security features in PostgreSQL.', 'Emily Davis', '2023-07-01', 'Security');

-- Exercise 1: Basic Full-Text Search
-- Create a function that performs a basic full-text search on the blog_posts table
-- The function should take a search term as input and return matching posts
-- It should search in both title and content fields
-- TODO: Implement the function

CREATE OR REPLACE FUNCTION search_posts(search_term TEXT)
RETURNS TABLE (
    post_id INTEGER,
    title TEXT,
    author TEXT,
    published_date DATE,
    category TEXT
) AS $$
BEGIN
    -- Your code here
    RETURN QUERY -- Complete this query
    SELECT
        bp.post_id,
        bp.title,
        bp.author,
        bp.published_date,
        bp.category
    FROM
        blog_posts bp
    WHERE
        to_tsvector('english', bp.title || ' ' || bp.content) @@ plainto_tsquery('english', search_term);
END;
$$ LANGUAGE plpgsql;

-- Test your function with:
-- SELECT * FROM search_posts('PostgreSQL performance');

-- Exercise 2: Weighted Search with Ranking
-- Create a function that performs a weighted search on blog_posts
-- The title should have more weight than the content
-- Results should be ranked by relevance
-- TODO: Implement the function

CREATE OR REPLACE FUNCTION weighted_search_posts(search_term TEXT)
RETURNS TABLE (
    post_id INTEGER,
    title TEXT,
    author TEXT,
    category TEXT,
    rank FLOAT
) AS $$
BEGIN
    -- Your code here
    RETURN QUERY -- Complete this query
    SELECT
        bp.post_id,
        bp.title,
        bp.author,
        bp.category,
        ts_rank(
            setweight(to_tsvector('english', bp.title), 'A') ||
            setweight(to_tsvector('english', bp.content), 'B'),
            plainto_tsquery('english', search_term)
        ) AS rank
    FROM
        blog_posts bp
    WHERE
        setweight(to_tsvector('english', bp.title), 'A') ||
        setweight(to_tsvector('english', bp.content), 'B') @@ 
        plainto_tsquery('english', search_term)
    ORDER BY
        rank DESC;
END;
$$ LANGUAGE plpgsql;

-- Test your function with:
-- SELECT * FROM weighted_search_posts('database performance');

-- Exercise 3: Add a tsvector Column and Index
-- Add a tsvector column to the blog_posts table that contains the lexemes from both title and content
-- Create a GIN index on this column
-- Create a trigger to keep this column updated when posts are inserted or updated
-- TODO: Complete the following code

ALTER TABLE blog_posts
ADD COLUMN search_vector tsvector;

-- Update the existing rows
UPDATE blog_posts
SET search_vector = -- Complete this statement
    to_tsvector('english', title || ' ' || content);

-- Create the index
-- Your code here
CREATE INDEX blog_posts_search_idx ON blog_posts USING GIN (search_vector);

-- Create the trigger function
CREATE OR REPLACE FUNCTION blog_posts_trigger()
RETURNS trigger AS $$
BEGIN
    -- Your code here
    NEW.search_vector := to_tsvector('english', NEW.title || ' ' || NEW.content);
    RETURN NEW;
END
$$ LANGUAGE plpgsql;

-- Create the trigger
CREATE TRIGGER blog_posts_vector_update
BEFORE INSERT OR UPDATE ON blog_posts
FOR EACH ROW EXECUTE FUNCTION blog_posts_trigger();

-- Test your work with:
-- INSERT INTO blog_posts (title, content, author, published_date, category) 
-- VALUES ('Testing Search', 'This is a test of the search functionality.', 'Test User', CURRENT_DATE, 'Test');
-- SELECT post_id, title, search_vector FROM blog_posts WHERE post_id = (SELECT max(post_id) FROM blog_posts);

-- Exercise 4: Search with Highlighting
-- Create a function that returns highlighted search results
-- The function should take a search term and highlight matches in the content
-- TODO: Implement the function

CREATE OR REPLACE FUNCTION highlight_search_results(search_term TEXT)
RETURNS TABLE (
    post_id INTEGER,
    title TEXT,
    highlighted_content TEXT
) AS $$
BEGIN
    -- Your code here
    RETURN QUERY -- Complete this query
    SELECT
        bp.post_id,
        bp.title,
        ts_headline(
            'english',
            bp.content,
            plainto_tsquery('english', search_term),
            'StartSel = <mark>, StopSel = </mark>, MaxWords=50, MinWords=5'
        ) AS highlighted_content
    FROM
        blog_posts bp
    WHERE
        bp.search_vector @@ plainto_tsquery('english', search_term);
END;
$$ LANGUAGE plpgsql;

-- Test your function with:
-- SELECT * FROM highlight_search_results('database performance');

-- Exercise 5: Advanced Search with Boolean Operators
-- Create a function that allows for advanced search using boolean operators
-- The function should allow for AND, OR, and NOT operations in the search term
-- TODO: Implement the function

CREATE OR REPLACE FUNCTION advanced_search(search_query TEXT)
RETURNS TABLE (
    post_id INTEGER,
    title TEXT,
    author TEXT,
    category TEXT,
    rank FLOAT
) AS $$
BEGIN
    -- Your code here
    RETURN QUERY -- Complete this query
    SELECT
        bp.post_id,
        bp.title,
        bp.author,
        bp.category,
        ts_rank(bp.search_vector, to_tsquery('english', search_query)) AS rank
    FROM
        blog_posts bp
    WHERE
        bp.search_vector @@ to_tsquery('english', search_query)
    ORDER BY
        rank DESC;
END;
$$ LANGUAGE plpgsql;

-- Test your function with different queries:
-- SELECT * FROM advanced_search('postgresql & !mysql');
-- SELECT * FROM advanced_search('performance | tuning');
-- SELECT * FROM advanced_search('database & (indexing | modeling)');

-- PART 2: ARRAY EXERCISES

-- Setup: Create a table for student courses
CREATE TABLE students (
    student_id SERIAL PRIMARY KEY,
    name TEXT NOT NULL,
    email TEXT UNIQUE NOT NULL,
    enrollment_date DATE NOT NULL,
    courses TEXT[],
    grades INTEGER[],
    interests TEXT[]
);

-- Insert sample data
INSERT INTO students (name, email, enrollment_date, courses, grades, interests) VALUES
('Alex Smith', 'alex.smith@example.com', '2023-01-10', ARRAY['Math 101', 'Physics 101', 'Computer Science 101'], ARRAY[92, 88, 95], ARRAY['programming', 'robotics', 'gaming']),
('Emma Johnson', 'emma.j@example.com', '2023-01-15', ARRAY['Biology 101', 'Chemistry 101', 'English 101'], ARRAY[90, 85, 91], ARRAY['reading', 'nature', 'music']),
('Michael Brown', 'michael.b@example.com', '2023-02-01', ARRAY['History 101', 'Political Science 101', 'Sociology 101'], ARRAY[87, 89, 84], ARRAY['politics', 'debate', 'history']),
('Sophia Garcia', 'sophia.g@example.com', '2023-02-10', ARRAY['Math 101', 'Chemistry 101', 'Art 101'], ARRAY[94, 82, 98], ARRAY['painting', 'mathematics', 'design']),
('William Davis', 'william.d@example.com', '2023-02-15', ARRAY['Computer Science 101', 'Computer Science 201', 'Statistics 101'], ARRAY[96, 92, 91], ARRAY['programming', 'data science', 'AI']),
('Olivia Wilson', 'olivia.w@example.com', '2023-03-01', ARRAY['Psychology 101', 'Sociology 101', 'Biology 101'], ARRAY[93, 90, 88], ARRAY['research', 'human behavior', 'animals']),
('James Taylor', 'james.t@example.com', '2023-03-10', ARRAY['Physics 101', 'Math 201', 'Engineering 101'], ARRAY[89, 91, 93], ARRAY['engineering', 'space', 'robotics']),
('Ava Martinez', 'ava.m@example.com', '2023-03-15', ARRAY['English 101', 'Literature 201', 'History 101'], ARRAY[95, 94, 88], ARRAY['writing', 'reading', 'theater']),
('Daniel Anderson', 'daniel.a@example.com', '2023-04-01', ARRAY['Computer Science 101', 'Math 101', 'Physics 101'], ARRAY[90, 87, 85], ARRAY['programming', 'gaming', 'electronics']),
('Isabella Thomas', 'isabella.t@example.com', '2023-04-10', ARRAY['Business 101', 'Economics 101', 'Statistics 101'], ARRAY[92, 91, 89], ARRAY['business', 'finance', 'entrepreneurship']);

-- Exercise 1: Basic Array Operations
-- Write queries to perform the following operations:
-- a. Find all students who are taking 'Math 101'
-- b. Find all students who are interested in 'programming'
-- c. Add a new course 'Physics 201' with grade 90 for James Taylor
-- d. Remove 'gaming' from Daniel Anderson's interests
-- TODO: Write your queries

-- a. Find all students who are taking 'Math 101'
SELECT 
    student_id,
    name
FROM 
    students
WHERE 
    -- Your code here
    'Math 101' = ANY(courses);

-- b. Find all students who are interested in 'programming'
SELECT 
    student_id,
    name
FROM 
    students
WHERE 
    -- Your code here
    interests @> ARRAY['programming'];

-- c. Add a new course 'Physics 201' with grade 90 for James Taylor
UPDATE students
SET 
    -- Your code here
    courses = array_append(courses, 'Physics 201'),
    grades = array_append(grades, 90)
WHERE 
    name = 'James Taylor';

-- d. Remove 'gaming' from Daniel Anderson's interests
UPDATE students
SET 
    -- Your code here
    interests = array_remove(interests, 'gaming')
WHERE 
    name = 'Daniel Anderson';

-- Exercise 2: Array Functions and Aggregation
-- Write queries to:
-- a. List each student with their average grade
-- b. Find the student with the highest grade in 'Computer Science 101'
-- c. Count how many students are taking each course
-- d. Find all unique interests across all students
-- TODO: Write your queries

-- a. List each student with their average grade
SELECT 
    name,
    -- Your code here (calculate average grade)
    (SELECT AVG(g) FROM unnest(grades) AS g) AS average_grade
FROM 
    students
ORDER BY 
    average_grade DESC;

-- b. Find the student with the highest grade in 'Computer Science 101'
SELECT 
    name,
    -- Your code here (extract CS101 grade)
    grades[array_position(courses, 'Computer Science 101')] AS cs101_grade
FROM 
    students
WHERE 
    'Computer Science 101' = ANY(courses)
ORDER BY 
    cs101_grade DESC
LIMIT 1;

-- c. Count how many students are taking each course
SELECT 
    unnest(courses) AS course,
    COUNT(*) AS student_count
FROM 
    students
GROUP BY 
    course
ORDER BY 
    student_count DESC;

-- d. Find all unique interests across all students
SELECT 
    DISTINCT unnest(interests) AS unique_interest
FROM 
    students
ORDER BY 
    unique_interest;

-- Exercise 3: Advanced Array Queries
-- Write queries to:
-- a. Find students who are taking exactly the same courses
-- b. Find students who share at least two interests
-- c. Find students who have improved their grades (last grade is higher than first grade)
-- d. Find students who are taking courses that contain the word "Science"
-- TODO: Write your queries

-- a. Find students who are taking exactly the same courses
SELECT 
    s1.name AS student1,
    s2.name AS student2
FROM 
    students s1
JOIN 
    students s2 ON s1.student_id < s2.student_id
WHERE 
    -- Your code here
    s1.courses @> s2.courses AND s2.courses @> s1.courses;

-- b. Find students who share at least two interests
SELECT 
    s1.name AS student1,
    s2.name AS student2,
    array(
        SELECT unnest(s1.interests)
        INTERSECT
        SELECT unnest(s2.interests)
    ) AS shared_interests
FROM 
    students s1
JOIN 
    students s2 ON s1.student_id < s2.student_id
WHERE 
    -- Your code here
    cardinality(
        array(
            SELECT unnest(s1.interests)
            INTERSECT
            SELECT unnest(s2.interests)
        )
    ) >= 2
ORDER BY 
    student1, student2;

-- c. Find students who have improved their grades (last grade is higher than first grade)
SELECT 
    name,
    grades[1] AS first_grade,
    grades[array_length(grades, 1)] AS last_grade
FROM 
    students
WHERE 
    -- Your code here
    grades[array_length(grades, 1)] > grades[1];

-- d. Find students who are taking courses that contain the word "Science"
SELECT 
    student_id,
    name,
    courses
FROM 
    students
WHERE 
    -- Your code here
    EXISTS (
        SELECT 1
        FROM unnest(courses) AS course
        WHERE course LIKE '%Science%'
    );

-- Exercise 4: Array Manipulation with SQL
-- Write queries to:
-- a. Add 'Data Analysis' as a new interest for all students taking 'Statistics 101'
-- b. Increase all grades by 5 points for courses containing 'Math'
-- c. Create a new array column that combines courses and grades in a format like "Math 101: 92"
-- d. Normalize student interests (convert to lowercase and remove duplicates if any)
-- TODO: Write your queries

-- a. Add 'Data Analysis' as a new interest for all students taking 'Statistics 101'
UPDATE students
SET 
    -- Your code here
    interests = array_append(interests, 'Data Analysis')
WHERE 
    'Statistics 101' = ANY(courses);

-- b. Increase all grades by 5 points for courses containing 'Math'
UPDATE students
SET 
    -- Your code here (this is tricky - you need to update specific array elements)
    grades = array(
        SELECT 
            CASE 
                WHEN courses[i] LIKE '%Math%' THEN grades[i] + 5 
                ELSE grades[i] 
            END
        FROM generate_subscripts(courses, 1) AS s(i)
        ORDER BY i
    )
WHERE 
    EXISTS (
        SELECT 1
        FROM unnest(courses) AS course
        WHERE course LIKE '%Math%'
    );

-- c. Create a new array column that combines courses and grades
SELECT 
    name,
    -- Your code here
    array(
        SELECT courses[i] || ': ' || grades[i]
        FROM generate_subscripts(courses, 1) AS s(i)
        ORDER BY i
    ) AS course_grades
FROM 
    students;

-- d. Normalize student interests (convert to lowercase and remove duplicates)
UPDATE students
SET 
    -- Your code here
    interests = array(
        SELECT DISTINCT lower(interest)
        FROM unnest(interests) AS interest
        ORDER BY lower(interest)
    );

-- Exercise 5: Create a Function for Array Operations
-- Create a function that:
-- a. Takes a student ID and a new course with grade
-- b. Adds the course and grade to the student's arrays
-- c. Ensures no duplicate courses are added
-- d. Returns the updated arrays
-- TODO: Implement the function

CREATE OR REPLACE FUNCTION add_course_to_student(
    p_student_id INTEGER,
    p_course TEXT,
    p_grade INTEGER
)
RETURNS TABLE (
    courses_result TEXT[],
    grades_result INTEGER[]
) AS $$
DECLARE
    v_courses TEXT[];
    v_grades INTEGER[];
BEGIN
    -- Get current courses and grades
    SELECT courses, grades INTO v_courses, v_grades
    FROM students
    WHERE student_id = p_student_id;
    
    -- Check if course already exists
    IF p_course = ANY(v_courses) THEN
        -- Your code here (handle existing course)
        -- Option 1: Do nothing and return existing arrays
        courses_result := v_courses;
        grades_result := v_grades;
    ELSE
        -- Your code here (add new course and grade)
        v_courses := array_append(v_courses, p_course);
        v_grades := array_append(v_grades, p_grade);
        
        -- Update the student record
        UPDATE students
        SET courses = v_courses, grades = v_grades
        WHERE student_id = p_student_id;
        
        courses_result := v_courses;
        grades_result := v_grades;
    END IF;
    
    RETURN NEXT;
END;
$$ LANGUAGE plpgsql;

-- Test your function with:
-- SELECT * FROM add_course_to_student(1, 'Chemistry 201', 88);
-- SELECT * FROM add_course_to_student(1, 'Math 101', 95); -- Should not add duplicate

-- BONUS Exercise: Combining Full-Text Search and Arrays
-- Create a table that stores documents with both text content and tag arrays
-- Implement a search function that allows searching by both content and tags
-- The function should rank results based on both text relevance and tag matches
-- TODO: Implement the table and function

CREATE TABLE documents (
    document_id SERIAL PRIMARY KEY,
    title TEXT NOT NULL,
    content TEXT NOT NULL,
    tags TEXT[],
    search_vector tsvector
);

-- Insert some sample documents
INSERT INTO documents (title, content, tags) VALUES
('PostgreSQL Introduction', 'PostgreSQL is a powerful, open-source object-relational database system.', ARRAY['postgresql', 'database', 'introduction']),
('Array Data Type', 'PostgreSQL arrays allow you to store multiple values of the same type in a single column.', ARRAY['postgresql', 'arrays', 'data types']),
('Full-Text Search Basics', 'PostgreSQL provides full-text search capability to efficiently search text documents.', ARRAY['postgresql', 'search', 'indexing']),
('JSON in PostgreSQL', 'PostgreSQL offers robust support for JSON data, with two JSON data types: json and jsonb.', ARRAY['postgresql', 'json', 'data types']),
('Performance Tuning', 'Optimizing PostgreSQL performance involves proper indexing and query tuning.', ARRAY['postgresql', 'performance', 'optimization']);

-- Update the search_vector
UPDATE documents SET search_vector = to_tsvector('english', title || ' ' || content);

-- Create indexes
CREATE INDEX idx_documents_search ON documents USING GIN (search_vector);
CREATE INDEX idx_documents_tags ON documents USING GIN (tags);

-- Create the combined search function
CREATE OR REPLACE FUNCTION search_documents(
    p_text_query TEXT,
    p_tags TEXT[]
)
RETURNS TABLE (
    document_id INTEGER,
    title TEXT,
    content_snippet TEXT,
    tags TEXT[],
    combined_rank FLOAT
) AS $$
BEGIN
    -- Your code here to implement combined search
    RETURN QUERY
    SELECT
        d.document_id,
        d.title,
        ts_headline('english', d.content, to_tsquery('english', p_text_query), 'MaxWords=30'),
        d.tags,
        (ts_rank(d.search_vector, to_tsquery('english', p_text_query)) * 0.7) + 
        (CASE WHEN d.tags && p_tags THEN
            (array_length(
                array(SELECT unnest(d.tags) INTERSECT SELECT unnest(p_tags)),
                1
            )::float / array_length(p_tags, 1)::float) * 0.3
         ELSE 0 END) AS combined_rank
    FROM
        documents d
    WHERE
        d.search_vector @@ to_tsquery('english', p_text_query) OR
        d.tags && p_tags
    ORDER BY
        combined_rank DESC;
END;
$$ LANGUAGE plpgsql;

-- Test your function with:
-- SELECT * FROM search_documents('postgresql & database', ARRAY['introduction', 'database']);
-- SELECT * FROM search_documents('array | json', ARRAY['data types']);
