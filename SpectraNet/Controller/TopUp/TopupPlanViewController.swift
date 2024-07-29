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
    var userVAlue:Results<UserCurrentData>? = nil
    var basePlan = String()
    var canID = String()
    var topupAmount = String()
    var topupName = String()
    var topupType = String()
    var dataResponse = NSDictionary()
    var checkStatus = String()
    var topUpArray = NSArray()
    var consumberTopUpTotalArray:[AnyObject] = [AnyObject]()
    var consumberTopUpArray:[AnyObject] = [AnyObject]()
    @IBOutlet weak var topUpableView: UITableView!
    @IBOutlet weak var tranprntView: UIView!
    @IBOutlet weak var dialogeView: UIView!
    @IBOutlet weak var lblDialogeStatusMsg: UILabel!
    @IBOutlet weak var ButtonRoundView: UIView!
    @IBOutlet weak var errorLabel: UILabel!
    @IBOutlet weak var labelHeightConstain: NSLayoutConstraint!
    @IBOutlet weak var lblTitleName: UILabel!
    @IBOutlet weak var oneTimeTopUpBTN: UIButton!
    @IBOutlet weak var recurringBTN: UIButton!
    @IBOutlet weak var oneTimeTopUpLine: UILabel!
    @IBOutlet weak var recurringLine: UILabel!
    var tdsAmountPerMonth = String()
    
    
    @IBOutlet weak var bottomLabel: UILabel!
    
    
    @IBOutlet weak var chooseView: UIView!
    @IBOutlet weak var choiceLabel: UILabel!
    @IBOutlet weak var chooseWhiteView: UIView!
    @IBOutlet weak var firstWhiteView: UIView!
    @IBOutlet weak var makePaymentView: UIView!
    @IBOutlet weak var makePaymentFirstWhiteView: UIView!
    @IBOutlet weak var makePaymentSecondWhiteView: UIView!
    @IBOutlet weak var activationView: UIView!
    @IBOutlet weak var secondWhiteView: UIView!
    @IBOutlet weak var activationFirstWhiteView: UIView!
    @IBOutlet weak var makePaymentLabel: UILabel!
    @IBOutlet weak var secondLabel: UILabel!
    @IBOutlet weak var thirdLabel: UILabel!
    @IBOutlet weak var activationLabel: UILabel!
    
    
    @IBOutlet weak var payNowView: UIView!
    @IBOutlet weak var paymentLabel: UILabel!
    
    @IBOutlet weak var paymentSuccessFulView: UIView!
    
    @IBOutlet weak var deactivateView: UIView!
    @IBOutlet weak var deactivateSucessView: UIView!
    @IBOutlet weak var topUpDescLabel: UILabel!
    var isFromMySRScreen = false
    var onetimetopUpSelect = true
    var isTopUpAdded = false
    var isFromPayment = false
    //MARK: View controller life cycle
    override func viewDidLoad()
    {
        super.viewDidLoad()
        realm = try? Realm()
        setBelowlineColor(below1stTabLine: oneTimeTopUpLine, withColor: .bgColors, below2ndTabLine: recurringLine, withColor2: UIColor.black, btn1stTab: oneTimeTopUpBTN, with1stBtnTabColor: .bgColors , btn2ndTab: recurringBTN, with2ndBtnTabColor: UIColor.darkGray, setstatus: "Top-up", toLabel: lblTitleName)
        showAndHideDialogView(bool: true,message:"")
        serviceTypeTopUpPlan()
        //serviceTypeGetConsumebTopUpPlan()
        
        if(isTopUpAdded == true){
            
            activationTopViewSetUP()
        }
        //
    }
    
   //MARK: TableView delegate
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        
        
        let count = self.consumberTopUpArray.count + (userResult?.count  ?? 0)
        if(count == 0){
            self.bottomLabel.isHidden = true
            self.topUpableView.isHidden = true
            self.errorLabel.isHidden = false
        }else{
            self.bottomLabel.isHidden = false
            self.topUpableView.isHidden = false
            self.errorLabel.isHidden = true
        }
        return count ?? 0
    }
       
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        var cell : TopupTableViewCell? = (tableView.dequeueReusableCell(withIdentifier: TableViewCellName.TopupTableViewCell) as! TopupTableViewCell)
        if cell == nil
        {
            cell = TopupTableViewCell(style: UITableViewCell.CellStyle.default, reuseIdentifier: TableViewCellName.TopupTableViewCell)
        }
        setCornerRadiusView(radius: Float((cell?.roundPayBtnView.frame.height)!/2), color: UIColor.cornerBGFullOpack, view: cell!.roundPayBtnView)
        if(indexPath.row >= self.consumberTopUpArray.count){
            
            cell?.buyLabel.text =  "BUY"
            cell?.buyButtonWidth.constant = 131
            cell?.buyButtonHeight.constant = 40
            cell?.roundPayBtnView.isHidden = false
            cell?.roundPayBtnView.tag = 100
            cell?.topupPayBTN.removeTarget(self, action: #selector(deactivateAction), for: .touchUpInside)
            cell?.topupPayBTN.addTarget(self, action: #selector(topupPayButton), for: .touchUpInside)
    //        cell?.topupInvoiceBTN.addTarget(self, action: #selector(topupInvoiceButton), for: .touchUpInside)
    //        setCornerRadiusView(radius: Float((cell?.roundInvoiceBtnView.frame.height)!/2), color: UIColor.cornerBGFullOpack, view: cell!.roundInvoiceBtnView)
           

            if let changePlanData = userResult?[indexPath.row - self.consumberTopUpArray.count]
            {
                cell?.lblTopupName.text = changePlanData.name
                cell?.lblTopupPrice.text = "₹ " + changePlanData.price + " + 18% Taxes"
                cell?.lblTopupVolume.text = changePlanData.volume
               // cell?.lblToupExcludingTaxes.text = changePlanData.pgPrice
             
            }
            cell?.lblTopupTitle.text =  ""
            
        }else{
            
            if let changePlanData = self.consumberTopUpArray[indexPath.row] as? AnyObject{
                
                cell?.lblTopupName.text = changePlanData["topup_name"] as? String
                
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
                cell?.topupPayBTN.removeTarget(self, action: #selector(topupPayButton), for: .touchUpInside)
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
            
        }
        
        return cell!
    }
    
    //MARK: Button Actions
    
    @objc func deactivateAction(sender: UIButton!)
    {
        
        let buttonPosition = sender.convert(CGPoint.zero, to: topUpableView)
        let indexPath = topUpableView.indexPathForRow(at:buttonPosition)
        
        if let changePlanData = self.consumberTopUpArray[indexPath?.row ?? 0] as? AnyObject{
            topupAmount = changePlanData["pgPrice"] as? String ?? ""
           
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
    @IBAction func deactivateCrossAction(_ sender: Any) {
        deactivateSucessView.isHidden = true
        
    }
    @objc func topupPayButton(sender: UIButton!)
    {
        
        if(sender.tag == 200){
            
            return
        }
        let buttonPosition = sender.convert(CGPoint.zero, to: topUpableView)
        let indexPath = topUpableView.indexPathForRow(at:buttonPosition)
        
        let index = indexPath?.row ?? 0 - self.consumberTopUpArray.count
        
        if(index < userResult?.count ?? 0){
        if let changePlanData = userResult?[index]
        {
            topupAmount = changePlanData.pgPrice

            topupName = changePlanData.name
            topupType = changePlanData.type
            tdsAmountPerMonth = changePlanData.price
        }
        self.serviceTypeProDataChargesForTopup()
        }
        

    }
    
    @IBAction func paymentclick(_ sender: Any) {
                let vc = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: ViewIdentifier.PayNowIdentifier) as? PayNowViewController
                vc?.outStandingAmt = tdsAmountPerMonth
                vc?.tdsAmount = ""
                vc?.tdsPercent = ""
                vc?.canID = canID
               vc?.topupName = topupName
               vc?.topupType = topupType
                vc?.screenFrom = FromScreen.topUpScreen
                vc?.tdsAmountPerMonth = topupAmount
                self.navigationController?.pushViewController(vc!, animated: false)
        
    }
    
    func paymentTopViewSetUP(showAmount:String,payAmount:String)
    {
        chooseView.backgroundColor = .bgColors
        choiceLabel.textColor  = .bgColors
        chooseWhiteView.backgroundColor = .bgColors
        firstWhiteView.backgroundColor = .bgColors
        makePaymentView.backgroundColor = .bgColors
        makePaymentFirstWhiteView.backgroundColor = .bgColors
        makePaymentLabel.textColor  = .bgColors
        secondLabel.textColor  = UIColor.white
        self.topUpableView.isHidden = true
        self.payNowView.isHidden = false
        self.paymentLabel.text = "₹\(payAmount)"
        topupAmount = showAmount
        tdsAmountPerMonth = payAmount
        bottomLabel.text = ""
        topUpDescLabel.isHidden = false
        userVAlue = self.realm!.objects(UserCurrentData.self)
        if let userActData = userVAlue?[0]
        {
        
            if let value = HelpingClass.sharedInstance.convert(date: Date(), fromFormate: "MMM dd,yyy"){
                
                if let dateFUPResetDate =  userActData.FUPResetDate as? String  as? String{
                    
                    if let dateValue =  HelpingClass.sharedInstance.convert(time: dateFUPResetDate, fromFormate: "dd/MM/yyyy", toFormate:  "MMM dd,yyy"){
                        topUpDescLabel .text = "\(topupName) will be activated effective on \(value) and the purchased data will be available till \(dateValue)"
                        
                    }else{
                        
                        topUpDescLabel .text = "\(topupName) will be activated effective on \(value) and the purchased data will be available till \(value)"
                    }
                }else{
                    
                    topUpDescLabel .text = "\(topupName) will be activated effective on \(value) and the purchased data will be available till \(value)"
                }
                
                
        
        }
        }
    }
    
    func activationTopViewSetUP()
    {
        chooseView.backgroundColor = .bgColors
        choiceLabel.textColor  = .bgColors
        chooseWhiteView.backgroundColor = .bgColors
        firstWhiteView.backgroundColor = .bgColors
        makePaymentView.backgroundColor = .bgColors
        makePaymentFirstWhiteView.backgroundColor = .bgColors
        makePaymentLabel.textColor  = .bgColors
        secondLabel.textColor  = UIColor.white
        makePaymentSecondWhiteView.backgroundColor = .bgColors
        secondWhiteView.backgroundColor = .bgColors
        activationFirstWhiteView.backgroundColor = .bgColors
        activationLabel.textColor  = .bgColors
        thirdLabel.textColor  = UIColor.white
        activationView.backgroundColor = .bgColors
        self.topUpableView.isHidden = true
        topUpDescLabel.isHidden = true
        self.paymentSuccessFulView.isHidden = false
        topUpDescLabel.isHidden = true
        bottomLabel.text = ""
        topUpDescLabel.text = ""
    }
    func resetView()
    {
        chooseView.backgroundColor = .bgColors
        choiceLabel.textColor  = .bgColors
        chooseWhiteView.backgroundColor = .white
        firstWhiteView.backgroundColor = .white
        makePaymentView.backgroundColor = .white
        makePaymentFirstWhiteView.backgroundColor = .white
        makePaymentLabel.textColor  = .white
        secondLabel.textColor  = .bgColors
        makePaymentSecondWhiteView.backgroundColor = .white
        secondWhiteView.backgroundColor = .white
        activationFirstWhiteView.backgroundColor = .white
        activationLabel.textColor  = .white
        thirdLabel.textColor  = .bgColors
        activationView.backgroundColor = .white
        self.topUpableView.isHidden = false
        self.payNowView.isHidden = true
        self.paymentSuccessFulView.isHidden = true
        topUpDescLabel.isHidden = true
        topUpDescLabel.text = ""
    }
    
    @objc func topupInvoiceButton(sender: UIButton!)
    {
        let buttonPosition = sender.convert(CGPoint.zero, to: topUpableView)
        let indexPath = topUpableView.indexPathForRow(at:buttonPosition)
        if let changePlanData = userResult?[indexPath!.row]
        {
            topupAmount = changePlanData.pgPrice
            topupName = changePlanData.name
            topupType = changePlanData.type
        }
        serviceTypeAddTopUp()
    }
    
    @IBAction func backBTN(_ sender: Any)
    {
        
        if(isFromMySRScreen == true){
             Switcher.updateRootVC()
        }
        else if isFromPayment{
            AppDelegate.sharedInstance.navigateFrom=TabViewScreenName.menu
            navigateScreen(identifier: ViewIdentifier.customTabIdentifier, controller: CustomTabViewController.self)
        }
        else{
        self.navigationController?.popViewController(animated: false)
        }
    }
    
    @IBAction func okDialogeBUtton(_ sender: Any)
    {
        self.showAndHideDialogView(bool: true,message:"")
    }
      
    //MARK:  ServiceTypeTopUpPlan
    func serviceTypeTopUpPlan()
     {
//        canID = "139525"
//        basePlan = "HBB_250_1000_HY"
        
        let dict = ["Action":ActionKeys.getTopupPlan, "Authkey":UserAuthKEY.authKEY,"basePlan":basePlan, "canID":canID]
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

                if( self.topUpArray.count > 0){
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
                    
                    if(self.onetimetopUpSelect == true){
                        self.oneTimeTopUpClick(UIButton())
                    }else{
                        self.recurringclick(UIButton())
                    }
                    
//                    self.labelHeightConstain.constant = 90
//                    self.bottomLabel.text = "One time charges (not prorated) will be applicable & add-on data will be available till next Quota Reset date."
                }else{
                    try! self.realm!.write
                    {
                        if let users = self.realm?.objects(TopupPlanData.self) {
                            self.realm!.delete(users)
                        }
                    }
                    
                    
                    self.topUpableView.isHidden = true
                    guard let statusMessage = self.dataResponse.value(forKey: "message") as? String else
                    {
                        return
                    }
                    self.showAlertC(message: statusMessage)
                }
           //    DatabaseHandler.instance().getAndSaveListOfTopupPlan(dict: responseAr)
             
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
  
    //MARK:  ServiceTypeGetConsumebTopUpPlan
    
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
                        
                        self.consumberTopUpTotalArray = response
                        
                        if(self.onetimetopUpSelect == true){
                        self.consumberTopUpArray =      self.consumberTopUpTotalArray.filter{ ($0["type"] as! String == "NRC") }
                        }else{
                            
                            self.consumberTopUpArray =      self.consumberTopUpTotalArray.filter{ ($0["type"] as! String == "RC") }
                        }
                            
                            
                        self.topUpableView.reloadData()
                            
                        
                    }
                    
                   
                }
               
            }
        }
    }
    
    
    //MARK:  serviceTypeProDataChargesForTopup
    
    func serviceTypeProDataChargesForTopup()
    {
        
       // canID = "139525"
        
        let dict = ["Action":ActionKeys.proDataChargesForTopup, "Authkey":UserAuthKEY.authKEY, "canId":canID, "topupId":topupName]
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
                    if let response =  self.dataResponse["response"] as? [String:AnyObject]{
                        
                        if let proDataCharges = response["proDataCharges"] as? Double,  let pgDataCharges = response["pgDataCharges"] as? Double{
                            
                            if pgDataCharges > 0{
                                self.paymentTopViewSetUP(showAmount: "\(proDataCharges)", payAmount: "\(pgDataCharges)")
                            }else{
                                
                                self.activationTopViewSetUP()
                               // self.serviceTypeChangePlan()
                                
                            }
                        }
                    }
                    
                   
                }
               
            }
        }
    }
    //MARK:  ServiceTypeAddTopUp
    
    
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
                    self.showAndHideDialogView(bool: false, message: errorMsg)
                }
            }
          }
       }
    }
    
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
    
    @IBAction func oneTimeTopUpClick(_ sender: Any) {
        onetimetopUpSelect = true
        if(isTopUpAdded == false){
            resetView()
        }
        
        isTopUpAdded = false

        setBelowlineColor(below1stTabLine: oneTimeTopUpLine, withColor: .bgColors, below2ndTabLine: recurringLine, withColor2: UIColor.black, btn1stTab: oneTimeTopUpBTN, with1stBtnTabColor: .bgColors , btn2ndTab: recurringBTN, with2ndBtnTabColor: UIColor.darkGray, setstatus: "Top-up", toLabel: lblTitleName)
        self.consumberTopUpArray =      self.consumberTopUpTotalArray.filter{ ($0["type"] as! String == "NRC") }
            
        self.userResult = self.realm!.objects(TopupPlanData.self).filter("type == 'NRC'")
        self.topUpableView.reloadData()
         labelHeightConstain.constant = 90
          bottomLabel.text = "One time charges (not prorated) will be applicable & add-on data will be available till next Quota Reset date."
    }
    
    @IBAction func recurringclick(_ sender: Any) {
        onetimetopUpSelect = false
        if(isTopUpAdded == false){
            resetView()
        }
        
        isTopUpAdded = false
        
          setBelowlineColor(below1stTabLine: oneTimeTopUpLine, withColor: UIColor.black , below2ndTabLine: recurringLine, withColor2: .bgColors, btn1stTab: oneTimeTopUpBTN, with1stBtnTabColor:UIColor.darkGray , btn2ndTab: recurringBTN, with2ndBtnTabColor: .bgColors , setstatus: "Top-up", toLabel: lblTitleName)
        self.consumberTopUpArray =      self.consumberTopUpTotalArray.filter{ ($0["type"] as! String == "RC") }
            
        self.userResult = self.realm!.objects(TopupPlanData.self).filter("type == 'RC'")
        self.topUpableView.reloadData()
         labelHeightConstain.constant = 90
        
        bottomLabel.text = "Prorated Top-up charges will be applicable from today, till the next invoice date based on your remaining plan duration."
    }
    
    
    @IBAction func backToHome(_ sender: Any)
    {
        Switcher.updateRootVC()
        
    }
    //
    
    
}
