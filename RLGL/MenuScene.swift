
//  MenuScene.swift
//  RLGL
//
//  Created by Overlord on 8/7/17.
//  Copyright © 2017 ComingUpSevens, LLC. All rights reserved.
//

import SpriteKit
import Foundation
import PureLayout
import Crashlytics
import TwitterKit
import SCLAlertView

class MenuScene: BaseScene {
    
    override var name: String? { get { return MENU_SCENE_NAME } set { /* Do nothing. */ } }
    
    var isKonami: Bool = false
    var buttons: SKShapeNode! = nil
    var trackedTouch: UITouch! = nil
    let difficultyLabel: SKLabelNode = SKLabelNode.Standard
    let trademark: SKLabelNode = SKLabelNode.Footer(text: "™")
    let redLight: SKLabelNode = SKLabelNode.Header(text: "RED LIGHT")
    let greenLight: SKLabelNode = SKLabelNode.Header(text: "GREEN LIGHT")
    
    let A: ColorButton = StandardButtons.A.button()
    let B: ColorButton = StandardButtons.B.button()
//    let forum: ColorButton = MenuButtons.Forum.button()
    let start: ColorButton = MenuButtons.Start.button()
    let stats: ColorButton = MenuButtons.Stats.button()
    let info: ColorButton = StandardButtons.Info.button()
    let music: ColorButton = StandardButtons.Music.button()
//    let profile: ColorButton = MenuButtons.Profile.button()
    let settings: ColorButton = MenuButtons.Settings.button()
//    let purchase: ColorButton = MenuButtons.Purchase.button()
    let hourglass: ColorButton = MenuButtons.Difficulty.button()
    
    override func didMove(to view: SKView) {
        super.didMove(to: view)
        
        createButtons()
        prepareTextLogo()

        field.zPosition = 0
        field.fillColor = .darkGray
        field.fillTexture = SKTexture.StripesTexture(size: field.frame.size, rotation: .LeftToRight, width: 3)
        
        addChild(field)
        
        difficultyLabel.text = GameManager.shared.difficulty.description
        difficultyLabel.fontName = DEFAULT_FONT_NAME
        difficultyLabel.fontColor = .white
        difficultyLabel.position = DEFAULT_SIZE__MIDPOINT
        difficultyLabel.position.y = (1920 / 2) - 100
        difficultyLabel.zPosition = 99999
        difficultyLabel.fontSize += 25.0
        
        addChild(difficultyLabel)
        
        StoreManager.RequestReview()
    }
    
    override func update(_ currentTime: TimeInterval) {
        super.update(currentTime)
        
        if !self.isKonami { checkKonami() }
    }
    
    private func checkKonami() {

        if Konami.GO {

            let theRainbow: [SKColor] = [.red, .mutedRed, .orange, .yellow, .mutedGreen, .green, .blue, .purple ]
            let rainbowSequenceAction = SKAction.multipleColorTransitionActionForLabel(colors: theRainbow, duration: 1.0)
            let reverseRainbowSequenceAction = SKAction.multipleColorTransitionActionForLabel(colors: theRainbow.reversed(), duration: 1.0)
            
            self.redLight.run(SKAction.repeatForever(rainbowSequenceAction))
            self.greenLight.run(SKAction.repeatForever(reverseRainbowSequenceAction))
            
            self.isKonami = true
            self.A.isHidden = true
            self.B.isHidden = true
            
            print("should play 'Gradius' here...")
            // TODO:  get permission from Konami?
            // self.run(AudioManager.Great)
            self.run(AudioManager.Gradius)
        }
        
        if Konami.Yes && !Konami.GO {
            self.A.isHidden = false
            self.B.isHidden = false
        }
    }

