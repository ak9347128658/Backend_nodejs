// >> Loops are used in javascript to perform repeated taks based on a condition.Conditions typically return true or false.A loop will contine running until the defined condition return false.

// >> A loop allows you to execute a block of code multiple times based on a condition or a set of vlaues,reducing the need for repetitive manual coding and improving efficiency.

// Type of loops in javascript

// 1. For Loop
// 2. While Loop
// 3. Do While Loop
// 4. For In Loop
// 5. For Of Loop
// 6. ForEach Loop

// 1.For Loop:

// defination:Executes a block of code a specific number of times, typically used when the number of iterations is known.

// syntax:
// for(initialization; condition; increment/decrement) {
//     // code block to be executed
// }

// Initialization: Sets the starting point (e.g., let i = 0).
// Condition: Checked before each iteration; if true, the loop continues (e.g., i < 5).
// Increment/Decrement: Updates the loop variable after each iteration (e.g., i++).

// Example:
// for (let i = 0; i< 5;i++){
//     console.log(i);
// }


// 2 .Print Number from 1 to 10
// for (let i =1; i< 11;i++){
//     console.log(i);
// }

// 3. Sum of Numbers from 1 to 4   ==>  1 + 2 + 3 + 4 = 10

// let sum = 0;
// for(let i =1; i<=4;i++){
//     sum = sum + i;
// }

// console.log("Sum of Numbers from 1 to 4 is: " + sum); 


// 4. Print Even Numbers from 1 to 10 ==> 2 , 4 , 6 , 8 , 10
// for(let i = 2; i<=10; i = i +2){
//   console.log(i);
// }

// 5. Iterate Over an Array
// const fruits = ["apple", "banana", "Orange"];
// const length = fruits.length;
// console.log("Length of fruits array is: " + length);
// console.log(fruits[1]);
// for(let i =0; i<length; i++){
//     console.log(fruits[i]);
// }

// 6. Print Numbers in Reverse Order (5 to 1)
// for(let i = 5; i>= 1;i--){
//     console.log(i);
// }

// 5 Start Pattern Examples Using Nested For Loop

// Examples: 
// 1. Square Start Pattern
// Output:
// * * * * * 
// * * * * * 
// * * * * * 
// * * * * * 
// * * * * *
// for(let i = 0 ; i < 5; i++){  //0 ,1 ,2, 3, 4
//   let row = ""; 
//   for (let j = 0; j < 5; j++){
//     row += "* "; 
//   }
//     console.log(row);
// }

// 2. Right Triangle Star Pattern
// Output:
// * 
// * * 
// * * * 
// * * * * 
// * * * * *
// for(let i = 1 ; i<=5; i++){
//     let row = "";
//     for(let j =1;j<=i;j++){
//         row += "* ";
//     }
//     console.log(row);
// }

// 3. Inverted Right Triangle Star Pattern
// Output:
// * * * * * 
// * * * * 
// * * * 
// * * 
// *
// for (let i = 5; i >= 1; i--) {   // 5, 4, 3, 2, 1, 0
//   let row = "";
//   for (let j = 1; j <= i; j++) {  // if i = 5 , j = 1 to 5, if i = 4 , j = 1 to 4
//     row += "* ";             
//   }
//   console.log(row);
// }

// Practice Questions:

// 1.Pyramid Star Pattern (Centered)
// Output:
//         * 
//       * * * 
//     * * * * * 
//   * * * * * * * 
// * * * * * * * * *

// 2.Hollow Square Star Pattern
// Output:
// * * * * * 
// *       * 
// *       * 
// *       * 
// * * * * *

// 3.Sum of Even Numbers
// Task: Write a program to calculate the sum of all even numbers between 1 and 20 (inclusive).
// Expected Output: 110 (2 + 4 + 6 + ... + 20)
// Hint: Use a for loop to iterate from 1 to 20 and add numbers divisible by 2 to a sum variable.

// 4.Count Consonants in a String
// Task: Write a program to count the number of consonants in the string "javascript". Consider consonants as any letters except vowels (a, e, i, o, u).
// Expected Output: 6 (j, v, s, c, r, p, t are consonants)
// Hint: Iterate through the string and check if each character is not a vowel and is a letter.

// 5.Find the Smallest Number in an Array
// Task: Write a program to find the smallest number in the array [15, 3, 9, 1, 12, 7].
// Expected Output: 1
// Hint: Initialize a variable with the first array element and update it if a smaller number is found during iteration.

