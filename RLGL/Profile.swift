//
//  Profile.swift
//  RLGL
//
//  Created by Overlord on 8/5/17.
//  Copyright © 2017 ComingUpSevens, LLC. All rights reserved.
//

import Disk
import SpriteKit
import Foundation

struct EncodedProfile : Codable {

    static var purchased:       Bool = false
    static var reviewPrompted:  Bool = false
    
    var games:              Int = 0
    var difficulty:         Int = 2
    
    var highscore:          [Double] = []
    var hits:               [Double] = []
    var misses:             [Double] = []
    var highestLevel:       [Double] = []
    
    init(_ difficulty: Int = 2) {
        
        self.difficulty     = difficulty
        self.hits           = [0.0, 0.0, Double(self.difficulty)]
        self.misses         = [0.0, 0.0, Double(self.difficulty)]
        self.highestLevel   = [0.0, 0.0, Double(self.difficulty)]
        self.highscore      = [0.0, 0.0, 0.0, Double(self.difficulty)]
    }
    
    init(_ profile: Profile) {

        EncodedProfile.purchased        = Profile.purchased
        EncodedProfile.reviewPrompted   = Profile.reviewPrompted

        self.games          = profile.games
        self.difficulty     = profile.difficulty.rawValue
        self.hits           = profile.hits.encoded
        self.misses         = profile.misses.encoded
        self.highscore      = profile.highscore.encoded
        self.highestLevel   = profile.highestLevel.encoded
    }
    
    func save() {
        
        do {
            try Disk.save(self, to: .applicationSupport, as: "p\(self.difficulty).json")
        } catch {
            Log.Message("\(Difficulty(rawValue: difficulty)?.description ?? "BROKEN") profile save fuckery", .Error)
        }
    }
    
    static func Load(difficulty: Difficulty) -> EncodedProfile? { return EncodedProfile.Load(difficulty.rawValue) }
    
    static func Load(_ difficulty: Int) -> EncodedProfile? {
        
        let profile = try? Disk.retrieve("p\(difficulty).json", from: .applicationSupport, as: EncodedProfile.self)
        return (profile == nil) ? EncodedProfile(difficulty) : profile
    }
}

class Profile {

    static var purchased:          Bool = false
    static var reviewPrompted:     Bool = false
    
    var games:              Int = 0
    var difficulty:         Difficulty = .Standard
    
    var hits:               Hits = Hits()
    var misses:             Misses = Misses()
    var highscore:          Highscore = Highscore()
    var highestLevel:       HighestLevel = HighestLevel()
    
    var encoded: EncodedProfile { get { return EncodedProfile(self) } }
    
    convenience init(_ difficulty: Int = 2) { self.init(Difficulty(rawValue: difficulty)!) }

    init(_ difficulty: Difficulty = .Standard) {

        self.difficulty = difficulty
        
        self.hits = Hits(difficulty)
        self.misses = Misses(difficulty)
        self.highscore = Highscore(difficulty)
        self.highestLevel = HighestLevel(difficulty)
    }
    
    init(profile: EncodedProfile) {

        Profile.purchased       = EncodedProfile.purchased
        Profile.reviewPrompted  = EncodedProfile.reviewPrompted

        self.games          = profile.games
        self.difficulty     = Difficulty(rawValue: profile.difficulty)!
        self.hits           = Hits(encoded: profile.hits)
        self.misses         = Misses(encoded: profile.misses)
        self.highscore      = Highscore(encoded: profile.highscore)
        self.highestLevel   = HighestLevel(encoded: profile.highestLevel)
    }
    
    func gamesUp() { self.games += 1 }
    func save() { self.encoded.save() }
    
    internal static func madePurchase()      { Profile.purchased = true }
    internal static func promptedForReview() { Profile.reviewPrompted = true }
}

class Profiles {
    
    static var casual:      Profile = Profile(profile: EncodedProfile.Load(difficulty: .Casual)!)
    static var easy:        Profile = Profile(profile: EncodedProfile.Load(difficulty: .Easy)!)
    static var standard:    Profile = Profile(profile: EncodedProfile.Load(difficulty: .Standard)!)
    static var hard:        Profile = Profile(profile: EncodedProfile.Load(difficulty: .Hard)!)
    static var unfair:      Profile = Profile(profile: EncodedProfile.Load(difficulty: .Unfair)!)
    
    static var totalGames:  Int {
        get {
            
            var output = 0
            
            output += Profiles.casual.games
            output += Profiles.easy.games
            output += Profiles.standard.games
            output += Profiles.hard.games
            output += Profiles.unfair.games
            
            return output
        }
    }
    
    static func select(_ difficulty: Difficulty) -> Profile {
        
        switch difficulty {
            case .Casual:
                return Profiles.casual
            case .Easy:
                return Profiles.easy
            case .Standard:
                return Profiles.standard
            case .Hard:
                return Profiles.hard
            case .Unfair:
                return Profiles.unfair
        }
    }
}
