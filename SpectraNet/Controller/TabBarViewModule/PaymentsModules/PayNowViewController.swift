//
//  PayNowViewController.swift
//  SpectraNet
//
//  Created by Bhoopendra on 8/12/19.
//  Copyright © 2019 Bhoopendra. All rights reserved.
//

import UIKit

class PayNowViewController: UIViewController,UITextFieldDelegate {
    
   
    @IBOutlet weak var payAmountPlaceHoderLabel: UILabel!
    @IBOutlet weak var ourstandingAmtD: UILabel!
    @IBOutlet weak var lblOutstandinAmount: UILabel!
    @IBOutlet weak var outStandingTF: UITextField!
    @IBOutlet weak var proceedBTN: UIButton!
    @IBOutlet weak var proceedBTNView: UIView!
    @IBOutlet weak var tdsView: UIView!
    @IBOutlet weak var tdsViewHeightConstant: NSLayoutConstraint!
    @IBOutlet weak var tdsAmountTF: UITextField!
    @IBOutlet weak var lblTdsPercent: UILabel!
    @IBOutlet weak var lbTdsSign: UILabel!
    @IBOutlet weak var enterTDSLbl: UILabel!
   
    var payNowVC = String()
    var outStandingAmt = String()
    var paymentStr = String()
    var canID = String()
    var sessionTime = String()
    var tdsAmount = String()
    var tdsPercent = String()
    var screenFrom = String()
    
    var mobileNoStr = ""
    var emailStr = ""
    var isForMultiPleAccount = false
    
    var topupName = String()
    var topupType = String()
    var  pckgID  = String()
     var tdsAmountPerMonth = String()
    
    //MARK: View controller life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        lblTdsPercent.text = String(format: "( upto %@ of billed amount )", tdsPercent)
        outStandingAmt =  convertStringtoFloatViceversa(amount: outStandingAmt)
        if screenFrom==FromScreen.topUpScreen
        {
            outStandingTF.isUserInteractionEnabled = false
            ourstandingAmtD.text = "Payable Amount"
            payAmountPlaceHoderLabel.text = "Amount to pay – (Top-up Rental + 18% Taxes)"
        }
        
        if outStandingAmt == ""
        {
            lblOutstandinAmount.text = "0"
            outStandingTF.text = "0"
           
        }
        else
        {
           lblOutstandinAmount.text = convertStringtoFloatViceversa(amount: outStandingAmt)
            lblOutstandinAmount.text = String(format: "%@ %@",SignINR.ruppes,outStandingAmt)
            outStandingTF.text = convertStringtoFloatViceversa(amount: outStandingAmt)
        }
        tdsAmountTF.text = ""
        
        if tdsAmount==""
        {
            tdsViewHeightConstant.constant = 0
            tdsAmountTF.isHidden = true
            lbTdsSign.isHidden = true
            enterTDSLbl.isHidden = true
            lblTdsPercent.isHidden = true
        }
        else
        {
            tdsAmountTF.text = tdsAmount
        }
        tdsAmountTF.delegate = self
        outStandingTF.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool)
    {
        super.viewWillAppear(animated)
        setCornerRadiusView(radius: Float(proceedBTNView.frame.height/2), color: UIColor.cornerBGFullOpack, view: proceedBTNView)
        let currentTime = HelpingClass.sharedInstance.getCurrentMillis()
        sessionTime = canID + String(describing: currentTime)
        paymentStr = outStandingAmt
    }
    
    //MARK: Button Actions
    @IBAction func proceedClick(_ sender: Any)
    {
        if tdsAmount == ""
        {
            paymentStr = outStandingTF.text ?? ""
            let vc = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: ViewIdentifier.paymentScreenIdentifier) as? PaymentScreenViewController
            vc?.paymentStr = outStandingTF.text ?? ""
            vc?.tdsAmount = outStandingTF.text ?? ""
            vc?.sessionTime = sessionTime
            vc?.canID = canID
            if(isForMultiPleAccount == true){
            vc?.mobileNoStr = self.mobileNoStr
            vc?.emailStr = self.emailStr
            vc?.isForMultiPleAccount = true
            }
            
            if(screenFrom == FromScreen.topUpScreen){
                
                vc?.topupName = topupName
                vc?.topupType = topupType
                vc?.screenFrom = screenFrom
                
                vc?.tdsAmountPerMonth = tdsAmountPerMonth
            }else if(screenFrom == FromScreen.changeTopUPScreen || screenFrom == FromScreen.CompareTopUPScreen){
                vc?.screenFrom = screenFrom
                vc?.tdsAmountPerMonth = tdsAmountPerMonth
                vc?.pckgID = pckgID
            }
            
            vc?.tdsAmount = tdsAmountTF.text ?? ""
            self.navigationController?.pushViewController(vc!, animated: false)
        }
        else
        {
            let totalTds = (tdsAmount as NSString).floatValue
            let enterTds = (tdsAmountTF.text! as NSString).floatValue

            if totalTds >= enterTds
            {
                paymentStr = outStandingTF.text ?? ""
                let vc = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: ViewIdentifier.paymentScreenIdentifier) as? PaymentScreenViewController
                vc?.paymentStr = outStandingTF.text ?? ""
                vc?.sessionTime = sessionTime
                vc?.canID = canID
                if tdsAmountTF.text == ""
                {
                    tdsAmountTF.text = "0"
                }
                if(isForMultiPleAccount == true){
                    vc?.mobileNoStr = self.mobileNoStr
                    vc?.emailStr = self.emailStr
                    vc?.isForMultiPleAccount = true
                }
                if(screenFrom == FromScreen.topUpScreen){
                    vc?.topupName = topupName
                    vc?.topupType = topupType
                    vc?.screenFrom = screenFrom
                    vc?.tdsAmountPerMonth = tdsAmountPerMonth
                    
                }else if(screenFrom == FromScreen.changeTopUPScreen || screenFrom == FromScreen.CompareTopUPScreen){
                    vc?.screenFrom = screenFrom
                    vc?.tdsAmountPerMonth = tdsAmountPerMonth
                    vc?.pckgID = pckgID
                }
                vc?.tdsAmount = tdsAmountTF.text ?? ""
                self.navigationController?.pushViewController(vc!, animated: false)
            }
            else
            {
                showAlertC(message: ErrorMessages.maxLimitAmount)
            }
        }
        tdsAmountTF.resignFirstResponder()
        outStandingTF.resignFirstResponder()
    }

    @IBAction func backBTN(_ sender: Any)
    {
        self.navigationController?.popViewController(animated: false)
    }
    
    //MARK: Get unic Time
    
   
    //MARK: TextField delegate
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let oldText = textField.text, let r = Range(range, in: oldText) else {
            return true
        }
        
        let newText = oldText.replacingCharacters(in: r, with: string)
        let isNumeric = newText.isEmpty || (Double(newText) != nil)
        let numberOfDots = newText.components(separatedBy: ".").count - 1
        
        let numberOfDecimalDigits: Int
        if let dotIndex = newText.index(of: ".") {
            numberOfDecimalDigits = newText.distance(from: dotIndex, to: newText.endIndex) - 1
        } else {
            numberOfDecimalDigits = 0
        }
        return isNumeric && numberOfDots <= 1 && numberOfDecimalDigits <= 2
    }
}




