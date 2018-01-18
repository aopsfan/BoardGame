import SpriteKit
import GameplayKit

// BoardGameTile -- Wrapper for a 2048-style SKSpriteNode. Think of
//  this as the "tile view".

class BoardGameTile {
    
    var row: Int
    var col: Int
    
    var sprite: SKSpriteNode?
    
    init(row: Int, col: Int) {
        self.row = row
        self.col = col
    }
}
