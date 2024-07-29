//
//  ViewController.swift
//  SpectraNet
//
//  Created by Bhoopendra on 7/16/19.
//  Copyright © 2019 Bhoopendra. All rights reserved.
//
// scrroll view container == 1094 if  tblView.isHidden = false this time we hiding the table view tblView.isHidden = true

import UIKit
import ObjectMapper
import RealmSwift
import Firebase
import Crashlytics
import Fabric

class HomeViewController: UIViewController,UITableViewDelegate,UITableViewDataSource
{
    var realm: Realm? = nil
    var userResult:Results<UserCurrentData>? = nil
    var userdata:Results<UserData>? = nil
    var notificationData: NotificationModel?

    
    var checkStatus = String()
    var dataFillChildView = UIView()
    @IBOutlet weak var lblSRNmbr: UILabel!
    @IBOutlet weak var lblTotalGB: UILabel!
    @IBOutlet weak var lblUsageGB: UILabel!
    @IBOutlet weak var lblDueDate: UILabel!
    @IBOutlet weak var lblTcketDate: UILabel!
    @IBOutlet weak var outStandingAmt: UILabel!
    @IBOutlet weak var lblEstimateTime: UILabel!
    @IBOutlet weak var lblDueDateStatus: UILabel!
    @IBOutlet weak var duePayAmtBTN: UIButton!
    @IBOutlet weak var nameAndCandIdLabel: UILabel!
    @IBOutlet var nameAndCandIdImg: UIImageView!
    @IBOutlet weak var availDataview: UIView!
    var canID = String()
    var packageID = String()

    @IBOutlet var tblView: UITableView!
    @IBOutlet var statusMsg: UIImageView!
    
    @IBOutlet var imageScrollCollectionView: UICollectionView!
    var timer = Timer()
    var counter = 0
    @IBOutlet var lblDayStatus: UILabel!
    @IBOutlet var pageView: UIPageControl!
    var ivrMessageArr = [String]()
    @IBOutlet var fillColorView: UIView!
    @IBOutlet var limitedDataImg: UIImageView!
    @IBOutlet var lblOutOfTitle: UILabel!
    @IBOutlet var lblDataLft: UILabel!
    @IBOutlet var lblUnlimitedData: UILabel!
    @IBOutlet var scrollView: UIScrollView!
    @IBOutlet var paNowBTNView: UIView!
    @IBOutlet var payInAdvanceBTNView: UIView!
    @IBOutlet var payNowBTNLabel: UILabel!
    @IBOutlet var viewAllView: UIView!
    @IBOutlet var srParentView: UIView!
    var homeAccountArray = NSArray()
    @IBOutlet var notificationBTN: UIButton!
    @IBOutlet var lblUnlmitedHurrey: UILabel!
    @IBOutlet var completeDataView: UIView!

    @IBOutlet weak var ivrHeightConstant: NSLayoutConstraint!
    @IBOutlet weak var pageControlHeightConstant: NSLayoutConstraint!
    @IBOutlet weak var lblUnreadNotification: UILabel!
    
    @IBOutlet weak var payInAdvanceWidthConstant: NSLayoutConstraint!
    
    //MARK: View controller life cycle
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        realm = try? Realm()
        
