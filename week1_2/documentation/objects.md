## **Definition of a JavaScript Object**

A JavaScript **object** is a collection of key-value pairs, where keys are strings (or symbols) and values can be any data type, including other objects, arrays, functions, or primitives. Objects are used to represent real-world entities or store structured data. They are mutable, dynamic, and central to JavaScript programming.

- **Key Characteristics**:
  - Objects are unordered collections.
  - Keys are unique; values can be of any type.
  - Objects can have properties (data) and methods (functions).
  - Objects support prototype-based inheritance.

---

## **Topics Covered**

1. **Object Creation**
2. **Accessing and Modifying Properties**
3. **Object Methods**
4. **Object Prototypes and Inheritance**
5. **Object Property Descriptors**
6. **Iterating Over Objects**
7. **Object Methods (Built-in)**
8. **Destructuring Objects**
9. **Object Spread and Rest Operators**
10. **JSON and Objects**

For each topic, I’ll provide a definition, explanation, and at least five examples.

---

### **1. Object Creation**

**Definition**: Objects can be created using various methods, including object literals, constructor functions, `Object.create()`, classes, or factory functions.

**Explanation**: JavaScript offers multiple ways to create objects, each suited for different use cases. Object literals are the simplest, while classes provide a more structured approach for complex applications.

**Examples**:

1. **Object Literal**:
   ```javascript
   const person = {
       name: "Alice",
       age: 25
   };
   console.log(person); // { name: "Alice", age: 25 }
   ```

2. **Using `new Object()`**:
   ```javascript
   const car = new Object();
   car.make = "Toyota";
   car.model = "Camry";
   console.log(car); // { make: "Toyota", model: "Camry" }
   ```

3. **Constructor Function**:
   ```javascript
   function Student(name, grade) {
       this.name = name;
       this.grade = grade;
   }
   const student = new Student("Bob", 10);
   console.log(student); // Student { name: "Bob", grade: 10 }
   ```

4. **Using `Object.create()`**:
   ```javascript
   const animalProto = { speak: () => console.log("Animal speaks!") };
   const dog = Object.create(animalProto);
   dog.breed = "Labrador";
   console.log(dog.breed); // "Labrador"
   dog.speak(); // "Animal speaks!"
   ```

5. **Using ES6 Class**:
   ```javascript
   class Book {
       constructor(title, author) {
           this.title = title;
           this.author = author;
       }
   }
   const book = new Book("1984", "Orwell");
   console.log(book); // Book { title: "1984", author: "Orwell" }
   ```

---

### **2. Accessing and Modifying Properties**

**Definition**: Object properties can be accessed or modified using dot notation (`.`) or bracket notation (`[]`).

**Explanation**: Dot notation is concise for known keys, while bracket notation is flexible for dynamic keys or keys with special characters. Properties can be added, updated, or deleted dynamically.

**Examples**:

1. **Dot Notation Access**:
   ```javascript
   const user = { name: "Charlie", age: 30 };
   console.log(user.name); // "Charlie"
   ```

2. **Bracket Notation Access**:
   ```javascript
   const product = { "item-name": "Laptop" };
   console.log(product["item-name"]); // "Laptop"
   ```

3. **Adding a Property**:
   ```javascript
   const phone = { brand: "Apple" };
   phone.model = "iPhone 14";
   console.log(phone); // { brand: "Apple", model: "iPhone 14" }
   ```

4. **Modifying a Property**:
   ```javascript
   const laptop = { brand: "Dell", price: 1000 };
   laptop.price = 1200;
   console.log(laptop.price); // 1200
   ```

5. **Deleting a Property**:
   ```javascript
   const employee = { id: 101, name: "Eve" };
   delete employee.id;
   console.log(employee); // { name: "Eve" }
   ```

---

### **3. Object Methods**

**Definition**: Methods are functions stored as object properties, allowing objects to perform actions.

**Explanation**: Methods are defined as functions within an object. They can use `this` to access other properties of the same object, enabling dynamic behavior.

**Examples**:

1. **Basic Method**:
   ```javascript
   const calculator = {
       add: (a, b) => a + b
   };
   console.log(calculator.add(5, 3)); // 8
   ```

