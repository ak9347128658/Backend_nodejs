// Defination:Asynchronous programming is a fundamental concept in Node.js. It allows your code to execute non-blocking operations, making your applications more efficient and responsive. Two modern approaches to handle asynchronous operations in Node.js are Promises and the async/await syntax. 

// Promise States
// A Promise can be in one of three states:

// Pending: The initial state. The Promise's outcome hasn't yet been determined.
// Fulfilled: The operation completed successfully, and the Promise has a resulting value.
// Rejected: The operation failed, and the Promise has a reason for the failure.

// Promises LifeCycle Diagram:
//                   +-------------+
//                   |   Promise   |
//                   |  Creation   |
//                   +------+------+
//                          |
//                          v
//                   +------+------+
//                   |   Pending   |<--------+
//                   | (in progress)|        |
//                   +------+------+         |
//                          |                |
//           +---------------+----------------+
//           |                                |
//           v                                v
//   +-------+-------+               +--------+------+
//   |   Fulfilled   |               |   Rejected    |
//   | (resolved with|               | (rejected with|
//   |    a value)   |               |  a reason)    |
//   +-------+-------+               +--------+------+
//           |                                |
//           v                                v
//   +-------+-------+               +--------+------+
//   | .then() handler|              | .catch() handler|
//   | processes the |               | processes the |
//   |     value     |               |     error     |
//   +---------------+               +---------------+
//           |                                |
//           +----------------+---------------+
//                            |
//                            v
//                     +------+------+
//                     |  .finally() |
//                     |   (optional)|
//                     +-------------+

// Create Promises
// const myPromise = new Promise((resolve,reject) => {
//    const success = false;

//    if(success){
//       resolve("Operation completed successfully...!");
//    }else{
//        reject(new Error("Operation failed!"));
//    }
// });

// myPromise
//    .then((result) => {
//      console.log(result);
//    })
//     .catch((error) => {
//       console.log("Error: ",error.message);
//    })
//     .finally(() => {
//        console.log("Promise completed (successfully or not)")
//    });

// Promis Chaining

// console.log("i am above the promise");
// setTimeout(() => {
//     console.log("i have executed after 2 seconds");
// },5000);
// table that contain id,name
// Table Name USER
// ---------------------------
// |  id     |       name     |
// ---------------------------
// | 1      |       John      |
// | 2      |       Jane      |
// | 3      |       Alice     |
// ----------------------------
// function getUserData(userId) {
//     return new Promise((resolve, reject) => {
//         setTimeout(() => {
//             if (userId === 1)
//                 resolve({ id: 1, name: "John Doe" });
//             else
//                 reject(new Error("User not found"));
//         }, 5000);
//     });
// }

// function getUserPosts(user) {
//     return new Promise((resolve, reject) => {
//         // simulate fetching user posts
//         setTimeout(() => {
//             if (user.id === 1)
//                 resolve({
//                     user: user,
//                     posts: [
//                         { id: 1, title: "Post 1", content: "Content of Post 1" },
//                         { id: 2, title: "Post 2", content: "Content of Post 2" }
//                     ]
//                 });
//             else
//                 reject(new Error("Posts not found for this user"));
//         }, 5000);
//     });
// }

// console.log("Fetching user data...");
// //
// getUserData(1)
//     .then((user) => {
//         console.log("User fecth successfully : ", user);
//         return getUserPosts(user)
//             .then(post => {
//                 console.log("User posts fetched successfully : ", post);
//             }).catch((error) => {
//                 console.error("Error fetching user posts : ", error.message);
//             });
//     })
//     .catch((error) => {
//         console.error("Error fetching user data : ", error.message);
//     })
//     .finally(() => {
//         console.log("User data fetch operation completed.");
//     });

// Promise Chaining Diagram
// +----------------+    +----------------+    +------------------+
// | getUserData(1) |    | getUserPosts(user) |    | Log posts to console |
// | returns Promise1 +--->| returns Promise2 +--->| and handle results  |
// +----------------+    +----------------+    +------------------+
//         |                     |                      |
//         v                     v                      v
// +----------------+    +----------------+    +------------------+
// | Promise1 resolves |    | Promise2 resolves |    | Final result shown |
// | with user data   |    | with posts data   |    | in the console    |
// +----------------+    +----------------+    +------------------+
//                                                      |
// +----------------------------------------------------|
// |
// v
// +------------------+
// | Any error in the |
// | chain is caught  |
// | by .catch()      |
// +------------------+

// Promise.all() - Parallel Execution

// const promise1 = new Promise((resolve,reject) => setTimeout(() => resolve("Result 1"),4000));
// const promise2 = new Promise((resolve,reject) => setTimeout(() => resolve("Result 2"),8000));
// const promise3 = new Promise((resolve,reject) => setTimeout(() => resolve("Result 3"),2000));

// Promise.all([promise1, promise2, promise3])
//     .then((results) => {
//         console.log("All promises resolved:");
//         console.log(results);
//     })
//     .catch((error) => {
//         console.error("One or more promises failed:", error);
//     });

