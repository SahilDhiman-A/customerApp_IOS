//
//  AccountActivationViewController.swift
//  SpectraNet
//
//  Created by Bhoopendra on 9/3/19.
//  Copyright © 2019 Bhoopendra. All rights reserved.
//

import UIKit

class AccountActivationViewController: UIViewController {
    @IBOutlet weak var butonView: UIView!
    
    //MARK: View controller life cycle
    override func viewDidLoad()
    {
        super.viewDidLoad()
        setCornerRadiusView(radius: Float(butonView.frame.height/2), color: UIColor.cornerBGFullOpack, view: butonView)
    }
    
    //MARK: Button Action
    @IBAction func clickCloasAppBTN(_ sender: Any)
    {
        HelpingClass.saveToUserDefault(value: false as AnyObject, key: "status")
        Switcher.updateRootVC()
    }
}
