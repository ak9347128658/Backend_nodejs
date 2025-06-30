// Game Board (Tic Tac Toe) (empty = 0, X = 1, O = 2)
let boards =[
    [0, 1, 2],
    [1, 2, 1],
    [2, 0, 0]
]

function printBoard(board) {
   for(let row of board){
     let rowString = '';
     for(let cell of row){
        if(cell === 0) rowString += " - ";
        else if(cell === 1) rowString += " X ";
        else if(cell === 2) rowString += " O ";
     }
     console.log(rowString);
   }
}

printBoard(boards);