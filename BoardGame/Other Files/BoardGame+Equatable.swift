import Foundation

extension Space: Equatable, Hashable {
    static func ==(lhs: Space, rhs: Space) -> Bool {
        return lhs.row == rhs.row && lhs.col == rhs.col
    }
    
    var hashValue: Int {
        // A blogger who seemed to know what he was talking about condones
        //  this implementation.
        //
        // https://www.iamsim.me/swift-equatable-and-hashable/
        
        return row.hashValue ^ col.hashValue
    }
}

extension GamePiece: Equatable, Hashable {
    static func ==(lhs: GamePiece, rhs: GamePiece) -> Bool {
        return lhs.player === rhs.player && lhs.hashValue == rhs.hashValue
    }
    
    var hashValue: Int {
        return player.descriptor.hashValue
    }
}

extension Vector: Equatable, Hashable {
    static func ==(lhs: Vector, rhs: Vector) -> Bool {
        return lhs.x == rhs.x && lhs.y == rhs.y
    }
    
    var hashValue: Int {
        return x ^ y
    }
}

