//
//  Constants.swift
//  RLGL
//
//  Created by Overlord on 8/7/17.
//  Copyright © 2017 ComingUpSevens, LLC. All rights reserved.
//

import SpriteKit
import Foundation

let DEBUG_MODE = true

enum Severity { case Info, Warning, Error }
class Log {
    
    static func Message(_ message: String, _ severity: Severity = .Info) -> Void{
    
        if DEBUG_MODE { print("\(severity) -- \(message)") }
    }
}

enum Difficulty: Int {
    case Casual = 0, Easy, Standard, Hard, Unfair
    
    var value: Double {
        
        switch self {
            case .Casual:
                return 0.0
            case .Easy:
                return 7.0
            case .Standard:
                return 5.0
            case .Hard:
                return 3.0
            case .Unfair:
                return 1.5
        }
    }
    
    var description: String { return "\(self) (\(buttonText))" }
    
    var buttonText: String {
        
        switch self {
            case .Casual:
                return "\u{221e}"
            case .Unfair:
                return "\u{1f620}"
            default:
                return "\(Int.init(value))"
        }
    }
}

let USER_DEFAULTS = UserDefaults.standard
let DEFAULT_PROFILE_NAME = "Friend of @Tonweight"

// Vibrate "system sound" IDs
let SYSTEM_VIBRATE_PEEK = 1519
let SYSTEM_VIBRATE_POP = 1520
let SYSTEM_VIBRATE_NOPE = 1521

// Font constants.

let DEFAULT_FONT_SIZE: CGFloat = CGFloat(40.0)

let DEFAULT_FONT_NAME = "AvenirNext-Medium"
let DEFAULT_FONT_NAME_BOLD = "AvenirNext-Heavy"
let DEFAULT_FONT_NAME_ITALIC = "AvenirNext-HeavyItalic"
let DEFAULT_FONT_NAME_INFORMATION = "AvenirNextCondensed-Regular"

// Sizing/positioning constants.

let DEFAULT_SIZE_WIDTH: Double = 1080.0
let DEFAULT_SIZE_HEIGHT: Double = 1920.0

let DEFAULT_SIZE__MIDPOINT: CGPoint = CGPoint(x: DEFAULT_SIZE_WIDTH / 2, y: DEFAULT_SIZE_HEIGHT / 2)
let DEFAULT_SIZE__FULL_SCREEN: CGSize = CGSize(width: DEFAULT_SIZE_WIDTH, height: DEFAULT_SIZE_HEIGHT)
let DEFAULT_SIZE__80_PERCENT: CGSize = CGSize(width: DEFAULT_SIZE_WIDTH * 0.8, height: DEFAULT_SIZE_HEIGHT * 0.8)

let DEFAULT_SIZE__80_PERCENT_WITH_AD: CGSize =
    CGSize(width: DEFAULT_SIZE_WIDTH * 0.8, height: (DEFAULT_SIZE_HEIGHT * 0.8 - 160))

let DEFAULT_Z_POSITION__INTERFACE: CGFloat = 7.0
let DEFAULT_Z_POSITION__CARDS: CGFloat = 7777.0

let DEFAULT_SCENE_SIZE = DEFAULT_SIZE__FULL_SCREEN

let RLGL_GAMESCENE_NODE_DIRECTIONS = CGRect(x: 0, y: 1780, width: 1080, height: 60)
let RLGL_GAMESCENE_NODE_DECK = CGRect(origin: DEFAULT_SIZE__MIDPOINT, size: DEFAULT_SIZE__80_PERCENT)

let RLGL_SYSTEM_FONT_NAME: String = "System"

let MENU_SCENE_NAME = "MenuScene"
let RLGL_SCENE_NAME = "RLGLScene"
let PROFILE_SCENE_NAME = "ProfileScene"
let SETTINGS_SCENE_NAME = "SettingsScene"

// String constants

let ALERT_MESSAGE_NO_CONNECTION: (title: String, message: String) = (title: "No Connection", message: "This version of the application requires an active connection.")