2. **Using `this` in a Method**:
   ```javascript
   const person = {
       name: "Frank",
       greet() {
           return `Hello, ${this.name}!`;
       }
   };
   console.log(person.greet()); // "Hello, Frank!"
   ```

3. **Method with Parameters**:
   ```javascript
   const rectangle = {
       width: 10,
       height: 5,
       area() {
           return this.width * this.height;
       }
   };
   console.log(rectangle.area()); // 50
   ```

4. **Dynamic Method Assignment**:
   ```javascript
   const game = {};
   game.start = function() {
       return "Game started!";
   };
   console.log(game.start()); // "Game started!"
   ```

5. **Arrow Function as Method**:
   ```javascript
   const counter = {
       count: 0,
       increment: () => counter.count++ // Note: Arrow functions don't bind `this`
   };
   counter.increment();
   console.log(counter.count); // 1
   ```

---

### **4. Object Prototypes and Inheritance**

**Definition**: JavaScript uses prototype-based inheritance, where objects can inherit properties and methods from other objects via their prototype.

**Explanation**: Every object has a prototype, accessible via `__proto__` or `Object.getPrototypeOf()`. Prototypes allow shared behavior across objects, enabling inheritance.

**Examples**:

1. **Adding to Prototype**:
   ```javascript
   function Animal(name) {
       this.name = name;
   }
   Animal.prototype.speak = function() {
       return `${this.name} makes a sound.`;
   };
   const cat = new Animal("Whiskers");
   console.log(cat.speak()); // "Whiskers makes a sound."
   ```

2. **Using `Object.create()` for Inheritance**:
   ```javascript
   const vehicle = { drive: () => "Driving..." };
   const car = Object.create(vehicle);
   car.model = "Sedan";
   console.log(car.drive()); // "Driving..."
   ```

3. **Class-Based Inheritance**:
   ```javascript
   class Animal {
       constructor(name) {
           this.name = name;
       }
       speak() {
           return `${this.name} speaks.`;
       }
   }
   class Dog extends Animal {
       bark() {
           return "Woof!";
       }
   }
   const dog = new Dog("Rex");
   console.log(dog.speak()); // "Rex speaks."
   console.log(dog.bark()); // "Woof!"
   ```

4. **Setting Prototype Manually**:
   ```javascript
   const proto = { greet: () => "Hello!" };
   const obj = {};
   Object.setPrototypeOf(obj, proto);
   console.log(obj.greet()); // "Hello!"
   ```

5. **Checking Prototype**:
   ```javascript
   const person = { name: "Grace" };
   console.log(Object.getPrototypeOf(person) === Object.prototype); // true
   ```

---

### **5. Object Property Descriptors**

**Definition**: Property descriptors define attributes of object properties, such as `writable`, `enumerable`, and `configurable`.

**Explanation**: Use `Object.defineProperty()` or `Object.defineProperties()` to control property behavior, such as making properties read-only or non-enumerable.

**Examples**:

1. **Read-Only Property**:
   ```javascript
   const obj = {};
   Object.defineProperty(obj, "id", {
       value: 123,
       writable: false
   });
   obj.id = 456; // Fails silently
   console.log(obj.id); // 123
   ```

2. **Non-Enumerable Property**:
   ```javascript
   const user = { name: "Helen" };
   Object.defineProperty(user, "secret", {
       value: "hidden",
       enumerable: false
   });
   console.log(Object.keys(user)); // ["name"]
   ```

3. **Getter and Setter**:
   ```javascript
   const person = {
       _age: 30,
       get age() {
           return this._age;
       },
       set age(value) {
           this._age = value > 0 ? value : 0;
       }
   };
   person.age = 25;
   console.log(person.age); // 25
   ```

4. **Non-Configurable Property**:
   ```javascript
   const obj = {};
   Object.defineProperty(obj, "constant", {
       value: "fixed",
       configurable: false
   });
   delete obj.constant; // Fails
   console.log(obj.constant); // "fixed"
   ```

