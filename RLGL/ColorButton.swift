//
//  ColorButton.swift
//  RLGL
//
//  Created by Overlord on 8/22/17.
//  Copyright © 2017 ComingUpSevens, LLC. All rights reserved.
//

import SpriteKit
import Foundation
import PureLayout
import FontAwesome

class ColorButton: SKShapeNode {
    
    enum ButtonState { case Normal, Highlighted, Disabled }

    var state: ButtonState = .Normal
    var icon: SKLabelNode = SKLabelNode.Standard
    var label: SKLabelNode = SKLabelNode.Standard
    var isDisabled: Bool { return (self.state == ButtonState.Disabled) }
    
    private var function: ButtonFunction!
    
    typealias ButtonFunction = () -> ()
    func setButtonFunction(function: @escaping ButtonFunction) {
        
        self.function = function
    }
    
    private var buttonColorCombos: [(fill: UIColor, text: UIColor)] {
        
        return [
            (fill: .red, text: .white),
            (fill: .blue, text: .white),
            (fill: .green, text: .white),
            (fill: .purple, text: .white),
            (fill: .orange, text: .white),
            (fill: .yellow, text: .white)
        ]
    }

    private var _selectedCombo: (fill: UIColor, text: UIColor)! = nil
    var selectedColorCombo: (fill: UIColor, text: UIColor) {
        get {
            
            if _selectedCombo == nil {
                _selectedCombo = randomColor
            }
            
            return _selectedCombo
        }
        set {
            _selectedCombo = newValue
            changeState(.Normal)
        }
    }

    private var randomColor: (fill: UIColor, text: UIColor) {
        let index = arc4random_uniform(UInt32(buttonColorCombos.count - 1))
        return buttonColorCombos[Int(index)]
    }
    
    private func changeState(_ newState: ButtonState) {

        self.state = newState
        
        self.fillColor = selectedColorCombo.fill
        self.strokeColor = (state == .Normal) ? .white : .lightGray
    }
    
    func enable() { changeState(ButtonState.Normal) }
    func disable() { changeState(ButtonState.Disabled) }
    
    override init() {
        super.init()

        self.lineWidth = 10
        self.zPosition = 90000
        
        changeState(.Normal)
    }
    
    required init?(coder aDecoder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    
    func touched() {
        
        if !isDisabled {
            
            changeState(ButtonState.Highlighted)
            tasteTheRainbow()
            self.run(AudioManager.Button)
        }
    }
    
    func tasteTheRainbow() {

        let theRainbow: [SKColor] = [.red, .mutedRed, .orange, .yellow, .mutedGreen, .green, .blue, .purple ]
        let rainbowSequenceAction = SKAction.multipleColorTransitionAction(colors: theRainbow, duration: 0.75)
        
        self.run(SKAction.repeatForever(rainbowSequenceAction))
    }
    
    func released(_ activate: Bool) {
        
//        print("released color button \(self.name ?? "fucked")")
        
        if !isDisabled {
            
            self.removeAllActions()
            changeState(ButtonState.Normal)
            
            if function != nil && activate { function() }
        }
    }
}

enum MenuButtons: Int {
    case Profile = 0, Start, Settings, Stats, TryAgain, Difficulty, Forum, Twitter, Facebook, Purchase
    
    var name: String { return "\(self)" }
    
    var rectangle: CGRect { return CGRect(x: (1080 / 2) - 300, y: (1920 / 2), width: 600, height: 120) }
    
    var faChar: String {

        var icon: FontAwesome = .question
        
        switch self {
            case .Start:
                icon = .playCircle; break
            case .Profile:
                icon = .userCircle; break
            case .Difficulty:
                icon = .tachometer; break
            case .Settings:
                icon = .cogs; break
            case .Forum:
                icon = .comments; break
            case .Twitter:
                icon = .twitter; break
            case .Facebook:
                icon = .facebookOfficial; break
            case .Stats:
                icon = .barChartO; break
            case .Purchase:
                icon = .money; break
            default:
                break
        }
        
        return String.fontAwesomeIcon(name: icon)
    }
    
    var character: String {
        switch self {
        case .Profile:
            return "\u{1f464}"
        case .Start:
            return "\u{25b9}"
        case .Settings:
            return "\u{2699}"
        case .Stats:
            return "≡"
        case .TryAgain:
            return "\u{21ba}"
        case .Difficulty:
            return "\u{231b}"
        case .Forum:
            return "\u{1f4ac}"
        case .Twitter:
            return "T"
        case .Facebook:
            return "F"
        case .Purchase:
            return "$"
        }
    }
    
    func button() -> ColorButton {
        return self.shape.copy() as! ColorButton
    }
    
