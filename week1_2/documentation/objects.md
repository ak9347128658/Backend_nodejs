Defination: In JavaScript, an object is a collection of key-value pairs, where keys are strings (or symbols) and values can be any data type, including numbers, strings, arrays, functions, or even other objects. Objects are used to store and organize data in a structured way, allowing you to represent real-world entities with properties and behaviors.

key 1. Objects are created using curly braces {} or the new Object() constructor. Each Key-value pair is called a property, and if the value is a function, it’s called a method. Objects are mutable, meaning their properties can be added, modified, or deleted after creation.

Example 1: Creating a Simple Object  
Creating an object using object literal syntax:
```js
const person = {
  name: "John",
  age: 30,
  greet: function() {
    console.log(`Hello, my name is ${this.name}`);
  },
  getName: function() {
    return this.name;  // in objects functions can be called as methods
  }
};
console.log(person);
// Accessing properties:
console.log(person.name); // Output: John
console.log(person["age"]); // Output: 30
// Calling a method:
person.greet();

const personName = person.getName();
console.log(personName); // Output: John
```

Example 2: Creating an Object with Constructor Function
```js
const car = new Object();
console.log(car);
car.brand = "Toyota";
car["model"] = "Camry";
car.year = 2020;
car.start = function() {
   console.log(`Starting the ${this.brand} ${this.model}`);
};

console.log(car);
// Accessing properties:
console.log(car.brand);  // Output: Toyota
console.log(car.model);  // Output: Camry
console.log(car.start()); // Output: 2020
```

key 2. Objects can be nested, meaning a property’s value can be another object. This allows for complex data structures to represent hierarchical relationships.

Example 1: Nested Objects
```js
const company = {
   name: "Tech Corp",
   location: "New York",
   employees: [
      {
        name: "Alice",
        position: "Developer",
        skills: ["JavaScript", "React"],
        address: {
           street: "123 Main St",
           city: "New York",
           zip: "10001"
        }
      },
      {
        name: "Bob",
        position: "Designer",
        skills: ["Photoshop", "Illustrator"]
      }
   ],
};

// Accessing nested properties:
console.log(company.employees[0].name); // Output: Alice
console.log(company.employees[0].address.city);
```

Example 2: Nested Objects with Methods
```js
const school = {
   name: "Green Valley High",
   location: "California",
   established: 1995,
   students: [
      {
        name: "Emma",
        age: 16,
        subjects: ["Math", "Science"],
        getDetails: function() {
           return `${this.name}, Age: ${this.age}`;
        }
      },
      {
        name: "Liam",
        age: 17,
        subjects: ["History", "Art"],
        getDetails: function() {
           return `${this.name}, Age: ${this.age}`;
        }
      }
   ],
};

// Accessing nested properties and methods:
console.log(school.students[1].getDetails());
```

key 3. Properties can be added or deleted dynamically using assignment or the delete operator. This makes JavaScript objects highly flexible for runtime modifications.

Example 1: Adding properties dynamically
```js
const laptop = {
   brand: "Dell"
};

console.log(laptop); // Output: { brand: 'Dell' }
laptop.model = "XPS 13";
laptop.year = 2022;
console.log(laptop); // Output: { brand: 'Dell', model: 'XPS 13', year: 2022 }
```

Example 2: Deleting properties
```js
const phone = {
   brand: "Samsung",
   model: "Galaxy S21",
   year: 2021,
   color: "Black"
};
console.log(phone); // Output: { brand: 'Samsung', model: 'Galaxy S21', year: 2021, color: 'Black' }

delete phone.color;
console.log(phone); // Output: { brand: 'Samsung', model: 'Galaxy S21', year: 2021 }
```

Key 4. Objects can be copied using methods like Object.assign() or the spread operator (...). However, this creates a shallow copy, meaning nested objects are still referenced rather than copied.

Example 1: Shallow Copy using Object.assign() or Spread
```js
const original = {
   name: "Eve",
   details: {
      age: 25
   }
};
console.log(original); // Output: { name: 'Eve', details: { age: 25 } }
// const copy = Object.assign({}, original); // Using Object.assign() to create a shallow copy
const copy = { ...original }; // Using spread operator
copy.name = "Charlie";

console.log(original); // Output: { name: 'Eve', details: { age: 25 } }
console.log(copy);     // Output: { name: 'Charlie', details: { age: 25 } }
```

Key 5. Object methods like Object.keys(), Object.values(), and Object.entries() allow iteration over properties. These are useful for inspecting or manipulating object data.  
object.keys() returns an array of keys of an object  
object.values() returns an array of values of an object  
object.entries() returns an array of key-value pairs of an object

Example 1: Using Object.keys(), Object.values()
```js
const fruit = {
   name: "Apple",
   color: "Red",
   weight: 150,
   taste: "Sweet"
};

const fruitKeys = Object.keys(fruit);
const fruitValues = Object.values(fruit);

console.log(fruitKeys);   // Output: ['name', 'color', 'weight', 'taste']
console.log(fruitValues); // Output: ['Apple', 'Red', 150, 'Sweet']
```

