//
//  CanIDViewController.swift
//  SpectraNet
//
//  Created by Bhoopendra on 8/8/19.
//  Copyright © 2019 Bhoopendra. All rights reserved.
//

import UIKit
import ObjectMapper
import RealmSwift

class CanIDViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    @IBOutlet weak var MoreViewHeight: NSLayoutConstraint!
    
    @IBOutlet weak var moreViewTop: NSLayoutConstraint!
    @IBOutlet weak var leadingMoreCiewConstraint: NSLayoutConstraint!
    var realm:Realm? = nil
    var userResult:Results<UserData>? = nil
    var userCurrentData:Results<UserCurrentData>? = nil
    var dataResponse = NSDictionary()
    var checkStatus = String()
    
     var data = [[String:AnyObject]]()
    @IBOutlet weak var tblView: UITableView!
    
    @IBOutlet weak var moreView: UIView!
    var faqSelect = -1
    var isLinkedSelected = false
    
     var isLinkedRemoveSelcted = false
    
    @IBOutlet weak var selectButton: UIButton!
    
    @IBOutlet weak var backgroudButton: UIButton!
    
     @IBOutlet weak var transParentView: UIView!
    //MARK: View controller life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        realm = try? Realm()
        userResult = self.realm!.objects(UserData.self)
        
         userCurrentData = self.realm?.objects(UserCurrentData.self)
        changeAccountFirbaseAnalysics()
    }
    
    
    func touchesBegan(_ touches: Set<AnyHashable>, withEvent event: UIEvent) {
        var touch: UITouch? = touches.first as! UITouch
        //location is relative to the current view
        // do something with the touched point
        if touch?.view != self.moreView {
            moreView.isHidden = true
        }
    }
    
    //MARK: TableView delegate
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        
         var  count = userResult?.count ?? 0
        
        count = count + data.count
        
        
        return count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        var cell : CanIDTableViewCell? = (tblView.dequeueReusableCell(withIdentifier: TableViewCellName.canIDTableViewCell) as! CanIDTableViewCell)
        
        if cell == nil {
            cell = CanIDTableViewCell(style: UITableViewCell.CellStyle.default, reuseIdentifier: TableViewCellName.canIDTableViewCell)
        }
        
        var selectionID = ""
         cell?.lblAcount.text = String(format: "Account %d", indexPath.row+1)

