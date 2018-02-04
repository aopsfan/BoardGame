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

extension GamePiece: CustomStringConvertible {
    var description: String {
        return player?.description ?? "[piece]"
    }
}

extension ChessPieceType: CustomStringConvertible {
    var description: String {
        var desc = "[chess piece]"
        
        switch self {
        case .pawn: desc = "P"
        case .rook: desc = "R"
        case .bishop: desc = "B"
        case .queen: desc = "Q"
        case .king: desc = "K"
        case .knight: desc = "N"
        }
        
        return desc
    }
}

extension Player: CustomStringConvertible {
    var description: String {
        var desc = "[Undescribed player]"
        
        switch descriptor {
        case .red: desc = "Red"
        case .blue: desc = "Blue"
        case .white: desc = "White"
        case .black: desc = "Black"
        }
        
        return desc
    }
}
