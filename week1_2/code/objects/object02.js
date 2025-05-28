// Object Prototypes and Inheritance:
// Defination: Prototypes are a fundamental feature of JavaScript that allows objects to inherit properties and methods from other objects. Every object in JavaScript has a prototype, which is itself an object. This enables a form of inheritance where properties and methods can be shared across multiple objects.


// Adding to Prototype:
// function Animal(name){
//     this.name = name;
// }

// // Animal.speak = function() {
// //     console.log(`${this.name} makes a sound.`);
// // };
// Animal.prototype.speak = function() {
//     console.log(`${this.name} makes a sound.`);
// }

// const animal = new Animal("Lion");

// console.log(animal.speak()); // Lion


// 2. Class-Based Inheritance:
class Animal {
    constructor(name){
        this.name = name;
    }
    speak() {
        console.log(`${this.name} makes a sound.`);
    }
}

// const animal = new Animal("Lion");
// console.log(animal.speak()); // Lion
class Dog extends Animal {
    constructor(name){
        super(name);
    }
    bark() {
        console.log(`${this.name} barks.`);
    }
}

const dog = new Dog("Rex");
console.log(dog.speak())
console.log(dog.bark()); // Rex barks.