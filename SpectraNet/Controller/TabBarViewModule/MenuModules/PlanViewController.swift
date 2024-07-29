//
//  PlanViewController.swift
//  SpectraNet
//
//  Created by Yugasalabs-28 on 24/07/2019.
//  Copyright © 2019 Bhoopendra. All rights reserved.
//

import UIKit
import ObjectMapper
import RealmSwift

class PlanViewController: UIViewController ,UITableViewDelegate,UITableViewDataSource{


    var realm:Realm? = nil
    var userResult:Results<UserCurrentData>? = nil
    var consumberTopUpArray:[AnyObject] = [AnyObject]()
    
    var dataResponse = NSDictionary()
    var checkStatus = String()
    var pckgID = String()
    var planDict = NSDictionary()
    var totalAmountArr = NSArray()
    var totalAmt = String()
    var finalAmount = Float()
    var canID = String()

    var topupAmount = String()
    var topupName = String()
    var topupType = String()
    var tdsAmountPerMonth = String()
    @IBOutlet weak var planView: UIView!
    @IBOutlet weak var lblPlanName: UILabel!
    @IBOutlet weak var lblChargesAmt: UILabel!
    @IBOutlet weak var lblTotalData: UILabel!
    @IBOutlet weak var lblSpeed: UILabel!
    @IBOutlet weak var lblFrequency: UILabel!
    @IBOutlet weak var changePlaneView: UIView!
    @IBOutlet weak var planTableView: UITableView!

