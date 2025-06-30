// Restaurant Management System using Node.js File System (fs)
// This file provides the core data models and file operations

const fs = require('fs');
const path = require('path');

// Ensure data directory exists
const DATA_DIR = path.join(__dirname, 'data');
if (!fs.existsSync(DATA_DIR)) {
    fs.mkdirSync(DATA_DIR);
}

// File paths
const MENU_FILE = path.join(DATA_DIR, 'menu.json');
const ORDERS_FILE = path.join(DATA_DIR, 'orders.json');
const TABLES_FILE = path.join(DATA_DIR, 'tables.json');
const RESERVATIONS_FILE = path.join(DATA_DIR, 'reservations.json');

// Initialize files if they don't exist
function initializeFiles() {
    // Initialize menu.json
    if (!fs.existsSync(MENU_FILE)) {
        const defaultMenu = {
            categories: [
                {
                    id: 1,
                    name: "Appetizers",
                    items: [
                        { id: 101, name: "Garlic Bread", price: 5.99, description: "Toasted bread with garlic butter" },
                        { id: 102, name: "Bruschetta", price: 7.99, description: "Toasted bread topped with tomatoes, garlic, and basil" }
                    ]
                },
                {
                    id: 2,
                    name: "Main Courses",
                    items: [
                        { id: 201, name: "Spaghetti Bolognese", price: 14.99, description: "Spaghetti with meat sauce" },
                        { id: 202, name: "Grilled Salmon", price: 18.99, description: "Fresh salmon fillet with lemon herb sauce" }
                    ]
                },
                {
                    id: 3,
                    name: "Desserts",
                    items: [
                        { id: 301, name: "Tiramisu", price: 6.99, description: "Classic Italian coffee-flavored dessert" },
                        { id: 302, name: "Chocolate Cake", price: 5.99, description: "Rich chocolate cake with ganache" }
                    ]
                },
                {
                    id: 4,
                    name: "Beverages",
                    items: [
                        { id: 401, name: "Soda", price: 2.99, description: "Assorted soft drinks" },
                        { id: 402, name: "Fresh Juice", price: 4.99, description: "Orange, apple, or pineapple" }
                    ]
                }
            ]
        };
        fs.writeFileSync(MENU_FILE, JSON.stringify(defaultMenu, null, 2), 'utf8');
    }

    // Initialize orders.json
    if (!fs.existsSync(ORDERS_FILE)) {
        fs.writeFileSync(ORDERS_FILE, JSON.stringify([], null, 2), 'utf8');
    }

    // Initialize tables.json
    if (!fs.existsSync(TABLES_FILE)) {
        const defaultTables = {
            tables: [
                { id: 1, capacity: 2, status: "available" },
                { id: 2, capacity: 2, status: "available" },
                { id: 3, capacity: 4, status: "available" },
                { id: 4, capacity: 4, status: "available" },
                { id: 5, capacity: 6, status: "available" },
                { id: 6, capacity: 6, status: "available" },
                { id: 7, capacity: 8, status: "available" },
                { id: 8, capacity: 8, status: "available" }
            ]
        };
        fs.writeFileSync(TABLES_FILE, JSON.stringify(defaultTables, null, 2), 'utf8');
    }

    // Initialize reservations.json
    if (!fs.existsSync(RESERVATIONS_FILE)) {
        fs.writeFileSync(RESERVATIONS_FILE, JSON.stringify([], null, 2), 'utf8');
    }
}

