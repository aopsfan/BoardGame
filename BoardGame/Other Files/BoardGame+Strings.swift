import Foundation

// Objects conforming to CustomStringConvertible are automatically
//  translated to text inside formatted strings

extension Space: CustomStringConvertible {
    var description: String {
        return "(R\(row)-C\(col))"
    }
}

extension Direction: CustomStringConvertible {
    var description: String {
        return "{\(name)}"
    }
}

extension Piece: CustomStringConvertible {
    var description: String {
        return player?.description ?? "[piece]"
    }
}

extension Player: CustomStringConvertible {
    var description: String {
        var desc = "[Undescribed player]"
        
        switch descriptor {
        case .red: desc = "Red"
        case .blue: desc = "Blue"
        }
        
        return desc
    }
}
