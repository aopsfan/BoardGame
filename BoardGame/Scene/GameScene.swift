import SpriteKit

// BoardGameScene -- Think of this as the top-level view

class GameScene: SKScene {
    
    // GameScene
    //  = animationDuration
    //  = elementSize
    //  = elementCushion
    //  - elements
    //  = board
    //  = rows
    //  = columns
    //
    //  - elementBounds [lazy]
    //  - boardBounds [lazy]
    //
    //  > addElement(:imageName:animated:)
    //  > moveElement(from:to:imageName:removeAfter:)
    //  > approximatedColumn(forPoint:)
    
    let animationDuration = 0.2
    let elementSize = CGSize(width: 50, height: 50)
    let elementSpacing = CGFloat(1)
    var elements = [GameSceneElement]()
    let board = SKNode()
    
    var rows: Int!
    var columns: Int!
    
    lazy var elementBounds: CGSize = {
        return CGSize(width: elementSize.width + elementSpacing,
                      height: elementSize.height + elementSpacing)
    }()
    
    lazy var boardBounds: CGSize = {
        return CGSize(width: elementBounds.width * CGFloat(columns),
                      height: elementBounds.height * CGFloat(rows))
    }()
    
    required init?(coder aDecoder: NSCoder) {
        // This doesn't make any sense to me either
        fatalError("init(coder:) has not been implemented")
    }
    
    init(rows: Int, cols: Int, size: CGSize) {
        super.init(size: size)
        self.rows = rows
        self.columns = cols
        
        // Anchor child layers to the middle of the screen
        
        anchorPoint = CGPoint(x: 0.5, y: 0.5)
        backgroundColor = .white
        
        // Calculate the offset of the layer relative to the middle of
        //  the screen

        let xOffset = (elementSize.width * CGFloat(cols) / 2.0) + (elementSpacing * (CGFloat(cols) - 1.0) / 2.0)
        let yOffset = (elementSize.height * CGFloat(rows) / 2.0) + (elementSpacing * (CGFloat(rows) - 1.0) / 2.0)

        // Set up the board layer

        board.position = CGPoint(x: -xOffset, y: -yOffset)
        addChild(board)
    }
    
    // addElement(:imageName:animated:) -- Initialize the provided
    //  GameSceneElement's sprite and add it to the scene
    
    func addElement(_ element: GameSceneElement, imageName: String, animated: Bool) {
        // Initialize and set up the sprite
        
        let sprite = SKSpriteNode(imageNamed: imageName)
        sprite.size = elementSize
        
        // Add the sprite reference to the GameSceneElement, and add
        //  the reference to the elements array
        
        element.sprite = sprite
        elements.append(element)
        
        // Calculate the expected position of the sprite and instantiate
        //  a new sprite action to fade it in
        
        let position = self.positionOnBoard(ofRow: element.row, inCol: element.col)
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
        
        guard let element = element(forRow: startSpace.row, inCol: startSpace.col) else { assertionFailure(); return }
        guard let sprite = element.sprite else { assertionFailure(); return }
        
        // Calculate the final position of the element, and instantiate
        //  a new SKTexture to be set if needed
        
        let newPosition = positionOnBoard(ofRow: endSpace.row, inCol: endSpace.col)
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
                
                element.row = endSpace.row
                element.col = endSpace.col
            }
        }
    }
    
    // approximatedColumn(forPoint:) -- Compute a column number given a
    //  point (presumably a tap location) in the view
    
    func approximatedColumn(forPoint point: CGPoint) -> Int? {
        // FIXME
        
        let indent = (size.width - boardBounds.width) / 2.0
        let adjustedX = point.x - indent
        
        guard adjustedX >= 0 else { return nil }
        
        return Int(adjustedX / elementBounds.width) + 1
    }
    

    
    // GameScene (private)
    //  > positionOnBoard(ofRow:inCol:)
    //  > element(forRow:inCol:)
    
    private func positionOnBoard(ofRow row: Int, inCol col: Int) -> CGPoint {
        // Do some math to convert a row and column to a point on the view
        
        return CGPoint(
            x: elementSize.width * CGFloat(col) + elementSpacing * CGFloat(col - 1) - elementSize.width / 2,
            y: elementSize.height * CGFloat(row) + elementSpacing * CGFloat(row - 1) - elementSize.height / 2)
    }

    private func element(forRow row: Int, inCol col: Int) -> GameSceneElement? {
        // Search the elements array for a GameSceneElement at the specified position
        
        let elements = self.elements.filter { $0.row == row && $0.col == col }
        
        // Sanity check - ensure we only have one such element before returning it
        
        guard elements.count < 2 else { assertionFailure(); return nil }
        return elements.count == 1 ? elements[0] : nil
    }
}
