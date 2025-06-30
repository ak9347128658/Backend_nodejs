// Multidimensional Arrays in JavaScript
// Defination: A multidimensional array in JavaScript is essentially an array of arrays. It’s a data structure where each element of the main array can itself be an array, allowing you to store data in a grid-like or tabular format (e.g., rows and columns for a 2D array) or even in more complex structures (e.g., 3D arrays for layers of grids). This is useful for representing matrices, tables, game boards, or any data with multiple dimensions

// Examples of Multidimensional Arrays
// 1. Student Grade Table (2D Array):
let grades = [
    [85, 90, 78], // Student 1: Math, Science, English
    [92, 88, 95], // Student 2: Math, Science, English
    [76, 85, 80]  // Student 3: Math, Science, English
]

const student1ScicenceMark = grades[0][1];
console.log(`Student 1's Science mark: ${student1ScicenceMark}`); // Output: 90

