# Complete Regex Mastery Guide for Node.js Backend Development

This comprehensive tutorial will teach you everything you need to know about Regular Expressions (Regex) in Node.js. Whether you're a beginner or looking to master advanced concepts, this guide covers foundational patterns, advanced techniques, performance optimization, and real-world applications specifically for backend developers.

**What You'll Learn:**
- Core regex concepts and syntax
- Advanced pattern matching techniques
- Performance optimization strategies
- Practical backend applications
- Common pitfalls and how to avoid them
- Best practices for maintainable regex code

Each section includes detailed explanations, multiple examples with Node.js code, and hands-on practice exercises to reinforce your learning.e-Day Regex Tutorial for Node.js Backend Development
This tutorial provides a comprehensive guide to mastering Regular Expressions (Regex) in Node.js for backend developers. It covers foundational and advanced regex concepts, their implementation in Node.js, and practical applications in backend tasks like validation, parsing, and data processing. Each topic includes at least five examples with Node.js code, followed by practice questions to reinforce understanding. The goal is to equip developers with the skills to use regex effectively in Node.js applications.
## Table of Contents

1. [Introduction to Regular Expressions](#introduction-to-regular-expressions)
2. [Basic Regex Patterns](#basic-regex-patterns)
3. [Character Classes and Quantifiers](#character-classes-and-quantifiers)
4. [Anchors and Boundaries](#anchors-and-boundaries)
5. [Groups and Capturing](#groups-and-capturing)
6. [Lookaheads and Lookbehinds](#lookaheads-and-lookbehinds)
7. [Backreferences and Recursive Patterns](#backreferences-and-recursive-patterns)
8. [Advanced Regex Techniques](#advanced-regex-techniques)
9. [Unicode and Internationalization](#unicode-and-internationalization)
10. [Regex Performance Optimization](#regex-performance-optimization)
11. [Error Handling and Debugging](#error-handling-and-debugging)
12. [Practical Applications in Node.js](#practical-applications-in-nodejs)
13. [Common Pitfalls and Solutions](#common-pitfalls-and-solutions)
14. [Practice Questions](#practice-questions)


## 1. Introduction to Regular Expressions

### Overview
Regular Expressions (regex) are powerful pattern-matching tools that allow you to search, match, and manipulate text based on specific rules and patterns. Think of regex as a sophisticated search language that can describe complex text patterns with concise syntax.

In Node.js, regex is natively supported through JavaScript's `RegExp` object and regex literals (e.g., `/pattern/flags`). They are indispensable for backend development tasks such as:
- **Input validation** (emails, passwords, phone numbers)
- **Data parsing** (log files, CSV data, API responses)
- **Text processing** (cleaning, formatting, extraction)
- **URL routing** (Express.js route patterns)
- **Security** (input sanitization, XSS prevention)

### Key Methods in Node.js

Understanding these core methods is crucial for effective regex usage:

| Method | Description | Returns | Use Case |
|--------|-------------|---------|----------|
| `test()` | Tests if string matches pattern | `boolean` | Quick validation |
| `exec()` | Executes search and returns details | `Array` or `null` | Detailed match info |
| `match()` | Finds matches in string | `Array` or `null` | Extract all matches |
| `replace()` | Replaces matched text | `string` | Text transformation |
| `search()` | Finds position of match | `number` | Locate patterns |
| `split()` | Splits string using regex | `Array` | Parse delimited data |

### Regex Flags (Modifiers)

Flags modify how the regex engine processes patterns:

- **`g`** (global): Find all matches, not just the first
- **`i`** (ignore case): Case-insensitive matching
- **`m`** (multiline): `^` and `$` match line breaks
- **`s`** (dotall): `.` matches newlines
- **`u`** (unicode): Enable Unicode support
- **`y`** (sticky): Match from lastIndex position

### Example Setup
Create a new file for each example (e.g., `regex-example.js`) and run with `node regex-example.js`. All examples are compatible with Node.js v14+.

### Examples

#### 1. Testing a Simple Pattern
```javascript
// Basic pattern matching
const regex = /hello/;
const str = "hello world";
console.log(regex.test(str)); // true
console.log(regex.test("Hello world")); // false (case sensitive)

// Checking multiple strings
const greetings = ["hello", "hi", "hey", "hello there"];
greetings.forEach(greeting => {
    console.log(`"${greeting}" matches: ${regex.test(greeting)}`);
});
```

#### 2. Case-Insensitive RegExp Object
```javascript
// Creating regex with constructor for dynamic patterns
const searchTerm = "node";
const regex = new RegExp(searchTerm, "i");
const texts = ["NODE.js is awesome", "I love Node.js", "Python vs node"];

texts.forEach(text => {
    console.log(`"${text}" contains "${searchTerm}": ${regex.test(text)}`);
});

// Dynamic pattern building
function createCaseInsensitiveRegex(word) {
    return new RegExp(`\\b${word}\\b`, "i");
}
```

#### 3. Finding Details with exec()
```javascript
// Extracting detailed match information
const regex = /\d+/g;
const str = "Order 123 received, tracking number 456789";

let match;
while ((match = regex.exec(str)) !== null) {
    console.log(`Found: ${match[0]} at position ${match.index}`);
    console.log(`Next search starts at: ${regex.lastIndex}`);
}

// Single execution example
const emailRegex = /([a-zA-Z0-9._%+-]+)@([a-zA-Z0-9.-]+\.[a-zA-Z]{2,})/;
const emailStr = "Contact us at support@example.com";
const emailMatch = emailRegex.exec(emailStr);
if (emailMatch) {
    console.log(`Full match: ${emailMatch[0]}`);
    console.log(`Username: ${emailMatch[1]}`);
    console.log(`Domain: ${emailMatch[2]}`);
}
```

#### 4. Replacing Text with Functions
```javascript
// Simple replacement
const regex = /bad/g;
const str = "This is a bad example with bad words";
console.log(str.replace(regex, "good"));

// Advanced replacement with function
const capitalizeRegex = /\b\w+\b/g;
const text = "hello world from node.js";
const capitalized = text.replace(capitalizeRegex, (match) => {
    return match.charAt(0).toUpperCase() + match.slice(1);
});
console.log(capitalized); // "Hello World From Node.js"

// Replacement with captured groups
const phoneRegex = /(\d{3})-(\d{3})-(\d{4})/g;
const phoneText = "Call me at 123-456-7890 or 098-765-4321";
const formatted = phoneText.replace(phoneRegex, "($1) $2-$3");
console.log(formatted);
```

#### 5. Finding Match Index and Multiple Operations
```javascript
// Finding position of matches
const regex = /world/i;
const str = "Hello World! Welcome to the world of regex";
console.log(str.search(regex)); // 6

// Multiple operations on the same string
const text = "The price is $19.99 and the tax is $2.50";
const priceRegex = /\$(\d+\.\d{2})/g;

console.log("Original:", text);
console.log("Search index:", text.search(priceRegex));
console.log("All matches:", text.match(priceRegex));
console.log("Replace prices:", text.replace(priceRegex, "€$1"));

// Splitting with regex
const csvData = "name,age,city\nJohn,25,NYC\nJane,30,LA";
const lines = csvData.split(/\r?\n/);
console.log("CSV lines:", lines);
```




## 2. Basic Regex Patterns

### Overview
Basic regex patterns form the foundation of pattern matching. They include literal characters (exact matches), metacharacters (special symbols with specific meanings), and flags that modify the regex behavior.

### Literal Characters
These match exactly as written: `a`, `1`, `@`, etc.

### Metacharacters (Special Characters)
| Character | Meaning | Example |
|-----------|---------|---------|
| `.` | Any character except newline | `a.c` matches `abc`, `a1c` |
| `*` | 0 or more of preceding | `ab*` matches `a`, `ab`, `abbb` |
| `+` | 1 or more of preceding | `ab+` matches `ab`, `abbb` |
| `?` | 0 or 1 of preceding | `ab?` matches `a`, `ab` |
| `^` | Start of string/line | `^hello` matches `hello world` |
| `$` | End of string/line | `world$` matches `hello world` |
| `\` | Escape character | `\.` matches literal dot |
| `|` | OR operator | `cat|dog` matches `cat` or `dog` |
| `[]` | Character class | `[abc]` matches `a`, `b`, or `c` |
| `()` | Group | `(abc)+` matches `abc`, `abcabc` |

### Regex Flags in Detail
- **Global (`g`)**: Without this flag, regex stops after first match
- **Case-insensitive (`i`)**: Ignores letter case
- **Multiline (`m`)**: Changes behavior of `^` and `$` anchors
- **Dotall (`s`)**: Makes `.` match newline characters
- **Unicode (`u`)**: Proper Unicode handling
- **Sticky (`y`)**: Matches only at `lastIndex` position

### Examples

#### 1. Matching Literal Strings and Patterns
```javascript
// Exact literal matching
const regex = /cat/;
const strings = ["cat", "dog", "caterpillar", "scat", "CAT"];

strings.forEach(str => {
    console.log(`"${str}" matches /cat/: ${regex.test(str)}`);
});

// Case sensitivity demonstration
const caseRegex = /Cat/;
const iCaseRegex = /Cat/i;
const testString = "The cat and Cat are different";

console.log("Case sensitive:", testString.match(caseRegex));
console.log("Case insensitive:", testString.match(iCaseRegex));
```

#### 2. Global Flag for Multiple Matches
```javascript
// Without global flag (stops at first match)
const regex1 = /a/;
const regex2 = /a/g;
const str = "banana split";

console.log("Without global flag:", str.match(regex1)); // ['a']
console.log("With global flag:", str.match(regex2)); // ['a', 'a', 'a']

// Practical example: counting occurrences
function countOccurrences(text, pattern) {
    const regex = new RegExp(pattern, 'g');
    const matches = text.match(regex);
    return matches ? matches.length : 0;
}

console.log("'a' appears:", countOccurrences("banana", "a"), "times");
console.log("'an' appears:", countOccurrences("banana", "an"), "times");
```

#### 3. Case-Insensitive Matching with Practical Applications
```javascript
// User input validation (case-insensitive)
function validateCommand(input) {
    const validCommands = [/^start$/i, /^stop$/i, /^restart$/i, /^status$/i];
    return validCommands.some(regex => regex.test(input.trim()));
}

const userInputs = ["START", "stop", "ReStar", "status", "invalid"];
userInputs.forEach(input => {
    console.log(`"${input}" is valid: ${validateCommand(input)}`);
});

// Configuration file parsing
const configLine = "DEBUG=true";
const configRegex = /^(\w+)\s*=\s*(.+)$/i;
const match = configLine.match(configRegex);
if (match) {
    console.log(`Key: ${match[1]}, Value: ${match[2]}`);
}
```

#### 4. Dot (.) Metacharacter Usage
```javascript
// Dot matches any character except newline
const regex = /h.t/g;
const str = "hot hat hit hut h t h\nt";

console.log("Matches for /h.t/:", str.match(regex));

// Practical example: flexible file extension matching
const fileRegex = /\w+\.\w{3,4}$/; // filename.ext (3-4 char extension)
const files = ["document.pdf", "image.jpeg", "script.js", "data.json", "readme"];

files.forEach(file => {
    console.log(`"${file}" is valid file: ${fileRegex.test(file)}`);
});

// Dotall flag example
const multilineText = "line1\nline2";
const dotRegex = /line1.line2/;
const dotallRegex = /line1.line2/s;

console.log("Without dotall:", dotRegex.test(multilineText)); // false
console.log("With dotall:", dotallRegex.test(multilineText)); // true
```

#### 5. Escaping Special Characters
```javascript
// Escaping metacharacters to match them literally
const specialChars = "file.txt $100 (test) [array] {object} *important* +plus+ ?maybe?";

// Match literal dots in filenames
const dotRegex = /\w+\.\w+/g;
console.log("Files found:", specialChars.match(dotRegex));

// Match dollar amounts
const dollarRegex = /\$\d+/g;
console.log("Dollar amounts:", specialChars.match(dollarRegex));

// Match text in parentheses
const parenRegex = /\([^)]+\)/g;
console.log("In parentheses:", specialChars.match(parenRegex));

// Escaping user input for safe regex
function escapeRegexChars(string) {
    return string.replace(/[.*+?^${}()|[\]\\]/g, '\\$&');
}

const userInput = "What is 2+2?";
const escapedInput = escapeRegexChars(userInput);
const searchRegex = new RegExp(escapedInput, 'i');
console.log("Escaped pattern:", escapedInput);
console.log("Matches:", searchRegex.test("He asked: What is 2+2?"));
```




## 3. Character Classes and Quantifiers

### Overview
Character classes define sets of characters to match, while quantifiers specify how many times a pattern should occur. These are essential for creating flexible and powerful regex patterns.

### Character Classes
| Class | Meaning | Equivalent |
|-------|---------|------------|
| `\d` | Digit | `[0-9]` |
| `\D` | Non-digit | `[^0-9]` |
| `\w` | Word character | `[a-zA-Z0-9_]` |
| `\W` | Non-word character | `[^a-zA-Z0-9_]` |
| `\s` | Whitespace | `[ \t\r\n\f]` |
| `\S` | Non-whitespace | `[^ \t\r\n\f]` |
| `[abc]` | Any of a, b, or c | - |
| `[^abc]` | Not a, b, or c | - |
| `[a-z]` | Lowercase letters | - |
| `[A-Z]` | Uppercase letters | - |
| `[0-9]` | Digits | `\d` |

### Quantifiers
| Quantifier | Meaning | Example |
|------------|---------|---------|
| `*` | 0 or more | `ab*` matches `a`, `ab`, `abbbb` |
| `+` | 1 or more | `ab+` matches `ab`, `abbbb` |
| `?` | 0 or 1 (optional) | `ab?` matches `a`, `ab` |
| `{n}` | Exactly n times | `a{3}` matches `aaa` |
| `{n,}` | n or more times | `a{2,}` matches `aa`, `aaa`, `aaaa` |
| `{n,m}` | Between n and m times | `a{2,4}` matches `aa`, `aaa`, `aaaa` |

### Greedy vs Lazy Quantifiers
- **Greedy** (default): Matches as much as possible
- **Lazy** (add `?`): Matches as little as possible
  - `*?` - Lazy zero or more
  - `+?` - Lazy one or more
  - `??` - Lazy zero or one
  - `{n,m}?` - Lazy range

### Examples

#### 1. Matching Digits in Various Contexts
```javascript
// Basic digit matching
const digitRegex = /\d+/g;
const str = "Order123 contains 456 items, total $78.90";
console.log("All digits:", str.match(digitRegex)); // ['123', '456', '78', '90']

// Specific digit patterns
const phoneRegex = /\d{3}-\d{3}-\d{4}/;
const creditCardRegex = /\d{4}-\d{4}-\d{4}-\d{4}/;
const zipRegex = /\d{5}(-\d{4})?/; // ZIP or ZIP+4

const testData = [
    "Call 555-123-4567",
    "Card: 1234-5678-9012-3456",
    "ZIP: 12345",
    "ZIP+4: 12345-6789"
];

testData.forEach(data => {
    console.log(`Phone in "${data}":`, phoneRegex.test(data));
    console.log(`Credit card in "${data}":`, creditCardRegex.test(data));
    console.log(`ZIP in "${data}":`, zipRegex.test(data));
});
```

#### 2. Word Characters and Identifiers
```javascript
// Word character matching
const wordRegex = /\w+/g;
const identifierRegex = /^[a-zA-Z_]\w*$/; // Valid programming identifier
const str = "Hello_World123! @#$ test-case";

console.log("Word characters:", str.match(wordRegex)); // ['Hello_World123', 'test', 'case']

// Validate programming identifiers
const identifiers = ["validName", "_private", "123invalid", "test-case", "another_valid_name"];
identifiers.forEach(id => {
    console.log(`"${id}" is valid identifier: ${identifierRegex.test(id)}`);
});

// Extract function names from code
const codeSnippet = `
function calculateTotal() {}
const processData = () => {}
function _privateMethod() {}
`;

const functionRegex = /function\s+(\w+)\s*\(/g;
const arrowFunctionRegex = /const\s+(\w+)\s*=/g;

let match;
console.log("Function names:");
while ((match = functionRegex.exec(codeSnippet)) !== null) {
    console.log("- " + match[1]);
}
```

#### 3. Quantifiers for Specific Repetitions
```javascript
// Exact repetition
const hexColorRegex = /^#[0-9A-Fa-f]{6}$/; // Hex color codes
const hexColors = ["#FF0000", "#123abc", "#GGG000", "#12345", "#1234567"];

hexColors.forEach(color => {
    console.log(`"${color}" is valid hex: ${hexColorRegex.test(color)}`);
});

// Range quantifiers
const passwordRegex = /^.{8,20}$/; // 8-20 characters
const strongPasswordRegex = /^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[@$!%*?&])[A-Za-z\d@$!%*?&]{8,}$/;

const passwords = ["weak", "StrongP@ss1", "VeryLongPasswordThatMightBeTooLong123!", "Short1!"];
passwords.forEach(pwd => {
    console.log(`"${pwd}" length OK: ${passwordRegex.test(pwd)}`);
    console.log(`"${pwd}" is strong: ${strongPasswordRegex.test(pwd)}`);
});

// Flexible matching with quantifiers
const variableSpaceRegex = /\w+\s+\w+/; // One or more spaces
const flexibleSpaceRegex = /\w+\s*=\s*\w+/; // Optional spaces around =

const assignments = ["name=value", "name = value", "name  =  value", "name="];
assignments.forEach(assignment => {
    console.log(`"${assignment}" matches flexible: ${flexibleSpaceRegex.test(assignment)}`);
});
```

#### 4. Character Ranges and Custom Classes
```javascript
// Character ranges
const lowercaseRegex = /^[a-z]+$/;
const uppercaseRegex = /^[A-Z]+$/;
const alphanumericRegex = /^[a-zA-Z0-9]+$/;
const customClassRegex = /^[a-zA-Z0-9._-]+$/; // Valid username characters

const testStrings = ["hello", "WORLD", "Test123", "user.name-123", "invalid@email"];
testStrings.forEach(str => {
    console.log(`"${str}" - lowercase: ${lowercaseRegex.test(str)}, uppercase: ${uppercaseRegex.test(str)}, alphanumeric: ${alphanumericRegex.test(str)}, valid username: ${customClassRegex.test(str)}`);
});

// Negated character classes
const noDigitsRegex = /^[^0-9]+$/; // No digits allowed
const noSpecialCharsRegex = /^[^@#$%^&*()]+$/; // No special characters

const inputs = ["hello", "hello123", "hello@world", "test$data"];
inputs.forEach(input => {
    console.log(`"${input}" - no digits: ${noDigitsRegex.test(input)}, no special: ${noSpecialCharsRegex.test(input)}`);
});

// Complex character classes
const emailLocalRegex = /^[a-zA-Z0-9._%+-]+$/; // Valid email local part
const domainRegex = /^[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$/; // Valid domain

console.log("Email parts validation:");
console.log("'user.name+tag' as local:", emailLocalRegex.test("user.name+tag"));
console.log("'example.com' as domain:", domainRegex.test("example.com"));
```

#### 5. Negated Character Classes and Advanced Patterns
```javascript
// Negated classes for validation
const noWhitespaceRegex = /^[^\s]+$/; // No whitespace
const alphaOnlyRegex = /^[^0-9\W]+$/; // Only letters (no digits or special chars)
const safeTextRegex = /^[^<>\"'&]+$/; // No HTML-unsafe characters

const userInputs = ["validtext", "has spaces", "has123numbers", "has<script>", "safe_text"];
userInputs.forEach(input => {
    console.log(`"${input}":`, {
        noWhitespace: noWhitespaceRegex.test(input),
        alphaOnly: alphaOnlyRegex.test(input),
        safeForHTML: safeTextRegex.test(input)
    });
});

// Greedy vs Lazy quantifiers
const greedyRegex = /<.+>/; // Greedy
const lazyRegex = /<.+?>/g; // Lazy
const htmlString = "<p>Hello</p><div>World</div>";

console.log("Greedy match:", htmlString.match(greedyRegex)); // Matches entire string
console.log("Lazy matches:", htmlString.match(lazyRegex)); // Matches individual tags

// Practical example: parsing CSV with quoted fields
const csvRegex = /"([^"]*)"|([^,]+)/g;
const csvLine = 'John,"Doe, Jr.",30,"Software Engineer"';
const fields = [];
let match;

while ((match = csvRegex.exec(csvLine)) !== null) {
    fields.push(match[1] || match[2]); // Quoted or unquoted field
}
console.log("CSV fields:", fields);
```




## 4. Anchors and Boundaries

### Overview
Anchors and boundaries are position-based assertions that don't consume characters but specify where in the text a match should occur. They're crucial for precise pattern matching and validation.

### Anchors
| Anchor | Meaning | Usage |
|--------|---------|--------|
| `^` | Start of string/line | `^Hello` matches "Hello world" but not "Say Hello" |
| `$` | End of string/line | `world$` matches "Hello world" but not "world peace" |
| `\A` | Start of string (not line) | Similar to `^` but not affected by multiline flag |
| `\Z` | End of string (not line) | Similar to `$` but not affected by multiline flag |

### Boundaries
| Boundary | Meaning | Example |
|----------|---------|---------|
| `\b` | Word boundary | `\bcat\b` matches "cat" but not "catch" |
| `\B` | Non-word boundary | `\Bcat\B` matches "cat" in "concatenate" |

### Multiline Mode
With the `m` flag, `^` and `$` match the start and end of each line, not just the entire string.

### Examples

#### 1. Start of String Validation
```javascript
// Validating string beginning
const startsWithRegex = /^Hello/;
const strings = [
    "Hello world",
    "Say Hello",
    "hello world", // case sensitive
    "Hello, how are you?",
    "Well, Hello there"
];

strings.forEach(str => {
    console.log(`"${str}" starts with 'Hello': ${startsWithRegex.test(str)}`);
});

// Practical example: Command validation
function validateCommand(input) {
    const validCommands = [
        /^\/help$/i,
        /^\/start$/i,
        /^\/stop$/i,
        /^\/restart\s+\w+$/i, // restart with parameter
        /^\/status$/i
    ];
    
    return validCommands.some(regex => regex.test(input.trim()));
}

const commands = ["/help", "/start server", "/restart nginx", "/invalid", "help"];
commands.forEach(cmd => {
    console.log(`"${cmd}" is valid command: ${validateCommand(cmd)}`);
});
```

#### 2. End of String Validation
```javascript
// File extension validation
const jsFileRegex = /\.js$/;
const imageFileRegex = /\.(jpg|jpeg|png|gif)$/i;
const executableRegex = /\.(exe|msi|dmg)$/i;

const files = [
    "script.js",
    "image.jpg",
    "document.pdf",
    "setup.exe",
    "script.js.backup", // doesn't end with .js
    "image.PNG" // case insensitive test
];

files.forEach(file => {
    console.log(`"${file}":`, {
        isJavaScript: jsFileRegex.test(file),
        isImage: imageFileRegex.test(file),
        isExecutable: executableRegex.test(file)
    });
});

// URL validation
const httpsUrlRegex = /^https:\/\/.+\.com$/;
const urls = [
    "https://example.com",
    "http://example.com", // doesn't start with https
    "https://example.org", // doesn't end with .com
    "https://sub.example.com"
];

urls.forEach(url => {
    console.log(`"${url}" is HTTPS .com URL: ${httpsUrlRegex.test(url)}`);
});
```

#### 3. Word Boundaries for Precise Matching
```javascript
// Word boundary examples
const wordBoundaryRegex = /\bcat\b/g;
const testText = "The cat in the category caught a catfish";

console.log("Text:", testText);
console.log("Matches with word boundary:", testText.match(wordBoundaryRegex));

// Without word boundary
const noWordBoundaryRegex = /cat/g;
console.log("Matches without word boundary:", testText.match(noWordBoundaryRegex));

// Practical search function
function searchWholeWords(text, searchTerm) {
    const regex = new RegExp(`\\b${searchTerm}\\b`, 'gi');
    return text.match(regex) || [];
}

const article = "JavaScript is a programming language. Java is also a programming language.";
console.log("Search 'Java':", searchWholeWords(article, "Java"));
console.log("Search 'Script':", searchWholeWords(article, "Script"));

// Variable name validation
const variableNameRegex = /^\b[a-zA-Z_]\w*\b$/;
const variableNames = ["validName", "_private", "123invalid", "test-case", "another_valid"];
variableNames.forEach(name => {
    console.log(`"${name}" is valid variable: ${variableNameRegex.test(name)}`);
});
```

#### 4. Non-Word Boundaries
```javascript
// Non-word boundary examples
const nonWordBoundaryRegex = /\Bcat\B/g;
const testStrings = [
    "cat",           // word boundary on both sides
    "catch",         // word boundary at start
    "scat",          // word boundary at end
    "concatenate",   // non-word boundary on both sides
    "education"      // no 'cat' substring
];

testStrings.forEach(str => {
    const matches = str.match(nonWordBoundaryRegex);
    console.log(`"${str}" - non-word boundary matches:`, matches);
});

// Finding partial matches within words
function findInternalMatches(text, pattern) {
    const regex = new RegExp(`\\B${pattern}\\B`, 'g');
    return text.match(regex) || [];
}

const text = "concatenate duplicate communicate";
console.log("'cat' within words:", findInternalMatches(text, "cat"));
console.log("'ate' within words:", findInternalMatches(text, "ate"));

// Password complexity: no common patterns within
const hasCommonPatterns = /\B(123|abc|qwe|pass|admin)\B/i;
const passwords = ["mypassword", "test123test", "abcdefgh", "securepwd"];
passwords.forEach(pwd => {
    console.log(`"${pwd}" has common patterns: ${hasCommonPatterns.test(pwd)}`);
});
```

#### 5. Combining Anchors and Multiline Mode
```javascript
// Multiline mode examples
const multilineText = `First line
Second line
Third line`;

// Without multiline flag
const singleLineRegex = /^Second/;
console.log("Single line mode matches 'Second':", singleLineRegex.test(multilineText));

// With multiline flag
const multiLineRegex = /^Second/m;
console.log("Multiline mode matches 'Second':", multiLineRegex.test(multilineText));

// Practical example: parsing configuration file
const configFile = `
# Database configuration
host=localhost
port=5432
database=myapp

# Redis configuration
redis_host=127.0.0.1
redis_port=6379
`;

const configRegex = /^(\w+)=(.+)$/gm;
const config = {};
let match;

while ((match = configRegex.exec(configFile)) !== null) {
    config[match[1]] = match[2];
}

console.log("Parsed configuration:", config);

// Validating each line format
const lines = configFile.split('\n').filter(line => line.trim() && !line.startsWith('#'));
const validLineRegex = /^\w+=.+$/;

lines.forEach(line => {
    console.log(`"${line.trim()}" is valid config: ${validLineRegex.test(line.trim())}`);
});

// Complete validation: starts and ends correctly
const completeEmailRegex = /^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$/;
const emails = [
    "user@example.com",
    " user@example.com ", // has spaces
    "user@example.com extra", // has extra text
    "user@example",
    "@example.com"
];

emails.forEach(email => {
    console.log(`"${email}" is complete valid email: ${completeEmailRegex.test(email)}`);
});
```




## 5. Groups and Capturing

### Overview
Groups in regex serve multiple purposes: they allow you to apply quantifiers to multiple characters, capture parts of matches for later use, and organize complex patterns. Understanding groups is essential for advanced regex usage and data extraction.

### Types of Groups
| Type | Syntax | Purpose |
|------|--------|---------|
| Capturing Group | `(pattern)` | Captures matched text for reuse |
| Non-capturing Group | `(?:pattern)` | Groups without capturing |
| Named Group | `(?<name>pattern)` | Captures with a custom name |
| Atomic Group | `(?>pattern)` | Prevents backtracking (limited support) |

### Accessing Captured Groups
- **Array indices**: `match[1]`, `match[2]`, etc.
- **Named groups**: `match.groups.name`
- **In replacements**: `$1`, `$2`, or `$<name>`

### Examples

#### 1. Basic Capturing Groups for Data Extraction
```javascript
// Email parsing with capturing groups
const emailRegex = /([a-zA-Z0-9._%+-]+)@([a-zA-Z0-9.-]+)\.([a-zA-Z]{2,})/;
const emails = [
    "john.doe@example.com",
    "admin@company.org",
    "support@subdomain.example.co.uk"
];

emails.forEach(email => {
    const match = email.match(emailRegex);
    if (match) {
        console.log(`Email: ${match[0]}`);
        console.log(`  Username: ${match[1]}`);
        console.log(`  Domain: ${match[2]}`);
        console.log(`  TLD: ${match[3]}`);
    }
});

// URL parsing
const urlRegex = /(https?):\/\/([^\/]+)(\/.*)?/;
const urls = [
    "https://www.example.com/path/to/page",
    "http://api.service.com",
    "https://subdomain.example.org/api/v1/users"
];

urls.forEach(url => {
    const match = url.match(urlRegex);
    if (match) {
        console.log(`URL: ${match[0]}`);
        console.log(`  Protocol: ${match[1]}`);
        console.log(`  Host: ${match[2]}`);
        console.log(`  Path: ${match[3] || '/'}`);
    }
});
```

#### 2. Multiple Groups for Complex Date Parsing
```javascript
// Date format parsing with multiple groups
const dateFormats = [
    {
        name: "US Format",
        regex: /(\d{1,2})\/(\d{1,2})\/(\d{4})/,
        order: ["month", "day", "year"]
    },
    {
        name: "ISO Format",
        regex: /(\d{4})-(\d{2})-(\d{2})/,
        order: ["year", "month", "day"]
    },
    {
        name: "European Format",
        regex: /(\d{1,2})\.(\d{1,2})\.(\d{4})/,
        order: ["day", "month", "year"]
    }
];

const testDates = ["12/31/2023", "2023-12-31", "31.12.2023", "invalid-date"];

function parseDate(dateString) {
    for (const format of dateFormats) {
        const match = dateString.match(format.regex);
        if (match) {
            const dateObj = {};
            format.order.forEach((part, index) => {
                dateObj[part] = match[index + 1];
            });
            return { format: format.name, ...dateObj };
        }
    }
    return null;
}

testDates.forEach(date => {
    const parsed = parseDate(date);
    console.log(`"${date}":`, parsed);
});

// Time parsing with optional components
const timeRegex = /(\d{1,2}):(\d{2})(?::(\d{2}))?(?:\s*(AM|PM))?/i;
const times = ["14:30", "2:30 PM", "14:30:45", "9:05:22 AM"];

times.forEach(time => {
    const match = time.match(timeRegex);
    if (match) {
        console.log(`Time: ${match[0]}`);
        console.log(`  Hour: ${match[1]}`);
        console.log(`  Minute: ${match[2]}`);
        console.log(`  Second: ${match[3] || 'N/A'}`);
        console.log(`  Period: ${match[4] || 'N/A'}`);
    }
});
```

#### 3. Using Groups in Replace Operations
```javascript
// Name formatting
const nameRegex = /(\w+),\s*(\w+)/;
const names = ["Doe, John", "Smith, Jane", "Johnson, Bob"];

const formattedNames = names.map(name => 
    name.replace(nameRegex, "$2 $1")
);
console.log("Formatted names:", formattedNames);

// Phone number formatting
const phoneRegex = /(\d{3})(\d{3})(\d{4})/;
const phoneNumbers = ["1234567890", "5551234567", "9876543210"];

const formattedPhones = phoneNumbers.map(phone => 
    phone.replace(phoneRegex, "($1) $2-$3")
);
console.log("Formatted phones:", formattedPhones);

// Advanced replacement with function
const camelCaseRegex = /([a-z])([A-Z])/g;
const camelCaseText = "firstName lastName emailAddress phoneNumber";

const snakeCase = camelCaseText.replace(camelCaseRegex, (match, lower, upper) => {
    return lower + '_' + upper.toLowerCase();
});
console.log("Snake case:", snakeCase);

// Template variable replacement
const templateRegex = /\{(\w+)\}/g;
const template = "Hello {name}, welcome to {site}! Your role is {role}.";
const variables = { name: "John", site: "MyApp", role: "Admin" };

const result = template.replace(templateRegex, (match, varName) => {
    return variables[varName] || match;
});
console.log("Template result:", result);
```

#### 4. Non-Capturing Groups for Performance
```javascript
// Without non-capturing groups (captures protocol unnecessarily)
const urlRegexCapturing = /(http|https):\/\/([^\/]+)/;

// With non-capturing groups (doesn't capture protocol)
const urlRegexNonCapturing = /(?:http|https):\/\/([^\/]+)/;

const testUrl = "https://example.com";

console.log("With capturing:", testUrl.match(urlRegexCapturing));
console.log("With non-capturing:", testUrl.match(urlRegexNonCapturing));

// Complex pattern with mixed groups
const logRegex = /(?:\d{4}-\d{2}-\d{2})\s+(?:\d{2}:\d{2}:\d{2})\s+\[(\w+)\]\s+(.*)/;
const logLine = "2023-12-31 23:59:59 [ERROR] Database connection failed";

const logMatch = logLine.match(logRegex);
if (logMatch) {
    console.log("Log level:", logMatch[1]);
    console.log("Message:", logMatch[2]);
}

// Performance comparison function
function benchmarkGroups(text, iterations = 100000) {
    const capturingRegex = /(http|https):\/\/([^\/]+)/g;
    const nonCapturingRegex = /(?:http|https):\/\/([^\/]+)/g;
    
    console.time("Capturing groups");
    for (let i = 0; i < iterations; i++) {
        text.match(capturingRegex);
    }
    console.timeEnd("Capturing groups");
    
    console.time("Non-capturing groups");
    for (let i = 0; i < iterations; i++) {
        text.match(nonCapturingRegex);
    }
    console.timeEnd("Non-capturing groups");
}

// Uncomment to run benchmark
// benchmarkGroups("Visit https://example.com and http://test.org");
```

#### 5. Named Groups for Cleaner Code
```javascript
// Named groups for better readability
const namedEmailRegex = /(?<username>[a-zA-Z0-9._%+-]+)@(?<domain>[a-zA-Z0-9.-]+)\.(?<tld>[a-zA-Z]{2,})/;
const email = "user.name+tag@example.co.uk";

const emailMatch = email.match(namedEmailRegex);
if (emailMatch) {
    const { username, domain, tld } = emailMatch.groups;
    console.log(`Username: ${username}, Domain: ${domain}, TLD: ${tld}`);
}

// Named groups in date parsing
const namedDateRegex = /(?<year>\d{4})-(?<month>\d{2})-(?<day>\d{2})/;
const isoDate = "2023-12-31";

const dateMatch = isoDate.match(namedDateRegex);
if (dateMatch) {
    console.log("Date components:", dateMatch.groups);
}

// Named groups in replacement
const nameFormattingRegex = /(?<last>\w+),\s*(?<first>\w+)/;
const formalName = "Doe, John";

const casualName = formalName.replace(nameFormattingRegex, "$<first> $<last>");
console.log("Casual format:", casualName);

// Complex log parsing with named groups
const complexLogRegex = /(?<timestamp>\d{4}-\d{2}-\d{2}\s+\d{2}:\d{2}:\d{2})\s+\[(?<level>\w+)\]\s+(?<logger>\w+):\s+(?<message>.*)/;
const complexLogLine = "2023-12-31 23:59:59 [ERROR] DatabaseManager: Connection timeout after 30 seconds";

const complexMatch = complexLogLine.match(complexLogRegex);
if (complexMatch) {
    console.log("Parsed log:", complexMatch.groups);
}

// Function to create structured data from named groups
function parseStructuredData(text, regex) {
    const match = text.match(regex);
    return match ? match.groups : null;
}

const serverLogRegex = /\[(?<timestamp>[^\]]+)\]\s+(?<ip>\d+\.\d+\.\d+\.\d+)\s+"(?<method>\w+)\s+(?<path>[^"]+)"\s+(?<status>\d+)\s+(?<size>\d+)/;
const serverLog = '[31/Dec/2023:23:59:59] 192.168.1.1 "GET /api/users" 200 1234';

console.log("Server log data:", parseStructuredData(serverLog, serverLogRegex));
```




## 6. Lookaheads and Lookbehinds

### Overview
Lookaround assertions (lookaheads and lookbehinds) are zero-width assertions that match a position in the string without consuming characters. They allow you to specify conditions that must be met before or after the current position without including those conditions in the actual match.

### Types of Lookarounds
| Type | Syntax | Description |
|------|--------|-------------|
| Positive Lookahead | `(?=...)` | Matches if followed by pattern |
| Negative Lookahead | `(?!...)` | Matches if NOT followed by pattern |
| Positive Lookbehind | `(?<=...)` | Matches if preceded by pattern |
| Negative Lookbehind | `(?<!...)` | Matches if NOT preceded by pattern |

### Use Cases
- Password validation with multiple requirements
- Extracting text between specific markers
- Finding patterns with specific context
- Complex validation rules

### Examples

#### 1. Positive Lookahead for Context-Aware Matching
```javascript
// Finding words followed by specific patterns
const wordBeforeComRegex = /\w+(?=\.com)/g;
const text = "Visit example.com and test.org, also check demo.com.au";

console.log("Domains ending in .com:", text.match(wordBeforeComRegex));

// Password validation: must contain uppercase
const hasUppercaseRegex = /(?=.*[A-Z])/;
const passwords = ["password", "Password", "PASSWORD", "pass123"];

passwords.forEach(pwd => {
    console.log(`"${pwd}" has uppercase: ${hasUppercaseRegex.test(pwd)}`);
});

// Finding numbers followed by currency
const numberBeforeCurrencyRegex = /\d+(?=\s*(?:USD|EUR|GBP))/g;
const priceText = "The prices are 100 USD, 50 EUR, and 75 GBP, plus 25 CAD";

console.log("Numbers with specified currencies:", priceText.match(numberBeforeCurrencyRegex));

// SQL injection detection: words followed by suspicious patterns
const suspiciousQueryRegex = /\w+(?=\s*[='].*(?:OR|AND|UNION))/gi;
const userInput = "username='admin' OR '1'='1'";
console.log("Suspicious patterns detected:", suspiciousQueryRegex.test(userInput));

// File names before specific extensions
const fileNameRegex = /[^\/\\]+(?=\.(jpg|png|gif)$)/gi;
const filePaths = [
    "/images/photo.jpg",
    "/docs/document.pdf",
    "/pics/avatar.png",
    "/files/data.csv"
];

filePaths.forEach(path => {
    const match = path.match(fileNameRegex);
    console.log(`"${path}" image filename:`, match ? match[0] : "none");
});
```

#### 2. Negative Lookahead for Exclusion Patterns
```javascript
// Words NOT followed by specific patterns
const wordNotBeforeComRegex = /\w+\.(?!com)\w+/g;
const domainText = "example.com test.org demo.net sample.com data.gov";

console.log("Domains NOT ending in .com:", domainText.match(wordNotBeforeComRegex));

// Password validation: must NOT contain dictionary words
const noDictionaryWordsRegex = /^(?!.*(?:password|123456|qwerty|admin)).+$/i;
const testPasswords = ["mypassword123", "secureP@ss", "admin123", "qwerty456"];

testPasswords.forEach(pwd => {
    console.log(`"${pwd}" avoids dictionary words: ${noDictionaryWordsRegex.test(pwd)}`);
});

// Find HTML tags that are NOT self-closing
const nonSelfClosingTagRegex = /<(\w+)(?!\s*\/?>)/g;
const htmlContent = `
    <div>Content</div>
    <img src="photo.jpg" />
    <p>Paragraph</p>
    <br />
    <span>Text</span>
`;

console.log("Non-self-closing tags:", htmlContent.match(nonSelfClosingTagRegex));

// Email validation: username NOT starting with numbers
const validEmailUserRegex = /^(?!\d)[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$/;
const emails = ["123user@example.com", "user123@example.com", "admin@test.org"];

emails.forEach(email => {
    console.log(`"${email}" has valid username: ${validEmailUserRegex.test(email)}`);
});

// Variable names NOT starting with reserved keywords
const validVariableRegex = /^(?!(?:var|let|const|function|class|if|else|for|while|do|break|continue|return|try|catch|finally|throw|new|this|super|typeof|instanceof|in|of|true|false|null|undefined)\b)\w+$/;
const variableNames = ["var", "username", "class", "userData", "function", "myFunction"];

variableNames.forEach(name => {
    console.log(`"${name}" is valid variable name: ${validVariableRegex.test(name)}`);
});
```

#### 3. Positive Lookbehind for Preceding Context
```javascript
// Numbers preceded by currency symbols
const priceRegex = /(?<=\$)\d+(?:\.\d{2})?/g;
const salesText = "Prices: $19.99, €25.50, $100, ¥500, $0.99";

console.log("Dollar amounts:", salesText.match(priceRegex));

// Words after specific markers
const afterColonRegex = /(?<=:\s*)\w+/g;
const configText = "host: localhost\nport: 3000\ndatabase: myapp\nuser: admin";

console.log("Config values:", configText.match(afterColonRegex));

// Extract quoted strings preceded by attribute names
const attributeValueRegex = /(?<=\w+=")\w+(?=")/g;
const xmlData = '<user name="john" role="admin" status="active" id="123">';

console.log("Attribute values:", xmlData.match(attributeValueRegex));

// Log levels preceded by timestamp
const logLevelRegex = /(?<=\d{2}:\d{2}:\d{2}\s+)\w+/g;
const logEntries = `
12:30:45 INFO Application started
13:15:22 ERROR Database connection failed
14:00:01 WARN Memory usage high
`;

console.log("Log levels:", logEntries.match(logLevelRegex));

// Environment variables preceded by export
const envVarRegex = /(?<=export\s+)\w+/g;
const bashScript = `
export NODE_ENV=production
export PORT=3000
set DEBUG=true
export DATABASE_URL=postgres://localhost
`;

console.log("Exported variables:", bashScript.match(envVarRegex));
```

#### 4. Negative Lookbehind for Context Exclusion
```javascript
// Numbers NOT preceded by dollar sign
const nonDollarNumberRegex = /(?<!\$)\b\d+(?:\.\d{2})?\b/g;
const mixedText = "Price: $19.99, Quantity: 5, Tax: $2.50, Items: 10";

console.log("Non-dollar numbers:", mixedText.match(nonDollarNumberRegex));

// Words NOT preceded by "not"
const positiveWordsRegex = /(?<!not\s)\b(good|great|excellent|awesome)\b/gi;
const reviews = "This is good, not great, but excellent and not awesome";

console.log("Positive words:", reviews.match(positiveWordsRegex));

// CSS properties NOT in comments
const cssPropertyRegex = /(?<!\/\*[^*]*)\b[a-z-]+(?=\s*:)/g;
const cssCode = `
.selector {
    color: red;
    /* background-color: blue; */
    font-size: 14px;
    /* margin-top: 10px; */
}
`;

console.log("Active CSS properties:", cssCode.match(cssPropertyRegex));

// Function calls NOT in string literals
const functionCallRegex = /(?<!["'`][^"'`]*)\b\w+(?=\()/g;
const jsCode = `
function test() {}
console.log("call myFunction()");
process.exit();
const str = "getValue() is a function";
`;

console.log("Function calls:", jsCode.match(functionCallRegex));

// URLs NOT in href attributes
const freeUrlRegex = /(?<!href=["']?)https?:\/\/[^\s"'<>]+/g;
const htmlWithUrls = `
<a href="https://example.com">Link</a>
Visit https://test.org for more info
<img src="https://images.com/pic.jpg" />
Check out https://news.com
`;

console.log("Standalone URLs:", htmlWithUrls.match(freeUrlRegex));
```

#### 5. Combining Multiple Lookarounds
```javascript
// Complex password validation
const strongPasswordRegex = /^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[@$!%*?&])(?!.*(.)\1{2,}).{8,}$/;
/*
Breakdown:
- (?=.*[a-z]) - contains lowercase
- (?=.*[A-Z]) - contains uppercase  
- (?=.*\d) - contains digit
- (?=.*[@$!%*?&]) - contains special char
- (?!.*(.)\1{2,}) - no character repeated 3+ times
- .{8,} - at least 8 characters
*/

const passwordTests = [
    "Password1!",      // valid
    "password1!",      // no uppercase
    "PASSWORD1!",      // no lowercase
    "Password!",       // no digit
    "Password1",       // no special char
    "Pass1!",          // too short
    "Passsword1!"      // repeated character
];

passwordTests.forEach(pwd => {
    console.log(`"${pwd}" is strong: ${strongPasswordRegex.test(pwd)}`);
});

// Valid identifier: starts with letter/underscore, not a keyword
const validIdentifierRegex = /^(?=[a-zA-Z_])(?!(?:var|let|const|function|class|if|else|for|while|do|break|continue|return|try|catch|finally|throw|new|this|super|typeof|instanceof|in|of|true|false|null|undefined)\b)\w+$/;

const identifiers = [
    "userName",        // valid
    "_private",        // valid
    "123invalid",      // starts with number
    "var",            // keyword
    "function",       // keyword
    "myFunction",     // valid
    "if",             // keyword
    "myVar"           // valid
];

identifiers.forEach(id => {
    console.log(`"${id}" is valid identifier: ${validIdentifierRegex.test(id)}`);
});

// Email with specific domain requirements
const corporateEmailRegex = /^(?=.*[a-zA-Z])(?!.*[._]{2,})[a-zA-Z0-9._]+(?<![._])@(?:company|corp|enterprise)\.com$/;
/*
Requirements:
- Must contain at least one letter
- No consecutive dots or underscores
- Must not end with dot or underscore before @
- Domain must be company.com, corp.com, or enterprise.com
*/

const corporateEmails = [
    "john.doe@company.com",        // valid
    "admin@corp.com",             // valid
    "test@xn--nxasmq6b", // internationalized domain
    "invalid@",                   // invalid (no domain)
    "user@.com",                  // invalid (no username)
    "user@company.c",             // invalid (short TLD)
    "user@company..com"           // invalid (consecutive dots)
];

corporateEmails.forEach(email => {
    console.log(`"${email}" is corporate email: ${corporateEmailRegex.test(email)}`);
});
```




## 7. Backreferences and Recursive Patterns

### Overview
Backreferences allow you to reference previously captured groups within the same regex pattern. They're useful for finding repeated patterns, matching paired elements (like HTML tags), and ensuring consistency within matches.

### Backreference Syntax
- `\1`, `\2`, `\3`, etc. - Reference captured groups by number
- `\k<name>` - Reference named groups (limited support in JavaScript)
- In replacements: `$1`, `$2`, `$<name>`

### Limitations in JavaScript
JavaScript's regex engine has limited support for recursive patterns compared to other languages like Perl or .NET. Complex nested structures often require alternative approaches.

### Examples

#### 1. Basic Backreferences for Repeated Patterns
```javascript
// Matching repeated words
const repeatedWordRegex = /\b(\w+)\s+\1\b/gi;
const text = "This is is a test test with some some repeated words";

console.log("Repeated words:", text.match(repeatedWordRegex));

// Remove repeated words
const cleanText = text.replace(repeatedWordRegex, '$1');
console.log("Cleaned text:", cleanText);

// Matching palindromes (simple cases)
const palindromeRegex = /\b(\w)(\w)?\2?\1\b/gi;
const palindromeText = "racecar level deed mom dad noon stats";

console.log("Simple palindromes:", palindromeText.match(palindromeRegex));

// Matching quoted strings with same quote type
const quotedStringRegex = /(['"])(.*?)\1/g;
const codeSnippet = `const msg = "Hello 'world'"; const name = 'John "Doe"';`;

let match;
while ((match = quotedStringRegex.exec(codeSnippet)) !== null) {
    console.log(`Quote type: ${match[1]}, Content: ${match[2]}`);
}

// Matching balanced parentheses (limited depth)
const balancedParensRegex = /\(([^()]*)\)/g;
const mathExpression = "Calculate (x + y) and (a * b) then (c / d)";

console.log("Parenthesized expressions:", mathExpression.match(balancedParensRegex));
```

#### 2. HTML Tag Matching with Backreferences
```javascript
// Matching paired HTML tags
const htmlTagRegex = /<(\w+)[^>]*>(.*?)<\/\1>/gi;
const htmlContent = `
    <div class="container">Content</div>
    <p>Paragraph text</p>
    <span>Inline text</span>
    <br /> <!-- self-closing, won't match -->
    <div>Unclosed div
`;

let tagMatch;
while ((tagMatch = htmlTagRegex.exec(htmlContent)) !== null) {
    console.log(`Tag: ${tagMatch[1]}, Content: ${tagMatch[2].trim()}`);
}

// Extracting nested tags (one level)
const nestedTagRegex = /<(\w+)[^>]*>(?:[^<]*<(\w+)[^>]*>[^<]*<\/\2>[^<]*)*<\/\1>/gi;
const nestedHtml = `
    <div>
        <p>Nested paragraph</p>
        <span>Nested span</span>
    </div>
    <article>
        <h1>Title</h1>
        <p>Content</p>
    </article>
`;

console.log("Nested HTML structures:", nestedHtml.match(nestedTagRegex));

// XML attribute validation
const xmlAttributeRegex = /(\w+)=(['"])(.*?)\2/g;
const xmlElement = '<user id="123" name="John Doe" email="john@example.com" active=\'true\'>';

let attrMatch;
console.log("XML attributes:");
while ((attrMatch = xmlAttributeRegex.exec(xmlElement)) !== null) {
    console.log(`  ${attrMatch[1]}: ${attrMatch[3]} (quoted with ${attrMatch[2]})`);
}

// Markdown link validation
const markdownLinkRegex = /\[([^\]]+)\]\(([^)]+)\)/g;
const markdownText = "Check out [Google](https://google.com) and [GitHub](https://github.com)";

let linkMatch;
console.log("Markdown links:");
while ((linkMatch = markdownLinkRegex.exec(markdownText)) !== null) {
    console.log(`  Text: ${linkMatch[1]}, URL: ${linkMatch[2]}`);
}
```

#### 3. Case-Insensitive Backreferences
```javascript
// Case-insensitive repeated word detection
const caseInsensitiveRepeatRegex = /\b(\w+)\s+\1\b/gi;
const mixedCaseText = "The THE dog Dog barked BARKED loudly";

console.log("Case-insensitive repeats:", mixedCaseText.match(caseInsensitiveRepeatRegex));

// Validate consistent casing in paired elements
function validateConsistentCasing(text) {
    const inconsistentTags = /<(\w+)[^>]*>.*?<\/(?!\1)[^>]*>/gi;
    return !inconsistentTags.test(text);
}

const htmlSamples = [
    "<div>Content</div>",           // consistent
    "<DIV>Content</div>",           // inconsistent case
    "<p>Text</P>",                  // inconsistent case
    "<span>Text</span>"             // consistent
];

htmlSamples.forEach(html => {
    console.log(`"${html}" has consistent casing: ${validateConsistentCasing(html)}`);
});

// Password confirmation matching
const passwordConfirmRegex = /^(.{8,})\s+\1$/;
const passwordPairs = [
    "password123 password123",      // match
    "password123 password124",      // no match
    "short short",                  // too short
    "LongPassword1! LongPassword1!" // match
];

passwordPairs.forEach(pair => {
    const isValid = passwordConfirmRegex.test(pair) && pair.split(' ')[0].length >= 8;
    console.log(`"${pair}" passwords match and valid: ${isValid}`);
});
```

#### 4. Advanced Backreference Patterns
```javascript
// Matching symmetric patterns
const symmetricPatternRegex = /(\w)(\w)(\w)\3\2\1/g;
const symmetricText = "abccba defged xyzyx";

console.log("Symmetric patterns:", symmetricText.match(symmetricPatternRegex));

// CSS property-value pair validation
const cssPropertyRegex = /(\w+(?:-\w+)*)\s*:\s*([^;]+);?/g;
const cssRules = `
    color: red;
    background-color: #ffffff;
    font-size: 16px;
    margin-top: 10px;
`;

let cssMatch;
console.log("CSS properties:");
while ((cssMatch = cssPropertyRegex.exec(cssRules)) !== null) {
    console.log(`  ${cssMatch[1]}: ${cssMatch[2].trim()}`);
}

// Duplicate detection in lists
function findDuplicates(text, separator = ',') {
    const items = text.split(separator).map(item => item.trim());
    const duplicateRegex = new RegExp(`\\b(\\w+)\\b.*\\b\\1\\b`, 'gi');
    return text.match(duplicateRegex) || [];
}

const itemLists = [
    "apple, banana, apple, orange",
    "red, blue, green, red, yellow",
    "unique, items, here"
];

itemLists.forEach(list => {
    console.log(`"${list}" duplicates:`, findDuplicates(list));
});

// Configuration file validation (key=value pairs)
const configPairRegex = /^(\w+)\s*=\s*(.+)$/gm;
const configContent = `
database=myapp
host=localhost
port=3000
debug=true
database=production
`;

const configMap = new Map();
let configMatch;

while ((configMatch = configPairRegex.exec(configContent)) !== null) {
    const key = configMatch[1];
    if (configMap.has(key)) {
        console.log(`Duplicate configuration key found: ${key}`);
    }
    configMap.set(key, configMatch[2]);
}

console.log("Final configuration:", Object.fromEntries(configMap));
```

#### 5. Workarounds for Recursive Pattern Limitations
```javascript
// Simple nested structure parsing (limited depth)
function parseNestedStructure(text, maxDepth = 3) {
    const patterns = [];
    
    // Build patterns for different nesting levels
    for (let i = 1; i <= maxDepth; i++) {
        let pattern = '\\([^()]*';
        for (let j = 1; j < i; j++) {
            pattern = `\\([^()]*${pattern}[^()]*\\)[^()]*`;
        }
        pattern += '\\)';
        patterns.push(new RegExp(pattern, 'g'));
    }
    
    const results = [];
    patterns.forEach((pattern, depth) => {
        const matches = text.match(pattern) || [];
        matches.forEach(match => {
            results.push({ depth: depth + 1, content: match });
        });
    });
    
    return results;
}

const nestedText = "Simple (one) and (nested (two) levels) and (very (deeply (nested)) structure)";
console.log("Nested structures:", parseNestedStructure(nestedText));

// JSON-like object parsing (simplified)
const jsonObjectRegex = /\{[^{}]*(?:\{[^{}]*\}[^{}]*)*\}/g;
const jsonText = '{"name": "John", "address": {"street": "123 Main", "city": "NYC"}, "age": 30}';

console.log("JSON objects:", jsonText.match(jsonObjectRegex));

// Alternative approach using iterative parsing
function parseBalancedBrackets(text, openChar = '(', closeChar = ')') {
    const results = [];
    let depth = 0;
    let start = -1;
    
    for (let i = 0; i < text.length; i++) {
        if (text[i] === openChar) {
            if (depth === 0) start = i;
            depth++;
        } else if (text[i] === closeChar) {
            depth--;
            if (depth === 0 && start !== -1) {
                results.push(text.substring(start, i + 1));
            }
        }
    }
    
    return results;
}

const bracketText = "Function calls: func1(arg1, func2(arg2, arg3), arg4) and func3(simple)";
console.log("Balanced brackets:", parseBalancedBrackets(bracketText));

// Template variable recursion detection
function detectRecursiveTemplates(template) {
    const variableRegex = /\{\{(\w+)\}\}/g;
    
    let match;
    while ((match = variableRegex.exec(template)) !== null) {
        const varName = match[1];
        const fullMatch = match[0];
        
        if (template.includes(`${varName}=${fullMatch}`)) {
            console.log(`Recursive template detected: ${varName}`);
        }
    }
}

const recursiveTemplate = "{{greeting}}=Hello {{name}}, {{name}}={{greeting}} User";
detectRecursiveTemplates(recursiveTemplate);
```




## 8. Advanced Regex Techniques

### Overview
Advanced regex techniques go beyond basic pattern matching to include sophisticated validation, parsing, and text manipulation strategies. These techniques are essential for complex backend operations.

### Advanced Concepts
- **Atomic Groups**: Prevent backtracking for performance
- **Conditional Patterns**: Different patterns based on conditions
- **Mode Modifiers**: Inline flag changes
- **Subroutine Calls**: Reusing pattern components (limited in JavaScript)
- **Unicode Properties**: Character classification beyond ASCII

### Examples

#### 1. Advanced Validation Patterns
```javascript
// Complex email validation with international domains
const advancedEmailRegex = /^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?)*$/;

const emailTests = [
    "user@example.com",
    "user.name+tag@example.co.uk",
    "user@subdomain.example.org",
    "test@xn--nxasmq6b", // internationalized domain
    "invalid@",
    "@invalid.com",
    "spaces in@email.com"
];

emailTests.forEach(email => {
    console.log(`"${email}" is valid: ${advancedEmailRegex.test(email)}`);
});

// Credit card validation with Luhn algorithm check
function validateCreditCard(cardNumber) {
    // Remove spaces and dashes
    const cleaned = cardNumber.replace(/[\s-]/g, '');
    
    // Basic format validation
    const formatRegex = /^\d{13,19}$/;
    if (!formatRegex.test(cleaned)) return false;
    
    // Card type validation
    const cardTypes = {
        visa: /^4\d{12}(?:\d{3})?$/,
        mastercard: /^5[1-5]\d{14}$/,
        amex: /^3[47]\d{13}$/,
        discover: /^6(?:011|5\d{2})\d{12}$/
    };
    
    const cardType = Object.keys(cardTypes).find(type => 
        cardTypes[type].test(cleaned)
    );
    
    if (!cardType) return false;
    
    // Luhn algorithm
    let sum = 0;
    let isEven = false;
    
    for (let i = cleaned.length - 1; i >= 0; i--) {
        let digit = parseInt(cleaned[i]);
        
        if (isEven) {
            digit *= 2;
            if (digit > 9) digit -= 9;
        }
        
        sum += digit;
        isEven = !isEven;
    }
    
    return sum % 10 === 0;
}

const creditCards = [
    "4532-1234-5678-9012", // Valid Visa
    "5555-5555-5555-4444", // Valid Mastercard
    "3782-822463-10005",   // Valid Amex
    "1234-5678-9012-3456", // Invalid
    "4532123456789013"     // Invalid Luhn
];

creditCards.forEach(card => {
    console.log(`"${card}" is valid: ${validateCreditCard(card)}`);
});
```

#### 2. Advanced Text Processing
```javascript
// Smart word boundary detection for different languages
const smartWordRegex = /\b[\w\u00C0-\u017F\u0400-\u04FF]+\b/g;
const multilingualText = "Hello 世界 مرحبا Привет café naïve";

console.log("Smart word extraction:", multilingualText.match(smartWordRegex));

// Advanced CSV parsing with quoted fields and escaped quotes
function parseCSVLine(line) {
    const fields = [];
    let current = '';
    let inQuotes = false;
    let i = 0;
    
    while (i < line.length) {
        const char = line[i];
        const next = line[i + 1];
        
        if (char === '"') {
            if (inQuotes && next === '"') {
                // Escaped quote
                current += '"';
                i += 2;
            } else {
                // Toggle quote state
                inQuotes = !inQuotes;
                i++;
            }
        } else if (char === ',' && !inQuotes) {
            fields.push(current);
            current = '';
            i++;
        } else {
            current += char;
            i++;
        }
    }
    
    fields.push(current);
    return fields;
}

const csvLines = [
    'John,Doe,30,"Software Engineer"',
    '"Smith, Jr.",Jane,25,"Sales ""Manager"""',
    'Bob,Wilson,35,"Product Owner, Senior"'
];

csvLines.forEach(line => {
    console.log(`CSV: ${line}`);
    console.log(`Parsed:`, parseCSVLine(line));
});

// Template engine with nested variables
function processTemplate(template, variables) {
    const variableRegex = /\{\{([^}]+)\}\}/g;
    
    return template.replace(variableRegex, (match, expression) => {
        // Handle nested object access
        const keys = expression.split('.');
        let value = variables;
        
        for (const key of keys) {
            value = value && value[key];
        }
        
        return value !== undefined ? value : match;
    });
}

const template = "Hello {{user.name}}, you have {{user.messages.count}} messages";
const templateVars = {
    user: {
        name: "John",
        messages: { count: 5 }
    }
};

console.log("Template result:", processTemplate(template, templateVars));
```

#### 3. Performance Optimization Techniques
```javascript
// Optimized regex compilation
class RegexCache {
    constructor(maxSize = 100) {
        this.cache = new Map();
        this.maxSize = maxSize;
    }
    
    getRegex(pattern, flags = '') {
        const key = `${pattern}:${flags}`;
        
        if (this.cache.has(key)) {
            return this.cache.get(key);
        }
        
        if (this.cache.size >= this.maxSize) {
            const firstKey = this.cache.keys().next().value;
            this.cache.delete(firstKey);
        }
        
        const regex = new RegExp(pattern, flags);
        this.cache.set(key, regex);
        return regex;
    }
}

const regexCache = new RegexCache();

// Usage example
function validateInput(input, pattern, flags) {
    const regex = regexCache.getRegex(pattern, flags);
    return regex.test(input);
}

// Benchmarking regex performance
function benchmarkRegex(pattern, testString, iterations = 100000) {
    console.log(`Benchmarking: ${pattern}`);
    
    // Compiled regex
    const compiledRegex = new RegExp(pattern, 'g');
    
    console.time('Compiled regex');
    for (let i = 0; i < iterations; i++) {
        compiledRegex.test(testString);
        compiledRegex.lastIndex = 0; // Reset for global regex
    }
    console.timeEnd('Compiled regex');
    
    // Dynamic compilation
    console.time('Dynamic compilation');
    for (let i = 0; i < iterations; i++) {
        new RegExp(pattern, 'g').test(testString);
    }
    console.timeEnd('Dynamic compilation');
}

// Uncomment to run benchmark
// benchmarkRegex('\\d+', 'Test string with 123 numbers 456', 10000);

// Lazy quantifier optimization
const greedyRegex = /.*foo/;
const lazyRegex = /.*?foo/;
const longString = 'a'.repeat(10000) + 'foo';

console.time('Greedy quantifier');
greedyRegex.test(longString);
console.timeEnd('Greedy quantifier');

console.time('Lazy quantifier');
lazyRegex.test(longString);
console.timeEnd('Lazy quantifier');
```

#### 4. Security-Focused Regex Patterns
```javascript
// XSS detection patterns
const xssPatterns = [
    /<script\b[^<]*(?:(?!<\/script>)<[^<]*)*<\/script>/gi,
    /javascript\s*:/gi,
    /on\w+\s*=/gi,
    /<iframe\b[^>]*>/gi,
    /eval\s*\(/gi,
    /expression\s*\(/gi
];

function detectXSS(input) {
    return xssPatterns.some(pattern => pattern.test(input));
}

const xssTests = [
    "Hello World",
    "<script>alert('xss')</script>",
    "javascript:alert(1)",
    "<img onload=\"alert('xss')\">",
    "eval(maliciousCode)",
    "<iframe src=\"javascript:alert(1)\"></iframe>"
];

xssTests.forEach(test => {
    console.log(`"${test}" contains XSS: ${detectXSS(test)}`);
});

// SQL injection detection
const sqlInjectionRegex = /('|(\')|;|--|\b(union|select|insert|update|delete|drop|create|alter|exec|execute)\b)/gi;

function detectSQLInjection(input) {
    return sqlInjectionRegex.test(input);
}

const sqlTests = [
    "normal user input",
    "'; DROP TABLE users; --",
    "admin' OR '1'='1",
    "UNION SELECT * FROM passwords",
    "regular input with numbers 123"
];

sqlTests.forEach(test => {
    console.log(`"${test}" contains SQL injection: ${detectSQLInjection(test)}`);
});

// Path traversal detection
const pathTraversalRegex = /(\.\.[\/\\]|%2e%2e[\/\\]|\.\.%2f|\.\.%5c)/gi;

function detectPathTraversal(path) {
    return pathTraversalRegex.test(path);
}

const pathTests = [
    "/normal/path/file.txt",
    "../../../etc/passwd",
    "..\\..\\windows\\system32",
    "%2e%2e%2f%2e%2e%2fetc%2fpasswd",
    "legitimate..file.txt"
];

pathTests.forEach(test => {
    console.log(`"${test}" contains path traversal: ${detectPathTraversal(test)}`);
});
```

#### 5. Dynamic Pattern Generation
```javascript
// Dynamic regex builder
class RegexBuilder {
    constructor() {
        this.pattern = '';
        this.flags = '';
    }
    
    literal(text) {
        this.pattern += text.replace(/[.*+?^${}()|[\]\\]/g, '\\$&');
        return this;
    }
    
    group(callback) {
        this.pattern += '(';
        callback();
        this.pattern += ')';
        return this;
    }
    
    or() {
        this.pattern += '|';
        return this;
    }
    
    digit(count) {
        if (count) {
            this.pattern += `\\d{${count}}`;
        } else {
            this.pattern += '\\d+';
        }
        return this;
    }
    
    word() {
        this.pattern += '\\w+';
        return this;
    }
    
    optional() {
        this.pattern += '?';
        return this;
    }
    
    caseInsensitive() {
        this.flags += 'i';
        return this;
    }
    
    global() {
        this.flags += 'g';
        return this;
    }
    
    build() {
        return new RegExp(this.pattern, this.flags);
    }
}

// Build a phone number regex dynamically
const phoneRegex = new RegexBuilder()
    .group(() => {
        new RegexBuilder()
            .literal('(')
            .digit(3)
            .literal(') ')
            .or()
            .digit(3)
            .literal('-');
    })
    .digit(3)
    .literal('-')
    .digit(4)
    .build();

console.log("Phone regex:", phoneRegex);
console.log("Test '(555) 123-4567':", phoneRegex.test('(555) 123-4567'));
console.log("Test '555-123-4567':", phoneRegex.test('555-123-4567'));

// Configuration-driven validation
const validationRules = {
    username: {
        pattern: '^[a-zA-Z][a-zA-Z0-9_]{2,19}$',
        message: 'Username must start with a letter and be 3-20 characters'
    },
    email: {
        pattern: '^[^@]+@[^@]+\\.[^@]+$',
        message: 'Invalid email format'
    },
    password: {
        pattern: '^(?=.*[a-z])(?=.*[A-Z])(?=.*\\d)(?=.*[@$!%*?&])[A-Za-z\\d@$!%*?&]{8,}$',
        message: 'Password must be 8+ chars with upper, lower, digit, and special char'
    }
};

function validateField(fieldName, value) {
    const rule = validationRules[fieldName];
    if (!rule) {
        throw new Error(`Unknown validation type: ${fieldName}`);
    }
    
    // Normalize the value
    const normalized = value.normalize('NFC').trim();
    
    // Apply length constraints if specified
    if (options.minLength && normalized.length < options.minLength) {
        return { valid: false, message: 'Too short' };
    }
    if (options.maxLength && normalized.length > options.maxLength) {
        return { valid: false, message: 'Too long' };
    }
    
    const valid = pattern.test(normalized);
    return { valid, error: valid ? null : 'Invalid format' };
}

const testData = {
    username: 'user123',
    email: 'user@example.com',
    password: 'StrongP@ss1'
};

Object.entries(testData).forEach(([field, value]) => {
    const result = validateField(field, value);
    console.log(`${field}: "${value}" - ${result.message}`);
});
```




## 9. Unicode and Internationalization

### Overview
Modern applications must handle international text, which requires understanding Unicode in regex patterns. JavaScript's regex engine supports Unicode through the `u` flag and Unicode property escapes.

### Unicode Features
- **Unicode Flag (`u`)**: Enables proper Unicode handling
- **Unicode Property Escapes**: `\p{Property}` and `\P{Property}`
- **Unicode Code Points**: Beyond Basic Multilingual Plane
- **Normalization**: Handling different Unicode representations

### Examples

#### 1. Unicode Character Classes
```javascript
// Basic Unicode support
const unicodeRegex = /\p{Letter}+/gu;
const multilingualText = "Hello 世界 مرحبا Привет café naïve";

console.log("Unicode letters:", multilingualText.match(unicodeRegex));

// Specific script detection
const scripts = {
    latin: /\p{Script=Latin}+/gu,
    arabic: /\p{Script=Arabic}+/gu,
    chinese: /\p{Script=Han}+/gu,
    cyrillic: /\p{Script=Cyrillic}+/gu
};

Object.entries(scripts).forEach(([name, regex]) => {
    const matches = multilingualText.match(regex);
    console.log(`${name} text:`, matches);
});

// Emoji detection
const emojiRegex = /\p{Emoji}/gu;
const textWithEmojis = "Hello 👋 world 🌍! How are you? 😊 Great! 👍";

console.log("Emojis found:", textWithEmojis.match(emojiRegex));

// Currency symbols
const currencyRegex = /\p{Currency_Symbol}/gu;
const priceText = "Prices: $100 €50 ¥500 £75 ₹1000 ¢25";

console.log("Currency symbols:", priceText.match(currencyRegex));

// Mathematical symbols
const mathRegex = /\p{Math}/gu;
const mathExpression = "Calculate: x + y = z, a × b ÷ c ≤ d ≥ e";

console.log("Math symbols:", mathExpression.match(mathRegex));
```

#### 2. International Name Validation
```javascript
// International name validation
const nameRegex = /^[\p{Letter}\p{Mark}\s'-]+$/u;
const names = [
    "John Smith",           // Latin
    "José María",           // Latin with diacritics
    "李小明",               // Chinese
    "محمد العلي",           // Arabic
    "Владимир Петров",      // Cyrillic
    "Jean-Pierre",          // Hyphenated
    "O'Connor",            // Apostrophe
    "Name123",             // Invalid (contains digit)
    "Name@Email"           // Invalid (contains symbol)
];

names.forEach(name => {
    console.log(`"${name}" is valid name: ${nameRegex.test(name)}`);
});

// International phone number validation
function validateInternationalPhone(phone) {
    // Remove common formatting
    const cleaned = phone.replace(/[\s()-+.]/g, '');
    
    // International format: country code + number
    const intlRegex = /^\d{7,15}$/;
    
    return intlRegex.test(cleaned);
}

const phoneNumbers = [
    "+1 555 123 4567",      // US
    "+44 20 7946 0958",     // UK
    "+81 3 1234 5678",      // Japan
    "+49 30 12345678",      // Germany
    "555-123-4567",         // Local US
    "+999 999 999 999 999", // Too long
    "+1234"                 // Too short
];

phoneNumbers.forEach(phone => {
    console.log(`"${phone}" is valid: ${validateInternationalPhone(phone)}`);
});
```

#### 3. Text Direction and Writing Systems
```javascript
// Right-to-left text detection
const rtlRegex = /[\p{Script=Arabic}\p{Script=Hebrew}]/u;
const bidiRegex = /[\p{Bidi_Class=R}\p{Bidi_Class=AL}]/u;

const textSamples = [
    "Hello World",          // LTR
    "مرحبا بالعالم",         // RTL (Arabic)
    "שלום עולם",            // RTL (Hebrew)
    "Mixed text مختلط",     // Bidirectional
    "Numbers ١٢٣ in Arabic"  // Arabic-Indic digits
];

textSamples.forEach(text => {
    console.log(`"${text}":`, {
        hasRTL: rtlRegex.test(text),
        hasBidi: bidiRegex.test(text)
    });
});

// Number format detection
const numberFormats = {
    western: /\d+/g,
    arabic: /[\u0660-\u0669]+/g,      // Arabic-Indic digits
    persian: /[\u06F0-\u06F9]+/g,     // Persian digits
    devanagari: /[\u0966-\u096F]+/g   // Devanagari digits
};

const numbersText = "Numbers: 123 ١٢٣ ۱۲۳ १२३";

Object.entries(numberFormats).forEach(([name, regex]) => {
    const matches = numbersText.match(regex);
    console.log(`${name} numbers:`, matches);
});

// International postal code validation
const postalCodes = {
    us: /^\d{5}(-\d{4})?$/,                    // US ZIP
    uk: /^[A-Z]{1,2}\d[A-Z\d]?\s*\d[A-Z]{2}$/i, // UK postcode
    canada: /^[A-Z]\d[A-Z]\s*\d[A-Z]\d$/i,     // Canadian postal
    germany: /^\d{5}$/,                        // German PLZ
    japan: /^\d{3}-\d{4}$/                     // Japanese postal
};

const testPostalCodes = [
    { code: "12345", country: "us" },
    { code: "SW1A 1AA", country: "uk" },
    { code: "K1A 0A6", country: "canada" },
    { code: "10115", country: "germany" },
    { code: "100-0001", country: "japan" }
];

testPostalCodes.forEach(({ code, country }) => {
    const regex = postalCodes[country];
    console.log(`${country.toUpperCase()} "${code}": ${regex ? regex.test(code) : 'Unknown format'}`);
});
```

#### 4. Unicode Normalization
```javascript
// Unicode normalization handling
function normalizeUnicode(text, form = 'NFC') {
    return text.normalize(form);
}

// Comparison with normalization
function safeStringCompare(str1, str2) {
    const normalized1 = normalizeUnicode(str1);
    const normalized2 = normalizeUnicode(str2);
    return normalized1 === normalized2;
}

// Different Unicode representations of the same character
const accentedStrings = [
    "café",           // Composed form (é as single character)
    "cafe\u0301",     // Decomposed form (e + combining acute)
    "naïve",          // Composed form
    "nai\u0308ve"     // Decomposed form
];

console.log("Original strings:", accentedStrings);
console.log("Normalized (NFC):", accentedStrings.map(s => normalizeUnicode(s, 'NFC')));
console.log("Normalized (NFD):", accentedStrings.map(s => normalizeUnicode(s, 'NFD')));

// Safe search with normalization
function createNormalizedRegex(pattern, flags = 'gi') {
    const normalized = normalizeUnicode(pattern);
    return new RegExp(normalized, flags + 'u');
}

const searchText = "Find café and naïve in this text";
const searchPattern = "cafe";
const normalizedRegex = createNormalizedRegex(searchPattern);

console.log(`Searching for "${searchPattern}" in "${searchText}"`);
console.log("Matches:", searchText.match(normalizedRegex));

// International domain name validation
const idnRegex = /^[\p{Letter}\p{Number}][\p{Letter}\p{Number}-]*[\p{Letter}\p{Number}]$/u;
const domains = [
    "example.com",          // ASCII
    "münchen.de",           // German umlaut
    "москва.рф",            // Cyrillic
    "القاهرة.مصر",          // Arabic
    "中国.cn",              // Chinese
    "test-.com",            // Invalid (ends with hyphen)
    "-test.com"             // Invalid (starts with hyphen)
];

domains.forEach(domain => {
    // Extract domain part (before TLD)
    const domainPart = domain.split('.')[0];
    console.log(`"${domain}" domain part valid: ${idnRegex.test(domainPart)}`);
});
```

#### 5. Internationalization Best Practices
```javascript
// Locale-aware text processing
class InternationalTextProcessor {
    constructor(locale = 'en-US') {
        this.locale = locale;
        this.collator = new Intl.Collator(locale, { sensitivity: 'base' });
    }
    
    // Locale-aware string matching
    createSearchRegex(pattern, flags = 'gi') {
        // Normalize the pattern for consistent matching
        const normalized = pattern.normalize('NFC');
        return new RegExp(normalized, flags + 'u');
    }
    
    // Extract words considering locale-specific rules
    extractWords(text) {
        // Different locales have different word boundary rules
        const segments = new Intl.Segmenter(this.locale, { granularity: 'word' });
        const words = [];
        
        for (const segment of segments.segment(text)) {
            if (segment.isWordLike) {
                words.push(segment.segment);
            }
        }
        
        return words;
    }
    
    // Locale-aware comparison
    areEqual(str1, str2) {
        return this.collator.compare(str1, str2) === 0;
    }
}

// Usage examples
const processors = [
    new InternationalTextProcessor('en-US'),
    new InternationalTextProcessor('de-DE'),
    new InternationalTextProcessor('ja-JP')
];

const testText = "Hello world! こんにちは世界 Guten Tag Welt";

processors.forEach(processor => {
    if (typeof Intl.Segmenter !== 'undefined') {
        const words = processor.extractWords(testText);
        console.log(`${processor.locale} words:`, words);
    } else {
        console.log(`${processor.locale}: Segmenter not supported`);
    }
});

// Comprehensive international validation framework
class InternationalValidator {
    static patterns = {
        email: /^[\p{L}\p{N}._%+-]+@[\p{L}\p{N}.-]+\.[\p{L}]{2,}$/u,
        phone: /^[\+]?[\p{N}\s\-\(\)\.]{7,15}$/u,
        name: /^[\p{L}\p{M}\s\-\'\.]+$/u,
        address: /^[\p{L}\p{N}\p{M}\s\-\'\.,#\/]+$/u,
        postalCode: /^[\p{L}\p{N}\s\-]{3,10}$/u
    };
    
    static validate(type, value, options = {}) {
        const pattern = this.patterns[type];
        if (!pattern) {
            throw new Error(`Unknown validation type: ${type}`);
        }
        
        // Normalize the value
        const normalized = value.normalize('NFC').trim();
        
        // Apply length constraints if specified
        if (options.minLength && normalized.length < options.minLength) {
            return { valid: false, message: 'Too short' };
        }
        if (options.maxLength && normalized.length > options.maxLength) {
            return { valid: false, message: 'Too long' };
        }
        
        const valid = pattern.test(normalized);
        return { valid, error: valid ? null : 'Invalid format' };
    }
}

// Test international validation
const validationTests = [
    { type: 'email', value: 'user@münchen.de' },
    { type: 'name', value: '李小明' },
    { type: 'name', value: 'José María' },
    { type: 'phone', value: '+49 30 12345678' },
    { type: 'address', value: 'Mühlenstraße 123, München' }
];

validationTests.forEach(test => {
    const result = InternationalValidator.validate(test.type, test.value);
    console.log(`${test.type} "${test.value}":`, result);
});
```
# Practice Questions

## Basic Regex Patterns

1. **Match 3-Letter Word**  
    Write a regex to match any 3-letter word starting with "a" and ending with "e" (e.g., "ace", "ale"). Test with Node.js.

2. **Find "the" Instances**  
    Create a regex to find all instances of the word "the" (case-insensitive) in a string, ignoring words like "then" or "there".

3. **Validate Lowercase Letters and Spaces**  
    Develop a regex to validate a string containing only lowercase letters and spaces. Implement it in a Node.js function.

4. **URL Pattern Match**  
    Write a regex to match any string that starts with "http" and ends with ".html". Test with multiple URLs.

5. **Extract Digits**  
    Create a regex to find all sequences of one or more digits in a string. Count their occurrences using Node.js.

## Character Classes and Quantifiers

1. **Validate Username**  
    Write a regex to validate a username that is 3-16 characters long, containing only letters, numbers, and underscores.

2. **Match US Phone Numbers**  
    Create a regex to match US phone numbers in formats like "123-456-7890" or "(123) 456-7890". Test with Node.js.

3. **Match 5-Letter Words**  
    Develop a regex to find all words in a string that are exactly 5 letters long, ignoring numbers and special characters.

4. **Validate Hex Color Code**  
    Write a regex to validate a hex color code (e.g., "#FF0000" or "#ff0000"). Implement validation in Node.js.

5. **Digits Followed by a Letter**  
    Create a regex to match any string with 2-4 digits followed by a letter (e.g., "123a", "4567b"). Test with multiple inputs.

## Anchors and Boundaries

1. **Capital Start and Period End**  
    Write a regex to validate a string that starts with a capital letter and ends with a period.

2. **Exact "cat" Match**  
    Create a regex to find whole words that are exactly "cat" in a text, ignoring "catch" or "category". Use word boundaries.

3. **Validate File Name Extension**  
    Develop a regex to validate a file name ending in ".txt" or ".doc" (case-insensitive). Test in Node.js.

4. **Match Lines With Numbered Prefix**  
    Write a regex to match lines in a multiline string that start with a number followed by a colon (e.g., "1: text").

5. **Single Word Validation**  
    Create a regex to validate a string that contains only one word (no spaces), using anchors and boundaries.

## Groups and Capturing

1. **Parse Date**  
    Write a regex to parse a date in the format "MM/DD/YYYY" and capture month, day, and year separately.

2. **Extract Email Components**  
    Create a regex to extract username and domain from an email address (e.g., "user@example.com"). Test in Node.js.

3. **Reformat Phone Number**  
    Develop a regex to reformat a phone number from "1234567890" to "(123) 456-7890" using captured groups.

4. **Match HTML Tags**  
    Write a regex to match HTML tags and capture the tag name and content. Test with Node.js.

5. **Parse URL Components**  
    Create a regex to parse a URL and capture protocol, host, and path components. Handle optional paths.

## Lookaheads and Lookbehinds

1. **Words Followed by Comma Without Space**  
    Write a regex to find all words followed by a comma but not followed by a space using positive lookahead.

2. **Validate Password**  
    Create a regex to validate a password that contains at least one uppercase letter and one digit, using lookaheads.

3. **Numbers Preceded by Dollar Sign**  
    Develop a regex to match numbers preceded by a dollar sign using positive lookbehind (e.g., "$100").

4. **Match Words Without "un-" Prefix**  
    Write a regex to find words not preceded by "un-" using negative lookbehind (e.g., match "happy" but not "unhappy").

5. **Email Not Starting With a Number**  
    Create a regex to validate an email address that does not start with a number, using negative lookahead.

## Backreferences and Recursive Patterns

1. **Find Repeated Words**  
    Write a regex to find repeated words in a text (e.g., "the the" or "is is"). Use backreferences.

2. **Match Paired HTML Tags**  
    Create a regex to match paired HTML tags with the same name (e.g., "<div>content</div>"). Test in Node.js.

3. **Validate Quoted Strings**  
    Develop a regex to validate quoted strings that use matching quote types (e.g., "text" or 'text'). Use backreferences.

4. **Find Palindromes**  
    Write a regex to find palindromes of 3-5 characters in a string (e.g., "deed", "radar"). Test with Node.js.

5. **Match Symmetric Patterns**  
    Create a regex to match symmetric patterns like "abcba" or "abccba" using backreferences.

## Advanced Regex Techniques

1. **Credit Card Validation**  
    Write a Node.js function to validate credit card numbers using regex and the Luhn algorithm.

2. **Parse CSV Lines**  
    Create a regex to parse CSV lines with quoted fields and escaped quotes. Implement parsing in Node.js.

3. **Template Engine**  
    Develop a regex-based template engine that replaces "{{variable}}" with values from an object. Test in Node.js.

4. **XSS Pattern Detection**  
    Write a regex to detect potential XSS patterns like "<script>" or "javascript:". Implement detection in Node.js.

5. **Caching Compiled Regex Patterns**  
    Create a Node.js class for caching compiled regex patterns to improve performance. Demonstrate with benchmarks.

## Unicode and Internationalization

1. **Validate International Names**  
    Write a regex to validate international names containing letters, spaces, hyphens, and apostrophes using Unicode.

2. **Match Emojis**  
    Create a regex to match emojis in a string using Unicode property escapes. Test extraction in Node.js.

3. **International Phone Numbers**  
    Develop a regex to validate international phone numbers with country codes (e.g., "+1234567890"). Test in Node.js.

4. **Extract Script-Specific Words**  
    Write a regex to extract words in specific scripts (e.g., Arabic or Cyrillic) from multilingual text using Unicode properties.

5. **Normalize Unicode Text**  
    Create a Node.js function to normalize Unicode text and perform case-insensitive searches with regex.