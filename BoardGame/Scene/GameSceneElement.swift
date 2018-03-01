import Foundation
import SpriteKit

// GameSceneElement -- Container for a sprite

class GameSceneElement {
    var location: Space
    
    var sprite: SKSpriteNode?
    
    init(row: Int, col: Int) {
        location = Space(row: row, col: col)
    }
    
    func setTexture(imageName: String) {
        // FIXME
    }
}
