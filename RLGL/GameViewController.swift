//
//  GameViewController.swift
//  RLGL
//
//  Created by Overlord on 7/10/17.
//  Copyright © 2017 ComingUpSevens, LLC. All rights reserved.
//

import UIKit
import SpriteKit
import GameplayKit

class GameViewController: UIViewController, RLGLDelegate, UIGestureRecognizerDelegate {

    var scene: RLGLScene?
    var panPointReference:CGPoint?
    
    var rlgl:RLGL!
    
//    @IBOutlet var scoreLabel: UILabel!
//    @IBOutlet var levelLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Configure the view.
        let skView = view as! SKView
        
        skView.bounds = CGRect(x: 0, y: 0, width: 1080, height: 1920)

        // Options
        skView.showsFPS = true
        skView.showsNodeCount = true
        skView.ignoresSiblingOrder = true
        skView.isMultipleTouchEnabled = false
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        tap.numberOfTapsRequired = 1
        self.view.addGestureRecognizer(tap)
        
        let swipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(handleGesture))
        swipeLeft.direction = .left
        self.view.addGestureRecognizer(swipeLeft)
        
        let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(handleGesture))
        swipeRight.direction = .right
        self.view.addGestureRecognizer(swipeRight)
        
        rlgl = RLGL()
        rlgl.delegate = self
        
        // Create and configure the scene.
//        scene = GameScene(size: skView.bounds.size)
        scene = MenuScene()
        scene?.scaleMode = .aspectFill
        scene?.tick = didTick

//        rlgl.beginGame(scene: scene)
        
        // Present the scene.
        skView.presentScene(scene)
    }
    
    func handleTap(gesture: UITapGestureRecognizer) -> Void {
        if gesture.numberOfTouches >= gesture.numberOfTapsRequired {

            let location = gesture.location(ofTouch: 0, in: self.view)
            let convertedLocation = (view as! SKView).convert(location, to: scene!)

            userTapped(self.rlgl, convertedLocation)
        }
    }
    
    func handleGesture(gesture: UISwipeGestureRecognizer) -> Void {
        if gesture.direction == UISwipeGestureRecognizerDirection.right {
            print("Swiped Right")
            userSwipedRight(self.rlgl)
        }
        else if gesture.direction == UISwipeGestureRecognizerDirection.left {
            print("Swiped Left")
            userSwipedLeft(self.rlgl)
        }
    }
    
    override var prefersStatusBarHidden : Bool {
        return true
    }
    
//    @IBAction func didTap(_ sender: UITapGestureRecognizer) {
////        rlgl.rotateShape()
//    }
    
//    @IBAction func didPan(_ sender: UIPanGestureRecognizer) {
//        let currentPoint = sender.translation(in: self.view)
//        if let originalPoint = panPointReference {
//            if abs(currentPoint.x - originalPoint.x) > (BlockSize * 0.9) {
//                if sender.velocity(in: self.view).x > CGFloat(0) {
////                    swiftris.moveShapeRight()
//                    panPointReference = currentPoint
//                } else {
////                    swiftris.moveShapeLeft()
//                    panPointReference = currentPoint
//                }
//            }
//        } else if sender.state == .began {
//            panPointReference = currentPoint
//        }
//    }
    
//    @IBAction func swipedLeft(_ sender: UISwipeGestureRecognizer) {
//        userSwipedLeft(rlgl)
//    }
//    
//    @IBAction func swipedRight(_ sender: UISwipeGestureRecognizer) {
//        userSwipedRight(rlgl)
//    }
//    
//    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
//        return true
//    }
//    
//    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldBeRequiredToFailBy otherGestureRecognizer: UIGestureRecognizer) -> Bool {
//        if gestureRecognizer is UISwipeGestureRecognizer {
//            if otherGestureRecognizer is UIPanGestureRecognizer {
//                return true
//            }
//        } else if gestureRecognizer is UIPanGestureRecognizer {
//            if otherGestureRecognizer is UITapGestureRecognizer {
//                return true
//            }
//        }
//        return false
//    }
    
    func didTick() {
//        swiftris.letShapeFall()
//        rlgl.murderOrphans()
//        print("RLGL:  currentCard = \(rlgl.currentCard?.description ?? "none/broken")")
    }
    
    func gameDidBegin(_ rlgl: RLGL) {
//        levelLabel.text = "\(rlgl.level)"
//        scoreLabel.text = "\(rlgl.score)"
        scene?.tickLengthMillis = TickLengthLevelOne
//        scene.startTicking()
        
        // The following is false when restarting a new game
//        if rlgl.nextShape != nil && swiftris.nextShape!.blocks[0].sprite == nil {
//            scene.addPreviewShapeToScene(swiftris.nextShape!) {
//                self.nextShape()
//            }
//        } else {
//            nextShape()
//        }
    }
    
    func gameDidEnd(_ rlgl: RLGL) {
        view.isUserInteractionEnabled = false
        scene?.stopTicking()
//        scene.playSound(SoundFile.Bad)
//        scene.animateCollapsingLines(swiftris.removeAllBlocks(), fallenBlocks: swiftris.removeAllBlocks()) {
//            swiftris.beginGame()
//        }
//        rlgl.beginGame(scene: scene)
    }
    
    func gameDidLevelUp(_ rlgl: RLGL) {
//        levelLabel.text = "\(rlgl.level)"
        
        if (scene?.tickLengthMillis)! >= TimeInterval(100) {
            scene?.tickLengthMillis -= TimeInterval(100)
        } else if (scene?.tickLengthMillis)! > TimeInterval(50) {
            scene?.tickLengthMillis -= TimeInterval(50)
        }
        
//        scene.playSound(SoundFile.LevelUp)
    }
    
    func userTapped(_ rlgl: RLGL, _ location: CGPoint) {
        rlgl.tap(location)
    }
    
    func userSwipedLeft(_ rlgl: RLGL) {
        rlgl.testSwipe(direction: .left)
    }
    
    func userSwipedRight(_ rlgl: RLGL) {
        rlgl.testSwipe(direction: .right)
    }
    
    func logFailure(_ rlgl: RLGL) {
//        self.scene.playSound(SoundEffect.Bad.soundFile)
//        let sound = SoundEffect.Bad
//        self.scene.audio.playSoundEffect(named: sound.soundFile.filename)
    }
    
    func logSuccess(_ rlgl: RLGL) {
//        let sound = (rlgl.inStreak) ? SoundEffect.Great : SoundEffect.Good
//        self.scene.audio.playSoundEffect(named: sound.soundFile.filename)
//        self.scene.playSound(SoundFile.Good)
//        rlgl.resetTimer()
//        rlgl.updateTimer(circle: rlgl.timer!, steps: 60, duration: 5) {
//            self.rlgl.endGame()
//        }
    }
}
