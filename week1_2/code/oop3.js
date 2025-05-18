// Polymorphism: Polymorphism allows objects of different types to be treated as instances of a common type,often by overriding inherited methods to provide specific behavior.

// Example 1: Polymrophism with method overriding
// class Shape{
//     constructor(){

//     }
//     getArea() {
//         return 0;
//     }
// }

// class Circle extends Shape{
//     constructor(radius){
//         super();
//         this.radius = radius;
//     }
//     getArea() {
//         return Math.PI * this.radius * this.radius;
//     }
// }

// class Rectangle extends Shape{
//     constructor(width, height){
//         super();
//         this.width = width;
//         this.height = height;
//     }
//     getArea() {
//         return this.width * this.height;
//     }
// }

// const circle = new Circle(5);
// const rectangle = new Rectangle(4, 6);

// console.log(circle.getArea()); // Output: 78.53981633974483
// console.log(rectangle.getArea()); // Output: 24

// Example 2: Polymorphism
// class Notification {
//     constructor(receiver){
//         this.receiver = receiver;
//     }

//     send(){
//         console.log(`Sending notification to ${this.receiver}`);
//     }
// }

// class SMSNotification extends Notification {
//     constructor(receiver, message){
//         super(receiver);
//         this.message = message;
//     }

//     send(){
//         console.log(`Sending SMS to ${this.receiver}: ${this.message}`);
//     }
// }

// const smsNotification = new SMSNotification('Jane Doe', 'Hello Jane!');

// smsNotification.send(); // Output: Sending SMS to Jane Doe: Hello Jane!

// Abstraction:Abstraction hides complex implementation details and exposes only the necessary parts of an object.in javascript,abstraction can be achieved by defining clear interfaces(e.g., methods) while keeping internal logic private.

// Example 1: Abstraction with Classes
// class CoffeeMachine {
//     #waterLevel =0;
//     addWater(amount){
//         this.#waterLevel = this.#waterLevel + amount;
//         console.log(`Added ${amount}ml of water. Current water level: ${this.#waterLevel}ml`);
//     }
//     makeCoffee() {
//         if(this.#waterLevel >=100){
//             this.#waterLevel = this.#waterLevel - 100;
//             console.log('Making coffee...');
//         }else{
//             console.log('Not enough water to make coffee.');
//         }
//     }
// }

// const machine = new CoffeeMachine();
// machine.addWater(50); // Output: Added 200ml of water. Current water level: 200ml
// machine.makeCoffee(); // Output: Making coffee...
// machine.addWater(100); // Output: Making coffee..
// machine.makeCoffee(); // Output: Not enough water to make coffee.

// Static methods in Javascript:
// Static methods are called on the class itself, not on instances of the class. They are often used for utility functions or factory methods that don't require access to instance properties.

class CoffeeMachine {
    #waterLevel =0;

    static startMachine() {
        console.log('Coffee machine started');
    }

    addWater(amount){
        this.#waterLevel = this.#waterLevel + amount;
        console.log(`Added ${amount}ml of water. Current water level: ${this.#waterLevel}ml`);
    }
    makeCoffee() {
        if(this.#waterLevel >=100){
            this.#waterLevel = this.#waterLevel - 100;
            console.log('Making coffee...');
        }else{
            console.log('Not enough water to make coffee.');
        }
    }
}

CoffeeMachine.startMachine(); // Output: Coffee machine started

const machine = new CoffeeMachine();
machine.addWater(50); // Output: Added 200ml of water. Current water level: 200ml
machine.makeCoffee(); // Output: Making coffee...
machine.addWater(100); // Output: Making coffee..
machine.makeCoffee(); // Output: Not enough water to make coffee.