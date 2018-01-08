import Foundation

// Objects conforming to this protocol are automatically translated
//  to text inside formatted strings

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
