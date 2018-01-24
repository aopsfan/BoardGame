import Foundation

// DropMove -- Piece placement for Connect Four

class DropMove {
    
    // DropMove
    //  = board
    //  = piece
    //  = column
    //
    //  > play() {}
    
    let board: Board
    let piece: Piece
    let column: Int
    
    init(onBoard board: Board, inColumn column: Int, piece: Piece) {
        self.board = board
        self.column = column
        self.piece = piece
    }
    
    func play(closure: (_ startSpaces: [Space], _ endSpace: Space) -> ()) {
        // Try the bottom row first
        
        let bottomSpace = Space(row: 1, col: column)
        
        if let dropLocation = nextEmptySpace(over: bottomSpace) {
            // If an empty space is found, place a piece on the board
            //  and fire the callback
            
            board.place(piece: piece, at: dropLocation)
            closure([], dropLocation)
        }
    }
    
    
    
    //////////
    
    
    
    // nextEmptySpace(over:) -- Recursive function to determine drop
    //  location given a starting space
    
    private func nextEmptySpace(over space: Space) -> Space? {
        if board.contains(emptySpaceAt: space) {
            return space
        }
        
        guard let nextSpace = board.space(space, shifted: Direction.up()) else {
            return nil
        }
        
        return nextEmptySpace(over: nextSpace)
    }
}
