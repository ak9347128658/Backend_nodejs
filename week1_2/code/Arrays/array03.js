// 4.Sorting And Reversing Arrays
// .sort(compareFuction): Sorts the array in AnimationPlaybackEvent(default is lexicographical order for string)

// let fruits = ["banana", "apple", "cherry"];
// console.log("Before :",fruits);
// fruits.sort();
// console.log("After :",fruits);

// unicode link
// https://docs.hexagonppm.com/r/en-US/Full-Text-Retrieval-FTR-Help/Version-2012-R1-SP5-3.6.6/97693

// Lexicographical Comparison:

// "apple" comes before "banana" because "a" < "b".   
// unicode value of "a" is 97 and "b" is 98

// "banana" comes before "cherry" because "b" < "c".

// Sorted Result:

// The array becomes: ["apple", "banana", "cherry"]

// example 2:
// let numbers = [3,5,7,8,6];
// console.log("Before :",numbers);
// numbers.sort();
// console.log("After :",numbers);

// example 3:
// let number = [10,2,5];
// console.log("Before :",number);
// number.sort();
// console.log("After :",number);

// 1. let numbers = [10, 2, 5];
// This creates an array called numbers with three elements: [10, 2, 5].

// 2. numbers.sort((a, b) => a - b);
// The .sort() method is used to sort the array.

// By default, .sort() converts elements to strings and sorts them lexicographically (e.g., "10" comes before "2").

// To sort numbers numerically, you provide a custom comparator function: (a, b) => a - b.

// let numbers = [10, 2, 5];
// console.log("Before :", numbers);
// numbers.sort((a, b) => a - b);
// console.log("After :", numbers);

// How (a, b) => a - b works:
// This is the compare function, and it tells .sort() how to order elements:

// If the result is negative (a < b), then a comes before b.

// If the result is zero, the order stays the same.

// If the result is positive (a > b), then b comes before a.

// if positive then b comes before a ,if negative then a comes before b else order stays the same

// So, .sort((a, b) => a - b) sorts the array in ascending numerical order.

// Internal comparison steps:
// Let's apply the comparator to [10, 2, 5]:

// Compare 10 and 2 → 10 - 2 = 8 → swap → [2, 10, 5]

// Compare 10 and 5 → 10 - 5 = 5 → swap → [2, 5, 10]

// Compare 2 and 5 → 2 - 5 = -3 → do nothing

// .reverse(): Reverses the order of the elements in the array
// example 1:
// let fruits = ["banana", "apple", "cherry", "date"];
// console.log("Before :", fruits);
// fruits.reverse();
// console.log("After :", fruits);

// exampe 2: reverse numbers
// let numbers = [1, 2, 3, 4, 5];
// console.log("Before :", numbers);
// numbers.reverse();
// console.log("After :", numbers);

// Joining and Splitting Arrays:
// let fruits = ["apple","banana","orange"];
// console.log("Before :", fruits);
// console.log("type of fruits:", typeof fruits);
// let joinedFruits = fruits.join(", ");
// console.log("Joined Fruits:", joinedFruits);
// console.log("type of joinedFruits:", typeof joinedFruits);

// concat(...arrays): Combines two or more arrays into one new array
// let fruits = ["Apple", "Banana", "Orange"];
// let moreFruits = ["Kiwi","Mango"];
// let allFruits = fruits.concat(moreFruits);
// console.log("All Fruits:", allFruits);

// slice(start, end): Returns a shallow copy of a portion of an array into a new array object
// let fruits = ["Apple", "Banana", "Orange", "Kiwi", "Mango"];
// let subset = fruits.slice(1,4);
// console.log("Subset of Fruits:", subset); // ["Banana", "Orange"]

// Copying and Filling Arrays:
// let arr = [1, 2, 3, 4, 5];
// console.log("Original Array:", arr);
// arr.copyWithin(0,3,5);
// console.log("After copyWithin:", arr); // [4, 5, 3, 4, 5]

// array.copyWithin(target, start, end)

// target: Index at which to copy the elements to.

// start: Index to start copying elements from.

// end (optional): Index to stop copying elements from (not inclusive).

// Let's apply it step-by-step:
// arr = [1, 2, 3, 4, 5]
// arr.copyWithin(0, 3, 5) means:

// Original:   [1, 2, 3, 4, 5]
// Indexes:     0  1  2  3  4
// positions:   1  2  3  4  5
// step: Copy [4,5] -> to index 0
// Result [4,5,3,4,5]

// fill(value, start, end): Fills all the elements of an array from a start index to an end index with a static value
let arr = [1, 2, 3, 4];
console.log("Original Array:", arr);
arr.fill(0,1,3);
console.log("After fill:", arr); // [1, 0, 0, 4]

// array.fill(value, start, end)
// value: The value to fill the array with.

// start: The index to start filling (inclusive).

// end: The index to stop filling (exclusive).

// arr = [1, 2, 3, 4]

// Fill the array with 0 from index 1 to 3 (exclusive of 3).

// So, it affects:

// arr[1] → becomes 0

// arr[2] → becomes 0

// arr[3] → not affected (because end is exclusive)

// Result: [1, 0, 0, 4]