// 6.Generate Multiples of 5 in Reverse
// Task: Write a program to print all multiples of 5 from 50 down to 5 in reverse order.
// Expected Output:
// 50
// 45
// 40
// 35
// 30
// 25
// 20
// 15
// 10
// 5
// Hint: Use a for loop starting from 50 and decrement by 5 until 5.


// While loops
// Defination: A while loop continues to execute its code block as long as the given condition remsins true.if the condition becomes false,the loop stops.It's crucial to ensure the condition eventually becomes false to avoid infinite loops.

// syntax:

// while(condition) {
//     // code to execute
//     // update condition (eg. increment/decrement) 
// }


// Simple Logical Examples
// 1.Print Numbers from 1 to 5
// let i =1;  // initializing i
// while(i<=5){
//     console.log(i);
//     i++; // i = i+1;
// }
// 2.Sum of Numbers from 1 to 10
// let sum = 0;
// let i = 1;
// while(i <= 10){
//     sum +=i; // sum = sum + i;   
//     i++;  // i = i +1 ;
// }
// console.log("sum of 1 to 10 is :"+sum);

// 3.Find First Power of 2 Greater Than 100
// let num = 1;
// while(num <= 100){
//     num = num *2;
// }
// console.log(num);

// 4.Reverse a Number
// let num = 123;
// let reversed = 0;

// while(num > 0){
//    let digit = num % 10;
//    reversed = reversed * 10 + digit;
//    num = Math.floor(num / 10);  
// }

// console.log(reversed);

// Print a right-angled triangle of stars with 5 rows. by While Loop
// let i = 1;
// while (i <= 5) {
//     let row = "";
//     let j  =1 ;
//     while (j <= i){
//         row = row + "* ";
//         j++;
//     }
//     console.log(row);
//     i++;
// }


// Practice Question for While Loop:
// 1.Square Star Pattern
// Output:
// * * * * 
// * * * * 
// * * * * 
// * * * *

// 2.Print an inverted right-angled triangle of stars with 5 rows.
// Output:
// * * * * * 
// * * * * 
// * * * 
// * * 
// *

// 3.Print a centered pyramid of stars with 4 rows.
// Output:
//       * 
//     * * * 
//   * * * * * 
// * * * * * * *

// While Loop:
// >> Definition: A do..while loop in javascript is similar to a while loop,but guarantess that the code block executes at least onece before checking the condition.The Condition is checked after each iteration,unlike a while loop,which checks before.

// >> Syntax:
// do {
//   // Code to execute
//   // Update condition (e.g., increment/decrement)
// } while (condition);

// >> Example:

// 1.Print Numbers from 1 to 5
// let i = 1;
// do {
//     console.log(i);
//     i++;
// } while(i <= 5);

// 2.Count Characters in a String
// let str = "Hello, World!";
// let count = 0;
// let i =0;
// do {
//   if(str[i]) count++;
//   i++;
// }while(i < str.length);  // str.length = 13
// console.log("Number of characters in the string is: " + count);

// practice question for do while loop:

// 1. Generate Odd Numbers Up to 9
// Output: 1, 3, 5, 7, 9

// Nested do while loop:

// 1.Print an inverted right-angled triangle of stars with 5 rows.
// Output:
// * * * * * 
// * * * * 
// * * * 
// * * 
// *
// let i = 5;
// do {
//  let row = "";
//  let j = 1;
//   do{
//    row = row + "* ";
//     j++;
//   }while(j<=i);
//   console.log(row);
//     i--;
// }while(i>=1)

// Practice Question for nested do while loop:\
// 1.Print a 4x4 square of stars.
// Output:
// * * * * 
// * * * * 
// * * * * 
// * * * *

// 2.Hollow Square Star Pattern
// Output:
// * * * * * 
// *       * 
// *       * 
// *       * 
// * * * * *

// For In Loop:
// >> Definition: A for..in loop is used to iterate over the properties of an object or the elements of an array. It allows you to access each property or element by its key or index.

// >> Syntax:
// for (variable in object) {
//     // Code to execute for each property or element
// }

// Example:
// 1. Sum of Values in an Object
// const scores = { math: 90, english: 85, science: 95, history: 80, geography: 88 ,telugu: 95,hindi: 90};
// console.log(scores);
// console.log(scores.math);
// console.log(scores["math"]);
// let sum = 0;
// for (let subject in scores){
//     sum = sum + scores[subject];
// }
// console.log("Sum of all subjects is: " + sum);

