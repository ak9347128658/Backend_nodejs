// Defination of object:
// In javascript,an object is a collection of key-value pairs,where keys are strings(Or Symbols) and values can be of any data type,including SVGAnimatedNumberList,strings,arrays,functions,or even other objects.Objects are used to stroe and orgaizedata in a structured way,allowing for easy access and manipulation of data.

// >>1. Objects are created using curly braces {} or the new Object() constructor.Each key-value pair is called a property,and if the value is a function,it's called as method.Objects are mutable ,meaning their property can be added,modified,or deleted after creation.


// Example 1:creating a simple Object
// Creating an object using object literal syntax
// const person = {
//     name: "John",
//     age: 25,
//     greet: function() {
//       console.log(`Hello,my name is ${this.name}`);  
//     }
// }

// console.log(person.age);
// console.log(person["name"]);
// person.greet();

// Example 2: Using new Object() constructor
// const car = new Object();

// car.brand = "Toyota";

// car["model"] = "Camry";

// car.year = 2020;

// car.drive = function() {
//     console.log(`Driving a ${this.year} ${this.brand} ${this.model}`);
// }

// console.log(car.brand);
// console.log(car["model"]);
// car.drive();

// Example 3: object with function which retuns an value
// const calculator = {
//    num1: 10,
//     num2: 5,
//     add: function() {
//         return this.num1 + this.num2;
//     },
//     subtract: function() {
//         return this.num1 - this.num2;
//     },
// }

// const calculatedValue = calculator.add();
// console.log(calculatedValue); // Output: 15

// 2.Objects can be nested,meaning a property's value can be another object.This allows tor complex data structures to represnt hieratchical relationships.

// 1.Example:Nested objects
// const company = {
//    name: "Tech Corp",
//    address: {
//     street:"123 Main St",
//     city: "New York",
//     state: "NY",
//     zip: {
//         code: 10001,
//         country: {
//             name: "USA",
//             code: "US"
//         }
//     }
//    } 
// }

// // console.log(company.address.city); // Output: New York
// console.log(company.address.zip.country.code);
// console.log(company["address"]["zip"]["country"]["name"]); // Output: USA

// 2.Example:Nested objects with methods
// const school = {
//     name: "Greenwood High",
//     principal: {
//         name:"Dr. Smith",
//         welcome: function() {
//             console.log(`Welcome to ${this.name}`);
//         }
//     }
// }

// school.principal.welcome();

// 3.Example:Deleting Properties
// const phone = {
//     brand: "Samsung",
//     model: "Galaxy S21",
//     color: "Black",
//     features: {
//         camera: "108MP",
//         battery: "4000mAh"
//     }
// }
// console.log("Phone object after delete color:",phone);
// delete phone.color;
// console.log("Phone object after delete color:",phone);


// 3.Objects can be copied using methods like object.assign() or the spread operator(...).However,these create shallow copies,meaning nested objects are still referenced ,not duplicated.

// 1.Example:Shallow copy with Object.assign()
// const original = {
//     name: "Eve",
//     details:{
//         age: 30,
//         city: "Los Angeles"
//     }
// }
// const copy = Object.assign({}, original); // or const copy = {...original};
// // const copy = original;

// copy.name ="Fiona";
// copy.details.age = 35;

// console.log(original);
// console.log(copy);

// 4.Objects methods like object.keys(),object.values(), and object.entries() allow iteration over properties.These are useful for inspecting or manipulating object data.

// 1.Example: using object.keys() and object.values()
// const fruit = {
//     name: "Apple",
//     color: "Red",
//     taste: "Sweet",
//     weight: 150,
// }

// const keys = Object.keys(fruit);
// const values = Object.values(fruit);

// console.log("Keys of fruit object:",keys);
// console.log("Values of fruit object:",values);

// 2.Example: using object.entries()
// const product = {
//     id: "P123",
//     name: "Mouse",
//     price: 25,
// }
// for(const [key,value] of Object.entries(product)){
//     console.log(`${key}: ${value}`);
// }

// 5.Objects can use computed property names,allowing dynamic keys creation.This is done using square brackets in objewct literals, e.g., {[key]: value}.

// 1.Example: Computed property names
// const prefix = "user_";

// const user = {
//     [prefix + "name"]: "Alice",
//     [prefix + "age"]: 28,
//     [prefix + "email"]: "email@gmail.com"
// }

// console.log(user);

// 6.objects can be frozen or sealed to restrict modifications. object.freeze() prevents all changes,while object.seal() allows modifying existing properties but not adding or deleting.

// 1.Example:Freezing an object
// const config = {
//     host: "localhost",
//     port: 8080,
// }
// Object.freeze(config);
// config.port = 3000; // This will not change the port
// config.timeout = 5000; // This will not add a new property
// console.log(config); // Output: { host: 'localhost', port: 8080 }

// 2.Example:Sealing an object
// const settings = {
//     theme: "dark",
//     notifications: true,
// }

// Object.seal(settings);
// settings.theme = "light"; // This will change the theme
// settings.language = "en"; // This will not add a new property
// delete settings.notifications; // This will not delete the property
// console.log(settings); // Output: { theme: 'light', notifications: true }

// 7.objects can be used with prototypes to share propeties and methods.Every object in javascript has a prototype,which is another object from which it inherits properties and methods.You can create inheritance like structures using Object.create() to specify a prototype or by using constructor functions with the prototype property.

// 1.Example: Using prototypes with object.create()
// const animal = {
//     eat: function(){
//         console.log(`${this.name} is eating`);
//     }
// }

// const dog = Object.create(animal);
// dog.name = "Buddy";
// dog.bark = function(){
//     console.log(`${this.name} is barking`);
// }

// dog.eat(); // Output: Buddy is eating

// // i have diffent animal
// const cat = Object.create(animal);
// cat.name = "Whiskers";
// cat.meow = function(){
//     console.log(`${this.name} is meowing`);
// }

// cat.eat(); // Output: Whiskers is eating

// 2.Example: Constructor Functions and Prototypes
function Cat(name){
    this.name = name;
}
Cat.prototype.meow = function(){
    console.log(`${this.name} is meowing`);
}
const luna = new Cat("Luna");
const whiskers = new Cat("Whiskers");
const kitty = new Cat("Kitty");
const tommy = new Cat("Tommy");
luna.meow(); // Output: Luna is meowing

