import Foundation

extension SteppingChessPiece {
    class func king(player: Player) -> SteppingChessPiece {
        let moves = [
            Vector(-1, -1),
            Vector(-1, 0),
            Vector(-1, 1),
            Vector(0, -1),
            Vector(0, 1),
            Vector(1, -1),
            Vector(1, 0),
            Vector(1, 1)
        ]
        
        return SteppingChessPiece(steps: moves, type: .king, player: player)
    }
    
    class func knight(player: Player) -> SteppingChessPiece {
        let moves = [
            Vector(-2, -1),
            Vector(-2, 1),
            Vector(-1, -2),
            Vector(-1, 2),
            Vector(1, -2),
            Vector(1, 2),
            Vector(2, -1),
            Vector(2, 1)
        ]
        
        return SteppingChessPiece(steps: moves, type: .knight, player: player)
    }
}

extension ScalingChessPiece {
    class func bishop(player: Player) -> ScalingChessPiece {
        return ScalingChessPiece(scalesOnAxis: false, scalesDiagonally: true, type: .bishop, player: player)
    }
    
    class func rook(player: Player) -> ScalingChessPiece {
        return ScalingChessPiece(scalesOnAxis: true, scalesDiagonally: false, type: .rook, player: player)
    }
    
    class func queen(player: Player) -> ScalingChessPiece {
        return ScalingChessPiece(scalesOnAxis: true, scalesDiagonally: true, type: .queen, player: player)
    }
}

extension Board {
    class func chessBoard(whitePlayer: Player, blackPlayer: Player) -> Board<ChessPiece> {
        // Initialize the board
        
        let board = Board<ChessPiece>(8, 8)
        
        // Kings, queens, rooks, knights, and bishops
        
        board.place(element: ScalingChessPiece.rook(player: whitePlayer), at: Space(row: 1, col: 1))
        board.place(element: SteppingChessPiece.knight(player: whitePlayer), at: Space(row: 1, col: 2))
        board.place(element: ScalingChessPiece.bishop(player: whitePlayer), at: Space(row: 1, col: 3))
        board.place(element: ScalingChessPiece.queen(player: whitePlayer), at: Space(row: 1, col: 4))
        board.place(element: SteppingChessPiece.king(player: whitePlayer), at: Space(row: 1, col: 5))
        board.place(element: ScalingChessPiece.bishop(player: whitePlayer), at: Space(row: 1, col: 6))
        board.place(element: SteppingChessPiece.knight(player: whitePlayer), at: Space(row: 1, col: 7))
        board.place(element: ScalingChessPiece.rook(player: whitePlayer), at: Space(row: 1, col: 8))
        
        board.place(element: ScalingChessPiece.rook(player: blackPlayer), at: Space(row: 8, col: 1))
        board.place(element: SteppingChessPiece.knight(player: blackPlayer), at: Space(row: 8, col: 2))
        board.place(element: ScalingChessPiece.bishop(player: blackPlayer), at: Space(row: 8, col: 3))
        board.place(element: ScalingChessPiece.queen(player: blackPlayer), at: Space(row: 8, col: 4))
        board.place(element: SteppingChessPiece.king(player: blackPlayer), at: Space(row: 8, col: 5))
        board.place(element: ScalingChessPiece.bishop(player: blackPlayer), at: Space(row: 8, col: 6))
        board.place(element: SteppingChessPiece.knight(player: blackPlayer), at: Space(row: 8, col: 7))
        board.place(element: ScalingChessPiece.rook(player: blackPlayer), at: Space(row: 8, col: 8))
        
        // Pawns
        
        for col in 1...8 {
            board.place(element: PawnChessPiece(yStep: 1, player: whitePlayer), at: Space(row: 2, col: col))
            board.place(element: PawnChessPiece(yStep: -1, player: blackPlayer), at: Space(row: 7, col: col))
        }
        
        //
        
        return board
    }
}