//        if indexPath.row==0 {
//          
//        }
//        else
//        {
//            cell?.lblAcount.textColor = UIColor.bgHalfOpackWithWhite
//            cell?.lblUserCanID.textColor = UIColor.viewBackgroundHalfOpack
//        }
        
        if(indexPath.row < userResult?.count ?? 0 ){
        if let userData = userResult?[indexPath.row]
        {
             selectionID = userData.CANId
            cell?.lblUserCanID.text = String(format: "CAN ID - %@", userData.CANId)
        }
        }else{
            let count = userResult?.count ?? 0
            let index = indexPath.row - count
               if let data = self.data[index] as? [String:AnyObject]{
                
                if let link_canid =  data["link_canid"]  as? String{
                    
                    selectionID = link_canid
                    cell?.lblUserCanID.text = String(format: "CAN ID - %@", link_canid)
                }
                
            }
            
            }
        
        if(self.userCurrentData?.count ?? 1 > 0 ){
            
            
            if let currentdata = self.userCurrentData?[0]{
                if  selectionID  == currentdata.CANId{
                    
                    
                if(indexPath.row < userResult?.count ?? 0 ){
                    cell?.moreButton.isHidden = true
                    }
                    
                    cell?.linkedAccountValue.isHidden = false
                }else{
                     cell?.moreButton.isHidden = false
                    cell?.linkedAccountValue.isHidden = true
                }
        }}
        
        cell?.moreButton.tag = indexPath.row
        
        
        return cell!
    }
    
   
    
    //MARK: Button Action
    @IBAction func backBTN(_ sender: Any)
    {
        self.navigationController?.popViewController(animated: false)
    }
    
    
    @IBAction func CanIdMoreButton(_ sender: UIButton) {
        
        
        backgroudButton.isHidden = false
        
        
        
        
        print_debug(object: "sender = \(sender)")
        
        if(sender.tag == self.faqSelect ?? -2){
            
            self.faqSelect = -1
            self.moreView.isHidden = true
            self.isLinkedSelected = false
            
            
            return
            
        }
        

        
        
        self.faqSelect = sender.tag
        self.moreView.isHidden = false
        
        let frame = sender.superview?.convert(sender.frame, to: self.view)
        
        self.moreViewTop.constant = (frame?.minY ?? 30) - 90
        self.leadingMoreCiewConstraint.constant = (frame?.minX ?? 30)  - 70
        print_debug(object: "frame = \(frame)")
        self.selectButton.setTitle(" Select", for: .normal)
         if(sender.tag  < userResult?.count ?? 0 ){
           MoreViewHeight.constant = 60
            self.isLinkedRemoveSelcted = false
            
         }else{
            let count = userResult?.count ?? 0
            let index = self.faqSelect - count
            if let data = self.data[index] as? [String:AnyObject]{
                
                
                if(self.userCurrentData?.count ?? 1 > 0 ){
                    
                    
                    if let currentdata = self.userCurrentData?[0]{
                         if let link_canid =  data["link_canid"]  as? String{
                            
                            if(link_canid == currentdata.CANId){
                                self.selectButton.setTitle(" Remove", for: .normal)
                                 MoreViewHeight.constant = 60
                                self.isLinkedRemoveSelcted = true
                                return
                                
                            }
                            
                        }
                        
                        
                    }
                
            }
            }
             self.isLinkedRemoveSelcted = false
              MoreViewHeight.constant = 123
        }
        
    }
    
    @IBAction func selectUnSelectCalled(_ sender: Any) {
        
        
        
          if(self.faqSelect  < userResult?.count ?? 0 ){
         self.changeTheCanId(selected: self.faqSelect)
            
          }else{
            
            
            if(isLinkedRemoveSelcted == true){
                
                 transParentView.isHidden = false
                
                return
            }
            let count = userResult?.count ?? 0
            let index = self.faqSelect - count
            if let data = self.data[index] as? [String:AnyObject]{
                
                if let link_canid =  data["link_canid"]  as? String{
                    
                    self.addLinkedAccountToUser(linkCanID: link_canid)
                }
                
                
            }
            
            
        }
        
        
        
    }
    
    
    
    func changeTheCanId(selected:Int)  {
        self.userResult = self.realm!.objects(UserData.self)
        
        try! self.realm!.write
        {
            if let users = self.realm?.objects(UserCurrentData.self) {
                self.realm!.delete(users)
            }
        }
        
        let userData: UserCurrentData = userResult![selected].convertToUserCurrentData()
        try! self.realm!.write
        {
            self.realm!.add(userData)
        }
        
        
        self.userCurrentData = self.realm!.objects(UserCurrentData.self)
        
        if userData.CancellationFlag == true
        {
            self.navigateScreenToStoryboardMain(identifier: ViewIdentifier.cancelledAccountIdentifier, controller: AccountCancelledViewController.self)
        }
        else if userData.actInProgressFlag == true
        {
            
            if   let vc = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: ViewIdentifier.trackOrderIdentifier) as? TrackOrderViewController{
                                           
                                           
                                                   
                 
                vc.canID = userData.CANId
                       self.navigationController?.pushViewController(vc, animated: false)
                                                       
                          
                                           }
                                           
                                      
                                       
                                        
                                    
        }
        else
        {
            AppDelegate.sharedInstance.navigateFrom=""
            navigateScreen(identifier: ViewIdentifier.customTabIdentifier, controller: CustomTabViewController.self)
        }
    }
    
    
    func  addLinkedAccountToUser(linkCanID:String){
        
        let dict = ["Action":ActionKeys.userAccountData, "Authkey":UserAuthKEY.authKEY, "canID":linkCanID]
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
                    
                    try! self.realm!.write
                    {
                        if let users = self.realm?.objects(UserCurrentData.self) {
                            
                            self.realm!.delete(users)
                        }
                    }
                    
                    guard let responseArr = self.dataResponse.value(forKey: "response") as? NSArray else
                    {
                        return
                    }
                    
                    
                    
                    for entry in responseArr{
                        
                        if let currentUser = Mapper<UserCurrentData>().map(JSONObject: entry) {
                            
                            
                            print_debug(object: "currentUser \(currentUser)")
                            try! self.realm!.write
                            {
                                self.realm!.add(currentUser)
                                
                                if currentUser.CancellationFlag == true
                                {
                                    self.navigateScreenToStoryboardMain(identifier: ViewIdentifier.cancelledAccountIdentifier, controller: AccountCancelledViewController.self)
                                }
                                else if currentUser.actInProgressFlag == true
                                {
                                    
                                    
                                   if   let vc = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: ViewIdentifier.trackOrderIdentifier) as? TrackOrderViewController{
                                                                            
                                                                            
                                                                                    
                                                  
                                                 vc.canID = currentUser.CANId
                                                        self.navigationController?.pushViewController(vc, animated: false)
                                                                                        
                                                           
                                                                            }
                                }
                                else
                                {
                                    AppDelegate.sharedInstance.navigateFrom=""
                                    self.navigateScreen(identifier: ViewIdentifier.customTabIdentifier, controller: CustomTabViewController.self)
                                }
                            }
                        }
                    }
                    
                    
                    
                }else{
                    
                    guard let errorMsg = self.dataResponse.value(forKey: "message") as? String else
                    {
                        return
                    }
                    self.showAlertC(message: errorMsg)
                    
                }
                
            }
        }
    }
    @IBAction func unlinkedCalled(_ sender: Any) {
        transParentView.isHidden = false
        
    }
    
    @IBAction func cancelButtonAction(_ sender: Any) {
        
        transParentView.isHidden = true
        self.faqSelect = -1
        self.moreView.isHidden = true
        self.isLinkedSelected = false
    }
    
    @IBAction func removeButtonClick(_ sender: Any) {
        
        let count = userResult?.count ?? 0
        let index = self.faqSelect - count
        
        if let dataValue = self.data[index] as? [String:AnyObject]{
            if let selectedCanId = dataValue["link_canid"] as? String{
                
                self.removeLinkAccount(dataValue: dataValue, index: index)
            }
            
        }
        
        self.faqSelect = -1
        self.moreView.isHidden = true
        self.isLinkedSelected = false
        transParentView.isHidden = true
    }
    
    func removeLinkAccount(dataValue:[String:AnyObject],index:Int)
    {
        
        if let linkedcandIdValue = dataValue["link_canid"] as? String, let base_canid =  dataValue["base_canid"] as? String ,let username =  dataValue["username"] as? String ,let mobile =  dataValue["mobile"] as? String{
            var dict = ["Action":ActionKeys.removeLinkAccount, "Authkey":UserAuthKEY.authKEY,"linkCanID":linkedcandIdValue,"userName":username,]
            
            if let isloginFrom = HelpingClass.userDefaultForKey(key: UserDefaultKeys.isLoginFrom) as? String{
                
                if isloginFrom == UserDefaultKeys.canID{
                    dict["baseCanID"] = base_canid
                    
                }else{
                    
                    if let mobileNumber = HelpingClass.userDefaultForKey(key: UserDefaultKeys.loginPhoneNumber) as? String{
                        dict["mobileNo"] = mobileNumber
                    }
                }
            }
            print_debug(object: dict)
            CANetworkManager.sharedInstance.requestApi(serviceName: ServiceMethods.serviceBaseURL, method: kHTTPMethod.POST, postData: dict as Dictionary<String, AnyObject>) { (response, error) in
                
                print_debug(object: response)
                if response != nil
                {
                    
                    
                    if let  responseValue = response?["status"] as? String{
                        
                        
                        if responseValue != Server.api_status
                        {
                            if let  statusMessage = response?[ "message"] as? String {
                                self.showAlertC(message: statusMessage)
                                
                            }
                            return
                        }
                        
                    }
                    
                    self.data.remove(at: index)
                    
                    if(self.isLinkedRemoveSelcted == true){
                        
                        self.changeTheCanId(selected: 0)
                   
                    }else{
                        
                        self.tblView.reloadData()
                    }
                }
            }
        }
    }
    
    
    @IBAction func backgroungViewClick(_ sender: Any) {
        
        backgroudButton.isHidden = true
        
        self.faqSelect = -1
        self.moreView.isHidden = true
        self.isLinkedSelected = false
    }
    
    func changeAccountFirbaseAnalysics(){
        
        if let currentdata = self.userCurrentData?[0]{
        
        let dictAnalysics = [AnanlysicParameters.canID:currentdata.CANId,
                             AnanlysicParameters.Category:AnalyticsEventsCategory.my_account,
                             AnanlysicParameters.Action:AnalyticsEventsActions.change_account,
                             AnanlysicParameters.EventType:AnanlysicParameters.ClickEvent]

        HelpingClass.sharedInstance.addFirebaseAnalysis(eventName: AnalyticsEventsName.change_account, parameters: dictAnalysics as? [String:AnyObject] ?? [String:AnyObject]() )
        }
        
    }
}


