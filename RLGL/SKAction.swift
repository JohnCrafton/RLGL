//
//  SKAction.swift
//  RLGL
//
//  Created by Overlord on 8/22/17.
//  Copyright © 2017 ComingUpSevens, LLC. All rights reserved.
//

/*
 Example usage:
 let theRainbow:[SKColor] = [.red,.orange,.yellow,.green,.cyan,.blue,.purple,.magenta]
 let rainbowSequenceAction = SKAction.multipleColorTransitionAction(colors: theRainbow, duration: 10)
 star.run(SKAction.repeatForever(rainbowSequenceAction))
*/

import SpriteKit
import Foundation

struct TempRGBA {
    var red:    CGFloat = 0.0
    var green:  CGFloat = 0.0
    var blue:   CGFloat = 0.0
    var alpha:  CGFloat = 0.0
}

extension SKAction {
    
    static func multipleColorTransitionAction(colors:[SKColor], duration:Double) -> SKAction {

        guard colors.count > 1 else { return SKAction.colorize(withColorBlendFactor: 1, duration: 0) }

        var colorActions:[SKAction] = []

        for i in 1..<colors.count {
            colorActions.append( colorTransitionAction(fromColor: colors[i-1] , toColor: colors[i], duration: duration/Double(colors.count)) )
        }

        colorActions.append(colorTransitionAction(fromColor: colors.last!, toColor: colors.first!, duration: duration/Double(colors.count)))

        return SKAction.sequence(colorActions)
    }
    
    static func colorTransitionAction(fromColor : SKColor, toColor : SKColor, duration : Double = 0.4) -> SKAction {

        func lerp(_ a : CGFloat, b : CGFloat, fraction : CGFloat) -> CGFloat { return (b-a) * fraction + a }

        var fci: TempRGBA = TempRGBA()
        var tci: TempRGBA = TempRGBA()
        
        fromColor.getRed(&fci.red, green: &fci.green, blue: &fci.blue, alpha: &fci.alpha)
        toColor.getRed(&tci.red, green: &tci.green, blue: &tci.blue, alpha: &tci.alpha)
        
        var frgba:[CGFloat] = [fci.red, fci.green, fci.blue, fci.alpha]
        var trgba:[CGFloat] = [tci.red, tci.green, tci.blue, tci.alpha]
        
        return SKAction.customAction(withDuration: duration, actionBlock: {
            (node : SKNode!, elapsedTime : CGFloat) -> Void in
                let fraction = CGFloat(elapsedTime / CGFloat(duration))
                let transColor = UIColor(red:   lerp(frgba[0], b: trgba[0], fraction: fraction),
                                         green: lerp(frgba[1], b: trgba[1], fraction: fraction),
                                         blue:  lerp(frgba[2], b: trgba[2], fraction: fraction),
                                         alpha: lerp(frgba[3], b: trgba[3], fraction: fraction))
            
                (node as! SKShapeNode).fillColor = transColor
            }
        )
    }
    
    static func multipleColorTransitionActionForLabel(colors:[SKColor], duration:Double) -> SKAction {
        
        guard colors.count > 1 else { return SKAction.colorize(withColorBlendFactor: 1, duration: 0) }
        
        var colorActions:[SKAction] = []
        
        for i in 1..<colors.count {
            colorActions.append( colorTransitionActionForLabel(fromColor: colors[i-1] , toColor: colors[i], duration: duration/Double(colors.count)) )
        }
        
        colorActions.append(colorTransitionActionForLabel(fromColor: colors.last!, toColor: colors.first!, duration: duration/Double(colors.count)))
        
        return SKAction.sequence(colorActions)
    }
    
    static func colorTransitionActionForLabel(fromColor : SKColor, toColor : SKColor, duration : Double = 0.4) -> SKAction {
        
        func lerp(_ a : CGFloat, b : CGFloat, fraction : CGFloat) -> CGFloat { return (b-a) * fraction + a }
        
        var fci: TempRGBA = TempRGBA()
        var tci: TempRGBA = TempRGBA()
        
        fromColor.getRed(&fci.red, green: &fci.green, blue: &fci.blue, alpha: &fci.alpha)
        toColor.getRed(&tci.red, green: &tci.green, blue: &tci.blue, alpha: &tci.alpha)
        
        var frgba:[CGFloat] = [fci.red, fci.green, fci.blue, fci.alpha]
        var trgba:[CGFloat] = [tci.red, tci.green, tci.blue, tci.alpha]

        return SKAction.customAction(withDuration: duration, actionBlock: {
            (node : SKNode!, elapsedTime : CGFloat) -> Void in
            let fraction = CGFloat(elapsedTime / CGFloat(duration))
            let transColor = UIColor(red:   lerp(frgba[0], b: trgba[0], fraction: fraction),
                                     green: lerp(frgba[1], b: trgba[1], fraction: fraction),
                                     blue:  lerp(frgba[2], b: trgba[2], fraction: fraction),
                                     alpha: lerp(frgba[3], b: trgba[3], fraction: fraction))
                (node as! SKLabelNode).fontColor = transColor
            }
        )
    }
}