    @IBOutlet weak var deactivateView: UIView!
    @IBOutlet weak var deactivateSucessView: UIView!
    @IBOutlet weak var topUpDescLabel: UILabel!
    //MARK: View controller life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        realm = try? Realm()
        
    }
    
    override func viewWillAppear(_ animated: Bool)
    {
        super.viewWillAppear(animated)
        setCornerRadiusView(radius: Float(changePlaneView.frame.height/2), color: UIColor.cornerBGFullOpack, view: changePlaneView)

        userResult = self.realm!.objects(UserCurrentData.self)
        if let userActData = userResult?[0]
        {
            pckgID = userActData.Product
            lblSpeed.text = userActData.Speed
            lblFrequency.text = userActData.BillFrequency
            lblTotalData.text = userActData.planDataVolume
            canID = userActData.CANId
        }
        if ConnectionCheck.isConnectedToNetwork() == true
        {
            ServiceTypeRatePlan()
            self.serviceTypeGetConsumebTopUpPlan()
        }
        else
        {
            noInternetCheckScreenWithMessage(errorMessage:"")
        }
              
        planView.isHidden = true
        finalAmount = 0
    }
   
    //MARK: Service RatePlan
    func ServiceTypeRatePlan()
    {
        let dict = ["Action":ActionKeys.getRatePlan, "Authkey":UserAuthKEY.authKEY, "canID":canID]
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
                    guard let planeDict = self.dataResponse.value(forKey: "response") as? NSDictionary else
                    {
                        return
                    }
                    self.planDict = planeDict
                    
                    self.pckgID  = ""
                    if let pcgID = self.planDict.value(forKey: "planId") as? String {
                         self.pckgID = pcgID
                    }
                
                    self.lblPlanName.text  = ""
                    if let planName = self.planDict.value(forKey: "planName") as? String {
                         self.lblPlanName.text = planName
                    }

                //self.totalAmountArr = self.planDict.value(forKey: "rcCharge") as! NSArray
                guard let responseAr = self.planDict.value(forKey: "rcCharge") as? NSArray else
                {
                    return
                }
                self.totalAmountArr = responseAr

                for i in 0 ..< self.totalAmountArr.count
                {
                    let myFloat: Float = (self.totalAmountArr[i] as AnyObject).value(forKey: "amount") as! Float
                    self.finalAmount = myFloat + self.finalAmount
                }
                self.lblChargesAmt.text = String(format: "%@ %.2f",SignINR.ruppes, self.finalAmount)
                
                self.planView.isHidden = false
            }
            else
            {
                guard let errorMsg = self.dataResponse.value(forKey: "message") as? String else
                {
                    return
                }
                self.noInternetCheckScreenWithMessage(errorMessage: errorMsg)
            }
          }
        }
    }
    
    func serviceTypeGetConsumebTopUpPlan()
    {
        
       // canID = "139525"
        
        let dict = ["Action":ActionKeys.consumedTopup, "Authkey":UserAuthKEY.authKEY, "canId":canID]
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
                    if let response =  self.dataResponse["response"] as? [AnyObject]{
                        
                        self.consumberTopUpArray = response
                        self.planTableView.reloadData()
                            
                        
                    }
                    
                   
                }
               
            }
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        
        
        let count = self.consumberTopUpArray.count
        
        return count ?? 0
    }
       
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        var cell : TopupTableViewCell? = (tableView.dequeueReusableCell(withIdentifier: TableViewCellName.TopupTableViewCellPlan) as! TopupTableViewCell)
        if cell == nil
        {
            cell = TopupTableViewCell(style: UITableViewCell.CellStyle.default, reuseIdentifier: TableViewCellName.TopupTableViewCellPlan)
        }
        //setCornerRadiusView(radius: Float((cell?.roundPayBtnView.frame.height)!/2), color: UIColor.cornerBGFullOpack, view: cell!.roundPayBtnView)
        
            
            if let changePlanData = self.consumberTopUpArray[indexPath.row] as? AnyObject{
                
                cell?.lblTopupName.text = changePlanData["description"] as? String
                
                let prince = changePlanData["price"] as? String
                cell?.lblTopupPrice.text = "₹ " +  (prince ?? " ") + " + 18% Taxes"
                cell?.lblTopupVolume.text = changePlanData["data_volume"] as? String
                cell?.roundPayBtnView.tag = 200
                if let type = changePlanData["type"] as? String{
                    
                    if(type == "RC"){
                        
                        cell?.lblTopupTitle.text = "Current Auto Top-Up"
                    }else{
                        
                        cell?.lblTopupTitle.text = "Current Flexi Top-Up"
                    }
                    
                    
                }
               
                cell?.topupPayBTN.addTarget(self, action: #selector(deactivateAction), for: .touchUpInside)
                if let deactivateFlag = changePlanData["deactivateFlag"] as? String{
                    if deactivateFlag == "true"{
                        cell?.buyButtonWidth.constant = 180
                        cell?.buyButtonHeight.constant = 40
                        cell?.buyLabel.text =  "Deactivate".uppercased()
                        
                        cell?.roundPayBtnView.isHidden = false
                    }else{
                        cell?.buyButtonWidth.constant = 0
                        cell?.buyButtonHeight.constant = 0
                        cell?.roundPayBtnView.isHidden = true
                    }
                    
                }
                
           
            
        }
        
        return cell!
    }
    
    @objc func deactivateAction(sender: UIButton!)
    {
        
        let buttonPosition = sender.convert(CGPoint.zero, to: planTableView)
        let indexPath = planTableView.indexPathForRow(at:buttonPosition)
        
        if let changePlanData = self.consumberTopUpArray[indexPath?.row ?? 0] as? AnyObject{
            topupAmount = changePlanData["pgPrice"] as? String ?? ""
            //topupAmount = "1"
            topupName = changePlanData["topup_name"] as? String  ?? ""
            topupType = changePlanData["type"] as? String  ?? ""
            tdsAmountPerMonth = changePlanData["price"] as? String  ?? ""
        }
        deactivateView.isHidden = false
        
    }
    @IBAction func deactivateCancelAction(_ sender: Any) {
        
        deactivateView.isHidden = true
        
    }
    @IBAction func deactivateOhkAction(_ sender: Any) {
        deactivateView.isHidden = true
       
        
        serviceTypeDeactivateTopup()
        
    }
    
    func serviceTypeDeactivateTopup()
    {
        let dict = ["Action":ActionKeys.deactivateTopup, "Authkey":UserAuthKEY.authKEY, "canId":canID, "topupId":topupName, "topupType":topupType]
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
                self.deactivateSucessView.isHidden = false
                self.serviceTypeGetConsumebTopUpPlan()
            }
            else
            {
                if let errorMsg = self.dataResponse.value(forKey: "message") as? String
                {
                   // self.showAndHideDialogView(bool: false, message: errorMsg)
                }
            }
          }
       }
    }
    @IBAction func deactivateCrossAction(_ sender: Any) {
        deactivateSucessView.isHidden = true
        
    }
    //MARK: Button Actions
    @IBAction func backBTN(_ sender: Any) {
        self.navigationController?.popViewController(animated: false)
    }
  
    @IBAction func changePlanBTN(_ sender: Any)
    {
        chnagePlanScreen(WithCanID: canID, pckgID: pckgID,typeOf: "")
    }
    
    
}
