import Foundation

// Board -- extended to provide mutating methods

extension Board {
    
    // Board
    //  > place(tile:at:)
    //  > move(tileAt:to:)
    //  > remove(tileAt:)
    
    // place(tile:at:) -- Assign a tile value to a particular space
    
    func place(element: Element, at space: Space) {
        elements[space] = element
    }
    
    // move(tileAt:toEmptySpace:) -- If the end space is not blocked, adjust
    //  the tiles dictionary to reflect a moved tile. Return whether the move
    //  was successful.
    
    func move(elementAt startSpace: Space, toEmptySpace endSpace: Space) -> Bool {
        // First, ensure that the end space is empty
        
        guard contains(emptySpaceAt: endSpace) else { return false }
        
        // Clear the tile at the starting space and assign its value to the
        //  end space
        
        elements[endSpace] = element(at: startSpace)
        elements[startSpace] = nil
        
        // If we got this far, the tile must have moved. Return true.
        
        return true
    }
    
    // remove(tileAt:) -- Clear the tile at the provided space
    
    func remove(elementAt space: Space) {
        elements[space] = nil
    }
}
