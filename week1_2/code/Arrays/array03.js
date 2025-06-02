// 4.Sorting And Reversing Arrays
// Examples
// .sort(compareFuction) : Sorts the array in place(default is lexicographical order for strings)
// ex1
// let fruits = ['banana','apple','cherry'];

// console.log("Before sorting:", fruits);
// fruits.sort();
// console.log("After sorting:", fruits);
// ex2


let numbers = [10,2,5];
console.log("Before sorting:", numbers);
let count = 0;
numbers.sort((a,b) => {
    count++;
  return a -b;
});
console.log("Count of comparisons:", count);
console.log("After sorting:", numbers);

// https://grok.com/chat/b4f514c0-4aae-478f-9fd0-64054c891c73