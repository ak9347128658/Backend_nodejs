// >> Defination:Object-Oriented Programming (OOP) in JavaScript is a programming paradigm that uses objects and classes to organize code in a modular, reusable, and maintainable way. It revolves around four key principles: encapsulation, inheritance, polymorphism, and abstraction. JavaScript, being a prototype-based language, implements OOP differently from class-based languages like Java or C++, primarily through prototypes and, since ES6, class syntax.

// Encapsulation:Encapsulation involves bundling data (properties) and methods that operate on that data within an object,restricting direct access to some of an object's  componenets to protect its integrity.In javascript,encapsulation is achieved using closures,private fields(with # prefix in classes),or naming conventions(e.g., _privateProperty)

// Example 1: Encapsulation with Closures
// function createCounter() {
//    let count = 0; // Private variable
//    return {
//        increment: function() {
//            count++;
//            return count;
//        },
//        getCount: function() {
//               return count;
//          }
//    } 
// }

// const counter = createCounter();
// // console.log(counter.getCount());
// counter.increment();
// counter.increment();

// console.log(counter.getCount()); // Output: 2

// Example 2: Encapsulation with Class Private Fields

// What is class?
// A class is a blueprint for creating objects. It defines a set of properties and methods that the created objects will have. In JavaScript, classes are syntactical sugar over the existing prototype-based inheritance and provide a clearer and more concise way to create objects and handle inheritance.

// syntax:
// class ClassName {
//     constructor(param1, param2) {
//         this.param1 = param1;
//         this.param2 = param2;
//     }
//     methodName() {
//         return `${this.param1} does something`;
//     }
// }

// what is constructor? in class
// constructor is a special method for creating and initializing an object created with a class.

// class BankAccount {    // it flows PascalCase
//    #balance = 0; // Private field
//    constructor(owner,accountNumber,balance){
//         this.owner = owner;
//         this.accountNumber = accountNumber;
//         this.#balance = balance; // Private field
//    } 
//   // functions in class
//   deposit(amount){
//      if(amount > 0) this.#balance = this.#balance + amount;  
//      return this.#balance; 
//   }

//    //   y we use this keyword because this keyword refers to the current instance of the class, allowing us to access    its properties and methods.
//    getBalance(){
//      return this.#balance;
//    }
   
//     withdraw(amount){
//       if(amount > 0 && amount <= this.#balance){
//           this.#balance = this.#balance - amount;
//           return this.#balance;
//       }else{
//           console.log("Insufficient funds");
//       }
//     }

// }

// const accountOne = new BankAccount("John Doe", "123456789",1000);

// accountOne.deposit(500);
// const balance = accountOne.getBalance();
// console.log(`Account One Balance of ${accountOne.owner}: $${balance}`); // Output: Account Balance: $1500

// const accountTwo = new BankAccount("Jane Smith", "987654321",2000);
// accountTwo.withdraw(300);
// const balanceTwo = accountTwo.getBalance();
// console.log(`Account Two Balance of ${accountTwo.owner}: $${balanceTwo}`); // Output: Account Balance: $1700

// console.log(`Account Two Account Number: ${accountTwo.accountNumber}`); // Output: Account Two Account Number: 987654321

// accountTwo.accountNumber = "000000000"; // This is allowed, but not recommended
// console.log(`Account Two New Account Number: ${accountTwo.accountNumber}`); // Output: Account Two New Account Number: 000000000

// Example 3: Encapsulation with Closures
// function createLibrary(){
//     // private variable 
//     let books = []; // Private variable
//     return {
//         addBook: function(title, author){
//             books.push({title, author});
//         },
//         getBooks: function(){
//             return books;
//         },
//         findBook: function(title){ 
//             return books.find(book => book.title === title);
//         }
//     }
// }

// const library = createLibrary();
// library.addBook("The Great Gatsby", "F. Scott Fitzgerald");
// library.addBook("To Kill a Mockingbird", "Harper Lee");
// library.addBook("1984", "George Orwell");
// library.addBook("The Catcher in the Rye", "J.D. Salinger");
// library.addBook("The Great Gatsby", "F. Scott Fitzgerald");

// // console.log(library.getBooks()); // Output: Array of book objects

// console.log(library.findBook("The Great Gatsby"));


// Example 4: Encapsulation with Class Private Fields
// class Library {
//    #books = []; // Private field
   
//    addBook(title, author) {
//       this.#books.push({ title, author });
//    }

//     getBooks() {
//         return this.#books;
//     }

//     findBook(title) {
//         return this.#books.find(book => book.title === title);
//     }
// }

// const library = new Library();
// library.addBook("The Great Gatsby", "F. Scott Fitzgerald");
// library.addBook("To Kill a Mockingbird", "Harper Lee");
// library.addBook("1984", "George Orwell");
// library.addBook("The Catcher in the Rye", "J.D. Salinger");
// library.addBook("The Great Gatsby", "F. Scott Fitzgerald");

// console.log(library.getBooks()); // Output: Array of book objects
// console.log(library.findBook("The Great Gatsby")); // Output: { title: "The Great Gatsby", author: "F. Scott Fitzgerald" }