5. **Multiple Descriptors**:
   ```javascript
   const data = {};
   Object.defineProperties(data, {
       name: { value: "Ivy", writable: true },
       id: { value: 101, enumerable: false }
   });
   console.log(data.name); // "Ivy"
   console.log(Object.keys(data)); // ["name"]
   ```

---

### **6. Iterating Over Objects**

**Definition**: Objects can be iterated using loops or methods like `for...in`, `Object.keys()`, `Object.values()`, or `Object.entries()`.

**Explanation**: Iteration allows processing of object properties. `for...in` includes inherited enumerable properties, while `Object` methods focus on own properties.

**Examples**:

1. **Using `for...in`**:
   ```javascript
   const person = { name: "Jack", age: 40 };
   for (let key in person) {
       console.log(`${key}: ${person[key]}`);
   }
   // Output: name: Jack
   //         age: 40
   ```

2. **Using `Object.keys()`**:
   ```javascript
   const book = { title: "Dune", author: "Herbert" };
   console.log(Object.keys(book)); // ["title", "author"]
   ```

3. **Using `Object.values()`**:
   ```javascript
   const scores = { math: 90, science: 85 };
   console.log(Object.values(scores)); // [90, 85]
   ```

4. **Using `Object.entries()`**:
   ```javascript
   const car = { make: "Honda", model: "Civic" };
   for (let [key, value] of Object.entries(car)) {
       console.log(`${key}: ${value}`);
   }
   // Output: make: Honda
   //         model: Civic
   ```

5. **Using `forEach` with `Object.keys()`**:
   ```javascript
   const user = { name: "Kate", role: "Admin" };
   Object.keys(user).forEach(key => {
       console.log(`${key}: ${user[key]}`);
   });
   // Output: name: Kate
   //         role: Admin
   ```

---

### **7. Object Methods (Built-in)**

**Definition**: JavaScript provides built-in methods on the `Object` constructor for manipulating objects, like `Object.assign()`, `Object.freeze()`, etc.

**Explanation**: These methods help copy, freeze, or inspect objects, enhancing functionality and control.

**Examples**:

1. **Using `Object.assign()`**:
   ```javascript
   const target = { a: 1 };
   const source = { b: 2 };
   Object.assign(target, source);
   console.log(target); // { a: 1, b: 2 }
   ```

2. **Using `Object.freeze()`**:
   ```javascript
   const obj = { name: "Liam" };
   Object.freeze(obj);
   obj.name = "Mia"; // Fails
   console.log(obj.name); // "Liam"
   ```

3. **Using `Object.seal()`**:
   ```javascript
   const obj = { prop: 42 };
   Object.seal(obj);
   obj.prop = 100; // Works
   obj.newProp = 50; // Fails
   console.log(obj); // { prop: 100 }
   ```

4. **Using `Object.keys()`**:
   ```javascript
   const user = { id: 1, name: "Noah" };
   console.log(Object.keys(user)); // ["id", "name"]
   ```

5. **Using `Object.hasOwnProperty()`**:
   ```javascript
   const person = { name: "Olivia" };
   console.log(person.hasOwnProperty("name")); // true
   console.log(person.hasOwnProperty("age")); // false
   ```

---

### **8. Destructuring Objects**

**Definition**: Object destructuring allows extracting properties into variables using a concise syntax.

**Explanation**: Destructuring simplifies code by assigning properties to variables in one line, with support for default values and renaming.

**Examples**:

1. **Basic Destructuring**:
   ```javascript
   const user = { name: "Paul", age: 28 };
   const { name, age } = user;
   console.log(name, age); // "Paul", 28
   ```

2. **Renaming Variables**:
   ```javascript
   const person = { firstName: "Quinn" };
   const { firstName: fname } = person;
   console.log(fname); // "Quinn"
   ```

3. **Default Values**:
   ```javascript
   const obj = { name: "Rachel" };
   const { name, age = 30 } = obj;
   console.log(age); // 30
   ```

4. **Nested Destructuring**:
   ```javascript
   const user = { info: { name: "Sam", age: 35 } };
   const { info: { name, age } } = user;
   console.log(name, age); // "Sam", 35
   ```

