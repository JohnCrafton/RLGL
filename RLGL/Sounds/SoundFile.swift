//
//  SoundFile.swift
//  RLGL
//
//  Created by Overlord on 8/7/17.
//  Copyright © 2017 ComingUpSevens, LLC. All rights reserved.
//

import Foundation

struct SoundFile {
    let name: String
    let filename: String
}

extension SoundFile {
    
    var toJSONDict: [String:String] {
        return ["name": name, "filename": filename]
    }
}

enum Music: Int {
    
    case ArcadeFunk = 0, BellBottoms, Disco, DiscoTwo, Funk, Groove, GrooveTwo

    static var random: Music {
        return Music(rawValue: Int(arc4random_uniform(6)))!
    }
    
    var soundFile: SoundFile {
        return AvailableMusic[self.rawValue]
    }
}

enum SoundEffect: Int {
    
    case Bad = 0, Good, Great, LevelUp, Button, ButtonTwo, GradiusCoin
    
    var soundFile: SoundFile {
        return AvailableSoundEffects[self.rawValue]
    }
}

let AvailableMusic = [
    SoundFile(name: "Arcade Funk", filename: "arcade_funk.mp3"),
    SoundFile(name: "Bell Bottoms", filename: "bell_bottoms.wav"),
    SoundFile(name: "Disco One", filename: "disco.wav"),
    SoundFile(name: "Disco Two", filename: "disco_2.wav"),
    SoundFile(name: "Funk", filename: "funk.wav"),
    SoundFile(name: "Groove One", filename: "groove_1.wav"),
    SoundFile(name: "Groove Two", filename: "groove_2.wav")
]

let AvailableSoundEffects = [
    SoundFile(name: "Bad", filename: "bad.wav"),
    SoundFile(name: "Good", filename: "good.wav"),
    SoundFile(name: "Great", filename: "great.wav"),
    SoundFile(name: "Level Up", filename: "level_up.wav"),
    SoundFile(name: "Button", filename: "button_1.wav"),
    SoundFile(name: "Button Two", filename: "button_2.wav"),
    SoundFile(name: "Graduis Coin", filename: "gradius-115-coin.mp3"),
]
