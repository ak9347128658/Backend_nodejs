# Restaurant Management System - Implementation Guide

This document provides an in-depth explanation of how the Restaurant Management System is implemented using Node.js and the file system (fs) module. This guide is intended for educational purposes to understand how to build a real-world application using Node.js file operations.

## System Architecture

The restaurant management system follows a simple architecture:

1. **Data Layer**: JSON files for persistent storage
2. **Service Layer**: Functions for CRUD operations on the data
3. **UI Layer**: Console-based user interface

### Architecture Diagram

```
+---------------------+
|     UI Layer        |
|  (Console Interface)|
+----------+----------+
           |
           v
+----------+----------+      +-----------------+
|   Service Layer     |      |                 |
| (CRUD Operations)   +----->+ Data Layer      |
+----------+----------+      | (JSON Files)    |
                             +-----------------+
```

### File Structure

```
RestaurantManagementSystem/
├── app.js               # Main application with console interface
├── models.js            # Data models and file operations
├── package.json         # Project metadata and dependencies
├── README.md            # Project documentation
└── data/                # Data directory (created at runtime)
    ├── menu.json        # Menu data
    ├── orders.json      # Order data
    ├── tables.json      # Table data
    └── reservations.json # Reservation data
```

## Data Storage Implementation

### Using JSON Files for Persistence

The system uses JSON files to store data persistently. This approach has several advantages:

1. **Simplicity**: No need for a separate database
2. **Human-readable**: JSON files can be easily viewed and edited
3. **Native to JavaScript**: JSON parsing/stringifying is built into JavaScript

The system creates a `data` directory at startup if it doesn't exist and initializes empty JSON files for each data type.

### File Initialization

When the application starts, it checks if the necessary data files exist and creates them with default data if they don't:

```javascript
// Initialize files if they don't exist
function initializeFiles() {
    // Initialize menu.json
    if (!fs.existsSync(MENU_FILE)) {
        const defaultMenu = {
            categories: [
                // Default menu data...
            ]
        };
        fs.writeFileSync(MENU_FILE, JSON.stringify(defaultMenu, null, 2), 'utf8');
    }
    
    // Initialize other files...
}
```

## CRUD Operations with Node.js fs Module

### Data Flow Diagram

```
+----------------+    +-----------------+    +----------------+
| User Interface |    | Service Layer   |    |  File System   |
|   (app.js)     |<-->|  (models.js)    |<-->|  (JSON Files)  |
+----------------+    +-----------------+    +----------------+
        ^                     ^                      ^
        |                     |                      |
        v                     v                      v
+----------------+    +-----------------+    +----------------+
| User Input     |    | Data Processing |    | Read/Write     |
| & Display      |    | & Validation    |    | Operations     |
+----------------+    +-----------------+    +----------------+
```

### Reading Data

The system reads data from JSON files using `fs.readFileSync()`, parses the JSON, and returns the resulting object:

```javascript
getAllCategories: function() {
    try {
        const data = fs.readFileSync(MENU_FILE, 'utf8');
        const menu = JSON.parse(data);
        return menu.categories;
    } catch (err) {
        console.error('Error reading menu:', err);
        return [];
    }
}
```

### Writing Data

After modifying data in memory, the system writes it back to the JSON file using `fs.writeFileSync()`:

```javascript
addMenuItem: function(categoryId, item) {
    try {
        const data = fs.readFileSync(MENU_FILE, 'utf8');
        const menu = JSON.parse(data);
        
        const category = menu.categories.find(cat => cat.id === categoryId);
        if (!category) return false;
        
        // Generate a new ID
        const maxId = Math.max(...category.items.map(item => item.id), 0);
        item.id = maxId + 1;
        
        category.items.push(item);
        fs.writeFileSync(MENU_FILE, JSON.stringify(menu, null, 2), 'utf8');
        return true;
    } catch (err) {
        console.error('Error adding menu item:', err);
        return false;
    }
}
```

### Error Handling

All file operations are wrapped in try-catch blocks to handle potential errors:

```javascript
try {
    // File operations...
} catch (err) {
    console.error('Error message:', err);
    return fallbackValue;
}
```

## Key Implementation Features

### Service Modules

The `models.js` file defines service modules for each entity type:

1. **menuService**: Manages menu categories and items
2. **orderService**: Handles order creation and management
3. **tableService**: Manages table status and availability
4. **reservationService**: Handles reservation bookings

Each service provides methods for CRUD operations on its respective entity.

### Data Relationships

The system maintains relationships between different entities:

