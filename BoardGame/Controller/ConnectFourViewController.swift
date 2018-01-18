import Foundation
import SpriteKit

// BoardGameViewController -- Literally (NOT) the only view controller in the app

class ConnectFourViewController: BoilerplateViewController {
    var scene: BoardGameScene!
    var game: ConnectFour!
    
    func setUpGame(view: SKView, rows: Int, cols: Int) {
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.handleTap))
        view.addGestureRecognizer(tap)
        
        scene = BoardGameScene(rows: rows, cols: cols, size: view.bounds.size)
        scene.scaleMode = .aspectFill
        
        view.presentScene(scene)
        
        for row in 1...rows { for col in 1...cols {
            let tile = BoardGameTile(row: row, col: col)
            scene.drawSprite(tile, imageName: "BlankPiece", animated: false)
            }}
        
        game = ConnectFour(rows: rows, cols: cols, delegate: self)
        game.prepareForPlay()
    }
    
    @objc func handleTap(gesture: UIGestureRecognizer) {
        guard let tap = gesture as? UITapGestureRecognizer else { assertionFailure(); return }
        let point = tap.location(in: view)
        guard let col = scene.approximatedColumn(forPoint: point) else { return }
        
        game.dropPiece(inColumn: col)
    }
    
    //
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard let view = self.view as! SKView? else { assertionFailure(); return }
        setUpGame(view: view, rows: 6, cols: 7)
    }
}

extension ConnectFourViewController: ConnectFourDelegate {
    func gameDidEnd(winner: Player, winningSequence: [Space]) {
        assertionFailure() // just for testing...
    }
    
    func gameDidStartTurn(player: Player) {
        
    }
    
    func gameDidPlace(piece: BoardPiece, at space: Space) {
        let imageName = "\(piece.player!)Piece"
        scene.animateTile(from: space, to: space, imageName: imageName, removeAfter: false)
    }
}
