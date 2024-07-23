//
//  OutstandingBalancePAymentViewController.swift
//  My Spectra
//
//  Created by Chakshu on 12/03/20.
//  Copyright © 2020 Bhoopendra. All rights reserved.
//

import UIKit

class OutstandingBalancePaymentViewController: UIViewController {
    
    @IBOutlet weak var desctptionCenterView: NSLayoutConstraint!
    @IBOutlet weak var viewHeight: NSLayoutConstraint!
    @IBOutlet weak var yesButtonWidthConstaint: NSLayoutConstraint!
    @IBOutlet weak var billInvoiceWidth: NSLayoutConstraint!
    @IBOutlet var outstandingAmountWidthConstain: NSLayoutConstraint!
    
    var outStandingAmount = String()
     var dueDateString = ""
    var desctptionText = String()
    var previousPlan = ""
    var endDate = ""
    
    var messageCode = String()
    var canId = String()
    var srNo = "";
    var ETRvalue = "";
    @IBOutlet weak var decrptionLabel: UILabel!
    @IBOutlet weak var headingLabel: UILabel!
    
    @IBOutlet weak var paymentView: UIView!
    @IBOutlet weak var outstanddingView: UIView!
    @IBOutlet weak var yesNoView: UIView!
    @IBOutlet weak var billInvoice: UIView!
    @IBOutlet weak var backToHomeView: UIView!
    @IBOutlet weak var invoiceView: UIView!
    
    
    @IBOutlet weak var invoiceNumberLabel: UILabel!
    @IBOutlet weak var invoiceDateLabel: UILabel!
    @IBOutlet weak var invoiceFromDateLabel: UILabel!
    @IBOutlet weak var invoiceToDateLabel: UILabel!
    @IBOutlet weak var invoiceAmountLabel: UILabel!
    @IBOutlet weak var invoiceDueLabel: UILabel!
    
    @IBOutlet weak var otherView: UIView!
    @IBOutlet weak var otherTextView: JVFloatLabeledTextView!
    
    
    var invoice = [String:AnyObject]()
   
    var invoiceDataResponse = NSDictionary()
    override func viewDidLoad() {
        super.viewDidLoad()
        invoiceView.isHidden = true
        otherView.isHidden = true
        decrptionLabel.text = desctptionText
        self.setupUI()
        
        
        
        // Do any additional setup after loading the view.
    }
    
    override func viewWillLayoutSubviews() {
        
        if(self.view.frame.size.height <= 568)
        {
            yesButtonWidthConstaint.constant = 110
            outstandingAmountWidthConstain.constant = 110
            billInvoiceWidth.constant = 110
        }
        switch messageCode {
            
        case NoInternetMessageCode.accountRecativeFlag:
            
            if(self.previousPlan != ""){
                if(self.view.frame.size.height <= 568)
                               {
                                   desctptionCenterView.constant = 0
                                   viewHeight.constant = 350
                              }else{
                
                desctptionCenterView.constant = 0
                          viewHeight.constant = 300
                }
            }else{
                
               if(self.view.frame.size.height <= 568)
                {
                    desctptionCenterView.constant = 0
                    viewHeight.constant = 250
               }else{
                
                desctptionCenterView.constant = 0
                          viewHeight.constant = 200
                }
            }
          
            break
        case NoInternetMessageCode.accountActiveFlag:
            desctptionCenterView.constant = 0
            viewHeight.constant = 360
            
        case NoInternetMessageCode.massOutrage,NoInternetMessageCode.OpenSR:
            desctptionCenterView.constant = 0
            viewHeight.constant = 400
            break
        case NoInternetMessageCode.serviceBar:
            desctptionCenterView.constant = 0
            viewHeight.constant = 320
            
            break
     case NoInternetMessageCode.SafeCustody:
         desctptionCenterView.constant = 0
         viewHeight.constant = 280
    break
    case NoInternetMessageCode.OutstandingBalanceFlag:
         desctptionCenterView.constant = 0
         viewHeight.constant = 320
            break
   case NoInternetMessageCode.enableSafeCustodytoActive:
    
    
  if(Double(self.outStandingAmount)
                    ?? 0 > 0){
           desctptionCenterView.constant = 0
           viewHeight.constant = 350
      }else{
       desctptionCenterView.constant = 0
       viewHeight.constant = 230
            }
        default:
            if  let font = UIFont(name: "Helvetica", size: 20.0){
                let height = HelpingClass.sharedInstance.heightForView(text:desctptionText, font: font, width: self.view.frame.width - 80)
                desctptionCenterView.constant = 0
                viewHeight.constant = height + 80
            }
        }
        super.viewWillLayoutSubviews()
    }
    
    
    @IBAction func paymentScreen(_ sender: Any)
    {
        
        if let number = Int(outStandingAmount){
            
            if(number == 0){
                 self.showSimpleAlert(TitaleName: "", withMessage: "Payable amount cann't be 0")
                
            }
        }
        
        let vc = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: ViewIdentifier.PayNowIdentifier) as? PayNowViewController
        vc?.outStandingAmt = outStandingAmount
        vc?.tdsAmount = ""
        vc?.tdsPercent = ""
        vc?.canID = self.canId
        