          if let isloginFrom = HelpingClass.userDefaultForKey(key: UserDefaultKeys.isLoginFrom) as? String{
            
            print_debug(object: "user")
            
          }else{
            HelpingClass.saveToUserDefault(value: false as AnyObject, key: "status")
                   Switcher.updateRootVC()
            
        }
        lblUnreadNotification.layer.cornerRadius = 5.0
        lblUnreadNotification.clipsToBounds = true
        lblUnreadNotification.backgroundColor = UIColor.bgColors
    }
 

    override func viewWillAppear(_ animated: Bool)
    {
        super.viewWillAppear(animated)
        
        
        
       // greeting message
        lblDayStatus.text = getGreetingTime()
        // load home page
        loadDataHomePage()
        lblUnlmitedHurrey.isHidden = true
        completeDataView.isHidden = true
        
        self.getLinkAccountByCanID()
        if(AppDelegate.sharedInstance.navigateFrom == ""){
            menuHomeFirbaseAnalysics()
        }
        AppDelegate.sharedInstance.navigateFrom = ""
       
    }
    
    func menuHomeFirbaseAnalysics(){
    
        let dictAnalysics = [AnanlysicParameters.canID:canID,
                             AnanlysicParameters.Category:AnalyticsEventsCategory.dashboard_menu,
                             AnanlysicParameters.Action:AnalyticsEventsActions.menu_home
                             ,AnanlysicParameters.EventType:AnanlysicParameters.ClickEvent]

       HelpingClass.sharedInstance.addFirebaseAnalysis(eventName: AnalyticsEventsName.menu_click_home, parameters: dictAnalysics as? [String:AnyObject] ?? [String:AnyObject]() )
    }
    
    func getLinkAccountByCanID()
    {
        var dict = ["Action":ActionKeys.getLinkAcount, "Authkey":UserAuthKEY.authKEY]
        
        
        var canIds = [String]();
        self.userdata =  self.realm!.objects(UserData.self)
        
        if let userValue = self.userdata  {
            
            
        for user  in userValue  {
            
            canIds.append(user.CANId)
        }
        }
        if let isloginFrom = HelpingClass.userDefaultForKey(key: UserDefaultKeys.isLoginFrom) as? String{
            
            if isloginFrom == UserDefaultKeys.canID{
               
                
               
                if let userData = userdata?[0]
                {
                    dict["baseCanID"] = userData.CANId
                    
                }
                
            }else{
                
                 if let mobileNumber = HelpingClass.userDefaultForKey(key: UserDefaultKeys.loginPhoneNumber) as? String{
                 dict["mobileNo"] = mobileNumber
                }
            }
        }
        print_debug(object: dict)
        CANetworkManager.sharedInstance.requestApiWithoutHUD(serviceName: ServiceMethods.serviceBaseURL, method: kHTTPMethod.POST, postData: dict as Dictionary<String, AnyObject>) { [weak self] (response, error) in
            
            print_debug(object: response)
            if response != nil
            {
                
                
                if let  responseValue = response?["status"] as? String{
                    
                    
                    if responseValue != Server.api_status
                    {
                        if let  statusMessage = response?[ "message"] as? String {
                          //  self?.showAlertC(message: statusMessage)
                            print_debug(object: "linkCanid =\(canIds)")
                            
                            self?.pushNotificationTokenUpdate(canIds: canIds)
                            
                        }
                        return
                    }
                    
                }
                
                if let  responseValue = response?["response"] as? [[String:AnyObject]]{
                    
                    for user  in responseValue  {
                        
                        if let linkCanid = user["link_canid"] as? String{
                            
                            canIds.append(linkCanid)
                        }
                        
                        
                       
                        
                    }
                    print_debug(object: "linkCanid =\(canIds)")
                    
                    self?.pushNotificationTokenUpdate(canIds: canIds)
                    
                    
                }
            }else{
                
                print_debug(object: "linkCanid =\(canIds)")
                
                self?.pushNotificationTokenUpdate(canIds: canIds)
            }
        }
    }
    
    func pushNotificationTokenUpdate(canIds:[String]){
        
        var canIdValue = [String:[String]]();
        var fcmToken = [String]();
        var deviceType = [String]();
        for canId in canIds{
            let token = Messaging.messaging().fcmToken
        
            
            print_debug(object: canId)
            fcmToken.append(token ?? "")
            deviceType.append("IOS")
        }
        
        canIdValue["canId"] = canIds
        canIdValue["deviceToken"] = fcmToken
        canIdValue["deviceType"] = deviceType
        
        
        let dict = ["Action":ActionKeys.deviceSignIn, "Authkey":UserAuthKEY.authKEY,"deviceData":canIdValue] as [String : Any]
        
        HelpingClass.sharedInstance.deviceData = canIdValue
        self.getAllNotifications()
        CANetworkManager.sharedInstance.requestApiWithoutHUD(serviceName: ServiceMethods.serviceBaseUatValue, method: kHTTPMethod.POST, postData: dict as Dictionary<String, AnyObject>) { [weak self] (response, error) in
            
            print_debug(object: response)
            if response != nil
            {
                
                
                if let  responseValue = response?["status"] as? String{
                    
                    
                    if responseValue != Server.api_status
                    {
                        if let  statusMessage = response?[ "message"] as? String {
                          //  self?.showAlertC(message: statusMessage)
                            
                        }
                        return
                    }
                    
                }
                
                if let  responseValue = response?["response"] as? [[String:AnyObject]]{
                    
                    
                } }
            
        }
        
        
        
        
    }
    
    override func viewWillDisappear(_ animated: Bool)
    {
        super.viewWillDisappear(true)
        timer.invalidate()
    }
    
    
    func getAllNotifications(isForRefresh: Bool? = false) {
        
        DispatchQueue.global(qos: .background).async {
            
            let dict = HelpingClass.sharedInstance.deviceData
            
            if let canIdArray = dict["canId"] as? [String]{
            
                let stringRepresentation = canIdArray.joined(separator: ",")
            let apiURL = ServiceMethods.notificationServiceBaseUrl + "notification/getallnotifications?can_id=\(stringRepresentation)&skip=0&limit=20"
           print_debug(object: "apiURL =" + apiURL)
           CANetworkManager.sharedInstance.requestApiWithoutHUD(serviceName: apiURL, method: kHTTPMethod.GET, postData: [:] as Dictionary<String, AnyObject>) { (response, error) in
               if response != nil {
                   if let responseData = response as? [String: Any] {
                       self.notificationData = NotificationModel(dictionary: responseData as NSDictionary)
                var unreadNotification = false
                    if let data = self.notificationData?.data {
                        for day in data {
                            if let noti = day.notification_info {
                                for notification in noti {
                                    if !(notification.is_read ?? false) {
                                        unreadNotification = true
                                        break
                                    }
                                }
                            }
                            if unreadNotification {
                                break
                            }
                        }
                        if unreadNotification {
                            DispatchQueue.main.async {
                                self.lblUnreadNotification.isHidden = false
                            }
                        } else {
                            DispatchQueue.main.async {
                                self.lblUnreadNotification.isHidden = true
                            }
                        }
                    }
                }
               }
           }
        }
        }
       }
       
    
    
    func loadDataHomePage()
    {
        realm = try? Realm()
        userResult = self.realm!.objects(UserCurrentData.self)
        
        if(userResult?.count ?? 0 > 0){
        if let userActData = userResult?[0]
        {
            canID = userActData.CANId
            packageID = userActData.Product
        }
        if ConnectionCheck.isConnectedToNetwork() == true
        {
            serviceTypeGetAccountDataAPI()
        }
        else
        {
           // noInternetCheckScreenWithMessage(errorMessage:"")
        }
        }

        scrollView.isHidden = true
        notificationBTN.isHidden = false    // TO REMOVE - hide notif button
        setCornerRadiusView(radius: Float(paNowBTNView.frame.height/2), color: UIColor.cornerBGFullOpack, view: paNowBTNView)
        setCornerRadiusView(radius: Float(viewAllView.frame.height/2), color: UIColor.cornerBGFullOpack, view: viewAllView)
    }
  
    //MARK: service GetAccountData
    func serviceTypeGetAccountDataAPI()
    {
        
//          var canIDValue = ""
//          var parentCanIDValue = ""
        let dict = ["Action":ActionKeys.userAccountData, "Authkey":UserAuthKEY.authKEY, "canID":canID]

        CANetworkManager.sharedInstance.requestApi(serviceName: ServiceMethods.serviceBaseURL, method: kHTTPMethod.POST, postData: dict as Dictionary<String, AnyObject>) { (response, error) in
            
            print_debug(object: response)
            
            if response != nil
            {
                var dict1 = NSDictionary()
                if let dict = response as? NSDictionary
                {
                    dict1 = dict
                }

                guard let responseArr = dict1.value(forKey: "response") as? NSArray else
                {
                    return
                }
                 self.homeAccountArray = responseArr
                try! self.realm!.write
                {
                    if let users = self.realm?.objects(UserCurrentData.self) {
                        
//                        if let userDataValue   = users[0] as? UserCurrentData
//                        {
//                           canIDValue = userDataValue.CANId
//                            parentCanIDValue = userDataValue.ParentCANId
//
//                        }
                    
                        self.realm!.delete(users)
                    }
                }
                
                for entry in self.homeAccountArray {
                    
                    if let currentUser = Mapper<UserCurrentData>().map(JSONObject: entry) {
                        
//                        if (canIDValue != "" && parentCanIDValue != ""){
//                            currentUser.CANId = canIDValue
//                        currentUser.ParentCANId = parentCanIDValue
//                        }
                          print_debug(object: "currentUser \(currentUser)")
                        try! self.realm!.write
                        {
                            self.realm!.add(currentUser)
                        }
                    }
                }
               // DatabaseHandler.instance().getAndSaveUserHomeAccountData(dict:responseArr)

                guard let dict = response as? NSDictionary else
                {
                    return
                }
                self.setDataFromAccount(dicto: dict)
            }
        }
    }
    
    func setDataFromAccount(dicto: NSDictionary)
    {
        userResult = self.realm?.objects(UserCurrentData.self)
        
        self.checkStatus = ""
        if let status = dicto.value(forKey: "status") as? String
        {
            self.checkStatus = status.lowercased()
        }
        
        if self.checkStatus == Server.api_status
        {
            scrollView.isHidden = false

            var aStr = String()
            var prebarred = Bool()
            
            var getDueDate = String()
               if let userActData = userResult?[0]
               {
                
                if userActData.CancellationFlag == true
                {
                    self.navigateScreenToStoryboardMain(identifier: ViewIdentifier.cancelledAccountIdentifier, controller: AccountCancelledViewController.self)
                }
                else if userActData.actInProgressFlag == true
                {
                    
                    
                    if   let vc = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: ViewIdentifier.trackOrderIdentifier) as? TrackOrderViewController{
                                                    
                        if let canID = userActData.CANId as? String{
                        vc.canID = canID
                        self.navigationController?.pushViewController(vc, animated: false)
                                                        
                            }
                                            }
                                            
                }
                else
                {
                    aStr = userActData.OutStandingAmount
                    AppDelegate.sharedInstance.segmentType = userActData.Segment.lowercased()
                    print_debug(object: AppDelegate.sharedInstance.segmentType)
                if userActData.SRNumber == ""
                {
                    srParentView.isHidden = true
                    if UIScreen.main.sizeType == .iPhone5
                    {
                        
                    }
                    else
                    {
                        scrollView.isScrollEnabled = true
                    }
                }
                else
                {
                    srParentView.isHidden = false
                    self.lblSRNmbr.text = userActData.SRNumber
                   
                       // createdOn = setInvoiceListDateFormate(previousDateStr: createdOn, withPreviousDateFormte: DateFormats.orderDateFormat, replaeWithFormate: DateFormats.orderDateFormatResult)
                    self.lblTcketDate.text = setInvoiceListDateFormate(previousDateStr: userActData.SRCreatedOn, withPreviousDateFormte: DateFormats.orderDateTime24Frmate, replaeWithFormate: DateFormats.orderDateFormatResult)
                    if(userActData.SRETR != ""){
                    self.lblEstimateTime.text = setInvoiceListDateFormate(previousDateStr: userActData.SRETR, withPreviousDateFormte: DateFormats.orderDateTime24Frmate, replaeWithFormate: DateFormats.orderDateTimeFormatResult)
                    }else{
                        self.lblEstimateTime.text = ""
                        
                    }

                    var str = String()
                    str = userActData.SRCaseStatus
                    if str.lowercased() == Server.srCase_status
                    {
                        statusMsg.image = UIImage(named: "status0")
                    }
                    else
                    {
                        statusMsg.image = UIImage(named: "status1")
                    }
                }
                    
                    self.nameAndCandIdLabel.text = userActData.AccountName + "(" + userActData.CANId + ")"
                getDueDate = userActData.DueDate
                print_debug(object: Realm.Configuration.defaultConfiguration.fileURL!)
                print_debug(object: userActData.planDataVolume.lowercased())
                if userActData.planDataVolume.lowercased() == Server.plandata_volume
                {
                    // use for unlimited data
                    labelShowStatus(withBool: true, setImage: "unlimitedData", setTextLabel: "", andOther: false)
                    lblUnlmitedHurrey.isHidden = false
                }
                else
                {
                    // use for data availbale
                    labelShowStatus(withBool: false, setImage: "dataImg", setTextLabel: "Data Left", andOther: true)
                    lblUnlmitedHurrey.isHidden = true
                    var replaceGB = String()
                    replaceGB = replaceStringWithStr(yourString: userActData.planDataVolume, replaceStr: " GB", withSyring: "")
                    var replaceTotalGB = Float()
                    replaceTotalGB = (replaceGB as NSString).floatValue

                    if userActData.DataConsumption == 0.0 || replaceTotalGB == 0
                    {
                        if userActData.planDataVolume == ""
                        {
                           lblTotalGB.text = "0"
                        }
                        else
                        {
                            lblTotalGB.text = String(format: "%@", userActData.planDataVolume)
                        }
                        
                        if userActData.DataConsumption == 0.0
                        {
                            makeViewFrameingAccordingParants(withOutOfdata: replaceTotalGB, usageData: 0)
                            lblUsageGB.text = String(format: "%@ GB", calculateUsageData(usageData: String(format: "%.2f GB",userActData.DataConsumption), TotalData: String(format: "%@", userActData.planDataVolume)));
                        }
                    }
                    else
                    {
                        lblTotalGB.text = String(format: "%@", userActData.planDataVolume)
                        
                        
                        lblUsageGB.text = String(format: "%@ GB", calculateUsageData(usageData: String(format: "%.2f GB",userActData.DataConsumption), TotalData: String(format: "%@", userActData.planDataVolume)));
                        // use for fuel up or down (petrol pump image)
                        makeViewFrameingAccordingParants(withOutOfdata: replaceTotalGB, usageData: Float(userActData.DataConsumption))
                    }
         
                    //TODO Topup Functionality Uncomment below code next milestone
              
                    var getPercentUseData = String()
                    getPercentUseData = calculateUsageDataInPercentage(usageData: String(format: "%.2f GB",userActData.DataConsumption), TotalData: String(format: "%@", userActData.planDataVolume))
                    let finalValue = (getPercentUseData as NSString).floatValue
                    if finalValue >= 80
                    {
                       completeDataView.isHidden = false
                    }
                     completeDataView.isHidden = finalValue >= 80 ? false : true
                    
                   // completeDataView.isHidden = false
                    
                }
                prebarred = userActData.PreBarredFlag
            if aStr == "0"
            {
                // use for prebarredflag
                payInAdvanceBTNView.isHidden = false
                self.setdataIntoDueDateLBL(setTextDueDates: "", withBool: true, setDueDatesStatus: "", prebarredFlag: prebarred)
                self.outStandingAmt.text = "₹ 0"
            }
            else
            {
                // use for prebarredflag
                print_debug(object: "getDueDate \(getDueDate)")
                self.setdataIntoDueDateLBL(setTextDueDates: self.setChangeDateFormate(previousDateStr: getDueDate), withBool: false, setDueDatesStatus: "Due on", prebarredFlag: prebarred)
                self.outStandingAmt.text = convertStringtoFloatViceversa(amount: aStr)
                payInAdvanceBTNView.isHidden = true
            }
            
            tblView.isHidden = true
            let ivrMessages = userActData.ivrNotification
            
//            let  ivrMessage = (homeAccountArray[0] as AnyObject).value(forKey: "ivrNotification")
//            if checkArray(item: ivrMessage as AnyObject)==true
//            {
//                ivrMessageArr = ivrMessage as! [AnyObject]
//            }
            ivrMessageArr = Array(ivrMessages)
            pageView.numberOfPages = ivrMessageArr.count
            pageView.currentPage = 0
          
            if ivrMessageArr.count>0
            {
                imageScrollCollectionView.isHidden = false
                imageScrollCollectionView.delegate = self
                imageScrollCollectionView.dataSource = self
                pageView.isHidden = false
            }
            else
            {
                ivrHeightConstant.constant = 0
                pageControlHeightConstant.constant = 0
                imageScrollCollectionView.isHidden = true
                pageView.isHidden = true
            }
            
            if ivrMessageArr.count>0
            {
                DispatchQueue.main.async
                    {
                    self.timer = Timer.scheduledTimer(timeInterval: 2, target: self,   selector: (#selector(self.changeImage)), userInfo: nil, repeats: true)
                    }
              }
             }
          }
        }
        else
        {
            guard let errorMsg = dicto.value(forKey: "message") as? String else
            {
                return
            }
            self.showAlertC(message: errorMsg)
        }
    }

    func checkArray(item : AnyObject) -> Bool {
        return item is Array<AnyObject>
    }
    
    @objc func changeImage()
    {
        if counter<ivrMessageArr.count {
            let index = IndexPath.init(item: counter, section: 0)
            self.imageScrollCollectionView.scrollToItem(at: index, at: .centeredHorizontally, animated: true)
            pageView.currentPage = counter
            counter += 1
        }
        else
        {
            counter = 0
            let index = IndexPath.init(item: counter, section: 0)
            self.imageScrollCollectionView.scrollToItem(at: index, at: .centeredHorizontally, animated: false)
            pageView.currentPage = counter
            counter = 1
        }
    }
    
    //MARK: Table View delegate
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        var cell : HomeTableViewCell? = (tableView.dequeueReusableCell(withIdentifier: TableViewCellName.homeTableViewCell) as! HomeTableViewCell)
        
        if cell == nil {
            cell = HomeTableViewCell(style: UITableViewCell.CellStyle.default, reuseIdentifier: TableViewCellName.homeTableViewCell)
        }
        return cell!
    }
    
    //MARK: Button Actions
    @IBAction func viewAllBTN(_ sender: Any)
    {
        viewAllSRFirbaseAnalysics()
        AppDelegate.sharedInstance.navigateFrom=TabViewScreenName.sr
        navigateScreen(identifier: ViewIdentifier.customTabIdentifier, controller: CustomTabViewController.self)
    }
    
    func viewAllDetailFirbaseAnalysics(){
    
        let dictAnalysics = [AnanlysicParameters.canID:canID,
                             AnanlysicParameters.Category:AnalyticsEventsCategory.dashboard,
                             AnanlysicParameters.Action:AnalyticsEventsActions.view_details,
                             AnanlysicParameters.EventType:AnanlysicParameters.ClickEvent]
        
        //,AnanlysicParameters.EventDescription:AnanlysicEventDescprion.loginwithUserNamePassword
    
       HelpingClass.sharedInstance.addFirebaseAnalysis(eventName: AnalyticsEventsName.view_details, parameters: dictAnalysics as? [String:AnyObject] ?? [String:AnyObject]() )
    }
    func viewAllSRFirbaseAnalysics(){
        let dictAnalysics = [AnanlysicParameters.canID:canID,
                             AnanlysicParameters.Category:AnalyticsEventsCategory.dashboard
                             ,AnanlysicParameters.Action:AnalyticsEventsActions.view_all_service_request_click
                             ,AnanlysicParameters.EventType:AnanlysicParameters.ClickEvent]
        
        //,AnanlysicParameters.EventDescription:AnanlysicEventDescprion.loginwithUserNamePassword
    
       HelpingClass.sharedInstance.addFirebaseAnalysis(eventName: AnalyticsEventsName.view_all_service_requests, parameters: dictAnalysics as? [String:AnyObject] ?? [String:AnyObject]() )
    
    }
    
    @IBAction func payDueAmountBTN(_ sender: Any)
    {
        payNowFirbaseAnalysics(outstandingAmt: outStandingAmt.text ?? "0.00")
        goPayNowScreen(canID: canID, outstandingAmt: outStandingAmt.text ?? "0.00", tdsAmt: "", tdsPrcnt: "",ifFromTopup: "")
    }
    func payNowFirbaseAnalysics(outstandingAmt:String){
        
            let dictAnalysics = [AnanlysicParameters.canID:canID,
                                 AnanlysicParameters.Category:AnalyticsEventsCategory.home
                                 ,AnanlysicParameters.Action:AnalyticsEventsActions.payNowClick
                                 ,AnanlysicParameters.EventType:AnanlysicParameters.ClickEvent,"Amount":outstandingAmt]
            
            //,AnanlysicParameters.EventDescription:AnanlysicEventDescprion.loginwithUserNamePassword
        
           HelpingClass.sharedInstance.addFirebaseAnalysis(eventName: AnalyticsEventsName.pay_Now, parameters: dictAnalysics as? [String:AnyObject] ?? [String:AnyObject]() )
    }
    
    @IBAction func payDueAmountOnAdvanceBTN(_ sender: Any)
    {
        payDueAmountOnAdvanceFirbaseAnalysics()
        goPayNowScreen(canID: canID, outstandingAmt: "0.00", tdsAmt: "", tdsPrcnt: "",ifFromTopup: "")
    }
    func payDueAmountOnAdvanceFirbaseAnalysics(){
        
            let dictAnalysics = [AnanlysicParameters.canID:canID,
                                 AnanlysicParameters.Category:AnalyticsEventsCategory.home
                                 ,AnanlysicParameters.Action:AnalyticsEventsActions.payInAdvanceClick
                                 ,AnanlysicParameters.EventType:AnanlysicParameters.ClickEvent]
            
            //,AnanlysicParameters.EventDescription:AnanlysicEventDescprion.loginwithUserNamePassword
        
           HelpingClass.sharedInstance.addFirebaseAnalysis(eventName: AnalyticsEventsName.pay_advance, parameters: dictAnalysics as? [String:AnyObject] ?? [String:AnyObject]() )
    }
    
    @IBAction func viewDetailsBTN(_ sender: Any)
    {
        viewAllDetailFirbaseAnalysics()
        
        if AppDelegate.sharedInstance.segmentType==segment.userB2C
        {
            navigateScreen(identifier: ViewIdentifier.dataUsageIdentifier, controller: DataUsageViewController.self)
        }
        else
        {
           navigateScreen(identifier: ViewIdentifier.mrtgIdentifier, controller: MRTGViewController.self)
        }
    }
  
    @IBAction func notificationBTN(_ sender: Any)
    {
  
        notificationClickedFirbaseAnalysics()
        guard let vc = UIStoryboard.init(name: "Storyboard", bundle: nil).instantiateViewController(withIdentifier: ViewIdentifier.NotificationIdentifier) as? NotificationViewController else {
            return
        }
        vc.notificationData = self.notificationData
        vc.canID = self.canID
        self.navigationController?.pushViewController(vc, animated: false)
        
    }
    
    func notificationClickedFirbaseAnalysics(){
        
            let dictAnalysics = [AnanlysicParameters.canID:canID,
                                 AnanlysicParameters.Category:AnalyticsEventsCategory.home
                                 ,AnanlysicParameters.Action:AnalyticsEventsActions.notificationClicked
                                 ,AnanlysicParameters.EventType:AnanlysicParameters.ClickEvent]
            
            //,AnanlysicParameters.EventDescription:AnanlysicEventDescprion.loginwithUserNamePassword
        
           HelpingClass.sharedInstance.addFirebaseAnalysis(eventName: AnalyticsEventsName.notification_Open, parameters: dictAnalysics as? [String:AnyObject] ?? [String:AnyObject]() )
    }
    @IBAction func searchBTNClick(_ sender: Any)
    {
        navigateScreenToStoryboardMain(identifier: ViewIdentifier.RecentSearchViewController, controller: RecentSearchViewController.self)
        
        
    }
    
    @IBAction func upgradeTopup(_ sender: Any)
      {
        topupScreen(WithCanID: canID, pckgID: packageID)
    }
    @IBAction func accountChangeView(_ sender: Any)
    {
        let vc = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: ViewIdentifier.AccountIdentifier) as? AccountViewController
        //vc?.fromScreen = FromScreen.menuScreen
        self.navigationController?.pushViewController(vc!, animated: false)
    }
}

