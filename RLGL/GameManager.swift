//
//  GameManager.swift
//  RLGL
//
//  Created by Overlord on 10/30/17.
//  Copyright © 2017 ComingUpSevens, LLC. All rights reserved.
//

import Foundation

class GameManager {

    private static var _shared: GameManager!
    public static var shared:   GameManager {
        get {
            if _shared == nil { GameManager.standard() } 
            return _shared
        }
    }
    
    var level:          Int = 1
    var difficulty:     Difficulty!

    var purchased:      Bool { get { return Profile.purchased } }
    
    var profile:        Profile!
    var score:          Score = Score()
    var hits:           Hits = Hits()
    var misses:         Misses = Misses()
    var highestLevel:   HighestLevel = HighestLevel()

    static func casual()    { GameManager._shared = GameManager(.Casual) }
    static func easy()      { GameManager._shared = GameManager(.Easy) }
    static func standard()  { GameManager._shared = GameManager(.Standard) }
    static func hard()      { GameManager._shared = GameManager(.Hard) }
    static func unfair()    { GameManager._shared = GameManager(.Unfair) }
    
    static func select(_ difficulty: Difficulty) {
        
        switch difficulty {
            case .Casual:
                GameManager.casual()
            case .Easy:
                GameManager.easy()
            case .Standard:
                GameManager.standard()
            case .Hard:
                GameManager.hard()
            case .Unfair:
                GameManager.unfair()
        }
    }
    
    init() { }
    convenience init(_ difficulty: Difficulty) {
        self.init()
        
        self.difficulty     = difficulty
        self.hits           = Hits(difficulty)
        self.misses         = Misses(difficulty)
        self.highestLevel   = HighestLevel(difficulty)
        self.profile        = Profiles.select(self.difficulty)
        
        GameManager._shared = self
    }
    
    func levelUp() { level += 1; highestLevel.up() }
    
    func hit(_ color: Color) {
        
        self.misses.blown()
        
        self.score.up()
        self.hits.up()
    }
    
    func miss(_ color: Color) {
        
        self.score.blown()
        self.hits.blown()
        
        self.misses.up()
    }
    
    func gameOver() {
        
        self.score.blown()
        
        self.hits.blown()
        self.misses.blown()
        self.highestLevel.blown()
        
        self.updateProfile()
    }
    
    func reset() {
        
        self.score          = Score()
        self.hits           = Hits(difficulty)
        self.misses         = Misses(difficulty)
        self.highestLevel   = HighestLevel(difficulty)
    }
    
    func updateProfile() {

        self.profile.hits.update(self.hits.streak)
        self.profile.misses.update(self.misses.streak)
        self.profile.highscore.update(self.score.total)
        self.profile.highestLevel.update(self.highestLevel.streak)
        
        self.profile.save()
    }
    
    func promptedForReview() {
        
        Profile.promptedForReview()
        self.profile.save()
    }
}
