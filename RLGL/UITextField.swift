//
//  UITextField.swift
//  RLGL
//
//  Created by Overlord on 8/31/17.
//  Copyright © 2017 ComingUpSevens, LLC. All rights reserved.
//

import UIKit
import Foundation

extension UITextField: UITextFieldDelegate {
    
    static var Name: UITextField {
        
        let name = UITextField(frame: CGRect(x: 0, y: 0, width: 400, height: 75))
        
        name.backgroundColor = .white
        name.placeholder = "Friend of @Tonweight"
        name.autocorrectionType = .no
        name.textColor = .black
        name.keyboardType = .default
        name.clearButtonMode = .always
//        name.delegate = self
        
        return name
    }
    
    public func textFieldDidBeginEditing(_ textField: UITextField) {    //delegate method
        
    }
    
    public func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {  //delegate method
        return false
    }
    
    public func textFieldShouldReturn(_ textField: UITextField) -> Bool {   //delegate method
        textField.resignFirstResponder()
        
        return true
    }
}
