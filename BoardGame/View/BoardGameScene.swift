import SpriteKit
import GameplayKit

// BoardGameScene -- Think of this as the top-level view

class BoardGameScene: SKScene {
    
    // BoardGameScene
    //  = animationDuration
    //  = tileSize
    //  = tileCushion
    //  = boardLayer
    //  = tilesLayer
    //  - tiles
    //
    //  > addTile(:)
    //  > updateSprites()
    
    let animationDuration = 0.1
    
    let tileSize = CGSize(width: 50, height: 50)
    let tileCushion = CGFloat(1)
    
    let boardLayer = SKNode()
    let tilesLayer = SKNode()
    
    var tiles = [BoardGameTile]()
    
    required init?(coder aDecoder: NSCoder) {
        // This doesn't make any sense to me either
        fatalError("init(coder:) has not been implemented")
    }
    
    init(rows: Int, cols: Int, size: CGSize) {
        super.init(size: size)
        
        // Anchor child layers to the middle of the screen
        
        anchorPoint = CGPoint(x: 0.5, y: 0.5)
        backgroundColor = .white
        
        // Calculate the offset of the layer relative to the middle of
        //  the screen
        
        let xOffset = (tileSize.width * CGFloat(cols) / 2.0) + (tileCushion * (CGFloat(cols) - 1.0) / 2.0)
        let yOffset = (tileSize.height * CGFloat(rows) / 2.0) + (tileCushion * (CGFloat(rows) - 1.0) / 2.0)
        
        // Set up the container (boardLayer) and the board view interface
        //  (tilesLayer)
        
        addChild(boardLayer)
        
        tilesLayer.position = CGPoint(x: -xOffset, y: -yOffset)
        boardLayer.addChild(tilesLayer)
    }
    
    
    
    //////////
    
    
    
    // updateSprites() -- Draw any sprites that aren't on the screen
    
    func updateSprites() {
        for tile in tiles {
            // Iterate through the tiles array, skipping tiles that have
            //  already drawn their sprites
            
            if tile.sprite != nil { continue }
            
            // Set the texture of the tile. This initializes the tile's
            //  sprite.
            
            tile.setTexture(duration: animationDuration)
            
            // Sanity check
            
            guard let sprite = tile.sprite else { assertionFailure(); return }
            
            // Set the sprite's position based on the tile's row and column,
            //  then draw it
            
            sprite.position = position(ofRow: tile.row, inCol: tile.col)
            tilesLayer.addChild(sprite)
        }
    }
    
    // addTile(:) -- Store the new BoardGameTile and update the sprites
    //  to display it
    
    func addTile(_ tile: BoardGameTile) {
        tiles.append(tile)
        updateSprites()
    }
    
    // moveTile(from:to:removeAfter:) -- Animate the indicated tile movement
    
    func moveTile(from startSpace: Space, to endSpace: Space, removeAfter: Bool) {
        // Fetch the tile and sprite. Do a couple sanity checks while we're
        //  at it.
        
        guard let tile = tile(forRow: startSpace.row, inCol: startSpace.col) else { assertionFailure(); return }
        guard let sprite = tile.sprite else { assertionFailure(); return }
        
        // Instantiate a new SKAction describing the animation
        
        let newPosition = position(ofRow: endSpace.row, inCol: endSpace.col)
        let move = SKAction.move(to: newPosition, duration: animationDuration)
        
        if removeAfter {
            // If we're supposed to remove the tile afterwards, it needs to
            //  be pushed to the back before it's covered by another tile
            
            tile.moveToBack()
            
            // Instantiate a new SKAction removing the sprite from the tiles
            //  layer. Run the move animation first, then remove the sprite.
            
            let removeSprite = SKAction.removeFromParent()
            sprite.run(SKAction.sequence([move, removeSprite]))
            
            // Get rid of the reference to the old tile
            
            tiles = tiles.filter { $0 !== tile }
        } else {
            // Run the move action. Once it's done, update the BoardGameTile's
            //  row and column references.
            
            sprite.run(move) {
                tile.row = endSpace.row
                tile.col = endSpace.col
            }
        }
    }
    
    // setValue(:forTileAt:) -- Set the value of the appropriate BoardGameTile
    //  and update its texture
    
    func setValue(_ value: Int, forTileAt space: Space) {
        // Sanity check
        
        guard let tile = tile(forRow: space.row, inCol: space.col) else { assertionFailure(); return }
        
        // Set the value of the appropriate blah blah blah
        
        tile.value = value
        tile.setTexture(duration: animationDuration)
    }
    
    
    
    //////////
    
    
    
    private func position(ofRow row: Int, inCol col: Int) -> CGPoint {
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

