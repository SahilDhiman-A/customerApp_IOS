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
    var pckgID = String()
    var typeOfUpgrade = String()
    var paybleAmount = String()

    var planArray = NSArray()
    var canID = String()
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
   
    //MARK: View controller life cycle
    override func viewDidLoad()
    {
        super.viewDidLoad()
        realm = try? Realm()
        ServiceTypeOfferPlanList()
        noDataView.isHidden = true
        roundCornerViews()
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

    //MARK: Button Actions
    @objc func selctPackageBTN(sender: UIButton!)
    {
        let buttonPosition = sender.convert(CGPoint.zero, to: taleView)
        let indexPath = taleView.indexPathForRow(at:buttonPosition)
        
        if let changePlanData = userChangePlan?[indexPath!.row]
        {
             pckgID = changePlanData.planid
             paybleAmount = changePlanData.charges
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
        serviceTypeChangePlan()
    }
    
    @IBAction func backToHomeBTN(_ sender: Any)
    {
        navigateScreen(identifier: ViewIdentifier.customTabIdentifier, controller: CustomTabViewController.self)
    }
    
    // hide failed view and success view
    @IBAction func backToOffer(_ sender: Any) {
        transPrntView.isHidden = true
        planCnfrmView.isHidden = true
        planSuccefullySubmittedView.isHidden = true
        offerfailedView.isHidden = true
    }
    
    //MARK: Service Offer plan list
    func ServiceTypeOfferPlanList()
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
                    self.taleView.isHidden = true
                    self.noDataView.isHidden = false
                    self.lblErrorMsg.text = self.dataResponse.value(forKey: "message") as? String
                }
            }
        }
    }
    //MARK: Service Change plan
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
}
