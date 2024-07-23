//
//  PaymentStatusViewController.swift
//  SpectraNet
//
//  Created by Bhoopendra on 9/2/19.
//  Copyright © 2019 Bhoopendra. All rights reserved.
//

import UIKit

class PaymentStatusViewController: UIViewController {

    @IBOutlet weak var statusImg: UIImageView!
    @IBOutlet weak var statusTitle: UILabel!
    @IBOutlet weak var statusMsg: UILabel!
    @IBOutlet weak var statusBTN: UILabel!
     var screenFrom = String()
    var succesMessage = ""
    var status = String()
    var payableAmount = String()
    @IBOutlet var buttonView: UIView!
    
    //MARK: View controller life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setCornerRadiusView(radius: Float(buttonView.frame.height/2), color: UIColor.cornerBGFullOpack, view: buttonView)

        if status == Payment.success_status
        {
            statusImg.image = UIImage(named: "checked")
            statusTitle.text = Payment.paymentSuccess_text
            statusTitle.textColor = UIColor.successPaymentColor
            statusMsg.text = String(format: "Your payment of INR %@ is Successfully received",payableAmount)
            statusBTN.text = Payment.paymentBtn_Success
        }
        else
        {
            statusImg.image = UIImage(named: "attention")
            statusTitle.text = Payment.paymentFailure_text
            statusTitle.textColor = UIColor.failurePaymentColor
            statusBTN.text = Payment.paymentBtn_Faluire
            statusMsg.text = Payment.paymentFailure_Message
        }
        
        if(succesMessage != ""){
            
             self.showAlertC(message: succesMessage)
        }
        
        
    }

    //MARK: Button Action
    @IBAction func clickButtonAction(_ sender: UIButton)
    {
        navigateScreen(identifier: ViewIdentifier.customTabIdentifier, controller: CustomTabViewController.self)
    }
}
