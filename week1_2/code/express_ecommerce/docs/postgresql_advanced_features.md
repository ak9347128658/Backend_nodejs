# PostgreSQL Advanced Features: Full-Text Search and JSON

This document covers how to leverage PostgreSQL's advanced features like full-text search and JSON capabilities in your Express.js e-commerce application.

## 🔍 Full-Text Search

### Overview

PostgreSQL's full-text search provides a sophisticated mechanism to search through textual content. Unlike basic `LIKE` or regular expression searches, full-text search in PostgreSQL:

- Is language-aware (understands stemming, stop words)
- Supports ranking of search results
- Offers indexing for better performance
- Handles normalization (case, accent insensitivity)

### Setting Up Full-Text Search

#### 1. Creating Text Search Configurations

```sql
-- Use default english dictionary
SELECT cfgname FROM pg_ts_config;

-- For most e-commerce applications, the 'english' configuration works well
-- However, you can create custom configurations if needed
```

#### 2. Adding Search Vectors to Tables

```sql
-- Add a tsvector column to your products table
ALTER TABLE products 
ADD COLUMN search_vector tsvector;

-- Create a function to update the search vector
CREATE FUNCTION products_search_vector_update() RETURNS trigger AS $$
BEGIN
  NEW.search_vector :=
    setweight(to_tsvector('english', coalesce(NEW.name, '')), 'A') ||
    setweight(to_tsvector('english', coalesce(NEW.description, '')), 'B') ||
    setweight(to_tsvector('english', coalesce(NEW.category, '')), 'C');
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Create a trigger to automatically update the search vector
CREATE TRIGGER products_search_vector_update
BEFORE INSERT OR UPDATE ON products
FOR EACH ROW EXECUTE PROCEDURE products_search_vector_update();

-- Update existing products
UPDATE products SET search_vector = 
  setweight(to_tsvector('english', name), 'A') ||
  setweight(to_tsvector('english', description), 'B') ||
  setweight(to_tsvector('english', category), 'C');

-- Create a GIN index for the search vector for better performance
CREATE INDEX products_search_idx ON products USING GIN(search_vector);
```

#### 3. Implementing Search Queries

```javascript
// In models/productQueries.js

const searchProducts = async (searchQuery) => {
  const query = `
    SELECT id, name, description, price, category, image_url,
           ts_rank(search_vector, plainto_tsquery('english', $1)) AS rank
    FROM products
    WHERE search_vector @@ plainto_tsquery('english', $1)
    ORDER BY rank DESC
    LIMIT 20;
  `;
  
  try {
    const result = await pool.query(query, [searchQuery]);
    return result.rows;
  } catch (error) {
    throw error;
  }
};

// You can also use phraseto_tsquery for exact phrase matches
// or websearch_to_tsquery for Google-like syntax
```

#### 4. Creating Search API Endpoint

```javascript
// In controllers/productController.js

const searchProducts = async (req, res, next) => {
  try {
    const { query } = req.query;
    
    if (!query || query.trim() === '') {
      return res.status(400).json({
        status: 'error',
        message: 'Search query is required'
      });
    }
    
    const results = await productQueries.searchProducts(query);
    
    res.status(200).json({
      status: 'success',
      data: results,
      count: results.length
    });
    
  } catch (error) {
    next(error);
  }
};

// In routes/productRoutes.js
router.get('/search', productController.searchProducts);
```

### Advanced Full-Text Search Features

#### Highlighting Search Results

```javascript
const searchProductsWithHighlight = async (searchQuery) => {
  const query = `
    SELECT id, name, description, price, category, image_url,
           ts_rank(search_vector, to_tsquery('english', $1)) AS rank,
           ts_headline('english', description, to_tsquery('english', $1), 
                      'StartSel=<mark>, StopSel=</mark>, MaxFragments=3, MaxWords=20') AS highlighted_description
    FROM products
    WHERE search_vector @@ to_tsquery('english', $1)
    ORDER BY rank DESC
    LIMIT 20;
  `;
  
  try {
    // Convert spaces to & for AND logic in tsquery
    const formattedQuery = searchQuery.trim().split(/\s+/).join(' & ');
    const result = await pool.query(query, [formattedQuery]);
    return result.rows;
  } catch (error) {
    throw error;
  }
};
```

#### Fuzzy Search with Trigram Similarity

```sql
-- First, install the pg_trgm extension
CREATE EXTENSION IF NOT EXISTS pg_trgm;

-- Add a GIN index for trigram search on the name column
CREATE INDEX products_name_trigram_idx ON products USING GIN (name gin_trgm_ops);
```

