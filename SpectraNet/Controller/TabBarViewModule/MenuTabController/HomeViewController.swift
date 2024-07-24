//
//  HomeViewController.swift
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
    @IBOutlet var viewAllView: UIView!
    @IBOutlet var srParentView: UIView!
    var homeAccountArray = NSArray()
    @IBOutlet var notificationBTN: UIButton!
    @IBOutlet var lblUnlmitedHurrey: UILabel!
    @IBOutlet var completeDataView: UIView!

    @IBOutlet weak var ivrHeightConstant: NSLayoutConstraint!
    @IBOutlet weak var pageControlHeightConstant: NSLayoutConstraint!
    
    
    //MARK: View controller life cycle
    override func viewDidLoad()
    {
        super.viewDidLoad()
        realm = try? Realm()
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
    }
    
    override func viewWillDisappear(_ animated: Bool)
    {
        super.viewWillDisappear(true)
        timer.invalidate()
    }
    
    func loadDataHomePage()
    {
        realm = try? Realm()
        userResult = self.realm!.objects(UserCurrentData.self)
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

        scrollView.isHidden = true
        notificationBTN.isHidden = true    // TO REMOVE - hide notif button
        setCornerRadiusView(radius: Float(paNowBTNView.frame.height/2), color: UIColor.cornerBGFullOpack, view: paNowBTNView)
        setCornerRadiusView(radius: Float(viewAllView.frame.height/2), color: UIColor.cornerBGFullOpack, view: viewAllView)
    }
  
    //MARK: service GetAccountData
    func serviceTypeGetAccountDataAPI()
    {
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
                        self.realm!.delete(users)
                    }
                }
                
                for entry in self.homeAccountArray {
                    
                    if let currentUser = Mapper<UserCurrentData>().map(JSONObject: entry) {
                        
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
                    self.navigateScreen(identifier: ViewIdentifier.cancelledAccountIdentifier, controller: AccountCancelledViewController.self)
                }
                else if userActData.actInProgressFlag == true
                {
                    self.navigateScreen(identifier: ViewIdentifier.accountActivationIdentifier, controller: AccountActivationViewController.self)
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
                    self.lblEstimateTime.text = setInvoiceListDateFormate(previousDateStr: userActData.SRETR, withPreviousDateFormte: DateFormats.orderDateTime24Frmate, replaeWithFormate: DateFormats.orderDateFormatResult)

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
                /*
                    var getPercentUseData = String()
                    getPercentUseData = calculateUsageDataInPercentage(usageData: String(format: "%.2f GB",userActData.DataConsumption), TotalData: String(format: "%@", userActData.planDataVolume))
                    let finalValue = (getPercentUseData as NSString).floatValue
                    if finalValue >= 80
                    {
                       completeDataView.isHidden = false
                    }
                     completeDataView.isHidden = finalValue >= 80 ? false : true
                    */
                }
               
                prebarred = userActData.PreBarredFlag
            if aStr == "0"
            {
                // use for prebarredflag
                self.setdataIntoDueDateLBL(setTextDueDates: "", withBool: true, setDueDatesStatus: "", prebarredFlag: prebarred)
                self.outStandingAmt.text = "No Dues"
            }
            else
            {
                // use for prebarredflag
                self.setdataIntoDueDateLBL(setTextDueDates: self.setChangeDateFormate(previousDateStr: getDueDate), withBool: false, setDueDatesStatus: "Due on", prebarredFlag: prebarred)
                self.outStandingAmt.text = convertStringtoFloatViceversa(amount: aStr)
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
        AppDelegate.sharedInstance.navigateFrom=TabViewScreenName.sr
        navigateScreen(identifier: ViewIdentifier.customTabIdentifier, controller: CustomTabViewController.self)
    }
    
    @IBAction func payDueAmountBTN(_ sender: Any)
    {
        goPayNowScreen(canID: canID, outstandingAmt: outStandingAmt.text ?? "0.00", tdsAmt: "", tdsPrcnt: "",ifFromTopup: "")
    }
    
    @IBAction func viewDetailsBTN(_ sender: Any)
    {
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
        
            // TO_D0
//        let vc = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: ViewIdentifier.NotificationIdentifier)
//        self.navigationController?.pushViewController(vc, animated: false)
        
        // TO_D0 TO REMOVE
        let vc = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: ViewIdentifier.chatBot)
        self.navigationController?.pushViewController(vc, animated: false)
        // TO REMOVE
    }
    
    @IBAction func upgradeTopup(_ sender: Any)
      {
        topupScreen(WithCanID: canID, pckgID: packageID)
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
            fillColorView .addSubview(dataFillChildView)
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
        self.lblDueDate.text = setTextDueDates
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
                print(error.localizedDescription)
            }
        }
        return nil
    }
}
