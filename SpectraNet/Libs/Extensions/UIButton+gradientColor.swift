//
//  UIButton+gradientColor.swift
//  SpectraNet
//
//  Created by Bhoopendra on 7/11/19.
//  Copyright © 2019 Bhoopendra. All rights reserved.
//

import Foundation
import UIKit

extension UIViewController
{
    // button background gradient color
    class func testGradientButton(button: UIButton) -> Void {
        let gradientColor = CAGradientLayer()
        gradientColor.frame = button.frame
        gradientColor.colors = [UIColor(red: 243.0/255.0, green: 111.0/255.0, blue: 105.0/255.0, alpha: 1.0).cgColor,UIColor(red: 246.0/255.0, green: 141.0/255.0, blue: 110.0/255.0, alpha: 1.0).cgColor]
        button.layer.insertSublayer(gradientColor, at: 0)
    }
    
    // Get Button corner radius
    func setCornerRadiusButton(radius: Float, color: UIColor, button: UIButton)
    {
        button.layer.cornerRadius = CGFloat(radius) 
        button.clipsToBounds = true
        button.layer.borderWidth = 2
        button.layer.borderColor = color.cgColor
        
        let gradientColor = CAGradientLayer()
        gradientColor.frame = button.frame
        gradientColor.colors = [UIColor(red: 243.0/255.0, green: 111.0/255.0, blue: 105.0/255.0, alpha: 1.0).cgColor,UIColor(red: 246.0/255.0, green: 141.0/255.0, blue: 110.0/255.0, alpha: 1.0).cgColor]
        button.layer.insertSublayer(gradientColor, at: 0)
    }
}
