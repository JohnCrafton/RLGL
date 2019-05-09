//
//  RLGL.swift
//  RLGL
//
//  Created by Overlord on 7/10/17.
//  Copyright © 2017 ComingUpSevens, LLC. All rights reserved.
//

import Fabric
import GameKit
import SpriteKit
import Foundation
import Crashlytics
import GameAnalytics

protocol RLGLDelegate {
    func update()
    func success()
    func failure()
    func levelUp()
}

struct RLGLProducts {
    public static let AdFree = "com.comingupsevens.rlgl.noads"
}

func resourceNameForProductIdentifier(_ productIdentifier: String) -> String? {
    return productIdentifier.components(separatedBy: ".").last
}

class RLGL {
    
    var delegate: RLGLDelegate?
    
    let MAX_FAILURES:   Int = (Konami.GO) ? 30 : 3
    
    var failures:       Int = 0
    var level:          Int = 0
    
    var inStreak:       Bool = true
    var gameover:       Bool = false
    
    var currentCard:    Card?

    weak var scene:     RLGLScene!

    var timer:          SKShapeNode! = nil
    var deckBox:        SKShapeNode = Deck.Node
    var directionsNode: SKShapeNode! = nil
    var wheelTimer:     WheelTimer! = nil
    
    var directions:     Array<Color> = []
    
    init() {

        scene = nil
        currentCard = nil

        timer = nil
        directionsNode = nil

        resetResources()

        Log.Message("RLGL.init:  Initialized.")
    }
    
    func beginGame(scene: RLGLScene) {
        
        self.scene = scene
        
        GameManager.shared.profile.gamesUp()

        resetResources()
        
        level = 1
        
        if Konami.GO { Answers.logCustomEvent(withName: "Konami Game", customAttributes: [:]) }
        
        Answers.logCustomEvent(withName: "Difficulty",
                               customAttributes: ["Level": (GameManager.shared.profile.difficulty.description)])
        
        DeckManager.deal()
//        print("RLGL.beginGame():  DeckManager.deal() called:\n\n\(DeckManager.description)\n")
        
        self.scene.prepare()

//        self.scene.addChild(_lives.container)
//        _lives.container.isHidden = true
        
        levelOne()
        renderTimer()
    }
    
    func endGame() {

        recordLevelEnd(false)
        DeckManager.explosion()
        
        self.resetTimer()
//        lineTimer.removeFromParent()
        wheelTimer.removeFromParent()

        self.gameover = true
        self.scene.gameover = true
        self.scene.showRetry()

        GameManager.shared.gameOver()

//        SceneManager.SaveProfile()

//        if profileSaved {
//            Log.Message("RLGL.endGame():  Profile already saved.")
//        } else {
//            SceneManager.SaveProfile()
//            Log.Message("RLGL.endGame():  Profile saved.")
//        }
        
        let gameoverLabel = OutlinedLabelNode(fontNamed: DEFAULT_FONT_NAME_BOLD, fontSize: 100.0, color: .red)

        gameoverLabel.zPosition = 99999
        gameoverLabel.fontColor = .white
        gameoverLabel.borderColor = .black
        gameoverLabel.outlinedText = "GAME OVER"
        gameoverLabel.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.center
        gameoverLabel.position = CGPoint(x: (scene?.frame.midX)!, y: (scene?.frame.midY)!)
        
        scene?.addChild(gameoverLabel)
        
        let streak = SKLabelNode(fontNamed: DEFAULT_FONT_NAME_BOLD)
        
        streak.fontSize = 80
        streak.text = "Streak:  \(GameManager.shared.hits.streak)"
        streak.fontColor = (currentCard?.color.isLightColor)! ? UIColor.black : UIColor.white
        streak.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.center
        
        streak.position = CGPoint(x: (scene?.frame.midX)!, y: (scene?.frame.midY)! - 150)
        streak.zPosition = 99999
        
        scene?.addChild(streak)
        
        let highscore = SKLabelNode(fontNamed: DEFAULT_FONT_NAME_BOLD)
        
        highscore.fontSize = 80
        highscore.text = "High Score:  \(GameManager.shared.score.total)"
        highscore.fontColor = (currentCard?.color.isLightColor)! ? UIColor.black : UIColor.white
        highscore.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.center
        
        highscore.position = CGPoint(x: (scene?.frame.midX)!, y: (scene?.frame.midY)! - 250)
        highscore.zPosition = 99999
        
        scene?.addChild(highscore)

//        delegate?.gameDidEnd(self)
    }
    
