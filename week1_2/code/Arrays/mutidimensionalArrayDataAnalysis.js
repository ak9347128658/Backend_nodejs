// Example 2: Data Analysis - Monthly Sales By Region

let salesData = [
    // 2023 Sales Data
    [
        [10000, 15000, 12000], // Jan: [North, South, East]
        [12000, 16000, 11000], // Feb: [North, South, East]
        [13000, 17000, 14000]  // Mar: [North, South, East]     
    ],
    // 2024 Sales Data
    [
        [11000, 16500, 13000], // Jan: [North, South, East]
        [13000, 17000, 12000], // Feb: [North, South, East]
        [14000, 18000, 15000]  // Mar: [North, South, East]
    ]
]

function getTotalSalesForMonth(data, year,month){
    let total =0;
    //validate indices
    if(year < 0 || year >= data.length || month < 0 || month >= data[year].length){
       return "Invalid year or month index";
    }

    for(let region = 0;region < data[year][month].length; region++){
         total += data[year][month][region];
    }
    return total;
}

let totalSalesFeb2024 = getTotalSalesForMonth(salesData,1,1);
console.log(`Total sales for February 2024: $${totalSalesFeb2024}`); // Output: Total sales for February 2024: $42000

// 3D Sales Data Structure:

//           Year 0 (2023)                    Year 1 (2024)
//         +--------------+                 +--------------+
//         |              |                 |              |
// Month 0 | N    S    E  |       Month 0  | N    S    E  |
// (Jan)   |10000 15000 12000|     (Jan)   |11000 16500 13000|
//         |              |                 |              |
//         +--------------+                 +--------------+
//         |              |                 |              |
// Month 1 | N    S    E  |       Month 1  | N    S    E  |
// (Feb)   |12000 16000 11000|     (Feb)   |13000 17000 12000|
//         |              |                 |              |
//         +--------------+                 +--------------+
//         |              |                 |              |
// Month 2 | N    S    E  |       Month 2  | N    S    E  |
// (Mar)   |13000 17000 14000|     (Mar)   |14000 18000 15000|
//         |              |                 |              |
//         +--------------+                 +--------------+

// Accessing salesData[1][1][0] returns: 13000 (North region, February 2024)