step: create folder
setp 2: app.js,models.js

execute interminal: npm init -y

Architecture Diagram

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


File structure

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