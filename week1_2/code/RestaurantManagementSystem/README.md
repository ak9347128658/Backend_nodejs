# Restaurant Management System

A console-based restaurant management system built with Node.js that uses the file system (fs) module for data persistence.

## Features

- **Menu Management**
  - View the restaurant menu
  - Add, update, and delete menu items
  - Organize menu items by categories

- **Order Management**
  - Create new orders
  - Update order status (pending, preparing, ready, served, completed, cancelled)
  - View all orders
  - Delete orders

- **Table Management**
  - View all tables and their status
  - Find available tables by party size
  - Update table status (available, occupied, reserved, maintenance)

- **Reservation Management**
  - Create table reservations
  - View all reservations
  - View reservations by date
  - Update and delete reservations

## Data Storage

The system uses JSON files for data persistence:

- `data/menu.json` - Stores the menu categories and items
- `data/orders.json` - Stores all orders
- `data/tables.json` - Stores table information and status
- `data/reservations.json` - Stores all reservations

## Getting Started

### Prerequisites

- Node.js (v12.0.0 or higher)

### Installation

1. Clone the repository or download the source code
2. Navigate to the project directory
3. Run the application:

```bash
node app.js
```

## How to Use

### Main Menu

When you start the application, you'll see the main menu with the following options:

1. Manage Menu
2. Manage Orders
3. Manage Tables
4. Manage Reservations
5. Exit

Use the keyboard to select an option by entering the corresponding number.

### Menu Management

- **View Menu**: Displays all menu categories and items
- **Add Menu Item**: Add a new item to a specific category
- **Update Menu Item**: Modify an existing menu item's name, price, or description
- **Delete Menu Item**: Remove a menu item

### Order Management

- **View All Orders**: See all orders with details
- **Create New Order**: Create a new order by selecting a table and adding menu items
- **Update Order Status**: Change the status of an order
- **Delete Order**: Remove an order from the system

### Table Management

- **View All Tables**: See all tables with their capacity and current status
- **Find Available Table**: Find tables available for a specific party size
- **Update Table Status**: Change a table's status

### Reservation Management

- **View All Reservations**: See all upcoming reservations
- **View Reservations by Date**: Filter reservations by date
- **Create Reservation**: Make a new reservation
- **Update Reservation**: Modify an existing reservation
- **Delete Reservation**: Cancel a reservation

## File Structure

- `app.js` - Main application file with the console interface
- `models.js` - Data models and file operations
- `data/` - Directory for JSON data files
  - `menu.json` - Menu data
  - `orders.json` - Order data
  - `tables.json` - Table data
  - `reservations.json` - Reservation data

## Learning Objectives

This project demonstrates:

1. How to use the Node.js fs module for file operations
2. Working with JSON data for persistence
3. Building a console-based user interface
4. Implementing CRUD operations (Create, Read, Update, Delete)
5. Error handling in file operations
6. Working with dates and times in JavaScript

## License

This project is licensed under the ISC License.
