//
//  OTPViewController.swift
//  SpectraNet
//
//  Created by Bhoopendra on 7/11/19.
//  Copyright © 2019 Bhoopendra. All rights reserved.
//

import UIKit
import ObjectMapper
import RealmSwift

class OTPViewController: UIViewController,UITextFieldDelegate {
   
    var realm: Realm? = nil
    var userdata:Results<UserData>? = nil
    
    var dataResponse = NSDictionary()
    var checkStatus = String()
    var canID = String()
    var ifUpdateScreen = String()

    @IBOutlet weak var lblPrefieldMobileNmbr: UILabel!
    // object variables
    @IBOutlet weak var submitButtonView: UIView!
    @IBOutlet weak var otpDigit1TF: UITextField!
    @IBOutlet weak var otpDigit2TF: UITextField!
    @IBOutlet weak var otpDigit3TF: UITextField!
    @IBOutlet weak var otpDigit4TF: UITextField!
    
    @IBOutlet weak var otpMainTextField: UITextField!
    @IBOutlet weak var otpView: UIView!
    @IBOutlet weak var tranparantView: UIView!
    @IBOutlet weak var updateOtpVarifiedView: UIView!
    @IBOutlet weak var varifiedView: UIView!
    @IBOutlet weak var lblOtpUpdateVerify: UILabel!

    var userMobileNmbr = String()
    var userMobileOTP = String()
    var userOtpDetailDict = NSDictionary()
    
   //MARK: View controller life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        otpMainTextField.tintColor = UIColor.clear

        realm = try? Realm()
        if userOtpDetailDict.count==0 {
            userMobileNmbr = ""
            userMobileOTP = ""
        }
        else
        {
            if userOtpDetailDict["mobileNo"] != nil
              {
                 userMobileNmbr = ""
                if let userMobile = userOtpDetailDict.value(forKey: "mobileNo") as? String
                {
                    userMobileNmbr = userMobile
                }
              }
             else
             {
                userMobileNmbr = ""
                if let userEmail = userOtpDetailDict.value(forKey: "EmailID") as? String
                    {
                        userMobileNmbr = userEmail
                    }
             }
            
            let otpNumber:String = String(format: "%@", userOtpDetailDict.value(forKey: "OTP") as! CVarArg)
            userMobileOTP = otpNumber
        }

        submitButtonView.layer.cornerRadius = submitButtonView.frame.height/2
        submitButtonView.clipsToBounds = true
        
        lblPrefieldMobileNmbr.text = userMobileNmbr
        
        // add bottom line textfield
        bottomLineTextfield(textfield: otpDigit1TF)
        bottomLineTextfield(textfield: otpDigit2TF)
        bottomLineTextfield(textfield: otpDigit3TF)
        bottomLineTextfield(textfield: otpDigit4TF)
        hideOrShowView(bool: true,withUpdatmassage: "")
    }
    
    func animationView()
    {
        UIView.animate(withDuration: 0.5, delay: 0.0, options: UIView.AnimationOptions.curveEaseIn, animations: {
            //Frame Option 1:
            self.view.frame = CGRect(x: self.view.frame.origin.x, y: -100, width: self.view.frame.width, height: self.view.frame.height-100)
            
            //Frame Option 2:
            //self.myView.center = CGPoint(x: self.view.frame.width / 2, y: self.view.frame.height / 4)
            self.view.backgroundColor = .blue
            
        },completion: { finish in
            
            UIView.animate(withDuration: 1, delay: 0.25,options: UIView.AnimationOptions.curveEaseIn,animations: {
                self.view.backgroundColor = .orange
             //   self.view.transform = CGAffineTransform(scaleX: 0.25, y: 0.25)
                
               // self.animationButton.isEnabled = false // If you want to restrict the button not to repeat animation..You can enable by setting into true
                
            },completion: nil)})
        }

    func textField(_ textField: UITextField, shouldChangeCharactersIn range:NSRange, replacementString string: String) -> Bool {
        
        let currentText = textField.text ?? ""
        
        // attempt to read the range they are trying to change, or exit if we can't
        guard let stringRange = Range(range, in: currentText) else { return false }
        
        // add their new text to the existing text
        let updatedText = currentText.replacingCharacters(in: stringRange, with: string)
        
        let characters = Array(updatedText)
        
        
        if(characters.count > 4){
            
            return false
        }
        
        switch characters.count {
        case 1:
              otpDigit1TF.text = String(characters[0])
             otpDigit2TF.text = ""
             otpDigit3TF.text = ""
             otpDigit4TF.text = ""
        case 2:
             otpDigit1TF.text = String(characters[0])
             otpDigit2TF.text = String(characters[1])
            otpDigit3TF.text = ""
             otpDigit4TF.text = ""
        case 3:
             otpDigit1TF.text = String(characters[0])
             otpDigit2TF.text = String(characters[1])
            otpDigit3TF.text = String(characters[2])
             otpDigit4TF.text = ""
            
        case 4:
             otpDigit1TF.text = String(characters[0])
             otpDigit2TF.text = String(characters[1])
             otpDigit3TF.text = String(characters[2])
             otpDigit4TF.text = String(characters[3])
        default:
             otpDigit1TF.text = ""
             otpDigit2TF.text = ""
             otpDigit3TF.text = ""
             otpDigit4TF.text = ""
            
        }
        
        
        // make sure the result is under 16 characters
        return true
        
        

    }

    @IBAction func backBTN(_ sender: Any)
    {
        self.navigationController?.popViewController(animated: false)
    }
  
    @IBAction func backToAccountBTN(_ sender: Any)
      {
          let vc = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: ViewIdentifier.AccountIdentifier) as? AccountViewController
            vc?.fromScreen = FromScreen.otpScreen
           self.navigationController?.pushViewController(vc!, animated: false)
      }
    
    @IBAction func submitBTN(_ sender: Any) {

        if otpDigit1TF.text=="" || otpDigit2TF.text=="" || otpDigit3TF.text=="" || otpDigit4TF.text==""
        {
            showAlertC(message: AlertViewMessage.notEnterOTP)
        }
        else
        {
            self.view.endEditing(true)
            let otpString  = otpDigit1TF.text! + otpDigit2TF.text! + otpDigit3TF.text! + otpDigit4TF.text!

            if userMobileOTP==otpString
            {
              
                if ifUpdateScreen==""
                 {
                      userdata = self.realm!.objects(UserData.self)
                      if let userActData = userdata?[0]
                        {
                            if userActData.CancellationFlag == true
                        {
                            self.navigateScreen(identifier: ViewIdentifier.cancelledAccountIdentifier, controller: AccountCancelledViewController.self)
                        }
                        else if userActData.actInProgressFlag == true
                        {
                            self.navigateScreen(identifier: ViewIdentifier.accountActivationIdentifier, controller: AccountActivationViewController.self)
                        }
                        else
                         {
                            HelpingClass.saveToUserDefault(value: true as AnyObject, key: "status")
                            Switcher.updateRootVC()
                            AppDelegate.sharedInstance.navigateFrom = ""
                            navigateScreen(identifier: ViewIdentifier.customTabIdentifier, controller: CustomTabViewController.self)
                         }
                    }
                }
                  else if ifUpdateScreen == UpdateType.mobileUpdateDefault
                {
                    serviceTypeChangeMobileNumber()
                 }
                 else if ifUpdateScreen == UpdateType.emailUpdateDefault
                 {
                    serviceTypeChangeEmailID()
                 }
                else
                {
                    print_debug(object: "NO API")
                }
            }
            else
            {
                showAlertC(message: AlertViewMessage.invaliOTP)
            }
        }
    }
    
    
    @IBAction func resendBTN(_ sender: Any) {
        if ConnectionCheck.isConnectedToNetwork() == true
           {
            if ifUpdateScreen==""
                {
                    serviceTypeLoginResendOTP()
                }
            else if ifUpdateScreen == UpdateType.mobileUpdateDefault
                {
                    serviceTypeResendOTPForMobileNumber()
                }
            else if ifUpdateScreen == UpdateType.emailUpdateDefault
                {
                    serviceTypeResendOTPForEmailID()
                }
            else
            {
                print_debug(object: "Not API")
            }
          }
        else
         {
            noInternetCheckScreenWithMessage(errorMessage:"")
         }
    }

