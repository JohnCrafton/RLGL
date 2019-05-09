//
//  Score.swift
//  RLGL
//
//  Created by Overlord on 8/28/17.
//  Copyright © 2017 ComingUpSevens, LLC. All rights reserved.
//

// TODO:  track streaks - score/multiplier at strike, # strikes, ???

import SpriteKit
import Foundation
import PureLayout

protocol ScoreDelegate {
    func multiplierGet(_ score: Score)
}

class Score {
    
    var delegate: ScoreDelegate?
    
    private var _level: Int         = 1
    private var _total: Int         = 0
    private var _running: Int       = 0
    private var _baseValue: Int     = 0
    private var _multiplier: Int    = 1
    
    var level: Int      { get { return _level } }
    var total: Int      { get { return _total } }
    var base: Int       { get { return _baseValue } }
    var multiplier: Int { get { return _multiplier } }
    
    let multiplierStages: [Int] = [10, 25, 50, 100, 150, 250, 500]

    func levelUp() { _level += 1 }
    
    func up() {

        _running            += 1
        _baseValue          += 1
        _total              += (1 * _multiplier)
        
        if multiplierStages.contains(_running) {
            _multiplier = (2 + multiplierStages.index(of: _running)!)
            delegate?.multiplierGet(self)
        }
    }

    func blown() { _running = 0; _multiplier = 1 }
}

class Highscore {
    
    private var _score:         Int = 0
    private var _totalPoints:   Int = 0
    private var _dateSet:       Double = 0.0
    private var _difficulty:    Difficulty = .Standard
    
    var score:          Int { get { return _score } }
    var totalPoints:    Int { get { return _totalPoints } }
    var difficulty:     Difficulty { get { return _difficulty } }
    
    var dateSetInt:     Int { get { return Int(_dateSet) } }

    var dateSet: String {
        get {
            
            if _dateSet == 0.0 {
                return "Not yet set"
            }

            return formattedDate(TimeInterval(_dateSet))
        }
    }
    
    var encoded: [Double] {
        
        var output: [Double] = []
        
        output.append(self._dateSet)
        output.append(Double(self._score))
        output.append(Double(self.totalPoints))
        output.append(Double(self._difficulty.rawValue))
        
        return output
    }
    
    convenience init(_ difficultyRawValue: Int, _ score: Int, _ total: Int, _ epochDate: Double) {
        self.init(Difficulty(rawValue: difficultyRawValue)!, score, total, TimeInterval(epochDate))
    }
    
    convenience init(encoded: [Double]) {
        
        var initValue = (encoded == []) ? [0.0, 0.0, 0.0, 0.0] : encoded
        self.init(Int(initValue[3]), Int(initValue[1]), Int(initValue[2]), initValue[0])
    }
    
    init() { }
    init(_ difficulty: Difficulty) { _difficulty = difficulty }
    init(_ difficulty: Difficulty, _ score: Int, _ total: Int, _ epochDate: TimeInterval) {

        _score = score
        _totalPoints = total
        _dateSet = epochDate
        _difficulty = difficulty
    }
    
    func update(_ newHighscore: Int) {
        
        _totalPoints += newHighscore

        if newHighscore > score {
            _score = newHighscore
            _dateSet = Date().timeIntervalSince1970
        }
    }
    
    var labels: SKShapeNode {
        get {
            
            let container: SKShapeNode = SKShapeNode(rectOf: CGSize(width: DEFAULT_SIZE_WIDTH * 0.80, height: 100))
            
            container.lineWidth = 0
            
            let labelScoreIcon: SKLabelNode = SKLabelNode.Standard
            let labelDateSet: SKLabelNode = SKLabelNode.Footer(text: self.dateSet)
            let labelScore: SKLabelNode = SKLabelNode.Header(text: "High Score:  \(self.score)")
            
            labelScoreIcon.text = self.difficulty.description
            
            labelScore.horizontalAlignmentMode = .left
            labelDateSet.horizontalAlignmentMode = .left
            labelScoreIcon.horizontalAlignmentMode = .right
            
            labelScore.fontSize = labelScore.fontSize * 0.75
            labelDateSet.fontSize = labelDateSet.fontSize * 1.75
            
            labelScore.position = CGPoint(x: container.frame.minX, y: container.frame.midY + 25)
            labelDateSet.position = CGPoint(x: container.frame.minX, y: container.frame.midY - 30)
            labelScoreIcon.position = CGPoint(x: container.frame.maxX - 25, y: container.frame.midY - 25)
                
            container.addChild(labelScore)
            container.addChild(labelDateSet)
            container.addChild(labelScoreIcon)
            
            return container
        }
    }
}
