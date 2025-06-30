# Promises and Async/Await in Node.js

## Introduction

Asynchronous programming is a fundamental concept in Node.js. It allows your code to execute non-blocking operations, making your applications more efficient and responsive. Two modern approaches to handle asynchronous operations in Node.js are Promises and the async/await syntax. This document explains these concepts with practical examples.

## Understanding Promises

A Promise is an object representing the eventual completion or failure of an asynchronous operation. It's essentially a placeholder for a value that will be available later.

### Promise States

A Promise can be in one of three states:
- **Pending**: The initial state. The Promise's outcome hasn't yet been determined.
- **Fulfilled**: The operation completed successfully, and the Promise has a resulting value.
- **Rejected**: The operation failed, and the Promise has a reason for the failure.

### Creating Promises

```javascript
// Creating a basic Promise
const myPromise = new Promise((resolve, reject) => {
  // Asynchronous operation
  const success = true;
  
  if (success) {
    resolve('Operation completed successfully!');
  } else {
    reject(new Error('Operation failed!'));
  }
});
```

### Using Promises

```javascript
// Consuming a Promise
myPromise
  .then(result => {
    console.log('Success:', result);
  })
  .catch(error => {
    console.error('Error:', error);
  })
  .finally(() => {
    console.log('Promise completed (successfully or not)');
  });
```

### Promise Chaining

Promises can be chained to execute a sequence of asynchronous operations:

```javascript
function getUserData(userId) {
  return new Promise((resolve, reject) => {
    // Simulate fetching user data
    setTimeout(() => {
      resolve({ id: userId, name: 'John Doe' });
    }, 1000);
  });
}

function getUserPosts(user) {
  return new Promise((resolve, reject) => {
    // Simulate fetching user posts
    setTimeout(() => {
      resolve({
        user: user,
        posts: [
          { id: 1, title: 'First Post' },
          { id: 2, title: 'Second Post' }
        ]
      });
    }, 1000);
  });
}

// Chain promises
getUserData(123)
  .then(user => {
    console.log('User data:', user);
    return getUserPosts(user);
  })
  .then(result => {
    console.log('User posts:', result.posts);
  })
  .catch(error => {
    console.error('Error:', error);
  });
```

### Promise.all - Parallel Execution

When you need to run multiple promises concurrently and wait for all of them to complete:

```javascript
const promise1 = new Promise(resolve => setTimeout(() => resolve('Result 1'), 1000));
const promise2 = new Promise(resolve => setTimeout(() => resolve('Result 2'), 2000));
const promise3 = new Promise(resolve => setTimeout(() => resolve('Result 3'), 1500));

Promise.all([promise1, promise2, promise3])
  .then(results => {
    console.log('All promises completed!');
    console.log(results); // ['Result 1', 'Result 2', 'Result 3']
  })
  .catch(error => {
    console.error('At least one promise rejected:', error);
  });
```

### Promise.race - First to Complete

When you need only the result of the first promise to resolve:

```javascript
const promise1 = new Promise(resolve => setTimeout(() => resolve('Result 1'), 1000));
const promise2 = new Promise(resolve => setTimeout(() => resolve('Result 2'), 500));
const promise3 = new Promise(resolve => setTimeout(() => resolve('Result 3'), 1500));

Promise.race([promise1, promise2, promise3])
  .then(result => {
    console.log('First promise completed!');
    console.log(result); // 'Result 2' (because it's the fastest)
  })
  .catch(error => {
    console.error('First promise to complete was rejected:', error);
  });
```

### Promise.allSettled - All Results Regardless of Outcome

When you want to get all results regardless of whether they were fulfilled or rejected:

```javascript
const promise1 = Promise.resolve('Success 1');
const promise2 = Promise.reject('Error 2');
const promise3 = Promise.resolve('Success 3');

Promise.allSettled([promise1, promise2, promise3])
  .then(results => {
    console.log('All promises settled!');
    results.forEach((result, index) => {
      if (result.status === 'fulfilled') {
        console.log(`Promise ${index + 1} fulfilled with value:`, result.value);
      } else {
        console.log(`Promise ${index + 1} rejected with reason:`, result.reason);
      }
    });
  });
```

## Understanding Async/Await

Async/await is a syntactic sugar built on top of Promises, making asynchronous code look and behave more like synchronous code while maintaining its non-blocking benefits.

### Basic Syntax

```javascript
// Function declaration with async keyword
async function myAsyncFunction() {
  // Use await to wait for a Promise to resolve
  const result = await somePromiseReturningFunction();
  return result;
}

// Async function expressions
const myAsyncArrowFunction = async () => {
  const result = await somePromiseReturningFunction();
  return result;
};
```

### Error Handling

