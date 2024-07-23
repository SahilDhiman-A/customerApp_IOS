//
//  PaymentScreenViewController.swift
//  SpectraNet
//
//  Created by Bhoopendra on 9/12/19.
//  Copyright © 2019 Bhoopendra. All rights reserved.
//

import UIKit
import Razorpay

class PaymentScreenViewController: UIViewController,RazorpayPaymentCompletionProtocolWithData {
    
    var paymentStr = String()
    var emailStr = String()
    var nameStr = String()
    var mobileNoStr = String()
    var canID = String()
    var sessionTime = String()
    var tdsAmount = String()
    var postString = String()
    var isForMultiPleAccount = false
    var isForAutopay = false
    var dataResponse = NSDictionary()
    var checkStatus = String()
    var autoPayType = String()
    
    var profileListData = NSDictionary()
    var paymentURLStr = String()
    var screenFrom = String()
    // SI payment success or failed views
    @IBOutlet weak var transprntView: UIView!
    @IBOutlet weak var dialogView: UIView!
    @IBOutlet weak var lblStatusMsg: UILabel!
    @IBOutlet weak var okButtonView: UIView!
    
    @IBOutlet var messageView: UIView!
     @IBOutlet var messageLabel: UILabel!
    @IBOutlet var bottombuttonLabel: UILabel!
    
    var siPaymentStaus = String()
    
    var topupName = String()
    var pckgID = String()
    var topupType = String()
    
     var tdsAmountPerMonth = String()
      var urlStatus = String()
    var backToHome = false
    var razorpay: RazorpayCheckout!
    //MARK: View controller life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        //tdsAmount = "1"
        if postString != ""
        {
            loadData()
        }
            
