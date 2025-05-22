// 3. Arrays Searching and Testing:

// 1. find(callback): Returns the first element that satisfies a condition
// find method in array is used to find the first element in an array that satisfies a condition. It returns undefined if no elements satisfy the condition.

// example 1: Find a number greater then 10
// let numbers = [3,8,12,5,7,10,15,20];

// const foundNumber = numbers.find((num,index) => {
//    if(num > 10){
//        return true;
//    }
// });

// const foundNumber = numbers.find(num =>  num > 10);

// console.log(foundNumber); // Output: 12

// example 2: Find a user by  ID
const users = [
 {id: 1, name : "John"},
 {id : 2, name : "Bob"},
 {id: 3, name : "Charlie"}
]
// // find user with id 2
// const userWithId2 = users.find((user) => {
//     if(user.id === 4){
//         return true;
//     }
// })
// const userWithId2 = users.find(user => user.id === 2);

// console.log(userWithId2); // Output: {id: 2, name : "Bob"}

// example 3: Find a string that starts with "A"
// const someFruit = "Apple";
// const firstChar = someFruit.charAt(3);
// console.log(firstChar); // Output: A

// const names = ["Jack","amanda","John","Ashish"];
// const name = names.find(name => name.charAt(0) === "A");
// console.log(name); // Output: Amanda

// findIndex(callback): Returns the index of the first element that satisfies a condition

// example 1: Find index of a number greter then 10
// let numbers = [3,8,12,5,7,10,15,20];
// const index = numbers.findIndex((number,index) => {
//     if(number > 10){
//         return true;
//     }
// });
// const index = numbers.findIndex(num => num > 10);
// console.log("found Index ",index); // Output: 2
// console.log("found value:",numbers[index]); // Output: 12

// IndexOf(element,fromIndex): Returns the index of the first occurrence of an element in an array, or -1 if not found

// example 1: Find index of a number greater then 10
// let numbers = [3,8,12,5,7,10,15,10];

// const indexOFNumber = numbers.indexOf(10);

// console.log("found Index ",indexOFNumber); // Output: 6

// lastIndexOf(element,fromIndex): Returns the index of the last occurrence of an element in an array, or -1 if not found

// example 1: Last index of a number in an array
// let numbers = [1,2,3,2,4,2];

// const lastIndexOfNumber = numbers.lastIndexOf(2);
// console.log("Last Index of 2: ",lastIndexOfNumber); // Output: 5

// example 2: Last index of a string in an array
// const fruits = ["apple","banana","orange","banana","apple","grape"];

// const lastIndex = fruits.lastIndexOf("apple");

// console.log("Last Index of apple: ",lastIndex); // Output: 4

// inclues(element,fromIndex): Returns true if the array contains the specified element, false otherwise

// example 1: Check if an array contains a number
// let numbers = [1,2,3,4,5];
// console.log(numbers.includes(3)); // Output: true
// console.log(numbers.includes(6)); // Output: false

// example 2:
// const items = ["a","e","c","a","d","b"];
// console.log(items.includes("e",0));

// some(callback): Returns true if at least one element satisfies the condition, false otherwise
// The .some() method tests whether at least one element in the array passes the test implmeted by provided function.It returns:
// true if any element satisfies then condition
// false if no elements satisfy the condition

// Example 1: check if any number is greter then 10
// const numbers = [1, 4, 9,15];

// const result = numbers.some((number,index) => {
//     if(number > 10){
//         return true;
//     }
// })

// console.log(result); // Output: true

// Example 2: check if any string starts with "A"
// const names = ["Jack","amanda","John","Ashish"];

// const hasA = names.some(name => name.charAt(0) === "A");
// console.log(hasA); // Output: true

// every(callback): Returns true if all elements satisfy the condition, false otherwise
// The .every() method tests whether all elements in the array pass the test implemented by the provided function. It returns:

// Example 1: Check if all numbers are positive
// const numbers = [1, 4, 9, 15];
// const allPositive = numbers.every((number) => {
//    if(number > 0) {
//        return true;
//    }
// });

// console.log(allPositive); // Output: true

// Example 2: Check if all strings are less then 10 characters
// const words = ["apple", "banana", "kiwi", "grape"];

// const allShort = words.every((word) => {
//     if(word.length < 10){
//         return true;
//     }
// })

// console.log(allShort); // Output: true


// https://grok.com/chat/b4f514c0-4aae-478f-9fd0-64054c891c73