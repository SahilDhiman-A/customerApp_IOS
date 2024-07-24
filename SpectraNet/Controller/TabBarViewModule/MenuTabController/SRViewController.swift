//
//  SRViewController.swift
//  SpectraNet
//
//  Created by Yugasalabs-28 on 23/07/2019.
//  Copyright © 2019 Bhoopendra. All rights reserved.
//

import UIKit
import ObjectMapper
import RealmSwift

class SRViewController: UIViewController,UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate {
    
    var userTransactionData = SRData()

    var realm:Realm? = nil
    var userSrResult:Results<SRData>? = nil
    var userCurrentData:Results<UserCurrentData>? = nil

    var dataResponse = NSDictionary()
    var checkStatus = String()
    
    var AllData:Array<Dictionary<String,String>> = []
    var SearchData:Array<Dictionary<String,String>> = []
    
    var canID = String()
    var srStatusArr = NSArray()
    var srSearchDataArr = NSArray()
    var search:String=""
    @IBOutlet var srStatusLbl: UILabel!
    
    @IBOutlet weak var srTblView: UITableView!
    @IBOutlet weak var riasingView: UIView!
    @IBOutlet weak var customView: UIView!
    @IBOutlet weak var customRiaseView: UIView!
    @IBOutlet weak var searchBTN: UIButton!
    @IBOutlet weak var searchSRNumberTF: UITextField!
    @IBOutlet weak var serachImage: UIImageView!
    @IBOutlet weak var searchView: UIView!
    @IBOutlet weak var hureyLbl: UILabel!
    
