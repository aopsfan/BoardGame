import Foundation

// ShiftMove -- Moves and merges all applicable tiles in the specified
//  direction

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
    
    var delta = BoardDelta()
    var score = 0
    
    init(onBoard board: Board, direction: Direction) {
        self.board = board
        self.direction = direction
    }
    
    
    
    //////////
    
    
    
    // play() {} -- Try to shift every tile on the board
    
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
    
    
    
    // shift(tileAt:) -- Try to shift a single tile
    
    private func shift(tileAt startSpace: Space) {
        // Lookup the indicated tile. We can implicitly unwrap this because
        //  only filled spaces are asked to shift.
        
        let tile = board.tile(at: startSpace)!
        
        // Bail out if the next space isn't on the board
        
        guard let nextSpace = board.space(startSpace, shifted: direction) else { return }
        
        // Try to move the tile over one space
        
        if board.move(tileAt: startSpace, toEmptySpace: nextSpace) {
            // If the move succeeds, record it and try to shift again
            
            delta.record(moveFrom: startSpace, to: nextSpace)
            shift(tileAt: nextSpace)
        }
        
        else if tile == board.tile(at: nextSpace) && !hasMerged(to: nextSpace) {
            // If the move fails because of an identical tile that hasn't already
            //  merged, merge them and record it
            
            board.place(tile: tile * 2, at: nextSpace)
            board.remove(tileAt: startSpace)
            delta.record(mergeFrom: startSpace, to: nextSpace)
            
            // Update the score
            
            score += tile * 2
        }
    }
    
    // hasMerged(to:) -- Determine whether a tile has already merged to a
    //  location
    
    private func hasMerged(to space: Space) -> Bool {
        return delta.mergeSpaces.contains(space)
    }
}
