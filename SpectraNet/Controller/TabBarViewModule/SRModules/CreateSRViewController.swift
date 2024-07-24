//
//  CreateSRViewController.swift
//  SpectraNet
//
//  Created by Bhoopendra on 8/12/19.
//  Copyright © 2019 Bhoopendra. All rights reserved.
//

import UIKit
import ObjectMapper
import RealmSwift

class CreateSRViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    
    var realm:Realm? = nil
    var userResult:Results<UserCurrentData>? = nil
    @IBOutlet weak var lblNetStatus: UILabel!
    @IBOutlet weak var submitView: UIView!
    @IBOutlet weak var descr: JVFloatLabeledTextView!
    @IBOutlet weak var transparantView: UIView!
    @IBOutlet weak var submitServiceRequest: UIView!
    @IBOutlet weak var backToSRView: UIView!
    @IBOutlet weak var caseTypeView: UIView!
    @IBOutlet weak var issuetypeLabel: UILabel!
    @IBOutlet weak var srCaseTypeBTN: UIButton!
    @IBOutlet weak var backBTNTitle: UILabel!
    
    var canID = String()
    var caseArr = NSArray()
    var caseTypeID = String()
    var caseTypeStatus = String()
    var srActivationStatus = String()
    var accountCancceled = String()
    var screenFrom = String()
    @IBOutlet var caseTableView: UITableView!
    @IBOutlet var createdSRNmbrLBL: UILabel!
    
    //MARK: View controller life cycle
    override func viewDidLoad()
    {
        super.viewDidLoad()

        realm = try? Realm()
        setCornerRadiusView(radius: Float(submitView.frame.height/2), color: UIColor.cornerBGFullOpack, view: submitView)
        setCornerRadiusView(radius: Float(backToSRView.frame.height/2), color: UIColor.cornerBGFullOpack, view: backToSRView)
        showViews(withBool: true)
        
        userResult = self.realm!.objects(UserCurrentData.self)
        if let userData = userResult?[0]
        {
            canID = userData.CANId
        }
        caseTypeView .isHidden = true
        issuetypeLabel.isHidden = true
        descr.text = ""
        if caseTypeStatus == ""
        {
            lblNetStatus.textColor = UIColor.gray
            caseTypeID = ""
       }
        else
        {
            lblNetStatus.textColor = UIColor.white
            lblNetStatus.text = caseTypeStatus
            backBTNTitle.text = "BACK TO LOGIN"
            issuetypeLabel.isHidden = false
        }
    }

    //MARK: Button Action
    @IBAction func backBTN(_ sender: Any) {
        //self.navigationController?.popViewController(animated: false)
        if accountCancceled == "cancelled"
        {
            HelpingClass.saveToUserDefault(value: false as AnyObject, key: "status")
            Switcher.updateRootVC()
        }
        else if screenFrom == "Menu"
        {
            self.navigationController?.popViewController(animated: false)
        }
        else
        {
            AppDelegate.sharedInstance.navigateFrom=TabViewScreenName.sr
            navigateScreen(identifier: ViewIdentifier.customTabIdentifier, controller: CustomTabViewController.self)
            if self.srActivationStatus == SRCreatedStatus.cancelledAcntToReactivate
            {
                srCaseTypeBTN.isUserInteractionEnabled = false
            }
        }
    }
    
    @IBAction func showListOfNETStatusBTN(_ sender: Any)
    {
        if ConnectionCheck.isConnectedToNetwork() == true
        {
            ServiceGetCasesType()
        }
        else
        {
            noInternetCheckScreenWithMessage(errorMessage:"")
        }
    }
    
    @IBAction func submitQuaryBTN(_ sender: Any)
    {
        if ConnectionCheck.isConnectedToNetwork() == true
        {
            serviceCreateSR()
        }
        else
        {
            noInternetCheckScreenWithMessage(errorMessage:"")
        }
    }
    
    func showViews(withBool : Bool)
    {
        transparantView.isHidden = withBool
        submitServiceRequest.isHidden = withBool
    }
    
    @IBAction func backToSRBTN(_ sender: Any)
    {
        if self.srActivationStatus == SRCreatedStatus.cancelledAcntToReactivate
        {
            HelpingClass.saveToUserDefault(value: false as AnyObject, key: "status")
            Switcher.updateRootVC()
        }
        else
        {
            self.navigationController?.popViewController(animated: false)
        }
    }
    @IBAction func hideCaseTypeView(_ sender: Any)
    {
        if self.srActivationStatus == SRCreatedStatus.cancelledAcntToReactivate
        {
            HelpingClass.saveToUserDefault(value: false as AnyObject, key: "status")
            Switcher.updateRootVC()
        }
        else
        {
            caseTypeView .isHidden = true
        }
    }
       
    //MARK: Service Create SR
    func serviceCreateSR()
    {
        descr.resignFirstResponder()
        let dict = ["Action":ActionKeys.createSR, "Authkey":UserAuthKEY.authKEY,"caseType":caseTypeID, "canID":canID, "comment":descr.text as Any] as [String : Any]
        
        CANetworkManager.sharedInstance.requestApi(serviceName: ServiceMethods.serviceBaseURL, method: kHTTPMethod.POST, postData: dict as Dictionary<String, AnyObject>) { (response, error) in
            
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
                    self.showViews(withBool: false)
                    if self.srActivationStatus == SRCreatedStatus.cancelledAcntToReactivate
                    {
                        self.createdSRNmbrLBL.text = String(format: "%@ %@.",SRCreatedStatus.srRequestSuccessfullySubmit, dataResponse.value(forKey: "response") as! CVarArg)
                    }
                    else
                    {
                         self.createdSRNmbrLBL.text = String(format: "%@ %@.",SRCreatedStatus.srRequestSuccessfullySubmit, dataResponse.value(forKey: "response") as! CVarArg)
                    }
                }
                else
                {
                    self.showViews(withBool: false)
                    self.createdSRNmbrLBL.text = String(format: "%@", (dataResponse.value(forKey: "message") as? String)!)
                }
            }
        }
    }

    //MARK: Service Get CaseType
    func ServiceGetCasesType()
    {
        let dict = ["Action":ActionKeys.getCases, "Authkey":UserAuthKEY.authKEY]
        
        CANetworkManager.sharedInstance.requestApi(serviceName: ServiceMethods.serviceBaseURL, method: kHTTPMethod.POST, postData: dict as Dictionary<String, AnyObject>) { (response, error) in
            
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
                    guard let responseAr = dataResponse.value(forKey: "response") as? NSArray else
                    {
                        return
                    }
                    self.caseArr = responseAr
                    self.caseTypeView .isHidden = false
                    self.caseTableView.delegate = self
                    self.caseTableView.dataSource = self
                    self.caseTableView.reloadData()
                }
                else
                {
                    guard let errorMsg = dataResponse.value(forKey: "message") as? String else
                    {
                        return
                    }
                    self.showAlertC(message: errorMsg)
                }
            }
        }
    }
    
    //MARK: Table View delegate
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        
        return caseArr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        var cell : CaseTYpeTableViewCell? = (caseTableView.dequeueReusableCell(withIdentifier: TableViewCellName.caseTypeTableViewCell) as! CaseTYpeTableViewCell)
        
        if cell == nil {
            cell = CaseTYpeTableViewCell(style: UITableViewCell.CellStyle.default, reuseIdentifier: TableViewCellName.caseTypeTableViewCell)
        }
        cell?.caseLBL.text = ""
        if let caseDesc = ((caseArr[indexPath.row] as AnyObject) .value(forKey: "case_desc") as? String) {
            cell?.caseLBL.text = caseDesc
        }
        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        lblNetStatus.text = ""
        if let caseDesc = ((caseArr[indexPath.row] as AnyObject) .value(forKey: "case_desc") as? String) {
            lblNetStatus.text = caseDesc
        }
        lblNetStatus.textColor = UIColor.white
        self.caseTypeView .isHidden = true
        issuetypeLabel.isHidden = false
        caseTypeID = ""
        if let caseID = ((caseArr[indexPath.row] as AnyObject) .value(forKey: "case_id") as? String) {
            caseTypeID = caseID
        }
    }
}