func serviceTypeLoginResendOTP()
    {
        let dict = ["Action":ActionKeys.resendOTP, "Authkey":UserAuthKEY.authKEY,"mobileNo":userMobileNmbr, "OTP":userMobileOTP]
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
                        if let statusMsg = self.dataResponse.value(forKey: "message") as? String
                        {
                            self.showAlertC(message:statusMsg)
                        }
                    }
                    else
                    {
                        if let statusMsg = self.dataResponse.value(forKey: "message") as? String
                        {
                            self.showAlertC(message:statusMsg)
                        }
                    }
                }
        }
    }
    
 func serviceTypeResendOTPForMobileNumber()
    {
        let dict = ["Action":ActionKeys.sendOTPforUpdateMobileNumber, "Authkey":UserAuthKEY.authKEY,"newMobile":userMobileNmbr, "canID":canID, "OTP":userMobileOTP]
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
                   guard let errorMsg = self.dataResponse.value(forKey: "message") as? String else
                   {
                      return
                   }
                    self.showAlertC(message: errorMsg)
                   
                    let userResponse: Any = self.dataResponse.value(forKey: "response") as Any
                    self.userMobileNmbr = ""
                    if let userMobile = (userResponse as AnyObject).value(forKey: "mobileNo") as? String
                    {
                        self.userMobileNmbr = userMobile
                    }
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
       
func serviceTypeResendOTPForEmailID()
      {
        let dict = ["Action":ActionKeys.sendOTPforUpdateEmailID, "Authkey":UserAuthKEY.authKEY,"newEmailID":userMobileNmbr, "canID":canID, "OTP":userMobileOTP]
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
                    guard let errorMsg = self.dataResponse.value(forKey: "message") as? String else
                    {
                        return
                    }
                    self.showAlertC(message: errorMsg)
                    
                    let userResponse: Any = self.dataResponse.value(forKey: "response") as Any
                 
                    self.userMobileNmbr = ""
                    if let userMobile = (userResponse as AnyObject).value(forKey: "EmailID") as? String
                    {
                        self.userMobileNmbr = userMobile
                    }
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
func serviceTypeChangeEmailID()
    {
        let dict = ["Action":ActionKeys.updateEmail, "Authkey":UserAuthKEY.authKEY,"newEmailID":userMobileNmbr, "canID":canID]
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
                    self.hideOrShowView(bool: false,withUpdatmassage: UpdateType.changedEmialID)
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
        
func serviceTypeChangeMobileNumber()
    {
        let dict = ["Action":ActionKeys.updateMobileNumber, "Authkey":UserAuthKEY.authKEY,"newMobile":userMobileNmbr, "canID":canID]
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
                self.hideOrShowView(bool: false,withUpdatmassage: UpdateType.changedMobileNumber)
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
    func hideOrShowView(bool: Bool,withUpdatmassage: String)
      {
          tranparantView.isHidden = bool
          updateOtpVarifiedView.isHidden = bool
          lblOtpUpdateVerify.text = withUpdatmassage
          setCornerRadiusView(radius: Float(varifiedView.frame.height/2), color: UIColor.cornerBGFullOpack, view: varifiedView)
      }
}
