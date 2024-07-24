//
//  EditProfileViewController.swift
//  My Spectra
//
//  Created by Bhoopendra on 9/24/19.
//  Copyright © 2019 Bhoopendra. All rights reserved.
//

import UIKit
import ObjectMapper
import RealmSwift

class EditProfileViewController: UIViewController,UITextFieldDelegate
{
    var realm: Realm? = nil
    var userProfileResult:Results<UserProfileData>? = nil
    
    @IBOutlet weak var lblUserName: UILabel!
    @IBOutlet weak var lblMobileNumber: UILabel!
    @IBOutlet weak var lblEmailID: UILabel!
    var canID = String()
    
    var dataResponse = NSDictionary()
    var checkStatus = String()
    var userName = String()
    var gstNumber = String()
    var tanNumber = String()
    var userDict = NSDictionary()
    @IBOutlet weak var transparantView: UIView!
    var typeOfUpdate = String()
    
    @IBOutlet weak var updateView: UIView!
    @IBOutlet weak var updateViewTitle: UILabel!
    @IBOutlet weak var inputField: JVFloatLabeledTextField!
    @IBOutlet weak var submitBtnView: UIView!
    @IBOutlet weak var cancelView: UIView!
    @IBOutlet weak var submitRoundView: UIView!
    @IBOutlet weak var titleOfUserNameD: UILabel!
    @IBOutlet weak  var gstTanView: UIView!
    @IBOutlet weak var gstTanHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var lblGSTN: UILabel!
    
    @IBOutlet weak var lblTANNumber: UILabel!
    
   
//MARK: View controller life cycle
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
         realm = try? Realm()
        lblUserName.text = userName
        transparantView.isHidden = true
        updateView.isHidden = true
        setCornerRadiusView(radius: Float(submitRoundView.frame.height/2), color: UIColor.cornerBGFullOpack, view: submitRoundView)
        setCornerRadiusView(radius: Float(cancelView.frame.height/2), color: UIColor.cornerBGFullOpack, view: cancelView)
        inputField.delegate = self
        
        if lblMobileNumber.text == ""
        {
            lblMobileNumber.text = " "
            submitBtnView.isHidden = true
        }
        else if (lblEmailID.text == "")
        {
            lblEmailID.text = " "
            submitBtnView.isHidden = true
        }
        else
        {
            self.userProfileResult = self.realm!.objects(UserProfileData.self)
            let profileDat = self.userProfileResult?[0]
            
            guard let shipto = profileDat?.shipTo else
            {
                return
            }
            lblMobileNumber.text = shipto.mobile
            lblEmailID.text = shipto.email
            lblGSTN.text = profileDat?.GSTN ?? ""
            lblTANNumber.text = profileDat?.TAN ?? ""
        }
      
