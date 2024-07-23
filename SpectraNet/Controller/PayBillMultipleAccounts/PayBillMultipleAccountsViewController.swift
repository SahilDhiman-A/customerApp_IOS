//
//  PayBillMultipleAccountsViewController.swift
//  My Spectra
//
//  Created by Chakshu on 12/20/19.
//  Copyright © 2019 Bhoopendra. All rights reserved.
//

import UIKit

class PayBillMultipleAccountsViewController: UIViewController {

    @IBOutlet weak var proceedButton: UIView!
    @IBOutlet weak var backgroundView: UIView!
    
     @IBOutlet weak var canIDTF: JVFloatLabeledTextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setView()
       
        // Do any additional setup after loading the view.
    }
    func setView(){
        
        
         setCornerRadiusView(radius: 15, color: UIColor.clear, view: backgroundView)
          setCornerRadiusView(radius: Float(proceedButton.frame.height/2), color: UIColor.clear, view: proceedButton)
        canIDTF.delegate = self
        placeholderTextColor(textfeildName: canIDTF, placeHolderText: "Enter CAN ID", withColor: UIColor.gray)
    }
    
    @IBAction func backButtonAction(_ sender: Any) {
        
        self.navigationController?.popViewController(animated: false)
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    
    @IBAction func procedButtonAction(_ sender: Any) {
        
        if canIDTF.text == ""
        {
            self.showAlertC(message:ErrorValidationMessages.wrongCanID)
        }
       else if canIDTF.text?.count ?? 0 < 5
        {
            self.showAlertC(message:ErrorValidationMessages.validCanID)
        }else{
            let dict = ["Action":ActionKeys.userAccountData, "Authkey":UserAuthKEY.authKEY,"canID":canIDTF.text as Any] as [String : Any]
            print_debug(object: dict)
            CANetworkManager.sharedInstance.requestApi(serviceName: ServiceMethods.serviceBaseURL, method: kHTTPMethod.POST, postData: dict as Dictionary<String, AnyObject>) { [weak self] (response, error) in
               
                if response != nil
                {
                    
                     print_debug(object: response)
                    
                    if let  responseValue = response?["status"] as? String{
                    
                  
                    if responseValue != Server.api_status
                    {
                        if let  statusMessage = response?[ "message"] as? String {
                            self?.showAlertC(message: statusMessage)
                        
                        }
                        return
                    }
                        
                    }
                    
                    if let  responseValue = response?["response"] as? [[String:AnyObject]]{
                        
                        if responseValue.count > 0{
                            
                            if let data = responseValue[0] as? [String:AnyObject]{
                            
                            if let name = data["AccountName"] as? String,  let ammount = data["OutStandingAmount"] as? String,let mobilenumber =  data["mobile"] as? String,let emailAddress = data["email"] as? String,let canID  = data["CANId"] as? String{
                                
                                
//                                if(ammount == "0"){
//
//                                    self?.showAlertC(message: ErrorMessages.noDueAmount)
//
//                                }else{
                                if  let vc = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: ViewIdentifier.payBillMultipleAccountsPaymentIdentifier) as? PayBillMultipleAccountsPaymentViewController{
                                    vc.name = name
                                    vc.ammount = ammount
                                    vc.emailAddress = emailAddress
                                    vc.mobilenumber = mobilenumber
                                    vc.canID = canID
                                    
                                    self?.navigationController?.pushViewController(vc, animated: false)
                                    }
                               // }
                            }else{
                                  self?.showAlertC(message: ErrorMessages.errorMsg)
                                
                                }
                            
                        }
                        
                      
                            
                        }
                        
                      
                        
                        
                    }
                    
                   
                    
                    
                }
                
                
            }
            
        }
        
        
    }
    

}

extension PayBillMultipleAccountsViewController:UITextFieldDelegate{
    
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
