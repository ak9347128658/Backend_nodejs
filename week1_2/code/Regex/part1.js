
// Regex Flags
// Flags modify how the regex engine processes patterns:

// g (global): Find all matches, not just the first
// i (ignore case): Case-insensitive matching
// m (multiline): ^ and $ match line breaks
// s (dotall): . matches newlines
// u (unicode): Enable Unicode support
// y (sticky): Match from lastIndex position

// Examples
// Testing a simple Pattern
// const regex = /hello/;
// const str = "hellow world";
// console.log(regex.test(str));

// checking multiple stings
// const greetings = ["hellow", "hi" , "hey" , "hello there"];
// greetings.forEach((greeting) => {
//    console.log(`${greeting} matches : ${regex.test(greeting)}`);
// })


// 2. Case-insensitive RegExp Object
// const searchTerm = "node";
// const regex = new RegExp(searchTerm,"i")
// const texts = ["NODE.js is awesome","I love Node.js","Python vs node"];

// texts.forEach(text => {
//     console.log(`"${text}" contains "${searchTerm}": ${regex.test(text)}`);
// });

// 3. Finding Details with exec()
// const regex = /\d+/g;
// const str = "Order 123 received, tracking number 456789";
// let match;

// while ((match = regex.exec(str)) !== null) {
//     console.log(`Found: ${match[0]} at position ${match.index}`);
//     console.log(`Next search starts at: ${regex.lastIndex}`);
// }

// Replacing Text with Functions
// const regex = /bad/g;
// let str = "This is a bad example with bad words";
// str = str.replace(regex, "good")
// console.log(str);

// Advanced replacement with function

// const text = "hello world from node.js";
// const capitalizeRegex = /\b\w+\b/g;

// const capitalized = text.replace(capitalizeRegex, (word) => {
//    return word.charAt(0).toUpperCase() + word.slice(1);
// });

// console.log(capitalized);


// Finding Match Index and multiple Operations

//finding position of matches
// const regex = /world/i;
// const str = "Hello World! Welcome to the world of regex";
// console.log(str.search(regex));

//if you want to search first occourance in a stirng of a word u can perfom while 

// Mutiple operations on the same string
// const text = "The price is $19.99 and the tax is $2.50";
// const priceRegex = /\$(\d+\.\d{2})/g;

// console.log("Original : ",text);
// console.log("Search Index :", text.search(priceRegex))
// console.log("All Matches : ",text.match(priceRegex))
// console.log("Replace prices : ", text.replace(priceRegex, "RS 1"));

// splitting with regex
// const csvData = "name,age,city\njohn,25,someCity"
// const lines = csvData.split(/\n/);
// console.log(lines);