// 2. Count properties in an Object
// const car = {brand: "Toyota", model: "Camry", year: 2020, color: "blue", price: 30000};
// let count = 0;
// for(let propKey in car){
//     count++;
// }
// console.log("Number of properties in the car object is: " + count);

// 3. Filter Properties by Value Type
// Task: Print only the properties of an object that have string values.
// const person = {name: "John", age: 30, city: "New York", isStudent: false};
// for(let key in person){
//    if(typeof person[key] === "string"){
//        console.log(key + ": " + person[key]);
//    }
// }

// Practice Question for For In Loop:
// 1. Build a Repeated Pattern Using Object Values:
// Task: Use Object Values to repeate a character (e.g., "*") for a visual representation.
// const sizes = { small: 3, medium: 5, large: 7 };
// Output:
// small: ***
// medium: *****
// large: *******

// For Of Loop:
// >> Definition: A for..of loop is used to iterate over iterable objects like arrays, strings, and other collections. It allows you to access each element directly without needing an index.
// >> Syntax:
// for (variable of iterable) {
//     // Code to execute for each element
// }

// Example:
// 1. Sum of Array Elements
// const expenses = [100, 200, 300, 400, 500];  // array is a iterable object type
// let sum = 0;
// for(let amount of expenses){
//   sum = sum + amount;
// }
// console.log("Sum of expenses is: " + sum);

// 2. Find Longest String in an Array
// const words = ["cat", "elephant", "dog", "giraffe"];
// let longestWord = "";
// for(let word of words){
//    if(word.length > longestWord.length){  // 7 > 7
//        longestWord = word;
//    }
// }

// console.log("Longest word is: " + longestWord);

// Array method to push elements into an array
// const numbers = [ ];
// console.log(numbers);
// numbers.push(1);
// numbers.push(4);
// numbers.push(3);
// numbers.push(2);
// console.log(numbers);

// 3. Filter Positive Numbers from an Array
// Task: Create a new Array containing only positive numbers from a given array.
// const numbers = [-5, 10, -3, 7, -1, 4];
// const positiveNumbers = [];
// for(let number of numbers){
//    if(number > 0){
//          positiveNumbers.push(number);
//    }
// }

// console.log("Positive numbers are: " + positiveNumbers);

// Break and Continue Statements:
// Definition

// Break:
// Exits the loop entirely, stopping further iterations, regardless of the loop’s condition.
// Used when a specific condition is met, and you want to terminate the loop immediately.
// Works in all loop types (for, while, do...while, for...in, for...of).
// Example: Stop searching an array once a target value is found.

// Continue:
// Skips the current iteration and proceeds to the next iteration of the loop, without exiting the loop.
// Used to bypass certain iterations based on a condition while continuing the loop.
// Works in all loop types.
// Example: Skip printing odd numbers in a loop that iterates from 1 to 10.

// >> syntax for break:
// for (let i = 0; i < n; i++) {
//   if (condition) {
//     break; // Exits the loop
//   }
// }

// >> syntax for continue:
// for (let i = 0; i < n; i++) {
//   if (condition) {
//     continue; // Skips to the next iteration
//   }
//   // Code here is skipped if continue is triggered
// }

// Example of break statement:
// 1. Find First Negative Number in an Array
// Task: Find and print the first negative nubmer in an Array,then stop;
// const numbers = [5,8,-3,10,-7,2];
// for(let number of numbers){
//   if(number < 0){
//     console.log("First negative number is: " + number);
//     break;
//   }
// }

// 2.Skip Vowels in a string (for..of)
// const str = "hello";
// for(let char of str){
//   if(char === "a" || char === "e" || char === "i" || char === "o" || char === "u"){
//     continue; // Skip vowels
//   }
//   console.log(char); // Print consonants
// }

// Practice Question for Break and Continue:
// 1. Skip Zero Values in an Array
// Task: Print non-zero values from an array, skipping any zeros.
// const measurements = [10, 0, 25, 0, 30, 15];
// write the code
// Output:
// 10
// 25
// 30
// 15

// 2. Limit Sum of Numbers(do..while)
// Task: Sum numbers from 1 until the sum exceeds 20,then stop.
// code
// Output:
// Sum exceeded 20: 21