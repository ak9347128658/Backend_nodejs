# PostgreSQL Full Text Search

This README provides a guide to using full text search in PostgreSQL. It includes steps to create a table, insert 40 sample records, and perform various types of searches. It also explains the differences between full text search and normal search with examples, and demonstrates direct search types with real-time applications.

## Introduction to Full Text Search

Full text search in PostgreSQL enables efficient searching of natural language text. Unlike traditional search methods, it processes text by tokenizing it into words, applying stemming to match word variations, and ranking results by relevance, making it ideal for large datasets and complex queries.

## Differences Between Full Text Search and Normal Search

Normal search in SQL uses operators like `LIKE` or `ILIKE` for pattern matching:

```sql
SELECT * FROM blog_posts WHERE content LIKE '%database%';
```

This method:
- Matches exact strings, missing variations like "databases" or synonyms.
- Can be slow for large datasets as it often doesn't leverage indexes efficiently.
- Lacks relevance ranking; results are simply matched or not.

Full text search, however, offers:
- **Tokenization**: Splits text into searchable words.
- **Stemming**: Matches word roots (e.g., "running" finds "run").
- **Relevance Ranking**: Orders results by how well they match the query.
- **Index Optimization**: Uses GIN or GiST indexes for speed.

Example of full text search:
```sql
SELECT * FROM blog_posts WHERE to_tsvector('english', content) @@ to_tsquery('english', 'database');
```
This finds "database" and its variations, leveraging stemming and tokenization.

## Setting Up Full Text Search in PostgreSQL

Full text search is built into PostgreSQL (version 8.3+), requiring no additional setup beyond ensuring your database supports your desired language (default is English).

## Creating a Sample Table

Create a `blog_posts` table with `id`, `title`, and `content` columns:

```sql
CREATE TABLE blog_posts (
    id SERIAL PRIMARY KEY,
    title TEXT,
    content TEXT
);
```

## Inserting Sample Data

Insert 40 records into `blog_posts`. Below are a few examples; a full script with 40 records can be adapted as needed:

```sql
INSERT INTO blog_posts (title, content) VALUES
('Introduction to PostgreSQL', 'PostgreSQL is a powerful, open-source relational database system.'),
('Full Text Search Basics', 'Full text search in PostgreSQL allows searching natural language content.'),
('Database Performance Tips', 'Optimizing PostgreSQL databases improves query speed.'),
('Advanced SQL Techniques', 'Learn SQL joins, subqueries, and indexing in PostgreSQL.'),
('Why Use PostgreSQL', 'PostgreSQL offers robust features for developers.');
-- Add 35 more records similarly
```

For brevity, only five are shown. A complete dataset might include varied titles and content about databases, programming, and PostgreSQL features.

## Performing Full Text Searches

### Simple Search
Search for a single word, like "database":

```sql
SELECT * FROM blog_posts
WHERE to_tsvector('english', content) @@ to_tsquery('english', 'database');
```
This matches "database", "databases", etc., due to stemming.

### Phrase Search
Search for an exact phrase, "full text search":

```sql
SELECT * FROM blog_posts
WHERE to_tsvector('english', content) @@ to_tsquery('english', '"full text search"');
```
The quotes ensure the exact phrase is matched.

### Boolean Search
Find posts with "PostgreSQL" and "search" but not "SQL":

```sql
SELECT * FROM blog_posts
WHERE to_tsvector('english', content) @@ to_tsquery('english', 'PostgreSQL & search & !SQL');
```
Operators: `&` (AND), `|` (OR), `!` (NOT).

### Stemming and Language-Specific Search
Search for "running" to match "run", "runs":

```sql
SELECT * FROM blog_posts
WHERE to_tsvector('english', content) @@ to_tsquery('english', 'running');
```

For French content:
```sql
SELECT * FROM blog_posts
WHERE to_tsvector('french', content) @@ to_tsquery('french', 'recherche');
```

### Ranking and Relevance
Rank results for "database performance":

