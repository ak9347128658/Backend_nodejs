// > Array: An array in javascript is a special type of object used to store mutlitple values in a single variable.Arrays are ordered collections of DataTransfer,where each value (called an elecment) is associated with an indexedDB(a numeric position starting from 0).Arrays are versatile and can hold any data type, including numbers, strings, objects, and even other arrays.

// Key Characteristics of Arrays:
// 1.Ordered: Elements are stored in a specifc order,accessible via indices(0,1,2,...).
// 2.Dynamic: Arrays can grow and shrink in size as elements are added or removed. 
// 3.Heterogeneous: Arrays can store different data types (e.g., numbers, strings, objects) in the same array.
// 4.Zero-based indexing: The first element is at index 0, the second at index 1, and so on.
// 5.Mutable: Arrays can be modified after creation (e.g., adding, removing, or changing elements).


// Creating an Array:
// 1. Array Literal Notation (Mosted common):
// let fruits = ['apple', 'banana', 'cherry'];

// console.log(fruits); // Output: ['apple', 'banana', 'cherry']

// 2. Array Constructor:
// let numbers = new Array(1,2,3);

// console.log(numbers); // Output: [1, 2, 3]

// 3. Array with Predefined Size:
// let emptyArray = new Array(5);
// console.log(emptyArray); // Output: [ <5 empty items> ]
// //adding values to the array
// emptyArray[0] = 1;
// emptyArray[1] = 2;
// emptyArray[2] = 3;
// emptyArray[3] = 4;
// emptyArray[4] = 5;
// console.log(emptyArray); // Output: [1, 2, 3, 4, 5]


// 5.Sparse Array:
// let sparseArray = [1, , 3]; // The second element is empty
// console.log(sparseArray); // Output: [1, <1 empty item>, 3]


// Accessing and Modifying Arrays:

// .Accessing Elements: use the index inside square brackets.Accessing
// let fruits = ['apple', 'banana', 'cherry'];
// console.log(fruits[1]); // Output: 'banana'
// console.log(fruits[2]);
// console.log(fruits[3]);


// Modifying Elements: Assign a new value to an index.
// let fruits = ['apple', 'banana', 'cherry'];
// console.log(fruits); // Output: 'banana'
// fruits[1] = 'mango';
// console.log(fruits); // Output: ['apple', 'mango', 'cherry']

// Accessing out-of-bounds indecies
// let arr = [1,2];
// console.log(arr[2]); // Output: undefined
// arr[2] = 3;
// console.log(arr); // Output: [1, 2, 3]
// arr[5] = 6;
// console.log(arr); // Output: [1, 2, 3, <2 empty items>, 6]


// Array Properties:
// 1. Length: The length property returns the number of elements in an array.
// let fruits = ['apple', 'banana', 'cherry', 'mango', 'orange', 'kiwi', 'grape', 'banana', 'cherry', 'mango', 'orange', 'kiwi', 'grape', 'banana', 'cherry', 'mango', 'orange', 'kiwi', 'grape', 'banana', 'cherry', 'mango', 'orange', 'kiwi', 'grape'];
// const lengthOfFruits = fruits.length;
// console.log(lengthOfFruits); // Output: 7

// Array Methods:
// 1. push(): Adds one or more elements to the end of an array and returns the new length of the array.
// let fruits = ['apple', 'banana' ];
// // console.log(fruits); // Output: ['apple', 'banana']
// fruits.push('cherry');
// // console.log(fruits); // Output: ['apple', 'banana', 'cherry']
// let lengthAfterPush = fruits.push('mango', 'orange');
// console.log(lengthAfterPush); // Output: ['apple', 'banana', 'cherry', 'mango', 'orange']

// 2. pop(): Removes the last element from an array and returns that element.
// let fruits = ['apple', 'banana', 'cherry'];
// const returnedValue = fruits.pop();
// console.log(returnedValue); // Output: 'cherry'
// console.log(fruits); // Output: ['apple', 'banana']

// 3. unshift(): Adds one or more elements to the beginning of an array and returns the new length of the array.
// let fruits = ['banana', 'cherry'];
// // console.log(fruits); // Output: ['banana', 'cherry']
// let lengthOfFruits = fruits.unshift('apple');
// console.log(lengthOfFruits); // Output: 3
// console.log(fruits); // Output: ['apple', 'banana', 'cherry']
// fruits.unshift('mango', 'orange');
// console.log(fruits); // Output: ['mango', 'orange', 'apple', 'banana', 'cherry']

// 4. shift(): Removes the first element from an array and returns that element.
// let fruits = ['apple', 'banana', 'cherry'];
// console.log(fruits); // Output: ['apple', 'banana', 'cherry']
// const firstElement = fruits.shift();
// console.log(firstElement); // Output: 'apple'
// console.log(fruits); // Output: ['banana', 'cherry']

// splice(): splice(start,deleteCount,...items):Adds/removes elements at a specific index.
// let fruits = ['apple', 'banana', 'cherry', 'mango', 'orange', 'kiwi', 'grape'];
// console.log(fruits); // Output: ['apple', 'banana', 'cherry', 'mango', 'orange', 'kiwi', 'grape']
// fruits.splice(0,3);
// console.log(fruits); // Output: ['apple', 'cherry']

// Iterating and Transforming Arrays:
// 1. forEach(): Executes a provided function once for each array element.
// let fruits = ['apple', 'banana', 'cherry', 'mango'];
// fruits.forEach((item,index) => {
//   console.log(`Index: ${index} , Value: ${item}`);
// });

// 2. map(): Creates a new array populated with the results of calling a provided function on every element in the calling array.
// let numbers = [1, 2, 3, 4, 5];
// console.log(numbers); // Output: [1, 2, 3, 4, 5]
// const doubledNumbers = numbers.map((item,index) => {
//   return item * 2;
// })
// console.log(doubledNumbers); // Output: [2, 4, 6, 8, 10]

// 3. filter(): Creates a new array with all elements that pass the test implemented by the provided function.
// example 1: Filter even numbers from an array
// let numbers = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10];
// const eventNumbers = numbers.filter((item,index) => {
//     const modulusValue = item % 2;
//   if(modulusValue === 0){
//     return item;
//   }
// });

// console.log(eventNumbers); // Output: [2, 4, 6, 8, 10]
// example 2: Filter Objects Based on a Property
// let users = [
//    {name: 'John', age: 12},  // object at index 0
//    {name: 'Jane', age: 30},  // object at index 1
//     {name: 'Jim', age: 14},  // object at index 2
//     {name: 'Jack', age: 35},
//     {name: 'Jill', age: 28}, 
// ]

// const adults = users.filter((user,index) => {
//     if(user.age >= 18){
//         return user;
//     }
// });
// console.log(adults);

