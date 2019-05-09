//
//  ComposeTweet.swift
//  RLGL
//
//  Created by Overlord on 9/29/17.
//  Copyright © 2017 ComingUpSevens, LLC. All rights reserved.
//

import TwitterKit
import Foundation

class SocialComposer {
    
    static func Tweet() {
        
        let composer = TWTRComposer()
//        Twitter.sharedInstance().logIn {
//            (session, error) -> Void in
//            if (session != nil) {
//                Log.Message("signed in as \(session?.userName ?? "twitter session fuckery")");
//            } else {
//                Log.Message("error: \(error?.localizedDescription ?? "twitter error fuckery")");
//            }
//        }
        
        composer.setText("I scored \(GameManager.shared.score.total) points, with a streak of " +
            "\(GameManager.shared.hits.streak) on \(GameManager.shared.difficulty.description) mode! " +
            "#RLGL https://appstore.com/rlgl")

        composer.setImage(UIImage(named: "twitterkit"))
        
        // Called from a UIViewController
        composer.show(from: SceneManager.Controller) {
            (result) in
                if (result == .done) {
                    Log.Message("Successfully composed Tweet")
                } else {
                    Log.Message("Cancelled composing")
                }
        }
    }
    
    static func FacebookPost() {
        Log.Message("Not implemented")
    }
}
