//
//  UIColor.swift
//  RLGL
//
//  Created by Overlord on 8/15/17.
//  Copyright © 2017 ComingUpSevens, LLC. All rights reserved.
//

import UIKit

extension UIColor {
    
    open class var gold: UIColor { get { return UIColor(rgb: 0xcffcc00) } }
    open class var infoBlue: UIColor { get { return UIColor(rgb: 0xc5ac8fa) } }
    open class var mutedRed: UIColor { get { return UIColor(rgb: 0xc87d7d) } }
    open class var mutedBlue: UIColor { get { return UIColor(rgb: 0x7d7dc8) } }
    open class var mutedGreen: UIColor { get { return UIColor(rgb: 0x7dc87d) } }
    open class var mutedYellow: UIColor { get { return UIColor(rgb: 0xf2f2aa) } }
    open class var almostBlack: UIColor { get { return UIColor(rgb: 0x222222) } }
    open class var brightOrange: UIColor { get { return UIColor(rgb: 0xff7800) } }
    open class var brightYellow: UIColor { get { return UIColor(rgb: 0xfff500) } }
    
    convenience init(red: Int, green: Int, blue: Int) {
        assert(red >= 0 && red <= 255, "Invalid red component")
        assert(green >= 0 && green <= 255, "Invalid green component")
        assert(blue >= 0 && blue <= 255, "Invalid blue component")
        
        self.init(red: CGFloat(red) / 255.0, green: CGFloat(green) / 255.0, blue: CGFloat(blue) / 255.0, alpha: 1.0)
    }
    
    convenience init(rgb: Int) {
        self.init(
            red: (rgb >> 16) & 0xFF,
            green: (rgb >> 8) & 0xFF,
            blue: rgb & 0xFF
        )
    }
}