    var shape: ColorButton {
        
        let shape = ColorButton(rect: self.rectangle)
        
        shape.name = "\(self)"
        
        shape.label.fontSize = 100
        shape.label.zPosition = 99999
        shape.label.text = self.character
        shape.label.fontColor = shape.selectedColorCombo.text
        shape.label.position = CGPoint(x: self.rectangle.midX, y: self.rectangle.midY)
        
        switch self {
            
        case .Difficulty, .Profile, .Start, .Stats, .Settings, .Forum, .Facebook, .Purchase:

            shape.icon.fontSize = 75.0
            shape.icon.fontName = UIFont.fontAwesome(ofSize: 1.0).fontName
            shape.icon.text = self.faChar
            
            shape.label.fontSize = 50.0
            shape.label.fontName = DEFAULT_FONT_NAME_BOLD
            shape.label.text = self.name.capitalized
            
            shape.addChild(shape.icon)
            shape.addChild(shape.label)
            
            shape.icon.position.y = self.rectangle.midY
            shape.label.position.y = self.rectangle.midY
            
            shape.label.position.x = self.rectangle.midX + 25 + (shape.icon.frame.width / 2)
            shape.icon.position.x = shape.label.frame.minX - 25 - (shape.icon.frame.width / 2)
            
            break
            
        case .TryAgain:
            
            shape.label.fontSize = 80
            shape.label.fontName = DEFAULT_FONT_NAME_BOLD
            shape.label.text = "Try again? \(self.character)"
            
            shape.addChild(shape.label)
            
            break
            
        case .Twitter:
            
            shape.icon.fontSize = 75.0
            shape.icon.fontName = UIFont.fontAwesome(ofSize: 1.0).fontName
            shape.icon.text = self.faChar
            
            shape.label.fontSize = 75.0
            shape.label.fontName = DEFAULT_FONT_NAME_BOLD
            shape.label.text = "Tweet highscore?"
            
            shape.addChild(shape.icon)
            shape.addChild(shape.label)
            
            shape.icon.position.x = shape.frame.minX + 10
            shape.icon.position.y = shape.frame.maxY / 2
            
            shape.label.position.x = (shape.frame.maxX - 10) + (shape.label.frame.width / 2)
            shape.label.position.y = shape.frame.maxY / 2
            
            break
            
//        default:
//            
//            shape.label.fontName = "Menlo-Regular"
//            shape.addChild(shape.label)
//            
//            break
        }
        
        return shape
    }
}

enum StandardButtons: Int {
    case Profile = 0, Start, Settings, Stats, A, B, Back, TryAgain, Info, Hourglass, Forum, Twitter, Facebook, Music
    
    var name: String { return "\(self)" }
    
    var rectangle: CGRect {
        switch self {
        case .Profile:
            return CGRect(x: 775, y: 375, width: 150, height: 150)
        case .Start:
            return CGRect(x: 465, y: 650, width: 150, height: 150)
        case .Settings:
            return CGRect(x: 775, y: 650, width: 150, height: 150)
        case .Stats:
            return CGRect(x: 155, y: 650, width: 150, height: 150)
        case .A:
            return CGRect(x: 80, y: 350, width: 60, height: 60)
        case .B:
            return CGRect(x: 950, y: 350, width: 60, height: 60)
        case .Back:
            return CGRect(x: 40, y: 1760, width: 80, height: 80)
        case .TryAgain:
            return CGRect(x: 205, y: 300, width: 660, height: 150)
        case .Info:
            return CGRect(x: 50, y: 1750, width: 60, height: 60)
        case .Music:
            return CGRect(x: 980, y: 1750, width: 60, height: 60)
        case .Hourglass:
            return CGRect(x: 155, y: 375, width: 150, height: 150)
        case .Forum:
            return CGRect(x: 775, y: 650, width: 150, height: 150)
        case .Twitter:
            return CGRect(x: 205, y: 495, width: 660, height: 150)
        case .Facebook:
            return CGRect(x: 205, y: 400, width: 660, height: 150)
        }
    }
    
    var faChar: String {
        
        var icon: FontAwesome = .questionCircle
        
        switch self {
        case .Start:
            icon = .playCircle; break
        case .Profile:
            icon = .userCircle; break
        case .Hourglass:
            icon = .hourglass; break
        case .Settings:
            icon = .cogs; break
        case .Forum:
            icon = .comments; break
        case .Twitter:
            icon = .twitter; break
        case .Facebook:
            icon = .facebookOfficial; break
        case .Music:
            icon = .music; break
        default:
            break
        }
        
        return String.fontAwesomeIcon(name: icon)
    }
    
