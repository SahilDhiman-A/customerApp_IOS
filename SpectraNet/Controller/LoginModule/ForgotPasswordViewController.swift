//
//  ForgotPasswordViewController.swift
//  SpectraNet
//
//  Created by Bhoopendra on 7/17/19.
//  Copyright © 2019 Bhoopendra. All rights reserved.
//

import UIKit

class ForgotPasswordViewController: UIViewController,UITextFieldDelegate {
    
    let networkClass = CANetworkManager()
    var dataResponse = NSDictionary()
    var checkStatus = String()
    @IBOutlet weak var mobileTF: JVFloatLabeledTextField!
    @IBOutlet weak var transparantView: UIView!
    @IBOutlet weak var SubmitCanView: UIView!
    
    @IBOutlet weak var byCAnIDBTN: UIButton!
    @IBOutlet weak var byUserNameBTN: UIButton!
    @IBOutlet weak var lineBelowUsernameBTN: UILabel!
    @IBOutlet weak var lineBelowCanBTN: UILabel!
    @IBOutlet weak var lblHeaderStatus: UILabel!
    @IBOutlet weak var showCanIDBTN: UIButton!
    
    @IBOutlet weak var imgShowCanInfo: UIImageView!
    @IBOutlet weak var btnCanInfoHide: UIButton!
    var postWithKey = String()
    @IBOutlet weak var submitPswdView: UIView!
    @IBOutlet weak var successPswdView: UIView!
    
    //MARK: View controller life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
       
        placeholderTextColor(textfeildName: mobileTF, placeHolderText: "CAN ID", withColor: UIColor.gray)
        postWithKey = "canID"
        SubmitCanView.isHidden = true
        showAndHideView(bool: true)
        
        setBelowlineColor(below1stTabLine: lineBelowCanBTN, withColor: .bgColors, below2ndTabLine: lineBelowUsernameBTN, withColor2: UIColor.white, btn1stTab: byCAnIDBTN, with1stBtnTabColor: .bgColors, btn2ndTab: byUserNameBTN, with2ndBtnTabColor: UIColor.darkGray, setstatus: AlertViewMessage.enterCanIDForgot, toLabel: lblHeaderStatus)
        
        setCornerRadiusView(radius: Float(submitPswdView.frame.height/2), color: UIColor.cornerBGFullOpack, view: submitPswdView)
        setCornerRadiusView(radius: Float(successPswdView.frame.height/2), color: UIColor.cornerBGFullOpack, view: successPswdView)

        mobileTF.keyboardType = .numberPad

      //  setupKeyboardDismissRecognizer()
    }
    // UITextField Delegates
 
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder();
        return true;
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool
    {
            if textField == mobileTF {
                if string == "" {
                    return true
                }
                
                if let characterCount = textField.text?.count {
                    // CHECK FOR CHARACTER COUNT IN TEXT FIELD
                    if characterCount >= 20
                    {
                        return textField.resignFirstResponder()
                    }
                }
            }
      
        return true
    }
    
    @IBAction func backBTN(_ sender: Any) {
        self.navigationController?.popViewController(animated: false)
    }
    @IBAction func submitBTN(_ sender: Any)
    {
        mobileTF.resignFirstResponder()
        
        if ConnectionCheck.isConnectedToNetwork() == true
        {
            if postWithKey == "canID"
            {
                if mobileTF.text == ""
                {
                    showAlertC(message: AlertViewMessage.enterCanID)
                }
                else
                {
                    ServiceTypeForgotPasswrd()
                }
            }
            else if postWithKey == "username"
            {
                if mobileTF.text == ""
                {
                    showAlertC(message: AlertViewMessage.enterUserName)
                }
                else
                {
                    ServiceTypeForgotPasswrd()
                }
            }
        }
        else
        {
            noInternetCheckScreenWithMessage(errorMessage:"")
        }
    }
    
    func ServiceTypeForgotPasswrd()
    {
        let dict = ["Action":ActionKeys.forgotPassword, "Authkey":UserAuthKEY.authKEY, postWithKey:mobileTF.text as Any] as [String : Any]
        print_debug(object: dict)
        CANetworkManager.sharedInstance.requestApi(serviceName: ServiceMethods.serviceBaseURL, method: kHTTPMethod.POST, postData: dict as Dictionary<String, AnyObject>) { (response, error) in
            
            print_debug(object: response)
            if response != nil
            {
                if let dict = response as? NSDictionary
                {
                    self.dataResponse = dict
                }
                                     
                self.checkStatus = ""
                if let status = self.dataResponse.value(forKey: "status") as? String
                {
                    self.checkStatus = status.lowercased()
                }
                
                if self.checkStatus == Server.api_status
                {
                  self.SubmitCanView.isHidden = false
                  self.transparantView.isHidden = false
                }
                else
                {
                    guard let errorMsg = self.dataResponse.value(forKey: "message") as? String else
                    {
                        return
                    }
                    self.showAlertC(message: errorMsg)
                }
            }
        }
    }
    
    @IBAction func showCanIdDetalsBTN(_ sender: Any) {
        
        showAndHideView(bool: false)
    }
    
    @IBAction func submitCanBTN(_ sender: Any) {
     self.navigationController?.popViewController(animated: false)
    }
    
    @IBAction func clickByCanIdBN(_ sender: Any) {
       
        mobileTF.resignFirstResponder()
        setBelowlineColor(below1stTabLine: lineBelowCanBTN, withColor: .bgColors, below2ndTabLine: lineBelowUsernameBTN, withColor2: UIColor.white, btn1stTab: byCAnIDBTN, with1stBtnTabColor: .bgColors, btn2ndTab: byUserNameBTN, with2ndBtnTabColor: UIColor.darkGray, setstatus: AlertViewMessage.enterCanIDForgot, toLabel: lblHeaderStatus)
         placeholderTextColor(textfeildName: mobileTF, placeHolderText: "CAN ID", withColor: UIColor.gray)
        mobileTF.keyboardType = .numberPad
        showCanIDBTN.isHidden = false
        postWithKey = "canID"
        mobileTF.text = ""
    }
    
    @IBAction func clickByUserNameBTN(_ sender: Any)
    {
         mobileTF.resignFirstResponder()
        setBelowlineColor(below1stTabLine: lineBelowCanBTN, withColor: UIColor.white, below2ndTabLine: lineBelowUsernameBTN, withColor2: .bgColors, btn1stTab: byCAnIDBTN, with1stBtnTabColor: UIColor.darkGray, btn2ndTab: byUserNameBTN, with2ndBtnTabColor: .bgColors, setstatus: AlertViewMessage.enterUsernameForgot, toLabel: lblHeaderStatus)
        placeholderTextColor(textfeildName: mobileTF, placeHolderText: "Username", withColor: UIColor.gray)
        mobileTF.keyboardType = .emailAddress
         showCanIDBTN.isHidden = true
        postWithKey = "username"
        mobileTF.text = ""

    }
    @IBAction func hideCanInfoBTN(_ sender: Any)
    {
        showAndHideView(bool: true)
    }
    
    func showAndHideView(bool: Bool)
    {
        transparantView.isHidden = bool
        imgShowCanInfo.isHidden = bool
        btnCanInfoHide.isHidden = bool
    }
}