    override func swipe(_ direction: Direction) {

        Konami.Swipe(direction)
        
        // TODO:  any other directional crap.
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {

        print("touching MenuScene")
        trackedTouch = touches.first
        
//        if profile.contains(trackedTouch.location(in: self)) { profile.touched() }
//        if forum.contains(trackedTouch.location(in: self)) { forum.touched() }
        if start.contains(trackedTouch.location(in: self)) { start.touched() }
        if stats.contains(trackedTouch.location(in: self)) { stats.touched() }
        if A.contains(trackedTouch.location(in: self)) { A.touched() }
        if B.contains(trackedTouch.location(in: self)) { B.touched() }
        if info.contains(trackedTouch.location(in: self)) { info.touched() }
        if music.contains(trackedTouch.location(in: self)) { music.touched() }
//        if !purchase.isDisabled && purchase.contains(trackedTouch.location(in: self)) { purchase.touched() }
        if hourglass.contains(trackedTouch.location(in: self)) { hourglass.touched() }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        print("stopped touching MenuScene")
        
//        if profile.state == .Highlighted { profile.released(profile.contains(trackedTouch.location(in: self))) }
//        if forum.state == .Highlighted { forum.released(forum.contains(trackedTouch.location(in: self))) }
        if start.state == .Highlighted { start.released(start.contains(trackedTouch.location(in: self))) }
        if stats.state == .Highlighted { stats.released(stats.contains(trackedTouch.location(in: self))) }
        if A.state == .Highlighted { A.released(A.contains(trackedTouch.location(in: self))) }
        if B.state == .Highlighted { B.released(B.contains(trackedTouch.location(in: self))) }
        if info.state == .Highlighted { info.released(info.contains(trackedTouch.location(in: self))) }
        if music.state == .Highlighted { music.released(music.contains(trackedTouch.location(in: self))) }
//        if !purchase.isDisabled && purchase.state == .Highlighted { purchase.released(purchase.contains(trackedTouch.location(in: self))) }
        if hourglass.state == .Highlighted { hourglass.released(hourglass.contains(trackedTouch.location(in: self))) }
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        print("cancelled touching MenuScene")

//        if profile.state == .Highlighted { profile.released(profile.contains(trackedTouch.location(in: self))) }
//        if forum.state == .Highlighted { forum.released(forum.contains(trackedTouch.location(in: self))) }
        if start.state == .Highlighted { start.released(start.contains(trackedTouch.location(in: self))) }
        if stats.state == .Highlighted { stats.released(stats.contains(trackedTouch.location(in: self))) }
        if A.state == .Highlighted { A.released(A.contains(trackedTouch.location(in: self))) }
        if B.state == .Highlighted { B.released(B.contains(trackedTouch.location(in: self))) }
        if info.state == .Highlighted { info.released(info.contains(trackedTouch.location(in: self))) }
        if music.state == .Highlighted { music.released(music.contains(trackedTouch.location(in: self))) }
//        if !purchase.isDisabled && purchase.state == .Highlighted { purchase.released(purchase.contains(trackedTouch.location(in: self))) }
        if hourglass.state == .Highlighted { hourglass.released(hourglass.contains(trackedTouch.location(in: self))) }
    }
    
    override func tap(_ location: CGPoint) { }
    
    private func prepareTextLogo() {

        redLight.fontColor = .red
        greenLight.fontColor = .green
        trademark.fontColor = .lightGray
        
        redLight.fontSize = 125
        greenLight.fontSize = 125
        trademark.fontSize = 42
        
        redLight.position = DEFAULT_SIZE__MIDPOINT
        greenLight.position = DEFAULT_SIZE__MIDPOINT
        trademark.position = DEFAULT_SIZE__MIDPOINT
        
        redLight.position.y += 400
        greenLight.position.y += 300

        trademark.position.x += 435
        trademark.position.y += 225

        self.addChild(redLight)
        self.addChild(greenLight)
        self.addChild(trademark)
    }
    
    private func setupAlertThing() {
        // Example of using the view to add two text fields to the alert
        // Create the subview
//        let appearance = SCLAlertView.SCLAppearance(
//            kTitleFont: UIFont(name: DEFAULT_FONT_NAME_BOLD, size: 16)!,
//            kTextFont: UIFont(name: DEFAULT_FONT_NAME, size: 12)!,
//            kButtonFont: UIFont(name: DEFAULT_FONT_NAME_BOLD, size: 14)!,
//            showCloseButton: false
//        )
//
//        // Initialize SCLAlertView using custom Appearance
//        let alert = SCLAlertView(appearance: appearance)
//
//        // Create the subview
//        let subview = UIView(frame: CGRect(x: 0, y: 0, width: 216, height: 140))
//        let x = (subview.frame.width - 200) / 2
//
//        // Add textfield 1
//        let textfield1 = UITextField(frame: CGRect(x: x, y: 10, width: 200, height: 25))
//        textfield1.layer.borderColor = UIColor.red.cgColor
//        textfield1.layer.borderWidth = 1.5
//        textfield1.layer.cornerRadius = 5
//        textfield1.placeholder = "Name"
//        textfield1.textAlignment = NSTextAlignment.center
//        textfield1.keyboardType = .default
//        textfield1.clearButtonMode = .whileEditing
//        if GameManager.shared.profile.name.isNotEmpty { textfield1.text = SceneManager.UserProfile.name }
//        subview.addSubview(textfield1)
//
//        // Add textfield 2
//        let textfield2 = UITextField(frame: CGRect(x: x, y: textfield1.frame.maxY + 10, width: 200, height: 25))
//        textfield2.layer.borderColor = UIColor.green.cgColor
//        textfield2.layer.borderWidth = 1.5
//        textfield2.layer.cornerRadius = 5
//        textfield2.placeholder = "Email"
//        textfield2.textAlignment = NSTextAlignment.center
//        textfield2.keyboardType = .emailAddress
//        textfield2.clearButtonMode = .whileEditing
//        if SceneManager.UserProfile.email.isNotEmpty { textfield2.text = SceneManager.UserProfile.email }
//        subview.addSubview(textfield2)
//
//        let twitterButton = TWTRLogInButton(logInCompletion: { session, error in
//            if (session != nil) {
//                Log.Message("signed in as \(session?.userName ?? "fucked")");
//
//                textfield1.text = session?.userName
//                self.saveProfile(alert, name: textfield1.text!, email: textfield2.text!)
//
//            } else {
//                Log.Message("error: \(error?.localizedDescription ?? "fucked")", .Error);
//            }
//        })
//
//        subview.addSubview(twitterButton)
//
//        twitterButton.autoPinEdge(.left, to: .left, of: subview)
//        twitterButton.autoPinEdge(.right, to: .right, of: subview)
//        twitterButton.autoPinEdge(.top, to: .bottom, of: textfield2, withOffset: 20.0)
//
//        // Add the subview to the alert's UI property
//        alert.customSubview = subview
//        alert.addButton("Save", backgroundColor: .mutedGreen, textColor: .white) {
//
//            self.saveProfile(alert, name: textfield1.text!, email: textfield2.text!)
//        }
//
//        // Add Button with Duration Status and custom Colors
//        alert.addButton("Cancel", backgroundColor: .mutedRed, textColor: .white) {
//            Log.Message("Profile cancel tapped")
//        }
//
//        alert.showInfo("Profile", subTitle: "Name and email address, please.")
    }
    
    private func saveProfile(_ alert: SCLAlertView, name: String, email: String) {
        
        GameManager.shared.profile.save()
        
        Log.Message("Saved profile.")
        
        alert.hideView()
    }
    
    private func createButtons() {
        
        buttons = SKShapeNode(rect: CGRect(x: 0, y: 300, width: 1080, height: 650))

        buttons?.lineWidth = 0
        
//        profile.setButtonFunction { self.setupAlertThing() }
//
//        forum.setButtonFunction {
//            let url = NSURL(string: "https://rlgl-forum.comingupsevens.com")!
//            UIApplication.shared.open(url as URL, options: [:], completionHandler: { (true) in
//                // do nothing?
//                Log.Message("in button function completion for forum button")
//            })
//        }
        
        start.setButtonFunction {
            GameManager.shared.reset()
            SceneManager.Viewport.presentScene(RLGLScene(), transition: SceneTransition.game.forward)
        }
        
        stats.setButtonFunction {
            SceneManager.Viewport.presentScene(ProfileScene(), transition: SceneTransition.profile.forward)
        }
        
        settings.setButtonFunction {
            SceneManager.Viewport.presentScene(SettingsScene(), transition: SceneTransition.settings.forward)
        }
        
        hourglass.setButtonFunction {
            let currentDifficulty = GameManager.shared.difficulty
            let newDifficulty = (currentDifficulty == .Unfair) ? .Casual :
                Difficulty(rawValue: (currentDifficulty?.rawValue)! + 1)
            
            GameManager.select(newDifficulty!)
            SceneManager.SelectedDifficulty = newDifficulty!

            self.difficultyLabel.text = GameManager.shared.difficulty.description
        }
        
        hourglass.label.text = "\(StandardButtons.Hourglass.character) " +
            "\(GameManager.shared.difficulty.buttonText)"
        
//        purchase.setButtonFunction {
//
//            self.purchase.disable()
//            self.displayPurchasePrompt()
//        }
        
        A.setButtonFunction { Konami.A = true }
        B.setButtonFunction { Konami.B = true }
        
//        addChild(self.profile)
//        addChild(self.forum)
        addChild(self.start)
        addChild(self.stats)
        addChild(self.hourglass)

        // Show purchase button if not purchased.
//        if !Profile.purchased { addChild(self.purchase) }

        let yMarker = (self.difficultyLabel.position.y - 300)
        
        self.hourglass.position.y   = yMarker
        self.stats.position.y       = yMarker - 150
//        self.profile.position.y     = yMarker - 300
//        self.forum.position.y       = yMarker - 450
//        self.purchase.position.y    = yMarker - 300
        
        buttons?.addChild(self.A)
        buttons?.addChild(self.B)
        
        self.A.isHidden = true
        self.B.isHidden = true
        
        addChild(buttons!)
        
        info.setButtonFunction {
            self.displayAbout()
            Log.Message("Info button clicked.")
            self.info.selectedColorCombo = (fill: .infoBlue, text: .white)
        }
        
        addChild(self.info)
        
        music.setButtonFunction {
            AudioManager.randomMusic()
        }
        
        addChild(self.music)
    }
    
    private func displayAbout() {
        
        let appearance = SCLAlertView.SCLAppearance(
            kTitleFont: UIFont(name: DEFAULT_FONT_NAME_BOLD, size: 16)!,
            kTextFont: UIFont(name: DEFAULT_FONT_NAME, size: 12)!,
            kButtonFont: UIFont(name: DEFAULT_FONT_NAME_BOLD, size: 14)!,
            showCloseButton: true,
            shouldAutoDismiss: false
        )
        
        // Initialize SCLAlertView using custom Appearance
        let alert = SCLAlertView(appearance: appearance)
        
        alert.showInfo("About RLGL", subTitle: "© 2017\nMade by Coming Up Sevens, LLC\nin Baltimore, Maryland.\n\n" +
            "For each colored dot, swipe cards of the same color away from the midline in the direction " +
            "indicated by the dot\n(ex.: red goes left; green goes right).\n\n" +
            "We collect and store gameplay data (no personally-identifying information is transmitted or stored) in order to craft a better experience.\n\n" +
            "Thanks very much for playing our game! ^_^")
        
        Answers.logContentView(withName: "About Page Viewed", contentType: "",
                               contentId: "aboutPage", customAttributes: [:])
    }
    
    private func displayPurchasePrompt() {
        
        let appearance = SCLAlertView.SCLAppearance(
            kTitleFont: UIFont(name: DEFAULT_FONT_NAME_BOLD, size: 16)!,
            kTextFont: UIFont(name: DEFAULT_FONT_NAME, size: 12)!,
            kButtonFont: UIFont(name: DEFAULT_FONT_NAME_BOLD, size: 14)!,
            showCloseButton: false,
            shouldAutoDismiss: false
        )

        // Initialize SCLAlertView using custom Appearance
        let alert = SCLAlertView(appearance: appearance)
        
        alert.addButton("Purchase Ad-free Version?", backgroundColor: .mutedGreen, textColor: .white) {

            let purchaseAlert = self.displayPurchaseAlert()
            
            Log.Message("Purchasing...")
            
            StoreManager.BuyAdFreeVersion() { status in
                
                if status == true {
                    
                    SceneManager.Controller.removeAdViews()

//                    self.purchase.isHidden = true

                    StoreManager.purchased = true
                    Profile.purchased = true
                    
                    GameManager.shared.profile.save()
                }
                else {
//                    self.purchase.enable()
                }
                
                purchaseAlert.hideView()
                alert.hideView()
            }
            
            Log.Message("Tutorial next pressed.")
        }
        
        alert.addButton("Cancel", backgroundColor: .mutedRed, textColor: .white) {
//            self.purchase.enable()
            alert.hideView()
        }
//
        alert.showInfo("Purchase RLGL", subTitle: "This purchase removes the ad banner from the bottom of the screen.")

        Answers.logContentView(withName: "Purchase Page Viewed", contentType: "",
                               contentId: "purchasePage", customAttributes: [:])
    }
    
    private func displayPurchaseAlert() -> SCLAlertView {
        
        let appearance = SCLAlertView.SCLAppearance(
            kTitleFont: UIFont(name: DEFAULT_FONT_NAME_BOLD, size: 16)!,
            kTextFont: UIFont(name: DEFAULT_FONT_NAME, size: 12)!,
            kButtonFont: UIFont(name: DEFAULT_FONT_NAME_BOLD, size: 14)!,
            showCloseButton: false,
            shouldAutoDismiss: false
        )
        
        // Initialize SCLAlertView using custom Appearance
        let alert = SCLAlertView(appearance: appearance)
        
        let customIcon = UIImage.fontAwesomeIcon(name: .money, textColor: .white, size: CGSize(width: 100, height: 100))
        alert.showCustom("Purchase in progress", subTitle: "Processing your purchase; please wait...", color: .mutedBlue, icon: customIcon)
        
        return alert
    }
}
