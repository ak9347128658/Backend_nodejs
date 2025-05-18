Polymorphism: Polymorphism allows objects of different types to be treated as instances of a common type, often by overriding inherited methods to provide specific behavior.

Example 1: Polymorphism with method overriding
```js
class Shape {
    constructor() {}
    getArea() {
        return 0;
    }
}

class Circle extends Shape {
    constructor(radius) {
        super();
        this.radius = radius;
    }
    getArea() {
        return Math.PI * this.radius * this.radius;
    }
}

class Rectangle extends Shape {
    constructor(width, height) {
        super();
        this.width = width;
        this.height = height;
    }
    getArea() {
        return this.width * this.height;
    }
}

const circle = new Circle(5);
const rectangle = new Rectangle(4, 6);
console.log(circle.getArea()); // Output: 78.53981633974483
console.log(rectangle.getArea()); // Output: 24
```

Example 2: Polymorphism
```js
class Notification {
    constructor(receiver) {
        this.receiver = receiver;
    }
    send() {
        console.log(`Sending notification to ${this.receiver}`);
    }
}

class SMSNotification extends Notification {
    constructor(receiver, message) {
        super(receiver);
        this.message = message;
    }
    send() {
        console.log(`Sending SMS to ${this.receiver}: ${this.message}`);
    }
}

const smsNotification = new SMSNotification('Jane Doe', 'Hello Jane!');
smsNotification.send(); // Output: Sending SMS to Jane Doe: Hello Jane!
```

Abstraction: Abstraction hides complex implementation details and exposes only the necessary parts of an object. In JavaScript, abstraction can be achieved by defining clear interfaces (e.g., methods) while keeping internal logic private.

Example 1: Abstraction with Classes
```js
class CoffeeMachine {
    #waterLevel = 0;
    addWater(amount) {
        this.#waterLevel += amount;
        console.log(`Added ${amount}ml of water. Current water level: ${this.#waterLevel}ml`);
    }
    makeCoffee() {
        if (this.#waterLevel >= 100) {
            this.#waterLevel -= 100;
            console.log('Making coffee...');
        } else {
            console.log('Not enough water to make coffee.');
        }
    }
}

const machine = new CoffeeMachine();
machine.addWater(50); // Output: Added 200ml of water. Current water level: 200ml
machine.makeCoffee(); // Output: Making coffee...
machine.addWater(100); // Output: Making coffee..
machine.makeCoffee(); // Output: Not enough water to make coffee.
```

Static methods in JavaScript: Static methods are called on the class itself, not on instances of the class. They are often used for utility functions or factory methods that don't require access to instance properties.

```js
class CoffeeMachine {
    #waterLevel = 0;

    static startMachine() {
        console.log('Coffee machine started');
    }

    addWater(amount) {
        this.#waterLevel += amount;
        console.log(`Added ${amount}ml of water. Current water level: ${this.#waterLevel}ml`);
    }
    makeCoffee() {
        if (this.#waterLevel >= 100) {
            this.#waterLevel -= 100;
            console.log('Making coffee...');
        } else {
            console.log('Not enough water to make coffee.');
        }
    }
}

CoffeeMachine.startMachine(); // Output: Coffee machine started

const anotherMachine = new CoffeeMachine();
anotherMachine.addWater(50); // Output: Added 200ml of water. Current water level: 200ml
anotherMachine.makeCoffee(); // Output: Making coffee...
anotherMachine.addWater(100); // Output: Making coffee..
anotherMachine.makeCoffee(); // Output: Not enough water to make coffee.
```

### Practice Questions for above tops
### Practice Question 1: Polymorphism - Triangle Area
**Problem**: Create a `Triangle` class that extends the `Shape` class (from Polymorphism Example 1). The `Triangle` class should have `base` and `height` properties and override the `getArea` method to return `(base * height) / 2`. Instantiate a `Triangle`, a `Circle`, and a `Rectangle`, and log their areas.

**Hint**: Use the `Shape` class with a default `getArea` method. For `Triangle`, extend `Shape`, call `super()` in the constructor, and override `getArea` to compute the triangle’s area. Test polymorphism by calling `getArea` on different shapes.

---

### Practice Question 2: Polymorphism - Email Notification
**Problem**: Create an `EmailNotification` class that extends the `Notification` class (from Polymorphism Example 2). The `EmailNotification` class should have `receiver` and `subject` properties and override the `send` method to log `Sending email to ${receiver} with subject: ${subject}`. Instantiate an `EmailNotification` and an `SMSNotification`, and call their `send` methods.

**Hint**: Use the `Notification` class with a `send` method. For `EmailNotification`, extend `Notification`, call `super(receiver)`, and override `send` with the email-specific message. Test polymorphic behavior with different notification types.

---

### Practice Question 3: Abstraction - Vending Machine
**Problem**: Create a `VendingMachine` class that uses abstraction to manage internal stock. Include a private `#items` property (initialized to 10) and public methods `addItems(amount)` to increase stock and `dispenseItem()` to dispense one item if stock is available (log `Dispensing item...` or `Out of stock!`). Instantiate a `VendingMachine` and test the methods.