// Data access functions for menu
const menuService = {
    getAllCategories: function() {
        try {
            const data = fs.readFileSync(MENU_FILE, 'utf8');
            const menu = JSON.parse(data);
            return menu.categories;
        } catch (err) {
            console.error('Error reading menu:', err);
            return [];
        }
    },

    getMenuItemById: function(itemId) {
        try {
            const data = fs.readFileSync(MENU_FILE, 'utf8');
            const menu = JSON.parse(data);
            
            for (const category of menu.categories) {
                const item = category.items.find(item => item.id === itemId);
                if (item) return item;
            }
            return null;
        } catch (err) {
            console.error('Error finding menu item:', err);
            return null;
        }
    },

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
    },

    updateMenuItem: function(itemId, updatedItem) {
        try {
            const data = fs.readFileSync(MENU_FILE, 'utf8');
            const menu = JSON.parse(data);
            
            for (const category of menu.categories) {
                const index = category.items.findIndex(item => item.id === itemId);
                if (index !== -1) {
                    // Preserve the ID
                    updatedItem.id = itemId;
                    category.items[index] = updatedItem;
                    fs.writeFileSync(MENU_FILE, JSON.stringify(menu, null, 2), 'utf8');
                    return true;
                }
            }
            return false;
        } catch (err) {
            console.error('Error updating menu item:', err);
            return false;
        }
    },

    deleteMenuItem: function(itemId) {
        try {
            const data = fs.readFileSync(MENU_FILE, 'utf8');
            const menu = JSON.parse(data);
            
            for (const category of menu.categories) {
                const index = category.items.findIndex(item => item.id === itemId);
                if (index !== -1) {
                    category.items.splice(index, 1);
                    fs.writeFileSync(MENU_FILE, JSON.stringify(menu, null, 2), 'utf8');
                    return true;
                }
            }
            return false;
        } catch (err) {
            console.error('Error deleting menu item:', err);
            return false;
        }
    }
};

// Data access functions for orders
const orderService = {
    getAllOrders: function() {
        try {
            const data = fs.readFileSync(ORDERS_FILE, 'utf8');
            return JSON.parse(data);
        } catch (err) {
            console.error('Error reading orders:', err);
            return [];
        }
    },

    getOrderById: function(orderId) {
        try {
            const data = fs.readFileSync(ORDERS_FILE, 'utf8');
            const orders = JSON.parse(data);
            return orders.find(order => order.id === orderId) || null;
        } catch (err) {
            console.error('Error finding order:', err);
            return null;
        }
    },

    createOrder: function(order) {
        try {
            const data = fs.readFileSync(ORDERS_FILE, 'utf8');
            const orders = JSON.parse(data);
            
            // Generate a new ID
            const maxId = orders.length > 0 ? Math.max(...orders.map(o => o.id)) : 0;
            order.id = maxId + 1;
            order.timestamp = new Date().toISOString();
            order.status = "pending";
            
            orders.push(order);
            fs.writeFileSync(ORDERS_FILE, JSON.stringify(orders, null, 2), 'utf8');
            return order;
        } catch (err) {
            console.error('Error creating order:', err);
            return null;
        }
    },

    updateOrderStatus: function(orderId, status) {
        try {
            const data = fs.readFileSync(ORDERS_FILE, 'utf8');
            const orders = JSON.parse(data);
            
            const order = orders.find(o => o.id === orderId);
            if (!order) return false;
            
            order.status = status;
            order.lastUpdated = new Date().toISOString();
            
            fs.writeFileSync(ORDERS_FILE, JSON.stringify(orders, null, 2), 'utf8');
            return true;
        } catch (err) {
            console.error('Error updating order status:', err);
            return false;
        }
    },

    deleteOrder: function(orderId) {
        try {
            const data = fs.readFileSync(ORDERS_FILE, 'utf8');
            const orders = JSON.parse(data);
            
            const index = orders.findIndex(o => o.id === orderId);
            if (index === -1) return false;
            
            orders.splice(index, 1);
            fs.writeFileSync(ORDERS_FILE, JSON.stringify(orders, null, 2), 'utf8');
            return true;
        } catch (err) {
            console.error('Error deleting order:', err);
            return false;
        }
    }
};

