# Node.js File System (fs) Module

## Introduction

The File System (fs) module in Node.js provides an API for interacting with the file system. It allows you to read from and write to files, create directories, watch files for changes, and perform many other file-related operations. The fs module is a core module in Node.js, which means it comes pre-installed and you don't need to install any external packages to use it.

## Importing the fs Module

```javascript
// CommonJS syntax
const fs = require('fs');

// ES6 syntax (if using ES modules)
// import * as fs from 'fs';
```

## Synchronous vs. Asynchronous Operations

The fs module provides both synchronous and asynchronous methods for file operations:

- **Synchronous methods** block the execution of the program until the operation is completed. They end with "Sync" (e.g., `readFileSync`).
- **Asynchronous methods** don't block the program execution. They take a callback function that is called when the operation is completed.
- **Promise-based methods** are available via `fs.promises` for working with promises instead of callbacks.

## Common File System Operations

### 1. Reading Files

#### Asynchronous Reading

```javascript
// Using callbacks
fs.readFile('file.txt', 'utf8', (err, data) => {
  if (err) {
    console.error('Error reading file:', err);
    return;
  }
  console.log('File content:', data);
});

// Using promises
fs.promises.readFile('file.txt', 'utf8')
  .then(data => console.log('File content:', data))
  .catch(err => console.error('Error reading file:', err));

// Using async/await
async function readFileContent() {
  try {
    const data = await fs.promises.readFile('file.txt', 'utf8');
    console.log('File content:', data);
  } catch (err) {
    console.error('Error reading file:', err);
  }
}
```

#### Synchronous Reading

```javascript
try {
  const data = fs.readFileSync('file.txt', 'utf8');
  console.log('File content:', data);
} catch (err) {
  console.error('Error reading file:', err);
}
```

### 2. Writing Files

#### Asynchronous Writing

```javascript
// Using callbacks
fs.writeFile('file.txt', 'Hello, World!', 'utf8', (err) => {
  if (err) {
    console.error('Error writing to file:', err);
    return;
  }
  console.log('File written successfully');
});

// Using promises
fs.promises.writeFile('file.txt', 'Hello, World!', 'utf8')
  .then(() => console.log('File written successfully'))
  .catch(err => console.error('Error writing to file:', err));

// Using async/await
async function writeToFile() {
  try {
    await fs.promises.writeFile('file.txt', 'Hello, World!', 'utf8');
    console.log('File written successfully');
  } catch (err) {
    console.error('Error writing to file:', err);
  }
}
```

#### Synchronous Writing

```javascript
try {
  fs.writeFileSync('file.txt', 'Hello, World!', 'utf8');
  console.log('File written successfully');
} catch (err) {
  console.error('Error writing to file:', err);
}
```

### 3. Appending to Files

```javascript
// Asynchronous
fs.appendFile('file.txt', '\nNew content to append', 'utf8', (err) => {
  if (err) {
    console.error('Error appending to file:', err);
    return;
  }
  console.log('Content appended successfully');
});

// Synchronous
try {
  fs.appendFileSync('file.txt', '\nNew content to append', 'utf8');
  console.log('Content appended successfully');
} catch (err) {
  console.error('Error appending to file:', err);
}
```

### 4. Checking if a File Exists

```javascript
// Using fs.access (preferred)
fs.access('file.txt', fs.constants.F_OK, (err) => {
  console.log(err ? 'File does not exist' : 'File exists');
});

// Using fs.existsSync (synchronous)
const fileExists = fs.existsSync('file.txt');
console.log(fileExists ? 'File exists' : 'File does not exist');
```

### 5. Creating Directories

```javascript
// Create a single directory
fs.mkdir('newDir', (err) => {
  if (err) {
    console.error('Error creating directory:', err);
    return;
  }
  console.log('Directory created successfully');
});

// Create nested directories (recursive)
fs.mkdir('path/to/nested/dir', { recursive: true }, (err) => {
  if (err) {
    console.error('Error creating nested directories:', err);
    return;
  }
  console.log('Nested directories created successfully');
});
```

### 6. Listing Directory Contents

```javascript
fs.readdir('directory', (err, files) => {
  if (err) {
    console.error('Error reading directory:', err);
    return;
  }
  console.log('Directory contents:', files);
});
```

### 7. Deleting Files

