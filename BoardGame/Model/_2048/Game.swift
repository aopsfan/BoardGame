import Foundation

// Game -- Entry-point for gameplay interaction within the model

class Game {
    
    // Game
    //  = board
    //  = delegate
    //  - score
    //
    //  > prepareForPlay()
    //  > shiftBoard(:)
    
    let board: Board
    let delegate: GameplayDelegate
    
    var score = 0
    
    init(rows: Int, cols: Int, delegate: GameplayDelegate) {
        self.delegate = delegate
        
        board = Board(rows, cols)
    }
    
    
    
    //////////
    
    
    
    // prepareForPlay() -- Conduct any game setup not appropriate for an
    //  initializer. For the standard 4x4 game, all we have to do is place
    //  two tiles.
    
    func prepareForPlay() {
        for _ in 1...2 { placeTile() }
    }
    
    // shiftBoard(:) -- Move and merge all applicable tiles in the specified
    //  direction. Place a new tile if necessary.
    
    func shiftBoard(_ direction: Direction) {
        // Instantiate and play a shift move
        
        let shift = ShiftMove(onBoard: board, direction: direction)
        var moved = false
        
        shift.play { (startSpaces, endSpace) in
            // Sanity check
            
            guard startSpaces.count < 3 else { assertionFailure(); return }
            
            if startSpaces.count == 1 {
                // If the move partial is one-to-one, all we have to do is
                //  notify the delegate
                
                delegate.gameDidMove(from: startSpaces[0], to: endSpace)
            } else if startSpaces.count == 2 {
                // If the move partial is two-to-one, we have a merge. First
                //  we obtain the resulting tile value from the board.
                
                guard let mergeValue = board.piece(at: endSpace)?.rawValue else {
                    assertionFailure()
                    return
                }
                
                // Next, sort the two spaces according to their distance from
                //  the end space. The closer space will always be covered.
                
                let topDownSpaces = startSpaces.sorted { endSpace.distance(to: $0) > endSpace.distance(to: $1) }
                
                // Notify the delegate
                
                delegate.gameDidMerge(topDownSpaces[0], and: topDownSpaces[1], to: endSpace, newValue: mergeValue)
            }
            
            // Any iteration of this block implies that we have moved
            
            moved = true
        }
        
        if moved {
            // If any tile moved, update the score, notify the delegate, and
            //  place a new tile
            
            score += shift.score
            delegate.gameScoreDidChange(newScore: score)
            
            // 15x20
            /*
            let numNewTiles = min(board.emptySpaces().count, 20)
            for _ in 1...numNewTiles { placeTile() } */
            
            // 4x4
            placeTile()
        }
    }
    
    
    
    //////////
    
    
    
    private func placeTile() {
        // Place a random tile on the board and notify the gameplay delegate
        
        let tile = randomTile()
        let space = randomSpace()
        
        board.place(piece: BoardPiece(tile), at: space)
        
        delegate.gameDidPlace(tile: tile, at: space)
    }
    
    private func randomSpace() -> Space {
        // Randomly choose an index of the empty spaces
        
        let spaces = board.emptySpaces()
        let spaceIndex = arc4random() % UInt32(spaces.count)
        
        // Lookup the space at the index and return it
        
        return spaces[Int(spaceIndex)]
    }
    
    // 15x20
    /*
    private func randomTile() -> Int {
        let seed = arc4random() % 128
        
        if seed < 4 { return 16 }
        else if seed < 10 { return 8 }
        else if seed < 32 { return 4 }
        
        return 2
    } */
    
    // 4x4
    private func randomTile() -> Int {
        // Give the tile a 10% chance of being a 4

        let tileIs4 = arc4random() % 10 == 1

        // Return 2 or 4

        return tileIs4 ? 4 : 2
    }
}