//
//  ChangePlanCompairViewController.swift
//  My Spectra
//
//  Created by Chakshu on 27/11/20.
//  Copyright © 2020 Bhoopendra. All rights reserved.
//

import UIKit
import RealmSwift
class ChangePlanCompareViewController: UIViewController {

    var realm:Realm? = nil
    var userResult:Results<UserCurrentData>? = nil
    @IBOutlet weak var lblRemarks: UILabel!
    @IBOutlet var lblCurrentPlanDate: UILabel!
    @IBOutlet var lblChangeOfduration: UILabel!
    @IBOutlet var lblbalanceAmount: UILabel!
    @IBOutlet var lblNewPlanCharges: UILabel!
    @IBOutlet var lblDifferentAmountPayable: UILabel!
    @IBOutlet var lblTax: UILabel!
    @IBOutlet var lblTotal: UILabel!
    var differenceResponce = [String:AnyObject]()
    var dataResponse = NSDictionary()
    var checkStatus = String()
    @IBOutlet var lblchangeLabel: UILabel!
    @IBOutlet var messageView: UIView!
    @IBOutlet var messageLabel: UILabel!
    @IBOutlet var bottombuttonLabel: UILabel!
    var canID = String()
    var pckgID = String()
    var data = String()
    var spead = String()
    var frequency = String()
    var backToHome = false
    override func viewDidLoad() {
        super.viewDidLoad()

        
        self.setUPUI()
        // Do any additional setup after loading the view.
        
    }
    
    
    func setUPUI()  {
        realm = try? Realm()
       
        userResult = self.realm!.objects(UserCurrentData.self)
        if let currentPlanDate = differenceResponce["Current plan Activation date"] as? String{
            
            if let date = HelpingClass.sharedInstance.convert(time: currentPlanDate, fromFormate: "dd/MM/yyyy ", toFormate: "MMM dd, yyyy"){
                self.lblCurrentPlanDate.text = date
            }
        }
        
        if let changes = differenceResponce["Charges for Duration consumed"] as? Double{
            
            self.lblChangeOfduration.text = "₹"+"\(changes)"
        }
        if let balance = differenceResponce["Balance amount to be reversed"] as? Double{
            
            self.lblbalanceAmount.text = "₹"+"\(balance)"
        }
        if let new = differenceResponce["New Plan Charges"] as? Double{
            
            self.lblNewPlanCharges.text = "₹"+"\(new)"
        }
        if let difference = differenceResponce["Difference Amount Payable"] as? Double{
            
            self.lblDifferentAmountPayable.text = "₹"+"\(difference)"
        }
        
        if let taxes = differenceResponce["taxes"] as? Double{
            self.lblTax.text = "₹"+"\(taxes)"
        }
        
        if let pgDataCharges = differenceResponce["pgDataCharges"] as? Double{
            
            if(pgDataCharges > 0){
                self.lblchangeLabel.text = "PAY NOW"
            }else{
                
                self.lblchangeLabel.text = "CHANGE PLAN"
            }
            self.lblTotal.text = "₹"+"\(pgDataCharges)"
        }
        if let remarks = differenceResponce["remarks"] as? String {
            self.lblRemarks.text = "Remarks: \(remarks)"
        }
        
        
        self.changePlanSlecectFirbaseAnalysics(new_plan_charges: self.lblNewPlanCharges.text ?? "" , new_plan_data: data, new_plan_speed: spead, new_plan_frequency: frequency)
    }
    
    func changePlanSlecectFirbaseAnalysics(new_plan_charges:String,new_plan_data:String,new_plan_speed:String,new_plan_frequency:String){
        
        let dictAnalysics = [AnanlysicParameters.canID:canID,
                             AnanlysicParameters.Category:AnalyticsEventsCategory.change_plan,
                             AnanlysicParameters.Action:AnalyticsEventsActions.change_plan_select,
                             AnanlysicParameters.EventType:AnanlysicParameters.ClickEvent,
                             "new_plan_charges":new_plan_charges,
                             "new_plan_data":new_plan_data,
                             "new_plan_speed":new_plan_speed,
                             "new_plan_frequency":new_plan_frequency]

        HelpingClass.sharedInstance.addFirebaseAnalysis(eventName: AnalyticsEventsName.change_plan_select, parameters: dictAnalysics as? [String:AnyObject] ?? [String:AnyObject]() )
        
    }
    
    @IBAction func changePlanStepClick(sender: UIButton!) {
        
//        self.planCnfrmView.isHidden = true
//        self.compairStepView.isHidden = true
        if let pgDataCharges = differenceResponce["pgDataCharges"] as? Double,let proDataCharges = differenceResponce["New Plan Charges"] as? Double {
            if pgDataCharges > 0{
                                           self.paymentForChangePlan(outStandingAmt: "\(proDataCharges)", tdsAmount: "\(pgDataCharges)")
                                       }else{
                                           self.serviceTypeChangePlan()
           
                                       }
        }
        
       
    }
    @IBAction func changePlanCancelClick(sender: UIButton!) {
        
        self.navigationController?.popViewController(animated: false)
//        self.planCnfrmView.isHidden = true
//        self.compairStepView.isHidden = true
    }
    