```javascript
async function fetchData() {
  try {
    const data = await fetch('https://api.example.com/data');
    const json = await data.json();
    return json;
  } catch (error) {
    console.error('Error fetching data:', error);
    throw error; // Re-throw or handle as needed
  }
}
```

### Converting the Promise Chain Example

Let's rewrite the earlier Promise chain example using async/await:

```javascript
async function getUserDataWithPosts(userId) {
  try {
    // Each await expression waits for the Promise to resolve
    const user = await getUserData(userId);
    console.log('User data:', user);
    
    const result = await getUserPosts(user);
    console.log('User posts:', result.posts);
    
    return result;
  } catch (error) {
    console.error('Error:', error);
    throw error;
  }
}

// Call the async function
getUserDataWithPosts(123)
  .then(result => {
    console.log('Function completed successfully');
  })
  .catch(error => {
    console.error('Function failed:', error);
  });
```

### Working with Promise.all Using Async/Await

```javascript
async function fetchAllData() {
  try {
    const promise1 = fetch('https://api.example.com/data1');
    const promise2 = fetch('https://api.example.com/data2');
    const promise3 = fetch('https://api.example.com/data3');
    
    // Wait for all promises to resolve
    const [response1, response2, response3] = await Promise.all([promise1, promise2, promise3]);
    
    // Process results
    const data1 = await response1.json();
    const data2 = await response2.json();
    const data3 = await response3.json();
    
    return [data1, data2, data3];
  } catch (error) {
    console.error('Error fetching data:', error);
    throw error;
  }
}
```

## Real-World Examples

### Example 1: Reading and Processing a File

```javascript
const fs = require('fs').promises;

// Using Promises
function processFileWithPromises(filePath) {
  return fs.readFile(filePath, 'utf8')
    .then(data => {
      const lines = data.split('\n');
      const wordCount = data.split(/\s+/).length;
      return {
        lineCount: lines.length,
        wordCount: wordCount,
        characterCount: data.length
      };
    })
    .catch(error => {
      console.error('Error processing file:', error);
      throw error;
    });
}

// Using Async/Await
async function processFileWithAsyncAwait(filePath) {
  try {
    const data = await fs.readFile(filePath, 'utf8');
    const lines = data.split('\n');
    const wordCount = data.split(/\s+/).length;
    
    return {
      lineCount: lines.length,
      wordCount: wordCount,
      characterCount: data.length
    };
  } catch (error) {
    console.error('Error processing file:', error);
    throw error;
  }
}
```

### Example 2: API Data Fetching and Transformation

```javascript
const axios = require('axios');

// Using Promises
function fetchUserDataWithPromises(userId) {
  return axios.get(`https://api.example.com/users/${userId}`)
    .then(response => {
      const user = response.data;
      return axios.get(`https://api.example.com/users/${userId}/posts`);
    })
    .then(response => {
      const posts = response.data;
      return posts.map(post => ({
        id: post.id,
        title: post.title,
        summary: post.body.substring(0, 100) + '...'
      }));
    })
    .catch(error => {
      console.error('API Error:', error.message);
      throw error;
    });
}

// Using Async/Await
async function fetchUserDataWithAsyncAwait(userId) {
  try {
    const userResponse = await axios.get(`https://api.example.com/users/${userId}`);
    const user = userResponse.data;
    
    const postsResponse = await axios.get(`https://api.example.com/users/${userId}/posts`);
    const posts = postsResponse.data;
    
    return posts.map(post => ({
      id: post.id,
      title: post.title,
      summary: post.body.substring(0, 100) + '...'
    }));
  } catch (error) {
    console.error('API Error:', error.message);
    throw error;
  }
}
```

### Example 3: Database Operations

```javascript
const { Pool } = require('pg');
const pool = new Pool({
  // database connection config
});

// Using Promises
function getUserWithOrders(userId) {
  let userData;
  
  return pool.query('SELECT * FROM users WHERE id = $1', [userId])
    .then(result => {
      if (result.rows.length === 0) {
        throw new Error('User not found');
      }
      
      userData = result.rows[0];
      return pool.query('SELECT * FROM orders WHERE user_id = $1', [userId]);
    })
    .then(result => {
      return {
        user: userData,
        orders: result.rows
      };
    })
    .catch(error => {
      console.error('Database error:', error);
      throw error;
    });
}

