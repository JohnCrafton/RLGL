//
//  Color.swift
//  RLGL
//
//  Created by Overlord on 8/1/17.
//  Copyright © 2017 ComingUpSevens, LLC. All rights reserved.
//

import SpriteKit

let NumberOfColors: Int = 8

enum Color: Int, CustomStringConvertible {
    
    case red = 0, green, blue, yellow, orange, purple, black, white

    var spriteName: String {

        switch self {
            case .red:
                return "Red"
            case .green:
                return "Green"
            case .blue:
                return "Blue"
            case .yellow:
                return "Yellow"
            case .orange:
                return "Orange"
            case .purple:
                return "Purple"
            case .black:
                return "Black"
            case .white:
                return "White"
        }
    }
    
    var displayColor: UIColor {
        
        switch self {
            case .red:
                return UIColor.red
            case .green:
                return UIColor.green
            case .blue:
                return UIColor.blue
            case .yellow:
                return UIColor.brightYellow
            case .orange:
                return UIColor.brightOrange
            case .purple:
                return UIColor.purple
            case .black:
                return UIColor.black
            case .white:
                return UIColor.white
        }
    }
    
    var description: String { return self.spriteName }
    var isLightColor: Bool { return (displayColor == UIColor.white || displayColor == UIColor.yellow) }
    
    static func random() -> Color {
        
        return Color(rawValue:Int(arc4random_uniform(UInt32(NumberOfColors))))!
    }
    
    static func value(_ value: Int) -> Color { return Color(rawValue: value)! }
    
    var shape: SKShapeNode {
        
        let shape = SKShapeNode(circleOfRadius: 24)
        
        shape.lineWidth = 6
        shape.zPosition = 9999
        shape.fillColor = displayColor
        shape.strokeColor = UIColor.almostBlack
        
        return shape
    }
    
    var pulse: SKAction {
        
        let pulseUp = SKAction.scale(to: 2.0, duration: 0.75)
        let pulseDown = SKAction.scale(to: 1.0, duration: 0.75)
        let pulse = SKAction.sequence([pulseUp, pulseDown, pulseUp, pulseDown])
        
        return pulse
    }
}
