const readline = require("readline");
const {menuService,orderService,tableService,reservationService} = require("./models.js");
// read a name
const rl = readline.createInterface({
  input: process.stdin,
  output: process.stdout
});

// helper function to display a menu and get user choice
function showMenu(title, options, callback) {
  console.log(`\n========== ${title} ============`)

  options.forEach((option,index) => {
    console.log(`${index + 1}. ${option}`);
  });

  rl.question('Enter your choice: ', (answer) => {
    const choice = parseInt(answer);
    // validate choice
    if(isNaN(choice) || choice < 0 || choice > options.length) {
      console.log("Invalid choice. Please try again.");
      showMenu(title, options, callback);
    }else{
        callback(choice);
    }
  })
}

// showMenu("Main Menu", ["Add Customer", "Add Order", "Exit"], (choice) => {
//     console.log("You selected an option from the main menu. ",choice);
// });

// Main menu
function mainMenu() {
   console.clear(); 
   console.log("=====================================");
   console.log("    Restaurant Management System    ");
    console.log("=====================================");

  const options =[
    "Manage Menu",
    "Manage Orders",
    "Manage Tables",
    "Manage Reservations",
    "Exit"
  ]

  showMenu("MAIN MENU", options, (choice) => {
    switch(choice) {
       case 1:
          manuManagement();
            break;
       case 2:
          orderManagement();
            break;
       case 3:
          tableManagement();
            break;
       case 4:
            reservationManagement();
                break;
       case 5:
        console.log("Thank you for using the Restaurant Management System. Goodbye!");
        rl.close();
            break;
       case 0:
          mainMenu();
            break;
    }
  })

}

// ================ men management code start here

function manuManagement() {
    const options = [
        "View Menu",
        "Add Menu Item",
        "Update Menu Item",
        "Delete Menu Item",
    ]

   showMenu("Menu Management", options, (choice) => {
        switch(choice) {
            case 1:
                viewMenu();
                break;
            case 2:
                addMenuItem();
                break;
            case 3:
                updateMenuItem();
                break;
            case 4:
                deleteMenuItem();
                break;
            case 0:
                mainMenu();
                break;
        }
   })
}

function addMenuItem() {
    const categories = menuService.getAllCategories();

    console.log(`\n====== CATEGORIES ======`);
    categories.forEach((category, index) => {
        console.log(`${index + 1}. ${category.name}`);
    });

    rl.question(`\nEnter the category ID :`, (categoryId) => {
        const id = parseInt(categoryId);
        const category = categories.find(cat => cat.id === id); 
       
        if(!category){
            console.log("Invalid category ID. Please try again.");
            rl.question(`\nPress Enter to try again...`, () => {
                addMenuItem();
            })
            return;
        }
    rl.question('Enter item name: ', (name) => {
            rl.question('Enter item price: ', (priceStr) => {
                const price = parseFloat(priceStr);
                
                if (isNaN(price) || price <= 0) {
                    console.log('Invalid price. Please enter a positive number.');
                    rl.question('\nPress Enter to try again...', () => {
                        addMenuItem();
                    });
                    return;
                }
                
                rl.question('Enter item description: ', (description) => {
                    const newItem = {
                        name,
                        price,
                        description
                    };
                    
                    const success = menuService.addMenuItem(id, newItem);
                    
                    if (success) {
                        console.log(`\nItem "${name}" added successfully to ${category.name} category.`);
                    } else {
                        console.log('\nFailed to add menu item. Please try again.');
                    }
                    
                    rl.question('\nPress Enter to continue...', () => {
                        manuManagement();
                    });
                });
            });
        });
    });
}

function viewMenu() {
  console.log("\n====== RESTAURANT MENU =========")
  const categories = menuService.getAllCategories();

  if(categories.length === 0){
    console.log("No menu items available.");
  }else{
    categories.forEach((categorie) => {
        console.log(`\n----- ${categorie.name} -----`);
        if(categorie.items.length === 0){
            console.log("No menu in this category.");
        }else{
            categorie.items.forEach((item) => {  
                console.log(`${item.id}. ${item.name} - $${item.price.toFixed(2)}`);
            })
        }
    });

    rl.question(`\nPress Enter to continue...`, () => {
        manuManagement();
    });
  }

}

