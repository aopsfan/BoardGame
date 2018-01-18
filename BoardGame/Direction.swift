import Foundation

// Direction -- Definitely the most iffy class in the program, but
//  I don't have the motivation to refactor

class Direction {
    
    // Direction
    //  = step
    //  = name
    //
    //  > shouldShift(:before:)
    
    let step: (x: Int, y: Int)
    let name: String
    
    init(_ name: String, xStep: Int, yStep: Int) {
        step = (x: xStep, y: yStep)
        self.name = name
    }
    
    
    
    //////////
    
    
    
    func shouldShift(_ space: Space, before otherSpace: Space) -> Bool {
        // Intuitively I think this works but I can't explain it
        
        let rowsInOrder = space.row * step.y >= otherSpace.row * step.y
        let colsInOrder = space.col * step.x >= otherSpace.col * step.x
        
        return rowsInOrder && colsInOrder
    }
}



// Direction -- constructors

extension Direction {
    
    class func up() -> Direction {
        return Direction("up", xStep: 0, yStep: 1)
    }
    
    class func down() -> Direction {
        return Direction("down", xStep: 0, yStep: -1)
    }
    
    class func right() -> Direction {
        return Direction("right", xStep: 1, yStep: 0)
    }
    
    class func left() -> Direction {
        return Direction("left", xStep: -1, yStep: 0)
    }
    
    //
    
    class func diagonalNE() -> Direction {
        return Direction("up-right", xStep: 1, yStep: 1)
    }
    
    class func diagonalNW() -> Direction {
        return Direction("up-left", xStep: -1, yStep: 1)
    }
}