        else if(isForMultiPleAccount == true){
            
             loadData()
        }
        else
        {
            serviceTypeGetProfile()
        }
        hiddenAndShowViews(bool: true, statusMeg: "")
    }
    
    func loadData()
    {
        if(isForAutopay){
            showPaymentFormAutoPay()

        }else{
            showPaymentForm()
        }
        setCornerRadiusView(radius: Float(okButtonView.frame.height/2), color: UIColor.clear, view: okButtonView)
    }
    
    
    private func showPaymentFormAutoPay(){
        
        var dict = ["Action":ActionKeys.createOrder, "Authkey":UserAuthKEY.authKEY,"amount":paymentStr,"emailId":emailStr,"mobileNo":mobileNoStr,"canId":canID,"requestType":autoPayType,"custName":nameStr] as [String : Any]
        if tdsAmount != ""
        {
            dict["amount"] = tdsAmount
        }
//        if(autoPayType == "2"){
//            
//            dict["amount"] = "0"
//        }
    
        
        CANetworkManager.sharedInstance.requestApiWithoutHUD(serviceName: ServiceMethods.serviceBaseUatValue, method: kHTTPMethod.POST, postData: dict as Dictionary<String, AnyObject>) { [weak self] (response, error) in
            
            print_debug(object: response)
            if response != nil
            {
                
                
                if let  responseValue = response?["status"] as? String{
                    
                    
                    if responseValue != Server.api_status
                    {
                        if let  statusMessage = response?[ "message"] as? String {
                           self?.showAlertC(message: statusMessage)
                            
                        }
                        return
                    }
                    
                }
                
                if let  responseValue = response?["response"] as? [String:AnyObject]{
    
                    self?.openrazorPay(responseValue: responseValue)
                
                } }
        }
    }

    
    private func showPaymentForm(){
        var dict = ["Action":ActionKeys.createTransaction, "Authkey":UserAuthKEY.authKEY,"pgId":"RAZORPAY","txnId":sessionTime,"amount":paymentStr,"emailId":emailStr,"mobileNo":mobileNoStr,"canId":canID,"requestType":UserAuthKEY.paymentType] as [String : Any]
        
       
        if tdsAmount != ""
        {
            
            dict["amount"] = tdsAmount
        }
        
        CANetworkManager.sharedInstance.requestApiWithoutHUD(serviceName: ServiceMethods.serviceBaseUatValue, method: kHTTPMethod.POST, postData: dict as Dictionary<String, AnyObject>) { [weak self] (response, error) in
            
            print_debug(object: response)
            if response != nil
            {
                
                
                if let  responseValue = response?["status"] as? String{
                    
                    
                    if responseValue != Server.api_status
                    {
                        if let  statusMessage = response?[ "message"] as? String {
                            self?.showAlertC(message: statusMessage)
                            
                        }
                        return
                    }
                    
                }
                
                if let  responseValue = response?["response"] as? [String:AnyObject]{
                    
                   
                    
                    self?.openrazorPay(responseValue: responseValue)
                
                } }
        }
        
        
    }
    
    func openrazorPay(responseValue:[String:AnyObject]){
        
        if let keyId = responseValue["keyId"] as? String, let order_id = responseValue["orderId"] as? String , let image = Bundle.main.icon{
            razorpay = RazorpayCheckout.initWithKey(keyId, andDelegateWithData: self)
       // razorpay = RazorpayCheckout.initWithKey(keyId, andDelegate: self)
            var options: [String:Any] = [
                   "key":keyId,
                    "amount": paymentStr, //This is in currency subunits. 100 = 100 paise= INR 1.
                    "currency": "INR",//We support more that 92 international currencies.
                    "order_id": order_id,
                    "image": image,
                   "name":"Spectra",
                "notes": [
                    "address":"Gurgaon",
                    "merchant_order_id":order_id
                ],
                    "prefill": [
                        "contact": mobileNoStr,
                        "email": emailStr,
                        "name":nameStr
                    ],
                    "theme": [
                        "color": "#000000",
                        "hide_topbar":true,
                        "backdrop_color": "#000000",
                        
                      ]
                ]
            
            
            if let customerId =  responseValue["customerId"] as? String {
                
                options["customer_id"] = customerId
            }
            
            if tdsAmount != ""
            {
                options["amount"] = tdsAmount
            }
            
            
            if(autoPayType == "2"){
            
                options["amount"] = "0"
                options["recurring"] = "1"
                   
            }
            print_debug(object: "options=== \(options) ")
            
            if((razorpay) != nil){
            razorpay.open(options)
            }
        }
    }
    
    @IBAction func confirmButtonClick(_ sender: Any) {
        if(backToHome){
            navigateScreen(identifier: ViewIdentifier.customTabIdentifier, controller: CustomTabViewController.self)
        }else{
            self.navigationController?.popViewController(animated: false)
        }
        
    }

    
    func serviceTypeChangePlan()
    {
        let dict = ["Action":ActionKeys.changePlane, "Authkey":UserAuthKEY.authKEY, "canId":canID, "pkgName":pckgID]
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
                    // TO DO change just like
                    if self.checkStatus == Server.api_status
                    {
                        self.messageView.isHidden = false
                        self.messageLabel.text = self.dataResponse.value(forKey: "message") as? String
                        self.bottombuttonLabel.text = "BACK TO HOME"
                        self.backToHome = true
                        self.changePlanSuccessFirbaseAnalysics()
                    }
                    else
                    {
                        self.changePlanFailureFirbaseAnalysics()
                        self.messageView.isHidden = false
                        self.messageLabel.text = self.dataResponse.value(forKey: "message") as? String
                        self.bottombuttonLabel.text = "BACK"
                        self.backToHome = false
                    }

                }
                else
                {
                    if let errorMsg = self.dataResponse.value(forKey: "message") as? String
                    {
                        
                        self.messageView.isHidden = false
                        self.messageLabel.text = self.dataResponse.value(forKey: "message") as? String
                        self.bottombuttonLabel.text = "BACK"
                        self.backToHome = false
                       // self.showAndHideDialogView(bool: false, message: errorMsg)
                    }
                }
            }
        }
    }
    
    func changePlanSuccessFirbaseAnalysics(){
        
        let dictAnalysics = [AnanlysicParameters.canID:canID,
                             AnanlysicParameters.Category:AnalyticsEventsCategory.change_plan,
                             AnanlysicParameters.Action:AnalyticsEventsActions.change_plan_success,
                             AnanlysicParameters.EventType:AnanlysicParameters.ClickEvent]

        HelpingClass.sharedInstance.addFirebaseAnalysis(eventName: AnalyticsEventsName.change_plan_success, parameters: dictAnalysics as? [String:AnyObject] ?? [String:AnyObject]() )
        
    }
    func changePlanFailureFirbaseAnalysics(){
        
        var dictAnalysics = [AnanlysicParameters.canID:canID,
                             AnanlysicParameters.Category:AnalyticsEventsCategory.change_plan,
                             AnanlysicParameters.Action:AnalyticsEventsActions.change_plan_failed,
                             AnanlysicParameters.EventType:AnanlysicParameters.ClickEvent] 
        
        if(HelpingClass.sharedInstance.planSucessData != nil){
            dictAnalysics = HelpingClass.sharedInstance.planSucessData
            
        }

        HelpingClass.sharedInstance.addFirebaseAnalysis(eventName: AnalyticsEventsName.change_plan_failed, parameters: dictAnalysics as? [String:AnyObject] ?? [String:AnyObject]() )
        
    }
    
    func serviceTypeAddTopUp()
    {
        let dict = ["Action":ActionKeys.addTopUp, "Authkey":UserAuthKEY.authKEY,"amount":tdsAmountPerMonth, "canID":canID, "topupName":topupName, "topupType":topupType]
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
                    if let successMsg = self.dataResponse.value(forKey: "message") as? String
                    {
                        
                        
                        let vc = UIStoryboard.init(name: "Storyboard", bundle: Bundle.main).instantiateViewController(withIdentifier: ViewIdentifier.topupIdentifier) as? TopupPlanViewController
                        vc?.canID = self.canID
                        vc?.basePlan = self.pckgID
                        if(self.topupType == "RC"){
                            vc?.onetimetopUpSelect = false
                        }else{
                            
                            vc?.onetimetopUpSelect = true
                        }
                        vc?.isTopUpAdded = true
                        vc?.isFromPayment = true
                        
                       
                        self.navigationController?.pushViewController(vc!, animated: false)

                    }
                }
                else
                {
                    if let errorMsg = self.dataResponse.value(forKey: "message") as? String
                    {
                        
                        self.messageView.isHidden = false
                        self.messageLabel.text = self.dataResponse.value(forKey: "message") as? String
                        self.bottombuttonLabel.text = "BACK"
                        self.backToHome = false
                       // self.showAndHideDialogView(bool: false, message: errorMsg)
                    }
                }
            }
        }
    }
    
    

    @IBAction func backBTM(_ sender: Any)
    {
        self.navigationController?.popViewController(animated: false)
    }
    
    func serviceTypeGetProfile()
    {
        let dict = ["Action":ActionKeys.getProfile, "Authkey":UserAuthKEY.authKEY, "canID":canID]
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
                    guard let userProfile = self.dataResponse.value(forKey: "response") as? NSDictionary else
                    {
                        return
                    }
                    self.profileListData = userProfile
                    
                    if AppDelegate.sharedInstance.segmentType == segment.userB2C
                    {
                        guard let UserB2CData = self.profileListData.value(forKey: "billTo") as? NSDictionary else
                        {
                            return
                        }
                        self.setData(dict: UserB2CData)
                    }
                    else
                    {
                        guard let UserB2BData = self.profileListData.value(forKey: "billTo") as? NSDictionary else
                        {
                            return
                        }
                        self.setData(dict: UserB2BData)
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
    
    func setData(dict: NSDictionary)
    {
        emailStr = ""
        if let email = dict.value(forKey: "email") as? String
        {
            emailStr = email
        }
        
        if let name = dict.value(forKey: "name") as? String
        {
            nameStr = name
        }
        
        mobileNoStr = ""
        if let mobileNmbr = dict.value(forKey: "mobile") as? String
        {
            mobileNoStr = mobileNmbr
        }
        
        loadData()
    }
    @IBAction func cliuckStatusButton(_ sender: Any)
    {
        hiddenAndShowViews(bool: true, statusMeg: "")
        if siPaymentStaus == Payment.success_status
        {
            navigateScreen(identifier: ViewIdentifier.customTabIdentifier, controller: CustomTabViewController.self)
        }
        else
        {
            self.navigationController?.popViewController(animated: false)
        }
    }
    
    func hiddenAndShowViews(bool: Bool,statusMeg: String)
    {
        transprntView.isHidden = bool
        dialogView.isHidden = bool
        lblStatusMsg.text = statusMeg
    }
    
      
    func onPaymentError(_ code: Int32, description str: String, andData response: [AnyHashable : Any]?) {
        debugPrint("error From razor PAy: ", code)
        debugPrint("str: ", str)
        debugPrint("response: ", response)
        let vc = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: ViewIdentifier.paymentstatusIndentifier) as? PaymentStatusViewController
                    
                   
                    vc?.status = Payment.failure_status
                   // vc?.ifSiPayment = ""
                    vc?.payableAmount = tdsAmount
                    self.navigationController?.pushViewController(vc!, animated: false)
        //self.presentAlert(withTitle: "Alert", message: str)
    }
    
    func onPaymentSuccess(_ payment_id: String, andData response: [AnyHashable : Any]?) {
        debugPrint("success: ", payment_id)
        debugPrint("response: ", response ?? [])
        if(isForAutopay){
            
            updatePaymentToServerAutoPAy(response: response ?? [:])
        }else{
            updatePaymentToServer(response: response ?? [:])
            
        }
      //  self.presentAlert(withTitle: "Success", message: "Payment Succeeded")
    }
    
    
    func updatePaymentToServer(response:[AnyHashable : Any]){
        
        if let razorpay_payment_id = response["razorpay_payment_id"] as? String, let razorpay_order_id = response["razorpay_order_id"] as? String, let razorpay_signature = response["razorpay_signature"] as? String{
        let dict = ["Action":ActionKeys.updatePaymentStatus, "Authkey":UserAuthKEY.authKEY,"orderId":razorpay_order_id] as [String : Any]
            
            CANetworkManager.sharedInstance.requestApiWithoutHUD(serviceName: ServiceMethods.serviceBaseUatValue, method: kHTTPMethod.POST, postData: dict as Dictionary<String, AnyObject>) { [weak self] (response, error) in
                
                print_debug(object: response)
                if response != nil
                {
                    
                    
                    if let  responseValue = response?["status"] as? String{
                        
                        
                        if responseValue.lowercased() != Server.api_status
                        {
                            if let  statusMessage = response?[ "message"] as? String {
                                let vc = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: ViewIdentifier.paymentstatusIndentifier) as? PaymentStatusViewController
                                            
                                           
                                            vc?.status = Payment.failure_status
                                           // vc?.ifSiPayment = ""
                                vc?.payableAmount = self?.tdsAmount ?? ""
                                self?.navigationController?.pushViewController(vc!, animated: false)
                                //self.presentAlert(withTitle: "Alert", message: str)
                            }
                                
                            
                            return
                        }
                        
                    }
                    
                    if let  responseValue = response?["response"] as? [String:AnyObject]{
                        
                       
                        if(self?.screenFrom == FromScreen.topUpScreen){
                                    
                                    self?.serviceTypeAddTopUp()
                                    
                        }else if(self?.screenFrom == FromScreen.changeTopUPScreen || self?.screenFrom == FromScreen.CompareTopUPScreen){
                                    //to do payment successful snakbar
                                    let snackbar = TTGSnackbar(message: "Payment Successful", duration: .middle)
                                    snackbar.show()
                            self?.serviceTypeChangePlan()
                                   }else{
                                    
                                    let vc = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: ViewIdentifier.paymentstatusIndentifier) as? PaymentStatusViewController
                                    
                                   
                                    
                                     vc?.status = Payment.success_status
                                    // vc?.ifSiPayment = ""
                                   vc?.payableAmount = self?.tdsAmount ?? ""
                                    self?.navigationController?.pushViewController(vc!, animated: false)
                                    
                                    }
                        
                    
                    } }
            }
        }
        
        
    }
    func updatePaymentToServerAutoPAy(response:[AnyHashable : Any]){
        if let razorpay_payment_id = response["razorpay_payment_id"] as? String, let razorpay_order_id = response["razorpay_order_id"] as? String, let razorpay_signature = response["razorpay_signature"] as? String{
            
            //"":"pay_H3qajjJOiYVDhT"
            let dict = ["Action":ActionKeys.updateStatusForAutopay, "Authkey":UserAuthKEY.authKEY,"orderId":razorpay_order_id,"paymentId":razorpay_payment_id] as [String : Any]

            CANetworkManager.sharedInstance.requestApiWithoutHUD(serviceName: ServiceMethods.serviceBaseUatValue, method: kHTTPMethod.POST, postData: dict as Dictionary<String, AnyObject>) { [weak self] (response, error) in

                print_debug(object: response)
                if response != nil
                {


                    if let  responseValue = response?["status"] as? String{


                        var value = Payment.success_status

                        if responseValue.lowercased() != Server.api_status
                        {
                            value = Payment.failure_status



                        }


                        if let  statusMessage = response?[ "message"] as? String {
                            let vc = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: ViewIdentifier.paymentstatusIndentifier) as? PaymentStatusViewController


                                        vc?.status = value

                            vc?.payableAmount = self?.tdsAmount ?? ""
                            self?.navigationController?.pushViewController(vc!, animated: false)
                            //self.presentAlert(withTitle: "Alert", message: str)
                        }

                    }


                    } }




    }
    }
}





extension Bundle {
    public var icon: UIImage? {
        if let icons = infoDictionary?["CFBundleIcons"] as? [String: Any],
            let primaryIcon = icons["CFBundlePrimaryIcon"] as? [String: Any],
            let iconFiles = primaryIcon["CFBundleIconFiles"] as? [String],
            let lastIcon = iconFiles.last {
            return UIImage(named: lastIcon)
        }
        return nil
    }
}
