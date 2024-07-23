//
//  LinkCanIdViewController.swift
//  My Spectra
//
//  Created by Chakshu on 12/27/19.
//  Copyright © 2019 Bhoopendra. All rights reserved.
//

import UIKit
import ObjectMapper
import RealmSwift

class LinkCanIdViewController: UIViewController {

    @IBOutlet weak var candIDTF: JVFloatLabeledTextField!
    var realm: Realm? = nil
    var userdata:Results<UserData>? = nil
    var currentUserData:Results<UserCurrentData>? = nil
    @IBOutlet weak var backgroundView: UIView!
    @IBOutlet weak var proceedButton: UIView!
     var linkedCanIDS = [String]()
    var baseCanID = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        self.setUpView()
        // Do any additional setup after loading the view.
    }
    
    
    func setUpView(){
        
         realm = try? Realm()
        setCornerRadiusView(radius: 15, color: UIColor.clear, view: backgroundView)
        setCornerRadiusView(radius: Float(proceedButton.frame.height/2), color: UIColor.clear, view: proceedButton)
        candIDTF.delegate = self
        placeholderTextColor(textfeildName: candIDTF, placeHolderText: "Enter CAN ID", withColor: UIColor.gray)
    }
    @IBAction func backButtonClick(_ sender: Any) {
        
         self.navigationController?.popViewController(animated: false)
    }
    
    @IBAction func proceedButtonClick(_ sender: Any) {
        if candIDTF.text == ""
        {
            self.showAlertC(message:ErrorValidationMessages.wrongCanID)
        }
        else  if candIDTF.text?.count ?? 0 < 5
        {
            
            
            self.showAlertC(message:ErrorValidationMessages.validCanID)
        }
        else if(linkedCanIDS.contains(candIDTF.text ?? "")){
             self.showAlertC(message:ErrorValidationMessages.canIDAlreadyLinked)
            
        }
        else{
             let allUsers = self.realm!.objects(UserData.self)
            
            var childSelected = false
            
            for alluserData in allUsers{
                
                
                if alluserData.CANId == candIDTF.text ?? ""{
                    childSelected = true
                    
                }
                
            }
            
                if(childSelected == true){
                    
                     self.showAlertC(message:ErrorValidationMessages.canIDAlreadyLinked)
                    
                }else{
                    
                     self.sendOTPtoLinkAccount(canID: candIDTF.text ?? "")
                }
           
        }
       
    }
    
    
    func sendOTPtoLinkAccount(canID:String)
    {
        let dict = ["Action":ActionKeys.sendOTPtoLinkAcount, "Authkey":UserAuthKEY.authKEY, "canID":canID]
        print_debug(object: dict)
        CANetworkManager.sharedInstance.requestApi(serviceName: ServiceMethods.serviceBaseURL, method: kHTTPMethod.POST, postData: dict as Dictionary<String, AnyObject>) { (response, error) in
            
            print_debug(object: response)
            if response != nil
            {
                if let  responseValue = response?["status"] as? String{
                    
                    
                    if responseValue != Server.api_status
                    {
                        if let  statusMessage = response?[ "message"] as? String {
                            self.showAlertC(message: statusMessage)
                            
                        }
                        return
                    }
                    
                }
                
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
                    vc?.ifUpdateScreen = UpdateType.LinkCanId
                    vc?.linkCanID = canID
                    vc?.baseCanID = self.baseCanID

                
                 self.navigationController?.pushViewController(vc!, animated: false)
                }
            }
        }
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
extension LinkCanIdViewController:UITextFieldDelegate{
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool
    {
        
        let maxLength = 20
        let currentString: NSString = textField.text! as NSString
        let newString: NSString =
            currentString.replacingCharacters(in: range, with: string) as NSString
        if newString.length>20
        {
            textField.resignFirstResponder()
            
        }
        return newString.length <= maxLength
        
        
        
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool
    {
        textField.resignFirstResponder();
        
        return true;
    }
    
    
}
