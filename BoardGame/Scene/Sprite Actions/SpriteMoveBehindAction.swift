import Foundation
import SpriteKit

// SpriteMoveBehindAction -- Subclass of SpriteMoveAction that also moves the
//  sprite to the background and removes it from its parent node after the
//  animation

class SpriteMoveBehindAction: SpriteMoveAction {
    
    let backgroundZ = CGFloat(5)
    
    
    
    //////////
    
    
    
    override func run(completion: @escaping () -> ()) {
        // Sanity check -- if the sprite is being removed, we really shouldn't
        //  be changing its texture.
        
        guard texture == nil else { assertionFailure(); return }
        
        // Set the sprite's z position to a lower value to make sure it's
        //  covered by any tile occupying the same space
        
        sprite.zPosition = backgroundZ
        
        // Initialize an SKAction removing the sprite from its parent node, and
        //  run it in sequence after the default move action
        
        let removeSprite = SKAction.removeFromParent()
        sprite.run(SKAction.sequence([moveAction, removeSprite]), completion: completion)
    }
}
