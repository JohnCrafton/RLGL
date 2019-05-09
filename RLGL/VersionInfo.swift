//
//  VersionInfo.swift
//  RLGL
//
//  Created by Overlord on 9/19/17.
//  Copyright © 2017 ComingUpSevens, LLC. All rights reserved.
//

import Foundation

struct VersionInfo: Codable {
    
    let major: Int
    let minor: Int
    let build: Int
    
    private init() {
        
        let versionString = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as! String
        let buildString = Bundle.main.infoDictionary?["CFBundleVersion"] as! String
        let split = versionString.components(separatedBy: ".")
        
        major = Int(split[0])!
        minor = Int(split[1])!
        build = Int(buildString)!
    }
    
    init(major: Int, minor: Int, build: Int) {
        
        self.major = major
        self.minor = minor
        self.build = build
    }
    
//    init?(json: String) {
//
//        let deserialized = JSON(parseJSON: json)
//
//        self.major = deserialized["major"].intValue
//        self.minor = deserialized["minor"].intValue
//        self.build = deserialized["build"].intValue
//    }
    
    static var Current: VersionInfo { return VersionInfo() }
    
    var toJSON: String {
        return "{ \"major\": \(self.major), \"minor\": \(self.minor), \"build\": \(self.build) }"
    }
    
    static func == (lhs: VersionInfo, rhs: VersionInfo) -> Bool {
        
        return  lhs.major == rhs.major &&
            lhs.minor == rhs.minor &&
            lhs.build == rhs.build
    }
}
