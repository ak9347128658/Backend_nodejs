// >> Objects Defination: A Javascript Object is a collection of key-value pairs,where key is are String(or symbols)  and values can be any data typeof,including other Objects,functions,arrays etc.Objects are used to represent real-world entities or store structured data.They are mutable ,dynamic and central to Javascript programming.

// Key Characteristics:
// Objects are unordered collections.
// Keys are unique; values can be of any type.
// Objects can have properties (data) and methods (functions).
// Objects support prototype-based inheritance.

// Topics Covered:
// Object Creation
// Accessing and Modifying Properties
// Object Methods
// Object Prototypes and Inheritance
// Object Property Descriptors
// Iterating Over Objects
// Object Methods (Built-in)
// Destructuring Objects
// Object Spread and Rest Operators
// JSON and Objects

// 1.Object Creation:
// By using Object Literal Notation
// const person = {
//    name: "Aman",
//     age: 30,
// }

// console.log(person); 

// 2.using the new Object()
// const car = new Object();
// car.make = "Toyota";
// // car.model = "Camry";
// car["model"] = "Camry";
// console.log(car); 

// 3.Constructor Functions:
// function Student(name,grade){
//     this.name = name;
//     this.grade = grade;
// } 

// const student1 = new Student("Aman", "A");
// const student2 = new Student("Ravi", "B");
// const student3 = new Student("Priya", "A+");

// console.log(student1);
// console.log(student2);
// console.log(student3);

// 4.Class Syntax (ES6):
// class Student {
//     constructor(name,grade){
//         this.name = name;
//         this.grade = grade;
//     }
// }

// const student1 = new Student("Aman", "A");
// const student2 = new Student("Ravi", "B");
// const student3 = new Student("Priya", "A+");

// console.log(student1);
// console.log(student2);
// console.log(student3);

// 5.Object.create() Method:
// const animalProto = {
//     speak() {
//         console.log(`Animal Speaks!`);
//     }
// }

// const dog = Object.create(animalProto);
// dog.breed = "Labrador";
// dog.speak = function() {
//     console.log(`Woof! I am a ${this.breed}`);
// };

// // console.log(dog); // { breed: 'Labrador' }
// dog.speak(); 

// Accessing and Modifying Properties of Objects:

// Example
// 1. Dot Notation Access:
// const user = {
//     name: "Charlie",
//     age: 28,
//     "user info": function() {
//         return `${this.name} is ${this.age} years old.`;
//     }
// }

// console.log(user.name);
// console.log(user.age);
// const userInfo = user["user info"]()
// console.log(userInfo); // Charlie is 28 years old.

// 2. Bracket Notation Access:
// const product = {
//     "item-name": "Laptop",
//     price: 1200,
// }

// const itemName = product["item-name"];
// console.log(itemName); // Laptop

// 3. Adding a Property:
// const phone = {
//     brand: "Apple"
// }

// phone.model = "iPhone 14";

// console.log(phone); 

// 4. Modifying a Property:
// const laptop = {
//     brand: "Dell",
//     price: 1000
// }

// laptop.price = 900; // Modifying the price property

// console.log(laptop); 

// 5. Deleting a Property:
// const employee = {
//     id: 101,
//     name: "Eve"
// }

// delete employee.id; // Deleting the id property

// console.log(employee); 

// Object Methods:
// Defination: Methods are functions that stored as object properties,allowing objects to perform actions
// Methods are defined as functions within an object. They can use this to access other properties of the same object, enabling dynamic behavior.

// Examples:
// 1.Basic Method
const calculator = {
    // add: (a, b) =>{
    //     return a + b;
    // }
    add(a, b){
        return a + b;
    }
}

// const sum = calculator.add(5, 10);
// console.log(sum);

// 2. Using this in a Method
// const person = {
//     name: "Frank",
//     greet(){
//         return `Hello, ${this.name}`;
//     }
// }

// console.log(person.greet());

// 3. Method with Parameters
// const rectangle = {
//     area(width, heigth){ 
//         return width * heigth;
//     }
// }

// const area = rectangle.area(5, 10);
// console.log(area);

// 4. Dynamic Method Assignment
// const game = {

// }
// game.start = function() {
//     return "Game started!";
// }

// console.log(game.start());

// Nested Objects: Objects can be nested ,meaning an object can contain other objects as properties. This allows for more complex data structures and relationships.
// Example1:
// const company = {
//     name: "TechCorp",
//     location: "New York",
//     employees: [
//         {
//           name: "Charlie",
//           position: "Developer",
//           skills: ["JavaScript", "React"],
//           address: {
//             street: "123 Tech Lane",
//             city: "New York",
//             zip: "10001"
//           }
//         },
//         {
//           name: "Bob",
//             position: "Designer",
//             skills: ["Photoshop", "Illustrator"],
//             address: {
//              street: "456 Design Ave",
//                 city: "New York",
//                 zip: "10002"   
//             }
//         }
//     ]
// }

// // Accessing Nested Objects properties
// const firstEmployee = company.employees[0];
// console.log(firstEmployee);
// console.log(firstEmployee.address.street);

