import Foundation

// Space -- Structure that describes an index path (for a tile or an empty
//  space)

struct Space {
    let row: Int, col: Int
    
    // distance(to:) -- Simple Pythagorean implementation
    
    func distance(to other: Space) -> Double {
        let rowChange = Double(row - other.row)
        let colChange = Double(col - other.col)
        
        return sqrt(pow(rowChange, 2) + pow(colChange, 2))
    }
}
