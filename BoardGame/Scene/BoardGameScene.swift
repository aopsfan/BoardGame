import SpriteKit
import GameplayKit

// BoardGameScene -- Think of this as the top-level view

class BoardGameScene: SKScene {
    
    // BoardGameScene
    //  = animationDuration
    //  = tileSize
    //  = tileCushion
    //
    //  = board
    //  - tiles
    //
    //  > animateNewTile(:)
    //  > animateTile(from:to:newValue:removeAfter:)
    
    let animationDuration = 0.2
    let tileSize = CGSize(width: 50, height: 50)
    let tileCushion = CGFloat(1)
    
    let board = SKNode()
    
    var tiles = [BoardGameTile]()
    
    var rows: Int!
    var columns: Int!
    
    lazy var tileBounds: CGSize = {
        return CGSize(width: tileSize.width + tileCushion,
                      height: tileSize.height + tileCushion)
    }()
    
    lazy var boardBounds: CGSize = {
        return CGSize(width: tileBounds.width * CGFloat(columns),
                      height: tileBounds.height * CGFloat(rows))
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

        let xOffset = (tileSize.width * CGFloat(cols) / 2.0) + (tileCushion * (CGFloat(cols) - 1.0) / 2.0)
        let yOffset = (tileSize.height * CGFloat(rows) / 2.0) + (tileCushion * (CGFloat(rows) - 1.0) / 2.0)

        // Set up the board layer

        board.position = CGPoint(x: -xOffset, y: -yOffset)
        addChild(board)
    }
    
    
    
    //////////
    
    
    
    func positionRange(forColumn column: Int) -> [CGPoint] {
        let min = positionOnBoard(ofRow: 0, inCol: column)
        let max = positionOnBoard(ofRow: 0, inCol: column + 1)
        
        return [min, max]
    }
    
    // animateNewTile(:) -- Store the new BoardGameTile, set up its sprite,
    //  and add it to the scene with animation
    
    func drawSprite(_ tile: BoardGameTile, imageName: String, animated: Bool) {
        // Initialize and set up the sprite
        
        let sprite = SKSpriteNode(imageNamed: imageName)
        sprite.size = tileSize
        
        // Add the sprite reference to the BoardGameTile, and add
        //  the tile reference to the tiles array
        
        tile.sprite = sprite
        tiles.append(tile)
        
        // Calculate the expected position of the sprite and instantiate
        //  a new sprite action to fade the tile in
        
        let position = self.positionOnBoard(ofRow: tile.row, inCol: tile.col)
        let action = AddSpriteAction(position: position, node: board)
        action.sprite = sprite
        action.duration = animationDuration
        action.animated = animated
        
        // Run the fade-in action
        
        action.run {}
    }
    
    
    
    // animateTile(from:to:newValue:removeAfter:) -- Animate the indicated tile movement
    
    func animateTile(from startSpace: Space, to endSpace: Space, imageName imageNameOrNil: String?, removeAfter: Bool) {
        // Fetch the tile and sprite. Do a couple sanity checks while we're
        //  at it.
        
        guard let tile = tile(forRow: startSpace.row, inCol: startSpace.col) else { assertionFailure(); return }
        guard let sprite = tile.sprite else { assertionFailure(); return }
        
        // Calculate the final position of the tile, and instantiate a new
        //  SKTexture to be set if needed
        
        let newPosition = positionOnBoard(ofRow: endSpace.row, inCol: endSpace.col)
        var texture: SKTexture? = nil
        
        if let imageName = imageNameOrNil {
            // If the value needs to be changed, initialize the texture
            
            texture = SKTexture(imageNamed: imageName)
        }

        if removeAfter {
            // Use a SpriteMoveBehindAction if we're removing the sprite after
            //  the animation. This action will automatically remove the sprite
            //  from the tiles layer.
            
            let action = MoveSpriteToBackAction(position: newPosition, texture: texture)
            action.sprite = sprite
            action.duration = animationDuration
            
            action.run {
                // After the animation is done, remove the reference to the
                //  deleted tile
                
                self.tiles = self.tiles.filter { $0 !== tile }
            }
        } else {
            // Otherwise, initialize a regular SpriteMoveAction. Here we pass
            //  in the new texture (which is nil if the tile's value hasn't
            //  changed).
            
            let action = UpdateSpriteAction(position: newPosition, texture: texture)
            action.sprite = sprite
            action.duration = animationDuration
            
            action.run {
                // After this animation finishes, update the reference space for
                //  the BoardGameTile
                
                tile.row = endSpace.row
                tile.col = endSpace.col
            }
        }
    }
    
    func approximatedColumn(forPoint point: CGPoint) -> Int? {
        let indent = (size.width - boardBounds.width) / 2.0
        let adjustedX = point.x - indent
        
        guard adjustedX >= 0 else { return nil }
        
        return Int(adjustedX / tileBounds.width) + 1
    }
    

    
    //////////
    
    
    
    private func positionOnBoard(ofRow row: Int, inCol col: Int) -> CGPoint {
        // Do some math to convert a row and column to a point on the view
        
        return CGPoint(
            x: tileSize.width * CGFloat(col) + tileCushion * CGFloat(col - 1) - tileSize.width / 2,
            y: tileSize.height * CGFloat(row) + tileCushion * CGFloat(row - 1) - tileSize.height / 2)
    }

    private func tile(forRow row: Int, inCol col: Int) -> BoardGameTile? {
        // Search the tiles array for a BoardGameTile at the specified position
        
        let tiles = self.tiles.filter { $0.row == row && $0.col == col }
        
        // Sanity check - ensure we only have one such tile before returning it
        
        guard tiles.count < 2 else { assertionFailure(); return nil }
        return tiles.count == 1 ? tiles[0] : nil
    }
}