```javascript
// In models/productQueries.js
const fuzzySearch = async (searchTerm) => {
  const query = `
    SELECT id, name, description, price, category, image_url,
           similarity(name, $1) AS sim
    FROM products
    WHERE name % $1
    ORDER BY sim DESC
    LIMIT 10;
  `;
  
  try {
    const result = await pool.query(query, [searchTerm]);
    return result.rows;
  } catch (error) {
    throw error;
  }
};
```

## 📋 JSON Capabilities

### Overview

PostgreSQL provides robust support for JSON data types (both `JSON` and `JSONB`), which allows you to:

- Store semi-structured data
- Query and manipulate JSON data directly in the database
- Combine relational and document-oriented approaches
- Create more flexible schemas

The `JSONB` type is generally preferred as it's more efficient and supports indexing.

### Setting Up JSON Columns

#### 1. Creating Tables with JSON Columns

```sql
-- For storing product attributes that might vary by category
ALTER TABLE products ADD COLUMN attributes JSONB;

-- For storing customer preferences
CREATE TABLE user_preferences (
  user_id INTEGER REFERENCES users(id),
  preferences JSONB NOT NULL DEFAULT '{}',
  PRIMARY KEY (user_id)
);
```

#### 2. Creating Indexes for JSON

```sql
-- Create a GIN index for efficient querying of JSON data
CREATE INDEX idx_product_attributes ON products USING GIN (attributes);

-- For specific JSON key indexing
CREATE INDEX idx_product_color ON products USING GIN ((attributes->>'color'));
```

### Using JSON in Queries

#### 1. Inserting JSON Data

```javascript
// In models/productQueries.js
const addProduct = async (name, description, price, category, imageUrl, attributes) => {
  const query = `
    INSERT INTO products (name, description, price, category, image_url, attributes)
    VALUES ($1, $2, $3, $4, $5, $6)
    RETURNING *;
  `;
  
  try {
    const result = await pool.query(query, [name, description, price, category, imageUrl, attributes]);
    return result.rows[0];
  } catch (error) {
    throw error;
  }
};

// Usage example
const productAttributes = {
  color: "red",
  size: "XL",
  weight: "150g",
  material: "cotton",
  features: ["waterproof", "breathable"]
};

const newProduct = await addProduct(
  "Hiking Shirt",
  "A comfortable shirt for hiking",
  29.99,
  "Clothing",
  "/uploads/hiking-shirt.jpg",
  productAttributes
);
```

#### 2. Querying JSON Data

```javascript
// Finding products with specific attributes
const findProductsByAttribute = async (key, value) => {
  const query = `
    SELECT *
    FROM products
    WHERE attributes->>$1 = $2;
  `;
  
  try {
    const result = await pool.query(query, [key, value]);
    return result.rows;
  } catch (error) {
    throw error;
  }
};

// Finding products with a specific feature in an array
const findProductsByFeature = async (feature) => {
  const query = `
    SELECT *
    FROM products
    WHERE attributes->'features' ? $1;
  `;
  
  try {
    const result = await pool.query(query, [feature]);
    return result.rows;
  } catch (error) {
    throw error;
  }
};
```

#### 3. Updating JSON Data

```javascript
// Adding or updating a specific attribute
const updateProductAttribute = async (productId, key, value) => {
  const query = `
    UPDATE products
    SET attributes = jsonb_set(attributes, $2, $3, true)
    WHERE id = $1
    RETURNING *;
  `;
  
  try {
    // Convert key to path array format
    const path = `{${key}}`;
    // Convert value to JSON string
    const jsonValue = JSON.stringify(value);
    
    const result = await pool.query(query, [productId, path, jsonValue]);
    return result.rows[0];
  } catch (error) {
    throw error;
  }
};
```

### Practical Applications in E-commerce

#### 1. Product Variants

```javascript
// Store product variants in a JSONB array
const createProductWithVariants = async (productData, variants) => {
  const query = `
    INSERT INTO products (
      name, description, price, category, image_url, attributes, variants
    )
    VALUES ($1, $2, $3, $4, $5, $6, $7)
    RETURNING *;
  `;
  
  try {
    const { name, description, basePrice, category, imageUrl, attributes } = productData;
    const result = await pool.query(query, [
      name, description, basePrice, category, imageUrl, attributes, JSON.stringify(variants)
    ]);
    return result.rows[0];
  } catch (error) {
    throw error;
  }
};

// Example usage
const variants = [
  { 
    sku: "TS-RED-S", 
    color: "Red", 
    size: "S", 
    price: 19.99, 
    stock: 10 
  },
  { 
    sku: "TS-RED-M", 
    color: "Red", 
    size: "M", 
    price: 19.99, 
    stock: 15 
  },
  { 
    sku: "TS-BLU-S", 
    color: "Blue", 
    size: "S", 
    price: 21.99, 
    stock: 8 
  }
];
```

