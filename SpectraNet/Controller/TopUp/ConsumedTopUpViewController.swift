//
//  ConsumedTopUpViewController.swift
//  My Spectra
//
//  Created by Chakshu on 28/01/20.
//  Copyright © 2020 Bhoopendra. All rights reserved.
//

import UIKit
import ObjectMapper
import RealmSwift

class ConsumedTopUpViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    var basePlan = String()
    var canID = String()
    @IBOutlet weak var topUpableView: UITableView!
    @IBOutlet weak var errorLabel: UILabel!
    var realm:Realm? = nil
    var userResult:[TopupPlanData] = [TopupPlanData]()
    var dataResponse = NSDictionary()
    var checkStatus = String()
    var topUpArray = NSArray()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.serviceTypeTopUpPlan()
        self.errorLabel.isHidden = true

        // Do any additional setup after loading the view.
    }
    
    @IBAction func backBTN(_ sender: Any)
    {
        self.navigationController?.popViewController(animated: false)
    }
    
    
    func serviceTypeTopUpPlan()
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
                    self.topUpArray = responseAr

                  
                    
                    if(self.topUpArray.count>0){
                        
                        for entry in self.topUpArray {
                            if let currentUser = Mapper<TopupPlanData>().map(JSONObject: entry) {
                                
                                
                                
                                self.userResult.append(currentUser)
                            }
                        }
                        
                        print_debug(object:  self.userResult)
                        //    DatabaseHandler.instance().getAndSaveListOfTopupPlan(dict: responseAr)
                        //                    self.userResult = self.realm!.objects(TopupPlanData.self).filter("type == 'NRC'")
                        
                        
                    }else{
                      
                        self.topUpableView.isHidden = true
                        guard let statusMessage = self.dataResponse.value(forKey: "message") as? String else
                        {
                            return
                        }
                        self.errorLabel.text = statusMessage
                        //self.showAlertC(message: statusMessage)
                    }
                    self.topUpableView.delegate = self
                    self.topUpableView.dataSource = self
                    self.topUpableView.reloadData()
                   
                }
                else
                {
                    self.topUpableView.isHidden = true
                    guard let statusMessage = self.dataResponse.value(forKey: "message") as? String else
                    {
                        return
                    }
                    self.errorLabel.text = statusMessage
                    self.showAlertC(message: statusMessage)
                }
            }
        }
    }
    
    @IBAction func buyTopUpClick(_ sender: Any) {
        
        
        topupScreen(WithCanID: canID, pckgID: basePlan)
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        
        if userResult.count>0
        {
            self.errorLabel.isHidden = true
            topUpableView.isHidden = false
        }else{
            self.errorLabel.isHidden = false
            topUpableView.isHidden = true
            
        }
        return userResult.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        var cell : ConsumedTableViewCell? = (tableView.dequeueReusableCell(withIdentifier: TableViewCellName.TopupCellIdentifier) as! ConsumedTableViewCell)
        if cell == nil
        {
            cell = ConsumedTableViewCell(style: UITableViewCell.CellStyle.default, reuseIdentifier: TableViewCellName.TopupCellIdentifier)
        }
      
//        setCornerRadiusView(radius: Float((cell?.roundInvoiceBtnView.frame.height)!/2), color: UIColor.cornerBGFullOpack, view: cell!.roundInvoiceBtnView)
//        setCornerRadiusView(radius: Float((cell?.roundPayBtnView.frame.height)!/2), color: UIColor.cornerBGFullOpack, view: cell!.roundPayBtnView)
        
        if let changePlanData = userResult[indexPath.row] as? TopupPlanData
        {
            cell?.lblTopupName.text = changePlanData.descriptionTopUp
            cell?.lblTopupPrice.text =  "₹ " + changePlanData.price
            cell?.lblTopupVolume.text = changePlanData.volume
            cell?.lblTopupType.text = changePlanData.type

            // cell?.lblToupExcludingTaxes.text = changePlanData.pgPrice
            
        }
        return cell!
    }

}
