-- Day 5: Final Project and Review - Example Review Queries

-- Example 1: Complex Join
SELECT s.name, c.title, e.enrolled_on
FROM students s
JOIN enrollments e ON s.student_id = e.student_id
JOIN courses c ON e.course_id = c.course_id;

-- Example 2: Aggregation and Grouping
SELECT c.title, COUNT(e.enrollment_id) AS num_students
FROM courses c
LEFT JOIN enrollments e ON c.course_id = e.course_id
GROUP BY c.title;

-- Example 3: Window Function
SELECT name, grade, AVG(grade) OVER (PARTITION BY course_id) AS avg_grade
FROM grades;

-- Example 4: JSON Data
SELECT id, data->'profile'->>'email' AS email
FROM users_json;

-- Example 5: Full-Text Search
SELECT * FROM articles WHERE to_tsvector(title || ' ' || body) @@ plainto_tsquery('PostgreSQL');

-- Example 6: Partitioned Table Query
SELECT * FROM sales WHERE sale_date BETWEEN '2023-01-01' AND '2023-12-31';

-- Example 7: RLS Policy Example
ALTER TABLE confidential_data ENABLE ROW LEVEL SECURITY;
CREATE POLICY user_policy ON confidential_data USING (owner = current_user);
