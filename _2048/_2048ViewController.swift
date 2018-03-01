import UIKit
import SpriteKit

// _2048ViewController -- Entry-point for 2048 gameplay

class _2048ViewController: BoardGameViewController, _2048Delegate {
    
    // GameplayDelegate (inherited by _2048Delegate)
    
    override func gameDidPlace(element: Any, at space: Space) {
        // Sanity check
        
        guard let tile = element as? Int else { assertionFailure(); return }
        
        // Make a new GameSceneElement with the provided data and add it
        //  to the scene
        
        let tileElement = GameSceneElement(row: space.row, col: space.col)
        let imageName = resourceName(forTileValue: tile)
        
        scene.addElement(tileElement, imageName: imageName, animated: true)
    }
    
    override func gameDidMove(elementAt startSpace: Space, to endSpace: Space) {
        // Move the appropriate GameSceneElement. Since this isn't a
        //  merge, we won't need to remove any elements.
        
        scene.moveElement(from: startSpace, to: endSpace, imageName: nil, removeAfter: false)
    }
    
    
    
    // _2048Delegate
    
    func gameDidMerge(_ topSpace: Space, and bottomSpace: Space, to endSpace: Space, newValue: Int) {
        // Move the bottom element first. The scene will not change the
        //  reference space for the removed element, avoiding a
        //  mindbending pitfall.
        
        let imageName = resourceName(forTileValue: newValue)
        
        scene.moveElement(from: bottomSpace, to: endSpace, imageName: nil, removeAfter: true)
        scene.moveElement(from: topSpace, to: endSpace, imageName: imageName, removeAfter: false)
    }
    
    func gameScoreDidChange(newScore: Int) {
        print("2048 score updated: \(newScore)")
    }
    
    
    
    // BoardGameViewController
    
    override func setUpGame(view: SKView) {
        game = _2048(delegate: self)
        
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
        
        let size = view.bounds.size
        let tileLength = min(size.width / 6, CGFloat(100)) // This is totally arbitrary
        let appearance = GameSceneAppearance(rows: board.rows, cols: board.columns)
        appearance.elementSize = CGSize(width: tileLength, height: tileLength)
        
        scene = GameScene(size: view.bounds.size, appearance: appearance)
        scene.scaleMode = .aspectFill
        
        view.presentScene(scene)
        
        // Setup the game
        
        game.prepareForPlay()
    }
    
    
    
    // _2048ViewController
    //  - game
    //  = board
    //
    //  > handleSwipe(:)
    
    var game: _2048!
    var board: Board<Int> { return game.board }
    
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
    
    
    
    // _2048ViewController (private)
    
    private func resourceName(forTileValue value: Int) -> String {
        // 2048 resources are named 'Tile2', 'Tile16', etc. See
        //  Assets.xcassets.
        
        return "Tile\(value)"
    }
    
}