function updateMenuItem() {
    rl.question(`\nEnter the Id of the iteme to udpate:`, (itemIdStr) => {
      const itemId = parseInt(itemIdStr);
      const item = menuService.getMenuItemById(itemId);
      if(!item) {
        console.log("Item not found.");
        rl.question(`\nPress Enter to try again...`, () => {
          updateMenuItem();
        });
        return; 
      }

      console.log(`\nUpdating: ${item.name} - $${item.price.toFixed(2)}`);
      console.log(`Description: ${item.description}`);
      
      rl.question(`\nEnter new name(or press Enter to keep current)`,(name) => {
        let newName = (name.trim().length === 0) ? item.name : name.trim();
        rl.question(`\nEnter new Price (or press Enter to keep current)`,
            (priceStr) => {
           let newPrice = (priceStr.trim().length === 0) ? item.price : parseFloat(priceStr);
           rl.question(`\nEnter new Description (or press Enter to keep current)`,(description) => {
            let newDescription = (description.trim().length === 0) ? item.description : description.trim();
            
            const updateItem = {
                name: newName,
                price: newPrice,
                description: newDescription
            }

            const success = menuService.updateMenuItem(itemId,updateItem);
            if(success)
                console.log(`\nMenu Item udpated successfully`);
            else
               console.log(`\nFailed to update menu item. Please try again.`)

            rl.question(`\nPress Enter to continue...`, () => {
                manuManagement();
            });
        });
      }
    );
  }
)

    });
}

function deleteMenuItem() {
    rl.question(`\nEnter the Id of the iteme to delete:`, (itemIdStr) => {
      const itemId = parseInt(itemIdStr);
      const item = menuService.getMenuItemById(itemId);

      if(!item){
        console.log("Item not found.");
        rl.question(`\nPress Enter to try again...`, () => {
          deleteMenuItem();
        });
        return;
      }
   
      console.log(`\nDeleting: ${item.name} - $${item.price.toFixed(2)}`);
      rl.question(`Are you sure you want to delete this item? (y/n)`,(answer)=> {
        if(answer.toLowerCase() === 'y'){
          const success = menuService.deleteMenuItem(itemId);
          if(success)
            console.log(`\nMenu Item deleted successfully`);
          else
            console.log(`\nFailed to delete menu item. Please try again.`)
        }
        else{
            console.log(`\nDeletion canceled.`);
        }
        
        rl.question(`\nPress Enter to continue...`, () => {
          manuManagement();
        });

      })
    })
}

// ================= menu management code ends here

// ============================ order managment start 

function orderManagement() {
    const options = [
        'View All Orders',
        'Create New Order',
        'Update Order Status',
        'Delete Order'
    ];
 showMenu('ORDER MANAGEMENT', options, (choice) => {
        switch(choice) {
            case 1:
                viewAllOrders();
                break;
            case 2:
                createNewOrder();
                break;
            case 3:
                updateOrderStatus();
                break;
            case 4:
                deleteOrder();
                break;
            case 0:
                mainMenu();
                break;
        }
    });
}


function viewAllOrders() {
   console.log("\n============== All ORDERS =============="); 
   const orders = orderService.getAllOrders();
    if (orders.length === 0) {
        console.log('No orders available.');
    } else {
        orders.forEach(order => {
            const date = new Date(order.timestamp).toLocaleString();
            console.log(`\nOrder #${order.id} - ${date}`);
            console.log(`Status: ${order.status}`);
            console.log(`Table: ${order.tableId}`);
            console.log('Items:');
            
            let total = 0;
            order.items.forEach(item => {
                const menuItem = menuService.getMenuItemById(item.menuItemId);
                const itemTotal = menuItem.price * item.quantity;
                total += itemTotal;
                console.log(`- ${item.quantity}x ${menuItem.name} ($${menuItem.price.toFixed(2)}) = $${itemTotal.toFixed(2)}`);
            });
            
            console.log(`Total: $${total.toFixed(2)}`);
        });
    }
    
    rl.question('\nPress Enter to continue...', () => {
        orderManagement();
    });
}

