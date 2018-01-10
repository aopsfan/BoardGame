import Foundation
import SpriteKit

// Model //

// GameplayDelegate -- Callback protocol for visible game changes. At this
//  level in the program's hierarchy, these callbacks should only be fired
//  once per tile (no "stepwise" changes). This allows the conformer to
//  directly correlate a call like gameDidMove(from:to:hidden:) to a
//  single view update.
//
// Conformers: BoardGameViewController

protocol GameplayDelegate {
    func gameDidPlace(tile: Int, at space: Space)
    func gameDidMove(from startSpace: Space, to endSpace: Space)
    func gameDidMerge(_ topSpace: Space, and bottomSpace: Space, to endSpace: Space, newValue: Int)
    func gameScoreDidChange(newScore: Int)
}



// View //

// BoardGameSpriteAction -- Protocol describing an animated action on a tile's
//  sprite. Conformers are basically wrappers for SKSpriteNode.
//
// Conformers:

protocol BoardGameSpriteAction {
    var sprite: SKSpriteNode! { get set }
    var duration: TimeInterval! { get set }
    
    func run(completion: @escaping () -> ())
}

