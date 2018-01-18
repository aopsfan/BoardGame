import Foundation
import SpriteKit

// SpriteMoveAction -- Moves an SKSpriteNode

class UpdateSpriteAction: BoardGameSpriteAction {
    
    // BoardGameSpriteAction
    
    var sprite: SKSpriteNode!
    var duration: TimeInterval!
    
    func run(completion: @escaping () -> ()) {
        // Create a new variable referencing the lazy-loaded default action.
        //  We'll change it if a new texture is specified.
        
        var action = moveAction
        
        if let unwrappedTexture = texture {
            // If the texture property is non-nil, substitute the default action
            //  for a "group" action that performs the move and the texture
            //  update.
            
            let newTextureAction = SKAction.animate(with: [unwrappedTexture],
                                                    timePerFrame: duration)
            action = SKAction.group([moveAction, newTextureAction])
        }
        
        // Run the action
        
        sprite.run(action, completion: completion)
    }
    
    
    
    //////////
    
    
    
    // SpriteMoveAction
    //  = position
    //  = texture
    //  = moveAction [lazy]
    
    let position: CGPoint
    let texture: SKTexture?
    
    lazy var moveAction: SKAction = {
        return SKAction.move(to: position, duration: duration)
    }()
    
    init(position: CGPoint, texture: SKTexture?) {
        self.position = position
        self.texture = texture
    }
}


