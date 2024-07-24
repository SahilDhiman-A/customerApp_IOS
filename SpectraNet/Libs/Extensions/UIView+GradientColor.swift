//
//  UIView+GradientColor.swift
//  SpectraNet
//
//  Created by Bhoopendra on 7/12/19.
//  Copyright © 2019 Bhoopendra. All rights reserved.
//

import Foundation
import UIKit

extension UIViewController
{
    // This function used for View corner radius Round
    func setCornerRadiusView(radius: Float, color: UIColor, view: UIView)
    {
        view.layer.cornerRadius = CGFloat(radius)
        view.clipsToBounds = true
        view.layer.borderWidth = 2
        view.layer.borderColor = color.cgColor
    }
    
    func setBelowlineColor(below1stTabLine: UILabel, withColor: UIColor, below2ndTabLine: UILabel, withColor2: UIColor,btn1stTab: UIButton, with1stBtnTabColor: UIColor, btn2ndTab: UIButton, with2ndBtnTabColor: UIColor, setstatus: String, toLabel: UILabel)
    {
        below1stTabLine.backgroundColor = withColor
        below2ndTabLine.backgroundColor = withColor2
        btn1stTab.setTitleColor(with1stBtnTabColor, for:UIControl.State.normal)
        btn2ndTab.setTitleColor(with2ndBtnTabColor, for:UIControl.State.normal)
        toLabel.text = setstatus
    }
}

extension UIColor
{
    static let bgColors = UIColor(red:255/255, green:108/255 ,blue:102/255, alpha:1.00)
    static let viewBackgroundFullOpack = UIColor(red:246/255, green:122/255 ,blue:133/255, alpha:1.00)
    static let viewBackgroundHalfOpack = UIColor(red:246/255, green:122/255 ,blue:133/255, alpha:0.9)
    static let cornerBGFullOpack = UIColor(red: 229.0/255.0, green: 105.0/255.0, blue: 97.0/255.0, alpha: 1.0)
    static let bgHalfOpackWithWhite = UIColor(red:255/255, green:255/255 ,blue:255/255, alpha:0.7)
    static let bgDataFillColor = UIColor(red: 224/255.0, green: 98/255.0, blue: 96/255.0, alpha: 1)

    static let successPaymentColor = UIColor(red: 106/255.0, green: 194/255.0, blue: 89/255.0, alpha: 1)
    static let failurePaymentColor = UIColor(red: 255/255.0, green: 74/255.0, blue: 74/255.0, alpha: 1)
    
    // profile Screen
    static let imageIcnTintColor = UIColor(red: 216/255.0, green: 18/255.0, blue: 18/255.0, alpha: 0.6)
    static let imagefrwdTintColor = UIColor(red: 61/255.0, green: 61/255.0, blue: 61/255.0, alpha: 1)


}

extension UIView {
    
    func roundCorners(_ corners: UIRectCorner, radius: CGFloat)
    {
        let path = UIBezierPath(roundedRect: self.bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        let mask = CAShapeLayer()
        mask.path = path.cgPath
        self.layer.mask = mask
    }
    
    func fadeIn(duration: TimeInterval = 0.9, delay: TimeInterval = 0.0, completion: @escaping ((Bool) -> Void) = {(finished: Bool) -> Void in })
    {
        self.alpha = 0.0
        
        UIView.animate(withDuration: duration, delay: delay, options: UIView.AnimationOptions.curveEaseIn, animations: {
            self.isHidden = false
            
            self.alpha = 1.0
        }, completion: completion)
    }
    
    func fadeOut(duration: TimeInterval = 0.8, delay: TimeInterval = 0.0, completion: @escaping (Bool) -> Void = {(finished: Bool) -> Void in }) {
        self.alpha = 1.0
        
        UIView.animate(withDuration: duration, delay: delay, options: UIView.AnimationOptions.curveEaseIn, animations: {
            self.alpha = 0.0
        }) { (completed) in
            self.isHidden = true
            completion(true)
        }
    }
}



