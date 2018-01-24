import Foundation

// SpatialMap -- Aggregates changes in the state of the board

class SpatialMap {
    
    // SpatialMap
    //  - moves
    //  - mergeSpaces
    //
    //  > record(moveFrom:to:)
    //  > record(mergeFrom:to:)
    //  > iterate() {}
    
    var deltas = [SpaceDelta]()
    var mergeSpaces = [Space]()
    
    
    
    //////////
    
    
    
    // record(moveFrom:to:) -- Record a non-merging move
    
    func record(moveFrom startSpace: Space, to endSpace: Space) {
        // Lookup any partial deltas that end where we're starting
        // from
        
        let referenceDeltas = spaceDeltas(endSpace: startSpace)
        
        // Sanity check: we better only have one of these
        
        guard referenceDeltas.count < 2 else { return }
        
        if referenceDeltas.count == 1 {
            // If an existing delta was found, update it
            
            referenceDeltas[0].endSpace = endSpace
        } else {
            // If no delta was found, make a new one
            
            let newDelta = SpaceDelta(startSpace: startSpace, endSpace: endSpace)
            deltas.append(newDelta)
        }
    }
    
    // record(mergeFrom:to:) -- Record a merging move
    
    func record(mergeFrom startSpace: Space, to endSpace: Space) {
        // This is pretty easy. Just move like usual and mark the end space
        //  as one that has been merged to.
        
        record(moveFrom: startSpace, to: endSpace)
        mergeSpaces.append(endSpace)
    }
    
    // iterate() {} -- Step through the delta, supplying packaged data to the
    //  caller via the block
    
    func iterate(closure: (_ startSpaces: [Space], _ endSpace: Space) -> ()) {
        // Start by iterating over the end spaces, since the block is called
        //  only once per move/merge
        
        for endSpace in endSpaces() {
            // Get the start spaces that travelled to the end space. There will
            //  USUALLY be one space for a move and two for a merge.
            
            var startSpaces = self.startSpaces(forEndSpace: endSpace)
            
            // Here's the catch: if we merged over a tile without moving that
            //  tile, we won't have a partial delta for it. To compensate, we'll
            //  treat the end space as another start space.
            
            if mergeSpaces.contains(endSpace) && startSpaces.count == 1 {
                startSpaces.append(endSpace)
            }
            
            // Call the block
            
            closure(startSpaces, endSpace)
        }
    }
    
    
    
    //////////
    
    
    
    private func endSpaces() -> Set<Space> {
        // Map moves to their end spaces, and wrap the result in a set
        //  to remove duplicates
        
        return Set(deltas.map { $0.endSpace })
    }
    
    private func startSpaces(forEndSpace endSpace: Space) -> [Space] {
        // Select the deltas that end at the specified space, and return
        //  their start spaces
        
        let deltas = spaceDeltas(endSpace: endSpace)
        return deltas.map { $0.startSpace }
    }
    
    private func spaceDeltas(endSpace: Space) -> [SpaceDelta] {
        return deltas.filter { $0.endSpace == endSpace }
    }
}
