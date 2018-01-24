import Foundation
//
// _2048 -- 2048 game model

class _2048: Game {
    
    // _2048
    //  = delegate
    //  - score
    //
    //  > prepareForPlay()
    //  > shiftBoard(:)
    
    let delegate: _2048Delegate
    var score = 0
    
    init(rows: Int, cols: Int, delegate: _2048Delegate) {
        self.delegate = delegate
        super.init(rows: rows, cols: cols)
    }

    // prepareForPlay() -- Conduct any game setup not appropriate
    //  for an initializer. For the standard 4x4 game, all we have
    //  to do is place two tiles.
    
    override func prepareForPlay() {
        for _ in 1...2 { placeTile() }
    }

    
    
    //////////
    
    

    // shiftBoard(:) -- Move/merge all eligible pieces in the
    //  specified direction. Place a new piece if necessary.

    func shiftBoard(_ direction: Direction) {
        // Instantiate and play a shift move

        let shift = ShiftMove(onBoard: board, direction: direction)
        var moved = false

        shift.play { (startSpaces, endSpace) in
            // Sanity check

            guard startSpaces.count < 3 else { assertionFailure(); return }

            // Any iteration of this block implies that we have
            //  moved
            
            moved = true

            if startSpaces.count == 1 {
                // If the move partial is one-to-one, all we have to
                //  do is notify the delegate

                delegate.gameDidMove(pieceAt: startSpaces[0],
                                     to: endSpace)
            } else if startSpaces.count == 2 {
                // If the move partial is two-to-one, we have a
                //  merge. First we obtain the resulting tile value
                //  from the board.

                guard let mergeValue = board.piece(at: endSpace)?.rawValue else {
                    assertionFailure()
                    return
                }
                
                // Handle the merge
                
                handleMerge(from: startSpaces, to: endSpace,
                            mergeValue: mergeValue)
            }
        }

        if moved {
            // If any tile moved, update the score, notify the
            //  delegate, and place a new tile

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


    
    private func handleMerge(from startSpaces: [Space], to endSpace: Space, mergeValue: Int) {
        // Sort the two spaces according to their distance from the
        //  end space. The closer space will always be covered.
        
        let topDownSpaces = startSpaces.sorted { lhs, rhs in
            return endSpace.distance(to: lhs) > endSpace.distance(to: rhs)
        }
        
        // Notify the delegate
        
        delegate.gameDidMerge(topDownSpaces[0],
                              and: topDownSpaces[1],
                              to: endSpace, newValue: mergeValue)
    }

    private func placeTile() {
        // Place a random tile on the board and notify the gameplay delegate

        let piece = Piece(randomTile())
        let space = randomSpace()

        board.place(piece: piece, at: space)
        delegate.gameDidPlace(piece: piece, at: space)
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