// Using Async/Await
async function getUserWithOrdersAsync(userId) {
  const client = await pool.connect();
  
  try {
    // Begin transaction
    await client.query('BEGIN');
    
    const userResult = await client.query('SELECT * FROM users WHERE id = $1', [userId]);
    if (userResult.rows.length === 0) {
      throw new Error('User not found');
    }
    
    const userData = userResult.rows[0];
    const ordersResult = await client.query('SELECT * FROM orders WHERE user_id = $1', [userId]);
    
    // Commit transaction
    await client.query('COMMIT');
    
    return {
      user: userData,
      orders: ordersResult.rows
    };
  } catch (error) {
    // Rollback transaction on error
    await client.query('ROLLBACK');
    console.error('Database error:', error);
    throw error;
  } finally {
    // Release client back to pool
    client.release();
  }
}
```

## Advanced Patterns

### Sequential vs Parallel Execution

**Sequential Execution (One after another):**

```javascript
async function processSequentially(items) {
  const results = [];
  
  for (const item of items) {
    // Each operation waits for the previous one to complete
    const result = await processItem(item);
    results.push(result);
  }
  
  return results;
}
```

**Parallel Execution (All at once):**

```javascript
async function processInParallel(items) {
  // Create an array of promises
  const promises = items.map(item => processItem(item));
  
  // Wait for all promises to resolve
  const results = await Promise.all(promises);
  return results;
}
```

**Controlled Parallel Execution (Limited concurrency):**

```javascript
async function processWithLimitedConcurrency(items, concurrencyLimit) {
  const results = [];
  const running = new Set();
  
  for (const item of items) {
    const promise = processItem(item)
      .then(result => {
        running.delete(promise);
        return result;
      });
    
    running.add(promise);
    results.push(promise);
    
    if (running.size >= concurrencyLimit) {
      // Wait for one task to complete before continuing
      await Promise.race(running);
    }
  }
  
  // Wait for all remaining tasks
  return Promise.all(results);
}
```

### Timeouts for Promises

```javascript
function promiseWithTimeout(promise, timeoutMs) {
  // Create a promise that rejects after timeoutMs
  const timeoutPromise = new Promise((_, reject) => {
    setTimeout(() => {
      reject(new Error(`Operation timed out after ${timeoutMs} ms`));
    }, timeoutMs);
  });
  
  // Race the original promise against the timeout
  return Promise.race([promise, timeoutPromise]);
}