#### 2. Order History with JSON

```javascript
// Storing order snapshots for historical reference
const createOrder = async (userId, items, shippingAddress, paymentDetails) => {
  const query = `
    INSERT INTO orders (
      user_id, 
      order_items, 
      shipping_address, 
      payment_details,
      order_status
    )
    VALUES ($1, $2, $3, $4, 'pending')
    RETURNING *;
  `;
  
  try {
    // Store complete item information to preserve historical data
    // even if product details change later
    const result = await pool.query(query, [
      userId, 
      JSON.stringify(items), 
      JSON.stringify(shippingAddress), 
      JSON.stringify(paymentDetails)
    ]);
    return result.rows[0];
  } catch (error) {
    throw error;
  }
};
```

#### 3. User Preferences and Settings

```javascript
// Saving user preferences as flexible JSON
const updateUserPreferences = async (userId, preferences) => {
  const query = `
    INSERT INTO user_preferences (user_id, preferences)
    VALUES ($1, $2)
    ON CONFLICT (user_id) 
    DO UPDATE SET preferences = user_preferences.preferences || $2
    RETURNING *;
  `;
  
  try {
    const result = await pool.query(query, [userId, preferences]);
    return result.rows[0];
  } catch (error) {
    throw error;
  }
};

// Example usage
await updateUserPreferences(userId, {
  theme: "dark",
  newsletter: true,
  productRecommendations: {
    enabled: true,
    categories: ["electronics", "books"]
  }
});
```

## 🔄 Combining Full-Text Search and JSON

You can combine both features for powerful search capabilities:

```javascript
const searchProductsWithFilters = async (searchQuery, filters) => {
  let queryText = `
    SELECT id, name, description, price, category, image_url
    FROM products
    WHERE search_vector @@ plainto_tsquery('english', $1)
  `;
  
  const queryParams = [searchQuery];
  let paramCounter = 2;
  
  // Add dynamic filters based on JSON attributes
  if (filters && Object.keys(filters).length > 0) {
    for (const [key, value] of Object.entries(filters)) {
      queryText += ` AND attributes->>$${paramCounter} = $${paramCounter + 1}`;
      queryParams.push(key, value);
      paramCounter += 2;
    }
  }
  
  queryText += ` ORDER BY ts_rank(search_vector, plainto_tsquery('english', $1)) DESC LIMIT 20`;
  
  try {
    const result = await pool.query(queryText, queryParams);
    return result.rows;
  } catch (error) {
    throw error;
  }
};

// Example usage
const results = await searchProductsWithFilters("hiking shirt", { 
  color: "red", 
  size: "XL" 
});
```

## 🚀 Implementation Guide

1. **Choose the right data type**:
   - Use `JSONB` instead of `JSON` for better performance and indexing
   - Use dedicated columns for frequently accessed data, JSON for variable attributes

2. **Indexing strategy**:
   - Use GIN indexes for JSONB columns that will be queried often
   - Create specific indexes for common search paths within JSON

3. **Consider schema evolution**:
   - JSON fields allow easy addition of new attributes without schema changes
   - Document your JSON structures to maintain consistency

4. **Performance considerations**:
   - Monitor query performance, especially with large JSON documents
   - Consider denormalizing critical data for faster access
   - Use proper indexing for both full-text search and JSON fields

## 📝 Best Practices

1. **Validation**: Validate JSON data structure in your application before storing it

2. **Security**: Be careful with user-provided JSON to prevent injection attacks

3. **Balance**: Find the right balance between relational structure and flexible JSON

4. **Documentation**: Document your JSON schema design decisions

5. **Error handling**: Implement robust error handling for JSON parsing and operations

## 📚 Resources

- [PostgreSQL Full Text Search](https://www.postgresql.org/docs/current/textsearch.html)
- [PostgreSQL JSON Functions](https://www.postgresql.org/docs/current/functions-json.html)
- [PostgreSQL JSONB Type](https://www.postgresql.org/docs/current/datatype-json.html)

## 🔄 Next Steps

To implement these features in your Express.js e-commerce application:

1. Update your database schema to include search vectors and JSON columns
2. Create new model functions to leverage these features
3. Add API endpoints that expose the advanced search capabilities
4. Update your frontend to take advantage of the new search features
