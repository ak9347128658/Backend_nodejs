Definition: Object-Oriented Programming (OOP) in JavaScript is a programming paradigm that uses objects and classes to organize code in a modular, reusable, and maintainable way. It revolves around four key principles: encapsulation, inheritance, polymorphism, and abstraction. JavaScript, being a prototype-based language, implements OOP differently from class-based languages like Java or C++, primarily through prototypes and, since ES6, class syntax.

Encapsulation: Encapsulation involves bundling data (properties) and methods that operate on that data within an object, restricting direct access to some of an object's components to protect its integrity. In JavaScript, encapsulation is achieved using closures, private fields (with # prefix in classes), or naming conventions (e.g., _privateProperty)

Example 1: Encapsulation with Closures
```js
function createCounter() {
    let count = 0; // Private variable
    return {
        increment: function() {
            count++;
            return count;
        },
        getCount: function() {
            return count;
        }
    }
}

const counter = createCounter();
console.log(counter.getCount());
counter.increment();
counter.increment();
console.log(counter.getCount()); // Output: 2
```

Example 2: Encapsulation with Class Private Fields

What is class?
A class is a blueprint for creating objects. It defines a set of properties and methods that the created objects will have. In JavaScript, classes are syntactical sugar over the existing prototype-based inheritance and provide a clearer and more concise way to create objects and handle inheritance.

Syntax:
```js
class ClassName {
    constructor(param1, param2) {
        this.param1 = param1;
        this.param2 = param2;
    }
    methodName() {
        return `${this.param1} does something`;
    }
}
```

What is constructor? in class
constructor is a special method for creating and initializing an object created with a class.

```js
class BankAccount {
   #balance = 0; // Private field
   constructor(owner, accountNumber, balance) {
       this.owner = owner;
       this.accountNumber = accountNumber;
       this.#balance = balance; // Private field
   }
   deposit(amount) {
       if (amount > 0) this.#balance = this.#balance + amount;
       return this.#balance;
   }
   getBalance() {
       return this.#balance;
   }
   withdraw(amount) {
       if (amount > 0 && amount <= this.#balance) {
           this.#balance = this.#balance - amount;
           return this.#balance;
       } else {
           console.log("Insufficient funds");
       }
   }
}

const accountOne = new BankAccount("John Doe", "123456789", 1000);
accountOne.deposit(500);
const balance = accountOne.getBalance();
console.log(`Account One Balance of ${accountOne.owner}: $${balance}`); // Output: 1500

const accountTwo = new BankAccount("Jane Smith", "987654321", 2000);
accountTwo.withdraw(300);
const balanceTwo = accountTwo.getBalance();
console.log(`Account Two Balance of ${accountTwo.owner}: $${balanceTwo}`); // Output: 1700

console.log(`Account Two Account Number: ${accountTwo.accountNumber}`); // Output: 987654321
accountTwo.accountNumber = "000000000";
console.log(`Account Two New Account Number: ${accountTwo.accountNumber}`);
```

Example 3: Encapsulation with Closures
```js
function createLibrary() {
    let books = []; // Private variable
    return {
        addBook: function(title, author) {
            books.push({ title, author });
        },
        getBooks: function() {
            return books;
        },
        findBook: function(title) {
            return books.find(book => book.title === title);
        }
    }
}

const library = createLibrary();
library.addBook("The Great Gatsby", "F. Scott Fitzgerald");
library.addBook("To Kill a Mockingbird", "Harper Lee");
library.addBook("1984", "George Orwell");
library.addBook("The Catcher in the Rye", "J.D. Salinger");
library.addBook("The Great Gatsby", "F. Scott Fitzgerald");
console.log(library.findBook("The Great Gatsby"));
```

