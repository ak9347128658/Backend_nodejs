// >>Defination:In JavaScript, an object is a collection of key-value pairs, where keys are strings (or symbols) and values can be any data type, including numbers, strings, arrays, functions, or even other objects. Objects are used to store and organize data in a structured way, allowing you to represent real-world entities with properties and behaviors.

// key 1.Objects are created using curly braces {} or the new Object() constructor.Each Key-value pair is called a property, and if the value is a function,it's called a method.Objects are mutable,meaning their properties can be added,modified,or deleted after creation.

// Example 1: Creating a Simple Object
// Creating an object using object literal syntax:
// const person ={
//    name:"John",
//    age: 30,
//    greet: function(){
//       console.log(`Hello, my name is ${this.name}`);
//    },
//    getName: function(){
//       return this.name;  // in objects functions can be called as  methods
//    }
// }
// console.log(person);
// // Accessing properties:
// console.log(person.name); // Output: John
// console.log(person["age"]); // Output: 30
// // Calling a method:
// person.greet();

// const personName = person.getName();

// console.log(personName); // Output: John

// Example 2: Creating an Object with Constructor Function
// const car = new Object();
// console.log(car);
// car.brand = "Toyota";
// car["model"] = "Camry";
// car.year = 2020;
// car.start = function() {
//     console.log(`Starting the ${this.brand} ${this.model}`);
// };

// console.log(car);
// Accessing properties:
// console.log(car.brand); // Output: Toyota
// console.log(car.model); // Output: Camry
// console.log(car.start()); // Output: 2020

// key2: Objects can be nested, meaning a property’s value can be another object. This allows for complex data structures to represent hierarchical relationships.

// Example 1: Nested Objects
// const company = {
//     name: "Tech Corp",
//     location: "New York",
//     employees: [
//         {
//             name: "Alice",
//             position: "Developer",
//             skills: ["JavaScript", "React"],
//             address: {
//                 street: "123 Main St",
//                 city: "New York",
//                 zip: "10001"
//             }
//         },
//         {
//             name: "Bob",
//             position: "Designer",
//             skills: ["Photoshop", "Illustrator"]
//         }
//     ],
// }

// Accessing nested properties:
// console.log(company.employees[0].name); // Output: Alice

// console.log(company.employees[0].address.city); 

// Example 2: Nested Objects with Methods
// const school = {
//     name: "Green Valley High",
//     location: "California",
//     established: 1995,
//     students: [
//         {
//             name: "Emma",
//             age: 16,
//             subjects: ["Math", "Science"],
//             getDetails: function() {
//                 return `${this.name}, Age: ${this.age}`;
//             }
//         },
//         {
//             name: "Liam",
//             age: 17,
//             subjects: ["History", "Art"],
//             getDetails: function() {
//                 return `${this.name}, Age: ${this.age}`;
//             }
//         }
//     ],
// }

// Accessing nested properties and methods:
// console.log(school.students[1].getDetails());

// key 3:Properties can be added or deleted dynamically using assignment or the delete operator. This makes JavaScript objects highly flexible for runtime modifications.

// Example 1: Adding properties dynamically

// const laptop = {
//     brand: "Dell"
// }

// console.log(laptop); // Output: { brand: 'Dell' }
// laptop.model = "XPS 13";
// laptop.year = 2022;
// console.log(laptop); // Output: { brand: 'Dell', model: 'XPS 13', year: 2022 }

// Example 2: Deleting properties
// const phone = {
//     brand: "Samsung",
//     model: "Galaxy S21",
//     year: 2021,
//     color: "Black"
// }
// console.log(phone); // Output: { brand: 'Samsung', model: 'Galaxy S21', year: 2021, color: 'Black' }

// delete phone.color;
// console.log(phone); // Output: { brand: 'Samsung', model: 'Galaxy S21', year: 2021 }

// Key 4: Objects can be copied using methods like Object.assign() or the spread operator (...). However, this creates a shallow copy, meaning nested objects are still referenced rather than copied.

// Example 1: Shallow Copy using Object.assign()
// const original = {
//     name: "Eve",
//     details:{
//         age: 25,
//     }
// }
// console.log(original); // Output: { name: 'Eve', details: { age: 25 } }
// // const copy = Object.assign({}, original); // Using Object.assign() to create a shallow copy
// const copy = {...original}; // Using spread operator
// copy.name = "Charlie";

