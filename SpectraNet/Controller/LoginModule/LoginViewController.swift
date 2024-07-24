//
//  ViewController.swift
//  SpectraNet
//
//  Created by Bhoopendra on 7/11/19.
//  Copyright © 2019 Bhoopendra. All rights reserved.
//

import UIKit
import ObjectMapper
import RealmSwift


class LoginViewController: UIViewController,UITextFieldDelegate
{

    var realm: Realm? = nil
    var userdata:Results<UserData>? = nil
    var currentUserData:Results<UserCurrentData>? = nil

    var userOTP = OTPData()
    var iconClick = true
    var dataResponse = NSDictionary()
    var checkStatus = String()
 
    @IBOutlet weak var mobileNumberTF: JVFloatLabeledTextField!
    @IBOutlet weak var userNameTF: JVFloatLabeledTextField!
    @IBOutlet weak var passwordTF: JVFloatLabeledTextField!
    
    @IBOutlet weak var firstMobileNmbrContainerView: UIView!
    @IBOutlet weak var userLoginView: UIView!
    @IBOutlet weak var viewSbmtBTNBG: UIView!
    @IBOutlet weak var loginBtnView: UIView!
    @IBOutlet weak var buttonView: UIView!
    @IBOutlet weak var pswdShowBTN: UIButton!
    @IBOutlet weak var loginErrorMSGView: UIView!
    @IBOutlet weak var lbl1Hi: UILabel!
    @IBOutlet weak var lblErrMsgByLogin: UILabel!
    @IBOutlet weak var userLoginByPswdBTN: UIButton!
    @IBOutlet weak var userLine1: UILabel!
    @IBOutlet weak var pswdLine1: UILabel!
    