    private func resetResources() {

        DeckManager.Reset()
        
        if scene != nil {
            if scene.children.count > 0 {
                for child in (scene?.children)! {
                    if child.name == StandardButtons.Back.shape.name { continue }
                    if child.name == StandardButtons.TryAgain.shape.name { continue }
                    child.removeFromParent()
                }
            }
        }
    }
    
    private func renderTimer() {
        
//        lineTimer = LineTimer()
//        scene.addChild(lineTimer.shape)
        
        wheelTimer = WheelTimer()
        wheelTimer.setDifficulty(GameManager.shared.difficulty)
        wheelTimer.shape.position = CGPoint(x: 540, y: 1750)

        scene.addChild(wheelTimer.shape)
    }
    
    func resetTimer() {
        
//        scene?.removeAction(forKey: "line-timer-update")
        scene?.removeAction(forKey: "wheel-timer-update")

//        if lineTimer != nil { lineTimer.removeFromParent() }
        if wheelTimer != nil { wheelTimer.removeFromParent() }

        renderTimer()
    }
    
    private func glowingDeckBox(on: Bool) {
        
//        let glow = SKShapeNode(rect: (deckBox?.frame)!, cornerRadius: 10)
//        if (on) {
//            glow.glowWidth = 25.0
//            glow.strokeColor = UIColor(red: 252.0/255.0, green: 194.0/255.0, blue: 0, alpha: 1.0)
//        } else {
//            glow.glowWidth = 0.0
//            glow.strokeColor = UIColor.clear
//        }
//        
//        glow.zPosition = 1000
//        
//        if (deckBox?.children.contains(glow))! { return }
//        deckBox?.addChild(glow)
    }
    
    private func renderDeckBox() {
        
        Log.Message("RLGL.renderDeckBox():  Creating deckBox...")
        
        var splines = [CGPoint(x: deckBox.frame.midX - 20, y: 200),
                       CGPoint(x: deckBox.frame.midX + 20, y: 200)]
        
        let dz = SKShapeNode(splinePoints: &splines, count: splines.count)
        
        dz.lineWidth = 1
        dz.strokeColor = UIColor.clear
        dz.physicsBody = SKPhysicsBody(edgeChainFrom: dz.path!)
        dz.physicsBody?.restitution = 0.75

        self.scene?.addChild(deckBox)
        self.scene?.addChild(dz)
    }
    
    func levelOne() {
        
        Log.Message("RLGL.levelOne()...")
        
        level = 1
        renderDeckBox()
        
        for card in DeckManager.Hand.items {
            let node = (card.node?.render())!
            deckBox.addChild(node)
        }
        
        currentCard = DeckManager.Hand.peek()

        Answers.logLevelStart("Level 1 Start", customAttributes: [:])
        
        Log.Message("RLGL.levelOne():  currentCard = \(currentCard?.description ?? "none/broken")")
    }

    func levelUp() {
        
        Log.Message("RLGL.levelUp():  Levelling up...")
        
        recordLevelEnd()
        
        self.delegate?.levelUp()
        
        self.level += 1
        
        GameManager.shared.levelUp()
        scene.instruments.updateLevel(self.level)

        // Renders the next color dot using level as the index of the Card.Deck
        if (level > 1 && level < NumberOfColors) { scene.showDot(Card.Deck[level].color) }
        
        Answers.logLevelStart("Level \(level) Start", customAttributes: [:])
        
        Log.Message("RLGL.levelUp():  Now at level \(self.level)")
    }
    
