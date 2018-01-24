//
//  BoardGameTests.swift
//  BoardGameTests
//
//  Created by Bruce Ricketts on 12/30/17.
//  Copyright © 2017 Bruce Ricketts. All rights reserved.
//

import XCTest
@testable import BoardGame

class SpatialMapTests: XCTestCase {
    var map: SpatialMap!
    
    override func setUp() {
        map = SpatialMap()
    }
    
    func testSimpleMerge() {
        let space11 = Space(row: 1, col: 1)
        let space21 = Space(row: 2, col: 1)
        
        map.record(mergeFrom: space21, to: space11)
        
        var iterations = 0
        var startSpaces = [Space]()
        var endSpace: Space?
        
        map.iterate { (starts, end) in
            iterations += 1
            
            startSpaces = starts
            endSpace = end
        }
        
        XCTAssertEqual(iterations, 1)
        XCTAssertEqual(startSpaces.count, 2)
        XCTAssert(startSpaces.contains(space21))
        XCTAssert(startSpaces.contains(space11))
        XCTAssert(endSpace == space11)
    }
    
    func testSpaceyMerge() {
        let space11 = Space(row: 1, col: 1)
        let space21 = Space(row: 2, col: 1)
        let space31 = Space(row: 3, col: 1)
        let space41 = Space(row: 4, col: 1)
        
        map.record(moveFrom: space41, to: space31)
        map.record(moveFrom: space31, to: space21)
        map.record(mergeFrom: space21, to: space11)
        
        var iterations = 0
        var startSpaces = [Space]()
        var endSpace: Space?
        
        map.iterate { (starts, end) in
            iterations += 1
            
            startSpaces = starts
            endSpace = end
        }
        
        XCTAssertEqual(iterations, 1)
        XCTAssertEqual(startSpaces.count, 2)
        XCTAssert(startSpaces.contains(space41))
        XCTAssert(startSpaces.contains(space11))
        XCTAssert(endSpace == space11)
    }
    
    func testCascadingMerge() {
        let space11 = Space(row: 1, col: 1)
        let space21 = Space(row: 2, col: 1)
        let space31 = Space(row: 3, col: 1)

        map.record(moveFrom: space21, to: space11)
        map.record(moveFrom: space31, to: space21)
        map.record(mergeFrom: space21, to: space11)
        
        var iterations = 0
        var startSpaces = [Space]()
        var endSpace: Space?
        
        map.iterate { (starts, end) in
            iterations += 1
            
            startSpaces = starts
            endSpace = end
        }
        
        XCTAssertEqual(iterations, 1)
        XCTAssertEqual(startSpaces.count, 2)
        XCTAssert(startSpaces.contains(space21))
        XCTAssert(startSpaces.contains(space31))
        XCTAssert(endSpace == space11)
    }
    
    func testCompoundMerge() {
        let space11 = Space(row: 1, col: 1)
        let space12 = Space(row: 1, col: 2)
        let space13 = Space(row: 1, col: 3)
        let space14 = Space(row: 1, col: 4)

        map.record(mergeFrom: space12, to: space11)
        map.record(moveFrom: space13, to: space12)
        map.record(moveFrom: space14, to: space13)
        map.record(mergeFrom: space13, to: space12)
        
        var iterations = 0
        var merge11StartSpaces = [Space]()
        var merge11EndSpace: Space?
        var merge12StartSpaces = [Space]()
        var merge12EndSpace: Space?
        
        map.iterate { (starts, end) in
            iterations += 1
            
            if end == space11 {
                merge11StartSpaces = starts
                merge11EndSpace = end
            } else if end == space12 {
                merge12StartSpaces = starts
                merge12EndSpace = end
            }
        }
        
        XCTAssertEqual(iterations, 2)
        
        XCTAssertEqual(merge11StartSpaces.count, 2)
        XCTAssert(merge11StartSpaces.contains(space11))
        XCTAssert(merge11StartSpaces.contains(space12))
        XCTAssert(merge11EndSpace == space11)
        
        XCTAssertEqual(merge12StartSpaces.count, 2)
        XCTAssert(merge12StartSpaces.contains(space13))
        XCTAssert(merge12StartSpaces.contains(space14))
        XCTAssert(merge12EndSpace == space12)
    }
}
