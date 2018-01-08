import SpriteKit
import GameplayKit

// BoardGameTile -- Wrapper for SKSpriteNode

class BoardGameTile {
    
    // BoardGameTile
    //  * topZ
    //  * bottomZ
    //  - row
    //  - col
    //  - value
    //  = size
    //  - sprite
    
    static let topZ = CGFloat(100)
    static let bottomZ = CGFloat(50)
    
    var row: Int
    var col: Int
    var value: Int
    
    let size = CGSize(width: 50, height: 50)
    var sprite: SKSpriteNode?
    
    init(row: Int, col: Int, value: Int) {
        self.row = row
        self.col = col
        self.value = value
    }
    
    
    
    //////////
    
    
    
    // setTexture(duration:) -- Change the sprite's image with a nice fade
    //  animation
    
    func setTexture(duration: Double) {
        if sprite == nil {
            // Instantiate and set up the tile if need be
            
            sprite = SKSpriteNode(imageNamed: imageName())
            sprite?.zPosition = BoardGameTile.topZ
            sprite?.size = size
        } else {
            // Create and run the new texture animation
            
            let newTexture = SKAction.animate(with: [SKTexture(imageNamed: imageName())],
                                              timePerFrame: duration)
            sprite?.run(newTexture)
        }
    }
    
    // moveToBack() -- Decrement the sprite's z to ensure it is covered
    //  during the next animation
    
    func moveToBack() {
        sprite?.zPosition = BoardGameTile.bottomZ
    }
    
    
    
    //////////
    
    
    
    private func imageName() -> String {
        return "Tile\(value)"
    }
}
