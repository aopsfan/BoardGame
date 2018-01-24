import UIKit
import SpriteKit

// _2048ViewController -- Entry-point for 2048 gameplay

class _2048ViewController: BoardGameViewController, _2048Delegate {
    
    // _2048Delegate
    
    override func gameDidPlace(piece: Piece, at space: Space) {
        // Make a new GameSceneElement with the provided data and add it
        //  to the scene
        
        let tileElement = GameSceneElement(row: space.row, col: space.col)
        let imageName = resourceName(forTileValue: piece.rawValue)
        
        scene.addElement(tileElement, imageName: imageName, animated: true)
    }
    
    override func gameDidMove(pieceAt startSpace: Space, to endSpace: Space) {
        // Move the appropriate GameSceneElement. Since this isn't a
        //  merge, we won't need to remove any elements.
        
        scene.moveElement(from: startSpace, to: endSpace, imageName: nil, removeAfter: false)
    }
    
    func gameDidMerge(_ topSpace: Space, and bottomSpace: Space, to endSpace: Space, newValue: Int) {
        // Move the bottom element first. The scene will not change the
        //  reference space for the removed element, avoiding a
        //  mindbending pitfall.
        
        let imageName = resourceName(forTileValue: newValue)
        
        scene.moveElement(from: bottomSpace, to: endSpace, imageName: nil, removeAfter: true)
        scene.moveElement(from: topSpace, to: endSpace, imageName: imageName, removeAfter: false)
    }
    
    
    
    // BoardGameViewController
    
    override func setUpGame(view: SKView) {
        // 2048 is played on a 4x4 grid
        
        let rows = 4
        let cols = 4
        
        // Add a gesture recognizer for each direction to the view
        
        let up = UISwipeGestureRecognizer(target: self, action: #selector(self.handleSwipe))
        up.direction = .up
        let down = UISwipeGestureRecognizer(target: self, action: #selector(self.handleSwipe))
        down.direction = .down
        let left = UISwipeGestureRecognizer(target: self, action: #selector(self.handleSwipe))
        left.direction = .left
        let right = UISwipeGestureRecognizer(target: self, action: #selector(self.handleSwipe))
        right.direction = .right
        
        for gesture in [up, down, left, right] {
            view.addGestureRecognizer(gesture)
        }
        
        // Setup and present the scene
        
        scene = GameScene(rows: rows, cols: cols, size: view.bounds.size)
        scene.scaleMode = .aspectFill
        
        view.presentScene(scene)
        
        // Setup the game
        
        game = _2048(rows: rows, cols: cols, delegate: self)
        game.prepareForPlay()
    }
    
    
    
    // _2048ViewController
    //  - game
    //
    //  > handleSwipe(:)
    
    var game: _2048!
    
    // handleSwipe(gesture:) -- Shift the board based on the direction of the
    //  swipe
    
    @objc func handleSwipe(gesture: UIGestureRecognizer) {
        // Sanity check
        
        guard let swipe = gesture as? UISwipeGestureRecognizer else { assertionFailure(); return }
        
        // Handle the swipe
        
        switch swipe.direction {
        case .up: game.shiftBoard(Direction.up())
        case .down: game.shiftBoard(Direction.down())
        case .left: game.shiftBoard(Direction.left())
        case .right: game.shiftBoard(Direction.right())
        default: assertionFailure()
        }
    }
    
    
    
    //////////
    
    
    
    private func resourceName(forTileValue value: Int) -> String {
        // 2048 resources are named 'Tile2', 'Tile16', etc. See
        //  Assets.xcassets.
        
        return "Tile\(value)"
    }
    
}