5. **Destructuring in Function Parameters**:
   ```javascript
   function greet({ name, age }) {
       return `Hello, ${name}, age ${age}!`;
   }
   const person = { name: "Tina", age: 22 };
   console.log(greet(person)); // "Hello, Tina, age 22!"
   ```

---

### **9. Object Spread and Rest Operators**

**Definition**: The spread (`...`) operator copies or merges object properties, while the rest operator collects remaining properties.

**Explanation**: Spread is used for cloning or merging objects, and rest is used in destructuring to gather unassigned properties.

**Examples**:

1. **Spread for Cloning**:
   ```javascript
   const original = { name: "Uma" };
   const clone = { ...original };
   console.log(clone); // { name: "Uma" }
   ```

2. **Spread for Merging**:
   ```javascript
   const obj1 = { a: 1 };
   const obj2 = { b: 2 };
   const merged = { ...obj1, ...obj2 };
   console.log(merged); // { a: 1, b: 2 }
   ```

3. **Spread with Overrides**:
   ```javascript
   const defaults = { theme: "light", font: "Arial" };
   const userPrefs = { theme: "dark" };
   const settings = { ...defaults, ...userPrefs };
   console.log(settings); // { theme: "dark", font: "Arial" }
   ```

4. **Rest in Destructuring**:
   ```javascript
   const user = { name: "Vera", age: 27, role: "User" };
   const { name, ...rest } = user;
   console.log(rest); // { age: 27, role: "User" }
   ```

5. **Combining Spread and Rest**:
   ```javascript
   const base = { id: 1, name: "Will" };
   const { id, ...rest } = base;
   const updated = { ...rest, name: "Xander" };
   console.log(updated); // { name: "Xander" }
   ```

---

### **10. JSON and Objects**

**Definition**: JSON (JavaScript Object Notation) is a format for representing objects as strings, and JavaScript provides methods to convert between objects and JSON.

**Explanation**: `JSON.stringify()` converts objects to JSON strings, and `JSON.parse()` converts JSON strings back to objects. Not all objects are JSON-serializable (e.g., functions are excluded).

**Examples**:

1. **Convert Object to JSON**:
   ```javascript
   const user = { name: "Yara", age: 29 };
   const json = JSON.stringify(user);
   console.log(json); // '{"name":"Yara","age":29}'
   ```

2. **Parse JSON to Object**:
   ```javascript
   const json = '{"title":"Zorba","author":"Kazantzakis"}';
   const book = JSON.parse(json);
   console.log(book.title); // "Zorba"
   ```

3. **Stringify with Formatting**:
   ```javascript
   const data = { name: "Zoe", scores: [90, 85] };
   const formatted = JSON.stringify(data, null, 2);
   console.log(formatted);
   // {
   //   "name": "Zoe",
   //   "scores": [90, 85]
   // }
   ```

4. **Handling Non-Serializable Properties**:
   ```javascript
   const obj = { name: "Alice", fn: () => {} };
   const json = JSON.stringify(obj);
   console.log(json); // '{"name":"Alice"}'
   ```

5. **Error Handling with `JSON.parse()`**:
   ```javascript
   try {
       const invalid = '{name: "Bob"}'; // Invalid JSON
       JSON.parse(invalid);
   } catch (e) {
       console.log("Invalid JSON:", e.message);
   }
   // Output: Invalid JSON: Unexpected token n in JSON at position 1
   ```

---


## **Practice Questions for JavaScript Objects**

### **1. Object Creation**

1. Create an object representing a student using an object literal. Include properties for `name`, `grade`, and `id`.
   - **Hint**: Use the `{}` syntax and define key-value pairs.

2. Write a constructor function `Car` that creates car objects with `make` and `model` properties. Create two car instances.
   - **Hint**: Use the `function` keyword and the `this` keyword inside the constructor.

3. Create an object `pet` using `Object.create()` that inherits a method `describe` from a prototype object that returns "I am a pet".
   - **Hint**: Define a prototype object with the method first, then use `Object.create()`.

4. Define a `Book` class using ES6 class syntax with `title` and `author` properties. Instantiate two book objects.
   - **Hint**: Use the `class` keyword and a `constructor` method.

5. Create an object `laptop` using the `new Object()` syntax. Add properties `brand` and `price` dynamically.
   - **Hint**: Start with `new Object()` and assign properties using dot or bracket notation.

