import Foundation
import SpriteKit

class GameSceneAppearance {
    let boardDimensions: (rows: Int, cols: Int)
    
    var elementSize = CGSize(width: 50, height: 50)
    var elementSpacing = CGFloat(10)
    
    var rows: Int { return boardDimensions.rows }
    var cols: Int { return boardDimensions.cols }
    
    lazy var elementBounds: CGSize = {
        return CGSize(width: elementSize.width + elementSpacing,
                      height: elementSize.height + elementSpacing)
    }()
    
    lazy var boardBounds: CGSize = {
        return CGSize(width: elementBounds.width * CGFloat(cols),
                      height: elementBounds.height * CGFloat(rows))
    }()
    
    lazy var boardPosition: CGPoint = {
        let xOffset = (elementSize.width * CGFloat(cols) / 2.0) + (elementSpacing * (CGFloat(cols) - 1.0) / 2.0)
        let yOffset = (elementSize.height * CGFloat(rows) / 2.0) + (elementSpacing * (CGFloat(rows) - 1.0) / 2.0)
        return CGPoint(x: -xOffset, y: -yOffset)
    }()
    
    init(rows: Int, cols: Int) {
        boardDimensions = (rows, cols)
    }
    
    //
    
    func location(ofPoint point: CGPoint) -> Space? {
        guard contains(point: point) else { return nil }
        
        let row = Int(point.y / elementBounds.height) + 1
        let col = Int(point.x / elementBounds.width) + 1
        
        return Space(row: row, col: col)
    }
    
    func position(ofSpace space: Space) -> CGPoint {
        return CGPoint(
            x: elementSize.width * CGFloat(space.col) + elementSpacing * CGFloat(space.col - 1) - elementSize.width / 2,
            y: elementSize.height * CGFloat(space.row) + elementSpacing * CGFloat(space.row - 1) - elementSize.height / 2)
    }
    
    //
    
    private func contains(point: CGPoint) -> Bool {
        return point.x >= 0 && point.y >= 0 && point.x <= boardBounds.width && point.y <= boardBounds.height
    }
}