    private func recordLevelEnd(_ playContinues: Bool = true) {

        if playContinues {

            Answers.logLevelEnd("Level \(self.level) End",
                score: NSNumber(integerLiteral: GameManager.shared.score.total),
                success: true,
                customAttributes: [
                    "Current Streak": GameManager.shared.hits.streak,
                    "Total Score": GameManager.shared.score.total,
                    "Remaining Strikes": scene.instruments.remainingStrikes
                ])
            
            if self.level == 3 {
                Answers.logCustomEvent(withName: "Level 3 Completed",
                                       customAttributes: [
                                        "Total Score": GameManager.shared.score.total,
                                        "Remaining Strikes": scene.instruments.remainingStrikes
                    ])
            }
            
            if self.level == 8 {
                Answers.logCustomEvent(withName: "Level 8 Completed",
                                       customAttributes: [
                                        "Total Score": GameManager.shared.score.total,
                                        "Remaining Strikes": scene.instruments.remainingStrikes
                    ])
            }

        } else {

            Answers.logLevelEnd("Level \(self.level) End",
                score: NSNumber(integerLiteral: GameManager.shared.score.total),
                success: false,
                customAttributes: [
                    "Current Streak": GameManager.shared.hits.streak,
                    "Base Score": GameManager.shared.score.base,
                    "Total Score": GameManager.shared.score.total,
                    "Remaining Strikes": scene.instruments.remainingStrikes,
                    "Game Over At Level": self.level
                ])
        }
    }
    
    func testSwipe(direction: Direction) {
        
        if self.gameover { return }
        if (self.currentCard?.direction == direction) { swipeSuccess() } else { swipeFail() }

        Log.Message("RLGL.testSwipe():  direction = \(direction), " +
            "currentCard = \(currentCard?.description ?? "none/broken")")
    }
    
    func swipeFail() {
        
        failures += 1
        scene.instruments.strike()

        AudioManager.Vibrate()

        GameManager.shared.miss((currentCard?.color)!)

        if (inStreak) { glowingDeckBox(on: false) }
        
        if (failures == MAX_FAILURES) { endGame() }
        
        self.delegate?.failure()
    }
    
    func swipeSuccess() {
        
        Log.Message("-----RLGL.swipeSuccess()")

        GameManager.shared.hit((currentCard?.color)!)

        if (inStreak) { glowingDeckBox(on: true) }

        self.currentCard = DeckManager.discard()
        
        if DeckManager.LevelUp(level) { levelUp() }

        scene.instruments.updateScore(GameManager.shared.score.total)
        scene.instruments.updateMultiplier(GameManager.shared.score.multiplier)

        for card in DeckManager.Hand.items {
            if (card.node?.rendered)! { continue }
            deckBox.addChild((card.node?.render())!)
        }
        
        resetTimer()
        wheelTimer.update(level) { self.endGame() }

        murderOrphans()
        self.delegate?.success()

//        print("RLGL.swipeSuccess():  currentCard:  \(currentCard?.description ?? "nothing")")
//        print("RLGL.swipeSuccess():  DeckManager status:\n\n\(DeckManager.description)\n")
    }
    
    func murderOrphans() {
    
        for card in DeckManager.Discard.items {
            if (card.node?.thrown)! {
                if (card.node?.rendered)! {

                    let doesNotIntersect = (card.node?.canvas?.frame)!.intersects((scene?.frame)!) == false
                    
                    if doesNotIntersect {

//                        print("RLGL.murderOrphans():  removing [\(card.description)]...")

                        card.node?.rendered = false
                        card.node?.canvas?.removeFromParent()
                    }
                }
            }
        }
    }
}
