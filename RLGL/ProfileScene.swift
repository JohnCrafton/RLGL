//
//  ProfileScene.swift
//  RLGL
//
//  Created by Overlord on 8/7/17.
//  Copyright © 2017 ComingUpSevens, LLC. All rights reserved.
//

import SpriteKit
import PureLayout
import Foundation

class ProfileScene: BaseScene, UITextFieldDelegate {

    override var name: String? { get { return PROFILE_SCENE_NAME } set { /* Do nothing. */ } }
    
    let back: ColorButton = StandardButtons.Back.button()

    // TODO:  theme music selector; available music
    // TODO:  favourite color selector?  -- v2.0?
    
    override func didMove(to view: SKView) {
        super.didMove(to: view)
        
        self.backgroundColor = UIColor.mutedRed
        
        self.back.zPosition = 500
        addChild(self.back)

//        let todo = SKLabelNode.Standard
//        todo.text = "Coming soon!\n\nMore stats and (hopefully) achievements!"
//        todo.position = DEFAULT_SIZE__MIDPOINT
//        todo.position.y -= 250
//        
//        addChild(todo)

        prepareProfileFields()
    }
    
    deinit { print("called ProfileScene.deinit()") }
    
    private func prepareProfileFields() {
        
        // TODO:  Name
        // TODO:  Email
        // TODO:  Selectors (theme, color)
        // TODO:  Tabbed control (scores, streaks, etc.)
//        Log.Message(SceneManager.UserProfile.toJSON)
        
        // High Score (date)
        // Longest Streak (date)
        
        var top = DEFAULT_SIZE__MIDPOINT.y
        top += 650

        let casual = Profiles.casual.highscore.labels
        let easy = Profiles.easy.highscore.labels
        let standard = Profiles.standard.highscore.labels
        let hard = Profiles.hard.highscore.labels
        let unfair = Profiles.unfair.highscore.labels
        
        casual.position = CGPoint(x: DEFAULT_SIZE__MIDPOINT.x, y: top)
        casual.zPosition = 1000
        top -= 150
        
        easy.position = CGPoint(x: DEFAULT_SIZE__MIDPOINT.x, y: top)
        easy.zPosition = 1000
        top -= 150
        
        standard.position = CGPoint(x: DEFAULT_SIZE__MIDPOINT.x, y: top)
        standard.zPosition = 1000
        top -= 150
        
        hard.position = CGPoint(x: DEFAULT_SIZE__MIDPOINT.x, y: top)
        hard.zPosition = 1000
        top -= 150
        
        unfair.position = CGPoint(x: DEFAULT_SIZE__MIDPOINT.x, y: top)
        unfair.zPosition = 1000
        top -= 150
        
        self.addChild(casual)
        self.addChild(easy)
        self.addChild(standard)
        self.addChild(hard)
        self.addChild(unfair)
        
//        let highscoreMessage = SceneManager.UserProfile.highscore.description
//        let longestStreakMessage = SceneManager.UserProfile.streak.description
//        let totalPointsMessage = "Total Points Earned:  \(SceneManager.UserProfile.highscore.totalPoints)"
//        
//        let highscore = SKLabelNode.Header(text: highscoreMessage)
//        let longestStreak = SKLabelNode.Header(text: longestStreakMessage)
//        let totalPoints = SKLabelNode.Header(text: totalPointsMessage)
//        
//        highscore.fontSize = highscore.fontSize * 0.65
//        longestStreak.fontSize = longestStreak.fontSize * 0.65
//        totalPoints.fontSize = totalPoints.fontSize * 0.65
//        
//        highscore.position = DEFAULT_SIZE__MIDPOINT
//        longestStreak.position = DEFAULT_SIZE__MIDPOINT
//        totalPoints.position = DEFAULT_SIZE__MIDPOINT
//        
//        highscore.position.y += 150
//        longestStreak.position.y += 75
//        totalPoints.position.y -= 250
//        
//        self.addChild(highscore)
//        self.addChild(longestStreak)
//        self.addChild(totalPoints)
    }
    
    override func tap(_ location: CGPoint) {
        super.tap(location)
        
        if (self.back.contains(location)) {

            self.back.disable()
            SceneManager.Viewport.presentScene(MenuScene(), transition: SceneTransition.profile.back)
        }
    }
}
