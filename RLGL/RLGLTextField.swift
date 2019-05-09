//
//  RLGLTextField.swift
//  RLGL
//
//  Created by Overlord on 9/6/17.
//  Copyright © 2017 ComingUpSevens, LLC. All rights reserved.
//

import UIKit
import SpriteKit
import PureLayout
import Foundation
import TextFieldEffects

struct FrameOffsets {
    
    var top: CGFloat
    var left: CGFloat
    var right: CGFloat
    var bottom: CGFloat
    
    static var Default: FrameOffsets { get { return FrameOffsets(top: 5.0, left: 5.0, right: 5.0, bottom: 5.0) } }
    
    static func Custom(_ top: CGFloat, _ left: CGFloat, _ bottom: CGFloat, _ right: CGFloat) -> FrameOffsets {
        
        return FrameOffsets(top: top, left: left, right: bottom, bottom: right)
    }
}

class RLGLTextField {
    
    let FRAME_RECTANGLE = CGRect(x: 0, y: 0, width: 1080, height: 60)

    private var _frame: CGRect! = nil
    private var _container: SKView! = nil
    private var _textField: KaedeTextField! = nil
    
    var placeholder: String = "No Value"
    var frameOffsets: FrameOffsets = FrameOffsets.Default
    
    var frame: CGRect {
        get { if _frame == nil { _frame = FRAME_RECTANGLE }; return _frame }
        set { _frame = newValue }
    }
    
    var container: SKView {
        get {
            if _container == nil {
                
                _container = SKView(frame: frame)

                _container.isHidden = true
                _container.backgroundColor = .purple
            }
            
            return _container
        }
    }
    
    var field: KaedeTextField {
        get {
            if _textField == nil {
                
                _textField = KaedeTextField()
                _textField.placeholder = placeholder
            }
            
            return _textField
        }
    }
    
    var inputValue: String { get { return field.text! } }
    
    func toggleVisibility() { container.isHidden = !container.isHidden }
    
    static var Name: RLGLTextField { get { return RLGLTextField.Create("Name") } }
    static var Email: RLGLTextField { get { return RLGLTextField.Create("Email") } }
    
    static func Create(_ placeholder: String, frame: CGRect? = nil) -> RLGLTextField {
        
        let output = RLGLTextField()
        
        output.placeholder = placeholder
        output.frame = (frame == nil) ? output.FRAME_RECTANGLE : frame!
        
        output.container.addSubview(output.field)
        output.field.autoPinEdge(.top, to: .top, of: output.container, withOffset: output.frameOffsets.top)
        output.field.autoPinEdge(.left, to: .left, of: output.container, withOffset: output.frameOffsets.left)
        output.field.autoPinEdge(.right, to: .right, of: output.container, withOffset: output.frameOffsets.right)
        output.field.autoPinEdge(.bottom, to: .bottom, of: output.container, withOffset: output.frameOffsets.bottom)
        
        return output
    }
}
