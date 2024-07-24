//
//  TopupPlanViewController.swift
//  My Spectra
//
//  Created by Bhoopendra on 9/27/19.
//  Copyright © 2019 Bhoopendra. All rights reserved.
//

import UIKit
import ObjectMapper
import RealmSwift

class TopupPlanViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {

    var realm:Realm? = nil
    var userResult:Results<TopupPlanData>? = nil
    
    var basePlan = String()
    var canID = String()
    var topupAmount = String()
    var topupName = String()
    var topupType = String()

    var dataResponse = NSDictionary()
    var checkStatus = String()
    var topUpArray = NSArray()
    @IBOutlet weak var topUpableView: UITableView!
    @IBOutlet weak var tranprntView: UIView!
    @IBOutlet weak var dialogeView: UIView!
    @IBOutlet weak var lblDialogeStatusMsg: UILabel!
    @IBOutlet weak var ButtonRoundView: UIView!
    
    //MARK: View controller life cycle
    override func viewDidLoad()
    {
        super.viewDidLoad()
        realm = try? Realm()
        showAndHideDialogView(bool: true,message:"")
        serviceTypeTopUpPlan()
    }
    
   //MARK: TableView delegate
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return userResult?.count ?? 0
    }
       
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        var cell : TopupTableViewCell? = (tableView.dequeueReusableCell(withIdentifier: TableViewCellName.TopupTableViewCell) as! TopupTableViewCell)
        if cell == nil
        {
            cell = TopupTableViewCell(style: UITableViewCell.CellStyle.default, reuseIdentifier: TableViewCellName.TopupTableViewCell)
        }
        cell?.topupPayBTN.addTarget(self, action: #selector(topupPayButton), for: .touchUpInside)
        cell?.topupInvoiceBTN.addTarget(self, action: #selector(topupInvoiceButton), for: .touchUpInside)
        setCornerRadiusView(radius: Float((cell?.roundInvoiceBtnView.frame.height)!/2), color: UIColor.cornerBGFullOpack, view: cell!.roundInvoiceBtnView)
        setCornerRadiusView(radius: Float((cell?.roundPayBtnView.frame.height)!/2), color: UIColor.cornerBGFullOpack, view: cell!.roundPayBtnView)

        if let changePlanData = userResult?[indexPath.row]
        {
            cell?.lblTopupName.text = changePlanData.name
            cell?.lblTopupPrice.text = changePlanData.price
            cell?.lblTopupTax.text = changePlanData.tax
            cell?.lblToupTotalCharge.text = changePlanData.total
            cell?.lblTopupData.text = changePlanData.data
        }
        return cell!
    }
    
    //MARK: Button Actions
    @objc func topupPayButton(sender: UIButton!)
    {
        let buttonPosition = sender.convert(CGPoint.zero, to: topUpableView)
        let indexPath = topUpableView.indexPathForRow(at:buttonPosition)
        if let changePlanData = userResult?[indexPath!.row]
        {
            topupAmount = changePlanData.total
        }
        goPayNowScreen(canID: canID, outstandingAmt: topupAmount, tdsAmt: "", tdsPrcnt: "",ifFromTopup: FromScreen.topUpScreen)
    }
    
    @objc func topupInvoiceButton(sender: UIButton!)
    {
        let buttonPosition = sender.convert(CGPoint.zero, to: topUpableView)
        let indexPath = topUpableView.indexPathForRow(at:buttonPosition)
        if let changePlanData = userResult?[indexPath!.row]
        {
            topupAmount = changePlanData.total
            topupName = changePlanData.name
            topupType = changePlanData.type
        }
        serviceTypeAddTopUp()
    }
    
    @IBAction func backBTN(_ sender: Any)
    {
        self.navigationController?.popViewController(animated: false)
    }
    
    @IBAction func okDialogeBUtton(_ sender: Any)
    {
        self.showAndHideDialogView(bool: true,message:"")
    }
      
    //MARK:  ServiceTypeTopUpPlan
    func serviceTypeTopUpPlan()
     {
      //  canID = "162538"
      //  basePlan = "HBB_250_1000_HY"
        
        let dict = ["Action":ActionKeys.getTopupPlan, "Authkey":UserAuthKEY.authKEY,"basePlan":basePlan, "canId":canID]
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

              try! self.realm!.write
              {
               if let users = self.realm?.objects(TopupPlanData.self) {
               self.realm!.delete(users)
               }
               }

              for entry in self.topUpArray {
              if let currentUser = Mapper<TopupPlanData>().map(JSONObject: entry) {
              try! self.realm!.write {
                self.realm!.add(currentUser)
               }
             }
               }
           //    DatabaseHandler.instance().getAndSaveListOfTopupPlan(dict: responseAr)
              self.userResult = self.realm!.objects(TopupPlanData.self)
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
              self.showAlertC(message: statusMessage)
          }
       }
     }
   }
    
    //MARK:  ServiceTypeAddTopUp
    func serviceTypeAddTopUp()
    {
        let dict = ["Action":ActionKeys.addTopUp, "Authkey":UserAuthKEY.authKEY,"amount":topupAmount, "canID":canID, "topupName":topupName, "topupType":topupType]
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
                    self.showAndHideDialogView(bool: false, message: successMsg)
                }
            }
            else
            {
                if let errorMsg = self.dataResponse.value(forKey: "message") as? String
                {
                    self.showAndHideDialogView(bool: false, message: errorMsg)
                }
            }
          }
       }
    }
    
    func showAndHideDialogView(bool:Bool,message:String)
    {
        tranprntView.isHidden = bool
        dialogeView.isHidden = bool
        lblDialogeStatusMsg.text = message
        setCornerRadiusView(radius: Float(ButtonRoundView.frame.height/2), color: UIColor.cornerBGFullOpack, view: ButtonRoundView)
    }
}
