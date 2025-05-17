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