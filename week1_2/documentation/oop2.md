## Inheritance in JavaScript
Inheritance allows a new object or class to inherit properties and methods from an existing one, promoting code reusability. In JavaScript, inheritance is achieved via prototypes or the extends keyword in classes.

### Example 1: Inheritance with Prototypes (using function constructor)
```js
function Animal(name) {
    this.name = name;
}

Animal.prototype.eat = function() {
    console.log(`${this.name} is eating`);
};

function Dog(name, breed) {
    Animal.call(this, name); // Call the parent constructor
    this.breed = breed;
}

Dog.prototype = Object.create(Animal.prototype); // Inherit from Animal
Dog.prototype.constructor = Dog;
Dog.prototype.bark = function() {
    console.log(`${this.name} is barking`);
};

const dog = new Dog('Buddy', 'Golden Retriever');
dog.eat(); // Output: Buddy is eating
dog.bark(); // Output: Buddy is barking
```

### Example 2: Inheritance with Classes (single level inheritance)
```js
class Vehicle {
    constructor(brand) {
        this.brand = brand;
    }

    move() {
        console.log(`${this.brand} is moving`);
    }
}

class Car extends Vehicle {
    constructor(brand, model) {
        super(brand); // Call the parent constructor
        this.model = model;
    }

    honk() {
        console.log(`${this.brand} ${this.model} is honking`);
    }
}

const car = new Car('Tata', 'Nexon');
car.honk(); // Output: Tata Nexon is honking
car.move(); // Output: Tata is moving
```

### Example 3: Inheritance with Classes (Hierarchical Inheritance)
```js
class User {
    constructor(name, email) {
        this.name = name;
        this.email = email;
    }

    login() {
        console.log(`${this.name} has looged in with email ${this.email}`);
    }

    logout() {
        console.log(`${this.name} has logged out`);
    }
}

class Admin extends User {
    constructor(name, email, permissions) {
        super(name, email);
        this.permissions = permissions;
    }

    deleteUser(user) {
        console.log(`${this.name} has deleted user ${user.name}`);
    }

    login() {
        console.log(`Admin ${this.name} has logged in with elevated privileges`);
    }
}

class Customer extends User {
    constructor(name, email, points) {
        super(name, email);
        this.points = points;
    }

    purchase(item) {
        console.log(`${this.name} has purchased ${item} and now has ${this.points - 10} points left`);
        this.points = this.points - 10;
    }
}

const admin = new Admin('John Doe', 'johndoe@gmail.com', ['delete', 'edit']);
admin.login(); // Output: Admin John Doe has logged in with elevated privileges
admin.deleteUser({ name: 'Jane Smith' }); // Output: John Doe has deleted user Jane Smith

const customer = new Customer('Charlie Brown', 'charlie@site.com', 100);
customer.login(); // Output: Charlie Brown has looged in with email
customer.purchase('Laptop'); // Output: Charlie Brown has purchased Laptop and now has 90 points left
customer.logout(); // Output: Charlie Brown has logged out
```

### Example 4: Inheritance with Classes (multiple level inheritance)
```js
class LivingThing {
    constructor() {
        this.alive = true;
    }

    breathe() {
        console.log("Breathing...");
    }
}

class Animal extends LivingThing {
    constructor(name) {
        super();
        this.name = name;
    }

    eat() {
        console.log(`${this.name} is eating`);
    }
}

class Dog extends Animal {
    constructor(name, breed) {
        super(name);
        this.breed = breed;
    }

    bark() {
        console.log(`${this.name}, the ${this.breed} is barking.`);
    }
}

const myDog = new Dog('Buddy', 'Golden Retriever');
myDog.breathe();
myDog.eat();
myDog.bark();
console.log("is Alive ?", myDog.alive); // Output: true
```

### Practice Questions for above tops
---

### Practice Question 1: Prototypal Inheritance - Creating a Cat Class
**Problem**: Create a `Cat` class that inherits from the `Animal` constructor (as shown in Example 1). The `Cat` should have a `name` and `color` property and a `meow` method that logs `${name} is meowing`. Instantiate a `Cat` and call its `eat` and `meow` methods.

**Hint**: Use a constructor function for `Animal` with an `eat` method on its prototype. For `Cat`, use `Animal.call(this, name)` to inherit the `name` property and set `Cat.prototype = Object.create(Animal.prototype)` to inherit methods. Don’t forget to reset the constructor and add the `meow` method.

---

### Practice Question 2: Class-Based Single-Level Inheritance - Bike Class
**Problem**: Create a `Bike` class that extends the `Vehicle` class (as in Example 2). The `Bike` class should have `brand` and `type` properties and a `ringBell` method that logs `${brand} ${type} is ringing its bell`. Create a `Bike` instance and call `move` and `ringBell`.

**Hint**: Define the `Vehicle` class with a `brand` property and `move` method. Use the `extends` keyword for `Bike`, call `super(brand)` in the constructor, and define the `ringBell` method in the `Bike` class.

---

### Practice Question 3: Hierarchical Inheritance - Guest User
**Problem**: Extend the `User` class (from Example 3) to create a `Guest` class. The `Guest` class should have `name`, `email`, and `sessionTime` properties and a `browse` method that logs `${name} is browsing for ${sessionTime} minutes`. Instantiate a `Guest` and call `login` and `browse`.