```sql
SELECT *, ts_rank(to_tsvector('english', content), to_tsquery('english', 'database & performance')) AS rank
FROM blog_posts
WHERE to_tsvector('english', content) @@ to_tsquery('english', 'database & performance')
ORDER BY rank DESC;
```
Higher `rank` values indicate greater relevance.

## Using Full Text Search Indexes

Enhance performance with a GIN index:

1. Add a `tsvector` column:
```sql
ALTER TABLE blog_posts ADD COLUMN content_tsv tsvector;
```

2. Populate it:
```sql
UPDATE blog_posts SET content_tsv = to_tsvector('english', content);
```

3. Create the index:
```sql
CREATE INDEX content_tsv_idx ON blog_posts USING GIN(content_tsv);
```

4. Query using the index:
```sql
SELECT * FROM blog_posts
WHERE content_tsv @@ to_tsquery('english', 'database');
```

5. Automate updates with a trigger:
```sql
CREATE FUNCTION update_tsvector() RETURNS trigger AS $$
BEGIN
    NEW.content_tsv := to_tsvector('english', NEW.content);
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER tsvectorupdate BEFORE INSERT OR UPDATE
ON blog_posts FOR EACH ROW EXECUTE PROCEDURE update_tsvector();
```

## Real-Time Examples

### Blog Search
Users search "PostgreSQL performance tips":
```sql
SELECT *, ts_rank(content_tsv, to_tsquery('english', 'PostgreSQL & performance & tips')) AS rank
FROM blog_posts
WHERE content_tsv @@ to_tsquery('english', 'PostgreSQL & performance & tips')
ORDER BY rank DESC;
```
Finds relevant posts, ranked by match quality.

### E-commerce Product Search
Search for "laptop deals":
```sql
SELECT * FROM products
WHERE content_tsv @@ to_tsquery('english', 'laptop & deals');
```
Matches products with "laptop" and "deal" variations.

### Support Knowledge Base
Find articles on "database errors":
```sql
SELECT * FROM support_articles
WHERE content_tsv @@ to_tsquery('english', 'database & errors & !performance');
```
Excludes performance-related articles.

Full text search excels in these scenarios by handling natural language flexibly and efficiently.

# PostgreSQL Full Text Search

This README provides a comprehensive guide to using full text search in PostgreSQL. It includes steps to create a table, insert sample data, and perform various types of searches using operators like `&` (AND), `|` (OR), `!` (NOT), and `*` (wildcard). It also explains the differences between full text search and normal search with examples and demonstrates real-time applications.

## Introduction to Full Text Search

Full text search in PostgreSQL enables efficient searching of natural language text. Unlike traditional search methods, it processes text by tokenizing it into words, applying stemming to match word variations, and ranking results by relevance, making it ideal for large datasets and complex queries.

## Differences Between Full Text Search and Normal Search

Normal search in SQL uses operators like `LIKE` or `ILIKE` for pattern matching:

```sql
SELECT * FROM blog_posts WHERE content LIKE '%database%';
```

This method:
- Matches exact strings, missing variations like "databases" or synonyms.
- Can be slow for large datasets as it often doesn't leverage indexes efficiently.
- Lacks relevance ranking; results are simply matched or not.

Full text search, however, offers:
- **Tokenization**: Splits text into searchable words.
- **Stemming**: Matches word roots (e.g., "running" finds "run").
- **Relevance Ranking**: Orders results by how well they match the query.
- **Index Optimization**: Uses GIN or GiST indexes for speed.

Example of full text search:
```sql
SELECT * FROM blog_posts WHERE to_tsvector('english', content) @@ to_tsquery('english', 'database');
```
This finds "database" and its variations, leveraging stemming and tokenization.

## Setting Up Full Text Search in PostgreSQL

Full text search is built into PostgreSQL (version 8.3+), requiring no additional setup beyond ensuring your database supports your desired language (default is English).

## Creating a Sample Table