Example 4: Encapsulation with Class Private Fields
```js
class Library {
   #books = []; // Private field

   addBook(title, author) {
       this.#books.push({ title, author });
   }

   getBooks() {
       return this.#books;
   }

   findBook(title) {
       return this.#books.find(book => book.title === title);
   }
}

const libraryClass = new Library();
libraryClass.addBook("The Great Gatsby", "F. Scott Fitzgerald");
libraryClass.addBook("To Kill a Mockingbird", "Harper Lee");
libraryClass.addBook("1984", "George Orwell");
libraryClass.addBook("The Catcher in the Rye", "J.D. Salinger");
libraryClass.addBook("The Great Gatsby", "F. Scott Fitzgerald");
console.log(libraryClass.getBooks());
console.log(libraryClass.findBook("The Great Gatsby"));
```


### Practice Questions on Encapsulation in JavaScript

#### Question 1: Encapsulation with Closures - Inventory Manager
**Problem**: Create a JavaScript function `createInventory` that encapsulates a private array of items in a store's inventory. The function should return an object with methods to:
- Add an item (name and quantity).
- Remove an item by name (if it exists).
- Get the total quantity of all items.
- List all item names.
The inventory data should not be directly accessible from outside.

**Requirements**:
- Use closures to encapsulate the inventory array.
- Ensure the `removeItem` method checks if the item exists before removing it.
- The `getTotalQuantity` method should sum the quantities of all items.

**Hint**: Use an array to store objects with `name` and `quantity` properties. Return an object with methods that manipulate the array while keeping it private.

**Example Usage**:
```javascript
const inventory = createInventory();
console.log(inventory.addItem("Laptop", 5)); // "Laptop added with quantity 5"
console.log(inventory.addItem("Phone", 10)); // "Phone added with quantity 10"
console.log(inventory.getTotalQuantity()); // 15
console.log(inventory.listItems()); // ["Laptop", "Phone"]
console.log(inventory.removeItem("Laptop")); // "Laptop removed"
console.log(inventory.listItems()); // ["Phone"]
console.log(inventory.items); // undefined
```

---

#### Question 2: Encapsulation with Class Private Fields - Task Manager
**Problem**: Implement a `TaskManager` class that encapsulates a private list of tasks. Each task has a `title` and a `completed` status (boolean). The class should provide methods to:
- Add a task (with title, initially not completed).
- Mark a task as completed by title.
- Get a list of incomplete task titles.
- Get the count of completed tasks.
The task list should be private and inaccessible directly.

**Requirements**:
- Use class private fields (`#`) to encapsulate the task list.
- Ensure the `markCompleted` method checks if the task exists.
- The `getIncompleteTasks` method should return only the titles of tasks where `completed` is `false`.

**Hint**: Store tasks as objects in a private array (e.g., `{ title: "Task 1", completed: false }`). Use array methods like `find` and `filter` in your public methods.

**Example Usage**:
```javascript
const taskManager = new TaskManager();
console.log(taskManager.addTask("Write code")); // "Write code added"
console.log(taskManager.addTask("Test app")); // "Test app added"
console.log(taskManager.markCompleted("Write code")); // "Write code marked as completed"
console.log(taskManager.getIncompleteTasks()); // ["Test app"]
console.log(taskManager.getCompletedCount()); // 1
console.log(taskManager.#tasks); // SyntaxError
```

---

#### Question 3: Encapsulation with Closures - Event Scheduler
**Problem**: Create a function `createScheduler` that encapsulates a private array of events, where each event has a `name` and a `date` (as a string). Provide methods to:
- Add an event (name and date).
- Cancel an event by name.
- List upcoming events (events with a date later than today).
- Get the total number of events.
The event data should be private.

