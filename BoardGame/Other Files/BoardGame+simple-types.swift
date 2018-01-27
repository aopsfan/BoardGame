import Foundation
import SpriteKit

// BoardUpdate: alias used in DropMove, ShiftMove, etc.

typealias BoardUpdate = (_ startSpaces: [Space], _ endSpace: Space) -> ()



// Simple Types //

// Enums:
// - PlayerDescriptor

// Structs:
// - Space
// - Piece

// Classes:
// - Player
// - Direction
// - SpaceDelta
// - GameSceneElement



//////////



// PlayerDescriptor

enum PlayerDescriptor {
    case red, blue
}



// Space -- Structure that describes an index path (for a tile or an
//  empty space)

struct Space {
    let row: Int, col: Int
    
    // distance(to:) -- Simple Pythagorean implementation
    
    func distance(to other: Space) -> Double {
        let rowChange = Double(row - other.row)
        let colChange = Double(col - other.col)
        
        return sqrt(pow(rowChange, 2) + pow(colChange, 2))
    }
}



// Piece -- Structure that describes something interactive on the board

struct Piece {
    let player: Player?
    
    var descriptor: PlayerDescriptor? {
        return player?.descriptor
    }
}



// Player

class Player {
    let descriptor: PlayerDescriptor
    
    init(descriptor: PlayerDescriptor) {
        self.descriptor = descriptor
    }
    
    func piece() -> Piece {
        return Piece(player: self)
    }
}



// Direction

class Direction {
    let step: (x: Int, y: Int)
    let name: String
    
    init(_ name: String, xStep: Int, yStep: Int) {
        step = (x: xStep, y: yStep)
        self.name = name
    }
    
    func shouldShift(_ space: Space, before otherSpace: Space) -> Bool {
        // Intuitively I think this works but I can't explain it
        
        let rowsInOrder = space.row * step.y >= otherSpace.row * step.y
        let colsInOrder = space.col * step.x >= otherSpace.col * step.x
        
        return rowsInOrder && colsInOrder
    }
}



// SpaceDelta -- Unit of a SpatialMap

class SpaceDelta {
    var startSpace: Space
    var endSpace: Space
    
    init(startSpace: Space, endSpace: Space) {
        self.startSpace = startSpace
        self.endSpace = endSpace
    }
}



// GameSceneElement -- Container for a sprite

class GameSceneElement {
    var row: Int
    var col: Int
    
    var sprite: SKSpriteNode?
    
    init(row: Int, col: Int) {
        self.row = row
        self.col = col
    }
}




//////////



// Direction (constructors)

extension Direction {
    class func up() -> Direction {
        return Direction("up", xStep: 0, yStep: 1)
    }
    
    class func down() -> Direction {
        return Direction("down", xStep: 0, yStep: -1)
    }
    
    class func right() -> Direction {
        return Direction("right", xStep: 1, yStep: 0)
    }
    
    class func left() -> Direction {
        return Direction("left", xStep: -1, yStep: 0)
    }
    
    class func diagonalNE() -> Direction {
        return Direction("up-right", xStep: 1, yStep: 1)
    }
    
    class func diagonalNW() -> Direction {
        return Direction("up-left", xStep: -1, yStep: 1)
    }
}
