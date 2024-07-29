//
//  ChangePlanViewController.swift
//  SpectraNet
//
//  Created by Bhoopendra on 9/16/19.
//  Copyright © 2019 Bhoopendra. All rights reserved.
//

import UIKit
import ObjectMapper
import RealmSwift

class ChangePlanViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {

    var realm:Realm? = nil
    var userResult:Results<UserCurrentData>? = nil
    var userChangePlan:Results<ChangePlanData>? = nil

    var dataResponse = NSDictionary()
    var checkStatus = String()
    
    var typeOfUpgrade = String()
    var paybleAmount = String()

    var planArray = NSArray()
    var canID = String()
    var pckgID = String()
    @IBOutlet weak var lblErrorMsg: UILabel!
    @IBOutlet weak var roundBackView: UIView!
    @IBOutlet weak var transPrntView: UIView!
    @IBOutlet weak var planSuccefullySubmittedView: UIView!
    @IBOutlet weak var planCnfrmView: UIView!
    @IBOutlet weak var noDataView: UIView!
    @IBOutlet weak var taleView: UITableView!
    @IBOutlet weak var changRoundView: UIView!
    @IBOutlet weak var cancelRoundView: UIView!
    @IBOutlet weak var backHomeRoundView: UIView!
    @IBOutlet weak var lblPlanChaneMsg: UILabel!
    
    @IBOutlet var backHomeBTNTitle: UILabel!
    
    @IBOutlet var backRoundBTNView: UIView!
    @IBOutlet var offerfailedView: UIView!
    @IBOutlet var lblfailedMeg: UILabel!
    @IBOutlet var comparePlanButton: UIButton!
    
    var selectedPlan : ChangePlanData? = nil
   
    
    var knowMoreObject:KnowMore?
//    var knowMoreData = []
   
    //MARK: View controller life cycle
    override func viewDidLoad()
    {
        super.viewDidLoad()
        realm = try? Realm()
        userResult = self.realm!.objects(UserCurrentData.self)
        if AppDelegate.sharedInstance.segmentType == segment.userB2C{
            serviceTypeOfferPlanList()
        }
        else{
            if let userActData = userResult?[0]
            {
                
                self.pckgID = userActData.Product
                self.comparePlanButton.isHidden = true
            serviceTypeChangePlan()
            }
        }
        noDataView.isHidden = true
        roundCornerViews()
       // self.serviceTypeGetConsumebTopUpPlan()
     }
    
    //MARK:Corner round View
    func roundCornerViews() {
        setCornerRadiusView(radius: Float(roundBackView.frame.height/2), color: UIColor.cornerBGFullOpack, view: roundBackView)
        setCornerRadiusView(radius: Float(changRoundView.frame.height/2), color: UIColor.cornerBGFullOpack, view: changRoundView)
        setCornerRadiusView(radius: Float(cancelRoundView.frame.height/2), color: UIColor.cornerBGFullOpack, view: cancelRoundView)
        setCornerRadiusView(radius: Float(backHomeRoundView.frame.height/2), color: UIColor.cornerBGFullOpack, view: backHomeRoundView)
        setCornerRadiusView(radius: Float(backRoundBTNView.frame.height/2), color: UIColor.cornerBGFullOpack, view: backRoundBTNView)
        transPrntView.isHidden = true
        planCnfrmView.isHidden = true
        planSuccefullySubmittedView.isHidden = true
        offerfailedView.isHidden = true
    }
    
    //MARK: Table View delegate
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
      
            return userChangePlan?.count ?? 0
            
        
        
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        
        
        var cell : ChangePlanTableViewCell? = (tableView.dequeueReusableCell(withIdentifier: TableViewCellName.changePlanTableViewCell) as! ChangePlanTableViewCell)
        
