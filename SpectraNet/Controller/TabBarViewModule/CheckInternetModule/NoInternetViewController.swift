//
// NoInternetViewController.swift
// SpectraNet
//
// Created by Bhoopendra on 9/3/19.
// Copyright © 2019 Bhoopendra. All rights reserved.
//

import UIKit

class NoInternetViewController: UIViewController {
    @IBOutlet var butonView: UIView!
    var errorMsg = String()
    
    @IBOutlet weak var lblPlzTryAgainHeightCons: NSLayoutConstraint!
    @IBOutlet weak var lblPlzTryAgain: UILabel!
    @IBOutlet weak var lblErrorMsg: UILabel!
    
    //MARK: View controller life cycle
    override func viewDidLoad() {
        super.viewDidLoad()

        if errorMsg != ""
        {
            lblErrorMsg.text = errorMsg
            lblPlzTryAgainHeightCons.constant = 0
        }
        setCornerRadiusView(radius: Float(butonView.frame.height/2), color: UIColor.cornerBGFullOpack, view: butonView)
    }
    
    //MARK: Button Action
    @IBAction func clickTryAgainBTN(_ sender: Any)
    {
        self.navigationController?.popViewController(animated: false)
    }
}
