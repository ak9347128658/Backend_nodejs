-- Day 4: Performance Tuning and Optimization - Examples

-- Example 1: Using EXPLAIN and EXPLAIN ANALYZE
EXPLAIN SELECT * FROM products WHERE price > 100;
EXPLAIN ANALYZE SELECT * FROM products WHERE price > 100;

-- Example 2: Creating and Using Indexes
CREATE INDEX idx_products_price ON products(price);
EXPLAIN SELECT * FROM products WHERE price > 100;

-- Example 3: Index Types
CREATE INDEX idx_products_name_btree ON products USING btree(name);
CREATE INDEX idx_products_name_hash ON products USING hash(name);
CREATE INDEX idx_products_tags_gin ON products USING gin(tags);
CREATE INDEX idx_products_location_gist ON products USING gist(location);
CREATE INDEX idx_products_date_brin ON products USING brin(created_at);

-- Example 4: Vacuum and Analyze
VACUUM products;
ANALYZE products;

-- Example 5: Configuration Tuning (conceptual)
-- SET work_mem = '64MB';
-- SET shared_buffers = '256MB';

-- Example 6: Monitoring
SELECT * FROM pg_stat_activity;
SELECT * FROM pg_stat_statements ORDER BY total_exec_time DESC LIMIT 5;

-- Example 7: Logging Slow Queries
-- In postgresql.conf:
-- log_min_duration_statement = 1000  -- log queries slower than 1s