        if AppDelegate.sharedInstance.segmentType == segment.userB2C
        {
            titleOfUserNameD.text = profileUserB2C.userNameD
            gstTanHeightConstraint.constant = 0
        }
        else
        {
            titleOfUserNameD.text = profileUserB2B.userNameD
        }
    }
    
    //MARK: Button Actions
    @IBAction func backBTN(_ sender: Any)
    {
       self.navigationController?.popViewController(animated: false)
    }

    @IBAction func clickChangeMobileNmber(_ sender: Any)
    {
        submitBtnView.isHidden = true
        if let name = lblMobileNumber.text
        {
            if name == ""
            {
                submitBtnView.isHidden = true
            }
            else
            {
                submitBtnView.isHidden = false
            }
        }
        
        setTyprOfUpdateTitle(typeOfUpdateTitle: UpdateType.enterUpdateMobileNumber, previousInputValue: lblMobileNumber.text ?? "",type: UpdateType.mobileUpdateDefault,placeholder: UpdateType.updateMobileNumberPlaceHolder)
        inputField.keyboardType = .numberPad
    }
    
    @IBAction func clickChangeEmailID(_ sender: Any)
    {
        if let name = lblEmailID.text
        {
            if validateEmail(enteredEmail: name)
            {
                submitBtnView.isHidden = false
            }
        else
            {
                submitBtnView.isHidden = true
            }
        }
        
        setTyprOfUpdateTitle(typeOfUpdateTitle: UpdateType.enterUpdateEmialID, previousInputValue: lblEmailID.text ?? "",type: UpdateType.emailUpdateDefault,placeholder: UpdateType.updateEmialIDPlaceHolder)
        inputField.keyboardType = .emailAddress
        inputField.autocapitalizationType = .none
    }
    
    @IBAction func clickUpdateGSTNumber(_ sender: UIButton)
    {
        submitBtnView.isHidden = true
        guard let gstNmbr = lblGSTN.text else { return }
        if isValidGSTIN(gstNmbr)
        {
            submitBtnView.isHidden = false
        }
        else
        {
            submitBtnView.isHidden = true
        }
       
        setTyprOfUpdateTitle(typeOfUpdateTitle: UpdateType.enterUpdateGSTNumber, previousInputValue: lblGSTN.text ?? "",type: UpdateType.gstUpdateDefault,placeholder: UpdateType.updateGSTNumberPlaceHolder)
        inputField.keyboardType = .emailAddress
        inputField.autocapitalizationType = .allCharacters
    }
    
    @IBAction func clickUpdateTANNumber(_ sender: UIButton)
    {
         let profileDat = self.userProfileResult?[0]
        submitBtnView.isHidden = true
        guard let tanNumber = lblTANNumber.text else { return }
        if validateTANCardNumber(tanNumber) || tanNumber != profileDat?.TAN ?? ""
        {
            submitBtnView.isHidden = false
        }
        else
        {
            submitBtnView.isHidden = true
        }

        setTyprOfUpdateTitle(typeOfUpdateTitle: UpdateType.enterUpdateTANNumber, previousInputValue: lblTANNumber.text ?? "",type: UpdateType.tanUpdateDefault,placeholder: UpdateType.updateTANNumberPlaceHolder)
        inputField.keyboardType = .emailAddress
        inputField.autocapitalizationType = .allCharacters
    }
    
    @IBAction func submitUdateBTN(_ sender: Any)
    {
        if ConnectionCheck.isConnectedToNetwork() == true
        {
              let profileDat = self.userProfileResult?[0]
            
            guard let shipto = profileDat?.shipTo else
                       {
                           return
                       }
            if typeOfUpdate==UpdateType.emailUpdateDefault
            {
                
                guard let emailAddress = inputField.text else { return }
                               
                               
                               if  emailAddress == shipto.email {
                                   
                                   showAlertC(message: UpdateType.enterChangedEmailID)
                                   return
                               }
                serviceTypeSendOTPForEmailID()
            }
            else if typeOfUpdate == UpdateType.gstUpdateDefault
            {
                guard let gstNmbr = inputField.text else { return }
              if gstNmbr == profileDat?.GSTN ?? ""{
                        
                showAlertC(message: UpdateType.enterChangeGSTNumber)
                    }
                else if isValidGSTIN(gstNmbr)
                {
                  updateGSTNumber(gstNumber: gstNmbr)
                }
                else
                {
                    showAlertC(message: UpdateType.entervalidGSTNumber)
                }
            }
            else if typeOfUpdate == UpdateType.tanUpdateDefault
            {
                
               
                guard let tanNumber = inputField.text else { return }
                 if  tanNumber == profileDat?.TAN ?? ""{
                     
                      showAlertC(message: UpdateType.enterChangedTANNumber)
                 }
                 else if validateTANCardNumber(tanNumber)
                 {
                     updateTANNumber(tanNumber: tanNumber)
                 }
                else
                {
                    showAlertC(message: UpdateType.enterValidTANNumber)
                }
              //  updateTANNumber(tanNumber: tanNumber)
            }
            else
            {
                
                 guard let mobileNumber = inputField.text else { return }
                
                
                if  mobileNumber == shipto.mobile {
                    
                    showAlertC(message: UpdateType.enterChangedMobileNumber)
                    return
                
                }
                
                serviceTypeSendOTPForMobileNumber()
            }
        }
      else
      {
        noInternetCheckScreenWithMessage(errorMessage:"")
      }
    }

    @IBAction func cancelUpdate(_ sender: Any)
    {
        transparantView.isHidden = true
        updateView.isHidden = true
        inputField.resignFirstResponder()
    }
    
    func setTyprOfUpdateTitle(typeOfUpdateTitle: String, previousInputValue:String,type:String,placeholder:String)
    {
         transparantView.isHidden = false
         updateView.isHidden = false
         updateViewTitle.text = typeOfUpdateTitle
         inputField.placeholder = placeholder
         inputField.text = previousInputValue
         typeOfUpdate = type
    }
    
    //MARK: ServicesTypeSendOTPForMobileNumber
    func serviceTypeSendOTPForMobileNumber()
    {
          // CHANGED - inputField.text ?? "" - nov 2019
          let dict = ["Action":ActionKeys.sendOTPforUpdateMobileNumber, "Authkey":UserAuthKEY.authKEY,"newMobile":inputField.text ?? "" as Any, "canID":canID, "OTP":""] as [String : Any]
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
             let vc = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: ViewIdentifier.otpIdentifier) as? OTPViewController
                guard let respon = self.dataResponse.value(forKey: "response") as? NSDictionary else
                {
                    return
                }
                
             vc?.userOtpDetailDict = respon
             vc?.ifUpdateScreen = UpdateType.mobileUpdateDefault
             vc?.canID = self.canID
             self.navigationController?.pushViewController(vc!, animated: false)
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
       
  func serviceTypeSendOTPForEmailID()
   {

     // CHANGED - inputField.text ?? "" - nov 2019
    let dict = ["Action":ActionKeys.sendOTPforUpdateEmailID, "Authkey":UserAuthKEY.authKEY,"newEmailID":inputField.text ?? "" as Any, "canID":canID, "OTP":""] as [String : Any]
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
             let vc = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: ViewIdentifier.otpIdentifier) as? OTPViewController
               
                guard let respon = self.dataResponse.value(forKey: "response") as? NSDictionary else
                {
                    return
                }
                vc?.userOtpDetailDict = respon
                vc?.ifUpdateScreen = UpdateType.emailUpdateDefault
                vc?.canID = self.canID
                self.navigationController?.pushViewController(vc!, animated: false)
             }
            else
            {
                if let statusMsg = self.dataResponse.value(forKey: "message") as? String
                {
                    self.showAlertC(message: statusMsg)
                }
             }
           }
         }
      }
    
    //MARK: Textfield Delegate

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder();
        return true;
    }
 
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool
    {
          
        if typeOfUpdate==UpdateType.emailUpdateDefault
        {
           submitBtnView.isHidden = true
           if let name = textField.text
           {
            let maxLength = 30
            let currentString: NSString = textField.text! as NSString
            let newString: NSString = currentString.replacingCharacters(in: range, with: string) as NSString
            
            if newString.length == 30
            {
              // submitBtnView.isHidden = false
                if validateEmail(enteredEmail: newString as String)
                {
                    submitBtnView.isHidden = false
                }
                else
                {
                   submitBtnView.isHidden = true
                }
            }
            else if newString.length<30
            {
                
                if validateEmail(enteredEmail: newString as String)
                {
                    submitBtnView.isHidden = false
                }
                else
                {
                    submitBtnView.isHidden = true
                }
                
             // submitBtnView.isHidden = true
            }
            else
            {
                submitBtnView.isHidden = false
            }
            
//            if validateEmail(enteredEmail: newString as String)
//               {
//                   submitBtnView.isHidden = false
//               }
//               else
//               {
//                   submitBtnView.isHidden = true
//               }
             return newString.length <= maxLength
           }
          }
          else if typeOfUpdate == UpdateType.gstUpdateDefault
          {
           if textField==inputField
           {
             let maxLength = 15
             let currentString: NSString = textField.text! as NSString
             let newString: NSString = currentString.replacingCharacters(in: range, with: string) as NSString
              if newString.length == 15
               {
                  submitBtnView.isHidden = false
               }
               else if newString.length<15
               {
                 submitBtnView.isHidden = true
               }
                 return newString.length <= maxLength
              }
          }
          else if typeOfUpdate == UpdateType.tanUpdateDefault
          {
           if textField==inputField
           {
             let maxLength = 10
             let currentString: NSString = textField.text! as NSString
             let newString: NSString = currentString.replacingCharacters(in: range, with: string) as NSString
              if newString.length == 10
               {
                  submitBtnView.isHidden = false
               }
               else if newString.length<10
               {
                 submitBtnView.isHidden = true
               }
                 return newString.length <= maxLength
              }
          }
          else
          {
           if textField==inputField
           {
             let maxLength = 10
             let currentString: NSString = textField.text! as NSString
             let newString: NSString = currentString.replacingCharacters(in: range, with: string) as NSString
              if newString.length == 10
               {
                  submitBtnView.isHidden = false
               }
               else if newString.length<10
               {
                 submitBtnView.isHidden = true
               }
                 return newString.length <= maxLength
              }
          }
            
           return true
       }
    
    func updateTANNumber(tanNumber: String)
      {
          let dict = ["Action":ActionKeys.updateTANNumber, "Authkey":UserAuthKEY.authKEY, "canID":canID, "tanNumber":tanNumber]
                 print_debug(object: dict)
          CANetworkManager.sharedInstance.requestApi(serviceName: ServiceMethods.serviceBaseURL, method: kHTTPMethod.POST, postData: dict as Dictionary<String, AnyObject>) { (response, error) in
          print_debug(object: response)
            
          if response != nil
              {
                guard let tanResponse = response as? NSDictionary else
                {
                    return
                }
                
                guard let status = tanResponse.value(forKey: "status") as? String else
                {
                    return
                }
                guard let tanStatus = tanResponse.value(forKey: "message") as? String else
                {
                    return
                }
                
                let statusCase = status.lowercased()
                switch statusCase {
                case Server.api_status:
                    self.showSimpleAlert(TitaleName: "", withMessage: tanStatus)
                case Server.api_statusFailed:
                    self.showAlertC(message: tanStatus)
                default:
                    print("no match")
                }
              }
          }
      }
      
      func updateGSTNumber(gstNumber: String)
      {
          let dict = ["Action":ActionKeys.updateGSTNumber, "Authkey":UserAuthKEY.authKEY, "canID":canID, "gstNumber":gstNumber]
          print_debug(object: dict)
          CANetworkManager.sharedInstance.requestApi(serviceName: ServiceMethods.serviceBaseURL, method: kHTTPMethod.POST, postData: dict as Dictionary<String, AnyObject>) { (response, error) in
                        
          print_debug(object: response)
          if response != nil
              {
                guard let gstResponse = response as? NSDictionary else
                {
                    return
                }
                
                guard let status = gstResponse.value(forKey: "status") as? String else
                {
                    return
                }
                
                guard let gstStatus = gstResponse.value(forKey: "message") as? String else
                {
                    return
                }
                
                let statusCase = status.lowercased()
                switch statusCase
                {
                case Server.api_status:
                    self.showSimpleAlert(TitaleName: "", withMessage: gstStatus)
                case Server.api_statusFailed:
                    self.showAlertC(message: gstStatus)
                default:
                    print("no match")
                }
              }
          }
      }
    
 
    func showSimpleAlert(TitaleName: String, withMessage: String)
     {
         let alert = UIAlertController(title: TitaleName, message: withMessage,preferredStyle: UIAlertController.Style.alert)
         alert.addAction(UIAlertAction(title: AlertViewButtonTitle.title_OK,style: UIAlertAction.Style.default,handler: {(_: UIAlertAction!) in

            let vc = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: ViewIdentifier.AccountIdentifier) as? AccountViewController
            vc?.fromScreen = FromScreen.otpScreen
            self.navigationController?.pushViewController(vc!, animated: false)
         }))
         self.present(alert, animated: true, completion: nil)
     }
}