Create a `blog_posts` table with `id`, `title`, and `content` columns:

```sql
CREATE TABLE blog_posts (
    id SERIAL PRIMARY KEY,
    title TEXT,
    content TEXT
);
```

## Inserting Sample Data

Insert 40 records into `blog_posts`. Below are a few examples; a full script with 40 records can be adapted as needed:

```sql
INSERT INTO blog_posts (title, content) VALUES
('Introduction to PostgreSQL', 'PostgreSQL is a powerful, open-source relational database system.'),
('Full Text Search Basics', 'Full text search in PostgreSQL allows searching natural language content.'),
('Database Performance Tips', 'Optimizing PostgreSQL databases improves query speed.'),
('Advanced SQL Techniques', 'Learn SQL joins, subqueries, and indexing in PostgreSQL.'),
('Why Use PostgreSQL', 'PostgreSQL offers robust features for developers.');
-- Add 35 more records similarly
```

For brevity, only five are shown. A complete dataset might include varied titles and content about databases, programming, and PostgreSQL features.

## Performing Full Text Searches

### Simple Search
Search for a single word, like "database":

```sql
SELECT * FROM blog_posts
WHERE to_tsvector('english', content) @@ to_tsquery('english', 'database');
```
This matches "database", "databases", etc., due to stemming.

### Phrase Search
Search for an exact phrase, "full text search":

```sql
SELECT * FROM blog_posts
WHERE to_tsvector('english', content) @@ to_tsquery('english', '"full text search"');
```
The quotes ensure the exact phrase is matched.

### Boolean Search Operators
PostgreSQL full text search supports boolean operators for more precise queries:
- `&` (AND): Both terms must be present.
- `|` (OR): At least one of the terms must be present.
- `!` (NOT): The term must not be present.
- `*` (Wildcard): Prefix matching for partial words.

#### Examples:
- **AND Operator (`&`)**: Find posts containing both "PostgreSQL" and "search":
  ```sql
  SELECT * FROM blog_posts
  WHERE to_tsvector('english', content) @@ to_tsquery('english', 'PostgreSQL & search');
  ```

- **OR Operator (`|`)**: Find posts containing either "database" or "SQL":
  ```sql
  SELECT * FROM blog_posts
  WHERE to_tsvector('english', content) @@ to_tsquery('english', 'database | SQL');
  ```

- **NOT Operator (`!`)**: Find posts containing "PostgreSQL" but not "performance":
  ```sql
  SELECT * FROM blog_posts
  WHERE to_tsvector('english', content) @@ to_tsquery('english', 'PostgreSQL & !performance');
  ```

- **Wildcard Operator (`*`)**: Find posts containing words starting with "databas" (e.g., "database", "databases"):
  ```sql
  SELECT * FROM blog_posts
  WHERE to_tsvector('english', content) @@ to_tsquery('english', 'databas:*');
  ```

#### Additional Examples:
- **Multiple ANDs**: Find posts with "PostgreSQL", "search", and "indexing":
  ```sql
  SELECT * FROM blog_posts
  WHERE to_tsvector('english', content) @@ to_tsquery('english', 'PostgreSQL & search & indexing');
  ```

- **Multiple ORs**: Find posts with "database", "SQL", or "query":
  ```sql
  SELECT * FROM blog_posts
  WHERE to_tsvector('english', content) @@ to_tsquery('english', 'database | SQL | query');
  ```

- **Multiple NOTs**: Exclude "performance" and "optimization":
  ```sql
  SELECT * FROM blog_posts
  WHERE to_tsvector('english', content) @@ to_tsquery('english', 'PostgreSQL & !performance & !optimization');
  ```

- **Wildcard with AND**: Find posts with "search" and words starting with "index":
  ```sql
  SELECT * FROM blog_posts
  WHERE to_tsvector('english', content) @@ to_tsquery('english', 'search & index:*');
  ```

