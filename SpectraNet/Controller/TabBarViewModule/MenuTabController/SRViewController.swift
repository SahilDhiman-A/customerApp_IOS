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
    
    @IBOutlet weak var srKnowMoreView: UIView!
    
    
    @IBOutlet weak var srNumberLabel: UILabel!
    @IBOutlet weak var createDateLabel: UILabel!
    @IBOutlet weak var problemTypeLabel: UILabel!
    @IBOutlet weak var createTimeLabel: UILabel!
    @IBOutlet weak var problemSubtype: UILabel!
    @IBOutlet weak var problemSubSubtype: UILabel!
    @IBOutlet weak var descptionLabel: UILabel!
    @IBOutlet weak var etrResolutionTime : UILabel!
     @IBOutlet weak var srstatusMOreView : UILabel!
    @IBOutlet weak var descptionView: UIView!
    @IBOutlet weak var descrtionHeightConstain : NSLayoutConstraint!
    @IBOutlet weak var knowViewHeightConstain : NSLayoutConstraint!

    
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
        let customView = UIView(frame: CGRect(x: 0, y: 0, width: 200, height: 70))
        customView.backgroundColor = UIColor.clear
        
        srTblView.tableFooterView = customView
       // viewAllSRDetailFirbaseAnalysics()
       
        if(AppDelegate.sharedInstance.navigateFrom == ""){
            menuSRFirbaseAnalysics()
            
        }
        AppDelegate.sharedInstance.navigateFrom = ""
    }

    func menuSRFirbaseAnalysics(){

        let dictAnalysics = [AnanlysicParameters.canID:canID,
                             AnanlysicParameters.Category:AnalyticsEventsCategory.dashboard_menu,
                             AnanlysicParameters.Action:AnalyticsEventsActions.menu_my_sr,
                             AnanlysicParameters.EventType:AnanlysicParameters.ClickEvent]
        
        //,AnanlysicParameters.EventDescription:AnanlysicEventDescprion.loginwithUserNamePassword

       HelpingClass.sharedInstance.addFirebaseAnalysis(eventName: AnalyticsEventsName.menu_click_my_sr, parameters: dictAnalysics as? [String:AnyObject] ?? [String:AnyObject]() )
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
            if srData.status.lowercased() == Server.sr_status || srData.status.lowercased() == Server.sr_statusCanecled
            {
                cell?.knowMoreView.isHidden = true
                cell?.statusImg.image = UIImage(named: "status1")
            }
            else
            {
                cell?.knowMoreView.isHidden = false
                cell?.statusImg.image = UIImage(named: "status0")
            }
             cell?.lblPrblmType.text = srData.problemType
             cell?.lblSubPrblmType.text = srData.subType
            cell?.knowMoreButton.tag = indexPath.row
            
            var date = String()
                if srData.ETR != ""
                {
                    date = setInvoiceListDateFormate(previousDateStr: srData.ETR, withPreviousDateFormte: DateFormats.orderDate12HoursFormate, replaeWithFormate: DateFormats.orderDate12WithoutTime)
                    
                    
                    if let date = HelpingClass.sharedInstance.convert(time: srData.ETR, fromFormate: DateFormats.orderDate12HoursFormate, toFormate: DateFormats.orderDate12WithoutTime),let time = HelpingClass.sharedInstance.convert(time: srData.ETR, fromFormate: DateFormats.orderDate12HoursFormate, toFormate: DateFormats.orderTime12){
                          print_debug(object: date)
                          print_debug(object: time)
                    cell?.lblResolve.text = date + " at " + time
                    }
                }
                else
                {
                    cell?.lblResolve.text = srData.ETR
                }
        }

        return cell!
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        
        
        if let srData = userSrResult?[indexPath.row]
              {
                if srData.status.lowercased() == Server.sr_status  || srData.status.lowercased() == Server.sr_statusCanecled
                {
                return 270
                }else{
                    
                    return 354
                }
                
        }
        else{
            
             return 270
        }
        
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
                         self.srTblView.delegate=self
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
            self.searchRequestFirbaseAnalysics(search_query: useNumber)
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
        raiseNewRequestFirbaseAnalysics()
       goCreateSRScreen(fromScreen: "")
    }
    
    @IBAction func createSRClick(_ sender: Any)
    {
        raiseNewRequestFirbaseAnalysics()
        goCreateSRScreen(fromScreen: "")
    }
    
    
    
    @IBAction func knowMoreButtonClick(_ sender: UIButton) {
        
        if let tagValue = sender.tag as? Int{

            if let srData = userSrResult?[tagValue]{
                
                if let srValue = srData.srNumber as? String{
        let dict = ["Action":ActionKeys.checkSR, "Authkey":UserAuthKEY.authKEY, "srNumber":srValue,"canId":canID]
        print_debug(object: dict)
        CANetworkManager.sharedInstance.requestApi(serviceName: ServiceMethods.serviceBaseUatValue, method: kHTTPMethod.POST, postData: dict as Dictionary<String, AnyObject>) { (response, error) in
            
            print_debug(object: response)
            self.knowMoreFirbaseAnalysics()
             if response != nil
             {
                 
                 if let status = response?["status"] as? String{
                     
                     
                     if status.lowercased() == Server.api_status{
                         
                         
                         if let array = response?["response"] as? [[String:AnyObject]]{
                             
                             
                             if array.count > 0 {
                               
                                 if let value = array[0] as? [String:AnyObject]{
                                     
                        if let ETR = value["SRstatusETR"] as? String{
                    if let value = HelpingClass.sharedInstance.convert(time: ETR, fromFormate: "dd/MM/yyyy hh:mm a", toFormate:"dd-MM-yyyy" ){
                                             
                                if let valueData = HelpingClass.sharedInstance.convert(time: ETR, fromFormate: "dd/MM/yyyy hh:mm a", toFormate:"hh:mm a" ){
                                                 self.etrResolutionTime.text = value + " at " + valueData
                                             }
                                             
                                             
                                                                                    
                                                     }
                                        
                                        
                                     }
                                     
                              if let lastUpdatedOn = value["createdon"] as? String{
                                 if let value = HelpingClass.sharedInstance.convert(time: lastUpdatedOn, fromFormate: "dd/MM/yyyy hh:mm a", toFormate:"dd-MM-yyyy" ){
                                         self.createDateLabel.text = value
                                                                                                                       }
                                         if let value = HelpingClass.sharedInstance.convert(time: lastUpdatedOn, fromFormate: "dd/MM/yyyy hh:mm a", toFormate:"hh:mm a" ){
                                                                                 self.createTimeLabel.text = value
                                                                                                                                                              }
                                                                           
                                                                           
                                                                        }
                                     
                                     if let srNumber = value["srNumber"] as? String{
                                         self.srNumberLabel.text = srNumber
                                        
                                     }
                                     if let problemType = value["problemType"] as? String{
                                         self.problemTypeLabel.text = problemType
                                                                           
                                     }
                                    
                                     if let subSubType = value["subType"] as? String{
                                         self.problemSubtype.text = subSubType
                                                                           
                                     }
                                    if let messageTemplate = value["MessageTemplate"] as? String{
                                        
                                        let value = messageTemplate
                                        
                                       // let value =  "wdojjoiwnklwdnk jwdbj jdwbjdwjbkdwjkjkbdwbjkdbjwkbjkdwjbkdwbjkdbjwkbjdkwbjdwbjwbjdjbkwdjkbwjdbbwjd dwjkd wjdwbkdjwbdkjbdkjdwbwdjbwkjjbwbwjbwjbkwjbkbjkwqbjkwbjkbjkwqbjkdqwbjkbjkwd d kjwd wdmnd wj dnw "
                                        
                                        if  let font = UIFont(name: "Helvetica", size: 17.0){
                                                       
                                        var height = HelpingClass.sharedInstance.heightForView(text:value, font: font, width: self.view.frame.width - 100)
                                            
                                            if(height>0){
                                                
                                                if height > 100{
                                                    height = 100
                                                }
                                self.knowViewHeightConstain.constant = 460 + height + 40
                                self.descrtionHeightConstain.constant = height + 20 + 10
                                self.descptionView.isHidden = false
                                self.view.layoutIfNeeded()
                                            }
                                            else
                                            {
                                self.descrtionHeightConstain.constant = 0
                                self.knowViewHeightConstain.constant = 430 + 40
                                self.descptionView.isHidden = true
                                self.view.layoutIfNeeded()
                                            }
                                            
                                        }
                                        self.descptionLabel.text = value
                                                                          
                                    }
                                    
                                    if let status = value["status"] as? String{
                                        self.srstatusMOreView.text = status
                                                                          
                                    }
                                     
                                     
                                 }
                                 UIApplication.shared.keyWindow!.addSubview(self.srKnowMoreView!)
                                UIApplication.shared.keyWindow!.bringSubviewToFront(self.srKnowMoreView!)
                                self.view.bringSubviewToFront( self.srKnowMoreView)

                               self.srKnowMoreView.isHidden = false
                                 
                             }
                             
                             
                             
                         }
                         
                     }else{
                        
                        if  let alertMsg: String = response?["message"] as? String{
                                            
                                              self.showAlertC(message: alertMsg)
                                           }
                   
                 }
                 }
                 
                 
                  
            }
        }
        
        print_debug(object: sender.tag)
            
        }
            }
        }
    }
    
    func knowMoreFirbaseAnalysics(){
    
        let dictAnalysics = [AnanlysicParameters.canID:canID,
                             AnanlysicParameters.Category:AnalyticsEventsCategory.service_request,
                             AnanlysicParameters.Action:AnalyticsEventsActions.know_more_click,
                             AnanlysicParameters.EventType:AnanlysicParameters.ClickEvent]

       HelpingClass.sharedInstance.addFirebaseAnalysis(eventName: AnalyticsEventsName.service_request_know_more, parameters: dictAnalysics as? [String:AnyObject] ?? [String:AnyObject]() )
    }
    
    func raiseNewRequestFirbaseAnalysics(){
    
        let dictAnalysics = [AnanlysicParameters.canID:canID,
                             AnanlysicParameters.Category:AnalyticsEventsCategory.service_request,
                             AnanlysicParameters.Action:AnalyticsEventsActions.raise_new_service_request,
                             AnanlysicParameters.EventType:AnanlysicParameters.ClickEvent]

       HelpingClass.sharedInstance.addFirebaseAnalysis(eventName: AnalyticsEventsName.raise_new_service_request, parameters: dictAnalysics as? [String:AnyObject] ?? [String:AnyObject]() )
    }
    
    func searchRequestFirbaseAnalysics(search_query:String){
    
        let dictAnalysics = [AnanlysicParameters.canID:canID,
                             AnanlysicParameters.Category:AnalyticsEventsCategory.service_request,
                             AnanlysicParameters.Action:AnalyticsEventsActions.search,
                             AnanlysicParameters.EventType:AnanlysicParameters.ClickEvent,
                             "search_query":search_query]

       HelpingClass.sharedInstance.addFirebaseAnalysis(eventName: AnalyticsEventsName.search_by_sr_number, parameters: dictAnalysics as? [String:AnyObject] ?? [String:AnyObject]() )
    }
    
    @IBAction func knowMoreButtonCancel(_ sender: Any) {
        
         srKnowMoreView.isHidden = true
    }
    
}
