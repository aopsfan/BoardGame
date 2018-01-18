import Foundation

enum PlayerDescriptor {
    case red, blue
}

class Player {
    let descriptor: PlayerDescriptor
    
    init(descriptor: PlayerDescriptor) {
        self.descriptor = descriptor
    }
    
    func piece() -> BoardPiece {
        return BoardPiece(player: self)
    }
}
