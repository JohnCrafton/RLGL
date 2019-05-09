//
//  Achievement.swift
//  RLGL
//
//  Created by Overlord on 8/7/17.
//  Copyright © 2017 ComingUpSevens, LLC. All rights reserved.
//

import GameKit
import SpriteKit
import Foundation

struct AchievementTrigger {
    
    let required: Int
    internal var running: Int = 0

    var progress: Int { get { return self.running } }
    
    init(required: Int) { self.required = required }
    
    mutating func update() { self.running += 1 }

    static let One: AchievementTrigger = AchievementTrigger(required: 1)
    static let Two: AchievementTrigger = AchievementTrigger(required: 2)
    static let Three: AchievementTrigger = AchievementTrigger(required: 3)
    static let Five: AchievementTrigger = AchievementTrigger(required: 5)
    static let Ten: AchievementTrigger = AchievementTrigger(required: 10)
    static let OneHundred: AchievementTrigger = AchievementTrigger(required: 100)
}

struct Achievement {
    
    let name: String
    let trigger: AchievementTrigger
    
    static var FirstNewColor: Achievement {
        get {
            let name = "first_new_color"
            return Achievement(name: name, trigger: AchievementTrigger.One)
        }
    }
    
    static var OnYourWay: Achievement {
        get {
            let name = "on_your_way"
            return Achievement(name: name, trigger: AchievementTrigger.Two)
        }
    }
}

enum AchievementIcon: String {
    
    case FirstRedGreen =    "On Your Way!"
    case FirstNewColor =    "Building Rainbows"
    case RainbowRoad =      "Rainbow Road"
}
