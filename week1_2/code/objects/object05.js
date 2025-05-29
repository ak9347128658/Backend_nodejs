// JSON and Objects
// JSON (javascript object Notation) is a format for representing objects as string,and javascript provides methods to convert between objects and JSON

// JSON.stringify() converts objects to JSON strings, and JSON.parse() converts JSON strings back to objects. Not all objects are JSON-serializable (e.g., functions are excluded).

// Example:
// 1. Convert Object to JSON String

// const user = {
//     name: "Yara",
//     age: 29
// }
// console.log("Before JSON.stringify():", user.name);

// console.log("Type of user :", typeof user);

// const json = JSON.stringify(user);

// console.log("JSON String:", json);
// console.log("Type of JSON String:", typeof json);

// 2.Parse JSON to Object:
// const jsonString = '{"name":"Zara","age":32}';

// console.log("JSON String:", jsonString);

// const parsedObject = JSON.parse(jsonString);

// console.log("Parsed Object:", parsedObject);

// 3. Stringify with Formatting:
const data = {name:"Zoe",scores:[85, 90, 95]};
const formatted = JSON.stringify(data,null,2); // Pretty print with 2 spaces indentation
console.log("Formatted JSON String:", formatted);