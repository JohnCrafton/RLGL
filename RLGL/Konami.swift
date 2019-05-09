//
//  Konami.swift
//  RLGL
//
//  Created by Overlord on 8/16/17.
//  Copyright © 2017 ComingUpSevens, LLC. All rights reserved.
//

// THE CODE... up up down down left right left right
let KONAMI = [
    Direction.up, Direction.up,
    Direction.down, Direction.down,
    Direction.left, Direction.right,
    Direction.left, Direction.right
]

final class Konami {
    
    static var A: Bool = false
    static var B: Bool = false

    private static var _go: Bool = false
    private static var _activate: Bool = false
    private static var _swipes: [Direction] = []

    static var GO: Bool { get { return (Yes && B && A) } }
    
    static var Yes: Bool {
        get { return _swipes == KONAMI }
    }
    
    static func Swipe(_ direction: Direction) {
        
        // They know the code...
        if (GO) { return }
        
        _swipes.append(direction)
        
        for n in (0...(_swipes.count - 1)) {
            if n > KONAMI.endIndex {
                _swipes = []
                return
            }
            if _swipes[n] != KONAMI[n] {
                _swipes = []
                return
            }
        }
    }
}