// console.log(original); // Output: { name: 'Eve', details: { age: 30 } }
// console.log(copy); // Output: { name: 'Charlie', details: { age: 30 } }

// Key 5:Object methods like Object.keys(), Object.values(), and Object.entries() allow iteration over properties. These are useful for inspecting or manipulating object data.

// object.keys() returns an array of keys of an object

// object.values() returns an array of values of an object

// object.entries() returns an array of key-value pairs of an object

// Example 1: Using Object.keys(), Object.values()

// const fruit = {
//     name: "Apple",
//     color: "Red",
//     weight: 150,
//     taste: "Sweet"
// }

// const fruitKeys = Object.keys(fruit);
// const fruitValues = Object.values(fruit);

// console.log(fruitKeys); // Output: ['name', 'color', 'weight', 'taste']
// console.log(fruitValues); // Output: ['Apple', 'Red', 150, 'Sweet']

// Example 2: Using Object.entries()
// const product = {
//     id: "P123",
//     name:"Mouse",
//     price: 25,
// }

// const productEntries = Object.entries(product);
// console.log(productEntries); // Output: [['id', 'P123'], ['name', 'Mouse'], ['price', 25]]

// console.log(productEntries[0][1]);

// for(const product of productEntries){
//   console.log(product[0], product[1]);
// }


// key 6: Objects can use computed property names ,allowing dynamic keys  creation.
// Example 1: Computed Property Names
// const perfix = "user_";
// const user = {
//     [perfix + "name"]: "John",
//     [perfix + "age"]: 30,
//     [perfix + "email"]: "john@gmail.com"
// }

// console.log(user); // Output: { user_name: 'John', user_age: 30, user_email: '

// key 7:Objects can be frozen or sealed to restrict modifications. Object.freeze() prevents all changes, while Object.seal() allows modifying existing properties but not adding or deleting.

// Example 1:Freezing an Object
// const config = {
//     host:"localhost",
//     port: 8080,
//     protocol: "http",
// }
// console.log(config); // Output: { host: 'localhost', port: 8080, protocol: 'http' }
// Object.freeze(config); // Freezing the object
// config.protocol = "https"; // Attempting to modify a frozen object
// config.timeout = 5000; // Attempting to add a new property
// config.port = 3000; // Attempting to modify an existing property
// console.log(config); // Output: { host: 'localhost', port: 8080, protocol: 'http' }

// Example 2: Sealing an Object
// const settings = {
//     theme: "dark",
//     notifications: true,
// }
// console.log(settings); // Output: { theme: 'dark', notifications: true }
// Object.seal(settings); // Sealing the object
// settings.theme = "light"; // Modifying an existing property
// delete settings.notifications; // Attempting to delete a property
// settings.language = "en"; // Attempting to add a new property
// console.log(settings); // Output: { theme: 'light', notifications: true, language: 'en' }


// Key 8:Objects can be used with prototypes to share properties and methods.Every object in javscript has a prototype,which is another object from which it inherits properties and methods.

// Example 1: Using Prototypes with Object.create()
// const animal = {
//     eat: function() {
//         console.log(`${this.name} is eating.`);
//     }
// }

// // console.log(animal); // Output: { eat: [Function: eat] }

// const dog = Object.create(animal); // Creating a new object with animal as prototype
// dog.name = "Buddy";
// dog.eat();

// const cat = Object.create(animal);
// cat.name = "Whiskers";
// cat.eat(); // Output: Whiskers is eating.

// Example 2:Using Object.create() with 3 Generations

// Generation 1: Grandparent
// const grandparent = {
//     lastName: "Smith",
//     greet: function() {
//         console.log(`Hello, I'm a ${this.lastName}`);
//     }
// }
// // Generation 2: Parent inherits from Grandparent
// const parent = Object.create(grandparent);
// parent.firstName = "John";
// parent.introduce = function() {
//     console.log(`Hi, I'm ${this.firstName} ${this.lastName}`);
// }

// // Generation 3: Child inherits from Parent

// const child = Object.create(parent);
// child.age = 10;
// child.name = "Alice";
// child.describe = function() {
//     console.log(`I'm ${this.name} ${this.lastName}, and I'm ${this.age} years old.`);
// }

// child.describe(); // Output: I'm Alice Smith, and I'm 10 years old.
// child.introduce(); // Output: Hi, I'm
// child.greet(); // Output: Hello, I'm a Smith

