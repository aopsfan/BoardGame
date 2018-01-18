import Foundation

struct BoardPiece {
    let rawValue: Int
    let player: Player?
    
    var descriptor: PlayerDescriptor? {
        return player?.descriptor
    }
    
    init(_ rawValue: Int) {
        self.rawValue = rawValue
        self.player = nil
    }
    
    init(player: Player?) {
        self.rawValue = 0
        self.player = player
    }
}
