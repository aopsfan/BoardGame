import Foundation

// ConnectFourInspector -- Determines whether a Connect Four game has
//  ended

class ConnectFourInspector {
    
    // ConnectFourInspector
    //  = game
    //  = delegate
    //  = board
    //  = directions
    //
    //  > inspect()
    
    let game: ConnectFour
    let delegate: ConnectFourInspectorDelegate
    
    var board: Board<GamePiece> { return game.board }
    
    let directions = [
        Direction.right(),
        Direction.up(),
        Direction.diagonalNE(),
        Direction.diagonalNW()
    ]
    
    init(game: ConnectFour, delegate: ConnectFourInspectorDelegate) {
        self.game = game
        self.delegate = delegate
    }
    
    // inspect() -- Determine whether the game has ended
    
    func inspect() {
        // Store a reference to a space. Initially, this is the bottom-
        //  left space, but as the function progresses, this variable
        //  is reassigned.
        
        var space: Space? = Space(row: 1, col: 1)
        
        // Define a variable that stores the winning sequence (default
        //  is nil)
        
        var winningSequence: [Space]? = nil
        
        while winningSequence == nil && space != nil {
            // Keep checking for a winning sequence while the reference
            //  space is on the board
            
            winningSequence = directions.reduce(winningSequence) { (sequence, direction) in
                return sequence ?? self.sequence(inDirection: direction, origin: space!)
            }
            
            // Change the space reference
            
            space = self.space(following: space!)
        }
        
        if let sequence = winningSequence {
            // If there's a winning sequence, deduce the game winner
            //  using the sequence's first space, then notify the
            //  delegate
            
            guard let winner = board.element(at: sequence[0])?.player else { assertionFailure(); return }
            delegate.inspector(self, indicatesWinner: winner, winningSequence: sequence)
        }
    }
    
    
    
    // ConnectFourInspector (private)
    //  > space(following:)
    //  > sequence(inDirection:origin:)
    
    // space(following:) -- Return the space to be inspected directly after
    //  the provided space. This will return the next space to the right, if
    //  said space is on the board. Otherwise, return the leftmost space in
    //  the next row.
    
    private func space(following space: Space) -> Space? {
        
        guard let adjacentSpace = board.space(space, shifted: Direction.right()) else {
            let nextRow = space.row + 1
            let leftmostSpace = Space(row: nextRow, col: 1)
            
            return board.contains(spaceAt: leftmostSpace) ? leftmostSpace : nil
        }
        
        return adjacentSpace
    }
    
    // sequence(inDirection:origin:) -- Produce a sequence given a direction
    //  (up, right, or either diagonal) and an origin space. Return nil if
    //  the sequence isn't on the board, or if the pieces aren't all the
    //  same color.
    
    private func sequence(inDirection direction: Direction, origin: Space) -> [Space]? {
        // Bail out if no piece is found at the origin
        
        guard let originPiece = board.element(at: origin) else { return nil }
        let player = originPiece.player
        
        // Set some things up for the while loop
        
        var currentSpace = origin
        var sequence = [origin]
        
        while sequence.count < 4 {
            // Bail out if no piece is found at the reference space
            // TODO: write some tests, see if this is redundant
            
            guard board.element(at: currentSpace) != nil else { return nil }
            
            // Bail out if the next space can't be located
            
            guard let otherSpace = board.space(currentSpace, shifted: direction) else { return nil }
            
            // Bail out if no piece is found at the next space
            
            guard let otherPiece = board.element(at: otherSpace) else { return nil }
            
            // Bail out if the next piece isn't the same color as this one
            
            guard otherPiece.player === player else { return nil }
            
            // If we got this far, the sequence hasn't been invalidated
            //  yet. Append rhe next space to the sequence array and
            //  update the current space reference.
            
            sequence.append(otherSpace)
            currentSpace = otherSpace
        }
        
        // Return the sequence (if we haven't already been kicked out by
        //  a 'guard' condition)
        
        return sequence
    }
}
