//
//  RLGLScene.swift
//  RLGL
//
//  Created by Overlord on 8/7/17.
//  Copyright © 2017 ComingUpSevens, LLC. All rights reserved.
//

import SpriteKit
import TwitterKit
import PureLayout
import Crashlytics

class RLGLScene: BaseScene, RLGLDelegate, ScoreDelegate {
    
    var gameover = false
    var rlgl: RLGL! = nil
    
    let audio = AudioManager.init()
    
    override var name: String? { get { return RLGL_SCENE_NAME } set { /* Do nothing. */ } }
    
    let backButton = StandardButtons.Back.button()
    let retryButton = StandardButtons.TryAgain.button()
    let twitterButton = StandardButtons.Twitter.button()
    
    var logInButton: TWTRLogInButton?
    
    override init() {
        super.init()
        
        loadGame()
    }
    
    private func loadGame() {

        rlgl = RLGL()
    }
    
    override func didMove(to view: SKView) {
        super.didMove(to: view)
        
        SceneManager.VersionLabelOff()
        
        self.physicsBody = SKPhysicsBody(edgeLoopFrom: self.frame)
        
        self.physicsBody?.categoryBitMask = 0
        self.physicsBody?.collisionBitMask = 0
        self.physicsBody?.contactTestBitMask = 0
        
        rlgl.beginGame(scene: self)
        
        rlgl.delegate = self
        GameManager.shared.score.delegate = self
    }
    
    func prepare() {
        
        prepareButtons()
        prepareDirections()
        prepareInstruments()
    }
    
    private func prepareButtons() {
        
        self.backButton.isHidden = true
        self.retryButton.isHidden = true
        self.twitterButton.isHidden = true
        self.backgroundColor = UIColor.darkGray
        
        addChild(backButton)
        addChild(retryButton)
        addChild(twitterButton)
    }
    
    func showDot(_ color: Color) {
        print("showing color dot for \(color)")
        let dot = _dots.first { (value: (Color, SKShapeNode)) -> Bool in
            value.0 == color
        }?.1
        
        dot?.isHidden = false
        dot?.run(color.pulse)
    }
    
    func showRetry() {

        self.retryButton.isHidden = false
        self.retryButton.zPosition = 99999
        
        self.backButton.isHidden = false
        self.backButton.zPosition = 99999

        self.twitterButton.isHidden = false
        self.twitterButton.zPosition = 99999
    }
    
    // TODO:  Deck
    
    private var _instruments: Instruments! = nil
    var instruments: Instruments {
        get {
            
            if _instruments == nil {
                
                _instruments = Instruments()
            }
            
            return _instruments
        }
    }
    
    func prepareInstruments() {
        
        addChild(instruments.container)
    }
    
    private var _directions: SKShapeNode! = nil
    var directions: SKShapeNode {
        get {
            
            if _directions == nil {
                
                _directions = SKShapeNode(rect: RLGL_GAMESCENE_NODE_DIRECTIONS)
                
                _directions.lineWidth = 0
                _directions.zPosition = 500
                _directions.fillColor = .clear
                
                _directions.physicsBody?.collisionBitMask = 0
            }
            
            return _directions
        }
    }
    
    private var _dots: [(Color, SKShapeNode)] = []
    private func prepareDirections() {
        
        var left = 0
        var right = 0

        for card in Card.Deck {
            
            let count = (card.direction == .left) ? left : right
            
            let multiplier = count + 1
            let value = (60 * multiplier)
            
            let xVal = 540 + ((card.direction == .left) ? (value * -1) : value)
            
            let dot = card.color.shape
            
            dot.isHidden = (card.color != .red && card.color != .green)
            dot.position = CGPoint(x: CGFloat(xVal), y: directions.frame.midY)
            
            directions.addChild(dot)
            _dots.append((card.color, dot))
            
            if card.direction == .left {
                left += 1
            } else {
                right += 1
            }
        }

        self.addChild(directions)
    }
    
    private func toggleButtons() {
        backButton.isHidden = !(backButton.isHidden)
        retryButton.isHidden = !(retryButton.isHidden)
        twitterButton.isHidden = !(twitterButton.isHidden)
    }
    
    override func swipe(_ direction: Direction) { rlgl.testSwipe(direction: direction) }
    
    override func tap(_ location: CGPoint) {
        
        if gameover {
            
            if StandardButtons.TryAgain.rectangle.contains(location) {
                print("RLGLViewController.tapped():  in Button.TryAgain.")
                
                toggleButtons()
                GameManager.shared.reset()
                SceneManager.Viewport.presentScene(RLGLScene())
            }
            
            if StandardButtons.Back.rectangle.contains(location) {
                print("RLGLViewController.tapped():  in Button.Back.")
                
                toggleButtons()
                SceneManager.Viewport.presentScene(MenuScene(), transition: SceneTransition.game.back)
            }
            
            if StandardButtons.Twitter.rectangle.contains(location) {
                Log.Message("RLGLViewController.tapped():  in Button.Twitter.")

                SocialComposer.Tweet()
            }
        }
    }
    
    func update() {
        
        print("RLGLScene.update() [RLGLDelegate]:  Doing update...")
        // TODO:  scene-level updates
    }
    
    func success() {
        self.run(AudioManager.Good)
        Log.Message("RLGLScene RLGL delegate method success()")
    }
    
    func failure() {
//        _lives.removePip()
        self.run(AudioManager.Bad)
        Log.Message("RLGLScene RLGL delegate method failure()")
    }
    
    func levelUp() {
        self.run(AudioManager.LevelUp)
        Log.Message("RLGLScene RLGL delegate method levelUp()")
    }
    
    func multiplierGet(_ score: Score) {
        self.run(AudioManager.Great)
        Log.Message("RLGLScene Score delegate method multiplierGet()")
        Answers.logCustomEvent(withName: "Multiplier GET", customAttributes: ["Multiplier": score.multiplier ])
    }
    
    required init?(coder aDecoder: NSCoder) { fatalError("init(coder:) has not been implemented") }
}