1. **Orders reference Tables**: Each order is associated with a table ID
2. **Orders reference Menu Items**: Orders contain menu item IDs and quantities
3. **Tables track Status**: Table status changes based on orders and reservations

### Entity Relationship Diagram

```
+----------------+       +----------------+       +----------------+
|     Menu       |       |     Order      |       |     Table      |
+----------------+       +----------------+       +----------------+
| - categories[] | <---- | - items[]      | ----> | - id           |
| - items[]      |       | - tableId      |       | - seats        |
+----------------+       | - status       |       | - status       |
                         | - total        |       +--------+-------+
                         +-------+--------+                |
                                 |                         |
                                 v                         v
                         +-------+--------+       +--------+-------+
                         |    OrderItem   |       |  Reservation   |
                         +----------------+       +----------------+
                         | - menuItemId   |       | - tableId      |
                         | - quantity     |       | - customerName |
                         | - price        |       | - date         |
                         +----------------+       | - partySize    |
                                                  +----------------+
```

### Console Interface

The `app.js` file implements a console-based user interface using the `readline` module:

```javascript
const rl = readline.createInterface({
    input: process.stdin,
    output: process.stdout
});
```

The interface uses nested menus and prompt/response patterns to guide the user through the system.

## Advanced Features

### Dynamic ID Generation

The system automatically generates new IDs for entities by finding the maximum existing ID and incrementing it:

```javascript
const maxId = Math.max(...category.items.map(item => item.id), 0);
item.id = maxId + 1;
```

### Date and Time Handling

The system uses JavaScript's `Date` object for handling reservation dates and times:

```javascript
const dateTime = new Date(`${dateStr}T${timeStr}:00`);
reservation.date = dateTime.toISOString();
```

### Status Workflow

Orders and tables follow a status workflow:

1. Tables: available → occupied → available
2. Orders: pending → preparing → ready → served → completed

### Order Status Workflow Diagram

```
+-----------+     +-----------+     +---------+     +---------+     +------------+
|  Pending  +---->| Preparing +---->|  Ready  +---->| Served  +---->| Completed  |
+-----------+     +-----------+     +---------+     +---------+     +------------+
     ^                                                                    |
     |                                                                    |
     +--------------------------------------------------------------------+
                           New order from same table
```

### Table Status Workflow Diagram

```
+------------+     +-----------+
| Available  +---->| Occupied  |
+-----+------+     +-----+-----+
      ^                  |
      |                  |
      +------------------+
      When order completed
```

## Learning Objectives Demonstrated

### 1. File System Operations

- Creating directories and files
- Reading from and writing to files
- Checking if files exist
- Error handling in file operations

### 2. Data Manipulation

- Parsing and stringifying JSON
- Finding, adding, updating, and deleting objects in arrays
- Filtering and sorting data

### 3. Console UI Design

- Creating a hierarchical menu system
- Handling user input and validation
- Displaying formatted data

### System Flow Diagram

```
+-------------------+    +-------------------+    +-------------------+
| 1. System Start   +--->| 2. File System    +--->| 3. Load Initial   |
|    app.js         |    |    Initialization |    |    Data           |
+-------------------+    +-------------------+    +--------+----------+
                                                           |
                                                           v
+-------------------+    +-------------------+    +--------+----------+
| 6. Process User   |<---+ 5. User Input     |<---+ 4. Display Main   |
|    Requests       |    |    via readline   |    |    Menu           |
+--------+----------+    +-------------------+    +-------------------+
         |
         v
+--------+----------+    +-------------------+    +-------------------+
| 7. Service Layer  +--->| 8. File System    +--->| 9. Display        |
|    Operations     |    |    Read/Write     |    |    Results        |
+-------------------+    +-------------------+    +-------------------+
```

## Best Practices Implemented

1. **Modular Design**: Separating data operations from the user interface
2. **Error Handling**: Comprehensive try-catch blocks for all file operations
3. **Data Validation**: Validating user input before processing
4. **Fallback Mechanisms**: Providing default values when operations fail
5. **Clear User Feedback**: Informative messages for success and failure

## Potential Improvements

1. **Asynchronous Operations**: Convert synchronous file operations to asynchronous for better performance
2. **Command Pattern**: Implement a command pattern for better operation tracking and potential undo functionality
3. **Input Validation**: Add more robust input validation
4. **Logging**: Implement a comprehensive logging system
5. **Authentication**: Add user authentication for different roles (manager, server, chef)

## Conclusion

This Restaurant Management System demonstrates how to use the Node.js fs module to create a fully functional application with persistent data storage. The system showcases CRUD operations, data relationships, and a console-based user interface, all built using core Node.js functionality without external dependencies.
