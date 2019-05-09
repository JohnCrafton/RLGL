//
//  SKTexture.swift
//  RLGL
//
//  Created by Overlord on 8/30/17.
//  Copyright © 2017 ComingUpSevens, LLC. All rights reserved.
//

import SpriteKit
import Foundation

enum StripesOrientation: Int {
    
    case Vertical = 0, Horizontal, RightToLeft, LeftToRight
    
    var value: CGFloat {
        
        var output: CGFloat = 0.0
        switch self {
            
            case .Horizontal:
                output = CGFloat(90.0 * Double.pi / 180)
            case .RightToLeft:
                output = CGFloat(45.0 * Double.pi / 180)
            case .LeftToRight:
                output = CGFloat(-45.0 * Double.pi / 180)
            default:
                // Vertical.  No rotation.
                return 0.0
        }
        
        return output
    }
}

extension SKTexture {

    static func StripesTexture(size: CGSize, rotation: StripesOrientation, width: Int = 0) -> SKTexture? {

        guard let stripeFilter = CIFilter(name: "CIStripesGenerator") else {
            return nil
        }

        let colorOne = CIColor(color: UIColor.lightGray)
        let colorTwo = CIColor(color: UIColor.white)
        
        stripeFilter.setValue(colorOne, forKey: "inputColor0")
        stripeFilter.setValue(colorTwo, forKey: "inputColor1")
        
        if width > 0 {
            stripeFilter.setValue(width, forKey: "inputWidth")
        }
        
        let context = CIContext(options: nil)
        let rect = CGRect(x: 0, y: 0, width: size.width, height: size.height)

        guard let filterImage = stripeFilter.outputImage,
            let stripeImage = context.createCGImage(filterImage, from: rect) else {
                return nil
        }
        
        guard let rotationFilter = CIFilter(name: "CIStraightenFilter",
                                            withInputParameters: [
                                                kCIInputImageKey: CIImage(cgImage: stripeImage),
                                                "inputAngle": rotation.value
            ]) else {
                return nil
        }
        
        guard let rotationFilterImage = rotationFilter.outputImage,
            let finalImage = context.createCGImage(rotationFilterImage, from: rect) else {
                return nil
        }

        return SKTexture(cgImage: finalImage)
    }
}
