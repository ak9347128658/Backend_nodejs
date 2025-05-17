// Operators in Javascript are symbols that tell our interpreter to perform logical operations, mathematical operations, or conditional operations.

// 1.Binary Operator: This Operator has two operands, where the operator is in between these two operands.

// 2. Unary Operator: This Operator has a single operand and the operator is either before the operand or after the operand.


// Types of Operators in Javascript

// 1. Assignment Operator

// 2. Arithemetic Operator

// 3. Comparison Operator

// 4. conditional Operator. (Special Operator ternary operator)

// 5. Logical Operator

// 1.Assignment Operator: The job of the Assignment Operator is to assign a value to a variable. The assignment operator is represented by the equal sign (=). The assignment operator can also be used to assign values to variables in a single line of code. For example, you can assign a value to a variable and then use that variable in an expression.

// Example: a = b which means a holds the value of b.(value of b is assigned to a)
// let a = 10;
// let b = 5;

// console.log(a); 
// a = b; 

// a = a+b; // 5 + 5 = 10

// a = a-b; // 10 - 5 = 5

// a = a*b; // 5 * 5 = 25

// a = a/b; // 25 / 5 = 5

// console.log(a); 


// 2> Arithemetic Operator:The job of the Arithmetic Operator is to perform an Arithmetic operation on two numeric operands either can be literals or can be variables.
// After performing the the Arithmetic Operation it provides a single numerical value;
//  Basic Arithmetic Operators are: + , - , * , / , %(modular operatior) , ++ , --

// a = b + c 
// a = b - c
// a = b * c
// a = b / c
// a = b % c

// Example:
// let a = 10;
// let b = 5;
// let c;

// c = a+ b;

// c = a - b;

// c = a * b;

// c = a / b;

// c = a % b;

// c = a++;

// c = ++a;

// c = a--;

// c = --a;
// console.log(c); 


// 3. Comparison Operator
// As the name suggests this operator’s Job is to compare the values of operands and return a logical value only if the comparison is true.
// These operands can be anything it can be string, number, object values.
// Conditional operators are mostly used with if-else, else if for comparing and returning required results.

// Basic Comparison Operators are: == , === , != , !== , > , < , >= , <=

// Example:

// let a = 7;
// let b = 3;
// let c = "3";
// let d = 7;
// let e; //stroing output of comparison

// e = a == b; // 7 == 3 = false

// e = b == c; // 3 == "3" = true

// e = a === d; // 7 === 7 = true

// e = b === c; // 3 === "3" = false

// e = c !== b;  // "3" !== 3 = !true = false

// e = a > b;  // 7 > 3 = true

// console.log(e); // true

// 4. Conditional Operator: The conditional operator is also known as the ternary operator. It is a shorthand way of writing an if-else statement. It takes three operands and returns one of the two values based on the condition.

// Example:

// let a = true;
// let b = false;

// a ? console.log("A") : console.log("B");

// b ? console.log("A") : console.log("B");

// complex condition example for ternary operator:

// let a = 10;
// let b = 20;
// let c = 30;
// let d = 40;


// a > b ? console.log("A") : b > c ? console.log("B") : c > d ? console.log("C") : console.log("D");


// 5. Logical Operator: The job of a logical operator is to compare two sets of opeations and then return the Boolean value true or false depending on an operator to operate.

//  Logical operators are: && (AND) , || (OR) , !(NOT)

// There are three types of logical operators:

// 1.Logical AND denoted as && which compares two conditions or operands and returns value only if both of them are true.

// 2.Logical OR denoted as || which compares two conditions or operands and returns a value if any one of the two conditions is true.

// 3.Logical NOT denoted as ! which compares two operands and returns a value if not equal true if equal then false.


// Example 1(AND operator):

// let a = 7;
// let b = 3;

// // AND operator
// if(a > 5 && b < 2) {
//  console.log("TRUE");
// }else{
//  console.log("FALSE");
// }



// Exampe 2 (OR operator):

// let a = 7;
// let b = 3;

// if(a > 5 || b < 2) {
//  console.log("TRUE");
// }else{
//     console.log("FALSE");
// }

// if(b < 2 || a > 5) {
//  console.log("TRUE");
// }else{
//     console.log("FALSE");
// }

// if(b < 2 || a > 8) {
//  console.log("TRUE");
// }else{
//     console.log("FALSE");
// }

// Example 3 (NOT operator):

// let a = 7;
// let b = 3;

// if(!(a > 5)) {
//     console.log("TRUE");
// }
// else{
//     console.log("FALSE");
// }


// typeof: This operator return the type of the variable value that is a string,number,boolean,object,etc.

// Example:
// let a = 10;
// let b = "hello";
// let c = true;

// let e = typeof a;

// let f = typeof b;

// let g = typeof c;

// console.log(e); // number
// console.log(f); // string
// console.log(g); // boolean