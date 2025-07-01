// Question 4: Restaurant Table Management System
// Implement a restaurant table management system using a 2D array to represent a dining area. Each element in the array represents a table, where 0 means the table is empty and 1 means it's occupied. Write functions to:

// Find the first available table for a party of a specific size
// Mark a table as occupied or empty
// Calculate the percentage of occupied tables

// Restaurant floor map (0 = empty, 1 = occupied)
let restaurantTables = [
  [1, 1, 0, 1],  // Row 0 (tables for 2 people)
  [1, 0, 0, 0],  // Row 1 (tables for 4 people)
  [0, 0, 1, 0]   // Row 2 (tables for 6 people)
];

const tableSizeByRow = {
    0: 2, // Row 0 has tables for 2 people
    1: 4, // Row 1 has tables for 4 people
    2: 6  // Row 2 has tables for 6 people
}

// Find the first available table that can fit the party
function findAvailableTable(tables, partySize) {
  for( let row = 0; row < tables.length; row++){
    if(tableSizeByRow[row] >= partySize){
      for(let col = 0; col < tables[row].length; col++){
         if(tables[row][col] === 0) {
            return {row ,col};
         }
      }
    }
    return null;
  }
}

function updateTableStatus(tables, row, col, isOccupied) {
  // Your code here
}



console.log(findAvailableTable(restaurantTables,1))