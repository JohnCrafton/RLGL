//
//  Direction.swift
//  RLGL
//
//  Created by Overlord on 8/1/17.
//  Copyright © 2017 ComingUpSevens, LLC. All rights reserved.
//

enum Direction: Int, CustomStringConvertible {
    
    case left = 0, right, up, down
    var spriteName: String {
        switch self {
            case .up:
                return "Up"
            case .down:
                return "Down"
            case .left:
                return "Left"
            case .right:
                return "Right"
        }
    }
    
    var description: String {
        return self.spriteName
    }
}
