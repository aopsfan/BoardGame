import Foundation

protocol ChessBoardDataSource {
    var blackPlayer: Player { get }
    var whitePlayer: Player { get }
}

class ChessBoard: Board<ChessPiece> {
    var dataSource: ChessBoardDataSource?
    
    init() {
        super.init(8, 8)
    }
    
    //
    
    func setUp(dataSource: ChessBoardDataSource) {
        self.dataSource = dataSource
        
        // Kings, queens, rooks, knights, and bishops
        
        place(element: ScalingChessPiece.rook(player: whitePlayer()), at: Space(row: 1, col: 1))
        place(element: SteppingChessPiece.knight(player: whitePlayer()), at: Space(row: 1, col: 2))
        place(element: ScalingChessPiece.bishop(player: whitePlayer()), at: Space(row: 1, col: 3))
        place(element: ScalingChessPiece.queen(player: whitePlayer()), at: Space(row: 1, col: 4))
        place(element: SteppingChessPiece.king(player: whitePlayer()), at: Space(row: 1, col: 5))
        place(element: ScalingChessPiece.bishop(player: whitePlayer()), at: Space(row: 1, col: 6))
        place(element: SteppingChessPiece.knight(player: whitePlayer()), at: Space(row: 1, col: 7))
        place(element: ScalingChessPiece.rook(player: whitePlayer()), at: Space(row: 1, col: 8))
        
        place(element: ScalingChessPiece.rook(player: blackPlayer()), at: Space(row: 8, col: 1))
        place(element: SteppingChessPiece.knight(player: blackPlayer()), at: Space(row: 8, col: 2))
        place(element: ScalingChessPiece.bishop(player: blackPlayer()), at: Space(row: 8, col: 3))
        place(element: ScalingChessPiece.queen(player: blackPlayer()), at: Space(row: 8, col: 4))
        place(element: SteppingChessPiece.king(player: blackPlayer()), at: Space(row: 8, col: 5))
        place(element: ScalingChessPiece.bishop(player: blackPlayer()), at: Space(row: 8, col: 6))
        place(element: SteppingChessPiece.knight(player: blackPlayer()), at: Space(row: 8, col: 7))
        place(element: ScalingChessPiece.rook(player: blackPlayer()), at: Space(row: 8, col: 8))
        
        // Pawns
        
        for col in 1...8 {
            place(element: PawnChessPiece(yStep: 1, player: dataSource.whitePlayer), at: Space(row: 2, col: col))
            place(element: PawnChessPiece(yStep: -1, player: dataSource.blackPlayer), at: Space(row: 7, col: col))
        }
    }
    
    func freeMoves(forPieceAt space: Space) -> [Space] {
        guard let piece = element(at: space) else { return [] }
        
        return emptySpaces().filter { emptySpace in
            let vector = emptySpace - space
            return piece.moves(by: vector)
        }
    }
    
    func attackMoves(forPieceAt space: Space) -> [Space] {
        guard let piece = element(at: space) else { return [] }
        
        return filledSpaces().filter { emptySpace in
            let vector = emptySpace - space
            return piece.attacks(by: vector)
        }
    }
    
    //
    
    private func whitePlayer() -> Player {
        guard let player = dataSource?.whitePlayer else { return Player(descriptor: .error) }
        return player
    }
    
    private func blackPlayer() -> Player {
        guard let player = dataSource?.blackPlayer else { return Player(descriptor: .error) }
        return player
    }

}
