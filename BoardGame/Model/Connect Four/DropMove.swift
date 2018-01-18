import Foundation

class DropMove {
    let board: Board
    let piece: BoardPiece
    let column: Int
    
    init(onBoard board: Board, inColumn column: Int, piece: BoardPiece) {
        self.board = board
        self.column = column
        self.piece = piece
    }
    
    func play(closure: (_ startSpaces: [Space], _ endSpace: Space) -> ()) {
        let bottomSpace = Space(row: 1, col: column)
        
        if let dropLocation = nextEmptySpace(over: bottomSpace) {
            board.place(piece: piece, at: dropLocation)
            
            closure([], dropLocation)
        }
    }
    
    //
    
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
