// Inheritance in JavaScript:
// Inheritance allows a new object or class to inherit properties and methods from and existing one,promoting code resuse.In javascript, inheritance is achieved via prototypes or the extends keyword in classes.

// Example 1: Inheritance with Prototypes (using function constructor)
// function Animal(name){
//     this.name = name;
// }

// Animal.prototype.eat = function() {
//     console.log(`${this.name} is eating`);
// } 

// function Dog(name, breed){
//     Animal.call(this,name); // Call the parent constructor
//     this.breed = breed;
// }

// Dog.prototype = Object.create(Animal.prototype); // Inherit from Animal
// Dog.prototype.constructor = Dog;
// Dog.prototype.bark = function() {
//     console.log(`${this.name} is barking`);
// }

// const dog = new Dog('Buddy', 'Golden Retriever');

// dog.eat(); // Output: Buddy is eating
// dog.bark(); // Output: Buddy is barking

// Example 2: Inheritance with Classes (single level inheritance)
// class Vehicle {
//     constructor(brand){
//         this.brand = brand;
//     }
//     move() {
//         console.log(`${this.brand} is moving`);
//     }
// }

// class Car extends Vehicle {
//     // brand = 'Toyota';
//     constructor(brand, model){
//         super(brand); // Call the parent constructor eg: new Vehicle(brand)
//         this.model = model;
//     }
//     honk(){
//         console.log(`${this.brand} ${this.model} is honking`);
//     }
// }

// const car = new Car('Tata', 'Nexon');
// car.honk(); // Output: Tata Nexon is honking
// car.move(); // Output: Tata is moving

// Example 3:  Inheritance with Classes (Hierarchical Inheritance)
// Base User class

// class User {
//    constructor(name,email){
//         this.name = name;
//         this.email = email;
//    }

//    login() {
//       console.log(`${this.name} has looged in with email ${this.email}`);
//    }

//     logout() {
//         console.log(`${this.name} has logged out`);
//     }
// }

// // Admin class with extended behavior
// class Admin extends User {
//     constructor(name,email,permissions){
//          super(name,email);
//          this.permissions = permissions;
//     }

//     deleteUser(user){
//         console.log(`${this.name} has deleted user ${user.name}`);
//     }
//     // Overriding the login method
//     login() {
//       console.log(`Admin ${this.name} has logged in with elevated privileges`);
//     }
// }

// // customer class with custom methods
// class Customer extends User {
//     constructor(name,email,points){
//         super(name,email);
//         this.points = points;
//     }

//     purchase(item){
//        console.log(`${this.name} has purchased ${item} and now has ${this.points - 10} points left`);
//        this.points = this.points - 10;
//     }
// }

// const admin = new Admin('John Doe', 'johndoe@gmail.com', ['delete','edit']);
// admin.login(); // Output: Admin John Doe has logged in with elevated privileges
// admin.deleteUser({name: 'Jane Smith'}); // Output: John Doe has deleted user Jane Smith


// const customer = new Customer('Charlie Brown', 'charlie@site.com', 100);
// customer.login(); // Output: Charlie Brown has logged in with email
// customer.purchase('Laptop'); // Output: Charlie Brown has purchased Laptop and now has 90 points left
// customer.logout(); // Output: Charlie Brown has logged out

// Example 4: Inheritance with Classes (multiple level inheritance)
// Living things   ==> Animals  ==> Dog

// Base class (1st generation)
// class LivingThing {
//    constructor(){
//      this.alive = true;
//    }

//    breathe(){
//     console.log("Breathing...");
//    }
// }

// // 2nd generation class
// class Animal extends LivingThing {
//     constructor(name){
//         super(); // Call the parent constructor
//         this.name = name;
//     }

//     eat(){
//         console.log(`${this.name} is eating`);
//     }
// }

// // 3rd generation class
// class Dog extends Animal {
//     constructor(name,breed){
//         super(name);
//         this.breed = breed;
//     }

//     bark(){
//         console.log(`${this.name},the ${this.breed} is barking.`);
//     }
// }

// create instance of Dog or object
// const myDog = new Dog('Buddy', 'Golden Retriever');
// myDog.breathe();
// myDog.eat();
// myDog.bark(); // Output: Buddy, the Golden Retriever is barking.

// console.log("is Alive ?",myDog.alive); // Output: true