function createNewOrder() {
    // First, get an available table
    const tables = tableService.getAllTables();
    const availableTables = tables.filter(table => table.status === 'available');
    
    if (availableTables.length === 0) {
        console.log('\nNo tables available at this time.');
        rl.question('\nPress Enter to continue...', () => {
            orderManagement();
        });
        return;
    }
    
    console.log('\n===== AVAILABLE TABLES =====');
    availableTables.forEach(table => {
        console.log(`Table #${table.id} - Capacity: ${table.capacity}`);
    });
    
    rl.question('\nEnter table ID for this order: ', (tableIdStr) => {
        const tableId = parseInt(tableIdStr);
        const table = availableTables.find(t => t.id === tableId);
        
        if (!table) {
            console.log('Invalid table ID.');
            rl.question('\nPress Enter to try again...', () => {
                createNewOrder();
            });
            return;
        }
        
        // Show menu for ordering
        console.log('\n===== MENU FOR ORDERING =====');
        const categories = menuService.getAllCategories();
        
        categories.forEach(category => {
            console.log(`\n--- ${category.name} ---`);
            category.items.forEach(item => {
                console.log(`${item.id}. ${item.name} - $${item.price.toFixed(2)}`);
            });
        });
        
        const orderItems = [];
        
        function addOrderItem() {
            rl.question('\nEnter menu item ID (or 0 to finish ordering): ', (itemIdStr) => {
                const itemId = parseInt(itemIdStr);
                
                if (itemId === 0) {
                    if (orderItems.length === 0) {
                        console.log('Order must contain at least one item.');
                        addOrderItem();
                        return;
                    }
                    
                    // Create the order
                    const newOrder = {
                        tableId,
                        items: orderItems,
                        notes: ''
                    };
                    
                    rl.question('Add any special instructions (or press Enter to skip): ', (notes) => {
                        newOrder.notes = notes;
                        
                        const createdOrder = orderService.createOrder(newOrder);
                        
                        if (createdOrder) {
                            // Update table status
                            tableService.updateTableStatus(tableId, 'occupied');
                            console.log(`\nOrder #${createdOrder.id} created successfully.`);
                        } else {
                            console.log('\nFailed to create order.');
                        }
                        
                        rl.question('\nPress Enter to continue...', () => {
                            orderManagement();
                        });
                    });
                    
                    return;
                }
                
                const menuItem = menuService.getMenuItemById(itemId);
                
                if (!menuItem) {
                    console.log('Invalid menu item ID.');
                    addOrderItem();
                    return;
                }
                
                rl.question(`Enter quantity for ${menuItem.name}: `, (quantityStr) => {
                    const quantity = parseInt(quantityStr);
                    
                    if (isNaN(quantity) || quantity <= 0) {
                        console.log('Invalid quantity. Please enter a positive number.');
                        addOrderItem();
                        return;
                    }
                    
                    // Check if this item is already in the order
                    const existingItem = orderItems.find(item => item.menuItemId === itemId);
                    
                    if (existingItem) {
                        existingItem.quantity += quantity;
                    } else {
                        orderItems.push({
                            menuItemId: itemId,
                            quantity
                        });
                    }
                    
                    console.log(`Added ${quantity}x ${menuItem.name} to the order.`);
                    addOrderItem();
                });
            });
        }
        
        addOrderItem();
    });
}

function updateOrderStatus() {
    const orders = orderService.getAllOrders();
    
    if (orders.length === 0) {
        console.log('\nNo orders available to update.');
        rl.question('\nPress Enter to continue...', () => {
            orderManagement();
        });
        return;
    }
    
    console.log('\n===== ORDERS =====');
    orders.forEach(order => {
        console.log(`Order #${order.id} - Status: ${order.status} - Table: ${order.tableId}`);
    });
    
    rl.question('\nEnter order ID to update status: ', (orderIdStr) => {
        const orderId = parseInt(orderIdStr);
        const order = orderService.getOrderById(orderId);
        
        if (!order) {
            console.log('Invalid order ID.');
            rl.question('\nPress Enter to try again...', () => {
                updateOrderStatus();
            });
            return;
        }
        
        console.log('\nStatus options:');
        const statusOptions = ['pending', 'preparing', 'ready', 'served', 'completed', 'cancelled'];
        statusOptions.forEach((status, index) => {
            console.log(`${index + 1}. ${status}`);
        });
        
        rl.question('\nChoose new status (1-6): ', (statusChoice) => {
            const choice = parseInt(statusChoice);
            
            if (isNaN(choice) || choice < 1 || choice > statusOptions.length) {
                console.log('Invalid choice.');
                rl.question('\nPress Enter to try again...', () => {
                    updateOrderStatus();
                });
                return;
            }
            
            const newStatus = statusOptions[choice - 1];
            
            // If status is completed or cancelled, free up the table
            if (newStatus === 'completed' || newStatus === 'cancelled') {
                tableService.updateTableStatus(order.tableId, 'available');
            }
            
            const success = orderService.updateOrderStatus(orderId, newStatus);
            
            if (success) {
                console.log(`\nOrder #${orderId} status updated to "${newStatus}".`);
            } else {
                console.log('\nFailed to update order status.');
            }
            
            rl.question('\nPress Enter to continue...', () => {
                orderManagement();
            });
        });
    });
}

