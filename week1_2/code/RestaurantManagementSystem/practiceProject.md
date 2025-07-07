# Practice Console Application

## Project Overview

Create a **Library Management System** as a console application. This project will help you reinforce concepts of object-oriented programming, data modeling, file I/O, and application flow control.

### Goals
- Design a clear data schema for books and members.
- Implement basic CRUD operations (Create, Read, Update, Delete).
- Handle user input and display console menus.
- Store data persistently (in JSON or text files).

**Detailed Goals & Validation**
- Assign unique IDs automatically (UUID or incremental).
- Validate required fields: non-empty strings, valid dates, correct formats (e.g., ISBN).
- Ensure availability status is boolean and updated consistently.
- Provide clear error messages and retry prompts for invalid input.

---
## Step-by-Step Guide

### 1. Define Requirements
1. **Entities**
   - **Book**: id, title, author, ISBN, publication year, availability status  
     _Hint:_ Use string for text fields, number for year, boolean for availability.
   - **Member**: id, name, email, phone number, membership date  
     _Hint:_ Validate email with regex; store dates as ISO strings.
   - **Loan**: id, bookId, memberId, loanDate, returnDate  
     _Hint:_ Set returnDate to `null` until the book is returned.

2. **Features**
   - Add/remove books and members with confirmations.
   - List all books, members, and current loans in tabular console format.
   - Issue a loan only if the book is available; update availability.
   - Return a book by updating returnDate and availability.
   - Search books by title or author (case-insensitive).

### 2. Model Schema Diagrams (Hints)
- Sketch an **Entity–Relationship Diagram** with ASCII art:
  ```
    [Book] 1<>-----* [Loan] *-----<>1 [Member]
  ```
- Under each entity, list fields and types:
  - Book: `id: string`, `title: string`, `year: number`, `available: boolean`
  - Member: `id: string`, `email: string`, `dateJoined: string`
  - Loan: `id: string`, `bookId: string`, `memberId: string`, `loanDate: string`, `returnDate: string | null`

#### Complete Model Schemas

**Book**
- id: string (UUID)
- title: string (required)
- author: string (required)
- ISBN: string (required, 10 or 13 digits)
- publicationYear: number (YYYY)
- available: boolean (true if book is available)

**Member**
- id: string (UUID)
- name: string (required)
- email: string (required, valid email format)
- phone: string (optional, phone number)
- membershipDate: string (ISO date)

**Loan**
- id: string (UUID)
- bookId: string (UUID, references Book.id)
- memberId: string (UUID, references Member.id)
- loanDate: string (ISO date)
- returnDate: string (ISO date or null)

### 3. Project Structure (Hints)
```
project-root/
  ├── models/
  │     ├── book.js
  │     ├── member.js
  │     └── loan.js
  ├── data/
  │     ├── books.json
  │     ├── members.json
  │     └── loans.json
  └── app.js
```
**Detail:**
- `models/`: constructor functions or classes matching schema and implementing CRUD operations.
- `data/`: store arrays of objects; pre-seed with sample entries.
- `app.js`: the main application file that ties all components together.

### 4. Implement Core Functionality (Hints)
1. **Data Access**
   - Create `readData(fileName)` and `writeData(fileName, data)` utilities.  
   - Use atomic operations: read entire file, modify in memory, then write.

2. **Controllers**
   - Pseudocode for `addBook()`:
     ```
     function addBook(book) {
       const books = readData('books.json');
       validateBook(book);
       book.id = generateId();
       books.push(book);
       writeData('books.json', books);
     }
     ```
   - Similar functions for update, delete, list, and search.

3. **Console Interface**
   - Example menu pseudocode:
     ```
     displayMenu();
     switch(userChoice) {
       case '1': addBookFlow(); break;
       // ... other cases ...
       case '0': exitApplication();
     }
     ```
   - Loop until exit; validate choice and show error on invalid selection.

### 5. User Flow Diagram (Hints)
- Main loop flowchart:
  1. **Start** → Display Main Menu
  2. Read user input → Validate
  3. Call corresponding controller function
  4. Display result/confirmation → Return to menu or Exit

### 6. Testing
- Outline test scenarios in a table or list:
  1. **Add Book**: missing title → expect validation error and retry prompt.
  2. **Delete Member**: invalid ID → display ‘Not found’ message.
  3. **Issue Loan**: book unavailable → block action with message.
  4. **Return Loan**: correct update and availability toggle.

---
## Extension Ideas
- Implement search filters (by date range, availability).
- Pagination for listing long datasets.
- Fine calculation for overdue loans.
- Admin role with authentication.

---

By following these steps and using the hints provided, you will build a structured console application that mirrors real-world project organization. Good luck!
