//
//  WheelTimer.swift
//  RLGL
//
//  Created by Overlord on 8/28/17.
//  Copyright © 2017 ComingUpSevens, LLC. All rights reserved.
//

import SpriteKit
import Foundation

class WheelTimer {
    
    private var _level: Int = 1
    private var _steps: Int = 60
    private var _interval: TimeInterval = TimeInterval(3)
    
    private var _shape: SKShapeNode! = nil
    var shape: SKShapeNode {
        get {
            
            if _shape == nil {
                
                _shape = SKShapeNode(circleOfRadius: 40)
                
                _shape.lineWidth = 6
                _shape.strokeColor = .black
                _shape.fillColor = .mutedBlue
                _shape.zRotation = CGFloat.pi / 2
            }
            
            return _shape
        }
    }

    func removeFromParent() { self.shape.removeFromParent() }

    func setDifficulty(_ difficulty: Difficulty = .Standard) { _interval = TimeInterval(difficulty.value) }
    
    func update(_ level: Int = 1, completion: @escaping () -> Void) {
        
        if _interval > 1.5 { _interval = (level % 1 == 0 || level % 10 == 0) ? _interval * 0.75 : _interval }
        updateLineTimer(level: level, steps: _steps, duration: _interval, completion: completion)
    }
    
    private func updateLineTimer(level: Int, steps: Int, duration: TimeInterval, completion: @escaping () -> Void) {
        
        guard let path = self.shape.path else {
            return
        }
        
        let newDuration = duration - (Double(level) / 10.0)
        
        let radius = path.boundingBox.width / 2
        let interval = newDuration/TimeInterval(steps)
        let increment = 1 / CGFloat(steps)
        var percent = CGFloat(1.0)
        
        let animate = SKAction.run {
            percent -= increment
            self.shape.path = self.pacman(radius: radius, percent: percent)
            
            if (percent < 0.40) {
                self.shape.fillColor = UIColor.magenta
            }
        }
        
        let wait = SKAction.wait(forDuration: interval)
        let action = SKAction.sequence([wait, animate])
        
        let completed = SKAction.run({
            self.shape.path = nil
            completion()
        })
        
        let countdown = SKAction.repeat(action, count: steps - 1)
        let sequence = SKAction.sequence([countdown, SKAction.wait(forDuration: interval), completed])
        
        shape.run(sequence, withKey: "wheel-timer-update")
    }
    
    private func pacman(radius: CGFloat, percent: CGFloat) -> CGPath {
        
        let start: CGFloat = 0
        let end = CGFloat.pi * 2 * percent
        let center = CGPoint.zero
        let bezierPath = UIBezierPath()
        
        bezierPath.move(to: center)
        bezierPath.addArc(withCenter: center, radius: radius, startAngle: start, endAngle: end, clockwise: true)
        bezierPath.addLine(to: center)
        
        return bezierPath.cgPath
    }
}
