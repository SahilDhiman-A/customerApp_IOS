//
//  ComparePlanViewController.swift
//  My Spectra
//
//  Created by Chakshu on 22/10/20.
//  Copyright © 2020 Bhoopendra. All rights reserved.
//

import UIKit
import ObjectMapper
import RealmSwift


class ComparePlanViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    var realm:Realm? = nil
    var userResult:Results<UserCurrentData>? = nil
    var userChangePlan:Results<ChangePlanData>? = nil
    var dataResponse = NSDictionary()
    var checkStatus = String()
    var planArray = NSArray()
    var canID = String()
    var compareArray:[String] = [String]()
    var pckgID = String()
    @IBOutlet weak var viewBottonConstraint: NSLayoutConstraint!
    @IBOutlet weak var comparePlanTableView: UITableView!
    @IBOutlet weak var proceedButton: UIButton!
    @IBOutlet weak var transPrntView: UIView!
    var selectedPlan : ChangePlanData? = nil
    var knowMoreObject:KnowMore?
    override func viewDidLoad() {
        super.viewDidLoad()
        
        methodToGetPlans()
        // Do any additional setup after loading the view.
        comparePlanFirbaseAnalysics()
    }
    func comparePlanFirbaseAnalysics(){
            
                let dictAnalysics = [AnanlysicParameters.canID:canID,
                                     AnanlysicParameters.Category:AnalyticsEventsCategory.all_Menu
                                     ,AnanlysicParameters.Action:AnalyticsEventsActions.comparePlanClicked
                                     ,AnanlysicParameters.EventType:AnanlysicParameters.ClickEvent]
                
                //,AnanlysicParameters.EventDescription:AnanlysicEventDescprion.loginwithUserNamePassword
            
               HelpingClass.sharedInstance.addFirebaseAnalysis(eventName: AnalyticsEventsName.compare_Plan, parameters: dictAnalysics as? [String:AnyObject] ?? [String:AnyObject]() )
        }
    
    func methodToGetPlans()  {
        realm = try? Realm()
        self.userChangePlan = self.realm!.objects(ChangePlanData.self)
        userResult = self.realm!.objects(UserCurrentData.self)
        if let userActData = userResult?[0]
        {
            compareArray.append(userActData.Product)
        }
        //
        comparePlanTableView.reloadData()
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return userChangePlan?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        var cell : ChangePlanTableViewCell? = (tableView.dequeueReusableCell(withIdentifier: TableViewCellName.comparePlanTableViewCell) as! ChangePlanTableViewCell)
        
        if cell == nil {
            cell = ChangePlanTableViewCell(style: UITableViewCell.CellStyle.default, reuseIdentifier: TableViewCellName.comparePlanTableViewCell)
        }
        //cell?.selctpackageBTN.addTarget(self, action: #selector(selctPackageBTN), for: .touchUpInside)
        setCornerRadiusView(radius: Float((cell?.roundBtnView.frame.height)!/2), color: UIColor.cornerBGFullOpack, view: cell!.roundBtnView)
        
        if let changePlanData = userChangePlan?[indexPath.row]
        {
            
            if(compareArray.contains(changePlanData.planid)){
                cell?.checkBoxButton.setImage(UIImage(named: "status1"), for: .normal)
            }else{
                cell?.checkBoxButton.setImage(UIImage(named: "CheckboxEmpty"), for: .normal)
                
            }
            cell?.lblplanName.text = changePlanData._description
            
           // cell?.lblplanName.text = "Know more / Plan detail screen will have a button “Select Plan” to select a plan."
            if changePlanData.data == ""
            {
                cell?.lblPlanCharge.text = " "
            }
            else
            {
                cell?.lblPlanCharge.text = convertStringtoFloatViceversa(amount: changePlanData.charges)
            }
            cell?.lblSped.text = changePlanData.speed
            cell?.lblFrequency.text = changePlanData.frequency
            if changePlanData.frequency == ""
            {
                cell?.lblFrequency.text = " "
            }
            cell?.availData.text = changePlanData.data
            if changePlanData.data == ""
            {
                cell?.availData.text = " "
            }
        }
        return cell!
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return UITableView.automaticDimension
    }
    
    @IBAction func backBTN(_ sender: Any)
    {
        self.navigationController?.popViewController(animated: false)
    }
    @IBAction func compairButtonClick(sender: UIButton)
    {
        let buttonPosition = sender.convert(CGPoint.zero, to: comparePlanTableView)
        let indexPath = comparePlanTableView.indexPathForRow(at:buttonPosition)
        
        if let changePlanData = userChangePlan?[indexPath!.row]
        {
            if(compareArray.contains(changePlanData.planid)){
                
                if let index = compareArray.firstIndex(of: changePlanData.planid) {
                    compareArray.remove(at: index)
                }
                
            }else{
                
                if(compareArray.count > 4){
                    self.showSimpleAlert(TitaleName: "", withMessage: "Maximum limit reached.")
                    
                    return
                    
                }
                compareArray.append(changePlanData.planid)
                
            }
             
            
        }
        
        comparePlanTableView.reloadData()
        
        if(compareArray.count > 1){
            
            viewBottonConstraint.constant = 50
            proceedButton.isHidden = false
        }else{
            viewBottonConstraint.constant = 0
            proceedButton.isHidden = true
            
        }
    }
    
    @IBAction func changePlanBTN(_ sender: Any)
    {
        serviceTypeProDataChargesForPlan()
    }
    
    @IBAction func selctPackageBTN(sender: UIButton!)
    {
        let buttonPosition = sender.convert(CGPoint.zero, to: comparePlanTableView)
        let indexPath = comparePlanTableView.indexPathForRow(at:buttonPosition)
        
        if let changePlanData = userChangePlan?[indexPath!.row]
        {
            selectedPlan = changePlanData
             pckgID = changePlanData.planid
            
        }
        transPrntView.isHidden = false
        
        changePlanFirbaseAnalysics()
    }
    
    func changePlanFirbaseAnalysics(){
        
        var dictAnalysics = [AnanlysicParameters.canID:canID,
                             AnanlysicParameters.Category:AnalyticsEventsCategory.change_plan,
                             AnanlysicParameters.Action:AnalyticsEventsActions.change_plan_click,
                             AnanlysicParameters.EventType:AnanlysicParameters.ClickEvent]
        

        HelpingClass.sharedInstance.addFirebaseAnalysis(eventName: AnalyticsEventsName.change_plan_click, parameters: dictAnalysics as? [String:AnyObject] ?? [String:AnyObject]() )
        
    }
    
    func changePlanCancelFirbaseAnalysics(){
        
        let dictAnalysics = [AnanlysicParameters.canID:canID,
                             AnanlysicParameters.Category:AnalyticsEventsCategory.change_plan,
                             AnanlysicParameters.Action:AnalyticsEventsActions.change_plan_canceled,
                             AnanlysicParameters.EventType:AnanlysicParameters.ClickEvent]

        HelpingClass.sharedInstance.addFirebaseAnalysis(eventName: AnalyticsEventsName.change_plan_canceled, parameters: dictAnalysics as? [String:AnyObject] ?? [String:AnyObject]() )
        
    }
    
   
    @IBAction func cancelPlanBtn(_ sender: Any)
    {
        transPrntView.isHidden = true
        changePlanCancelFirbaseAnalysics()
       
    }
    func serviceTypeProDataChargesForPlan()
    {
        
        let dict = ["Action":ActionKeys.proDataChargesForPlan, "Authkey":UserAuthKEY.authKEY, "canId":canID, "planId":pckgID]
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
                    if let response =  self.dataResponse["response"] as? [String:AnyObject]{
                        
                       
                        self.transPrntView.isHidden = true
                        let vc = UIStoryboard.init(name: "Storyboard", bundle: Bundle.main).instantiateViewController(withIdentifier: ViewIdentifier.ChangePlanCompareViewController) as? ChangePlanCompareViewController
                        vc?.differenceResponce = response
                        vc?.canID = self.canID
                        vc?.pckgID = self.pckgID
                        vc?.data =  self.selectedPlan?.data ?? ""
                        vc?.spead =  self.selectedPlan?.speed ?? ""
                        vc?.frequency = self.selectedPlan?.frequency ?? ""
                        self.navigationController?.pushViewController(vc!, animated: false)
                    
                    
                }
                else
                {
                    
                }
                
                }
                else
                {
                    let string = self.dataResponse.value(forKey: "message") as? String
                    self.showSimpleAlert(TitaleName: "", withMessage: string ?? "")
                    
                    
                }
            }
        }
        
    }
    
    
   
    func paymentForChangePlan(outStandingAmt:String,tdsAmount:String){
        let vc = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: ViewIdentifier.PayNowIdentifier) as? PayNowViewController
        vc?.outStandingAmt = tdsAmount
        vc?.tdsAmount = ""
        vc?.tdsPercent = ""
        vc?.canID = canID