**Requirements**:
- Use closures for encapsulation.
- For simplicity, assume dates are strings in the format "YYYY-MM-DD" and compare them lexicographically to determine if an event is upcoming (e.g., compare with today's date, "2025-05-18").
- The `cancelEvent` method should return a message indicating success or failure.

**Hint**: Use `Date` objects or string comparison to filter upcoming events. Store events in a private array and expose only the necessary methods.

**Example Usage**:
```javascript
const scheduler = createScheduler();
console.log(scheduler.addEvent("Meeting", "2025-06-01")); // "Meeting added"
console.log(scheduler.addEvent("Concert", "2025-05-20")); // "Concert added"
console.log(scheduler.listUpcomingEvents()); // ["Meeting", "Concert"]
console.log(scheduler.cancelEvent("Meeting")); // "Meeting canceled"
console.log(scheduler.getTotalEvents()); // 1
console.log(scheduler.events); // undefined
```

---

#### Question 4: Encapsulation with Class Private Fields - Student Registry
**Problem**: Design a `StudentRegistry` class that encapsulates a private list of students, where each student has a `name` and a `grade` (number). Implement methods to:
- Register a student (name and grade).
- Update a student's grade by name.
- Get the average grade of all students.
- List students with grades above a given threshold.
The student list should be private.

**Requirements**:
- Use class private fields for encapsulation.
- The `updateGrade` method should check if the student exists.
- The `getAverageGrade` method should handle the case where there are no students (return 0).
- The `listStudentsAbove` method should accept a threshold parameter.

**Hint**: Store students as objects in a private array. Use `reduce` for calculating the average and `filter` for listing students above the threshold.

**Example Usage**:
```javascript
const registry = new StudentRegistry();
console.log(registry.registerStudent("Alice", 85)); // "Alice registered with grade 85"
console.log(registry.registerStudent("Bob", 90)); // "Bob registered with grade 90"
console.log(registry.updateGrade("Alice", 88)); // "Alice's grade updated to 88"
console.log(registry.getAverageGrade()); // 89
console.log(registry.listStudentsAbove(87)); // ["Alice", "Bob"]
console.log(registry.#students); // SyntaxError
```

---

#### Question 5: Mixed Encapsulation - Recipe Book
**Problem**: Create a `RecipeBook` system that encapsulates a private collection of recipes, where each recipe has a `name` and an array of `ingredients`. Implement it in **two ways**: using closures and using class private fields. For each implementation, provide methods to:
- Add a recipe (name and ingredients array).
- Remove a recipe by name.
- Find recipes containing a specific ingredient.
- Get the total number of ingredients across all recipes.
The recipe data should be private.

**Requirements**:
- Implement `createRecipeBook` (closure-based) and `RecipeBook` (class-based) separately.
- The `findRecipesWithIngredient` method should return recipe names that include the given ingredient.
- The `getTotalIngredients` method should count unique ingredients across all recipes (use a `Set` to avoid duplicates).

**Hint**: For both implementations, store recipes as objects with `name` and `ingredients` properties. Use `Set` to compute unique ingredients in `getTotalIngredients`.

**Example Usage** (for both implementations):
```javascript
const recipeBook = createRecipeBook(); // or new RecipeBook();
console.log(recipeBook.addRecipe("Pasta", ["tomato", "pasta", "cheese"])); // "Pasta added"
console.log(recipeBook.addRecipe("Salad", ["lettuce", "tomato", "cheese"])); // "Salad added"
console.log(recipeBook.findRecipesWithIngredient("tomato")); // ["Pasta", "Salad"]
console.log(recipeBook.getTotalIngredients()); // 4 (tomato, pasta, cheese, lettuce)
console.log(recipeBook.removeRecipe("Pasta")); // "Pasta removed"
console.log(recipeBook.recipes); // undefined (or SyntaxError for class)
```

---

### Tips for Students
- **Test Your Code**: After implementing each solution, test edge cases (e.g., empty lists, non-existent items, invalid inputs).
- **Understand Privacy**: Verify that private data is inaccessible by attempting to access it directly (e.g., `inventory.items` or `registry.#students`).
- **Compare Approaches**: For Question 5, note the differences in syntax and usability between closures and classes.
- **Use Array Methods**: Leverage `map`, `filter`, `find`, and `reduce` to manipulate private arrays efficiently.