function deleteOrder() {
    const orders = orderService.getAllOrders();
    
    if (orders.length === 0) {
        console.log('\nNo orders available to delete.');
        rl.question('\nPress Enter to continue...', () => {
            orderManagement();
        });
        return;
    }
    
    console.log('\n===== ORDERS =====');
    orders.forEach(order => {
        console.log(`Order #${order.id} - Status: ${order.status} - Table: ${order.tableId}`);
    });
    
    rl.question('\nEnter order ID to delete: ', (orderIdStr) => {
        const orderId = parseInt(orderIdStr);
        const order = orderService.getOrderById(orderId);
        
        if (!order) {
            console.log('Invalid order ID.');
            rl.question('\nPress Enter to try again...', () => {
                deleteOrder();
            });
            return;
        }
        
        rl.question(`Are you sure you want to delete Order #${orderId}? (y/n): `, (answer) => {
            if (answer.toLowerCase() === 'y') {
                // Free up the table if it was occupied
                tableService.updateTableStatus(order.tableId, 'available');
                
                const success = orderService.deleteOrder(orderId);
                
                if (success) {
                    console.log(`\nOrder #${orderId} deleted successfully.`);
                } else {
                    console.log('\nFailed to delete order.');
                }
            } else {
                console.log('\nDeletion cancelled.');
            }
            
            rl.question('\nPress Enter to continue...', () => {
                orderManagement();
            });
        });
    });
}

// =========================== order management ends

// ======================== table management code start here
// Table Management
function tableManagement() {
    const options = [
        'View All Tables',
        'Find Available Table',
        'Update Table Status'
    ];
    
    showMenu('TABLE MANAGEMENT', options, (choice) => {
        switch(choice) {
            case 1:
                viewAllTables();
                break;
            case 2:
                findAvailableTable();
                break;
            case 3:
                updateTableStatus();
                break;
            case 0:
                mainMenu();
                break;
        }
    });
}

function viewAllTables() {
    console.log('\n===== ALL TABLES =====');
    const tables = tableService.getAllTables();
    
    if (tables.length === 0) {
        console.log('No tables available.');
    } else {
        tables.forEach(table => {
            const statusColor = table.status === 'available' ? '\x1b[32m' : '\x1b[31m';
            console.log(`Table #${table.id} - Capacity: ${table.capacity} - Status: ${statusColor}${table.status}\x1b[0m`);
        });
    }
    
    rl.question('\nPress Enter to continue...', () => {
        tableManagement();
    });
}

function findAvailableTable() {
    rl.question('\nEnter party size: ', (partySizeStr) => {
        const partySize = parseInt(partySizeStr);
        
        if (isNaN(partySize) || partySize <= 0) {
            console.log('Invalid party size. Please enter a positive number.');
            rl.question('\nPress Enter to try again...', () => {
                findAvailableTable();
            });
            return;
        }
        
        const availableTables = tableService.getAvailableTables(partySize);
        
        console.log(`\n===== AVAILABLE TABLES FOR ${partySize} PEOPLE =====`);
        
        if (availableTables.length === 0) {
            console.log('No tables available for this party size.');
        } else {
            availableTables.forEach(table => {
                console.log(`Table #${table.id} - Capacity: ${table.capacity}`);
            });
        }
        
        rl.question('\nPress Enter to continue...', () => {
            tableManagement();
        });
    });
}