    //MARK: View controller life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        realm = try? Realm()
        // view round corner
        setCornerRadiusView(radius: Float(viewSbmtBTNBG.frame.height/2), color: UIColor.cornerBGFullOpack, view: viewSbmtBTNBG)
        setCornerRadiusView(radius: Float(loginBtnView.frame.height/2), color: UIColor.clear, view: loginBtnView)
        loginBtnView.backgroundColor = UIColor.viewBackgroundHalfOpack
        userLoginView.isHidden = true
        buttonView.isHidden = true
        //setupKeyboardDismissRecognizer()
        // change color placeholder
        mobileNumberTF.delegate = self
        placeholderTextColor(textfeildName: mobileNumberTF, placeHolderText: "Registered Mobile Number", withColor: UIColor.gray)
        placeholderTextColor(textfeildName: userNameTF, placeHolderText: "Username", withColor: UIColor.gray)
        placeholderTextColor(textfeildName: passwordTF, placeHolderText: "Password", withColor: UIColor.gray)
    }
  
    override func viewWillAppear(_ animated: Bool)
    {
        super.viewWillAppear(animated)
    }
   
    //MARK: Button Actions
    // user login by mobile number
    @IBAction func submitNmbrBTN(_ sender: Any)
    {
        self.mobileNumberTF.resignFirstResponder()
        var phone = String()
        phone = mobileNumberTF.text!
        if ConnectionCheck.isConnectedToNetwork() == true
        {
            serviceTypeLoginByMobile()
        }
        else
        {
            noInternetCheckScreenWithMessage(errorMessage:"")
        }
        print_debug(object: phone)
    }
 
    // submit user loggin by username and password
    @IBAction func loginUserViaUserName(_ sender: Any)
    {
        userLoginByPswdBTN.isUserInteractionEnabled = true
        if ConnectionCheck.isConnectedToNetwork() == true
        {
            serviceTypeUserLoginByPaswd()
        }
        else
        {
            noInternetCheckScreenWithMessage(errorMessage:"")
            self.view.endEditing(true)
        }
    }
  
    // alert message when user enter invalid credential
    func showSimpleAlert(TitaleName: String, withMessage: String)
    {
        let alert = UIAlertController(title: TitaleName, message: withMessage,preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: AlertViewButtonTitle.title_OK,style: UIAlertAction.Style.default,handler: {(_: UIAlertAction!) in
     
        self.setTextFieldTextClr(textColor: UIColor.black, bgColor: UIColor.gray)
        self.userLoginByPswdBTN.isUserInteractionEnabled = true
        self.setCornerRadiusView(radius: Float(self.loginBtnView.frame.height/2), color: UIColor.cornerBGFullOpack, view: self.loginBtnView)
        self.loginBtnView.backgroundColor = UIColor.viewBackgroundFullOpack
        self.userNameTF.text = ""
        self.passwordTF.text = ""
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
    func setTextFieldTextClr(textColor: UIColor, bgColor: UIColor) {
        userNameTF.textColor = textColor
        passwordTF.textColor = textColor
        userLine1.backgroundColor = bgColor
        pswdLine1.backgroundColor = bgColor
    }
    
    // userloginByUsename And Password
    @IBAction func loginButton(_ sender: Any)
    {
        view.endEditing(true)
        userLoginView.isHidden = false
        firstMobileNmbrContainerView.isHidden = true
        loginErrorMSGView.isHidden = true
        setCornerRadiusView(radius: Float(loginErrorMSGView.frame.height/2), color: UIColor.clear, view: loginErrorMSGView)
       // firstMobileNmbrContainerView.fadeOut()
    }
    
     // userloginByMobileNumberView
    @IBAction func loginViaMobileNmbrBtn(_ sender: Any)
    {
       // userLoginView.fadeIn()
       // firstMobileNmbrContainerView.fadeIn()
        view.endEditing(true)
        userLoginView.isHidden = true
        firstMobileNmbrContainerView.isHidden = false
    }
    
    @IBAction func forgotPswdButton(_ sender: Any)
    {
        self.view.endEditing(true)
        navigateScreen(identifier: ViewIdentifier.forgotPswdIdentifier, controller: ForgotPasswordViewController.self)
    }
    
      // service user logged in by mobile number
       func serviceTypeLoginByMobile()
       {
            let dict = ["Action":ActionKeys.getAccountByMobile, "Authkey":UserAuthKEY.authKEY,"Mobile":mobileNumberTF.text as Any] as [String : Any]
            print_debug(object: dict)
           
            DispatchQueue.main.async {
                CANetworkManager.sharedInstance.requestApi(serviceName: ServiceMethods.serviceBaseURL, method: kHTTPMethod.POST, postData: dict as Dictionary<String, AnyObject>) { (response, error) in
                   print_debug(object: response)
                   if response != nil
                   {
                   var dataResponse = NSDictionary()
                   var checkStatus = String()
                   
                   if let dict = response as? NSDictionary
                   {
                       dataResponse = dict
                   }
                   checkStatus = ""
                   if let status = dataResponse.value(forKey: "status") as? String
                   {
                    checkStatus = status.lowercased()
                   }
                       
                   if checkStatus == Server.api_status
                   {
                       var dict1 = NSDictionary()
                       if let dict = response as? NSDictionary
                       {
                           dict1 = dict
                       }
                       
                       var arr = NSArray()
                       guard let responseArr = dict1.value(forKey: "response") as? NSArray else
                       {
                           return
                       }
                       arr = responseArr
                       
                       try! self.realm!.write
                       {
                           if let users = self.realm?.objects(UserData.self) {
                               self.realm!.delete(users)
                           }
                       }
                       for entry in arr {
                           
                           if let currentUser = Mapper<UserData>().map(JSONObject: entry) {
                               try! self.realm!.write {
                                   self.realm!.add(currentUser)
                               }
                           }
                       }
                       
                       self.userdata = self.realm!.objects(UserData.self)
                       print_debug(object: self.userdata)
                       
                       try! self.realm!.write
                       {
                           if let users = self.realm?.objects(UserCurrentData.self) {
                               self.realm!.delete(users)
                           }
                       }
                       
                       let userData: UserCurrentData = (self.userdata?[0].convertToUserCurrentData())!
                       try! self.realm!.write
                       {
                           self.realm!.add(userData)
                       }
                       self.currentUserData = self.realm!.objects(UserCurrentData.self)
                       print_debug(object: self.currentUserData)
                       if ConnectionCheck.isConnectedToNetwork() == true
                       {
                           self.serviceGenerateOTP()
                       }
                       else
                       {
                           self.noInternetCheckScreenWithMessage(errorMessage:"")
                       }
                   }
                   else
                   {
                       guard let errorMsg = dataResponse.value(forKey: "message") as? String else
                       {
                           return
                       }
                       self.showAlertC(message: errorMsg)
                   }
                 }
               }
           }
       }
       
    // Send OTP user's number
     func serviceGenerateOTP()
     {
        let dict = ["Action":ActionKeys.sandOTP, "Authkey":UserAuthKEY.authKEY,"mobileNo":mobileNumberTF.text as Any] as [String : Any]
       print_debug(object: dict)
       
        CANetworkManager.sharedInstance.requestApi(serviceName: ServiceMethods.serviceBaseURL, method: kHTTPMethod.POST, postData: dict as Dictionary<String, AnyObject>) { (response, error) in
           print_debug(object: response)
           if response != nil
           {
           var dataResponse = NSDictionary()
           var checkStatus = String()
           
           if let dict = response as? NSDictionary
           {
               dataResponse = dict
           }
           checkStatus = ""
           if let status = dataResponse.value(forKey: "status") as? String
           {
            checkStatus = status.lowercased()
           }
           
           if checkStatus == Server.api_status
           {
               let vc = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: ViewIdentifier.otpIdentifier) as? OTPViewController
               vc?.userOtpDetailDict = dataResponse.value(forKey: "response") as! NSDictionary
               vc?.ifUpdateScreen = ""
               var dict1 = NSDictionary()
               if let dict = response as? NSDictionary
               {
                   dict1 = dict
               }

               var dicto = NSDictionary()
               guard let dictionaryData = dict1.value(forKey: "response") as? NSDictionary else
               {
                   return
               }
               dicto = dictionaryData
               try! self.realm!.write
               {
                   if let users = self.realm?.objects(OTPData.self)
                   {
                       self.realm!.delete(users)
                   }
               }
               
               if let currentUser = Mapper<OTPData>().map(JSONObject: dicto)
                   {
                       try! self.realm!.write
                       {
                           self.realm!.add(currentUser)
                        }
                    }
               self.navigationController?.pushViewController(vc!, animated: false)
           }
           else
           {
               guard let errorMsg = dataResponse.value(forKey: "message") as? String else
               {
                   return
               }
               self.showAlertC(message: errorMsg)
           }
          }
         }
       }
       
    // service username and password
    func serviceTypeUserLoginByPaswd()
    {
        self.view.endEditing(true)
        if userNameTF.text == ""
        {
            self.showAlertC(message:ErrorValidationMessages.wrongEmailUserName)
        }
        else if passwordTF.text == ""
        {
            self.showAlertC(message:ErrorValidationMessages.wrongEnterPassword)
        }
        else
        {
            var pswdEncodeStr = String()
            pswdEncodeStr = passwordTF.text!.data(using: .utf8)?.base64EncodedString() as Any as! String
            let dict = ["Action":ActionKeys.getAccountByPassword, "Authkey":UserAuthKEY.authKEY,"Username":userNameTF.text as Any, "Password":pswdEncodeStr] as [String : Any]
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
                        self.setTextFieldTextClr(textColor: UIColor.black, bgColor: UIColor.gray)
                        self.loginErrorMSGView.isHidden = true
                        self.lbl1Hi.isHidden = false
                        var dict1 = NSDictionary()
                        if let dict = response as? NSDictionary
                        {
                            dict1 = dict
                        }

                        var arr = NSArray()
                        guard let responseArr = dict1.value(forKey: "response") as? NSArray else
                        {
                            return
                        }
                        arr = responseArr
                            
                        try! self.realm!.write
                        {
                            if let users = self.realm?.objects(UserData.self) {
                                self.realm!.delete(users)
                            }
                        }
                        for entry in arr {
                                
                            if let currentUser = Mapper<UserData>().map(JSONObject: entry) {
                                try! self.realm!.write {
                                    self.realm!.add(currentUser)
                                }
                            }
                        }
                            
                        self.userdata = self.realm!.objects(UserData.self)
                        print_debug(object: self.userdata)

                        try! self.realm!.write
                        {
                            if let users = self.realm?.objects(UserCurrentData.self) {
                                self.realm!.delete(users)
                            }
                        }
                            
                        let userData: UserCurrentData = (self.userdata?[0].convertToUserCurrentData())!
                        try! self.realm!.write
                        {
                            self.realm!.add(userData)
                        }
                        self.currentUserData = self.realm!.objects(UserCurrentData.self)
                        print_debug(object: self.currentUserData)

                        if userData.CancellationFlag == true
                        {
                            self.navigateScreen(identifier: ViewIdentifier.cancelledAccountIdentifier, controller: AccountCancelledViewController.self)
                        }
                        else if userData.actInProgressFlag == true
                        {
                            self.navigateScreen(identifier: ViewIdentifier.accountActivationIdentifier, controller: AccountActivationViewController.self)
                        }
                        else
                        {
                            HelpingClass.saveToUserDefault(value: true as AnyObject, key: "status")
                            Switcher.updateRootVC()
                            AppDelegate.sharedInstance.navigateFrom = ""
                            self.navigateScreen(identifier: ViewIdentifier.customTabIdentifier, controller: CustomTabViewController.self)
                        }
                    }
                    else
                    {
                        self.setTextFieldTextClr(textColor: UIColor.red, bgColor: UIColor.red)
                        self.userLoginByPswdBTN.isUserInteractionEnabled = false
                        self.setCornerRadiusView(radius: Float(self.loginBtnView.frame.height/2), color: UIColor.clear, view: self.loginBtnView)
                        self.loginBtnView.backgroundColor = UIColor.viewBackgroundHalfOpack
                        self.showSimpleAlert(TitaleName: "", withMessage: (self.dataResponse.value(forKey: "message") as? String)!)
                    }
                }
            }
         }
    }
    
    @IBAction func showPswdBTN(_ sender: Any)
    {
        if passwordTF.text == ""
        {
        }
        else
        {
            if(iconClick == true) {
                passwordTF.isSecureTextEntry = false
                pswdShowBTN.setTitle("HIDE", for: UIControl.State.normal)
            } else {
                passwordTF.isSecureTextEntry = true
                pswdShowBTN.setTitle("SHOW", for: UIControl.State.normal)
            }
            iconClick = !iconClick
        }
    }
    
    // handle views hide error message view
    @IBAction func hideErrorMsgView(_ sender: Any) {
    
        self.loginErrorMSGView.isHidden = true
        self.lbl1Hi.isHidden = false
        setTextFieldTextClr(textColor: UIColor.black, bgColor: UIColor.gray)
        userLoginByPswdBTN.isUserInteractionEnabled = true
        setCornerRadiusView(radius: Float(loginBtnView.frame.height/2), color: UIColor.cornerBGFullOpack, view: loginBtnView)
        loginBtnView.backgroundColor = UIColor.viewBackgroundFullOpack
        userNameTF.text = ""
        passwordTF.text = ""
    }
    
    // UITextField Delegates
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool
    {
        if textField==mobileNumberTF {
            
            let maxLength = 10
            let currentString: NSString = textField.text! as NSString
            let newString: NSString =
                currentString.replacingCharacters(in: range, with: string) as NSString
            if newString.length == 10
            {
                buttonView.isHidden = false
            }
            else if newString.length<10
            {
                buttonView.isHidden = true
            }
            return newString.length <= maxLength
        }
        else if (textField==userNameTF)
        {
            let maxLength = 20
            let currentString: NSString = textField.text! as NSString
            let newString: NSString =
                currentString.replacingCharacters(in: range, with: string) as NSString
            if newString.length>20
            {
                textField.resignFirstResponder()
                passwordTF.becomeFirstResponder()
            }
            return newString.length <= maxLength
        }
        else if (textField==passwordTF)
        {
            let maxLength = 20
            let currentString: NSString = textField.text! as NSString
            let newString: NSString =
                currentString.replacingCharacters(in: range, with: string) as NSString

            if newString.length>20
            {
                textField.resignFirstResponder()
            }
            else
             {
                if (userNameTF.text == "" && passwordTF.text == "")
                {
                    print_debug(object: "Both is empty")
                }
                else
                {
                    userLoginByPswdBTN.isUserInteractionEnabled = true
                    setCornerRadiusView(radius: Float(loginBtnView.frame.height/2), color: UIColor.cornerBGFullOpack, view: loginBtnView)
                    loginBtnView.backgroundColor = UIColor.viewBackgroundFullOpack
                }
            }
            return newString.length <= maxLength
        }
        return true
    }
  
    func textFieldShouldReturn(_ textField: UITextField) -> Bool
    {
        textField.resignFirstResponder();
        return true;
    }
}


