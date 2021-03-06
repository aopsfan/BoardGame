import Foundation
import SpriteKit

// Model //

// GameplayDelegate -- Callback protocol for visible game changes. At
//  this level in the program's hierarchy, these callbacks should
//  only be fired once per piece (no "stepwise" changes). This allows
//  the conformer to directly correlate a call like
//  gameDidMove(pieceAt:to:) to a single view update.

protocol GameplayDelegate {
    
    // Conformers:
    //  FIXME
    
    func gameWillStartMoves()
    func gameDidStartTurn(player: Player?)
    func gameDidEndMoves()
    func gameDidEndTurn(player: Player?)
    
    func gameDidPlace(element: Any, at space: Space)
    func gameDidMove(elementAt startSpace: Space, to endSpace: Space)
}

protocol ChessDelegate: GameplayDelegate {
    func gamePiece(at startSpace: Space, didCapturePieceAt endSpace: Space)
}

// _2048Delegate -- Subtype of GameplayDelegate

protocol _2048Delegate: GameplayDelegate {
    
    // Conformers:
    //  FIXME
    
    func gameDidMerge(_ topSpace: Space, and bottomSpace: Space,
                      to endSpace: Space, newValue: Int)
    func gameScoreDidChange(newScore: Int)
    
}

// ConnectFourDelegate -- Subtype of GameplayDelegate

protocol ConnectFourDelegate: GameplayDelegate {
    
    // Conformers:
    //  FIXME
    
    func gameDidEnd(winner: Player, winningSequence: [Space])
    
}

// ConnectFourInspectorDelegate

protocol ConnectFourInspectorDelegate {
    
    // Conformers:
    //  FIXME
    
    func inspector(_ inspector: ConnectFourInspector, indicatesWinner winner: Player, winningSequence: [Space])
    
}



// Scene //

// GameSceneSpriteAction -- Protocol describing an animated action on
//  a sprite

protocol GameSceneSpriteAction {
    
    // Conformers:
    //  FIXME
    
    var sprite: SKSpriteNode! { get set }
    var duration: TimeInterval! { get set }
    
    func run(completion: @escaping () -> ())
    
}