function updateTableStatus() {
    const tables = tableService.getAllTables();
    
    console.log('\n===== ALL TABLES =====');
    tables.forEach(table => {
        const statusColor = table.status === 'available' ? '\x1b[32m' : '\x1b[31m';
        console.log(`Table #${table.id} - Capacity: ${table.capacity} - Status: ${statusColor}${table.status}\x1b[0m`);
    });
    
    rl.question('\nEnter table ID to update status: ', (tableIdStr) => {
        const tableId = parseInt(tableIdStr);
        const table = tables.find(t => t.id === tableId);
        
        if (!table) {
            console.log('Invalid table ID.');
            rl.question('\nPress Enter to try again...', () => {
                updateTableStatus();
            });
            return;
        }
        
        console.log('\nStatus options:');
        console.log('1. available');
        console.log('2. occupied');
        console.log('3. reserved');
        console.log('4. maintenance');
        
        rl.question('\nChoose new status (1-4): ', (statusChoice) => {
            const statuses = ['available', 'occupied', 'reserved', 'maintenance'];
            const choice = parseInt(statusChoice);
            
            if (isNaN(choice) || choice < 1 || choice > statuses.length) {
                console.log('Invalid choice.');
                rl.question('\nPress Enter to try again...', () => {
                    updateTableStatus();
                });
                return;
            }
            
            const newStatus = statuses[choice - 1];
            const success = tableService.updateTableStatus(tableId, newStatus);
            
            if (success) {
                console.log(`\nTable #${tableId} status updated to "${newStatus}".`);
            } else {
                console.log('\nFailed to update table status.');
            }
            
            rl.question('\nPress Enter to continue...', () => {
                tableManagement();
            });
        });
    });
}


// ======================= table management code ends here

// ======================= reservation Management start here
function reservationManagement() {
    const options = [
        'View All Reservations',
        'View Reservations by Date',
        'Create Reservation',
        'Update Reservation',
        'Delete Reservation'
    ];
    
    showMenu('RESERVATION MANAGEMENT', options, (choice) => {
        switch(choice) {
            case 1:
                viewAllReservations();
                break;
            case 2:
                viewReservationsByDate();
                break;
            case 3:
                createReservation();
                break;
            case 4:
                updateReservation();
                break;
            case 5:
                deleteReservation();
                break;
            case 0:
                mainMenu();
                break;
        }
    });
}

function viewAllReservations() {
    console.log('\n===== ALL RESERVATIONS =====');
    const reservations = reservationService.getAllReservations();
    
    if (reservations.length === 0) {
        console.log('No reservations available.');
    } else {
        reservations.sort((a, b) => new Date(a.date) - new Date(b.date));
        
        reservations.forEach(reservation => {
            const date = new Date(reservation.date).toLocaleString();
            console.log(`\nReservation #${reservation.id}`);
            console.log(`Name: ${reservation.customerName}`);
            console.log(`Date & Time: ${date}`);
            console.log(`Party Size: ${reservation.partySize}`);
            console.log(`Phone: ${reservation.phone}`);
            console.log(`Notes: ${reservation.notes || 'None'}`);
        });
    }
    
    rl.question('\nPress Enter to continue...', () => {
        reservationManagement();
    });
}

function viewReservationsByDate() {
    rl.question('\nEnter date (YYYY-MM-DD): ', (dateStr) => {
        // Validate date format
        const dateRegex = /^\d{4}-\d{2}-\d{2}$/;
        if (!dateRegex.test(dateStr)) {
            console.log('Invalid date format. Please use YYYY-MM-DD.');
            rl.question('\nPress Enter to try again...', () => {
                viewReservationsByDate();
            });
            return;
        }
        
        console.log(`\n===== RESERVATIONS FOR ${dateStr} =====`);
        const reservations = reservationService.getReservationsByDate(dateStr);
        
        if (reservations.length === 0) {
            console.log('No reservations found for this date.');
        } else {
            reservations.sort((a, b) => new Date(a.date) - new Date(b.date));
            
            reservations.forEach(reservation => {
                const time = new Date(reservation.date).toLocaleTimeString();
                console.log(`\nReservation #${reservation.id} - ${time}`);
                console.log(`Name: ${reservation.customerName}`);
                console.log(`Party Size: ${reservation.partySize}`);
                console.log(`Phone: ${reservation.phone}`);
            });
        }
        
        rl.question('\nPress Enter to continue...', () => {
            reservationManagement();
        });
    });
}

