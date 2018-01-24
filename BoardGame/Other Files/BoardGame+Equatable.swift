import Foundation

// Extend Space to conform to Equatable and Hashable. This allows us
//  to store spaces in arrays and dictionaries.

extension Space: Equatable, Hashable {
    var hashValue: Int {
        // A blogger who seemed to know what he was talking about condones
        //  this implementation.
        //
        // https://www.iamsim.me/swift-equatable-and-hashable/
        
        return row.hashValue ^ col.hashValue
    }
}

extension Piece: Equatable, Hashable {
    var hashValue: Int {
        if let player = self.player {
            return player.descriptor.hashValue ^ rawValue
        }
        
        return rawValue
    }
}

// ...I know, right??

func ==(lhs: Space, rhs: Space) -> Bool {
    return lhs.row == rhs.row && lhs.col == rhs.col
}

func ==(lhs: Piece, rhs: Piece) -> Bool {
    return lhs.player === rhs.player && lhs.hashValue == rhs.hashValue
}
