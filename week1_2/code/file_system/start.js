// Importing the fs(File System) module
// const fs = require('fs');

// Common File System Operations

// 1. Reading a File
// fs.readFile('file.txt','utf-8', (err,data) => {
//    if(err){
//      console.error('Error reading file:', err);
//      return;
//    }
//    console.log('File content:', data);
// })

// Using promises
// fs.promises.readFile('file.txt', 'utf-8')
//    .then((result) => {
//         console.log('File content using promises:', result);
//    })
//    .catch((err) => {
//        console.error('Error reading file using promises:', err);
//    })
//    .finally(() => {
//         console.log('File read operation completed.');
//    });

// user async/await
// async function readFileContent() {
//     try{
//        const data = await fs.promises.readFile('file.txt', 'utf-8');
//        console.log('File content using async/await:', data);
//     }catch(error){
//         console.error('Error reading file using async/await:', error);
//     }
// }

// readFileContent();

// 2. Writing to a Files
// fs.writeFile("file.txt", "Hello, World!",(err) => {
//    if(err) {
//       console.error('Error writing to file:', err);
//       return;
//    }
//    console.log('File written successfully');
// });

// Appending To Files
// fs.appendFile("file.txt","\n\nThis is a new Content","utf-8",(error) => {
//     if(error) {
//         console.error('Error appending to file:', error);
//         return;
//     }
//         console.log('Content appended successfully');
// })

// Creating a Directory
// fs.mkdir("newDir", (error) => {
//     if (error) {
//         console.error('Error creating directory:', error);
//         return;
//     }
//     console.log('Directory created successfully');
// })

// Listing Directory Contents
// fs.readdir('newDir', (error,files) => {
//     if(error) {
//         console.error('Error reading directory:', error);
//         return;
//     }
//     console.log('Directory contents:', files);
//     files.forEach(file => {
//         console.log('File:', file);
//         // logic to read a single file
//     });
// })


// Deleting a Files
// fs.unlink('file.txt', (error) => {
//   if(error) {
//     console.error('Error deleting file:', error);
//     return;
//   }
//   console.log('File deleted successfully');
// })

// Renaming/Moving files
// fs.rename('file.txt', 'renamedFile.txt', (error) => {
//   if (error) {
//     console.error('Error renaming file:', error);
//     return;
//   }
//     console.log('File renamed successfully');
// })

// Wrinting to a file using Streams
// const writeStream = fs.createWriteStream('file.txt', 'utf-8');

// setTimeout(() => {
//   writeStream.write("Filrst line of data\n");
// },1000);
// setTimeout(() => {
//   writeStream.write("Second line of data\n");
// },3000);
// setTimeout(() => {
//   writeStream.end("Third line of data\n");
// },5000);

// writeStream.on('error', (error) => {
//   console.error('Error writing to file:', error)
//   });


// Reading from a file Using Streams
// const readStream = fs.createReadStream('largeFile.txt', 'utf-8');   

// readStream.on('data', (chunk) => {
//     console.log('New chunk received:', chunk);
// });


// Reading and Parsing JSON Files
// fs.readFile('usersData.json','utf-8', (error,data) => {
//   if(error) {
//     console.error('Error reading JSON file:', error);
//     return;
//   }
//   try{
//     // console.log('JSON file content:', typeof data);
//    const usersData = JSON.parse(data);
//    console.log('Parsed JSON data:', usersData[0].id);
//   }catch(error){
//     console.error('Error parsing JSON file:', error);
//   }
// })

// Writing JSON Data to a File

// const user1 = {
//     id: 1,
//     name: 'John Doe',
//     age: 30,
//     email: 'john.doe@example.com',
//     address: {
//         street: '123 Main St',
//         city: 'Anytown',
//         state: 'CA',
//         zip: '12345'
//     }
// }

// const user1String = JSON.stringify(user1,null,1);

// fs.writeFile('userDataWriteFile.json',user1String, 'utf-8', (error) => {
//   if(error) {
//     console.error('Error writing JSON data to file:', error);
//     return;
//   }
//   console.log('JSON data written successfully to file');
// });