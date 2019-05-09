//
//  LineTimer.swift
//  RLGL
//
//  Created by Overlord on 8/24/17.
//  Copyright © 2017 ComingUpSevens, LLC. All rights reserved.
//

import SpriteKit
import Foundation

class LineTimer {

    private var _sprite: SKSpriteNode! = nil
    private var _container: SKShapeNode! = nil
    
    private var _level: Int = 1
    private var _steps: Int = 60
    private var _countdown: Int = 5
    private var _interval: TimeInterval = TimeInterval(5)
    
    private var sprite: SKSpriteNode {
        get {
            
            if _sprite == nil {
                _sprite = SKSpriteNode(texture: SKTexture(image: #imageLiteral(resourceName: "LineTimerBlock")))
                
                _sprite.color = .gold
                _sprite.zPosition = 99999
                _sprite.colorBlendFactor = 1.0
                _sprite.position = CGPoint(x: 540, y: 1724)
                _sprite.scale(to: CGSize(width: 1080, height: 24))
            }
            
            return _sprite
        }
    }
    
    var shape: SKShapeNode {
        get {
            
            if _container == nil {
                
                _container = SKShapeNode(rect: CGRect(x: 0, y: 1710, width: 1080, height: 28))
                
                _container.zPosition = 99998
                _container.fillColor = .black
                _container.strokeColor = .clear
                
                _container.addChild(sprite)
            }
            
            return _container
        }
    }
    
    func removeFromParent() { self.shape.removeFromParent() }
    
    func update(_ level: Int = 1, completion: @escaping () -> Void) {
        
        updateLineTimer(steps: _steps, duration: _interval, completion: completion)
    }
    
    private func updateLineTimer(steps: Int, duration: TimeInterval, completion: @escaping () -> Void) {
        
        let newDuration = duration - (Double(_level) / 10.0)
        
        var percent = CGFloat(1.0)
        
        let increment = 1 / CGFloat(steps)
        let interval = newDuration / TimeInterval(steps)
        
        let animate = SKAction.run {
            
            percent -= increment
            self.sprite.scale(to: CGSize(width: 1080 * percent, height: 24))
            
            if (percent < 0.40) {
                self.sprite.color = .magenta
                self.sprite.colorBlendFactor = 1.0
            }
        }
        
        let wait = SKAction.wait(forDuration: interval)
        let action = SKAction.sequence([wait, animate])
        
        let completed = SKAction.run({
            self.sprite.color = .black
            completion()
        })
        
        let countdown = SKAction.repeat(action, count: steps - 1)
        let sequence = SKAction.sequence([countdown, SKAction.wait(forDuration: interval), completed])
        
        sprite.run(sequence, withKey: "line-timer-update")
    }
}
