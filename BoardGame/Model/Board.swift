import Foundation

// Board -- describes the state of the board

class Board<Element> {
    
    // Board
    //  = rows
    //  = columns
    //  - elements
    //
    //  > space(:shifted:)
    //
    //  > element(at:)
    //  - allSpaces [lazy]
    //  > emptySpaces()
    //  > filledSpaces()
    //  > contains(spaceAt:)
    //  > contains(emptySpaceAt:)
    //  > contains(elementAt:)
    
    let rows: Int
    let columns: Int
    
    var elements = [Space: Element]()
    
    init(_ rows: Int, _ columns: Int) {
        self.rows = rows
        self.columns = columns
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
    
    func element(at space: Space) -> Element? {
        return elements[space]
    }
    
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
        // Filter out all spaces where an element is found
        
        return allSpaces.filter { !contains(elementAt: $0) }
    }
    
    func filledSpaces() -> [Space] {
        // Return only the spaces where an element is found
        
        return allSpaces.filter { contains(elementAt: $0) }
    }
    
    func contains(spaceAt space: Space) -> Bool {
        // Return whether or not allSpaces contains the space
        
        return allSpaces.contains(where: { $0 == space })
    }
    
    func contains(emptySpaceAt space: Space) -> Bool {
        // Return whether no element was found at the provided space
        
        return emptySpaces().contains(space)
    }
    
    func contains(elementAt space: Space) -> Bool {
        // Return whether any element was found at the provided space
        
        return element(at: space) != nil
    }
}
