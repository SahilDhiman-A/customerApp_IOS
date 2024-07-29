//
//  AccountCancelledViewController.swift
//  SpectraNet
//
//  Created by Bhoopendra on 9/9/19.
//  Copyright © 2019 Bhoopendra. All rights reserved.
//

import UIKit

class AccountCancelledViewController: UIViewController {
    @IBOutlet weak  var buttonView: UIView!
    
    @IBOutlet weak var logoutButtonHeight: NSLayoutConstraint!
    //MARK: View controller life cycle
    override func viewDidLoad()
    {
        super.viewDidLoad()
        setCornerRadiusView(radius: Float(buttonView.frame.height/2), color: UIColor.cornerBGFullOpack, view: buttonView)
    }
    
    //MARK: Button Action
    @IBAction func createSRBTN(_ sender: Any)
    {
        let vc = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: ViewIdentifier.CreateSRIdentifier) as? CreateSRViewController
        vc?.caseTypeStatus = SRCreateCreateCaseType.reactivateAccount
        vc?.caseTypeID = "7"
        vc?.accountCancceled = "cancelled"
        vc!.srActivationStatus = SRCreatedStatus.cancelledAcntToReactivate
        self.navigationController?.pushViewController(vc!, animated: false)
    }
    
    @IBAction func logoutAction(_ sender: Any) {
        
       
        HelpingClass.saveToUserDefault(value: false as AnyObject, key: "status")
        Switcher.updateRootVC()
    }
    
    override func viewWillLayoutSubviews() {
        
        if self.view.frame.height <= 568{
            
            logoutButtonHeight.constant = 45
        }
        
        super.viewWillLayoutSubviews()
        
    }
    
    @IBAction func myAccountClick(_ sender: Any) {
        let vc = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: ViewIdentifier.AccountIdentifier) as? AccountViewController
        vc?.fromScreen = FromScreen.deactivateScreen
        self.navigationController?.pushViewController(vc!, animated: false)
        
    }
}