//       vc?.topupName = topupName
//       vc?.topupType = topupType
        vc?.pckgID = pckgID
        vc?.screenFrom = FromScreen.changeTopUPScreen
        vc?.tdsAmountPerMonth = outStandingAmt
        self.navigationController?.pushViewController(vc!, animated: false)
        
    }
    
    //MARK: Service Change plan
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
                   // self.changePlanSuccessFirbaseAnalysics()
                    self.transPrntView.isHidden = false

                }
                else
                {
                    
                    //self.changePlanFailureFirbaseAnalysics()
                    self.transPrntView.isHidden = false

                }
            }
        }
    }
    
    
    
    @IBAction func knowMoreButtonClick(sender: UIButton!) {
        
        
        //ComparePlanViewController
        let buttonPosition = sender.convert(CGPoint.zero, to: comparePlanTableView)
        let indexPath = comparePlanTableView.indexPathForRow(at:buttonPosition)
        
        if let changePlanData = userChangePlan?[indexPath!.row]
        {
             
            
            self.knowMoreViewAdd(planId: changePlanData.planid)
        }
        
            
        
    }
    
    

    func knowMoreViewAdd(planId:String) {
        let vc = UIStoryboard.init(name: "Storyboard", bundle: Bundle.main).instantiateViewController(withIdentifier: ViewIdentifier.KnowMoreIdentifier) as? KnowMoreViewController
        vc?.canID = canID
        vc?.planId = planId
        //vc?.knowMoreObject = knowMoreObject
        self.present(vc ?? UIViewController(), animated: false, completion: nil)
    }
    func showSimpleAlert(TitaleName: String, withMessage: String)
    {
        let alert = UIAlertController(title: TitaleName, message: withMessage,preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: AlertViewButtonTitle.title_OK,style: UIAlertAction.Style.default,handler: {(_: UIAlertAction!) in
            
       
        }))
        self.present(alert, animated: true, completion: nil)
    }
    @IBAction func proceedButtonClick(sender: UIButton!) {
        
        let vc = UIStoryboard.init(name: "Storyboard", bundle: Bundle.main).instantiateViewController(withIdentifier: ViewIdentifier.CompareViewController) as? CompareViewController
        vc?.canID = canID
        vc?.compareArray=compareArray
        self.navigationController?.pushViewController(vc ?? UIViewController(), animated: true)
    }
    
    
}
