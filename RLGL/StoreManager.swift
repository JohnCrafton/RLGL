//
//  StoreManager.swift
//  RLGL
//
//  Created by Overlord on 10/20/17.
//  Copyright © 2017 ComingUpSevens, LLC. All rights reserved.
//

import StoreKit
import Crashlytics
import SwiftyStoreKit

class StoreManager {

    public static var purchased: Bool = false
    public static var restorable: Bool = false

    public static var adsActive: Bool = true
//    public static var adsActive: Bool {
//        get {
//            return !owned
//        }
//    }
    
    public static var owned: Bool {
        get {
            return purchased || restorable
        }
    }
    
    public static func RequestReview() {
        
        Log.Message("StoreManager.RequestReview():  Requesting review...")
        
        // Prompt for review after seven games.
        if Profiles.totalGames > 7 {
            SKStoreReviewController.requestReview()
            GameManager.shared.promptedForReview()
        }

        Log.Message("StoreManager.RequestReview():  Review requested.")
    }
    
    public static func CompleteTransactions() {
        
        // https://github.com/bizz84/SwiftyStoreKit
        // Complete any purchases using SwiftyStoreKit per recommendations (2017-10-24)
        SwiftyStoreKit.completeTransactions(atomically: true) { purchases in
            for purchase in purchases {
                if  purchase.transaction.transactionState == .purchased ||
                    purchase.transaction.transactionState == .restored {

                    if purchase.needsFinishTransaction {
                        // Deliver content from server, then:
                        SwiftyStoreKit.finishTransaction(purchase.transaction)
                    }

                    StoreManager.purchased = true
                    Profile.purchased = true
                    GameManager.shared.profile.save()
                    Log.Message("SwiftyStoreKit:  purchased - \(purchase)")
                }
            }
        }
    }
    
    public static func RestorePreviousPurchase() {
        
        SwiftyStoreKit.restorePurchases(atomically: true) { results in
            if results.restoreFailedPurchases.count > 0 {
                Log.Message("Restore Failed: \(results.restoreFailedPurchases)")
            }
            else if results.restoredPurchases.count > 0 {
                StoreManager.purchased = true
                Profile.purchased = true
                GameManager.shared.profile.save()
                Log.Message("Restore Success: \(results.restoredPurchases)")
            }
            else {
                Log.Message("Nothing to Restore")
            }
        }
    }
    
    // Just call a static method that bakes in the name of the purchase (since it's the only one).
    public static func BuyAdFreeVersion(completion: @escaping (_ status: Bool) -> Void) {
        
        SwiftyStoreKit.purchaseProduct(RLGLProducts.AdFree, quantity: 1, atomically: true) { result in

            switch result {

                case .success(let purchase):

                    Log.Message("Purchase Success: \(purchase.productId)")

                    StoreManager.purchased = true

                    completion(true)
                
                case .error(let error):

                    switch error.code {

                        case .unknown:
                            Log.Message("Unknown error. Please contact support", .Error)
                        case .clientInvalid:
                            Log.Message("Not allowed to make the payment", .Error)
                        case .paymentCancelled:
                            Log.Message("Cancelled.", .Warning)
                        case .paymentInvalid:
                            Log.Message("The purchase identifier was invalid", .Error)
                        case .paymentNotAllowed:
                            Log.Message("The device is not allowed to make the payment", .Error)
                        case .storeProductNotAvailable:
                            Log.Message("The product is not available in the current storefront", .Error)
                        case .cloudServicePermissionDenied:
                            Log.Message("Access to cloud service information is not allowed", .Error)
                        case .cloudServiceNetworkConnectionFailed:
                            Log.Message("Could not connect to the network", .Error)
                        case .cloudServiceRevoked:
                            Log.Message("User has revoked permission to use this cloud service", .Error)
                    }
                    
                    completion(false)
            }
        }
    }
}