        self.navigationController?.pushViewController(vc!, animated: false)
        
        
    }
    @IBAction func viewInvoice(_ sender: Any)
    {
         invoiceView.isHidden = false
        
       
        
        if let invoiceData = self.invoice as? [String:AnyObject]{
           
            if let dueDate = invoiceData["dueDate"] as? String{
                invoiceDueLabel.text = dueDate
            }
            if let fromDate = invoiceData["fromDate"] as? String{
                           invoiceFromDateLabel.text = fromDate
                       }
            if let invoiceAmount = invoiceData["invoiceAmount"]{
                           invoiceAmountLabel.text = "\(invoiceAmount)"
                       }
            if let invoiceDate = invoiceData["invoiceDate"] as? String{
                           invoiceDateLabel.text = invoiceDate
                       }
            if let invoiceNo = invoiceData["invoiceNo"] as? String{
                           invoiceNumberLabel.text = invoiceNo
                       }
            if let toDate = invoiceData["toDate"] as? String{
                           invoiceToDateLabel.text = toDate
                       }
            
            
        }
        
        
        
        
        
        
    }
    
    @IBAction func invoiceCancel(_ sender: Any)
    {
         invoiceView.isHidden = true
        
    }
    
    @IBAction func submitButton(_ sender: Any)
       {
            
        
        let dict = ["Action":ActionKeys.createSR, "Authkey":UserAuthKEY.authKEY,"caseType":"9", "canID":self.canId, "comment":otherTextView.text as Any] as [String : Any]
               
               CANetworkManager.sharedInstance.requestApi(serviceName: ServiceMethods.serviceBaseURL, method: kHTTPMethod.POST, postData: dict as Dictionary<String, AnyObject>) { (response, error) in
                self.otherView.isHidden = true
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
                       
                     Switcher.updateRootVC()
                   }
           
       }
    }
    
    @IBAction func backButtonClick(_ sender: Any)
    {
        
        switch messageCode {
                 
        case NoInternetMessageCode.accountRecativeFlag,NoInternetMessageCode.OutstandingBalanceFlag:
             otherView.isHidden = false
             self.otherTextView.becomeFirstResponder()
            break
                 
        case NoInternetMessageCode.enableSafeCustodytoActive:
            
            Switcher.updateRootVC()
            
            break
            
             default:
                otherView.isHidden = false
                 self.otherTextView.becomeFirstResponder()
                 break
                 
             }
        
        
    }
    
    
    @IBAction func okButtonClick(_ sender: Any)
    {
        
        switch messageCode {
            
        case NoInternetMessageCode.SafeCustody:
            
            self.enableSafeCustodytoActive()
            
      case NoInternetMessageCode.accountRecativeFlag:
            
            self.reactivateAcoount()
            
        default:
            break
        }
        
    }
    
    
    func reactivateAcoount(){
        
        
        CANetworkManager.sharedInstance.progressHUD(show: true)
        
        let apiURL = ServiceMethods.serviceBaseURLInternetNotWorking + UserAuthKEY.authKEYInternetNotWorking + "/" + ServiceKeys.canId + "/"  + self.canId
        
        let dict = ["reactivateAccount":"True"] as [String : Any]
        
        print_debug(object: "apiURL =" + apiURL)
        CANetworkManager.sharedInstance.requestApiWithoutHUD(serviceName: apiURL, method: kHTTPMethod.POST, postData: dict as Dictionary<String, AnyObject>) { (response, error) in
            
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
                    
                    if let responce = dataResponse["response"] as? [String:AnyObject]{
                        
                        if let outstandingAount = responce["outstandingAmount"] as? AnyObject{
                            self.outStandingAmount = "\(outstandingAount)"
                        }
                        if let description = responce["messageDescription"] as? String{
                            self.desctptionText = description
                        }
                        
                        if let srNo = responce["srNo"] as? String{
                            self.srNo = srNo
                             self.serviceTypeGetSRStatus(useKey: "srNumber", useNumber: self.srNo)
                        }
                        
                       
                        
                        if let  messageCode = responce["messageCode"] as? String{
                            
                            self.messageCode = messageCode
                            
                        }
                        
                    }
                }else{
                    
                    CANetworkManager.sharedInstance.progressHUD(show: false)
                }
            }else{
                
                CANetworkManager.sharedInstance.progressHUD(show: false)
            }
        }
    }
    
    
    func enableSafeCustodytoActive(){
        
        
        let apiURL = ServiceMethods.serviceBaseURLInternetNotWorking + UserAuthKEY.authKEYInternetNotWorking + "/" + ServiceKeys.canId + "/"  + self.canId
        
        let dict = ["enableSafeCustodytoActive":"True"] as [String : Any]
        
        print_debug(object: "apiURL =" + apiURL)
        CANetworkManager.sharedInstance.requestApi(serviceName: apiURL, method: kHTTPMethod.POST, postData: dict as Dictionary<String, AnyObject>) { (response, error) in
            
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
                    
                    if let responce = dataResponse["response"] as? [String:AnyObject]{
                        
//                        if let outstandingAount = responce["outstandingAmount"] as? AnyObject{
//                            self.outStandingAmount = "\(outstandingAount)"
//                        }
                        if let description = responce["messageDescription"] as? String{
                            self.desctptionText = description
                        }
                        
                        if let  messageCode = responce["messageCode"] as? String{
                            
                            self.messageCode = messageCode
                            
                        }
                        self.setupUI()
                    }
                }
            }
        }
    }
    
    @IBAction func backToHome(_ sender: Any)
    {
        Switcher.updateRootVC()
        
    }
    
    func setupUI()  {
        paymentView.isHidden = true
        yesNoView.isHidden = true
        outstanddingView.isHidden = true
        backToHomeView.isHidden = true
        decrptionLabel.text = desctptionText
        decrptionLabel.isHidden = true
        billInvoice.isHidden = true
        headingLabel.isHidden = true
        switch messageCode {
            
        case NoInternetMessageCode.accountRecativeFlag:
            decrptionLabel.text = ""
            let attributes = [NSAttributedString.Key.font: UIFont(name: "HelveticaNeue-Bold", size: 20)!,
                              NSAttributedString.Key.foregroundColor: UIColor.black]
            
            let attributedText = NSMutableAttributedString(string: "Great !! Welcome Back", attributes: attributes)
            
            let attributedTextSpace = NSMutableAttributedString(string: "\n", attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 17)])
            attributedText.append(attributedTextSpace)
            attributedText.append(attributedTextSpace)
            if(self.previousPlan != ""){
            
            let attributedOldPlan = NSMutableAttributedString(string: "Your old plan was\n", attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 17)])
            attributedText.append(attributedOldPlan)
            
            let attributedPlanId = NSMutableAttributedString(string: "\(self.previousPlan)", attributes: attributes)
            attributedText.append(attributedPlanId)
            attributedText.append(attributedTextSpace)
            attributedText.append(attributedTextSpace)
            let attributedOldContinue = NSMutableAttributedString(string: "Would you like to continue with it ?", attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 17)])
            attributedText.append(attributedOldContinue)
            }else{
                let attributedOldContinue = NSMutableAttributedString(string: "Would you like to continue ?", attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 17)])
                attributedText.append(attributedOldContinue)
                
            }
            
            decrptionLabel.attributedText = attributedText
            yesNoView.isHidden = false
            decrptionLabel.isHidden = false
            
        case NoInternetMessageCode.accountActiveFlag:
            decrptionLabel.text = ""
            let attributedTextSpace = NSMutableAttributedString(string: "\n", attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 17)])
            
            
            let attributedText = NSMutableAttributedString(string: "You may start using your\n internet from\n", attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 17)])
            
            
            if let value = HelpingClass.sharedInstance.convert(time: ETRvalue, fromFormate: "MM/dd/yyyy hh:mm:ss a", toFormate:"dd/MM/yyyy hh:mm a" ){
            let attributedDate = NSMutableAttributedString(string: "\(value).", attributes:  [NSAttributedString.Key.font: UIFont(name: "HelveticaNeue-Bold", size: 20)!])
                 attributedText.append(attributedDate)
            }
            //
            //
           
            attributedText.append(attributedTextSpace)
            attributedText.append(attributedTextSpace)
            attributedText.append(attributedTextSpace)
            //
            let attributedPlan = NSMutableAttributedString(string: "We will send you a notification when it is ready !\n\n\n Thank you for giving us an opportunity to serve you again!", attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 17)])
            attributedText.append(attributedPlan)
            
            
            
            decrptionLabel.attributedText = attributedText
            backToHomeView.isHidden = false
            decrptionLabel.isHidden = false
            
            case NoInternetMessageCode.massOutrage:
                        decrptionLabel.text = ""
                       let attributedText = NSMutableAttributedString(string: "There is an outage in your\n area which is expected to\n be restored by\n", attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 17)])
                       
                        if let value = HelpingClass.sharedInstance.convert(time: dueDateString, fromFormate: "dd/MM/yyyy HH:mm:ss", toFormate:"dd/MM/yyyy hh:mm a" ){
                       let attributedDate = NSAttributedString(string: " \(value) \n", attributes:  [NSAttributedString.Key.font: UIFont(name: "HelveticaNeue-Bold", size: 20)!])
                       attributedText.append(attributedDate)
                        }else{
                           
                           if let value = HelpingClass.sharedInstance.convert(time: dueDateString, fromFormate: "MM/dd/yyyy hh:mm:ss a", toFormate:"dd/MM/yyyy hh:mm a" ){
                               let attributedDate = NSAttributedString(string: " \(value) \n", attributes:  [NSAttributedString.Key.font: UIFont(name: "HelveticaNeue-Bold", size: 20)!])
                                          attributedText.append(attributedDate)
                               
                           }
                           
                        }
                       
                       
                       
                       let attributedBody = NSAttributedString(string: "\n\n\n Your internet will start working\n automatically after this time.\n Sorry for the inconvenience caused.", attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 17)])
                       attributedText.append(attributedBody)
                       
                       decrptionLabel.attributedText = attributedText
                       backToHomeView.isHidden = false
                       decrptionLabel.isHidden = false
       
            
            
        case NoInternetMessageCode.OutstandingBalanceFlag:
             decrptionLabel.text = ""
            let attributedText = NSMutableAttributedString(string: "There is an outstanding of\n", attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 17)])
                  
             if let myInteger = Double(outStandingAmount) {
             
             if let number = NSNumber(value: myInteger) as? NSNumber{
                let attributedDate = NSAttributedString(string: "Rs \(df2so(Double(number))).", attributes:  [NSAttributedString.Key.font: UIFont(name: "HelveticaNeue-Bold", size: 20)!])
                                 attributedText.append(attributedDate)
               
             }
             }
                                 
                
                                 
                                 let attributedBody = NSAttributedString(string: "\nin your account.\n\n\nKindly clear this to get account\n activated and enjoy uninterrupted\n services.", attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 17)])
                                 attributedText.append(attributedBody)
                                 
                                 decrptionLabel.attributedText = attributedText
            outstanddingView.isHidden = false
            decrptionLabel.isHidden = false
            
        case NoInternetMessageCode.serviceBar:
             headingLabel.isHidden = false
             decrptionLabel.text = ""
             headingLabel.text = "Your account is currently Barred\ndue to nonpayment of your dues/pending payment"
            let attributedText = NSMutableAttributedString(string: "Total Amount Due\n", attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 16)])
                      
             
              if let myInteger = Double(outStandingAmount) {
                         
                         if let number = NSNumber(value: myInteger) as? NSNumber{
                      let attributedDate = NSAttributedString(string: " RS \(df2so(Double(number)))", attributes:  [NSAttributedString.Key.font: UIFont(name: "HelveticaNeue-Bold", size: 20)!])
                      attributedText.append(attributedDate)
                            }
                                           }
        
             
             
                      
             let attributedDueOn = NSAttributedString(string: "\nDue On ", attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 16)])
              attributedText.append(attributedDueOn)
             
             
             if let date = HelpingClass.sharedInstance.convert(time: dueDateString, fromFormate: "dd/MM/yyyy", toFormate: "MMM dd,YYYY") as? String{
             
             let attributedDueDate = NSAttributedString(string: date, attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 17),NSAttributedString.Key.foregroundColor: UIColor.red])
                       attributedText.append(attributedDueDate)
             }
