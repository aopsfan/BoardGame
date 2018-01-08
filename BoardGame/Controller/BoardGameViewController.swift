import UIKit
import SpriteKit
import GameplayKit

// BoardGameViewController -- Literally the only view controller in the app

class BoardGameViewController: UIViewController {
    
    // BoardGameViewController
    //  - scene
    //  - game
    //
    //  > setUpGame(rows:cols:)
    //  > handleSwipe(:)
    
    var scene: BoardGameScene!
    var game: Game!
    
    
    
    //////////
    
    
    
    // setUpGame(view:rows:cols:) -- Basic setup of the scene, swipe recognizers, and model
    
    func setUpGame(view: SKView, rows: Int, cols: Int) {
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
        
        scene = BoardGameScene(rows: rows, cols: cols, size: view.bounds.size)
        scene.scaleMode = .aspectFill
        
        view.presentScene(scene)
        
        // Setup the game
        
        game = Game(rows: rows, cols: cols, delegate: self)
        game.prepareForPlay()
    }
    
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
}



// BoardGameViewController -- GameplayDelegate

extension BoardGameViewController: GameplayDelegate {
    
    func gameDidPlace(tile: Int, at space: Space) {
        // Make a new BoardGameTile with the provided data and add it to the
        //  scene
        
        let playingTile = BoardGameTile(row: space.row, col: space.col, value: tile)
        scene.addTile(playingTile)
    }
    
    func gameDidMove(from startSpace: Space, to endSpace: Space) {
        // Move the appropriate BoardGameTile. Since this isn't a merge, we won't
        //  need to remove any tiles.
        
        scene.moveTile(from: startSpace, to: endSpace, removeAfter: false)
    }
    
    func gameDidMerge(_ topSpace: Space, and bottomSpace: Space, to endSpace: Space, newValue: Int) {
        // Update the value of the top tile
        
        scene.setValue(newValue, forTileAt: topSpace)
        
        // Move the bottom tile first. The scene will not change the reference
        //  space for the removed BoardGameTile, avoiding a mindbending pitfall.
        
        scene.moveTile(from: bottomSpace, to: endSpace, removeAfter: true)
        scene.moveTile(from: topSpace, to: endSpace, removeAfter: false)
    }
    
    func gameScoreDidChange(newScore: Int) {
        // Haven't implemented yet
    }
}