// Promise.all Diagram
//                          +---------------+
//                          | Promise.all() |
//                          +-------+-------+
//                                  |
//          +-------------------+---+----------------+
//          |                   |                    |
// +--------v------+    +-------v-------+    +-------v-------+
// |  Promise 1    |    |   Promise 2   |    |   Promise 3   |
// | (takes 4s)    |    |  (takes 8s)   |    |  (takes 2s) |
// +--------+------+    +-------+-------+    +-------+-------+
//          |                   |                    |
//          |                   |                    |
// +--------v------+    +-------v-------+    +-------v-------+
// | Resolves after |    | Resolves after|    | Resolves after|
// |    4 seconds   |    |   8 seconds   |    |  2 seconds    |
// +--------+------+    +-------+-------+    +-------+-------+
//          |                   |                    |
//          +-------------------+--------------------+
//                              |
//                              v
//                     +--------+--------+
//                     |    Promise.all  |
//                     |    resolves     |
//                     |  after 8 seconds|
//                     | (longest time)  |
//                     +-----------------+
//                              |
//                              v
//                     +--------+--------+
//                     | Returns array of|
//                     |  all results:   |
//                     | ['Result 1',    |
//                     |  'Result 2',    |
//                     |  'Result 3']    |
//                     +-----------------+

// Promise.race - first to complete

// const promise1 = new Promise(resolve => setTimeout(() => resolve('Result 1'), 1000));
// const promise2 = new Promise(resolve => setTimeout(() => resolve('Result 2'), 500));
// const promise3 = new Promise(resolve => setTimeout(() => resolve('Result 3'), 1500));

// Promise.race([promise1, promise2, promise3])
//      .then((result) => {
//         console.log("First resolved promise:", result);
//      })
//      .catch((error) => {
//         console.error("Error in promise race:", error);
//      });


// Promise.race Diagram
//                          +----------------+
//                          | Promise.race() |
//                          +-------+--------+
//                                  |
//          +-------------------+---+----------------+
//          |                   |                    |
// +--------v------+    +-------v-------+    +-------v-------+
// |  Promise 1    |    |   Promise 2   |    |   Promise 3   |
// | (takes 1s)    |    |  (takes 0.5s) |    |  (takes 1.5s) |
// +--------+------+    +-------+-------+    +-------+-------+
//          |                   |                    |
//          |                   |                    |
//          |            +------v-------+            |
//          |            | Resolves FIRST|            |
//          |            | after 0.5s    |            |
//          |            +------+-------+            |
//          |                   |                    |
//          |                   v                    |
//          |            +------+-------+            |
//          +----------->|  Promise.race |<-----------+
//                       |    resolves   |
//                       | with 'Result 2'|
//                       +--------------+
//                              |
//                              v
//                       +------+-------+
//                       | Other promises|
//                       | continue but  |
//                       | their results |
//                       | are ignored   |
//                       +--------------+


// Promise.allSettled - All Results Regardless of Outcome
// const Promise1 = Promise.resolve("Success 1");
// const Promise2 = Promise.reject(new Error("Failure 2"));
// const Promise3 = Promise.resolve("Success 3");

// Promise.allSettled([Promise1, Promise2, Promise3])
//     .then((results) => {
//         console.log("All promises settled:");
//         results.forEach((result,index) => {
//           if(result.status === "fulfilled") {
//             console.log(`Promise ${index + 1} fulfilled with value: ${result.value}`);
//           } else {
//             console.log(`Promise ${index + 1} rejected with reason: ${result.reason}`);
//           }
//         });
//     });

// Understanding Async/Await

//                  Promises                     |               Async/Await
// --------------------------------------------|------------------------------------------
//                                            |
// getUserData(123)                           |  async function getUserInfo() {
//   .then(user => {                          |    try {
//     console.log(user);                     |      const user = await getUserData(123);
//     return getUserPosts(user);             |      console.log(user);
//   })                                       |
//   .then(posts => {                         |      const posts = await getUserPosts(user);
//     console.log(posts);                    |      console.log(posts);
//     return getUserFriends(posts.user);     |
//   })                                       |      const friends = await getUserFriends(user);
//   .then(friends => {                       |      console.log(friends);
//     console.log(friends);                  |      return { user, posts, friends };
//     return { user: posts.user,             |
//              posts: posts,                 |    } catch (error) {
//              friends: friends };           |      console.error('Error:', error);
//   })                                       |    }
//   .catch(error => {                        |  }
//     console.error('Error:', error);        |
//   });                                      |


// Basic Syntax of Async/Await
// async function myAsyncFunction() {
//     try{
//     const result = await  somePromiseReturingFunction();
//     return result;
//     }catch(error){
//         console.error("Error occurred:", error);
//         return null;
//     }
// }

// const myAsyncFunction = async () => {
//     try{
//       const result = await somePromiseReturningFunction();
//       console.log("Result:", result);
//       return result;
//     }catch(error){
//         console.error("Error occurred:", error);
//         return null;
//     }
// }

// exmaple 1 : Async/Await with Promises

function getUserData(userId) {
    return new Promise((resolve, reject) => {
        setTimeout(() => {
            if (userId === 1)
                resolve({ id: 1, name: "John Doe" });
            else
                reject(new Error("User not found"));
        }, 5000);
    });
}

function getUserPosts(user) {
    return new Promise((resolve, reject) => {
        // simulate fetching user posts
        setTimeout(() => {
            if (user.id === 1)
                resolve({
                    user: user,
                    posts: [
                        { id: 1, title: "Post 1", content: "Content of Post 1" },
                        { id: 2, title: "Post 2", content: "Content of Post 2" }
                    ]
                });
            else
                reject(new Error("Posts not found for this user"));
        }, 5000);
    });
}

// const fetchUserData = await getUserData(1);
async function fetchUserData() {
    try{
        const user = await getUserData(1);
        console.log("User fetched successfully:", user);
        const posts = await getUserPosts(user);
        console.log("User posts fetched successfully:", posts);
        return user;
    }catch(error){
        console.error("Error fetching user data:", error.message);
        return null;
    }
}

const user = await fetchUserData();

// console.log("User fetched successfully:", user);