Example 2: Using Object.entries()
```js
const product = {
   id: "P123",
   name: "Mouse",
   price: 25
};

const productEntries = Object.entries(product);
console.log(productEntries); // Output: [['id', 'P123'], ['name', 'Mouse'], ['price', 25]]

console.log(productEntries[0][1]);

for(const item of productEntries) {
  console.log(item[0], item[1]);
}
```

key 6. Objects can use computed property names, allowing dynamic key creation.

Example 1: Computed Property Names
```js
const perfix = "user_";
const user = {
   [perfix + "name"]: "John",
   [perfix + "age"]: 30,
   [perfix + "email"]: "john@gmail.com"
};

console.log(user); // Output: { user_name: 'John', user_age: 30, user_email: 'john@gmail.com' }
```

key 7. Objects can be frozen or sealed to restrict modifications. Object.freeze() prevents all changes, while Object.seal() allows modifying existing properties but not adding or deleting.

Example 1: Freezing an Object
```js
const config = {
   host: "localhost",
   port: 8080,
   protocol: "http",
};
console.log(config); // Output: { host: 'localhost', port: 8080, protocol: 'http' }
Object.freeze(config); // Freezing the object
config.protocol = "https"; // Attempting to modify a frozen object
config.timeout = 5000; // Attempting to add a new property
config.port = 3000; // Attempting to modify an existing property
console.log(config); // Output: { host: 'localhost', port: 8080, protocol: 'http' }
```

Example 2: Sealing an Object
```js
const settings = {
   theme: "dark",
   notifications: true
};
console.log(settings); // Output: { theme: 'dark', notifications: true }
Object.seal(settings); // Sealing the object
settings.theme = "light"; // Modifying an existing property
delete settings.notifications; // Attempting to delete a property
settings.language = "en"; // Attempting to add a new property
console.log(settings); // Output: { theme: 'light', notifications: true }
```

Key 8. Objects can be used with prototypes to share properties and methods. Every object in JavaScript has a prototype, which is another object from which it inherits properties and methods.

Example 1: Using Prototypes with Object.create()
```js
const animal = {
   eat: function() {
      console.log(`${this.name} is eating.`);
   }
};

// console.log(animal); // Output: { eat: [Function: eat] }

const dog = Object.create(animal); // Creating a new object with animal as prototype
dog.name = "Buddy";
dog.eat();

const cat = Object.create(animal);
cat.name = "Whiskers";
cat.eat(); // Output: Whiskers is eating.
```

Example 2: Using Object.create() with 3 Generations

Generation 1: Grandparent
```js
const grandparent = {
   lastName: "Smith",
   greet: function() {
      console.log(`Hello, I'm a ${this.lastName}`);
   }
};
```
Generation 2: Parent inherits from Grandparent
```js
const parent = Object.create(grandparent);
parent.firstName = "John";
parent.introduce = function() {
   console.log(`Hi, I'm ${this.firstName} ${this.lastName}`);
};
```
Generation 3: Child inherits from Parent
```js
const child = Object.create(parent);
child.age = 10;
child.name = "Alice";
child.describe = function() {
   console.log(`I'm ${this.name} ${this.lastName}, and I'm ${this.age} years old.`);
};

