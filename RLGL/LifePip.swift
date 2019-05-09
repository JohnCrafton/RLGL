//
//  LifePip.swift
//  RLGL
//
//  Created by Overlord on 8/26/17.
//  Copyright © 2017 ComingUpSevens, LLC. All rights reserved.
//

import SpriteKit
import Foundation

private var DEFAULT_PIP_POSITION_Y = 1750
private var DEFAULT_PIP_SPACING:CGFloat = 6.0
private var DEFAULT_PIP_RADIUS: CGFloat = 10.0

class Pip: SKShapeNode {

    static var Default: Pip { return Pip(DEFAULT_PIP_RADIUS) }
    
    init(_ radius: CGFloat) {
        super.init()

        let diameter = radius * 2
        path = CGPath(ellipseIn: CGRect(origin: CGPoint.zero, size: CGSize(width: diameter, height: diameter)),
                      transform: nil)
        
        lineWidth = 3
        zPosition = 99999
        fillColor = .mutedRed
        strokeColor = .almostBlack
    }
    
    required init?(coder aDecoder: NSCoder) { fatalError("init(coder:) has not been implemented") }
}

class LifePips {
    
    private var _container: SKShapeNode! = nil
    var container: SKShapeNode {
        get {
            
            if _container == nil {
                
                _container = SKShapeNode(rect: CGRect(x: 0, y: DEFAULT_PIP_POSITION_Y,
                                                      width: 1080, height: 15))
                
                _container.lineWidth = 3
                _container.fillColor = .clear
                _container.strokeColor = .clear

//                let midline = SKShapeNode(rect: CGRect(x: 540, y: 0, width: 3, height: 1920))
//                
//                midline.lineWidth = 0
//                midline.fillColor = .cyan
//                
//                _container.addChild(midline)
            }
            
            return _container
        }
    }
    
    var pips: [Pip] = []

    init() {

        let center = 540 - DEFAULT_PIP_RADIUS
        let value = (DEFAULT_PIP_RADIUS + DEFAULT_PIP_SPACING)

        if Konami.GO {
        
            for index in (1...30) {
                
                let pip = Pip.Default

                let xVal = (index % 2 == 0)
                    ? (center - (value * (CGFloat(index) - 1)))
                    : (center + (value * CGFloat(index)))

                print("Pip[\(index)].xVal: \(xVal)")
                
                pip.position = CGPoint(x: xVal, y: CGFloat(DEFAULT_PIP_POSITION_Y))

                container.addChild(pip)
                pips.append(pip)
            }

        } else {
            
            let left = Pip.Default
            let right = Pip.Default
            let middle = Pip.Default
            
            middle.position = CGPoint(x: center, y: CGFloat(DEFAULT_PIP_POSITION_Y))
            
            left.position = CGPoint(x: (center + (value * -2)), y: CGFloat(DEFAULT_PIP_POSITION_Y))
            right.position = CGPoint(x: (center + (value * 2)), y: CGFloat(DEFAULT_PIP_POSITION_Y))
            
            container.addChild(middle)
            container.addChild(left)
            container.addChild(right)
            
            pips.append(middle)
            pips.append(left)
            pips.append(right)
        }
        
        print("LifePips():  done initializing LifePips.")
    }
    
    func removePip() {

        print("pip popping")
        let pipToPop = pips.popLast()
        pipToPop?.removeFromParent()
    }
}
