//
//  Streak.swift
//  RLGL
//
//  Created by Overlord on 8/7/17.
//  Copyright © 2017 ComingUpSevens, LLC. All rights reserved.
//

import SpriteKit
import Foundation

class Hits : Streak { override var name: String { get { return "Hits" } } }
class Misses : Streak { override var name: String { get { return "Misses" } } }
class HighestLevel : Streak { override var name: String { get { return "Highest Level" } } }

class Streak {

    private var _streak:        Int = 0
    private var _running:       Int = 0

    private var _dateSet:       Double = 0.0
    internal var _difficulty:   Difficulty = .Standard
    
    var streak:     Int { get { return _streak } }
    var name:       String { get { return "Streak" } }
    var difficulty: Difficulty { get { return _difficulty } }

    var dateSet: String {
        get {
            
            if _dateSet == 0.0 {
                return "Not yet set"
            }
            
            return formattedDate(TimeInterval(_dateSet))
        }
    }
    
    var encoded: [Double] {
        
        var output: [Double] = []
        
        output.append(self._dateSet)
        output.append(Double(self._streak))
        output.append(Double(self._difficulty.rawValue))
        
        return output
    }

    init() { }
    
    init(_ difficulty: Difficulty) {

        self._streak        = 0
        self._difficulty    = difficulty
    }
    
    convenience init(encoded: [Double]) {
        
        var initValue = (encoded == []) ? [0.0, 0.0, 0.0] : encoded
        
        self.init(Difficulty(rawValue: Int(initValue[2]))!)
        
        self._dateSet = initValue[0]
        self._streak = Int(initValue[1])
    }
    
    func up()    { _running += 1 }
    func blown() { update(); _running = 0 }
    
    func update() {

        _streak         = (_running > streak)   ? _running : streak
        _dateSet        = (_running > streak)   ? Date().timeIntervalSince1970 : _dateSet
    }
    
    func update(_ newStreak: Int) {
        
        if newStreak > _streak {

            _running = newStreak
            self.update()
        }
    }
    
    var labels: SKShapeNode {
        get {
            
            let container: SKShapeNode = SKShapeNode(rectOf: CGSize(width: DEFAULT_SIZE_WIDTH, height: 75))
            
            container.lineWidth = 0
            
            let labelStreak: SKLabelNode        = SKLabelNode.Standard
            let labelStreakIcon: SKLabelNode    = SKLabelNode.Standard
            let labelDateSet: SKLabelNode       = SKLabelNode.Footer(text: dateSet)
            
            labelStreak.text            = "\(name):  \(streak)"
            labelStreakIcon.text        = "\(difficulty.description)"
            
            labelStreak.fontSize        = labelStreak.fontSize * 1.25
            labelDateSet.fontSize       = labelDateSet.fontSize * 1.75
            
            labelStreak.position        = container.position
            labelDateSet.position       = container.position
            labelStreakIcon.position    = container.position
            
            labelStreakIcon.horizontalAlignmentMode = .right
            
            labelStreak.position.y  += 25
            labelDateSet.position.y -= 40
            
            container.addChild(labelStreak)
            container.addChild(labelDateSet)
            container.addChild(labelStreakIcon)
            
            return container
        }
    }
}
