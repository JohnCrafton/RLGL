//
//  Card.swift
//  RLGL
//
//  Created by Overlord on 7/19/17.
//  Copyright © 2017 ComingUpSevens, LLC. All rights reserved.
//

import SpriteKit

struct Card {
    
    let color: Color
    let effect: Effect
    let texture: Texture
    let direction: Direction
    
    var swipes: Int = 0
    var thrown: Bool = false
    var rendered: Bool = false
    
    var id: Int?
    var z: CGFloat?

    var node: CardNode?
    
    static var ID: Int = 0
    static var Z: CGFloat = DEFAULT_Z_POSITION__CARDS
    static var Deck: Array<Card> = [Card.Red, Card.Green]

    var description: String { return "[id: \(id!)] \(color) (\(direction) (z=\(z!))" }
    
    init(color: Color, direction: Direction) {
        
        self.color = color
        self.direction = direction
        
        self.id = Card.ID
        Card.ID += 1

        self.node = nil
        self.effect = Effect()
        self.texture = Texture()
        
        self.z = Card.Z
        Card.Z = chop(CGFloat(Card.Z - 2.0))

//        print("Card.init:  Initialized \(self.description)")
    }
    
    static var Red: Card { return Card(color: Color.red, direction: Direction.left) }
    static var Green: Card { return Card(color: Color.green, direction: Direction.right) }
    
    static func Reset() {
        
        ID = 0
        Z = DEFAULT_Z_POSITION__CARDS
        Deck = [Card.Red, Card.Green]
    }
    
    static func Random() -> Card {
        
        var color = Color.random()
        
        // Make sure we have all of them at least once.
        while (self.Deck.countWhere{ $0.color == color } > 0) { color = Color.random() }
        
        var direction = ((1...30).randomInt > 15) ? Direction.left : Direction.right
        
        if (self.Deck.count > 3) {
            // Make sure we have a bit of balance in directions.
            let mod: Int = (2...5).randomInt
            let leftCount = self.Deck.countWhere{ $0.direction == Direction.left }
            let rightCount = self.Deck.countWhere{ $0.direction == Direction.right }
            if ( (leftCount % mod) == 0 ) {
                direction = Direction.right
            }
            
            if (leftCount < (rightCount + 1)) { direction = Direction.left }
            if (rightCount < (leftCount + 1)) { direction = Direction.right }
        }
        
        let card = Card(color: color, direction: direction)
        
        self.Deck.append(card)
        
//        print("Card.Random:  Made random card:  [\(card.description)]")
//        print("Card.Random:  Card.Deck now contains \(Card.Deck.count) items.")
        
        return card
    }
    
    static func New(_ deckIndex: Int) -> Card {
        
        return Card(color: Card.Deck[deckIndex].color, direction: Card.Deck[deckIndex].direction)
    }
}

func ==(lhs: Card, rhs: Card) -> Bool {
    return lhs.color.rawValue == rhs.color.rawValue &&
        lhs.direction.rawValue == rhs.direction.rawValue
}
