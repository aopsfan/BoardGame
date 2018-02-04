import Foundation

// ConnectFour -- Connect Four game model

class ConnectFour: ConnectFourInspectorDelegate {
    
    // ConnectFourInspectorDelegate
    
    func inspector(_ inspector: ConnectFourInspector, indicatesWinner winner: Player, winningSequence: [Space]) {
        // Pass end-game information down to the delegate
        
        delegate.gameDidEnd(winner: winner, winningSequence: winningSequence)
    }
    
    
    
    // ConnectFour
    //  = players
    //  - board
    //  = delegate
    //  - activePlayerIndex
    //
    //  = activePlayer
    //
    //  > prepareForPlay()
    //  > dropPiece(inColumn:)
    
    let players: [Player]
    var board: Board<GamePiece>
    let delegate: ConnectFourDelegate
    var activePlayerIndex = 0
    
    var activePlayer: Player {
        // Use the modulo operator to ensure that activePlayer
        //  'wraps around'
        
        return players[activePlayerIndex % players.count]
    }
    
    init(rows: Int, cols: Int, delegate: ConnectFourDelegate) {
        self.delegate = delegate
        
        // Standard Connect Four dimensions are 6x7
        
        self.board = Board<GamePiece>(6, 7)
        
        // Set up a red and a blue player
        
        players = [
            Player(descriptor: .red),
            Player(descriptor: .blue)
        ]
    }
    
    func prepareForPlay() {
        // Notify the delegate of the active player before gameplay
        //  starts
        
        delegate.gameDidStartTurn(player: activePlayer)
    }
    
    // dropPiece(inColumn:) -- Place a tile
    
    func dropPiece(inColumn column: Int) {
        // Setup: retreive an aptly colored piece and initialize a drop move
        //  in the appropriate column
        
        let piece = activePlayer.piece()
        let drop = DropMove(onBoard: board, inColumn: column, piece: piece)
        var moved = false
        
        // Play the drop move
        
        drop.play { (startSpaces, endSpace) in
            // Sanity checks: the drop move just places a piece, so we should
            //  see an empty startSpaces array
            
            guard startSpaces.isEmpty else { assertionFailure(); return }
            guard let element = board.element(at: endSpace) else { assertionFailure(); return }
            
            // Notify the delegate of the new piece placement
            
            delegate.gameDidPlace(element: element, at: endSpace)
            
            // Any iteration of this block implies that a piece was dropped
            
            moved = true
        }
        
        if moved {
            // If a piece was dropped, check for a winning sequence and advance
            //  the active player
            
            checkForWinner()
            startNextTurn()
        }
    }
    
    
    
    // ConnectFour (private)
    //  > checkForWinner()
    //  > startNextTurn()
    
    private func checkForWinner() {
        // Instantiate a ConnectFourInspector with ourself as the
        //  delegate.
        
        let inspector = ConnectFourInspector(game: self, delegate: self)
        inspector.inspect()
    }
    
    private func startNextTurn() {
        // Increment the active player index and notify the delegate
        //  that the active player has changed. Keep in mind that
        //  activePlayer is a computed, not a stored, property.
        
        activePlayerIndex += 1
        delegate.gameDidStartTurn(player: activePlayer)
    }
}