        if cell == nil {
            cell = ChangePlanTableViewCell(style: UITableViewCell.CellStyle.default, reuseIdentifier: TableViewCellName.changePlanTableViewCell)
        }
        cell?.selctpackageBTN.addTarget(self, action: #selector(selctPackageBTN), for: .touchUpInside)
        setCornerRadiusView(radius: Float((cell?.roundBtnView.frame.height)!/2), color: UIColor.cornerBGFullOpack, view: cell!.roundBtnView)
        
        if let changePlanData = userChangePlan?[indexPath.row]
        {
            cell?.lblplanName.text = changePlanData._description
            
           // cell?.lblplanName.text = "Know more / Plan detail screen will have a button “Select Plan” to select a plan."
            if changePlanData.data == ""
            {
                cell?.lblPlanCharge.text = " "
            }
            else
            {
                cell?.lblPlanCharge.text = "₹ " + convertStringtoFloatViceversa(amount: changePlanData.charges)
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

    //MARK: Button Actions
    @objc func selctPackageBTN(sender: UIButton!)
    {
        let buttonPosition = sender.convert(CGPoint.zero, to: taleView)
        let indexPath = taleView.indexPathForRow(at:buttonPosition)
        
        if let changePlanData = userChangePlan?[indexPath!.row]
        {
             pckgID = changePlanData.planid
             paybleAmount = changePlanData.charges
            selectedPlan = changePlanData
        }
        transPrntView.isHidden = false
        planCnfrmView.isHidden = false
        planSuccefullySubmittedView.isHidden = true
    }
    
    @IBAction func backBTN(_ sender: Any) {
        self.navigationController?.popViewController(animated: false)
    }
    
    @IBAction func backViewBTN(_ sender: Any) {
        self.navigationController?.popViewController(animated: false)
    }
    
    @IBAction func cancelPlanBtn(_ sender: Any)
    {
        transPrntView.isHidden = true
        planCnfrmView.isHidden = true
        planSuccefullySubmittedView.isHidden = true
    }
    
    @IBAction func changePlanBTN(_ sender: Any)
    {
        serviceTypeProDataChargesForPlan()
        changePlanFirbaseAnalysics()
    }
    
    func changePlanFirbaseAnalysics(){
        
        let dictAnalysics = [AnanlysicParameters.canID:canID,
                             AnanlysicParameters.Category:AnalyticsEventsCategory.change_plan,
                             AnanlysicParameters.Action:AnalyticsEventsActions.change_plan_click,
                             AnanlysicParameters.EventType:AnanlysicParameters.ClickEvent]

        HelpingClass.sharedInstance.addFirebaseAnalysis(eventName: AnalyticsEventsName.change_plan_click, parameters: dictAnalysics as? [String:AnyObject] ?? [String:AnyObject]() )
        
    }
    
    @IBAction func backToHomeBTN(_ sender: Any)
    {
        navigateScreen(identifier: ViewIdentifier.customTabIdentifier, controller: CustomTabViewController.self)
    }
    
    // hide failed view and success view
    @IBAction func backToOffer(_ sender: Any) {
        
        if AppDelegate.sharedInstance.segmentType == segment.userB2C{
        transPrntView.isHidden = true
        planCnfrmView.isHidden = true
        planSuccefullySubmittedView.isHidden = true
        offerfailedView.isHidden = true
        }else{
            
            self.navigationController?.popViewController(animated: false)
        }
    }
    
    func serviceTypeGetConsumebTopUpPlan()
    {
        
       // canID = "139525"
        
        let dict = ["Action":ActionKeys.consumedTopup, "Authkey":UserAuthKEY.authKEY, "canId":canID]
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
                    guard let responseAr = self.dataResponse.value(forKey: "response") as? NSArray else
                    {
                        return
                    }
                    
                   
                }
               
            }
        }
    }
    //MARK: Service Offer plan list
    func serviceTypeOfferPlanList()
    {
        let dict = ["Action":ActionKeys.getOffer, "Authkey":UserAuthKEY.authKEY, "canID":canID, "basePlan":pckgID]
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
                    // self.planArray = self.dataResponse.value(forKey: "response") as! NSArray
                    guard let responseAr = self.dataResponse.value(forKey: "response") as? NSArray else
                    {
                        return
                    }
                    self.planArray = responseAr

                    try! self.realm!.write
                    {
                        if let users = self.realm?.objects(ChangePlanData.self) {
                            self.realm!.delete(users)
                        }
                    }

                    for entry in self.planArray {
                           if let currentUser = Mapper<ChangePlanData>().map(JSONObject: entry) {
                               try! self.realm!.write {
                                self.realm!.add(currentUser)
                            }
                        }
                    }
//                    DatabaseHandler.instance().getAndSaveChangePlan(dict:responseAr)
                    
                    self.userChangePlan = self.realm!.objects(ChangePlanData.self)
                    self.taleView.delegate = self
                    self.taleView.dataSource = self
                    self.taleView.reloadData()
                    self.noDataView.isHidden = true
                }
                else
                {
                    self.comparePlanButton.isHidden = true
                    self.taleView.isHidden = true
                    self.noDataView.isHidden = false
                    self.lblErrorMsg.text = self.dataResponse.value(forKey: "message") as? String
                }
            }
        }
    }
    //MARK: Service Pro Data Charges For Plan
    
    func serviceTypeProDataChargesForPlan()
    {
        //self.canID = "211292"
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
                        self.planCnfrmView.isHidden = true
                        let vc = UIStoryboard.init(name: "Storyboard", bundle: Bundle.main).instantiateViewController(withIdentifier: ViewIdentifier.ChangePlanCompareViewController) as? ChangePlanCompareViewController
                        vc?.differenceResponce = response
                        vc?.canID = self.canID
                        vc?.pckgID = self.pckgID
                        vc?.data =  self.selectedPlan?.data ?? ""
                        vc?.spead =  self.selectedPlan?.speed ?? ""
                        vc?.frequency = self.selectedPlan?.frequency ?? ""
                        self.navigationController?.pushViewController(vc!, animated: false)
                        
                       
                        
                        
                        
//                        if let proDataCharges = response["proDataCharges"] as? Double, let pgDataCharges = response["pgDataCharges"] as? Double{
//
//                            if proDataCharges > 0{
//                                self.paymentForChangePlan(outStandingAmt: "\(proDataCharges)", tdsAmount: "\(pgDataCharges)")
//                            }else{
//                                self.serviceTypeChangePlan()
//
//                            }
//                        }
                    }
                    
                }
                else
                {
                    self.transPrntView.isHidden = false
                    self.planCnfrmView.isHidden = true
                    self.planSuccefullySubmittedView.isHidden = true
                    self.offerfailedView.isHidden = false
                    self.lblfailedMeg.text = self.dataResponse.value(forKey: "message") as? String
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
        vc?.pckgID = pckgID
//       vc?.topupType = topupType
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
                    self.transPrntView.isHidden = false
                    self.planCnfrmView.isHidden = true
                    self.planSuccefullySubmittedView.isHidden = false
                    self.lblPlanChaneMsg.text = self.dataResponse.value(forKey: "message") as? String
                }
                else
                {
                    self.transPrntView.isHidden = false
                    self.planCnfrmView.isHidden = true
                    self.planSuccefullySubmittedView.isHidden = true
                    self.offerfailedView.isHidden = false
                    self.lblfailedMeg.text = self.dataResponse.value(forKey: "message") as? String
                }
            }
        }
    }
    
   
    
    @IBAction func knowMoreButtonClick(sender: UIButton!) {
        
        
        //ComparePlanViewController
        let buttonPosition = sender.convert(CGPoint.zero, to: taleView)
        let indexPath = taleView.indexPathForRow(at:buttonPosition)
        
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
    
    @IBAction func comparePlanButtonClick(_ sender: Any)
    {
        let vc = UIStoryboard.init(name: "Storyboard", bundle: Bundle.main).instantiateViewController(withIdentifier: ViewIdentifier.ComparePlanViewController) as? ComparePlanViewController
        vc?.canID = canID
        vc?.userResult=userResult
        vc?.userChangePlan=userChangePlan

        vc?.planArray = planArray
       
        self.navigationController?.pushViewController(vc ?? UIViewController(), animated: true)
        
    }
    
}
