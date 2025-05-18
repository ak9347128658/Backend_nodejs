// >Defination:Prototyping in JavaScript is a mechanism that allows objects to inherit properties and methods from other objects. Every JavaScript object has a prototype, which is another object from which it can inherit properties and methods. The prototype property of a constructor function or an object serves as a blueprint for creating new instances, enabling shared behavior and efficient memory usage. This is central to JavaScript's object-oriented programming, as it facilitates inheritance without traditional classes (prior to ES6). Prototypes form a chain, known as the prototype chain, where an object can access properties and methods from its prototype, and the prototype's prototype, until it reaches null.

// const person1 = {
//     name: "John",
//     write: function() {
//         console.log("Hello, my name is " + this.name+ ". I am person1 and i can write.");
//     }
// }

// const person2 = {
//     name: "Jane",
//     see: function() {
//         console.log("Hello, my name is " + this.name+ ". I am person2 and i can see.");
//     },
    
//     __proto__: person1
// }

// console.log(person2.write());

// Example 1: Basic Prototype Property Access

// function Person(name){
//     this.name = name;
// }

// Person.prototype.greet = function() {
//     console.log("Hello, my name is " + this.name);
// }
// const john = new Person("John");

// john.greet(); // Output: Hello, my name is John

// Example 2: checking Prototype Property

// function Car(brand){
//    this.brand = brand;
// }
// Car.prototype.model = "Sedan";

// const myCar = new Car("Toyota");
// console.log(myCar.model); // Output: Toyota

// console.log(myCar.hasOwnProperty("model")); // Output: false

// 1. Naming Convention:
// By convention in JavaScript:

// animal (lowercase) → Used for regular functions or factory functions.

// Animal (PascalCase) → Used for constructor functions or classes.


// class Car{
//     constructor(name){
//         this.name = name;
//     }
// }

// Car.prototype.model = "Sedan";

// const myCar = new Car("Toyota");
// console.log(myCar.model); // Output: Sedan
// console.log(myCar.hasOwnProperty("model")); // Output: false


// Example 3: Dynamic Prototype Update

// function Animal(type){
//     this.type = type;
// }
// or
// class Animal {
//     constructor(type){
//         this.type = type;
//     }
// }

// const dog = new Animal("Dog");
// Animal.prototype.sound = function() {
//     return `${this.type} makes a sound`;
// }

// console.log(dog.sound()); // Output: Dog makes a sound

// Example 4: Overriding Prototype Property

// function Book(title){
//     this.title = title;
// }
// or
// class Book {
//     constructor(title){
//         this.title = title;
//     }
// }

// Book.prototype.getTitle = function() {
//     return this.title;
// }

// const myBook = new Book("Javascipt Guide");
// myBook.getTitle = function() {
//     return "Overridden Title: " + this.title;
// }

// // console.log(myBook.getTitle()); // Output: Overridden Title: Javascipt Guide

// const otherBook = new Book("Python Guide");

// // console.log(otherBook.getTitle()); // Output: Python Guide

// console.log(myBook);

// console.log(otherBook);









