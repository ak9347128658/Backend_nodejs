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
// https://grok.com/chat/42e6ec80-58f4-4e92-a8bd-b6c57ae60c64