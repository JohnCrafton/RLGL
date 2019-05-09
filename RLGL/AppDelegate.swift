//
//  AppDelegate.swift
//  RLGL
//
//  Created by Overlord on 7/10/17.
//  Copyright © 2017 ComingUpSevens, LLC. All rights reserved.
//

import UIKit
import Fabric
import Firebase
import TwitterKit
import Crashlytics
import SwiftyStoreKit
import GoogleMobileAds

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    private var _hasConnection: Bool = false
//    internal let reachability: Reachability! = Reachability()

    private var _mainViewController: MainViewController! = nil

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.

        StoreManager.CompleteTransactions()
//        StoreManager.RestorePreviousPurchase()

        // Twitter stuff.  // TODO:  maybe push these secrets into some sort of build file?
        Twitter.sharedInstance().start(withConsumerKey:"key",
                                       consumerSecret:"secret")

        // TODO:  Set USER_DEFAULTS defaults

        // Initialize Firebase
        FirebaseApp.configure()

        // Initialize Fabric/Crashlytics
        Fabric.with([Crashlytics.self])

        if StoreManager.adsActive {
            // Initialize the Google Mobile Ads SDK.
            // Sample AdMob app ID: ca-app-pub-3940256099942544~1458002511
            if DEBUG_MODE {
                GADMobileAds.configure(withApplicationID: "debug_key")
            } else {
                GADMobileAds.configure(withApplicationID: "prod_key")
            }
        }

//        prepareGameAnalytics()

        // Create our initial app view.
        window = UIWindow(frame: UIScreen.main.bounds)

        _mainViewController = MainViewController()

        window!.rootViewController = _mainViewController
        window!.makeKeyAndVisible()

        return true
    }

    func application(_ app: UIApplication, open url: URL, options: [UIApplicationOpenURLOptionsKey : Any] = [:]) -> Bool {
        return Twitter.sharedInstance().application(app, open: url, options: options)
    }

    private func prepareGameAnalytics() {

        if DEBUG_MODE {
            // Enable log to output simple details (disable in production)
//            GameAnalytics.setEnabledInfoLog(true)
            // Enable log to output full event JSON (disable in production)
//            GameAnalytics.setEnabledVerboseLog(true)
        }

        // Example: configure available virtual currencies and item types for later use in resource events
        // GameAnalytics.configureAv$ailableResourceCurrencies(["gems", "gold"])
        // GameAnalytics.configureAvailableResourceItemTypes(["boost", "lives"])

        // Example: configure available custom dimensions for later use when specifying these
        // GameAnalytics.configureAvailableCustomDimensions01(["ninja", "samurai"])
        // GameAnalytics.configureAvailableCustomDimensions02(["whale", "dolphin"])
        // GameAnalytics.configureAvailableCustomDimensions03(["horde", "alliance"])

        // Configure build version
//        let version = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as! String
//        GameAnalytics.configureBuild("\(version)")

        // initialize GameAnalytics - this method will use app keys injected by Fabric
//        GameAnalytics.initializeWithConfiguredGameKeyAndGameSecret()

        // to manually specify keys use this method:
        //GameAnalytics.initializeWithGameKey("[game_key]", gameSecret:"[game_secret]")
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.

        // TODO:  save and create pause state
        USER_DEFAULTS.synchronize()
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.

        // TODO:  background stuff
        USER_DEFAULTS.synchronize()
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.

        // TODO:  load pause state
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.

        // TODO:  verify and unpause
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        USER_DEFAULTS.synchronize()
    }
}
