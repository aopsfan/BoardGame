import Foundation

protocol ConnectFourInspectorDelegate {
    func inspector(_ inspector: ConnectFourInspector, indicatesWinner winner: Player, winningSequence: [Space])
}

// ConnectFourInspector -- Determines whether a Connect Four game has
//  ended

class ConnectFourInspector {
    
    // ConnectFourInspector
    //  = game
    //  = delegate
    //  - board
    //  = directions
    //
    //  > inspect()
    
    let game: ConnectFour
    let delegate: ConnectFourInspectorDelegate
    
    var board: Board { return game.board }
    
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
        var space: Space? = Space(row: 1, col: 1)
        var winningSequence: [Space]? = nil
        
        while winningSequence == nil && space != nil {
            winningSequence = directions.reduce(winningSequence) { (sequence, direction) in
                return sequence ?? self.sequence(inDirection: direction, origin: space!)
            }
            
            space = self.space(following: space!)
        }
        
        if let sequence = winningSequence {
            guard let winner = board.piece(at: sequence[0])?.player else { assertionFailure(); return }
            
            delegate.inspector(self, indicatesWinner: winner, winningSequence: sequence)
        }
    }
    
    
    
    //////////
    
    
    
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
        guard let originPiece = board.piece(at: origin) else { return nil }
        guard let player = originPiece.player else { assertionFailure(); return nil }
        
        var currentSpace = origin
        var sequence = [origin]
        
        while sequence.count < 4 {
            guard board.piece(at: currentSpace) != nil else { return nil }
            guard let otherSpace = board.space(currentSpace, shifted: direction) else { return nil }
            guard let otherPiece = board.piece(at: otherSpace) else { return nil }
            guard otherPiece.player === player else { return nil }
            
            sequence.append(otherSpace)
            currentSpace = otherSpace
        }
        
        return sequence
    }
}
