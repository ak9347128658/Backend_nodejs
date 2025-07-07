const fs = require("fs");
const path = require("path");

const DATA_DIR = path.join(__dirname, "data");

// console.log("Data directory:", DATA_DIR);

// Ensure data directory exists
if(!fs.existsSync(DATA_DIR)){
    fs.mkdirSync(DATA_DIR, { recursive: true });
}

// File paths
const MENU_FILE = path.join(DATA_DIR, 'menu.json');
const ORDERS_FILE = path.join(DATA_DIR, 'orders.json');
const TABLES_FILE = path.join(DATA_DIR, 'tables.json');
const RESERVATIONS_FILE = path.join(DATA_DIR, 'reservations.json');


// Data access funtions for menu
const menuService = {
    getAllCategories: function() {
        try{
          const data = fs.readFileSync(MENU_FILE, 'utf-8');
          const menu = JSON.parse(data);
          return menu.categories;
        }catch(error){
            console.error("Error fetching categories:", error);
            return [];
        }
    },
    getMenuItemById: function(itemId){
        try{
         const data = fs.readFileSync(MENU_FILE, 'utf-8');
         const menu = JSON.parse(data);
         for(const category of menu.categories){
            const item = category.items.find(item => item.id === itemId);
            if(item){
                return item;
            }
         }
        }catch(error){
            console.error("Error fetching menu item:", error);
            return null;
        }
    },
    addMenuItem: function(categoryId, item) {
        try{
        const data = fs.readFileSync(MENU_FILE, 'utf-8');
        const menu = JSON.parse(data);
        const category = menu.categories.find(cat => cat.id === categoryId);
        if(!category){
            console.error("Category not found");
            return false;
        }

        // Generate a new ID for the item
        const maxId = Math.max(...category.items.map(item => item.id), 0);
        item.id = maxId + 1;

        category.items.push(item);
        fs.writeFileSync(MENU_FILE,JSON.stringify(menu,null,2),'utf-8');
        return true;

        }catch(error){
            console.error("Error adding menu item:", error);
            return false;
        }
    },
    updateMenuItem: function(itemId, updateItem){
       try{
        const data = fs.readFileSync(MENU_FILE, 'utf-8');
        const menu = JSON.parse(data);
        for(const category of menu.categories){
           const index = category.items.findIndex(item => item.id === itemId);
           if(index !== -1){
             // Presere the Id
             updateItem.id = itemId;
             category.items[index] = updateItem;
             fs.writeFileSync(MENU_FILE, JSON.stringify(menu, null, 2), 'utf-8');
             return true;
           }
        }
       }catch(error){
           console.error("Error updating menu item:", error);
           return false;
       }
    },
    deleteMenuItem: function(itemId){
        try{
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
        }catch(error){
            console.error("Error deleting menu item:", error);
            return false;
        }
    } 
}


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
    createOrder: function(order){
        try {
            const data = fs.readFileSync(ORDERS_FILE, 'utf8');
            const orders = JSON.parse(data);
            
            // Generate a new ID
            const maxId = orders.length > 0 ? Math.max(...orders.map(o => o.id)) : 0;
            order.id = maxId + 1;
            order.timestamp = new Date().toISOString();
            order.lastUpdated = new Date().toISOString();
            order.status = "pending";
            
            orders.push(order);
            fs.writeFileSync(ORDERS_FILE, JSON.stringify(orders, null, 2), 'utf8');
            return order;
        } catch (err) {
            console.error('Error creating order:', err);
            return null;
        }
    },
    updateOrderStatus:function(orderId,status){
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
    deleteOrder: function(orderId){
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
    getAvailableTables: function(partySize){
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
    updateTableStatus: function(tableId,status){
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
}

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


module.exports = {
    menuService,
    orderService,
    tableService,
    reservationService
}