---

### **2. Accessing and Modifying Properties**

1. Given an object `user = { name: "Sam", age: 25 }`, write code to access the `name` property using dot notation.
   - **Hint**: Use the `.` operator with the property name.

2. Create an object `product` with a property `item-name: "Phone"`. Access `item-name` using bracket notation.
   - **Hint**: Use `[]` with the property name as a string.

3. Create an object `employee` with `id: 101`. Add a `department` property and set it to "HR".
   - **Hint**: Use either dot or bracket notation to add the new property.

4. Given an object `book = { title: "Dune", price: 15 }`, update the `price` to 20 and log the result.
   - **Hint**: Assign a new value to the property using `=`.

5. Create an object `cart = { item: "Shirt", quantity: 2 }`. Delete the `quantity` property and log the updated object.
   - **Hint**: Use the `delete` operator.

---

### **3. Object Methods**

1. Create an object `calculator` with a method `multiply` that takes two numbers and returns their product.
   - **Hint**: Define a function as a property of the object.

2. Create an object `person` with a `name` property and a `greet` method that returns "Hello, [name]!".
   - **Hint**: Use `this` to access the object’s `name` property.

3. Write an object `rectangle` with `width`, `height`, and an `area` method that calculates and returns the area.
   - **Hint**: Use `this.width * this.height` inside the method.

4. Create an object `game` and dynamically add a `start` method that returns "Game started!".
   - **Hint**: Assign a function to a new property after creating the object.

5. Create an object `counter` with a `count` property (initially 0) and an `increment` method that increases `count` by 1.
   - **Hint**: Ensure the method modifies the object’s `count` property using `this`.

---

### **4. Object Prototypes and Inheritance**

1. Define a constructor function `Animal` with a `name` property. Add a `speak` method to its prototype that returns "[name] makes a sound."
   - **Hint**: Use `Animal.prototype` to add the method.

2. Create a prototype object `vehicle` with a `drive` method. Use `Object.create()` to create a `car` object that inherits `drive`.
   - **Hint**: Pass the prototype object to `Object.create()`.

3. Create an `Animal` class with a `speak` method. Extend it with a `Dog` class that adds a `bark` method.
   - **Hint**: Use `class`, `extends`, and `super` if needed.

4. Create an object `obj` and set its prototype to an object with a `greet` method using `Object.setPrototypeOf()`.
   - **Hint**: Define the prototype object first, then use `Object.setPrototypeOf()`.

5. Given a constructor function `Person`, check if an instance’s prototype is `Person.prototype` using `Object.getPrototypeOf()`.
   - **Hint**: Create an instance and compare its prototype.

---

### **5. Object Property Descriptors**

1. Create an object with a read-only property `id` set to 100 using `Object.defineProperty()`.
   - **Hint**: Use the `writable: false` descriptor.

2. Define an object with a non-enumerable property `secret` using `Object.defineProperty()`. Verify it doesn’t appear in `Object.keys()`.
   - **Hint**: Set `enumerable: false` in the descriptor.

3. Create an object with a `name` property and add a getter and setter for `fullName` using `Object.defineProperty()`.
   - **Hint**: Use `get` and `set` in the descriptor object.

4. Create an object with a non-configurable property `constant` using `Object.defineProperty()`. Try deleting it and log the result.
   - **Hint**: Set `configurable: false` and test with the `delete` operator.

5. Use `Object.defineProperties()` to create an object with two properties: `name` (writable) and `id` (non-enumerable).
   - **Hint**: Pass an object with multiple property descriptors to `Object.defineProperties()`.

---

### **6. Iterating Over Objects**

1. Create an object `person = { name: "Alex", age: 30 }` and use a `for...in` loop to log all keys and values.
   - **Hint**: Use the loop to access each property and its value.

2. Given an object `book = { title: "1984", author: "Orwell" }`, use `Object.keys()` to log all property names.
   - **Hint**: Call `Object.keys()` and iterate over the resulting array.

3. Create an object `scores = { math: 95, science: 88 }` and use `Object.values()` to log all values.
   - **Hint**: Use `Object.values()` to get an array of values.

