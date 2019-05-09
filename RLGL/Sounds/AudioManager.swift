//
//  AudioManager.swift
//  RLGL
//
//  Created by Overlord on 8/5/17.
//  Copyright © 2017 ComingUpSevens, LLC. All rights reserved.
//

import AudioKit
import SpriteKit
import AVFoundation

open class AudioManager {

    static func Vibrate() {
//        AudioServicesPlaySystemSound(SystemSoundID(kSystemSoundID_Vibrate))
        AudioServicesPlaySystemSoundWithCompletion(SystemSoundID(kSystemSoundID_Vibrate), nil)
    }
    
    static var _audio: AudioManager! = nil
    static var audio: AudioManager {
        get {
            if _audio == nil {
                _audio = AudioManager()
            }
            
            return _audio
        }
    }
    
    static var Bad: SKAction {
        get {
            return SKAction.playSoundFileNamed(SoundEffect.Bad.soundFile.filename, waitForCompletion: false)
        }
    }
    
    static var Good: SKAction {
        get {
            return SKAction.playSoundFileNamed(SoundEffect.Good.soundFile.filename, waitForCompletion: false)
        }
    }
    
    static var Great: SKAction {
        get {
            return SKAction.playSoundFileNamed(SoundEffect.Great.soundFile.filename, waitForCompletion: false)
        }
    }
    
    static var Button: SKAction {
        get {
            return SKAction.playSoundFileNamed(SoundEffect.Button.soundFile.filename, waitForCompletion: false)
        }
    }
    
    static var ButtonTwo: SKAction {
        get {
            return SKAction.playSoundFileNamed(SoundEffect.ButtonTwo.soundFile.filename, waitForCompletion: false)
        }
    }
    
    static var LevelUp: SKAction {
        get {
            return SKAction.playSoundFileNamed(SoundEffect.LevelUp.soundFile.filename, waitForCompletion: false)
        }
    }
    
    static var Gradius: SKAction {
        get {
            return SKAction.playSoundFileNamed(SoundEffect.GradiusCoin.soundFile.filename, waitForCompletion: false)
        }
    }
    
    var player: AKAudioPlayer!
    var songFile = Bundle.main
    
    func play(file: String, type: String) -> AKAudioPlayer? {
        let song = try? AKAudioFile(readFileName: file, baseDir: .resources)

        //        songFile.path(forResource: file, ofType: type)
        player = try? AKAudioPlayer(file: song!) {
            print("Completion from AudioManager/AKAudioPlayer")
        }

        return player
    }
    
    static func randomMusic() {
        
        if AudioManager.audio.player.isPlaying { AudioManager.audio.player.stop() }
        
        let music = Music.random
        let musicfileType = (music == Music.ArcadeFunk) ? "mp3" : "wav"
        
        let player = AudioManager.audio.play(file: music.soundFile.filename, type: musicfileType)

        AudioKit.output = player
        AudioKit.start()
        player?.looping = true
        player?.play()
    }
    
//    func rePlay(file: String, type: String, curPlay: AKAudioPlayer) {
//        let song = songFile.path(forResource: file, ofType: type)
//        curPlay.stop()
//        curPlay.replaceFile(song!)
//        curPlay.play()
//    }
}
