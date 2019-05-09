//
//  CardNode.swift
//  RLGL
//
//  Created by Overlord on 8/11/17.
//  Copyright © 2017 ComingUpSevens, LLC. All rights reserved.
//

import SpriteKit
import Foundation

class CardNode: SKShapeNode {
    
    var thrown = false
    var rendered = false
    
    var card: Card?
    var canvas: SKShapeNode?
    
    init(_ card: Card) {
        super.init()
        
        self.card = card
        
        self.canvas = SKShapeNode(rectOf: DEFAULT_SIZE__80_PERCENT_WITH_AD)
        let shape = SKShapeNode(rectOf: DEFAULT_SIZE__80_PERCENT_WITH_AD, cornerRadius: 30)
        
        self.canvas?.name = "card_canvas__\(card.description)"
        
        self.canvas?.strokeColor = UIColor.clear
        self.canvas?.position = CGPoint(x: 0, y: 0)
        self.canvas?.zPosition = chop(card.z!)
        
        shape.name = "card_shape__\((self.card?.description)! )"
        
        shape.lineWidth = 6
        shape.strokeColor = .almostBlack
        shape.fillColor = (self.card?.color.displayColor)!
        
//        let rotation: StripesOrientation = (self.card?.direction == .left) ? .LeftToRight : .RightToLeft
//        let texture =  SKTexture.StripesTexture(size: shape.frame.size, rotation: rotation)
//        if texture != nil { shape.fillTexture = texture }
        
        shape.zPosition = chop((card.z! + CGFloat(0.00001)))
        
        self.canvas?.addChild(shape)
        
//        print("CardNode.init:  Initialized\n\ncard=\(card.description)\ncanvas z=\(canvas?.zPosition ?? 0.0)\nshape z=\(shape.zPosition)\n")
    }
    
    required init?(coder aDecoder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    
    func render() -> SKShapeNode {
        
        rendered = true
        return canvas!
    }
    
    func explode() {
        
        self.canvas?.physicsBody = SKPhysicsBody(rectangleOf: (canvas?.frame.size)!)

        let randomAngular = CGFloat(arc4random_uniform(3) + 1)
        let randomDistance = CGFloat(arc4random_uniform(25) + 5)
        
        let dt: CGFloat = 1.0/60.0
        let angular: CGFloat = (card?.direction == .left) ? (randomAngular * -1) : randomAngular
        let distance = CGVector(dx: (card?.direction == .left) ? randomDistance : (randomDistance * -1), dy: 0.5)
        
        let velocity = CGVector(dx: distance.dx/dt, dy: 0)
        
        self.canvas?.physicsBody?.isDynamic = true
        self.canvas?.physicsBody?.velocity = velocity
        self.canvas?.physicsBody?.categoryBitMask = 0
        self.canvas?.physicsBody?.collisionBitMask = 0
        self.canvas?.physicsBody?.contactTestBitMask = 0
        self.canvas?.physicsBody?.affectedByGravity = true
        self.canvas?.physicsBody?.angularVelocity = angular
    }
    
    func throwCard() {
        
        self.thrown = true
        self.canvas?.physicsBody = SKPhysicsBody(rectangleOf: (canvas?.frame.size)!)
        
        let dt: CGFloat = 1.0/60.0
        let angular: CGFloat = (card?.direction == .left) ? 3.0 : -3.0
        let distance = CGVector(dx: (card?.direction == .left) ? -50 : 50, dy: 0)

        let velocity = CGVector(dx: distance.dx/dt, dy: 0)
        
        self.canvas?.physicsBody?.isDynamic = true
        self.canvas?.physicsBody?.velocity = velocity
        self.canvas?.physicsBody?.affectedByGravity = true
        self.canvas?.physicsBody?.angularVelocity = angular
        
        Log.Message("Card.throwCard:  Threw away \((canvas?.name)!)")
    }
}
