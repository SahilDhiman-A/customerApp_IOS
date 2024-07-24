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

class PlanViewController: UIViewController {


    var realm:Realm? = nil
    var userResult:Results<UserCurrentData>? = nil
    
    
    var dataResponse = NSDictionary()
    var checkStatus = String()
    var pckgID = String()
    var planDict = NSDictionary()
    var totalAmountArr = NSArray()
    var totalAmt = String()
    var finalAmount = Float()
    var canID = String()

    @IBOutlet weak var planView: UIView!
    @IBOutlet weak var lblPlanName: UILabel!
    @IBOutlet weak var lblChargesAmt: UILabel!
    @IBOutlet weak var lblTotalData: UILabel!
    @IBOutlet weak var lblSpeed: UILabel!
    @IBOutlet weak var lblFrequency: UILabel!
    @IBOutlet weak var changePlaneView: UIView!
    
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
    
    //MARK: Button Actions
    @IBAction func backBTN(_ sender: Any) {
        self.navigationController?.popViewController(animated: false)
    }
  
    @IBAction func changePlanBTN(_ sender: Any)
    {
        chnagePlanScreen(WithCanID: canID, pckgID: pckgID,typeOf: "")
    }
    
}
