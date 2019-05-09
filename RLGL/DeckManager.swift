//
//  DeckManager.swift
//  RLGL
//
//  Created by Overlord on 8/11/17.
//  Copyright © 2017 ComingUpSevens, LLC. All rights reserved.
//

import Foundation

class DeckManager {
    
    private static var _draw: Deck = Deck()
    private static var _hand: Deck = Deck()
    private static var _discard: Deck = Deck()
    
//    static let LevelThresholds: [Int] = [5, 10, 15, 20, 30, 35, 40, 45]
    static let LevelThresholds: [Int] = [10, 20, 30, 40, 50, 60, 70, 80]
//    static let LevelThresholds: [Int] = [10, 20, 40, 75, 125, 200, 300, 400]
    
    static func LevelUp(_ level: Int) -> Bool {
        return (level < LevelThresholds.endIndex)
            ? Discard.items.count == LevelThresholds[level - 1]
            : Discard.items.count == LevelThresholds.last! + ((level - LevelThresholds.endIndex) * 25)
//            : Discard.items.count == LevelThresholds.last! * (level % LevelThresholds.endIndex)
    }
    
    static func Reset() {
        
        Deck.Reset()
        Card.Reset()

        _draw = Deck()
        _hand = Deck()
        _discard = Deck()
    }
    
    static var Draw: Deck {
        get {
            return _draw
        }
    }
    
    static var Hand: Deck {
        get {
            return _hand
        }
    }
    
    static var Discard: Deck {
        get {
            return _discard
        }
    }
    
    static func draw() -> Card {
        
        var current = _draw.pop()!
        current.node = CardNode(current)

        _hand.push(current)

        return _hand.peek()
    }
    
    static func discard() -> Card {
        
        let current = _hand.pop()!
        
        _discard.push(current)
        current.node?.throwCard()

        if _draw.items.count == 10 { shuffle() }
        
        return draw()
    }
    
    static func shuffle() {

        for n in (2...1000) {
            
            if (Card.Deck.count < NumberOfColors) {
                
                // Accounts for Red/Green always at [0] and [1] of Card.Deck
                let threshold = LevelThresholds[Card.Deck.count - 2]

                if n % threshold == 0 { _ = Card.Random() }
            }

            let index = Int(arc4random_uniform(UInt32(Card.Deck.count)))

            _draw.push(Card.New(index))
        }
    }
    
    static func deal() {
        
        _draw.push(Card.Deck[0]) // Add red card; always first/left
        _draw.push(Card.Deck[1]) // Add green card; always second/right
        
        shuffle()
        
        // Starting deck of ten cards.
        for _ in (1...10) {
            _ = draw()
        }
    }
    
    static func explosion() {
        
        for card in _hand.items {
            card.node?.explode()
        }
    }
    
    static var description: String {
        get {
            return "draw: \(_draw.items.count)\nhand: \(_hand.items.count)\ndiscard: \(_discard.items.count)"
        }
    }
}
