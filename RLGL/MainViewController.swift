//
//  File.swift
//  RLGL
//
//  Created by Overlord on 8/15/17.
//  Copyright © 2017 ComingUpSevens, LLC. All rights reserved.

import AudioKit
import SpriteKit
import PureLayout
import Crashlytics
import SCLAlertView
import SwiftyStoreKit
import GoogleMobileAds
import Reachability

enum VersionLabelState { case On, Off }

class MainViewController:   UIViewController, UIGestureRecognizerDelegate,
                            SceneInteractivityDelegate, GADBannerViewDelegate {

    private var _alert: SCLAlertView! = nil
    private var _notice: UIAlertController! = nil

    var alert: SCLAlertView {
        get {
            if _alert == nil {

                let appearance = SCLAlertView.SCLAppearance(
                    kTitleFont: UIFont(name: DEFAULT_FONT_NAME_BOLD, size: 16)!,
                    kTextFont: UIFont(name: DEFAULT_FONT_NAME, size: 12)!,
                    kButtonFont: UIFont(name: DEFAULT_FONT_NAME_BOLD, size: 14)!,
                    showCloseButton: false
                )

                // Initialize SCLAlertView using custom Appearance
                _alert = SCLAlertView(appearance: appearance)
            }

            return _alert
        }
    }

    private let reachability: Reachability! = Reachability()

    var contentView: SKView!
    var bannerView: GADBannerView!
    var versionLabel: UILabel! = nil

    override func viewDidLoad() {
        super.viewDidLoad()

        SceneManager.Controller = self

        if StoreManager.adsActive { prepareAdView() }

        prepareAudio()
        prepareGameView()

        self.view.bringSubview(toFront: self.bannerView)

        // Options
        SceneManager.Viewport.showsFPS = DEBUG_MODE
        SceneManager.Viewport.showsNodeCount = DEBUG_MODE
        SceneManager.Viewport.ignoresSiblingOrder = true
        SceneManager.Viewport.isMultipleTouchEnabled = false

        presentMenuScene()
    }

    func removeAdViews() {

        self.bannerView.removeFromSuperview()

        if versionLabel != nil {
            versionLabel.autoPinEdge(ALEdge.bottom, to: .bottom, of: self.contentView)
        }

//        NotificationCenter.default.removeObserver(reachability)
    }

    override func viewDidAppear(_ animated: Bool) { doReachability() }

    private func presentMenuScene() { SceneManager.Viewport.presentScene(MenuScene()) }

    private func presentOfflineAlert() {

        Answers.logCustomEvent(withName: "Connection Interrupted", customAttributes: [:])
        self.present(_notice, animated: true) { Log.Message("fuckery") }
    }

    private func doReachability() {

        NotificationCenter.default.addObserver(self, selector: #selector(self.reachabilityChanged),
                                               name: Notification.Name.reachabilityChanged,
                                               object: reachability)

        do {
            try reachability.startNotifier()
        } catch {
            Log.Message("could not start reachability notifier")
        }
    }

    @objc private func reachabilityChanged(note: Notification) {

        if StoreManager.owned { return }

        let reachability = note.object as! Reachability
        if reachability.connection == .none {
            Log.Message("network unreachable")
            self.showNoConnectionAlert()
            self.view.isUserInteractionEnabled = false
        } else {
            Log.Message("reachable again")
            self.dismissNoConnectionAlert()
            self.view.isUserInteractionEnabled = true
        }
    }

    private func showNoConnectionAlert() {
        Answers.logCustomEvent(withName: "Connection Interrupted", customAttributes: [:])
        _alert = nil
        self.alert.showError(ALERT_MESSAGE_NO_CONNECTION.title, subTitle: ALERT_MESSAGE_NO_CONNECTION.message)
//        DispatchQueue.main.async(execute: {
//            self.alert.showError(ALERT_MESSAGE_NO_CONNECTION.title, subTitle: ALERT_MESSAGE_NO_CONNECTION.message)
//        })
    }

    private func dismissNoConnectionAlert() {
        if _alert == nil { return }
        alert.hideView()
        _alert = nil
        let timeout = SCLAlertView.SCLTimeoutConfiguration(timeoutValue: TimeInterval(3.0)) {
            self.alert.hideView()
        }
        self.alert.showSuccess("Connection Restored", subTitle: "Thanks!", timeout: timeout)
//        DispatchQueue.main.async(execute: {
//            self.alert.showSuccess("Connection Restored", subTitle: "Thanks!")
//        })
    }

    private func prepareOfflineNotice() {

        Log.Message("trying no connection alert guy")

        _notice = UIAlertController(title: ALERT_MESSAGE_NO_CONNECTION.title,
                                    message: ALERT_MESSAGE_NO_CONNECTION.message,
                                    preferredStyle: .alert)

        let retry = UIAlertAction(title: "Retry?", style: .default) {
            action in
            Log.Message("The \"Retry\" alert occured.")

            sleep(3)

            if self.reachability.connection != .none {
                self.presentMenuScene()
                return
            }

            self.presentOfflineAlert()
        }

        _notice.addAction(retry)
    }

    private func prepareAdView() {

        self.bannerView = GADBannerView(adSize: kGADAdSizeFullBanner)

        self.bannerView.delegate = self
        self.bannerView.rootViewController = self

        if DEBUG_MODE {
            self.bannerView.adUnitID = "dev_key"
        } else {
            self.bannerView.adUnitID = "prod_key"
        }

        self.view.addSubview(self.bannerView)

        self.bannerView.autoPinEdge(toSuperviewEdge: ALEdge.bottom)
        self.bannerView.autoMatch(ALDimension.width, to: ALDimension.width, of: view)

        self.bannerView.load(GADRequest())

        let barrierHeight = (self.view.frame.height / 100)
        let bannerBarrier = UIView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: barrierHeight))

        bannerBarrier.backgroundColor = .mutedGreen

        self.view.addSubview(bannerBarrier)

        bannerBarrier.autoPinEdge(ALEdge.bottom, to: ALEdge.top, of: bannerView)
        bannerBarrier.autoPinEdge(ALEdge.left, to: ALEdge.left, of: self.view)
    }

    private func prepareGameView() {

        Log.Message("GameManager starting... \(GameManager.shared.difficulty)")
        self.contentView = SKView(frame: CGRect(origin: CGPoint.zero, size: DEFAULT_SIZE__FULL_SCREEN))

        self.view.addSubview(self.contentView)

        self.contentView.autoPinEdgesToSuperviewEdges()

        // Version label
        let version = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as! String
        let buildNumber = Bundle.main.infoDictionary?["CFBundleVersion"] as! String

        versionLabel = UILabel(frame: CGRect(x: 0, y: 0, width: 50, height: 15))

        versionLabel.isHidden = true
        versionLabel.text = "v\(version).\(buildNumber) "
        versionLabel.textColor = .lightGray
        versionLabel.font = UIFont(name: DEFAULT_FONT_NAME, size: 10.0)

        self.contentView.addSubview(versionLabel)

        versionLabel.autoPinEdge(ALEdge.left, to: ALEdge.left, of: self.contentView)

        let versionPosition = (GameManager.shared.purchased) ? ALEdge.bottom : ALEdge.top
        let versionTarget = (GameManager.shared.purchased) ? self.contentView : self.bannerView

        versionLabel.autoPinEdge(ALEdge.bottom, to: versionPosition, of: versionTarget)

        // -- Gesture recognition --
        let tap = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        tap.numberOfTapsRequired = 1
        SceneManager.Viewport.addGestureRecognizer(tap)

        let swipeUp = UISwipeGestureRecognizer(target: self, action: #selector(handleGesture))
        swipeUp.direction = .up
        SceneManager.Viewport.addGestureRecognizer(swipeUp)

        let swipeDown = UISwipeGestureRecognizer(target: self, action: #selector(handleGesture))
        swipeDown.direction = .down
        SceneManager.Viewport.addGestureRecognizer(swipeDown)

        let swipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(handleGesture))
        swipeLeft.direction = .left
        SceneManager.Viewport.addGestureRecognizer(swipeLeft)

        let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(handleGesture))
        swipeRight.direction = .right
        SceneManager.Viewport.addGestureRecognizer(swipeRight)
    }

    internal func toggleVersionLabel(_ state: VersionLabelState) {
        if versionLabel == nil { return }

        versionLabel.isHidden = (state == .Off)
    }

    private func prepareAudio() {

//        AudioManager.PlayTheme()
        let music = Music.random
        let musicfileType = (music == Music.ArcadeFunk) ? "mp3" : "wav"

        let player = AudioManager.audio.play(file: music.soundFile.filename, type: musicfileType)
        AudioKit.output = player
        AudioKit.start()
        player?.looping = true
        player?.play()
    }

    func tapped(_ location: CGPoint) { SceneManager.Scene.tap(location) }
    func swiped(_ direction: Direction) { SceneManager.Scene.swipe(direction) }

    @objc func handleTap(gesture: UITapGestureRecognizer) -> Void {
        if gesture.numberOfTouches >= gesture.numberOfTapsRequired {

            let location = gesture.location(ofTouch: 0, in: self.view)
            let convertedLocation = SceneManager.Viewport.convert(location, to: SceneManager.Viewport.scene!)
//            print("tapped @ \(location)|\(convertedLocation)")
//            print("tapped @ \(location)")

            tapped(convertedLocation)
//            tapped(location)
        }
    }

    @objc func handleGesture(gesture: UISwipeGestureRecognizer) -> Void {

        switch gesture.direction {

        case UISwipeGestureRecognizerDirection.up:
            Log.Message("Swiped Up")
            swiped(.up)
            break
        case UISwipeGestureRecognizerDirection.down:
            Log.Message("Swiped Down")
            swiped(.down)
            break
        case UISwipeGestureRecognizerDirection.right:
            Log.Message("Swiped Right")
            swiped(.right)
            break
        case UISwipeGestureRecognizerDirection.left:
            Log.Message("Swiped Left")
            swiped(.left)
            break
        default:
            Log.Message("swipes are fucked")
            break
        }
    }

    // Tells the delegate an ad request loaded an ad.
    func adViewDidReceiveAd(_ bannerView: GADBannerView) {
        Log.Message("adViewDidReceiveAd")
        Log.Message("animating...")
        bannerView.alpha = 0
        UIView.animate(withDuration: 1, animations: {
            bannerView.alpha = 1
        })
        Log.Message("animated.")
    }

    // Tells the delegate an ad request failed.
    func adView(_ bannerView: GADBannerView,
                didFailToReceiveAdWithError error: GADRequestError) {
        Log.Message("adView:didFailToReceiveAdWithError: \(error.localizedDescription)")
    }

    // Tells the delegate that a full screen view will be presented in response
    // to the user clicking on an ad.
    func adViewWillPresentScreen(_ bannerView: GADBannerView) {
        Log.Message("adViewWillPresentScreen")
    }

    // Tells the delegate that the full screen view will be dismissed.
    func adViewWillDismissScreen(_ bannerView: GADBannerView) {
        Log.Message("adViewWillDismissScreen")
    }

    // Tells the delegate that the full screen view has been dismissed.
    func adViewDidDismissScreen(_ bannerView: GADBannerView) {
        Log.Message("adViewDidDismissScreen")
    }

    // Tells the delegate that a user click will open another app (such as
    // the App Store), backgrounding the current app.
    func adViewWillLeaveApplication(_ bannerView: GADBannerView) {
        Log.Message("adViewWillLeaveApplication")
    }
}
