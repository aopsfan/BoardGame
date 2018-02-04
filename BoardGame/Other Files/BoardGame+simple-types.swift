import Foundation
import SpriteKit

// BoardUpdate: alias used in DropMove, ShiftMove, etc.

typealias BoardUpdate = (_ startSpaces: [Space], _ endSpace: Space) -> ()

// Simple Types //

// Enums:
// - PlayerDescriptor

// Structs:
// - Space
// - Vector

// Classes:
// - GamePiece
// - Player
// - Direction
// - SpaceDelta
// - GameSceneElement



//////////



// PlayerDescriptor

enum PlayerDescriptor {
    case red, blue, white, black
}



// Space -- Structure that describes an index path (for a tile or an
//  empty space)

struct Space {
    let row: Int, col: Int
    
    // distance(to:)
    //  TESTME
    
    func distance(to other: Space) -> Double {
        let vectorDistance = other - self
        return vectorDistance.magnitude()
    }
}



// Vector -- Structure that describes a change in location

struct Vector {
    let x: Int
    let y: Int
    
    init(_ x: Int, _ y: Int) {
        self.x = x
        self.y = y
    }
    
    // magnitude() -- Simple Pythagorean implementation
    
    func magnitude() -> Double {
        return sqrt(pow(Double(x), 2) + pow(Double(y), 2))
    }
}



// GamePiece -- Describes a piece that can be "owned" by a particular
//  player

class GamePiece { // TODO: class/struct
    let player: Player?
    
    var descriptor: PlayerDescriptor? {
        return player?.descriptor
    }
    
    init(player: Player?) {
        self.player = player
    }
}



// Player

class Player {
    let descriptor: PlayerDescriptor
    
    init(descriptor: PlayerDescriptor) {
        self.descriptor = descriptor
    }
    
    func piece() -> GamePiece {
        return GamePiece(player: self)
    }
}



// Direction

class Direction {
    let step: Vector
    let name: String
    
    init(_ name: String, xStep: Int, yStep: Int) {
        step = Vector(xStep, yStep)
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



// Arithmetic
//  TESTME

func -(lhs: Space, rhs: Space) -> Vector {
    let x = lhs.col - rhs.col
    let y = lhs.row - rhs.row
    
    return Vector(x, y)
}

func +(lhs: Space, rhs: Vector) -> Space {
    let row = lhs.row + rhs.y
    let col = lhs.col + rhs.x
    
    return Space(row: row, col: col)
}

func +(lhs: Vector, rhs: Space) -> Space {
    let row = lhs.y + rhs.row
    let col = lhs.x + rhs.col
    
    return Space(row: row, col: col)
}



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