function createReservation() {
    rl.question('Enter customer name: ', (customerName) => {
        if (!customerName.trim()) {
            console.log('Customer name is required.');
            rl.question('\nPress Enter to try again...', () => {
                createReservation();
            });
            return;
        }
        
        rl.question('Enter phone number: ', (phone) => {
            if (!phone.trim()) {
                console.log('Phone number is required.');
                rl.question('\nPress Enter to try again...', () => {
                    createReservation();
                });
                return;
            }
            
            rl.question('Enter party size: ', (partySizeStr) => {
                const partySize = parseInt(partySizeStr);
                
                if (isNaN(partySize) || partySize <= 0) {
                    console.log('Invalid party size. Please enter a positive number.');
                    rl.question('\nPress Enter to try again...', () => {
                        createReservation();
                    });
                    return;
                }
                
                rl.question('Enter date (YYYY-MM-DD): ', (dateStr) => {
                    // Validate date format
                    const dateRegex = /^\d{4}-\d{2}-\d{2}$/;
                    if (!dateRegex.test(dateStr)) {
                        console.log('Invalid date format. Please use YYYY-MM-DD.');
                        rl.question('\nPress Enter to try again...', () => {
                            createReservation();
                        });
                        return;
                    }
                    
                    rl.question('Enter time (HH:MM): ', (timeStr) => {
                        // Validate time format
                        const timeRegex = /^([01]?[0-9]|2[0-3]):[0-5][0-9]$/;
                        if (!timeRegex.test(timeStr)) {
                            console.log('Invalid time format. Please use HH:MM (24-hour format).');
                            rl.question('\nPress Enter to try again...', () => {
                                createReservation();
                            });
                            return;
                        }
                        
                        const dateTime = new Date(`${dateStr}T${timeStr}:00`);
                        
                        rl.question('Enter any special notes (or press Enter to skip): ', (notes) => {
                            const reservation = {
                                customerName,
                                phone,
                                partySize,
                                date: dateTime.toISOString(),
                                notes
                            };
                            
                            const createdReservation = reservationService.createReservation(reservation);
                            
                            if (createdReservation) {
                                console.log(`\nReservation #${createdReservation.id} created successfully.`);
                            } else {
                                console.log('\nFailed to create reservation.');
                            }
                            
                            rl.question('\nPress Enter to continue...', () => {
                                reservationManagement();
                            });
                        });
                    });
                });
            });
        });
    });
}