    //MARK: View controller life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        realm = try? Realm()
    }
    
    override func viewWillAppear(_ animated: Bool)
    {
        super.viewWillAppear(animated)
        
        userCurrentData = self.realm!.objects(UserCurrentData.self)
        if let userData = userCurrentData?[0]
        {
            canID = userData.CANId
        }
        setCornerRadiusView(radius: Float(riasingView.frame.height/2), color: UIColor.cornerBGFullOpack, view: riasingView)
        setCornerRadiusView(radius: Float(customRiaseView.frame.height/2), color: UIColor.cornerBGFullOpack, view: customRiaseView)
        placeholderTextColor(textfeildName: searchSRNumberTF, placeHolderText: "Search by SR Number", withColor: UIColor.white)
        
        riasingView.isHidden = true
        customView.isHidden = true
        searchView.isHidden = true
        self.srTblView.isHidden = true
        if ConnectionCheck.isConnectedToNetwork() == true
        {
            serviceTypeGetSRStatus(useKey: "canID", useNumber: canID)
        }
        else
        {
            noInternetCheckScreenWithMessage(errorMessage:"")
        }
        searchSRNumberTF.addTarget(self, action: #selector(SRViewController.textFieldDidChange(_:)), for: UIControl.Event.editingChanged)
    }
    
    //MARK: TextField delegate
    @objc func textFieldDidChange(_ textField: UITextField)
    {
        if textField.text!.isEmpty
        {
            searchBTN.isHidden = true
            serachImage.isHidden = true
            serviceTypeGetSRStatus(useKey: "canID", useNumber: canID)
            serachImage.image = UIImage(named: "filterarrow")
            searchBTN.isSelected = false
        }
        else
        {
            searchBTN.isHidden = false
            serachImage.isHidden = false
        }
    }
   
    func textFieldShouldReturn(_ textField: UITextField) -> Bool
    {
        textField.resignFirstResponder();
        return true;
    }
   
    //MARK: Table View delegate
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return userSrResult?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        var cell : SRTableViewCell? = (srTblView.dequeueReusableCell(withIdentifier: TableViewCellName.srTableViewCell) as! SRTableViewCell)
        
        if cell == nil
        {
            cell = SRTableViewCell(style: UITableViewCell.CellStyle.default, reuseIdentifier: TableViewCellName.srTableViewCell)
        }
      
        if let srData = userSrResult?[indexPath.row]
        {
            cell?.lblSRNmbr.text = srData.srNumber
            if srData.status.lowercased() == Server.sr_status
            {
                cell?.statusImg.image = UIImage(named: "status1")
            }
            else
            {
                cell?.statusImg.image = UIImage(named: "status0")
            }
             cell?.lblPrblmType.text = srData.problemType
             cell?.lblSubPrblmType.text = srData.subType
            
            var date = String()
                if srData.ETR != ""
                {
                    date = setInvoiceListDateFormate(previousDateStr: srData.ETR, withPreviousDateFormte: DateFormats.orderDate12HoursFormate, replaeWithFormate: DateFormats.orderDate24WithTime)
                    print_debug(object: date)
                    cell?.lblResolve.text = replaceStringWithStr(yourString: date, replaceStr: " ", withSyring: " at ")
                }
                else
                {
                    cell?.lblResolve.text = srData.ETR
                }
        }

        return cell!
    }
    
    //MARK: Service Get SR Status
    func serviceTypeGetSRStatus(useKey: String, useNumber: String)
    {
        let dict = ["Action":ActionKeys.getSRStatus, "Authkey":UserAuthKEY.authKEY, useKey:useNumber]
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
                if self.dataResponse.value(forKey: "response") is Dictionary<AnyHashable,Any>
                {
                    let alertMsg: Any = self.dataResponse.value(forKey: "response") as Any
                    guard let errorMsg = (alertMsg as AnyObject).value(forKey: "message") as? String else
                    {
                      return
                     }
                      self.showAlertC(message: errorMsg)
                }
                else
                {
                    guard let responseArr = self.dataResponse.value(forKey: "response") as? NSArray else
                    {
                        return
                    }
                    self.srStatusArr = responseArr
                    
                    if self.srStatusArr.count>0
                    {
                        var dict1 = NSDictionary()
                        if let dict = response as? NSDictionary
                        {
                            dict1 = dict
                        }
                        var arr = NSArray()
                        guard let responseArr = dict1.value(forKey: "response") as? NSArray else
                        {
                            return
                        }
                        arr = responseArr

                        try! self.realm!.write
                        {
                            if let users = self.realm?.objects(SRData.self) {
                                self.realm!.delete(users)
                            }
                        }

                        for entry in arr {

                            if let currentUser = Mapper<SRData>().map(JSONObject: entry) {

                                try! self.realm!.write {
                                    self.realm!.add(currentUser)
                                }
                            }
                        }
  //                      DatabaseHandler.instance().getAndSaveSRData(dict:responseArr)
                        self.userSrResult = self.realm!.objects(SRData.self)
                        
                        self.customView.isHidden = true
                        self.srTblView.dataSource=self
                        self.srTblView.reloadData()
                        self.srTblView.isHidden = false
                        self.riasingView.isHidden = false
                        self.searchView.isHidden = false
                        self.serachImage.isHidden = true
                        self.searchBTN.isHidden = true
                    }
                    else
                    {
                        self.customView.isHidden = false
                        self.srStatusLbl.text = DefaultString.noSRrequest
                        self.hureyLbl.text=DefaultString.hurrey
                    }
                }
            }
            else
            {
                self.customView.isHidden = false
                self.srStatusLbl.text = DefaultString.noSRrequest
                self.hureyLbl.text=DefaultString.hurrey
            }
          }
        }
    }
    
    //MARK: Service SearchSR
    func serviceTypeSearchSR(useKey: String, useNumber: String)
    {
        let dict = ["Action":ActionKeys.getSRStatus, "Authkey":UserAuthKEY.authKEY,useKey:useNumber]
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
                    if self.dataResponse.value(forKey: "response") is Dictionary<AnyHashable,Any>
                    {
                        let alertMsg: Any = self.dataResponse.value(forKey: "response") as Any
                        guard let errorMsg = (alertMsg as AnyObject).value(forKey: "message") as? String else
                        {
                           return
                        }
                        self.showAlertC(message: errorMsg)
                    }
                    else
                    {
                        //self.srStatusArr = self.dataResponse.value(forKey: "response") as! NSArray
                        guard let responseArr = self.dataResponse.value(forKey: "response") as? NSArray else
                        {
                            return
                        }
                        self.srStatusArr = responseArr
                        var dict1 = NSDictionary()
                        if let dict = response as? NSDictionary
                        {
                            dict1 = dict
                        }
                        var arr = NSArray()
                        guard let responseAr = dict1.value(forKey: "response") as? NSArray else
                        {
                            return
                        }
                        arr = responseAr
                        try! self.realm!.write
                        {
                            if let users = self.realm?.objects(SRData.self) {
                                self.realm!.delete(users)
                            }
                        }
                        
                        for entry in arr {
                            
                            if let currentUser = Mapper<SRData>().map(JSONObject: entry) {
                                
                                try! self.realm!.write {
                                    self.realm!.add(currentUser)
                                }
                            }
                        }
                        // DatabaseHandler.instance().getAndSaveSRData(dict:responseArr)
                        self.userSrResult = self.realm!.objects(SRData.self)
                        self.customView.isHidden = true
                        self.srTblView.dataSource=self
                        self.srTblView.reloadData()
                        self.riasingView.isHidden = false
                        self.searchView.isHidden = false
                        self.serachImage.isHidden = false
                        self.searchBTN.isHidden = false
                    }
                }
                else
                {
                    self.hureyLbl.text=""
                    self.srStatusLbl.text = "No Request found."
                    self.customView.isHidden = false
                }
            }
        }
    }
    
  //MARK: Button Actions
   @IBAction func clickSearchBTN(_ sender: Any)
    {
        if ConnectionCheck.isConnectedToNetwork() == true
        {
            searchBTN.isSelected = !searchBTN.isSelected
        
            if(searchBTN.isSelected == true)
            {
                serachImage.image = UIImage(named: "cross")
                serviceTypeSearchSR(useKey: "srNumber", useNumber: searchSRNumberTF.text!)
            }
        else
            {
                serachImage.image = UIImage(named: "filterarrow")
                serviceTypeGetSRStatus(useKey: "canID", useNumber: canID)
                searchSRNumberTF.text = ""
            }
        }
        else
        {
            noInternetCheckScreenWithMessage(errorMessage:"")
        }
    }
    
    @IBAction func createSRBTN(_ sender: Any)
    {
       goCreateSRScreen(fromScreen: "")
    }
    
    @IBAction func createSRClick(_ sender: Any)
    {
        goCreateSRScreen(fromScreen: "")
    }
    
   
}
