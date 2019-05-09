//
//  GameScene.swift
//  RLGL
//
//  Created by Overlord on 7/10/17.
//  Copyright © 2017 ComingUpSevens, LLC. All rights reserved.
//

import SpriteKit
import GameplayKit

import SpriteKit

import AVFoundation

// start at 500ms; tune with feedback
//let TickLengthLevelOne = TimeInterval(500)
//var audioPlayer: AVAudioPlayer?

class GameScene: SKScene {
 
//    let gameLayer = SKNode()
//    let shapeLayer = SKNode()
//    let LayerPosition = CGPoint(x: 6, y: -6)
    
//    let level = BGNode()
//    let audio = AudioManager.sharedInstance()
    
//    var tick:(() -> ())?
//    var tickLengthMillis = TickLengthLevelOne
//    var lastTick:Date?
    
//    let audioManager = AudioManager.sharedInstance()
//    var textureCache = Dictionary<String, SKTexture>()
    
    // TODO:  Sound file cache?
    // TODO:  Music file cache?
    
    override init(size: CGSize) {
        super.init(size: CGSize(width: 1080, height: 1920))

// MARK: Monkeying with crap.

//        let physicsField = CGRect(x: -2500, y: -1000, width: frame.width + 5000, height: frame.height + 2000)
//        self.physicsBody = SKPhysicsBody(edgeLoopFrom: physicsField)
//        self.physicsBody?.restitution = 0.3
        
//        var splines = [CGPoint(x: (frame.minX - 1000), y: -10000),
//                       CGPoint(x: (frame.maxX + 1000), y: -10000)]
//        
//        let dropzone = SKShapeNode(splinePoints: &splines, count: splines.count)
//        
//        dropzone.lineWidth = 0
//        dropzone.physicsBody = SKPhysicsBody(edgeChainFrom: dropzone.path!)
//        dropzone.physicsBody?.restitution = 0.3
//        dropzone.physicsBody?.isDynamic = false
//        
//        scene?.addChild(dropzone)
        
//        let directionsNode = SKShapeNode(rect: CGRect(x: 0, y: 0, width: frame.width, height: 32))
//        directionsNode.zPosition = 42
////        directionsNode.position = CGPoint(x: (scene?.frame.maxX ?? 0)!, y: (scene?.frame.maxY ?? 0)!)
//        directionsNode.position = CGPoint(x: 0, y: (frame.maxY - 30))
//        
//        //            scene?.addChild(directionsNode!)
//        //
//        //            let outline = SKShapeNode(rect: CGRect(x: 0, y: 0, width: (directionsNode?.frame.width)!, height: 32))
//        
//        directionsNode.lineWidth = 1
//        directionsNode.fillColor = SKColor.clear
//        directionsNode.strokeColor = UIColor.lightGray
//        
//        addChild(directionsNode)
//        
////        level.setup(size: size)
////        level.zPosition = 0
////        addChild(level)
//        
//        let testCard = Card.Random()
////        testCard.sprite?.position = CGPoint(x: frame.minX + 10, y: frame.minY + 10)
//        
//        addChild(testCard.sprite!)
//        
//        let xVal = frame.midX
//        let dot = testCard.color.renderDot()
//        dot.zPosition = 125
//        dot.position = CGPoint(x: (testCard.direction == Direction.left) ? xVal - 30 : xVal + 30, y: frame.maxY - 25)
////        dot.position = CGPoint(x: 0, y: 0)
//        directionsNode.addChild(dot)
//
//        let redCard = Card.Red(frame: frame)
//        addChild(redCard.shape)
//        
//        let greenCard = Card.Green(frame: frame)
//        addChild(greenCard.shape)
//        
//        let redcircle = redCard.makeColorCircle(x: frame.midX - 20, frame: frame)
//        addChild(redcircle)
//        
//        let greencircle = greenCard.makeColorCircle(x: frame.midX + 20, frame: frame)
//        addChild(greencircle)
//        
//        let grow = SKAction.scale(by: 1, duration: 0.20)
//        let shrink = SKAction.scale(by: -1, duration: 0.20)
//        
//        let pulsate = SKAction.sequence([grow, shrink, grow, shrink, grow, shrink, grow])
        
//        let deck = Deck()
//        deck.cards.enqueue(key: Card.Red(frame: frame))
//        deck.cards.enqueue(key: Card.Green(frame: frame))
//        deck.cards.enqueue(key: Card(color: Color.yellow, direction: Direction.right, frame: frame))
//        
//        print(deck.cards.count)
        
//        shape.run(pulsate)
//        redcircle.run(pulsate)
//        greencircle.run(pulsate)
        
        //SKAction *fullScale = [SKAction repeatActionForever:[SKAction sequence:@[scaleDown, scaleUp, scaleDown, scaleUp]]];
        //[_circleChanging runAction:fullScale];
        
        // Start main theme.
//        startSelectedThemeSong()

//        let theme = SKAudioNode(fileNamed: MusicFile.ArcadeFunk.filename)
//        
//        theme.autoplayLooped = true
//        theme.isPositional = false
//        addChild(theme)
//
//        scene?.run(SKAction.sequence([
//            SKAction.wait(forDuration: 0.01),
//            SKAction.run {
//                // this will start playing the audio once.
//                theme.run(SKAction.play())
//            }
//            ]))

//        audioManager.playMusic(MusicFile.ArcadeFunk)
        
//        let bundles = Bundle.allBundles
//        print("all bundles:  \(bundles.count) | \(bundles.description)")
//        let url = Bundle.allBundles.first(where: { $0.name.contains(MusicFile.ArcadeFunk.filename) }).url
//        audioPlayer = AVAudioPlayer(contentsOf: url)
//        audioPlayer.numberOfLoops = -1
//        audioPlayer.volume = 1.0
//        audioPlayer.play()

//        greenCard.throwCard()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
//    func startSelectedThemeSong() {
//        // TODO:  config + song file
//        let defaultTheme = MusicFile.ArcadeFunk.filename
//        run(SKAction.repeatForever(SKAction.playSoundFileNamed(defaultTheme, waitForCompletion: true)))
////        AudioManager.getSKAudioNode(target: scene!, selection: defaultTheme)
//    }

//    func playSound(_ sound: SoundFile) {
////        run(SKAction.playSoundFileNamed(sound, waitForCompletion: false))
////        audioManager.playSoundEffect(named: sound.filename)
//    }
    
//    override func update(_ currentTime: TimeInterval) {
//        /* Called before each frame is rendered */
//        guard let lastTick = lastTick else {
//            return
//        }
//        let timePassed = lastTick.timeIntervalSinceNow * -1000.0
//        if timePassed > tickLengthMillis {
//            self.lastTick = Date()
//            tick?()
//        }
//    }
//    
//    func startTicking() {
//        lastTick = Date()
//    }
//    
//    func stopTicking() {
//        lastTick = nil
//    }
}