// Data access functions for tables
const tableService = {
    getAllTables: function() {
        try {
            const data = fs.readFileSync(TABLES_FILE, 'utf8');
            const tableData = JSON.parse(data);
            return tableData.tables;
        } catch (err) {
            console.error('Error reading tables:', err);
            return [];
        }
    },

    getAvailableTables: function(partySize) {
        try {
            const data = fs.readFileSync(TABLES_FILE, 'utf8');
            const tableData = JSON.parse(data);
            
            return tableData.tables.filter(table => 
                table.status === "available" && table.capacity >= partySize
            );
        } catch (err) {
            console.error('Error finding available tables:', err);
            return [];
        }
    },

    updateTableStatus: function(tableId, status) {
        try {
            const data = fs.readFileSync(TABLES_FILE, 'utf8');
            const tableData = JSON.parse(data);
            
            const table = tableData.tables.find(t => t.id === tableId);
            if (!table) return false;
            
            table.status = status;
            fs.writeFileSync(TABLES_FILE, JSON.stringify(tableData, null, 2), 'utf8');
            return true;
        } catch (err) {
            console.error('Error updating table status:', err);
            return false;
        }
    }
};

// Data access functions for reservations
const reservationService = {
    getAllReservations: function() {
        try {
            const data = fs.readFileSync(RESERVATIONS_FILE, 'utf8');
            return JSON.parse(data);
        } catch (err) {
            console.error('Error reading reservations:', err);
            return [];
        }
    },

    getReservationsByDate: function(date) {
        try {
            const data = fs.readFileSync(RESERVATIONS_FILE, 'utf8');
            const reservations = JSON.parse(data);
            
            return reservations.filter(res => 
                res.date.split('T')[0] === date.split('T')[0]
            );
        } catch (err) {
            console.error('Error finding reservations by date:', err);
            return [];
        }
    },

    createReservation: function(reservation) {
        try {
            const data = fs.readFileSync(RESERVATIONS_FILE, 'utf8');
            const reservations = JSON.parse(data);
            
            // Generate a new ID
            const maxId = reservations.length > 0 ? Math.max(...reservations.map(r => r.id)) : 0;
            reservation.id = maxId + 1;
            reservation.createdAt = new Date().toISOString();
            
            reservations.push(reservation);
            fs.writeFileSync(RESERVATIONS_FILE, JSON.stringify(reservations, null, 2), 'utf8');
            return reservation;
        } catch (err) {
            console.error('Error creating reservation:', err);
            return null;
        }
    },

    updateReservation: function(reservationId, updatedReservation) {
        try {
            const data = fs.readFileSync(RESERVATIONS_FILE, 'utf8');
            const reservations = JSON.parse(data);
            
            const index = reservations.findIndex(r => r.id === reservationId);
            if (index === -1) return false;
            
            // Preserve the ID and creation date
            updatedReservation.id = reservationId;
            updatedReservation.createdAt = reservations[index].createdAt;
            updatedReservation.updatedAt = new Date().toISOString();
            
            reservations[index] = updatedReservation;
            fs.writeFileSync(RESERVATIONS_FILE, JSON.stringify(reservations, null, 2), 'utf8');
            return true;
        } catch (err) {
            console.error('Error updating reservation:', err);
            return false;
        }
    },

    deleteReservation: function(reservationId) {
        try {
            const data = fs.readFileSync(RESERVATIONS_FILE, 'utf8');
            const reservations = JSON.parse(data);
            
            const index = reservations.findIndex(r => r.id === reservationId);
            if (index === -1) return false;
            
            reservations.splice(index, 1);
            fs.writeFileSync(RESERVATIONS_FILE, JSON.stringify(reservations, null, 2), 'utf8');
            return true;
        } catch (err) {
            console.error('Error deleting reservation:', err);
            return false;
        }
    }
};

// Initialize files when the module is first loaded
initializeFiles();

// Export the service modules
module.exports = {
    menuService,
    orderService,
    tableService,
    reservationService
};