### Combining Operators
You can combine operators for complex queries:
- Find posts with "database" or "SQL" but not "performance":
  ```sql
  SELECT * FROM blog_posts
  WHERE to_tsvector('english', content) @@ to_tsquery('english', '(database | SQL) & !performance');
  ```

- Find posts with "PostgreSQL" and either "search" or "query", excluding "tips":
  ```sql
  SELECT * FROM blog_posts
  WHERE to_tsvector('english', content) @@ to_tsquery('english', 'PostgreSQL & (search | query) & !tips');
  ```

- Find posts with words starting with "data" and "SQL", but not "performance":
  ```sql
  SELECT * FROM blog_posts
  WHERE to_tsvector('english', content) @@ to_tsquery('english', 'data:* & SQL & !performance');
  ```

### Stemming and Language-Specific Search
Search for "running" to match "run", "runs":
```sql
SELECT * FROM blog_posts
WHERE to_tsvector('english', content) @@ to_tsquery('english', 'running');
```

For French content:
```sql
SELECT * FROM blog_posts
WHERE to_tsvector('french', content) @@ to_tsquery('french', 'recherche');
```

### Ranking and Relevance
Rank results for "database performance":
```sql
SELECT *, ts_rank(to_tsvector('english', content), to_tsquery('english', 'database & performance')) AS rank
FROM blog_posts
WHERE to_tsvector('english', content) @@ to_tsquery('english', 'database & performance')
ORDER BY rank DESC;
```
Higher `rank` values indicate greater relevance.

## Using Full Text Search Indexes

Enhance performance with a GIN index:

1. Add a `tsvector` column:
```sql
ALTER TABLE blog_posts ADD COLUMN content_tsv tsvector;
```

2. Populate it:
```sql
UPDATE blog_posts SET content_tsv = to_tsvector('english', content);
```

3. Create the index:
```sql
CREATE INDEX content_tsv_idx ON blog_posts USING GIN(content_tsv);
```

4. Query using the index:
```sql
SELECT * FROM blog_posts
WHERE content_tsv @@ to_tsquery('english', 'database');
```

5. Automate updates with a trigger:
```sql
CREATE FUNCTION update_tsvector() RETURNS trigger AS $$
BEGIN
    NEW.content_tsv := to_tsvector('english', NEW.content);
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER tsvectorupdate BEFORE INSERT OR UPDATE
ON blog_posts FOR EACH ROW EXECUTE PROCEDURE update_tsvector();
```

## Real-Time Examples

### Blog Search
Users search for "PostgreSQL performance tips":
```sql
SELECT *, ts_rank(content_tsv, to_tsquery('english', 'PostgreSQL & performance & tips')) AS rank
FROM blog_posts
WHERE content_tsv @@ to_tsquery('english', 'PostgreSQL & performance & tips')
ORDER BY rank DESC;
```
Finds relevant posts, ranked by match quality.

#### Excluding Terms
Find blog posts about "PostgreSQL" but not "performance" or "tips":
```sql
SELECT * FROM blog_posts
WHERE content_tsv @@ to_tsquery('english', 'PostgreSQL & !performance & !tips');
```

### E-commerce Product Search
Search for "laptop deals":
```sql
SELECT * FROM products
WHERE content_tsv @@ to_tsquery('english', 'laptop & deals');
```

#### OR Operator in Product Search
Find products related to "database", "SQL", or "software":
```sql
SELECT * FROM products
WHERE content_tsv @@ to_tsquery('english', 'database | SQL | software');
```

### Support Knowledge Base
Find articles on "database errors" excluding "performance":
```sql
SELECT * FROM support_articles
WHERE content_tsv @@ to_tsquery('english', 'database & errors & !performance');
```

#### Wildcard Search
Find articles mentioning words starting with "error":
```sql
SELECT * FROM support_articles
WHERE content_tsv @@ to_tsquery('english', 'error:*');
```

Full text search excels in these scenarios by handling natural language flexibly and efficiently, especially with the use of boolean and wildcard operators.