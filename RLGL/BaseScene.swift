//
//  BaseScene.swift
//  RLGL
//
//  Created by Overlord on 8/16/17.
//  Copyright © 2017 ComingUpSevens, LLC. All rights reserved.
//

import AudioKit
import SpriteKit
import PureLayout
import AVFoundation

// start at 500ms; tune with feedback
let TickLengthLevelOne = TimeInterval(500)

protocol SceneInteractivityDelegate {
    func tapped(_ location: CGPoint)
    func swiped(_ direction: Direction)
}

class BaseScene: SKScene {

    var sceneInteractivityDelegate: SceneInteractivityDelegate?

    var lastTick:Date?
    var tick:(() -> ())?
    var tickLengthMillis = TickLengthLevelOne

    let field = SKShapeNode(rect: CGRect(origin: CGPoint.zero, size: DEFAULT_SIZE__FULL_SCREEN))

    private var _container: SKView! = nil
    var container: SKView {
        get {
            if _container == nil {

                _container = SKView(frame: CGRect(x: 0, y: 0, width: 1080, height: 500))
                _container.backgroundColor = .blue
            }

            return _container
        }
    }

    required init?(coder aDecoder: NSCoder) { fatalError("init(coder:) has not been implemented") }

    override init(size: CGSize) { super.init(size: size) }

    override init() {
        super.init(size: DEFAULT_SCENE_SIZE)
    }

    override func didMove(to view: SKView) {
        super.didMove(to: view)

        self.backgroundColor = .yellow
        SceneManager.VersionLabelOn()
    }

    open func initializeContainer() { initializeContainer((height: 0.0, width: 0.0)) }

    open func initializeContainer(_ withOffset: (height: CGFloat, width: CGFloat)) {

        self.view?.addSubview(container)

        container.autoPinEdge(.left, to: .left, of: self.view!)
        container.autoPinEdge(.top, to: .top, of: self.view!, withOffset: 100.0)
        container.autoMatch(.width, to: .width, of: self.view!, withOffset: withOffset.width)
    }

    open func removeContainer() { container.removeFromSuperview(); _container = nil }

    func stopTicking() { lastTick = nil }
    func startTicking() { lastTick = Date() }

    func tap(_ location: CGPoint) { sceneInteractivityDelegate?.tapped(location) }
    func swipe(_ direction: Direction) { sceneInteractivityDelegate?.swiped(direction) }

    override func update(_ currentTime: TimeInterval) {

        /* Called before each frame is rendered */
        guard let lastTick = lastTick else {
            return
        }

        let timePassed = lastTick.timeIntervalSinceNow * -1000.0

        if timePassed > tickLengthMillis {

            self.lastTick = Date()
            tick?()
        }
    }
}