//MARK: CollectionView Delegate Method
extension HomeViewController: UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout
{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return ivrMessageArr.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: CustomCollectionViewCell = imageScrollCollectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! CustomCollectionViewCell
        
        cell.lblIvrMsg.text = ivrMessageArr[indexPath.row]

        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width, height: 100)
    }
    
    // calculate left data
       func calculateUsageDataInPercentage(usageData: String, TotalData: String) -> String
       {
            let usage: Float = (usageData as NSString).floatValue
            let Total: Float = (TotalData as NSString).floatValue
            var calculatedValue = Float()
            calculatedValue = Float(Total-usage)
            var val = Float()
            val = calculatedValue/Float(Total)
            let s = NSString(format: "%.2f", val*100)
            let netVal: Float = (s as NSString).floatValue

            let usageTotaldatainpercent = 100 - netVal
            let finalValue = NSString(format: "%.2f", usageTotaldatainpercent)
           return finalValue as String
       }
    
    // calculate left data
    func calculateUsageData(usageData: String, TotalData: String) -> String
    {
        let usage = CGFloat((usageData as NSString).floatValue)
        let Total = CGFloat((TotalData as NSString).floatValue)
        var calculatedValue = Float()
        calculatedValue = Float(Total-usage)
        let s = NSString(format: "%.2f", calculatedValue)
        return s as String
    }
    
    // use for fuel up or down (petrol pump image)
    func makeViewFrameingAccordingParants(withOutOfdata: Float, usageData: Float)
    {
        let val = setViewFraming(outOfData: withOutOfdata, usageData: usageData, viewHeight: Float(fillColorView.frame.height), viewYorigin: Float(fillColorView.frame.origin.y-34))
        if withOutOfdata<usageData
        {
            dataFillChildView.backgroundColor = UIColor.bgDataFillColor
            fillColorView.backgroundColor = UIColor.bgDataFillColor
            fillColorView .addSubview(dataFillChildView)
            lblUsageGB.text = "0 GB"

        }
        else
        {
            dataFillChildView.frame = CGRect(x: fillColorView.frame.origin.x-15, y: fillColorView.frame.origin.y-34.5, width: fillColorView.frame.width, height: CGFloat(val))
            
            dataFillChildView.backgroundColor = UIColor.bgDataFillColor
            fillColorView.backgroundColor = UIColor.white
            //fillColorView .addSubview(dataFillChildView)
        }
    }
    
    // user for prebarredflag
    func setdataIntoDueDateLBL(setTextDueDates: String,withBool: Bool,setDueDatesStatus: String , prebarredFlag: Bool)
    {
        if prebarredFlag==false {
            self.lblDueDate.textColor = UIColor.black
        }
        else
        {
            self.lblDueDate.textColor = UIColor.red
        }
        self.lblDueDateStatus.text = setDueDatesStatus
        if(setTextDueDates != ""){
        self.lblDueDate.text = setTextDueDates
        }else{
            self.lblDueDate.text = ""
        }
        self.duePayAmtBTN.isHidden = withBool
        paNowBTNView.isHidden = withBool
    }
    
    // use for unlimited data or data availbale
    func labelShowStatus(withBool: Bool, setImage: String, setTextLabel: String, andOther: Bool)
    {
        limitedDataImg.image = UIImage(named: setImage)
        lblDataLft.text = setTextLabel
        lblOutOfTitle.isHidden = withBool
        lblTotalGB.isHidden = withBool
        lblUsageGB.isHidden = withBool
        lblUnlimitedData.isHidden = andOther
        fillColorView.isHidden = withBool
    }
}

extension Float {
    var clean: String {
        return self.truncatingRemainder(dividingBy: 1) == 0 ? String(format: "%.0f", self) : String(self)
    }
}

extension String {
    func convertToDictionary() -> [String: Any]? {
        if let data = self.data(using: .utf8) {
            do {
                return try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
            } catch {
                debugPrint(error.localizedDescription)
            }
        }
        return nil
    }
}
