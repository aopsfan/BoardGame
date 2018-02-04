import Foundation
import SpriteKit

class DemoViewController: BoardGameViewController {
    
    override func setUpGame(view: SKView) {
        let whitePlayer = Player(descriptor: .white)
        let blackPlayer = Player(descriptor: .black)

        let board = Board<Any>.chessBoard(whitePlayer: whitePlayer,
                                          blackPlayer: blackPlayer)
        
        scene = GameScene(rows: 8, cols: 8, size: view.bounds.size)
        scene.scaleMode = .aspectFill
        
        view.presentScene(scene)
        
        for space in board.filledSpaces() {
            let pieceElement = GameSceneElement(row: space.row, col: space.col)
            
            guard let chessPiece = board.element(at: space) else { assertionFailure(); return }
            let imageName = "\(chessPiece.player)\(chessPiece.type)"
            
            scene.addElement(pieceElement, imageName: imageName, animated: false)
        }
    }
    
}
