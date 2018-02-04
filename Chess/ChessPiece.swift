import Foundation

enum ChessPieceType {
    case pawn, rook, bishop, queen, king, knight
}

protocol ChessPiece {
    var player: Player { get }
    var type: ChessPieceType { get }
    
    func didMove()
    func moves(by vector: Vector) -> Bool
    func attacks(by vector: Vector) -> Bool
}

extension ChessPiece {
    func didMove() {}
    
    func attacks(by vector: Vector) -> Bool {
        return moves(by: vector)
    }
}

class SteppingChessPiece: ChessPiece {
    let steps: [Vector]
    let type: ChessPieceType
    let player: Player
    
    init(steps: [Vector], type: ChessPieceType, player: Player) {
        self.steps = steps
        self.type = type
        self.player = player
    }
    
    func moves(by vector: Vector) -> Bool {
        return steps.contains { $0 == vector }
    }
}

class ScalingChessPiece: ChessPiece {
    let scalesOnAxis: Bool
    let scalesDiagonally: Bool
    let type: ChessPieceType
    let player: Player
    
    init(scalesOnAxis: Bool, scalesDiagonally: Bool, type: ChessPieceType, player: Player) {
        self.scalesOnAxis = scalesOnAxis
        self.scalesDiagonally = scalesDiagonally
        self.type = type
        self.player = player
    }
    
    func moves(by vector: Vector) -> Bool {
        guard vector.magnitude() > 0 else { return false }
        
        if vector.x == 0 || vector.y == 0 {
            return scalesOnAxis
        } else if abs(vector.x) == abs(vector.y) {
            return scalesDiagonally
        }
        
        return false
    }
}

class PawnChessPiece: ChessPiece {
    var moved = false
    let yStep: Int
    let type = ChessPieceType.pawn
    let player: Player
    
    init(yStep: Int, player: Player) {
        self.yStep = yStep
        self.player = player
    }
    
    func markAsMoved() {
        moved = true
    }
    
    func moves(by vector: Vector) -> Bool {
        guard vector.x == 0 else { return false }
        
        let y = vector.y
        return y == yStep || (y == yStep * 2 && !moved)
    }
    
    func attacks(by vector: Vector) -> Bool {
        guard vector.y == yStep else { return false }
        
        let x = vector.x
        return x == 1 || x == -1
    }
}
