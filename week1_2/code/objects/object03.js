// Iterating Over an Object
// Defination:objects can be iterated using loops or methods like for...in, Object.keys(), Object.values(), or Object.entries().

// Examples:
// 1. Using for...in Loop:
// const person = {
//     name: "Jack",
//      age: 40
// }

// for(let key in person){
//   console.log(`${key} : ${person[key]}`)
// }
// nested for...in loops on objects
// const person = {
//     name: "Jack",
//     age: 40,
//     address: {
//         city: "New York",
//         zip: "10001"
//     }
// };

// for(let key in person) {
//     if(typeof person[key] === 'object'){
//         console.log(`${key} : `);
//         for(let subKey in person[key]) {
//             console.log(`  ${subKey} : ${person[key][subKey]}`);
//         }
//     }else{
//         console.log(`${key} : ${person[key]}`);
//     }
// }

// 2. Using Object.keys():
// const book = {
//     title: "JavaScript Basics",
//     author: "John Doe",
//     year: 2021
// }

// const keys = Object.keys(book);
// console.log(keys);

// 3. Using Object.values():
// const scores = {
//     math: 90,
//     science: 85,
//     english: 88
// }

// const values = Object.values(scores);
// console.log(values);

// let sum = 0;
// for(let score of values){
//     sum = sum + score;
// }

// console.log(`Total Score: ${sum}`);

// 4. Using Object.entries():
// const car = {
//     make: "Honda",
//     model: "Civic",
// }

// const entries = Object.entries(car);

// for(let [key,value] of entries){
//     console.log(`${key} : ${value}`);
// }

// // console.log(entries);

// Object Methods (Built in)
// JavaScript provides built-in methods on the Object constructor for manipulating objects, like Object.assign(), Object.freeze(), etc.

// Example:
// 1. Using Object.assign():
// const target = { a : 1};
// const source = { b: 2}

// Object.assign(target, source);

// console.log(target);

// 2. Using Object.freeze():
// const user = {
//    name: "Charlie",
//    age: 30
// }

// console.log("Before ",user);

// Object.freeze(user);

// user.age = 35; 
// user.city = "New York"; // Adding a new property

// console.log("After ",user);

// What Object.freeze() Does:
// Prevents adding new properties.

// Prevents removing existing properties.

// Prevents changing values of existing properties.

// Prevents changing the prototype.

// example 2 on Object.freeze():

// const person = {
//     name: "Bob",
//     address: {
//         city:"London"
//     }
// }

// console.log("Before ", person);

// Object.freeze(person);

// person.name = "Charlie";
// person.address.city = "Paris"; // ✅ This works because `address` is not frozen

// console.log("After ", person); 

// If you want to deeply freeze an object, you’ll need to recursively freeze its properties:

// Example:  Deep Freeze Utility Function

// function deepFreeze(obj){
//     Object.freeze(obj);
//     for(const key in obj){
//         if(typeof obj[key] === 'object' && obj[key] !== null && !Object.isFrozen(obj[key])){
//             deepFreeze(obj[key]);
//         }
//     }
// }

// const user2 = {
//     name: "Charlie",
//     address: {
//        city: "Berlin"
//     }
// }

// deepFreeze(user2);

// console.log("Before ", user2);

// user2.address.city = "London"; // This will work because `address` is not frozen

// console.log("After :",user2);

//  Object.seal() in JavaScript

// ✅ Existing properties can still be changed.

// ❌ New properties cannot be added.

// ❌ Existing properties cannot be deleted.

// ✅ Property values can still be modified (if writable).

// const car = {
//    brand: "Toyota",
//    year: 2020,
// }

// console.log("Before :",car);

// Object.seal(car);

// car.year = 2024;

// car.color = "Red";

// delete car.brand;

// console.log("After :",car);

// Object.hasOwnProperty() in JavaScript

// const person = {
//     name: "Charlie"
// }

// console.log(person.hasOwnProperty("name"));
// console.log(person.hasOwnProperty("age"));