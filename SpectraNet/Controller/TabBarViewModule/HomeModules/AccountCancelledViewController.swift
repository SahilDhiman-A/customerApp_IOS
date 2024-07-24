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
}
