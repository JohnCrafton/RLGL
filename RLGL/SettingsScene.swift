//
//  SettingsScene.swift
//  RLGL
//
//  Created by Overlord on 8/16/17.
//  Copyright © 2017 ComingUpSevens, LLC. All rights reserved.
//

import SpriteKit
import Foundation

class SettingsScene: BaseScene {
    
    override var name: String? { get { return SETTINGS_SCENE_NAME } set { /* Do nothing. */ } }
    
    let back: ColorButton = StandardButtons.Back.button()
    
    override func didMove(to view: SKView) {
        super.didMove(to: view)
        
        self.backgroundColor = UIColor.mutedGreen
        field.fillColor = .mutedGreen
        
        addChild(self.back)
        
        let todo = SKLabelNode.Standard
        todo.text = "TODO:  Settings go here"
        todo.position = DEFAULT_SIZE__MIDPOINT
        
        addChild(todo)
    }
    
    override func tap(_ location: CGPoint) {
        super.tap(location)

        if (self.back.contains(location)) {
            SceneManager.Viewport.presentScene(MenuScene(), transition: SceneTransition.settings.back)
        }
    }
}
