//
//  Utility.swift
//  RLGL
//
//  Created by Overlord on 7/27/17.
//  Copyright © 2017 ComingUpSevens, LLC. All rights reserved.
//

import SpriteKit
import Foundation

struct Vectors {
    
    let Up: CGVector = CGVector(dx: 0, dy: 100)
    let Down: CGVector = CGVector(dx: 0, dy: -100)

    let Left: CGVector = CGVector(dx: -100, dy: 0)
    let Right: CGVector = CGVector(dx: 100, dy: 0)
}

extension Sequence {
    
    func countWhere (condition: (Self.Iterator.Element) -> Bool) -> Int {
        return self.reduce(0, { (count, e) in count + (condition(e) ? 1 : 0) })
    }
}

extension Range {
    var randomInt: Int {
        get {
            return Utility.getRandomInt(lowerBound: lowerBound as! Int, upperBound: upperBound as! Int)
        }
    }
}

extension CountableClosedRange {
    var randomInt: Int {
        get {
            return Utility.getRandomInt(lowerBound: lowerBound as! Int, upperBound: upperBound as! Int)
        }
    }
}

extension Array where Element: Equatable {
    
    // Remove first collection element that is equal to the given `object`:
    mutating func remove(object: Element) {
        if let index = index(of: object) {
            remove(at: index)
        }
    }
}

struct Utility {

    static func getRandomInt(lowerBound: Int, upperBound: Int) -> Int {
        
        var offset = 0
        
        if (lowerBound) < 0   // allow negative ranges
        {
            offset = abs(lowerBound )
        }
        
        let mini = UInt32(lowerBound + offset)
        let maxi = UInt32(upperBound + offset)
        
        return Int(mini + arc4random_uniform(maxi - mini)) - offset
    }
}

// Stack/Queue foundation generic
class QNode<T> {
    
    var key: T?
    var next: QNode?
}

class Queue<T> {
    
    var top: QNode<T>!
    
    func enqueue(key: T) {
        
        if (top == nil) { top = QNode<T>() }
        
        if (top.key == nil) {

            top.key = key
            return
        }
        
        let child: QNode<T> = QNode<T>()
        var current: QNode = top
        
        while (current.next != nil) { current = current.next! }
        
        child.key = key
        current.next = child
    }
    
    func dequeue() -> T? {
        
        let topitem: T? = self.top?.key
        
        if (topitem == nil) {
            return nil
        }
        
        let queueitem: T? = top.key!
        
        if let nextitem = top.next {
            top = nextitem
        }
        else {
            top = nil
        }
        
        return queueitem
    }
    
    var count: Int {
        
        if (top.key == nil) {
            return 0
        } else  {
            
            var current: QNode<T> = top
            var x: Int = 1

            while (current.next != nil) {
                current = current.next!
                x += 1
            }

            return x
            
        }
    }

    func peek() -> T? {
        return top.key!
    }

    func isEmpty() -> Bool {
        
        if let _: T = self.top?.key {
            return false
        }
        else {
            return true
        }
        
    }
}

class Stack<T> {
    
    var top: QNode<T>!
    
    func push(key: T) {
        
        if (top == nil) { top = QNode<T>() }
        
        if (top.key == nil) {
            
            top.key = key
            return
        }
        
        let child: QNode<T> = QNode<T>()
        var current: QNode = top
        
        while (current.next != nil) { current = current.next! }
        
        child.key = key
        current.next = child
    }
    
    func pop() -> T? {
        
        let topitem: T? = self.top?.key
        
        if (topitem == nil) {
            return nil
        }
        
        let queueitem: T? = top.key!
        
        if let nextitem = top.next {
            top = nextitem
        }
        else {
            top = nil
        }
        
        return queueitem
    }
    
    var count: Int {
        
        if (top.key == nil) {
            return 0
        } else  {
            
            var current: QNode<T> = top
            var x: Int = 1
            
            while (current.next != nil) {
                current = current.next!
                x += 1
            }
            
            return x
            
        }
    }
    
    func peek() -> T? {
        return top.key!
    }
    
    func isEmpty() -> Bool {
        
        if let _: T = self.top?.key {
            return false
        }
        else {
            return true
        }
        
    }
}

func chop(_ value: CGFloat) -> CGFloat {
    return Darwin.round(value / CGFloat(0.00001)) * CGFloat(0.00001)
}

func formattedDate(_ epochTime: TimeInterval) -> String {
    
    let formatter = DateFormatter()
    formatter.dateFormat = "yyyy-MM-dd HH:mm"
    
    return formatter.string(from: Date(timeIntervalSince1970: epochTime))
}