**Hint**: Use the `User` class with `name`, `email`, and `login`/`logout` methods. For `Guest`, use `extends User`, call `super(name, email)` in the constructor, and add the `browse` method. Test inherited methods like `login`.

---

### Practice Question 4: Multi-Level Inheritance - Puppy Class
**Problem**: Extend the `Dog` class (from Example 4) to create a `Puppy` class. The `Puppy` class should have `name`, `breed`, and `age` properties and a `play` method that logs `${name}, the ${breed} puppy, is playing at ${age} months`. Instantiate a `Puppy` and call `breathe`, `eat`, `bark`, and `play`.

**Hint**: Use the `LivingThing` → `Animal` → `Dog` hierarchy. For `Puppy`, extend `Dog`, call `super(name, breed)` in the constructor, and add the `play` method. Ensure all inherited methods work.

---

### Practice Question 5: Prototypal Inheritance - Bird Class
**Problem**: Create a `Bird` constructor that inherits from the `Animal` constructor (as in Example 1). The `Bird` should have `name` and `wingspan` properties and a `fly` method that logs `${name} is flying with a ${wingspan} cm wingspan`. Create a `Bird` instance and call `eat` and `fly`.

**Hint**: Set up `Animal` with a `name` property and `eat` method on its prototype. For `Bird`, use `Animal.call(this, name)` and `Object.create(Animal.prototype)` for inheritance. Add the `fly` method to `Bird.prototype`.

---

### Practice Question 6: Class-Based Inheritance - ElectricCar Class
**Problem**: Create an `ElectricCar` class that extends the `Car` class (from Example 2). The `ElectricCar` should have `brand`, `model`, and `batteryCapacity` properties and a `charge` method that logs `${brand} ${model} is charging its ${batteryCapacity} kWh battery`. Instantiate an `ElectricCar` and call `move`, `honk`, and `charge`.

**Hint**: Use the `Vehicle` → `Car` hierarchy. For `ElectricCar`, extend `Car`, call `super(brand, model)` in the constructor, and define the `charge` method. Test inherited methods.

---

### Practice Question 7: Hierarchical Inheritance - Moderator Class
**Problem**: Extend the `User` class (from Example 3) to create a `Moderator` class. The `Moderator` should have `name`, `email`, and `forum` properties and a `moderate` method that logs `${name} is moderating the ${forum} forum`. Override the `login` method to log `Moderator ${name} has logged in to ${forum}`. Instantiate a `Moderator` and call `login`, `moderate`, and `logout`.

**Hint**: Use the `User` class with `login` and `logout`. For `Moderator`, extend `User`, call `super(name, email)`, and override `login` with a custom message. Add the `moderate` method.

---

### Practice Question 8: Multi-Level Inheritance - WildAnimal Class
**Problem**: Create a `WildAnimal` class that extends `Animal` (from Example 4) and a `Lion` class that extends `WildAnimal`. The `WildAnimal` class should have a `habitat` property and a `roam` method that logs `${name} is roaming in ${habitat}`. The `Lion` class should have a `prideSize` property and a `roar` method that logs `${name} is roaring with a pride of ${prideSize}`. Instantiate a `Lion` and call `breathe`, `eat`, `roam`, and `roar`.

**Hint**: Use the `LivingThing` → `Animal` → `WildAnimal` → `Lion` hierarchy. Call `super` in each constructor and add the respective methods. Ensure all inherited properties and methods work.

---

### Practice Question 9: Prototypal Inheritance - Override Method
**Problem**: Create a `Parrot` constructor that inherits from the `Animal` constructor (as in Example 1). The `Parrot` should have `name` and `color` properties and override the `eat` method to log `${name} is eating seeds`. Add a `speak` method that logs `${name} says hello!`. Instantiate a `Parrot` and call `eat` and `speak`.

**Hint**: Set up `Animal` with an `eat` method on its prototype. For `Parrot`, use `Animal.call(this, name)` for inheritance and `Object.create(Animal.prototype)` for the prototype. Override `eat` on `Parrot.prototype` and add `speak`.

---

### Practice Question 10: Class-Based Inheritance - VIP Customer
**Problem**: Create a `VIPCustomer` class that extends the `Customer` class (from Example 3). The `VIPCustomer` should have `name`, `email`, `points`, and `membershipLevel` properties and a `redeemReward` method that logs `${name} redeemed a ${membershipLevel} reward, deducting 50 points`. Update the `purchase` method to deduct only 5 points per purchase. Instantiate a `VIPCustomer` and call `login`, `purchase`, `redeemReward`, and `logout`.

**Hint**: Use the `User` → `Customer` → `VIPCustomer` hierarchy. For `VIPCustomer`, extend `Customer`, call `super(name, email, points)`, and override `purchase` to deduct 5 points. Add the `redeemReward` method.

---

### Guidelines for Students
- For each question, write the code from scratch, following the structure in the provided examples.
- Test your code by creating instances and calling all relevant methods.
- Ensure proper use of `call` and `Object.create` for prototypal inheritance or `extends` and `super` for class-based inheritance.
- Verify that inherited properties and methods work as expected.
- If overriding methods, ensure the new behavior is specific to the child class while maintaining access to parent methods when needed.