//                      
                      let attributedBody = NSAttributedString(string: "\n\n\nKindly Clear this to get account\nactivated and enjoy uninterrupted\nService", attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 16)])
                      attributedText.append(attributedBody)
                      
                      decrptionLabel.attributedText = attributedText
                      billInvoice.isHidden = false
                      decrptionLabel.isHidden = false
            
        case NoInternetMessageCode.SafeCustody:
              let attributedText = NSMutableAttributedString(string: "Your account is under\n safe custody till\n", attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 17)])
                                
                                let attributedDate = NSAttributedString(string: " \(endDate).", attributes:  [NSAttributedString.Key.font: UIFont(name: "HelveticaNeue-Bold", size: 20)!])
                                attributedText.append(attributedDate)
                            
              
              
             
                let attributedBody = NSAttributedString(string: "\n\n\nWould you like to remove your\n account from Safe Custody ?", attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 17)])
                                              attributedText.append(attributedBody)
                 yesNoView.isHidden = false
            
                              
                                
                                decrptionLabel.attributedText = attributedText
                               
                                decrptionLabel.isHidden = false
            
     
        case NoInternetMessageCode.enableSafeCustodytoActive:
            
            decrptionLabel.isHidden = false
            
            let attributedText = NSMutableAttributedString(string:  "Your account has been\n activated now.\n\n Please continue enjoying Spectra services.", attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 17)])
           
            if(Double(self.outStandingAmount)
                ?? 0 > 0){
                
//                let attributedBody = NSAttributedString(string: "\n\n\nThere is an outstanding of Rs \(self.outStandingAmount) in your account. Kindly clear this to enjoy uninterrupted services", attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 17)])
                
                //attributedText.append(attributedBody)
                
                  let attributedBody = NSAttributedString(string: "\n\n\nThere is an outstanding of", attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 17)])
                attributedText.append(attributedBody)
                
                if let myInteger = Double(outStandingAmount) {
                      
                      if let number = NSNumber(value: myInteger) as? NSNumber{
                 let attributedBodyOne = NSAttributedString(string: " Rs \(df2so(Double(number))) ", attributes: [NSAttributedString.Key.font: UIFont(name: "HelveticaNeue-Bold", size: 20)!])
                attributedText.append(attributedBodyOne)
                
                 let attributedBodyTwo = NSAttributedString(string:  "in your account. Kindly clear this to enjoy uninterrupted services", attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 17)])
                attributedText.append(attributedBodyTwo)
                        
                    }
                    
                    
                  }
                    
                               
                    outstanddingView.isHidden = false
                
            }else{
                
                backToHomeView.isHidden = false
            }
            
            
             decrptionLabel.attributedText = attributedText
            
