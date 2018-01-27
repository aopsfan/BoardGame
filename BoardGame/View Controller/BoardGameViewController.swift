import UIKit
import SpriteKit

// BoardGameViewController -- Abstract VC

class BoardGameViewController: UIViewController, GameplayDelegate {
    
    // GameplayDelegate baggage (because Swift 4 doesn't support
    //  optional protocol methods without using @objc
    
    func gameWillStartMoves() {}
    func gameDidStartTurn(player: Player?) {}
    func gameDidEndMoves() {}
    func gameDidEndTurn(player: Player?) {}
    
    func gameDidPlace(element: Any, at space: Space) {
        assertionFailure() // Did you forget something?
    }
    
    func gameDidMove(elementAt startSpace: Space, to endSpace: Space) {
        assertionFailure() // Did you forget something?
    }

    
    
    // UIViewController
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard let view = self.view as! SKView? else { assertionFailure(); return }
        view.isMultipleTouchEnabled = false
        view.ignoresSiblingOrder = true
        setUpGame(view: view)
    }
    
    override var shouldAutorotate: Bool {
        return true
    }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        if UIDevice.current.userInterfaceIdiom == .phone {
            return .allButUpsideDown
        } else {
            return .all
        }
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    
    
    // BoardGameViewController
    //  - scene
    //  > setUpGame(view:)
    
    var scene: GameScene!
    
    // setUpGame(view:) -- Subclasses should override to initialize
    //  the game and scene properties
    
    func setUpGame(view: SKView) {}
    
}
