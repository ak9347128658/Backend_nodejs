// let allows reassigning values; const does not
// var is an older way of declaring variables and is not recommended 

// primitve types: string, number, boolean, null, undefined
// reference types: object, array, function

// let name = "John"; // string

// we call let as a variable
// name as reference to the value "John"
// = is the assignment operator
// John is the value
// console.log(name);

// name = "Doe"; // reassigning the value of name
// console.log(name);

// const age = 25; // number
// console.log(age);
// age = 30; // error: age is a constant and cannot be reassigned
// console.log(age);

// conclusion:
// let is for values that can change
// const is for values that cannot change


// 1. Primitive Data Types
// ==> String: Represents textual data encloed in a single ('') or double ("") quotes

// let name = "John Doe"; // String

// // ==> Number: Represents numeric values, both integers and floating-point numbers
// let age = 25; // Number
// let height = 5.9; // Number (floating-point)

// // ==> Boolean: Represents a logical entity and can have two values: true or false
// let isStudent = true; // Boolean
// let isEmployed = false; // Boolean

// // ==> Null: Represents the intentional absence of any object value. It is a primitive value that represents "nothing" or "no value"
// let emptyValue = null; // Null

// // ==> Undefined: Represents a variable that has been declared but has not yet been assigned a value. It is a type itself (undefined)
// let notAssigned; // Undefined

// 2. Non-Primitive Data Types

// ==> Object: Represents a collection of key-value pairs. Objects can store multiple values as properties

// let person = {
//     name: "John Doe",
//     age: 25,
//     isStudent: true
// }  // an object with properties name, age, and isStudent

// console.log(person)
// // print the value of name property
// console.log(person.name) // John Doe
// // print the value of age property
// console.log(person.age) // 25

// ==> Array: Represents a list-like collection of values. Arrays can store multiple values in a single variable
// let fruits = ["apple", "banana", "orange", "grape", "mango", "kiwi"] // an array of fruits
// console.log(fruits);

// how to print the first element of the array
// console.log(fruits[0]); // apple
// what is the index of grape
// console.log(fruits[3]); // grape

// Function: Represents a block of code that can be called and executed. Functions can take parameters and return values

// function helloworld() {
//     console.log("Hello, World!");
// }

// helloworld();
// helloworld();
// helloworld();
// helloworld();

// Function with parameters
// function greet(name) {
//     console.log("Hello, " + name + "!");
// }

// greet("John Doe");
// greet("Jane Smith");
// greet("Alice Johnson");

// Function with multiple parameters
// function add(a,b){
//     console.log(a + b);
// }

// add(5, 10); // 15

// function with mutiple parameters with different data types
// function add(a, b, c) {
//     console.log(a + b + c);
// }

// add(5, 10, 15.4); // 30


// Function with return value with parameters

// function calculateSquare(number) {
//     return number * number;
// }

// const calculatedSquareValue = calculateSquare(5); // 25
// const calculatedSquareValue2 = calculateSquare(10); // 100
// const calculatedSquareValue3 = calculateSquare(15); // 225
// console.log(calculatedSquareValue); // 25
// console.log(calculatedSquareValue2); // 100
// console.log(calculatedSquareValue3); // 225


// const calculateSquare = (a,b) => {
//     console.log("Calculating square of " + a + " and " + b);
//   return a * b;
// }

// const calculatedSquareValue = calculateSquare(5, 10); // 50
// console.log(calculatedSquareValue); // 50

// const calculateSquare = (a,b) => a * b;

// const calculatedSquareValue = calculateSquare(5, 10); // 50
// console.log(calculatedSquareValue); // 50



// Var: var is function scoped, meaning it is accessible within the function in which it is declared

// function exampleVar() {
//     let y =10;
//     var x = 20;
//     const z = 30;
//     if(true){
//        var x = 10;
//        let y = 20;
//        z = 40;
//     }
//     console.log(x);
//     console.log(y); // ReferenceError: y is not defined 
//     console.log(z); // ReferenceError: z is not defined
// }

// exampleVar(); // I am in true condition


// Javascript Conditional Control Statements: if ,else if, else, switch

// if(condition1){
//   // code to execute if condition1 is true then other 3 conditions will not be executed else if with condition2,condition3 and else 
// }else if(condition2){
//   // code to execute if condition2 is true then other 2 conditions will not be executed else if with condition3 and else also if condition1 will not be executed
// }else if(condition3){
//   // code to execute if condition3 is true then other 1 conditions will not be executed else if with condition2 and else also if condition1 will not be executed
// }else{
//   // code to execute if all conditions are false
// }

// let name = "EXAMPE NAME";

// if(name == "John Doe"){  // true
//     console.log("from if with condition1");
// }else if(name == "Jane Doe"){
//     console.log("from else if with condition2");
// }
// else if(name == "Jane Doe"){
//     console.log("from else if with condition3");
// }else{
//     console.log("from else with condition4");
// }

// console.log("i am executed.")


// Switch Statement
// syntax:

// switch(expression) {
//     case value1:
//         // code block to be executed if expression === value1
//         break;
//     case value2:
//         // code block to be executed if expression === value2
//         break;
//     default:
//         // code block to be executed if none of the cases match
// }

// let fruit = "banana";
// // switch statement will take less time comparing to if else statement
// switch (fruit) {
//     case "apple":
//         console.log("This is an apple.");
//         break;
//     case "banana":
//         console.log("This is a banana.");
//         break;
//     case "orange":
//         console.log("This is an orange.");
//         break;
//     default:
//         console.log("Unknown fruit.");
//         break;
// }

// example of switch statement with break and continue
let day = 3; 
let dayName = "tuesday";

switch (day) {
    case 1:
        dayName = "Monday";
        console.log("Today is Monday");
        break;
    case 2:
        dayName = "Tuesday";
        console.log("Today is Tuesday");
        break;
    case 3:
        dayName = "wed";
        if(false){
            break;
        }
    case 3:
        dayName = "Wednesday";
        console.log("Today is Wednesday");
        break;
    case 4:
        dayName = "Thursday";
        console.log("Today is Thursday");
        break;
    case 5:
        dayName = "Friday";
        console.log("Today is Friday");
        break;
    case 6:
        dayName = "Saturday";
        console.log("Today is Saturday");
        break;
    case 7:
        dayName = "Sunday";
        console.log("Today is Sunday");
        break;
    default:
        dayName = "Invalid day";
}


