// Usage
async function fetchWithTimeout(url, timeout = 5000) {
  try {
    const response = await promiseWithTimeout(fetch(url), timeout);
    return await response.json();
  } catch (error) {
    if (error.message.includes('timed out')) {
      console.error('Request timed out');
    } else {
      console.error('Error during fetch:', error);
    }
    throw error;
  }
}
```

### Retry Mechanism

```javascript
async function fetchWithRetry(url, options = {}, maxRetries = 3, delay = 1000) {
  let lastError;
  
  for (let attempt = 1; attempt <= maxRetries; attempt++) {
    try {
      return await fetch(url, options);
    } catch (error) {
      console.warn(`Attempt ${attempt} failed:`, error.message);
      lastError = error;
      
      if (attempt < maxRetries) {
        // Wait before next retry with exponential backoff
        const waitTime = delay * Math.pow(2, attempt - 1);
        console.log(`Waiting ${waitTime}ms before retry...`);
        await new Promise(resolve => setTimeout(resolve, waitTime));
      }
    }
  }
  
  throw new Error(`All ${maxRetries} attempts failed. Last error: ${lastError.message}`);
}
```

## Common Pitfalls and Best Practices

### Common Mistakes

1. **Forgetting to handle errors:**

   ```javascript
   // Bad - no error handling
   async function riskyFunction() {
     const data = await fetchData();
     return processData(data);
   }
   
   // Good - with error handling
   async function safeFunction() {
     try {
       const data = await fetchData();
       return processData(data);
     } catch (error) {
       console.error('Error in safeFunction:', error);
       throw error;
     }
   }
   ```

2. **Forgetting that async functions always return Promises:**

   ```javascript
   // Incorrect - not waiting for the async function to complete
   function processUserData() {
     const userData = getUserData(); // Returns a Promise, not the actual data
     console.log(userData); // Will log a Promise object, not the user data
   }
   
   // Correct
   async function processUserData() {
     const userData = await getUserData();
     console.log(userData); // Logs the actual user data
   }
   
   // Also correct (without using async/await)
   function processUserData() {
     getUserData().then(userData => {
       console.log(userData); // Logs the actual user data
     });
   }
   ```

3. **Using await outside an async function:**

   ```javascript
   // Will cause a syntax error
   function someFunction() {
     const data = await fetchData(); // Error: await is only valid in async functions
   }
   
   // Correct
   async function someFunction() {
     const data = await fetchData();
   }
   ```

4. **Losing error stack traces:**

   ```javascript
   // Bad - error stack trace is lost
   async function outerFunction() {
     try {
       await innerFunction();
     } catch (error) {
       throw new Error('Something went wrong'); // Original stack trace is lost
     }
   }
   
   // Good - preserving stack trace
   async function outerFunction() {
     try {
       await innerFunction();
     } catch (error) {
       error.message = 'Outer context: ' + error.message;
       throw error; // Original stack trace is preserved
     }
   }
   ```

### Best Practices

1. **Properly handle promise rejections:**

   ```javascript
   // For async/await functions
   async function example() {
     try {
       // Your code here
     } catch (error) {
       // Handle or log the error
     }
   }
   
   // For promise chains
   promiseFunction()
     .then(result => {
       // Handle result
     })
     .catch(error => {
       // Handle error
     });
   
   // For top-level unhandled rejections
   process.on('unhandledRejection', (reason, promise) => {
     console.error('Unhandled Rejection at:', promise, 'reason:', reason);
     // Application specific logging, throwing an error, or other logic here
   });
   ```

2. **Avoid mixing callbacks and promises:**

   ```javascript
   // Avoid this mixed approach
   function mixedFunction() {
     return new Promise((resolve, reject) => {
       someCallbackFunction((err, result) => {
         if (err) {
           return reject(err);
         }
         
         someOtherPromiseFunction()
           .then(data => {
             resolve({ result, data });
           })
           .catch(reject);
       });
     });
   }
   
   // Better: use util.promisify for callback-based functions
   const util = require('util');
   const someCallbackFunctionPromise = util.promisify(someCallbackFunction);
   
   async function cleanerFunction() {
     const result = await someCallbackFunctionPromise();
     const data = await someOtherPromiseFunction();
     return { result, data };
   }
   ```

3. **Use Promise.all for concurrent operations:**

   ```javascript
   // Run tasks in parallel when possible
   async function fetchMultipleResources() {
     try {
       const [users, posts, comments] = await Promise.all([
         fetchUsers(),
         fetchPosts(),
         fetchComments()
       ]);
       
       return { users, posts, comments };
     } catch (error) {
       console.error('Error fetching resources:', error);
       throw error;
     }
   }
   ```

4. **Create reusable async utilities:**

   ```javascript
   // Reusable retry function
   async function withRetry(fn, options = {}) {
     const { maxRetries = 3, delay = 1000, onRetry = () => {} } = options;
     let lastError;
     
     for (let attempt = 1; attempt <= maxRetries; attempt++) {
       try {
         return await fn();
       } catch (error) {
         lastError = error;
         onRetry(error, attempt);
         
         if (attempt < maxRetries) {
           await new Promise(resolve => setTimeout(resolve, delay));
         }
       }
     }
     
     throw lastError;
   }
   
   // Usage
   async function fetchImportantData() {
     return withRetry(() => fetch('https://api.example.com/data'), {
       maxRetries: 5,
       onRetry: (error, attempt) => console.log(`Retry ${attempt} after error: ${error.message}`)
     });
   }
   ```

## Practice Questions

Test your understanding of Promises and Async/Await with these exercises:

### Question 1: Promise Chain

Write a function that takes a URL string, fetches the data from that URL, parses it as JSON, transforms all string values to uppercase, and returns the modified object. Use Promise chaining.

### Question 2: Promise.all Implementation

Implement a function that takes an array of user IDs and fetches all users in parallel. Use Promise.all to optimize the operation.

### Question 3: Sequential vs Parallel

Write two functions that process an array of items:
1. One that processes each item sequentially (one after another)
2. One that processes all items in parallel

Compare the performance differences for different array sizes.

### Question 4: Error Recovery

Create a function that attempts to read a configuration file, but falls back to default values if the file doesn't exist or has invalid content. Use async/await and proper error handling.

### Question 5: Timeout Implementation

Implement a function that wraps another async function and adds a timeout feature. If the original function doesn't complete within the specified timeout, the wrapper should reject with a timeout error.

### Question 6: Retry with Backoff

Create a retry utility that attempts an async operation multiple times with exponential backoff between attempts. The utility should accept parameters for maximum retries and initial delay.

### Question 7: Promise Queue

Implement a queue system that processes promises sequentially, with a configurable concurrency limit. The queue should accept new tasks even while processing and maintain the specified concurrency level.

## Conclusion

Promises and async/await are powerful tools for handling asynchronous operations in Node.js. While Promises provide a more structured approach compared to callbacks, async/await takes it a step further by making asynchronous code more readable and maintainable.

Key takeaways:
- Use Promises for handling asynchronous operations
- Use async/await for cleaner, more readable code
- Always handle errors properly
- Use Promise.all for parallel operations
- Understand when to use sequential vs parallel execution

By mastering these concepts and patterns, you'll be well-equipped to write efficient, maintainable, and robust asynchronous code in Node.js.
