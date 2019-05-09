//
//  LabelNode.swift
//  RLGL
//
//  Created by Overlord on 8/9/17.
//  Copyright © 2017 ComingUpSevens, LLC. All rights reserved.
//

import SpriteKit
import PureLayout
import Foundation

extension SKLabelNode {
    
    static var Standard: SKLabelNode {
        
        let label = SKLabelNode(text: "broken")
        
        label.color = UIColor.white
        label.fontName = DEFAULT_FONT_NAME
        label.fontSize = DEFAULT_FONT_SIZE
        
        label.verticalAlignmentMode = SKLabelVerticalAlignmentMode.center
        label.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.center
        
        return label
    }
    
    static func Text(text: String, fontName: String = DEFAULT_FONT_NAME) -> SKLabelNode {
        
        let label = SKLabelNode.Standard
        
        label.text = text
        label.fontName = fontName
        
        return label
    }
    
    static func InstrumentsLabel(text: String) -> SKLabelNode {
        
        let label = SKLabelNode.Standard
        
        label.text = text
        label.fontSize += 13
        label.fontName = "CourierNewPS-BoldMT"
        
        return label
    }
    
    static func Header(text: String) -> SKLabelNode {
        
        let label = SKLabelNode.Standard
        
        label.text = text
        label.fontSize = label.fontSize * 2
        label.fontName = DEFAULT_FONT_NAME_BOLD
        
        return label
    }
    
    static func Footer(text: String) -> SKLabelNode {
        
        let label = SKLabelNode.Standard
        
        label.text = text
        label.fontSize = label.fontSize / 2
        
        return label
    }
}
