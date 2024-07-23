//
//  PayBillMultipleAccountsPaymentViewController.swift
//  My Spectra
//
//  Created by Chakshu on 12/24/19.
//  Copyright © 2019 Bhoopendra. All rights reserved.
//

import UIKit

class PayBillMultipleAccountsPaymentViewController: UIViewController {

    @IBOutlet weak var buyNowButton: UIView!
    @IBOutlet weak var canIDTF: JVFloatLabeledTextField!
    @IBOutlet weak var nameTF: JVFloatLabeledTextField!
    @IBOutlet weak var backgroundView: UIView!
    @IBOutlet weak var pyableAmoumtTF: JVFloatLabeledTextField!
    var name = ""
    var ammount = ""
    var mobilenumber = ""
    var emailAddress = ""
    var canID = ""
    override func viewDidLoad() {
        super.viewDidLoad()

        
        self.setView()
        // Do any additional setup after loading the view.
    }
    
    func setView(){
        
        
        setCornerRadiusView(radius: 15, color: UIColor.clear, view: backgroundView)
        
        setCornerRadiusView(radius: 20, color: UIColor.clear, view: buyNowButton)
        canIDTF.delegate = self
        placeholderTextColor(textfeildName: canIDTF, placeHolderText: "CAN ID", withColor: UIColor.gray)
        placeholderTextColor(textfeildName: nameTF, placeHolderText: "Account Name", withColor: UIColor.gray)
        placeholderTextColor(textfeildName: pyableAmoumtTF, placeHolderText: "Payable Amount", withColor: UIColor.gray)
        canIDTF.text = canID
        
        var nameValue = ""
        
        for (index,chacters) in name.enumerated(){
            
            if(index == 0 || index == name.count - 1 || String(chacters) == " " ){
                nameValue += "\(chacters)"
                
            }else{
                
                nameValue += "*"
            }
            
            
        }
        nameTF.text = nameValue
        pyableAmoumtTF.text = "₹ "
        pyableAmoumtTF.isEnabled = true
        
    }
    
    
    @IBAction func backButtonAction(_ sender: Any) {
        self.navigationController?.popViewController(animated: false)
    }
    
    @IBAction func payNowAction(_ sender: Any) {
       
        
        
      
        
//        let vc = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: ViewIdentifier.PayNowIdentifier) as? PayNowViewController
//        vc?.outStandingAmt = ammount
////        vc?.tdsAmount = ammount
//        vc?.tdsPercent = ""
//        vc?.canID = canID
//        vc?.screenFrom = ""
//        vc?.mobileNoStr = mobilenumber
//        vc?.emailStr = emailAddress
//        vc?.isForMultiPleAccount = true
//        self.navigationController?.pushViewController(vc!, animated: false)
        
       
        if let amount =  pyableAmoumtTF.text?.replacingOccurrences(of: "₹ ", with: ""){
            
            if amount != ""{
                
                if let value = Int(amount) as? Int{
                    
                    
                    if(value>0){
                
                
                
      let currentTime = HelpingClass.sharedInstance.getCurrentMillis()
      let  sessionTime = canID + String(describing: currentTime)

        let vc = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: ViewIdentifier.paymentScreenIdentifier) as? PaymentScreenViewController
        vc?.paymentStr = amount
        vc?.tdsAmount = amount
        vc?.sessionTime = sessionTime
        vc?.canID = canID
        vc?.mobileNoStr = mobilenumber
        vc?.emailStr = emailAddress
        vc?.isForMultiPleAccount = true
        //vc?.tdsPercent = ""
        self.navigationController?.pushViewController(vc!, animated: false)
                    }else{
                        
                        pyableAmoumtTF.text = "₹ "
                        
                        self.showAlertC(message: ErrorMessages.payableAmount)
                    }
                }else{
                    
                     pyableAmoumtTF.text = "₹ "
                    
                    self.showAlertC(message: ErrorMessages.payableAmount)
                }
                
            }else{
                
                self.showAlertC(message: ErrorMessages.payableAmount)
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
extension PayBillMultipleAccountsPaymentViewController:UITextFieldDelegate{
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool
    {
        guard let oldText = textField.text, let r = Range(range, in: oldText) else {
            return true
        }
        
        var newText = oldText.replacingCharacters(in: r, with: string)
        
      newText = newText.replacingOccurrences(of: "₹ ", with: "")
        let isNumeric = newText.isEmpty || (Double(newText) != nil)
        let numberOfDots = newText.components(separatedBy: ".").count - 1
        
        let numberOfDecimalDigits: Int
        if let dotIndex = newText.index(of: ".") {
            numberOfDecimalDigits = newText.distance(from: dotIndex, to: newText.endIndex) - 1
        } else {
            numberOfDecimalDigits = 0
        }
        
//        if(newText.count == 0){
//            return false
//        }
        return isNumeric && numberOfDots <= 1 && numberOfDecimalDigits <= 2
        
        
        
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool
    {
        textField.resignFirstResponder();
        
        return true;
    }
    
    
}
