const readline = require("readline");
const {menuService} = require("./models.js");
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
        //   orderManagement();
            break;
       case 3:
        //   tableManagement();
            break;
       case 4:
            // reservationManagement();
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
                        menuManagement();
                    });
                });
            });
        });
    });
}


mainMenu();