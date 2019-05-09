//
//  Deck.swift
//  RLGL
//
//  Created by Overlord on 8/1/17.
//  Copyright © 2017 ComingUpSevens, LLC. All rights reserved.
//

import SpriteKit
import Foundation

struct Deck {
    
    var items = [Card]()

    mutating func push(_ item: Card) { items.append(item) }

    mutating func pop() -> Card? {

        return (items.isEmpty) ? nil : items.removeFirst()
    }
    
    func peek() -> Card {

        return (items.isEmpty ? nil : items.first)!
    }
    
//    func peek5() -> Array<Card> {
//        
//        return Array<Card>(items.prefix(5))
//    }
    
    static func Reset() {
        
        _node = nil
    }
    
    private static var _node: SKShapeNode?
    static var Node: SKShapeNode {
        get {
            
            if (_node == nil) {
                
                _node = SKShapeNode(rectOf: DEFAULT_SIZE__80_PERCENT_WITH_AD)

                _node?.name = "DeckNode"
                _node?.zPosition = 42
                _node?.position = DEFAULT_SIZE__MIDPOINT
                _node?.position.y = (_node?.position.y)! - 30
                
                _node?.lineWidth = 0
                _node?.fillColor = .clear
                _node?.strokeColor = .clear
            }
            
            return _node!
        }
    }
}
