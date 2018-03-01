import Foundation

enum ChessPieceType {
    case pawn, rook, bishop, queen, king, knight
}

enum PlayerDescriptor {
    case white, black, red, blue, error
}

class Player {
    let descriptor: PlayerDescriptor
    
    init(descriptor: PlayerDescriptor) {
        self.descriptor = descriptor
    }
}

protocol OwnedPiece {
    var player: Player { get }
    var descriptor: PlayerDescriptor { get }
}

extension OwnedPiece {
    var descriptor: PlayerDescriptor {
        return player.descriptor
    }
}

protocol ChessPiece: OwnedPiece {
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
    var player: Player
    let type: ChessPieceType
    
    let steps: [Vector]
    
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
    var player: Player
    let type: ChessPieceType
    
    let scalesOnAxis: Bool
    let scalesDiagonally: Bool
    
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
    var player: Player
    let type = ChessPieceType.pawn
    
    var moved = false
    let yStep: Int
    
    init(yStep: Int, player: Player) {
        self.yStep = yStep
        self.player = player
    }
    
    func didMove() {
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
