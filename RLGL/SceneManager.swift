//
//  SceneManager.swift
//  RLGL
//
//  Created by Overlord on 8/14/17.
//  Copyright © 2017 ComingUpSevens, LLC. All rights reserved.
//

import SpriteKit
import Foundation

enum SceneTransition {
    
    case game, profile, settings
    
    private var forwardDirection: SKTransitionDirection {
        
        switch self {
            case .game:
                return .up
            case .profile:
                return .right
            case .settings:
                return .left
        }
    }
    
    private var backDirection: SKTransitionDirection {
        
        switch self {
        case .game:
            return .down
        case .profile:
            return .left
        case .settings:
            return .right
        }
    }
    
    var interval:   TimeInterval { return TimeInterval(0.5) }
    var back:       SKTransition { return SKTransition.push(with: self.backDirection, duration: self.interval) }
    var forward:    SKTransition { return SKTransition.push(with: self.forwardDirection, duration: self.interval) }
}

class SceneManager {
    
    internal static var _profile: Profile!
    internal static var _viewport: SKView!
    internal static var _controller: MainViewController!
    internal static var _selectedDifficulty: Difficulty = .Casual
    
    static var Controller: MainViewController {
        get { return _controller }
        set { _controller = newValue }
    }
    
    static var Viewport: SKView { get { return Controller.contentView } }
    static var Scene: BaseScene { get { return Viewport.scene as! BaseScene } }
    
    static var SelectedDifficulty: Difficulty {
        get { return _selectedDifficulty }
        set { _selectedDifficulty = newValue }
    }
    
    static func VersionLabelOn() { _controller.toggleVersionLabel(.On) }
    static func VersionLabelOff() { _controller.toggleVersionLabel(.Off) }
}
