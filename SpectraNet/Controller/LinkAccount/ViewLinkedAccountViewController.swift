//
//  ViewLinkedAccountViewController.swift
//  My Spectra
//
//  Created by Chakshu on 12/27/19.
//  Copyright © 2019 Bhoopendra. All rights reserved.
//

import UIKit
import ObjectMapper
import RealmSwift

class ViewLinkedAccountViewController: UIViewController {
    
    var realm: Realm? = nil
    var userdata:Results<UserData>? = nil
    var currentUserData:Results<UserCurrentData>? = nil
    
    var data = [[String:AnyObject]]()
    var linkedCanId = ""
    var canId = ""
    var dataResponse = NSDictionary()
    @IBOutlet weak var linkedAccountTableView: UITableView!
    
    @IBOutlet weak var linkedAccountHeighConstain: NSLayoutConstraint!
    @IBOutlet weak var canIdLabel: UILabel!
    @IBOutlet weak var linkedCanIdLabel: UILabel!
    @IBOutlet weak var linkedAccount: UIView!
    
    @IBOutlet weak var removeButton: UIButton!
    @IBOutlet weak var linkButton: UIButton!
    @IBOutlet weak var popOverView: UIView!
    
    
    @IBOutlet weak var transParentView: UIView!
    
    var faqSelect = -1
    var isLinkedSelected = false
    
    @IBOutlet weak var popOverTop: NSLayoutConstraint!
    @IBOutlet weak var popOverLeading: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
         realm = try? Realm()
        canIdLabel.text = "CAN ID - \(canId)"
        
        if(self.canId != self.linkedCanId){
            linkedCanIdLabel.text = "Linked CAN ID - \(linkedCanId)"
        }else{
             linkedCanIdLabel.text = ""
        }
        
        print_debug(object: "data =\(data)")
         setCornerRadiusView(radius: 15, color: UIColor.clear, view: linkedAccount)
        