    func serviceTypeChangePlan()
    {
        let dict = ["Action":ActionKeys.changePlane, "Authkey":UserAuthKEY.authKEY, "canId":canID, "pkgName":pckgID]
        print_debug(object: dict)
        CANetworkManager.sharedInstance.requestApi(serviceName: ServiceMethods.serviceBaseUatValue, method: kHTTPMethod.POST, postData: dict as Dictionary<String, AnyObject>) { (response, error) in
            
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
                    self.changePlanSuccessFirbaseAnalysics()
                    self.messageView.isHidden = false
                    self.messageLabel.text = self.dataResponse.value(forKey: "message") as? String
                    self.bottombuttonLabel.text = "BACK TO HOME"
                }
                else
                {
                    self.changePlanFailureFirbaseAnalysics()
                    self.messageView.isHidden = false
                    self.messageLabel.text = self.dataResponse.value(forKey: "message") as? String
                    self.bottombuttonLabel.text = "BACK"
                }
            }
        }
    }
    
    func changePlanSuccessFirbaseAnalysics(){
        
        var dictAnalysics = [AnanlysicParameters.canID:canID,
                             AnanlysicParameters.Category:AnalyticsEventsCategory.change_plan,
                             AnanlysicParameters.Action:AnalyticsEventsActions.change_plan_success,
                             AnanlysicParameters.EventType:AnanlysicParameters.ClickEvent]
        if let userActData = userResult?[0]
        {
            dictAnalysics["current_plan_charges"] = userActData.InvoiceAmount
            dictAnalysics["current_plan_data"] = userActData.planDataVolume
            dictAnalysics["current_plan_speed"] = userActData.Speed
            dictAnalysics["current_plan_frequency"] = userActData.BillFrequency
            
        }

        HelpingClass.sharedInstance.addFirebaseAnalysis(eventName: AnalyticsEventsName.change_plan_success, parameters: dictAnalysics as? [String:AnyObject] ?? [String:AnyObject]() )
        
    }
    
    func changePlanFailureFirbaseAnalysics(){
        
        var dictAnalysics = [AnanlysicParameters.canID:canID,
                             AnanlysicParameters.Category:AnalyticsEventsCategory.change_plan,
                             AnanlysicParameters.Action:AnalyticsEventsActions.change_plan_failed,
                             AnanlysicParameters.EventType:AnanlysicParameters.ClickEvent]
        if let userActData = userResult?[0]
        {
            dictAnalysics["current_plan_charges"] = userActData.InvoiceAmount
            dictAnalysics["current_plan_data"] = userActData.planDataVolume
            dictAnalysics["current_plan_speed"] = userActData.Speed
            dictAnalysics["current_plan_frequency"] = userActData.BillFrequency
            if let new = differenceResponce["New Plan Charges"] as? Double{
            dictAnalysics["new_plan_charges"] = "\(new)"
            }
            dictAnalysics["new_plan_data"] = "\(data)"
            dictAnalysics["new_plan_speed"] = "\(spead)"
            dictAnalysics["new_plan_frequency"] = "\(frequency)"
            
        }

        HelpingClass.sharedInstance.addFirebaseAnalysis(eventName: AnalyticsEventsName.change_plan_failed, parameters: dictAnalysics as? [String:AnyObject] ?? [String:AnyObject]() )
        
    }
    
    func paymentForChangePlan(outStandingAmt:String,tdsAmount:String){
        let vc = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: ViewIdentifier.PayNowIdentifier) as? PayNowViewController
        vc?.outStandingAmt = tdsAmount
        vc?.tdsAmount = ""
        vc?.tdsPercent = ""
        vc?.canID = canID
        vc?.pckgID = pckgID
//       vc?.topupType = topupType
        vc?.screenFrom = FromScreen.changeTopUPScreen
        vc?.tdsAmountPerMonth = outStandingAmt
        
        var dictAnalysics = [AnanlysicParameters.Category:AnalyticsEventsCategory.change_plan,
                             AnanlysicParameters.Action:AnalyticsEventsActions.change_plan_success,
                             AnanlysicParameters.EventType:AnanlysicParameters.ClickEvent]
        if let userActData = userResult?[0]
        {
            dictAnalysics["current_plan_charges"] = userActData.InvoiceAmount
            dictAnalysics["current_plan_data"] = userActData.planDataVolume
            dictAnalysics["current_plan_speed"] = userActData.Speed
            dictAnalysics["current_plan_frequency"] = userActData.BillFrequency
            
        }
        
        HelpingClass.sharedInstance.planSucessData = dictAnalysics
        self.navigationController?.pushViewController(vc!, animated: false)
        
    }
    @IBAction func confirmButtonClick(_ sender: Any) {
        if(backToHome){
            navigateScreen(identifier: ViewIdentifier.customTabIdentifier, controller: CustomTabViewController.self)
        }else{
            
            self.navigationController?.popViewController(animated: false)
        }
        
    }
    @IBAction func backBTN(_ sender: Any) {
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

}
