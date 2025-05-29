// Object Spread and Rest Operators
// The spread (...) operator copies or merges object properties, while the (...rest) rest operator collects remaining properties

// Examples

// 1.Spread for Cloning
// const original = {
//     name: "Uma",
//     age: 30,
//     hobbies: ["reading", "traveling"]
// }


// const clone = {...original};

// console.log(clone);


// 2. Spread for Merging

// const obj1 = { a: 1};
// const obj2 = { b: 2}

// const merged = {...obj1, ...obj2};

// console.log(merged);

// 3. Spread with Overrides
// const defaults = {
//     theme: "light", font:"Arial"
// }

// const userPrefs = {
//     theme: "dark"
// }

// const settings = { ...defaults,...userPrefs};
// console.log(settings); 

// 4.Rest in Destructuring
// const user = {
//     name: "Vera",
//     age: 27,
//     role:"User"
// }
// const {name:myname,age} = user;
// const {name,age} = user;

// console.log(name);

// 5.Combining Spread and Rest
// const base = {
//     id: 1,
//     name: "Will",
//     age: 35,
//     hobbies: ["coding", "gaming"],
//     city: "San Francisco",
//     phoneNumber: "123-456-7890"
// }
// const {id,phoneNumber,...rest} = base;

// console.log(id);
// console.log(rest);
