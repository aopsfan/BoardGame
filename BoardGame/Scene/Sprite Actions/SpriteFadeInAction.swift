import Foundation
import SpriteKit

// SpriteFadeInAction -- fades in an SKSpriteNode

class SpriteFadeInAction: BoardGameSpriteAction {
    
    // BoardGameSpriteAction
    
    var sprite: SKSpriteNode!
    var duration: TimeInterval!
    
    func run(completion: @escaping () -> ()) {
        // Set the sprite's xy position AND its z position. We
        //  set all the z positions to be the same at first for
        //  performance (see 'ignoresSiblingOrder' in the docs).
        
        sprite.position = position
        sprite.zPosition = zPosition
        
        // Make the sprite completely transparent, then add it
        //  to the node
        
        sprite.alpha = 0.0
        node.addChild(sprite)
        
        // Initialize and run the fade in animation
        
        let fadeIn = SKAction.fadeIn(withDuration: duration)
        sprite.run(fadeIn, completion: completion)
    }
    
    
    
    //////////
    
    
    
    // SpriteFadeInAction
    //  = position
    //  = node
    //  = zPosition
    
    let position: CGPoint
    let node: SKNode
    
    let zPosition = CGFloat(10)
    
    init(position: CGPoint, node: SKNode) {
        self.position = position
        self.node = node
    }
}