**Hint**: Use a private field `#items` to hide the stock count. Implement `addItems` to update `#items` and log the new stock level. In `dispenseItem`, check if `#items > 0` before dispensing and update the stock.

---

### Practice Question 4: Static Method - Calculator Utility
**Problem**: Create a `Calculator` class with a static method `add(a, b)` that returns the sum of two numbers. The class should also have instance methods `storeResult(result)` to save a result in a private `#memory` field and `getMemory()` to return the stored value. Call the static method and test the instance methods.

**Hint**: Define `add` as a `static` method on the `Calculator` class that doesn’t require an instance. Use a private `#memory` field for instance methods. Test `Calculator.add(5, 3)` and instance methods separately.

---

### Practice Question 5: Polymorphism - Square Area
**Problem**: Create a `Square` class that extends the `Shape` class (from Polymorphism Example 1). The `Square` class should have a `side` property and override the `getArea` method to return `side * side`. Create an array of `Shape` objects (`Circle`, `Rectangle`, `Square`) and loop through it to log each shape’s area.

**Hint**: Extend `Shape` for `Square`, call `super()`, and override `getArea` to compute the square’s area. Use an array to store different shape instances and call `getArea` on each to demonstrate polymorphism.

---

### Practice Question 6: Abstraction - ATM Machine
**Problem**: Create an `ATM` class with a private `#balance` field (initialized to 1000). Provide public methods `deposit(amount)` to add money and `withdraw(amount)` to deduct money if sufficient funds are available (log appropriate messages). Instantiate an `ATM` and test depositing and withdrawing.

**Hint**: Use a private `#balance` field to hide the account balance. In `deposit`, update `#balance` and log the new balance. In `withdraw`, check if `#balance >= amount` before deducting and log success or failure.

---

### Practice Question 7: Static Method - Distance Converter
**Problem**: Create a `DistanceConverter` class with a static method `kmToMiles(km)` that converts kilometers to miles (1 km = 0.621371 miles). The class should also have instance methods `setDistance(km)` to store a distance in a private `#distance` field and `getDistance()` to return it. Call the static method and test the instance methods.

**Hint**: Define `kmToMiles` as a `static` method that performs the conversion. Use a private `#distance` field for instance methods. Test `DistanceConverter.kmToMiles(10)` and instance methods separately.

---

### Practice Question 8: Polymorphism - Push Notification
**Problem**: Create a `PushNotification` class that extends the `Notification` class (from Polymorphism Example 2). The `PushNotification` class should have `receiver` and `device` properties and override the `send` method to log `Sending push notification to ${receiver} on ${device}`. Instantiate a `PushNotification`, an `SMSNotification`, and an `EmailNotification`, and call their `send` methods.

**Hint**: Extend `Notification` for `PushNotification`, call `super(receiver)`, and override `send` with the push-specific message. Test polymorphic behavior by calling `send` on different notification types.

---

### Practice Question 9: Abstraction - Music Player
**Problem**: Create a `MusicPlayer` class with a private `#volume` field (initialized to 50). Provide public methods `increaseVolume(amount)` to increase the volume (max 100) and `playSong(song)` to log `Playing ${song} at volume ${#volume}` if volume is above 0. Instantiate a `MusicPlayer` and test the methods.

**Hint**: Use a private `#volume` field to hide the volume level. In `increaseVolume`, ensure `#volume` doesn’t exceed 100. In `playSong`, check if `#volume > 0` before playing and include the volume in the message.

---

### Practice Question branded: Static Method and Polymorphism - Payment Processor
**Problem**: Create a `PaymentProcessor` class with a static method `formatCurrency(amount)` that returns `$${amount.toFixed(2)}`. Create two subclasses, `CreditCardPayment` and `PayPalPayment`, that extend `PaymentProcessor` and override a `processPayment(amount)` method to log payment-specific messages (e.g., `Processing credit card payment of ${amount}` for `CreditCardPayment`). Call the static method and test polymorphic payment processing.

**Hint**: Define `formatCurrency` as a `static` method on `PaymentProcessor`. For each subclass, extend `PaymentProcessor`, call `super()`, and override `processPayment` with a unique message. Test `PaymentProcessor.formatCurrency(10.5)` and polymorphic `processPayment` calls.

---

### Guidelines for Students
- Write the code from scratch, following the structure in the provided examples.
- Test your code by creating instances (where applicable) and calling all relevant methods, including static methods.
- For polymorphism, ensure overridden methods provide specific behavior while maintaining a common interface.
- For abstraction, use private fields (e.g., `#field`) to hide internal details and expose only necessary methods.
- For static methods, call them directly on the class (e.g., `ClassName.method()`) and ensure they don’t rely on instance data.
- Verify that your code produces the expected output and handles edge cases (e.g., insufficient stock, invalid inputs).
