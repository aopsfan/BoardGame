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

extension BoardPiece: CustomStringConvertible {
    var description: String {
        if let player = self.player {
            return "\(player) [\(rawValue)]"
        }
        
        return String(reflecting: rawValue)
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
