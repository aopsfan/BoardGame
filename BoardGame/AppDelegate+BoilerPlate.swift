import UIKit
import SpriteKit

// AppDelegate

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        return true
    }
}



// BoardGameViewController -- UIViewController boiler-plate code

extension BoardGameViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard let view = self.view as! SKView? else { assertionFailure(); return }
        view.isMultipleTouchEnabled = false
        
        // In case you were wondering where setUpGame is called, it's right
        //  here
        
        setUpGame(view: view, rows: 4, cols: 4)
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
}