    var character: String {
        switch self {
        case .Profile:
            return "\u{1f464}"
        case .Start:
            return "\u{25b9}"
        case .Settings:
            return "\u{2699}"
        case .Stats:
            return "≡"
        case .A:
            return "A"
        case .B:
            return "B"
        case .Back:
            return "\u{21e0}"
        case .TryAgain:
            return "\u{21ba}"
        case .Info:
            return "?"
        case .Hourglass:
            return "\u{231b}"
        case .Forum:
            return "\u{1f4ac}"
        case .Twitter:
            return "T"
        case .Facebook:
            return "F"
        case .Music:
            return "M"
        }
    }
    
    func button() -> ColorButton {
        return self.shape.copy() as! ColorButton
    }
    
    var shape: ColorButton {
        
        let shape = (["A", "B", "?", "M"].contains(self.character)) ?
            ColorButton(circleOfRadius: ((self.character == "?" || self.character == "M") ? 40.0 : 60.0)) :
            ColorButton(rect: self.rectangle)
        
        shape.name = "\(self)"
        
        shape.label.fontSize = 140
        shape.label.zPosition = 99999
        shape.label.text = self.character
        shape.label.fontColor = shape.selectedColorCombo.text
        shape.label.position = CGPoint(x: self.rectangle.midX, y: self.rectangle.midY)
        
        switch self {
            
        case .Hourglass, .Profile, .Start, .Settings, .Forum, .Facebook:
            
//            let outlinedLabel = OutlinedLabelNode(fontNamed: UIFont.fontAwesome(ofSize: 100.0).fontName,
//                                                  fontSize: 100.0, color: .white)
//            
//            outlinedLabel.fontColor = .white
//            outlinedLabel.borderColor = .black
//            outlinedLabel.outlinedText = self.faChar
//            outlinedLabel.zPosition = 99999
//            outlinedLabel.position = CGPoint(x: self.rectangle.midX, y: self.rectangle.midY)
//            outlinedLabel.isHidden = false
            
            shape.label.fontSize = (self == .Hourglass) ? 80.0 : 100.0
            shape.label.fontName = UIFont.fontAwesome(ofSize: 1.0).fontName
            shape.label.text = self.faChar
//            shape.label.isHidden = true
            
            shape.addChild(shape.label)
//            shape.addChild(outlinedLabel)
            
            break
            
        case .TryAgain:
            
            shape.label.fontSize = 80
            shape.label.fontName = DEFAULT_FONT_NAME_BOLD
            shape.label.text = "Try again? \(self.character)"
            
            shape.addChild(shape.label)
            
            break
            
        case .Twitter:
            
            shape.icon.fontSize = 75.0
            shape.icon.fontName = UIFont.fontAwesome(ofSize: 1.0).fontName
            shape.icon.text = self.faChar
            
            shape.label.fontSize = 50.0
            shape.label.fontName = DEFAULT_FONT_NAME_BOLD
            shape.label.text = "Tweet highscore?"
            
            shape.addChild(shape.icon)
            shape.addChild(shape.label)

            shape.icon.position.y = self.rectangle.midY
            shape.label.position.y = self.rectangle.midY
            
            shape.label.position.x = self.rectangle.midX + 25 + (shape.icon.frame.width / 2)
            shape.icon.position.x = shape.label.frame.minX - 25 - (shape.icon.frame.width / 2)
            
            break
        
        case .Info, .Music:
            
            shape.lineWidth = 7
            shape.strokeColor = .white
            shape.fillColor = .infoBlue
            shape.position = CGPoint(x: self.rectangle.midX, y: self.rectangle.midY)
            
            shape.label.fontSize = 42
            shape.label.position = CGPoint(x: 0, y: 0)
//            shape.label.fontName = DEFAULT_FONT_NAME_BOLD
            shape.label.fontColor = .white

            shape.label.fontName = UIFont.fontAwesome(ofSize: 1.0).fontName
            shape.label.text = self.faChar

            shape.addChild(shape.label)

            break

        case .A, .B:
            
//            let circle = SKShapeNode(circleOfRadius: 60.0)
            
            shape.lineWidth = 7
            shape.strokeColor = .white
            shape.fillColor = (self.character == "A") ? .red : .green
            shape.position = CGPoint(x: self.rectangle.midX, y: self.rectangle.midY)
            
            shape.label.fontSize = 60
            shape.label.position = CGPoint(x: 0, y: 0)
            shape.label.fontName = DEFAULT_FONT_NAME_BOLD
            shape.label.fontColor = (self.character == "A") ? .white : .almostBlack
            
//            circle.addChild(label)
//            shape.addChild(circle)
            shape.addChild(shape.label)
            
//            shape.lineWidth = 0
            
            break
            
        default:
            
            shape.label.fontName = "Menlo-Regular"
            shape.addChild(shape.label)
            
            break
        }
        
        return shape
    }
}
