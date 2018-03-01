import Foundation
import SpriteKit

class ChessSandboxViewController: BoardGameViewController, ChessDelegate {
    
    // GameplayDelegate
    
    override func gameDidMove(elementAt startSpace: Space, to endSpace: Space) {
        scene.moveElement(from: startSpace, to: endSpace, imageName: nil, removeAfter: false)
    }
    
    // ChessDelegate
    
    func gamePiece(at startSpace: Space, didCapturePieceAt endSpace: Space) {
        scene.moveElement(from: endSpace, to: endSpace, imageName: nil, removeAfter: true)
        scene.moveElement(from: startSpace, to: endSpace, imageName: nil, removeAfter: false)
    }
    
    //
    
    override func setUpGame(view: SKView) {
        game = Chess(delegate: self)
        
        let appearance = GameSceneAppearance(rows: 8, cols: 8)
        appearance.elementSpacing = 1
        
        scene = GameScene(size: view.bounds.size, appearance: appearance)
        scene.scaleMode = .aspectFill
        
        view.presentScene(scene)
        
        for (space, piece) in board.elements {
            let pieceElement = GameSceneElement(row: space.row, col: space.col)
            let imageName = "\(piece.descriptor)\(piece.type)"
            
            scene.addElement(pieceElement, imageName: imageName, animated: false)
        }
        
        let tap = UITapGestureRecognizer(target: self,
                                         action: #selector(self.handleTap))
        view.addGestureRecognizer(tap)
    }
    
    //
    
    var game: Chess!
    var highlightedSpace: Space?
    
    var board: ChessBoard { return game.board }
    
    @objc func handleTap(gesture: UIGestureRecognizer) {
        guard let tap = gesture as? UITapGestureRecognizer else { assertionFailure(); return }
        let point = tap.location(in: view)
        
        guard let selection = scene.location(ofPoint: point) else { return }
        
        if let highlightedSpace = self.highlightedSpace {
            game.tryMove(from: highlightedSpace, to: selection)
            self.highlightedSpace = nil
        } else if game.contains(activePieceAt: selection) {
            self.highlightedSpace = selection
        }
    }
}