child.describe();  // Output: I'm Alice Smith, and I'm 10 years old.
child.introduce(); // Output: Hi, I'm John Smith
child.greet();     // Output: Hello, I'm a Smith
```

Proactice Questions on JavaScript Objects
---

### Practice Questions on JavaScript Objects

#### Beginner Level: Understanding Object Basics
1. **Create a Simple Object**  
  - Create an object representing a book with properties for `title`, `author`, and `year`. Log the book’s title and author to the console.  
  - *Expected Output*:
    ```
    Title: [Your Book Title]
    Author: [Your Author Name]
    ```

2. **Access Properties**  
  - Create an object for a car with properties `brand`, `model`, and `color`. Access the `model` using both dot notation and bracket notation, and log the results.  
  - *Expected Output*:
    ```
    Model (dot): [Your Model]
    Model (bracket): [Your Model]
    ```

3. **Add a Method**  
  - Create an object for a person with `name` and `age` properties. Add a method `sayHello` that logs a greeting using the person’s name. Call the method.  
  - *Expected Output*:
    ```
    Hello, my name is [Your Name]!
    ```

4. **Modify Properties**  
  - Create an object for a laptop with `brand` and `price`. Change the `price` to a new value and add a `ram` property. Log the updated object.  
  - *Expected Output*:
    ```
    { brand: '[Your Brand]', price: [New Price], ram: '[Your RAM]' }
    ```

#### Intermediate Level: Working with Methods and Nested Objects
5. **Calculate Area**  
  - Create an object for a rectangle with `width` and `height` properties. Add a method `getArea` that returns the area (width * height). Log the area.  
  - *Expected Output*:
    ```
    Area: [Width * Height]
    ```

6. **Nested Object Access**  
  - Create an object for a student with a nested `address` object containing `street`, `city`, and `zip`. Log the city and zip using dot and bracket notation.  
  - *Expected Output*:
    ```
    City: [Your City]
    Zip: [Your Zip]
    ```

7. **Dynamic Property Addition**  
  - Create an empty object. Prompt the user for a property name and value (or hardcode them), then add them to the object. Log the object.  
  - *Expected Output*:
    ```
    { [UserInputKey]: '[UserInputValue]' }
    ```

8. **Delete a Property**  
  - Create an object for a phone with `brand`, `model`, and `color`. Delete the `color` property and log the updated object.  
  - *Expected Output*:
    ```
    { brand: '[Your Brand]', model: '[Your Model]' }
    ```

9. **Object with Array**  
  - Create an object for a classroom with a `name` and a `students` array of names. Add a method `addStudent` that pushes a new name to the array. Call it and log the array.  
  - *Expected Output*:
    ```
    Students: ['Name1', 'Name2', 'NewName']
    ```

10. **Iterate with `Object.keys()`**  
   - Create an object for a product with `id`, `name`, and `price`. Use `Object.keys()` to log all property names.  
   - *Expected Output*:
    ```
    id
    name
    price
    ```

#### Advanced Level: Copying, Prototypes, and Dynamic Behavior
11. **Shallow Copy**  
   - Create an object with a nested object (e.g., `person` with `details`). Create a shallow copy using the spread operator. Modify the nested object in the copy and log both objects to show the shared reference.  
   - *Expected Output*:
    ```
    Original: { name: '...', details: { modifiedProperty: '...' } }
    Copy: { name: '...', details: { modifiedProperty: '...' } }
    ```

12. **Deep Copy (Challenge)**  
   - Create an object with a nested object. Write a function to create a deep copy (no shared references). Modify the nested object in the copy and log both objects to confirm independence.  
   - *Expected Output*:
    ```
    Original: { name: '...', nested: { ... } }
    Copy: { name: '...', nested: { modifiedProperty: '...' } }
    ```

13. **Computed Property Names**  
   - Create an object where property names are generated dynamically (e.g., `prop1`, `prop2`) using a loop or array. Add values to these properties and log the object.  
   - *Expected Output*:
    ```
    { prop1: 'Value1', prop2: 'Value2' }
    ```

14. **Object Iteration with `Object.entries()`**  
   - Create an object for a shopping cart with item names and quantities. Use `Object.entries()` to log each item and its quantity in a formatted string.  
   - *Expected Output*:
    ```
    Item: Apple, Quantity: 5
    Item: Banana, Quantity: 3
    ```

15. **Freeze an Object**  
   - Create an object for a configuration with `host` and `port`. Freeze it using `Object.freeze()`. Attempt to modify a property and add a new one, then log the object.  
   - *Expected Output*:
    ```
    { host: '[Your Host]', port: [Your Port] }
    ```

16. **Seal an Object**  
   - Create an object for settings with `theme` and `volume`. Seal it using `Object.seal()`. Modify an existing property, try to add a new one, and log the object.  
   - *Expected Output*:
    ```
    { theme: '[Modified Theme]', volume: [Your Volume] }
    ```

#### Expert Level: Prototypes and Inheritance
17. **Prototype with `Object.create()`**  
   - Create a `vehicle` object with a `move` method. Use `Object.create()` to create a `car` object that inherits from `vehicle`. Add a `honk` method to `car`. Call both methods.  
   - *Expected Output*:
    ```
    [Car Name] is moving!
    [Car Name] says Beep!
    ```

18. **Constructor Function**  
   - Write a `Book` constructor function with `title` and `author`. Add a `getDetails` method to its prototype that returns a string with the book’s details. Create two book instances and call the method.  
   - *Expected Output*:
    ```
    Title: [Book1 Title], Author: [Book1 Author]
    Title: [Book2 Title], Author: [Book2 Author]
    ```

19. **Prototype Chain**  
   - Create a `person` object with a `greet` method. Use `Object.create()` to create a `student` object that inherits from `person`. Add a `study` method to `student`. Call both methods and use `console.log(student.__proto__)` to inspect the prototype.  
   - *Expected Output*:
    ```
    Hello from [Student Name]!
    [Student Name] is studying.
    { greet: [Function] }
    ```

20. **Simulate a Class with Prototypes**  
   - Create a `Rectangle` constructor with `width` and `height`. Add `getArea` and `getPerimeter` methods to its prototype. Create two rectangles and log their areas and perimeters.  
   - *Expected Output*:
    ```
    Rectangle 1 - Area: [W1*H1], Perimeter: [2*(W1+H1)]
    Rectangle 2 - Area: [W2*H2], Perimeter: [2*(W2+H2)]
    ```

---
