import Foundation
import SpriteKit

// SpriteFadeInAction -- fades in an SKSpriteNode

class AddSpriteAction: GameSceneSpriteAction {
    
    // BoardGameSpriteAction
    
    var sprite: SKSpriteNode!
    var duration: TimeInterval!
    
    func run(completion: @escaping () -> ()) {
        sprite.position = position
        sprite.zPosition = zPosition
        
        if animated { sprite.alpha = 0.0 }
        
        node.addChild(sprite)
        
        if animated {
            let fadeIn = SKAction.fadeIn(withDuration: duration)
            sprite.run(fadeIn, completion: completion)
        } else {
            completion()
        }
    }
    
    
    
    //////////
    
    
    
    // SpriteFadeInAction
    //  = position
    //  = node
    //  = zPosition
    
    let position: CGPoint
    let zPosition = CGFloat(10)
    let node: SKNode
    
    var animated = true
    
    init(position: CGPoint, node: SKNode) {
        self.position = position
        self.node = node
    }
}