4. Given an object `car = { make: "Toyota", model: "Corolla" }`, use `Object.entries()` to log each key-value pair.
   - **Hint**: Use a `for...of` loop with `Object.entries()`.

5. Create an object `user = { name: "Beth", role: "Admin" }` and use `Object.keys().forEach()` to log each property.
   - **Hint**: Combine `Object.keys()` with the `forEach` method.

---

### **7. Object Methods (Built-in)**

1. Create two objects `obj1 = { a: 1 }` and `obj2 = { b: 2 }`. Use `Object.assign()` to merge them into a new object.
   - **Hint**: Pass a new object `{}` as the target.

2. Create an object `data = { name: "Cathy" }` and freeze it using `Object.freeze()`. Try modifying a property and log the result.
   - **Hint**: Use `Object.freeze()` and test immutability.

3. Create an object `obj = { prop: 42 }` and seal it using `Object.seal()`. Try adding and modifying properties, then log the result.
   - **Hint**: Use `Object.seal()` and check what operations are allowed.

4. Given an object `user = { id: 1, name: "Dan" }`, use `Object.keys()` to check if it has exactly two properties.
   - **Hint**: Check the length of the array returned by `Object.keys()`.

5. Create an object `person = { name: "Eve" }` and use `Object.hasOwnProperty()` to check if it has a `name` property.
   - **Hint**: Call `hasOwnProperty()` with the property name as a string.

---

### **8. Destructuring Objects**

1. Given an object `user = { name: "Frank", age: 35 }`, destructure `name` and `age` into variables and log them.
   - **Hint**: Use the `{}` syntax to extract properties.

2. Create an object `person = { firstName: "Grace" }` and destructure `firstName` into a variable named `fname`.
   - **Hint**: Use a colon (`:`) to rename the variable.

3. Destructure an object `book = { title: "Dune" }` to extract `title` and provide a default value for `author`.
   - **Hint**: Use `=` in the destructuring syntax for defaults.

4. Given an object `user = { info: { name: "Helen", age: 28 } }`, use nested destructuring to extract `name` and `age`.
   - **Hint**: Use nested `{}` to access the inner object.

5. Write a function that takes an object parameter and destructures `name` and `role` in the parameter list. Call it with an object.
   - **Hint**: Define the function with `{ name, role }` as the parameter.

---

### **9. Object Spread and Rest Operators**

1. Create an object `user = { name: "Ian" }` and use the spread operator to create a clone.
   - **Hint**: Use `...` to copy all properties.

2. Merge two objects `obj1 = { a: 1 }` and `obj2 = { b: 2 }` into a new object using the spread operator.
   - **Hint**: Combine multiple objects with `...` in a new `{}`.

3. Create an object `defaults = { theme: "light", font: "Arial" }` and override `theme` using the spread operator.
   - **Hint**: Spread `defaults` and add a new `theme` property.

4. Given an object `user = { name: "Jack", age: 30, role: "User" }`, use the rest operator to extract `name` and the remaining properties.
   - **Hint**: Use `...rest` in destructuring.

5. Combine spread and rest: Destructure `id` from an object and spread the rest into a new object with an updated property.
   - **Hint**: Use destructuring with `...rest`, then spread `rest` into a new object.

---

### **10. JSON and Objects**

1. Create an object `user = { name: "Kate", age: 27 }` and convert it to a JSON string using `JSON.stringify()`.
   - **Hint**: Call `JSON.stringify()` with the object.

2. Given a JSON string ` '{"title":"1984","author":"Orwell"}' `, parse it into an object and log the `title`.
   - **Hint**: Use `JSON.parse()` and access the property.

3. Convert an object `data = { name: "Liam", scores: [90, 85] }` to a formatted JSON string with indentation.
   - **Hint**: Use `JSON.stringify()` with `null` and a number for spacing.

4. Create an object with a function property and convert it to JSON. Log the result to see what happens.
   - **Hint**: Check if the function appears in the JSON string.

5. Write code to parse an invalid JSON string and handle any errors using a try-catch block.
   - **Hint**: Use `try` and `catch` with `JSON.parse()`.

---