        setCornerRadiusView(radius: 15, color: UIColor.clear, view: popOverView)
    }
    
    override func viewWillLayoutSubviews() {
        
      
        self.changeTheViewOfTheTableView()
        
        super.viewWillLayoutSubviews()
    }
    
    func changeTheViewOfTheTableView(){
        
        let count = self.data.count
        
        var height = count * 60
        
        let heightValue = self.view.frame.height - 175
        if(height > Int(heightValue)){
            
            height = Int(heightValue)
        }
        
        linkedAccountHeighConstain.constant = CGFloat(height)
    }
    
    
    @IBAction func addCanIdAcction(_ sender: Any) {
        
        var linkedCanIds = [String]()
        
        for subdata in self.data{
            
            if let linkedCanIdValue = subdata["link_canid"] as? String{
                linkedCanIds.append(linkedCanIdValue)
                
            }
        }
        
        if  let vc = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: ViewIdentifier.LinkCanIdIdentifier) as? LinkCanIdViewController{
            vc.baseCanID = canId
            vc.linkedCanIDS = linkedCanIds
            self.navigationController?.pushViewController(vc, animated: false)
        }
        
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
                
                if(linkedcandIdValue == self.linkedCanId){
                    
                    if let isloginFrom = HelpingClass.userDefaultForKey(key: UserDefaultKeys.isLoginFrom) as? String{
                        
                        if isloginFrom == UserDefaultKeys.canID{
                            self.linkAnotherAccount(selectedCanId: base_canid)
                        }else{
                            
                             let allUsers = self.realm!.objects(UserData.self)
                            
                            if(allUsers.count > 0){
                            
                                let userData: UserCurrentData = (allUsers[0].convertToUserCurrentData())
                            try! self.realm!.write
                            {
                                self.realm!.add(userData)
                                
                                 Switcher.updateRootVC()
                            }
                            }else{
                                
                                HelpingClass.saveToUserDefault(value: false as AnyObject, key: "status")
                                Switcher.updateRootVC()
                            }
                        }
                    
                    
                    
                    
                    
                    
                }else{
                self.linkedAccountTableView.reloadData()
                self.changeTheViewOfTheTableView()
                
                if(self.data.count == 0){
                    
                     self.navigationController?.popViewController(animated: false)
                }
                }
            }
        }
    }
    }
    }
    
    @IBAction func backAction(_ sender: Any) {
        
        self.navigationController?.popViewController(animated: false)
    }
    
    
    func linkAnotherAccount(selectedCanId:String){
        
        
        self.userdata = self.realm!.objects(UserData.self)
        self.currentUserData = self.realm!.objects(UserCurrentData.self)
        if let userActData = self.currentUserData?[0]
        {
            
            print_debug(object: "userActData \(userActData)")
            
            if let userData = self.userdata
            {
                
                for (index,data) in userData.enumerated(){
                    
                    if (self.canId == data.CANId){
                        
                        try! self.realm!.write
                        {
                            self.realm!.delete(userActData)
                        }
                        
                        let userDataVAlue: UserCurrentData = (self.userdata?[index].convertToUserCurrentData())!
                        userDataVAlue.CANId = selectedCanId
                        
                        
                        print_debug(object: "userActData \(userActData)")
                        try! self.realm!.write
                        {
                            self.realm!.add(userDataVAlue)
                            
                            Switcher.updateRootVC()
                            
                           
                        }
                        
                        
                        
                        
                    }
                }
            }
            
            
            
            
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
                
                 var  checkStatus = ""
                if let status = self.dataResponse.value(forKey: "status") as? String
                {
                   checkStatus = status.lowercased()
                }
                
                if checkStatus == Server.api_status
                    
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
                                
                                Switcher.updateRootVC()
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
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

    @IBAction func linkUnLinkButtonAction(_ sender: Any) {
        
       
        
          if let dataValue = self.data[faqSelect] as? [String:AnyObject]{
            if let selectedCanId = dataValue["link_canid"] as? String{
                
                if(selectedCanId == self.linkedCanId){
                    
                    if let isloginFrom = HelpingClass.userDefaultForKey(key: UserDefaultKeys.isLoginFrom) as? String{
                        
                        if isloginFrom == UserDefaultKeys.canID{
                            self.linkAnotherAccount(selectedCanId: canId)
                        }else{
                            self.addLinkedAccountToUser(linkCanID: canId)
                            
                        }
                        
                    }
                    
                    
                }else{
                    
                    if let isloginFrom = HelpingClass.userDefaultForKey(key: UserDefaultKeys.isLoginFrom) as? String{
                        
                        if isloginFrom == UserDefaultKeys.canID{
                            self.linkAnotherAccount(selectedCanId: selectedCanId)
                        }else{
                            self.addLinkedAccountToUser(linkCanID: selectedCanId)
                            
                        }
                        
                    }
                    
                    
                }
                
               
                
            }
            
        }
        
        self.faqSelect = -1
        self.popOverView.isHidden = true
        self.isLinkedSelected = false
    }
    
    
    @IBAction func cancelButtonAction(_ sender: Any) {
        
        transParentView.isHidden = true
        self.faqSelect = -1
        self.popOverView.isHidden = true
          self.isLinkedSelected = false
    }
    
    @IBAction func removeButtonClick(_ sender: Any) {
        
        if let dataValue = self.data[faqSelect] as? [String:AnyObject]{
            if let selectedCanId = dataValue["link_canid"] as? String{
                
                self.removeLinkAccount(dataValue: dataValue, index: faqSelect)
            }
            
        }
        
        self.faqSelect = -1
        self.popOverView.isHidden = true
        self.isLinkedSelected = false
        transParentView.isHidden = true
    }
    
    
    @IBAction func removedAction(_ sender: Any) {
        
        transParentView.isHidden = false
       
       
    }
    
    
    
}


extension ViewLinkedAccountViewController:UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
       
        if let cell = tableView.dequeueReusableCell(withIdentifier: "LinkedAccountIdentifier") as? LinkedAccoundTableViewCell{
            if let data = self.data[indexPath.row] as? [String:AnyObject]{
                
                cell.setValueToCell(value: data, faqSelect: data["link_canid"] as! String == linkedCanId, islastValue: indexPath.row == (self.data.count - 1),indexValue: indexPath.row)
                cell.faqSelect = {
                    [weak self] intValue in
                    
                    
                    if(intValue == self?.faqSelect ?? -2){
                        
                        self?.faqSelect = -1
                        self?.popOverView.isHidden = true
                        self?.isLinkedSelected = false
                        
                        
                        return
                        
                    }
                    
                    
                    if(data["link_canid"] as? String == self?.linkedCanId){
                        
                        
                        
                        self?.isLinkedSelected = true
                        
                        self?.linkButton.setTitle(" Unselect", for: .normal)
                        
                    }else{
                        
                        self?.linkButton.setTitle(" Select", for: .normal)
                    }
                    
                    
                    self?.faqSelect = intValue
                    self?.popOverView.isHidden = false
                    
                    let frame = cell.moreButton!.superview?.convert(cell.moreButton!.frame, to: self?.view)
                    
                    self?.popOverTop.constant = (frame?.minY ?? 30) - 50
                    self?.popOverLeading.constant = (frame?.minX ?? 30)  - 100
                    print_debug(object: "frame = \(frame)")
                    
                    
                    
                   
//                    let popover = PopovPopover;                  popover.show(self?.popOverView ?? UIView(), point: startPoint)
                    
                   // self?.linkAnotherAccount(selectedCanId: data["link_canid"] as! String)
                }
            }
            
            return cell
        }
        
        return UITableViewCell()
    }
    


    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return self.data.count
}



}
