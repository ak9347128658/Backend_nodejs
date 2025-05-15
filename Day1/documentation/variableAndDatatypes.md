# Variables and Data Types

**let** allows reassigning values; **const** does not.  
**var** is an older way of declaring variables and is not recommended.

---

## 1. Primitive Data Types

- **String**: Text enclosed in `' '` or `" "`
- **Number**: Integers or floating-point values
- **Boolean**: `true` or `false`
- **Null**: Intentional absence of any object value
- **Undefined**: Declared but not yet assigned

```js
let name = "John Doe";
let age = 25;
let height = 5.9;
let isStudent = true;
let emptyValue = null;
let notAssigned;
```

---

## 2. Reference Types

### Object  
A collection of key–value pairs.

```js
let person = {
    name: "John Doe",
    age: 25,
    isStudent: true
};
console.log(person);
console.log(person.name);
console.log(person.age);
```

### Array  
An ordered list of values.

```js
let fruits = ["apple", "banana", "orange", "grape", "mango", "kiwi"];
console.log(fruits);
console.log(fruits[0]); // apple
console.log(fruits[3]); // grape
```

### Function  
A reusable block of code.

```js
function helloWorld() {
    console.log("Hello, World!");
}

helloWorld();
```

#### Functions with Parameters and Return Values

```js
function greet(name) {
    console.log("Hello, " + name + "!");
}
greet("John Doe");

function add(a, b) {
    return a + b;
}
console.log(add(5, 10)); // 15

const multiply = (a, b) => a * b;
console.log(multiply(5, 10)); // 50
```

---

## 3. var vs let vs const

```js
function exampleVar() {
    let y = 10;
    var x = 20;
    const z = 30;

    if (true) {
        var x = 10;   // overrides function-scoped x
        let y = 20;   // block-scoped
        // z = 40;    // error: cannot reassign const
    }

    console.log(x); // 10
    console.log(y); // 10
    console.log(z); // 30
}

exampleVar();
```

---

## 4. Conditional Statements

### if / else if / else

```js
let name = "EXAMPLE NAME";

if (name === "John Doe") {
    console.log("from if");
} else if (name === "Jane Doe") {
    console.log("from else if");
} else {
    console.log("from else");
}
```

### switch

```js
let fruit = "banana";

switch (fruit) {
    case "apple":
        console.log("This is an apple.");
        break;
    case "banana":
        console.log("This is a banana.");
        break;
    case "orange":
        console.log("This is an orange.");
        break;
    default:
        console.log("Unknown fruit.");
}
```

---

## 5. Nested Statements

### Nested if

```js
let age = 16;
let hasLicense = false;

if (age >= 18) {
    if (hasLicense) {
        console.log("You are eligible to drive.");
    } else {
        console.log("You do not have a license.");
    }
} else {
    console.log("You are too young to drive.");
}
```

### Nested Functions

```js
function outerFunction() {
    let outerVariable = "I am outer";
    function innerFunction() {
        console.log(outerVariable);
    }
    innerFunction();
}

outerFunction();
```