```javascript
fs.unlink('fileToDelete.txt', (err) => {
  if (err) {
    console.error('Error deleting file:', err);
    return;
  }
  console.log('File deleted successfully');
});
```

### 8. Renaming/Moving Files

```javascript
fs.rename('oldName.txt', 'newName.txt', (err) => {
  if (err) {
    console.error('Error renaming file:', err);
    return;
  }
  console.log('File renamed successfully');
});
```

### 9. Getting File Information

```javascript
fs.stat('file.txt', (err, stats) => {
  if (err) {
    console.error('Error getting file stats:', err);
    return;
  }
  console.log('File size:', stats.size);
  console.log('Is file:', stats.isFile());
  console.log('Is directory:', stats.isDirectory());
  console.log('Last modified:', stats.mtime);
});
```

### 10. Watching Files for Changes

```javascript
const watcher = fs.watch('file.txt', (eventType, filename) => {
  console.log(`Event type: ${eventType}`);
  if (filename) {
    console.log(`File changed: ${filename}`);
  }
});

// Stop watching
// watcher.close();
```

## Stream Operations

Streams are particularly useful for handling large files as they allow you to process data in chunks rather than loading the entire file into memory.

### Reading from a File Using Streams

```javascript
const readStream = fs.createReadStream('largeFile.txt', 'utf8');

readStream.on('data', (chunk) => {
  console.log('Received chunk of data:', chunk.length);
});

readStream.on('end', () => {
  console.log('Finished reading file');
});

readStream.on('error', (err) => {
  console.error('Error reading file:', err);
});
```

### Writing to a File Using Streams

```javascript
const writeStream = fs.createWriteStream('output.txt', 'utf8');

writeStream.write('First line of data\n');
writeStream.write('Second line of data\n');
writeStream.end('Last line of data');

writeStream.on('finish', () => {
  console.log('Finished writing to file');
});

writeStream.on('error', (err) => {
  console.error('Error writing to file:', err);
});
```

### Piping Streams

```javascript
const readStream = fs.createReadStream('source.txt');
const writeStream = fs.createWriteStream('destination.txt');

readStream.pipe(writeStream);

writeStream.on('finish', () => {
  console.log('File copy completed');
});
```

## Working with JSON Data

A common use case in Node.js applications is to store and retrieve data in JSON format.

### Reading and Parsing JSON Files

```javascript
fs.readFile('data.json', 'utf8', (err, data) => {
  if (err) {
    console.error('Error reading file:', err);
    return;
  }
  
  try {
    const jsonData = JSON.parse(data);
    console.log('Parsed JSON data:', jsonData);
  } catch (parseErr) {
    console.error('Error parsing JSON:', parseErr);
  }
});
```

### Writing JSON Data to Files

```javascript
const data = {
  name: 'John',
  age: 30,
  city: 'New York'
};

fs.writeFile('data.json', JSON.stringify(data, null, 2), 'utf8', (err) => {
  if (err) {
    console.error('Error writing JSON file:', err);
    return;
  }
  console.log('JSON file saved successfully');
});
```

## Error Handling Best Practices

1. **Always handle errors**: Never ignore errors in file operations as they can cause unexpected behavior.
2. **Use try-catch blocks**: Wrap synchronous operations in try-catch blocks.
3. **Check for specific error codes**: Different errors have different codes, which can help you provide better error messages.

```javascript
fs.access('file.txt', fs.constants.F_OK, (err) => {
  if (err) {
    if (err.code === 'ENOENT') {
      console.error('File does not exist');
    } else {
      console.error('Unknown error:', err);
    }
    return;
  }
  console.log('File exists');
});
```

## Performance Considerations

1. **Use asynchronous operations**: For better performance and to avoid blocking the event loop, use asynchronous methods.
2. **Use streams for large files**: When dealing with large files, use streams instead of reading entire files into memory.
3. **Buffer size**: Consider adjusting the buffer size when working with streams for optimal performance.
4. **Batch operations**: Group multiple file operations together when possible to reduce overhead.

## Conclusion

The fs module in Node.js provides a comprehensive set of tools for working with files and directories. By understanding how to use its various methods effectively, you can build applications that efficiently manage file I/O operations. Remember to use asynchronous methods for better performance and always handle errors properly to ensure your application is robust and reliable.
