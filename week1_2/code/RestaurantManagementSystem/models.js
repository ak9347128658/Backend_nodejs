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


module.exports = {
    menuService
}