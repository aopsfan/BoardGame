import Foundation

// Game -- Abstract board game model

class Game {
    
    // Game
    //  = board
    //  > prepareForPlay()
    
    let board: Board
    
    init(rows: Int, cols: Int) {
        board = Board(rows, cols)
    }
    
    // prepareForPlay() -- Conduct any game setup not appropriate for
    //  an initializer
    
    func prepareForPlay() {}
}
