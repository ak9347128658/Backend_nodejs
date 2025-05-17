# Loops in JavaScript

Loops let you execute a block of code repeatedly based on a condition (true/false). They reduce repetitive coding and improve efficiency.

---

## Types of Loops

1. **for**  
2. **while**  
3. **do…while**  
4. **for…in**  
5. **for…of**  
6. **Array.prototype.forEach**

---

## 1. For Loop

**Definition:** Executes a block of code a specific number of times.

**Syntax:**
```javascript
for (initialization; condition; update) {
    // code
}
```
- **initialization**: set start value (e.g. `let i = 0`)  
- **condition**: checked before each iteration (e.g. `i < 5`)  
- **update**: changes the loop variable (e.g. `i++`)  

**Example:**
```javascript
for (let i = 0; i < 5; i++) {
    console.log(i);
}
```

### More For‐Loop Examples

- **Print 1 to 10**
    ```javascript
    for (let i = 1; i <= 10; i++) {
        console.log(i);
    }
    ```

- **Sum 1 to 4 (1+2+3+4 = 10)**
    ```javascript
    let sum = 0;
    for (let i = 1; i <= 4; i++) {
        sum += i;
    }
    console.log(sum);
    ```

- **Even numbers 2 to 10**
    ```javascript
    for (let i = 2; i <= 10; i += 2) {
        console.log(i);
    }
    ```

- **Iterate over an array**
    ```javascript
    const fruits = ["apple", "banana", "orange"];
    for (let i = 0; i < fruits.length; i++) {
        console.log(fruits[i]);
    }
    ```

- **Reverse order (5 to 1)**
    ```javascript
    for (let i = 5; i >= 1; i--) {
        console.log(i);
    }
    ```

### Nested For‐Loop Star Patterns

- **Square (5×5)**
    ```javascript
    for (let i = 0; i < 5; i++) {
        let row = "";
        for (let j = 0; j < 5; j++) {
            row += "* ";
        }
        console.log(row);
    }
    ```

- **Right Triangle**
    ```javascript
    for (let i = 1; i <= 5; i++) {
        let row = "";
        for (let j = 1; j <= i; j++) {
            row += "* ";
        }
        console.log(row);
    }
    ```

- **Inverted Right Triangle**
    ```javascript
    for (let i = 5; i >= 1; i--) {
        let row = "";
        for (let j = 1; j <= i; j++) {
            row += "* ";
        }
        console.log(row);
    }
    ```

#### Practice (for‐loop)

1. Centered pyramid (5 rows)  
2. Hollow square (5×5)  
3. Sum of evens from 1 to 20 (→110)  
4. Count consonants in `"javascript"` (→7)  
5. Find smallest in `[15,3,9,1,12,7]` (→1)  
6. Multiples of 5 from 50 to 5 in reverse  

---

## 2. While Loop

**Definition:** Executes while a condition is true; must update the condition inside the loop.

**Syntax:**
```javascript
while (condition) {
    // code
    // update condition
}
```

**Examples:**

- **Print 1 to 5**
    ```javascript
    let i = 1;
    while (i <= 5) {
        console.log(i++);
    }
    ```

- **Sum 1 to 10**
    ```javascript
    let sum = 0, i = 1;
    while (i <= 10) {
        sum += i++;
    }
    console.log(sum);
    ```

- **First power of 2 > 100**
    ```javascript
    let num = 1;
    while (num <= 100) {
        num *= 2;
    }
    console.log(num);
    ```

- **Reverse a number**
    ```javascript
    let num = 123, rev = 0;
    while (num > 0) {
        rev = rev * 10 + (num % 10);
        num = Math.floor(num / 10);
    }
    console.log(rev);
    ```

- **Right-angled triangle (5 rows)**
    ```javascript
    let i = 1;
    while (i <= 5) {
        let row = "", j = 1;
        while (j <= i) {
            row += "* ";
            j++;
        }
        console.log(row);
        i++;
    }
    ```

#### Practice (while)

1. 4×4 square of stars  
2. Inverted right triangle (5 rows)  
3. Centered pyramid (4 rows)  

---

## 3. Do…While Loop

**Definition:** Like `while`, but executes the block **at least once** before checking the condition.

**Syntax:**
```javascript
do {
    // code
    // update condition
} while (condition);
```

**Examples:**

- **Print 1 to 5**
    ```javascript
    let i = 1;
    do {
        console.log(i++);
    } while (i <= 5);
    ```

- **Count chars in a string**
    ```javascript
    const str = "Hello, World!";
    let count = 0, idx = 0;
    do {
        if (str[idx]) count++;
        idx++;
    } while (idx < str.length);
    console.log(count);
    ```

#### Practice (do…while)

1. Odd numbers up to 9  
2. Inverted right triangle (5 rows)  
3. 4×4 square of stars  
4. Hollow square (5×5)  

---

## 4. For…In Loop

**Definition:** Iterates over **object properties** (or array indices).

**Syntax:**
```javascript
for (let key in object) {
    // use object[key]
}
```

**Examples:**

- **Sum object values**
    ```javascript
    const scores = { math:90, eng:85, sci:95 };
    let total = 0;
    for (let subject in scores) {
        total += scores[subject];
    }
    console.log(total);
    ```

- **Count object props**
    ```javascript
    const car = { brand:"Toyota", model:"Camry", year:2020 };
    let count = 0;
    for (let k in car) count++;
    console.log(count);
    ```

- **Filter string values**
    ```javascript
    const person = { name:"John", age:30, city:"NY", isStudent:false };
    for (let k in person) {
        if (typeof person[k] === "string") {
            console.log(`${k}: ${person[k]}`);
        }
    }
    ```

#### Practice (for…in)

- Build a repeated‐pattern using object values, e.g.:  
    ```js
    const sizes = { small:3, medium:5, large:7 };
    // small: ***
    // medium: *****
    // large: *******
    ```

---

## 5. For…Of Loop

**Definition:** Iterates over **iterable** objects (arrays, strings).

**Syntax:**
```javascript
for (let item of iterable) {
    // use item
}
```

**Examples:**

- **Sum array**
    ```javascript
    const expenses = [100,200,300];
    let total = 0;
    for (let x of expenses) total += x;
    console.log(total);
    ```

- **Longest string**
    ```javascript
    const words = ["cat","elephant","dog"];
    let longest = "";
    for (let w of words) {
        if (w.length > longest.length) longest = w;
    }
    console.log(longest);
    ```

- **Filter positives**
    ```javascript
    const nums = [-5,10,-3,7,4];
    const positives = [];
    for (let n of nums) {
        if (n > 0) positives.push(n);
    }
    console.log(positives);
    ```

---

## 6. break and continue

- **break**: exits the current loop immediately.  
- **continue**: skips to the next iteration.

**Examples:**

- **First negative in array**
    ```javascript
    const arr = [5,8,-3,10];
    for (let n of arr) {
        if (n < 0) {
            console.log(n);
            break;
        }
    }
    ```

- **Skip vowels in a string**
    ```javascript
    for (let c of "hello") {
        if ("aeiou".includes(c)) continue;
        console.log(c);
    }
    ```

#### Practice (break/continue)

1. Skip zeros in `[10,0,25,0,30]`  
2. Sum numbers until total > 20 (do…while)  

---

End of **Loops.md**  
