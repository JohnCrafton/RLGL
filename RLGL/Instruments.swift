//
//  Instruments.swift
//  RLGL
//
//  Created by Overlord on 8/28/17.
//  Copyright © 2017 ComingUpSevens, LLC. All rights reserved.
//

import SpriteKit

class Instruments {
    
    private let INSTRUMENTS_Y_POSITION_ITEMS = 1720
    private let INSTRUMENTS_Y_POSITION_CONTAINER = 1680
    private let INSTRUMENTS_FONT_NAME = "CourierNewPS-BoldMT"
    
    private var _container: SKShapeNode! = nil
    var container: SKShapeNode {
        get {
            
            if _container == nil {
                
                _container = SKShapeNode(rect: CGRect(x: 0, y: INSTRUMENTS_Y_POSITION_CONTAINER,
                                                      width: 1080, height: 80))
                
                _container.lineWidth = 0
                _container.zPosition = 9001
                _container.fillColor = .clear
                _container.strokeColor = .clear
            }
            
            return _container
        }
    }

    private var _strikesValue: Int = (Konami.GO) ? 30 : 3
    
    private var _score: SKLabelNode! = nil
    private var _level: SKLabelNode! = nil
    private var _strike: SKLabelNode! = nil
    private var _strikes: SKLabelNode! = nil
    private var _scoreMultiplier: SKLabelNode! = nil
    
    var remainingStrikes: Int { get { return _strikesValue } }

    func strike() {

        _strikesValue -= 1
        _strikes.text = "\(_strikesValue)"
        
        multiplierReset()
    }
    
    private func multiplierReset() { _scoreMultiplier.isHidden = true }
    
    func updateScore(_ value: Int) { _score.text = "\(value)" }
    func updateLevel(_ value: Int) { _level.text = "level \(value)" }
    
    func updateMultiplier(_ value: Int) {

        _scoreMultiplier.isHidden = false
        _scoreMultiplier.text = "x\(value)"
    }

    init() {
        
        _strike = SKLabelNode.InstrumentsLabel(text: "⊗")
        _score = SKLabelNode.InstrumentsLabel(text: "\(0)")
        _level = SKLabelNode.InstrumentsLabel(text: "level \(1)")
        _scoreMultiplier = SKLabelNode.InstrumentsLabel(text: "x\(1)")
        _strikes = SKLabelNode.InstrumentsLabel(text: "\(_strikesValue)")

        _strike.fontColor = .red
        _strike.position = CGPoint(x: 50, y: INSTRUMENTS_Y_POSITION_ITEMS)

        _strikes.position = CGPoint(x: 85, y: INSTRUMENTS_Y_POSITION_ITEMS)
        _strikes.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.left
        
        _level.position = CGPoint(x: 200, y: INSTRUMENTS_Y_POSITION_ITEMS)
        _level.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.left
        
        container.addChild(_level)
        container.addChild(_strike)
        container.addChild(_strikes)
        
        _score.position = CGPoint(x: 1030, y: INSTRUMENTS_Y_POSITION_ITEMS)
        _score.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.right
        
        _scoreMultiplier.isHidden = true
        _scoreMultiplier.position = CGPoint(x: 650, y: INSTRUMENTS_Y_POSITION_ITEMS)
        _scoreMultiplier.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.right

        container.addChild(_score)
        container.addChild(_scoreMultiplier)
    }
}
