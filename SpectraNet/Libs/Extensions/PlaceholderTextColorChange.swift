//
//  PlaceholderTextColorChange.swift
//  SpectraNet
//
//  Created by Bhoopendra on 7/12/19.
//  Copyright © 2019 Bhoopendra. All rights reserved.
//

import Foundation
import UIKit

extension UIViewController
{
    // This function used for set placeholder text color 
    func placeholderTextColor(textfeildName: UITextField, placeHolderText: String, withColor: UIColor)
    {
        textfeildName.attributedPlaceholder = NSAttributedString(string: placeHolderText,attributes: [NSAttributedString.Key.foregroundColor: withColor])
    }
    
    // use for hide keybord touch any where on view
    func setupKeyboardDismissRecognizer()
    {
        let tapRecognizer: UITapGestureRecognizer = UITapGestureRecognizer(
                  target: self,
                  action: #selector(dismissKeyboard))
              
        view.addGestureRecognizer(tapRecognizer)
    }
          
    @objc func dismissKeyboard()
    {
        view.endEditing(true)
    }
    
    // This function is used for add bottom line on textfield
    func bottomLineTextfield(textfield: UITextField)
    {
        let bottomLine = CALayer()
        bottomLine.frame = CGRect(x: 0.0, y: textfield.frame.height-1, width: textfield.frame.width, height: 1.0)
        bottomLine.backgroundColor = UIColor.gray.cgColor
        textfield.borderStyle = UITextField.BorderStyle.none
        textfield.layer.addSublayer(bottomLine)
    }
}

