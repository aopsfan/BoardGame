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