function updateReservation() {
    const reservations = reservationService.getAllReservations();
    
    if (reservations.length === 0) {
        console.log('\nNo reservations available to update.');
        rl.question('\nPress Enter to continue...', () => {
            reservationManagement();
        });
        return;
    }
    
    console.log('\n===== RESERVATIONS =====');
    reservations.forEach(reservation => {
        const date = new Date(reservation.date).toLocaleString();
        console.log(`Reservation #${reservation.id} - ${reservation.customerName} - ${date}`);
    });
    
    rl.question('\nEnter reservation ID to update: ', (reservationIdStr) => {
        const reservationId = parseInt(reservationIdStr);
        const reservation = reservations.find(r => r.id === reservationId);
        
        if (!reservation) {
            console.log('Invalid reservation ID.');
            rl.question('\nPress Enter to try again...', () => {
                updateReservation();
            });
            return;
        }
        
        console.log(`\nUpdating Reservation #${reservationId}:`);
        console.log(`Current Name: ${reservation.customerName}`);
        console.log(`Current Phone: ${reservation.phone}`);
        console.log(`Current Party Size: ${reservation.partySize}`);
        console.log(`Current Date & Time: ${new Date(reservation.date).toLocaleString()}`);
        
        rl.question('\nEnter new customer name (or press Enter to keep current): ', (customerName) => {
            const newName = customerName.trim().length === 0 ? reservation.customerName : customerName.trim();
            
            rl.question('Enter new phone number (or press Enter to keep current): ', (phone) => {
                const newPhone = phone.trim() === '' ? reservation.phone : phone;
                
                rl.question('Enter new party size (or press Enter to keep current): ', (partySizeStr) => {
                    let newPartySize = reservation.partySize;
                    
                    if (partySizeStr.trim() !== '') {
                        const parsedSize = parseInt(partySizeStr);
                        if (!isNaN(parsedSize) && parsedSize > 0) {
                            newPartySize = parsedSize;
                        } else {
                            console.log('Invalid party size. Keeping the current size.');
                        }
                    }
                    
                    const currentDate = new Date(reservation.date);
                    const currentDateStr = currentDate.toISOString().split('T')[0];
                    const currentTimeStr = currentDate.toTimeString().slice(0, 5);
                    
                    rl.question(`Enter new date (YYYY-MM-DD) (current: ${currentDateStr}): `, (dateStr) => {
                        const newDateStr = dateStr.trim() === '' ? currentDateStr : dateStr;
                        
                        // Validate date format if changed
                        if (dateStr.trim() !== '') {
                            const dateRegex = /^\d{4}-\d{2}-\d{2}$/;
                            if (!dateRegex.test(newDateStr)) {
                                console.log('Invalid date format. Keeping the current date.');
                                newDateStr = currentDateStr;
                            }
                        }
                        
                        rl.question(`Enter new time (HH:MM) (current: ${currentTimeStr}): `, (timeStr) => {
                            const newTimeStr = timeStr.trim() === '' ? currentTimeStr : timeStr;
                            
                            // Validate time format if changed
                            if (timeStr.trim() !== '') {
                                const timeRegex = /^([01]?[0-9]|2[0-3]):[0-5][0-9]$/;
                                if (!timeRegex.test(newTimeStr)) {
                                    console.log('Invalid time format. Keeping the current time.');
                                    newTimeStr = currentTimeStr;
                                }
                            }
                            
                            const newDateTime = new Date(`${newDateStr}T${newTimeStr}:00`);
                            
                            rl.question(`Enter new notes (current: ${reservation.notes || 'None'}): `, (notes) => {
                                const newNotes = notes.trim() === '' ? reservation.notes : notes;
                                
                                const updatedReservation = {
                                    customerName: newName,
                                    phone: newPhone,
                                    partySize: newPartySize,
                                    date: newDateTime.toISOString(),
                                    notes: newNotes
                                };
                                
                                const success = reservationService.updateReservation(reservationId, updatedReservation);
                                
                                if (success) {
                                    console.log(`\nReservation #${reservationId} updated successfully.`);
                                } else {
                                    console.log('\nFailed to update reservation.');
                                }
                                
                                rl.question('\nPress Enter to continue...', () => {
                                    reservationManagement();
                                });
                            });
                        });
                    });
                });
            });
        });
    });
}

function deleteReservation() {
    const reservations = reservationService.getAllReservations();
    
    if (reservations.length === 0) {
        console.log('\nNo reservations available to delete.');
        rl.question('\nPress Enter to continue...', () => {
            reservationManagement();
        });
        return;
    }
    
    console.log('\n===== RESERVATIONS =====');
    reservations.forEach(reservation => {
        const date = new Date(reservation.date).toLocaleString();
        console.log(`Reservation #${reservation.id} - ${reservation.customerName} - ${date}`);
    });
    
    rl.question('\nEnter reservation ID to delete: ', (reservationIdStr) => {
        const reservationId = parseInt(reservationIdStr);
        const reservation = reservations.find(r => r.id === reservationId);
        
        if (!reservation) {
            console.log('Invalid reservation ID.');
            rl.question('\nPress Enter to try again...', () => {
                deleteReservation();
            });
            return;
        }
        
        rl.question(`Are you sure you want to delete the reservation for ${reservation.customerName}? (y/n): `, (answer) => {
            if (answer.toLowerCase() === 'y') {
                const success = reservationService.deleteReservation(reservationId);
                
                if (success) {
                    console.log(`\nReservation #${reservationId} deleted successfully.`);
                } else {
                    console.log('\nFailed to delete reservation.');
                }
            } else {
                console.log('\nDeletion cancelled.');
            }
            
            rl.question('\nPress Enter to continue...', () => {
                reservationManagement();
            });
        });
    });
}


// ======================= reservation Management end here

mainMenu();