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
    
    var board: Board<Int>
    let direction: Direction
    
    var delta = SpatialMap()
    var score = 0
    
    init(onBoard board: Board<Int>, direction: Direction) {
        self.board = board
        self.direction = direction
    }
    
    // play() {} -- Attempt to shift each tile on the board
    
    func play(closure: BoardUpdate) {
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
    
    
    
    // ShiftMove (private)
    //  > shift(tileAt:)
    //  > hasMerged(to:)
    
    private func shift(tileAt startSpace: Space) {
        // Sanity check/lookup the indicated tile
        
        guard let tile = board.element(at: startSpace) else { assertionFailure(); return }
        
        // Bail out if the next space isn't on the board
        
        guard let nextSpace = board.space(startSpace, shifted: direction) else { return }
        let nextTile = board.element(at: nextSpace)
        
        // Try to move the tile over one space
        
        if board.move(elementAt: startSpace, toEmptySpace: nextSpace) {
            // If the move succeeds, record it and try to shift again
            
            delta.record(moveFrom: startSpace, to: nextSpace)
            shift(tileAt: nextSpace)
        } else if tile == nextTile && !hasMerged(to: nextSpace) {
            // If the move fails because of an identical tile that hasn't already
            //  merged, merge them and record it
            
            let newTile = tile * 2
            
            board.place(element: newTile, at: nextSpace)
            board.remove(elementAt: startSpace)
            delta.record(mergeFrom: startSpace, to: nextSpace)
            
            // Update the score
            
            score += newTile
        }
    }
    
    private func hasMerged(to space: Space) -> Bool {
        // Determine whether the tile has already merged to a location
        
        return delta.mergeSpaces.contains(space)
    }
}
