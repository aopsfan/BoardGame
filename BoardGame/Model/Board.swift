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



// Board -- describes the state of the board

class Board {
    
    // Board
    //  = rows
    //  = columns
    //
    //  - tiles
    //
    //  > tile(at:)
    //  > space(:shifted:)
    //
    //  - allSpaces [lazy]
    //  > emptySpaces()
    //  > filledSpaces()
    //  > contains(spaceAt:)
    //  > contains(emptySpaceAt:)
    //  > contains(tileAt:)
    
    let rows: Int
    let columns: Int
    
    var tiles = [Space: Int]()
    
    init(_ rows: Int, _ columns: Int) {
        self.rows = rows
        self.columns = columns
    }
    
    
    
    //////////
    
    
    
    // tile(at:) -- Lookup the provided space in the tiles dictionary
    
    func tile(at space: Space) -> Int? {
        return tiles[space]
    }
    
    // space(:shifted:) -- Return the space, shifted once in the provided
    //  direction, if it's on the board
    
    func space(_ space: Space, shifted direction: Direction) -> Space? {
        // Build the offset space
        
        let step = direction.step
        let newSpace = Space(row: space.row + step.y, col: space.col + step.x)
        
        // Return the space or nil
        
        return contains(spaceAt: newSpace) ? newSpace : nil
    }
    
    
    
    //////////
    
    
    
    lazy var allSpaces: [Space] = { [unowned self] in
        // Build and return an array containing all spaces bounded by the preset
        //  numbers of rows and columns.
        
        var spaces = [Space]()
        
        for row in 1...rows { for col in 1...columns {
            spaces.append(Space(row: row, col: col))
            } }
        
        return spaces
        }()
    
    func emptySpaces() -> [Space] {
        // Filter out all spaces where a tile is found
        
        return allSpaces.filter { !contains(tileAt: $0) }
    }
    
    func filledSpaces() -> [Space] {
        // Return only the spaces where a tile is found
        
        return allSpaces.filter { contains(tileAt: $0) }
    }
    
    func contains(spaceAt space: Space) -> Bool {
        // Return whether or not allSpaces contains the space
        
        return allSpaces.contains(where: { $0 == space })
    }
    
    func contains(emptySpaceAt space: Space) -> Bool {
        // Return whether no tile was found at the provided space
        
        return emptySpaces().contains(space)
    }
    
    func contains(tileAt space: Space) -> Bool {
        // Return whether any tile was found at the provided space
        
        return tile(at: space) != nil
    }
}



// Board -- extended to provide mutating methods

extension Board {
    
    // Board
    //  > place(tile:at:)
    //  > move(tileAt:to:)
    //  > remove(tileAt:)
    
    // place(tile:at:) -- Assign a tile value to a particular space
    
    func place(tile: Int, at space: Space) {
        tiles[space] = tile
    }
    
    // move(tileAt:toEmptySpace:) -- If the end space is not blocked, adjust
    //  the tiles dictionary to reflect a moved tile. Return whether the move
    //  was successful.
    
    func move(tileAt startSpace: Space, toEmptySpace endSpace: Space) -> Bool {
        // First, ensure that the end space is empty
        
        guard contains(emptySpaceAt: endSpace) else { return false }
        
        // Clear the tile at the starting space and assign its value to the
        //  end space
        
        let frontTile = tile(at: startSpace)
        
        tiles[startSpace] = nil
        tiles[endSpace] = frontTile
        
        return true
    }
    
    // remove(tileAt:) -- Clear the tile at the provided space
    
    func remove(tileAt space: Space) {
        tiles[space] = nil
    }
}

