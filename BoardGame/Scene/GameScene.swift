import SpriteKit

// GameScene -- Think of this as the top-level view

class GameScene: SKScene {
    
    var elements = [GameSceneElement]()
    let board = SKNode()
    let animationDuration = 0.2
    
    var appearance: GameSceneAppearance!
    
    required init?(coder aDecoder: NSCoder) {
        // This doesn't make any sense to me either
        fatalError("init(coder:) has not been implemented")
    }
    
    init(size: CGSize, appearance: GameSceneAppearance) {
        super.init(size: size)
        self.appearance = appearance
        
        // Anchor child layers to the middle of the screen
        
        anchorPoint = CGPoint(x: 0.5, y: 0.5)
        backgroundColor = .white
        
        // Set up the board layer

        board.position = appearance.boardPosition
        addChild(board)
    }
    
    // addElement(:imageName:animated:) -- Initialize the provided
    //  GameSceneElement's sprite and add it to the scene
    
    func addElement(_ element: GameSceneElement, imageName: String, animated: Bool) {
        // Initialize and set up the sprite
        
        let sprite = SKSpriteNode(imageNamed: imageName)
        sprite.size = appearance.elementSize
        
        // Add the sprite reference to the GameSceneElement, and add
        //  the reference to the elements array
        
        element.sprite = sprite
        elements.append(element)
        
        // Calculate the expected position of the sprite and instantiate
        //  a new sprite action to fade it in
        
        let position = appearance.position(ofSpace: element.location)
        let action = AddSpriteAction(position: position, node: board)
        action.sprite = sprite
        action.duration = animationDuration
        action.animated = animated
        
        // Run the fade-in action
        
        action.run {}
    }
    
    // moveElement(from:to:imageName:removeAfter:) -- Animate the
    //  indicated movement
    
    func moveElement(from startSpace: Space, to endSpace: Space, imageName imageNameOrNil: String?, removeAfter: Bool) {
        // Fetch the element and sprite. Do a couple sanity checks while
        //  we're at it.
        
        guard let element = element(at: startSpace) else { assertionFailure(); return }
        guard let sprite = element.sprite else { assertionFailure(); return }
        
        // Calculate the final position of the element, and instantiate
        //  a new SKTexture to be set if needed
        
        let newPosition = appearance.position(ofSpace: endSpace)
        var texture: SKTexture? = nil
        
        if let imageName = imageNameOrNil {
            // If the value needs to be changed, initialize the texture
            
            texture = SKTexture(imageNamed: imageName)
        }

        if removeAfter {
            // Use a SpriteMoveBehindAction if we're removing the sprite
            //  after the animation. This action will automatically
            //  remove the sprite from the board node.
            
            let action = MoveSpriteToBackAction(position: newPosition, texture: texture)
            action.sprite = sprite
            action.duration = animationDuration
            
            action.run {
                // After the animation is done, remove the reference to
                //  the deleted element
                
                self.elements = self.elements.filter { $0 !== element }
            }
        } else {
            // Otherwise, initialize a regular SpriteMoveAction. Here we
            //  pass in the new texture (or nil).
            
            let action = UpdateSpriteAction(position: newPosition, texture: texture)
            action.sprite = sprite
            action.duration = animationDuration
            
            action.run {
                // After this animation finishes, update the reference
                //  index path for the GameSceneElement
                
                element.location = endSpace
            }
        }
    }
    
    func location(ofPoint point: CGPoint) -> Space? {
        let offset = CGSize(width: (size.width - appearance.boardBounds.width) / 2.0,
                            height: (size.height - appearance.boardBounds.height) / 2.0)
        let adjustedY = point.y - offset.height
        let flippedY = (adjustedY - appearance.boardBounds.height) * -1
        let adjustedPoint = CGPoint(x: point.x - offset.width, y: flippedY)
        
        return appearance.location(ofPoint: adjustedPoint)
    }
    

    
    // GameScene (private)
    
    private func element(at space: Space) -> GameSceneElement? {
        // Search the elements array for a GameSceneElement at the specified position
        
        let elements = self.elements.filter { $0.location == space }
        
        // Sanity check - ensure we only have one such element before returning it
        
        guard elements.count < 2 else { assertionFailure(); return nil }
        return elements.count == 1 ? elements[0] : nil
    }
}