//        case NoInternetMessageCode.OutstandingBalanceFlagSafeCustody:
//            paymentView.isHidden = false
//            decrptionLabel.isHidden = false
            
       
            
      
      
            default:
            break
    }
    }
    
    func serviceTypeGetSRStatus(useKey: String, useNumber: String)
       {
           let dict = ["Action":ActionKeys.getSRStatus, "Authkey":UserAuthKEY.authKEY, useKey:useNumber]
           print_debug(object: dict)
           CANetworkManager.sharedInstance.requestApiWithoutHUD(serviceName: ServiceMethods.serviceBaseURL, method: kHTTPMethod.POST, postData: dict as Dictionary<String, AnyObject>) { (response, error) in
               
               print_debug(object: response)
            
            CANetworkManager.sharedInstance.progressHUD(show: false)
            
            if response != nil
            {
                
                if let status = response?["status"] as? String{
                    
                    
                    if status.lowercased() == Server.api_status{
                        
                        
                        if let array = response?["response"] as? [[String:AnyObject]]{
                            
                            
                            if array.count > 0 {
                                if let value = array[0] as? [String:AnyObject]{
                                    
                                    if let ETR = value["ETR"] as? String{
                                        self.ETRvalue = ETR
                                       
                                    }
                                   
                                     self.setupUI()
                                    
                                }
                                
                                
                            }
                            
                            
                            
                        }
                        
                    }
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
    func showSimpleAlert(TitaleName: String, withMessage: String)
    {
        let alert = UIAlertController(title: TitaleName, message: withMessage,preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: AlertViewButtonTitle.title_OK,style: UIAlertAction.Style.default,handler: {(_: UIAlertAction!) in
            
       
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
   


func df2so(_ price: Double) -> String{
    let numberFormatter = NumberFormatter()
    numberFormatter.groupingSeparator = ","
    numberFormatter.groupingSize = 3
    numberFormatter.usesGroupingSeparator = true
    numberFormatter.decimalSeparator = "."
    numberFormatter.numberStyle = .decimal
    numberFormatter.maximumFractionDigits = 2
    return numberFormatter.string(from: price as NSNumber)!
}

}
