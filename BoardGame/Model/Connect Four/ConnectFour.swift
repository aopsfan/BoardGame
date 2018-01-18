import Foundation

protocol ConnectFourDelegate {
    func gameDidEnd(winner: Player, winningSequence: [Space])
    func gameDidStartTurn(player: Player)
    func gameDidPlace(piece: BoardPiece, at space: Space)
}

class ConnectFour {
    let board: Board
    let players: [Player]
    let delegate: ConnectFourDelegate
    var activePlayerIndex = 0
    
    var activePlayer: Player {
        return players[activePlayerIndex % players.count]
    }
    
    init(rows: Int, cols: Int, delegate: ConnectFourDelegate) {
        self.board = Board(rows, cols)
        self.delegate = delegate
        
        players = [
            Player(descriptor: .red),
            Player(descriptor: .blue)
        ]
    }
    
    func prepareForPlay() {
        delegate.gameDidStartTurn(player: activePlayer)
    }
    
    func dropPiece(inColumn column: Int) {
        let piece = activePlayer.piece()
        let drop = DropMove(onBoard: board, inColumn: column, piece: piece)
        var moved = false
        
        drop.play { (startSpaces, endSpace) in
            guard startSpaces.isEmpty else { assertionFailure(); return }
            guard let piece = board.piece(at: endSpace) else { assertionFailure(); return }
            
            delegate.gameDidPlace(piece: piece, at: endSpace)
            
            moved = true
        }
        
        if moved {
            checkForWinner()
            startNextTurn()
        }
    }
    
    private func checkForWinner() {
        let inspector = ConnectFourInspector(game: self, delegate: self)
        inspector.inspect()

    }
    
    private func startNextTurn() {
        activePlayerIndex += 1
        
        delegate.gameDidStartTurn(player: activePlayer)
    }
}

extension ConnectFour: ConnectFourInspectorDelegate {
    
    func inspector(_ inspector: ConnectFourInspector, indicatesWinner winner: Player, winningSequence: [Space]) {
        delegate.gameDidEnd(winner: winner, winningSequence: winningSequence)
    }
    
}
