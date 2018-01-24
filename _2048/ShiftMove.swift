import Foundation

// ShiftMove -- Directional move in 2048

class ShiftMove {
    
    // ShiftMove
    //  - board
    //  = direction
    //  - delta
    //  - score
    //
    //  > play() {}
    
    var board: Board
    let direction: Direction
    
    var delta = SpatialMap()
    var score = 0
    
    init(onBoard board: Board, direction: Direction) {
        self.board = board
        self.direction = direction
    }
    
    // play() {}
    
    func play(closure: (_ startSpaces: [Space], _ endSpace: Space) -> ()) {
        // Sort the board's filled spaces, starting with spaces that should be
        //  handled first based on the direction
        
        let assortedSpaces = board.filledSpaces().sorted(by: { direction.shouldShift($0, before: $1) })
        
        // Iterate over the sorted spaces, shifting the tile at each space
        
        for startSpace in assortedSpaces {
            shift(tileAt: startSpace)
        }
        
        // Iterate over the delta, passing down the inputted block
        
        delta.iterate(closure: closure)
    }
    
    
    
    //////////
    
    
    
    // shift(tileAt:) -- Try to move a single piece
    
    private func shift(tileAt startSpace: Space) {
        // Sanity check/lookup the indicated tile
        
        guard let tile = board.piece(at: startSpace)?.rawValue else { assertionFailure(); return }
        
        // Bail out if the next space isn't on the board
        
        guard let nextSpace = board.space(startSpace, shifted: direction) else { return }
        
        //
        
        let nextTile = board.piece(at: nextSpace)?.rawValue
        
        // Try to move the tile over one space
        
        if board.move(pieceAt: startSpace, toEmptySpace: nextSpace) {
            // If the move succeeds, record it and try to shift again
            
            delta.record(moveFrom: startSpace, to: nextSpace)
            shift(tileAt: nextSpace)
        } else if tile == nextTile && !hasMerged(to: nextSpace) {
            // If the move fails because of an identical tile that hasn't already
            //  merged, merge them and record it
            
            let newTile = tile * 2
            
            board.place(piece: Piece(newTile), at: nextSpace)
            board.remove(pieceAt: startSpace)
            delta.record(mergeFrom: startSpace, to: nextSpace)
            
            // Update the score
            
            score += newTile
        }
    }
    
    // hasMerged(to:) -- Determine whether a tile has already merged to a
    //  location
    
    private func hasMerged(to space: Space) -> Bool {
        return delta.mergeSpaces.contains(space)
    }
}
