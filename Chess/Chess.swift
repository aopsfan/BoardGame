import Foundation

class Chess: MultiplayerGame, ChessBoardDataSource {
    
    // MultiplayerGame
    
    var players = [
        Player(descriptor: .white),
        Player(descriptor: .black)
    ]
    var turnIndex = 0
    
    // ChessBoardDataSource
    
    var whitePlayer: Player { return players[0] }
    var blackPlayer: Player { return players[1] }
    
    //
    
    let board: ChessBoard
    let delegate: ChessDelegate
    
    init(delegate: ChessDelegate) {
        self.delegate = delegate
        
        self.board = ChessBoard()
        self.board.setUp(dataSource: self)
    }
    
    //
    
    func tryMove(from startSpace: Space, to endSpace: Space) {
        guard contains(activePieceAt: startSpace) else { return }
        guard board.freeMoves(forPieceAt: startSpace).contains(endSpace) else {
            tryAttack(from: startSpace, to: endSpace)
            return
        }
        
        if board.move(elementAt: startSpace, toEmptySpace: endSpace) {
            delegate.gameDidMove(elementAt: startSpace, to: endSpace)
            didMove(to: endSpace)
        }
    }
    
    func contains(activePieceAt space: Space) -> Bool {
        return activePiece(at: space) != nil
    }
    
    func contains(inactivePieceAt space: Space) -> Bool {
        return inactivePiece(at: space) != nil
    }
    
    //
    
    private func tryAttack(from startSpace: Space, to endSpace: Space) {
        guard let piece = activePiece(at: startSpace) else { return }
        guard contains(inactivePieceAt: endSpace) else { return }
        guard board.attackMoves(forPieceAt: startSpace).contains(endSpace) else { return }
        
        board.place(element: piece, at: endSpace)
        board.remove(elementAt: startSpace)
        didMove(to: endSpace)
        
        delegate.gamePiece(at: startSpace, didCapturePieceAt: endSpace)
    }
    
    private func activePiece(at space: Space) -> ChessPiece? {
        guard let piece = board.element(at: space) else { return nil }
        return piece.player === activePlayer ? piece : nil
    }
    
    private func inactivePiece(at space: Space) -> ChessPiece? {
        guard let piece = board.element(at: space) else { return nil }
        return piece.player === activePlayer ? nil : piece
    }

    private func didMove(to endSpace: Space) {
        board.element(at: endSpace)?.didMove()
        turnIndex += 1
    }
}
