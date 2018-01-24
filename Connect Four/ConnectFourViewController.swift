import Foundation
import SpriteKit

// BoardGameViewController -- Literally (NOT) the only view controller in the app

class ConnectFourViewController: BoardGameViewController, ConnectFourDelegate {
    
    // ConnectFourDelegate
    
    func gameDidEnd(winner: Player, winningSequence: [Space]) {
        assertionFailure() // just for testing...
    }
    
    override func gameDidPlace(piece: Piece, at space: Space) {
        // Compute the image name. For Connect Four, the images are
        //  named 'RedPiece' and 'BluePiece' (see Assets.xcassets).
        
        let imageName = "\(piece.player!)Piece"
        
        // Ask the scene to animate the new image
        
        scene.moveElement(from: space, to: space, imageName: imageName, removeAfter: false)
    }
    
    
    
    // BoardGameViewController
    
    override func setUpGame(view: SKView) {
        // Standard Connect Four dimensions are 6x7
        
        let rows = 6
        let cols = 7
        
        // Initialize the game in the model
        
        game = ConnectFour(rows: rows, cols: cols, delegate: self)
        game.prepareForPlay()
        
        // Add a tap gesture recognizer
        
        let tap = UITapGestureRecognizer(target: self,
                                         action: #selector(self.handleTap))
        view.addGestureRecognizer(tap)
        
        // Set up a blank game scene
        
        scene = GameScene(rows: rows, cols: cols,
                          size: view.bounds.size)
        scene.scaleMode = .aspectFill
        
        // Present the blank scene
        
        view.presentScene(scene)
        
        // Populate the scene with dummy sprites so users can see the
        //  grid.
        
        for row in 1...rows { for col in 1...cols {
            
            let tile = GameSceneElement(row: row, col: col)
            scene.addElement(tile, imageName: "BlankPiece",
                             animated: false)
            
            } }
    }

    
    
    // ConnectFourViewController
    //  - game
    //
    //  > setUpGame(view:)
    //  > handleTap(gesture:)

    var game: ConnectFour!
    
    // handleTap(gesture:) -- Translate user input (via the tap
    //  recognizer) into a column and drop a piece
    
    @objc func handleTap(gesture: UIGestureRecognizer) {
        // Sanity check: we better have a tap-type gesture
        
        guard let tap = gesture as? UITapGestureRecognizer else { assertionFailure(); return }
        
        // Get the relative location of the tap
        
        let point = tap.location(in: view)
        
        // If this point translates to a column on the board, ask the
        //  game to drop a piece there
        
        guard let col = scene.approximatedColumn(forPoint: point) else { return }
        game.dropPiece(inColumn: col)
    }
    
}
