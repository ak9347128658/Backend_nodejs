
//  One-Dimensional Array 
// +-----+-----+-----+-----+-----+
// |  0  |  1  |  2  |  3  |  4  |
// +-----+-----+-----+-----+-----+

// Two-Dimensional Array

//          Columns
//       0     1     2     3
//     +-----+-----+-----+-----+
//   0 | 1,0 | 1,1 | 1,2 | 1,3 |
//     +-----+-----+-----+-----+
// R 1 | 2,0 | 2,1 | 2,2 | 2,3 |
// o   +-----+-----+-----+-----+
// w 2 | 3,0 | 3,1 | 3,2 | 3,3 |
// s   +-----+-----+-----+-----+
//   3 | 4,0 | 4,1 | 4,2 | 4,3 |
//     +-----+-----+-----+-----+


// Defination: Multidimensional arrays are arrays that contain other arrays as elements. They allow you to organize data in multiple dimensions, making them ideal for representing complex data structures like tables, matrices, grids, and more. In backend development with Node.js, multidimensional arrays are frequently used for data processing, analysis, and storage.


// Creating Mutidimensional Arrays
// 1. Creting a 2D Array (Matrix)
// let matrix =[
// [1,2,3], // Row 0
// [4,5,6], // Row 1
// [7,8,9] // Row 2
// ]

// console.log(matrix[1][1])
// console.log(matrix[2][2])

// Method 2: creating an empty 2D array and filling it
// let rows = 3;
// let columns = 4;
// let grid = [];
// //grid = [ [0,0,0,0],[] ]
// for (let i =0;i < rows; i++){
//     grid[i] = [];
//     for (let j =0; j< columns; j++){ 
//         grid[i][j] = 0;
//     }
// }

// console.log(grid);

// 2. Creating a 3D Array

// let cube = [
//     [
//         [1, 2],  // Row 0
//         [3, 4],  // Row 1
//         [5, 6]   // Row 2
//     ],
//     [
//         [7, 8],   // Row 0
//         [9, 10],  // Row 1
//         [11, 12]  // Row 2
//     ]
// ]

// // console.log(cube[1][1][1])
// console.log(cube[0][1][1])

// Modifying Elements in Multidimensional Arrays

// let matrix = [
//     [1, 2, 3], // Row 0
//     [4, 5, 6], // Row 1
//     [7, 8, 9]  // Row 2
// ]

// // console.log(matrix);
// // matrix[0][1] = 20;
// // console.log(matrix); // Output: 20

// console.log(matrix);
// matrix[1] = [10, 11, 12]; // Replacing the entire second row
// console.log(matrix); 

// Iterating Through Multidimensional Arrays
// verical are columns and horizontal are rows
let matrix = [
    [1, 2, 3], // Row 0
    [4, 5, 6], // Row 1
    [7, 8, 9,10]  // Row 2
]



// console.log(matrix[0].length); 
// for(let i =0 ; i< matrix.length ; i++){
//    for(let j =0 ; j< matrix[i].length; j++){
//          console.log(`Element at row ${i}, column ${j} is: ${matrix[i][j]}`);
//    } 
// }

// matrix.forEach((row, rowIndex) => {
//     row.forEach((element, colIndex) => {
//         console.log(`Element at row ${rowIndex}, column ${colIndex} is: ${element}`);
//     });
// });


// console.log(...matrix.entries());

for(const [rowIndex, row] of matrix.entries()){
    for(const [colIndex,element] of row.entries()){
        console.log(`Element at row ${rowIndex}, column ${colIndex} is: ${element}`);
    }
}