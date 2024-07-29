//
//  DataUsageViewController.swift
//  SpectraNet
//
//  Created by Bhoopendra on 8/13/19.
//  Copyright © 2019 Bhoopendra. All rights reserved.
//

import UIKit
import Charts
import RealmSwift
import ObjectMapper

class DataUsageViewController: UIViewController,ChartViewDelegate {
    var dataUsageResult:Results<DataUsageData >? = nil
    var userCurrentData:Results<UserCurrentData>? = nil

    var realm:Realm? = nil
    @IBOutlet weak var dataUsageLBL: UILabel!
    @IBOutlet weak var lineChartView: LineChartView!
    
    @IBOutlet weak var oneMonthBTN: UIButton!
    @IBOutlet weak var sixMonthBTN: UIButton!
    @IBOutlet weak var customBTN: UIButton!
    @IBOutlet weak var firstBottomLine: UILabel!
    @IBOutlet weak var secondBottomLine: UILabel!
    @IBOutlet weak var customLine: UILabel!
    @IBOutlet weak var lblTotalDataUsage: UILabel!
    
    @IBOutlet weak var currentMonth: UILabel!
    @IBOutlet weak var lblSelectFromDate: UILabel!
    @IBOutlet weak var lblSelectToDate: UILabel!
    @IBOutlet weak var customdateView: UIView!
    @IBOutlet weak var manageLbl: UILabel!
    @IBOutlet weak var graphParantView: UIView!
    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var transparentView: UIView!
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var doneBTNview: UIView!
    @IBOutlet weak var filterBtnView: UIView!
    @IBOutlet weak var datePickerParentView: UIView!
    @IBOutlet weak var dateFilterBTN: UIButton!
    @IBOutlet weak var lblErrorMsg: UILabel!
    
    var checkPickerFrom = String()
    var fromDateString = String()
    var toDateString = String()
    var totalNumberOfDays = Int()
    var dataUsageArr = NSMutableArray()
    var dayOfMonthArr: [String] = []

    var finalTotalUsage = Double()
    var currentdate = String()
    var startDateOfCurrentMonth = String()
    var canID = String()

    var startDateVal = String()
    var dateCheck1 = String()
    var dateCheck2 = String()
    
    var y_AxisTotalVal = Double()
    var y_Axis = Double()
    var existingDate = String()
    var existingMonth = String()
    var if6monthGrapgh = Bool()
    @IBOutlet weak var lblDefaultDataYsageLine: UILabel!
    @IBOutlet weak var notDataAvailbleView: UIView!
    
    @IBOutlet weak var roundTryAgainView: UIView!
   
    //MARK: View controller life cycle
    override func viewDidLoad() {
        super.viewDidLoad()

        realm = try? Realm()
        if6monthGrapgh = false

        // label set 90* form
        dataUsageLBL.transform = CGAffineTransform(rotationAngle: -.pi / 2)
      // get user can id
        userCurrentData = self.realm!.objects(UserCurrentData.self)
        if let userData = userCurrentData?[0]
        {
            canID = userData.CANId
        }

        // three button click managed with colors
        setBackgroundColrAccordingToClic(selectedBGColor: UIColor.cornerBGFullOpack, withSelectedBTN: oneMonthBTN, withUnselectedButton: sixMonthBTN, withUnselected2BTN: customBTN, unselectedBGColor: UIColor.gray, withSelectedBool: false, unselectBool: true, withselecedLine: firstBottomLine, unselect1: customLine, unselect2: secondBottomLine)
        manageLbl.text = ""
       // view corner round
        setCornerRadiusView(radius: Float(filterBtnView.frame.height/2), color: UIColor.clear, view: filterBtnView)
        setCornerRadiusView(radius: Float(roundTryAgainView.frame.height/2), color: UIColor.clear, view: roundTryAgainView)

        customdateView.isHidden = true
        manageLbl.isHidden = true
        hideDatePickerMode(bool: true)
        // get start date of current month
        startDateOfCurrentMonth = getStartDateOfCurrentMonth()
        
        // get end date
        currentdate = getCurrentDate(withFormate: DateFormats.orderCurrentDateFormatOutPut)
        // service call
        serviceTypeUsageGraph(withStartdate: startDateOfCurrentMonth, withEndDate: currentdate, canId: canID)
        finalTotalUsage = 0.00
        
        // get current month and current year
        getCurrentMonthAndYear(setLabelName: currentMonth)
        
        // set click on date filter button image
        changeNormalButonColor()
        customBTN.isHidden = true
        customLine.isHidden = true
        self.graphParantView.isHidden = true
        notDataAvailbleView.isHidden = true
    }
  
    //MARK: Button Action
    @IBAction func backBTN(_ sender: Any) {
        self.navigationController?.popViewController(animated: false)
    }
    
    // get 1 month graph data
    @IBAction func oneMonthClick(_ sender: Any)
    {
        setBackgroundColrAccordingToClic(selectedBGColor: UIColor.cornerBGFullOpack, withSelectedBTN: oneMonthBTN, withUnselectedButton: sixMonthBTN, withUnselected2BTN: customBTN, unselectedBGColor: UIColor.gray, withSelectedBool: false, unselectBool: true, withselecedLine: firstBottomLine, unselect1: customLine, unselect2: secondBottomLine)
        manageLbl.text = ""
        customdateView.isHidden = true
        dataUsageArr = []
        serviceTypeUsageGraph(withStartdate: startDateOfCurrentMonth, withEndDate: currentdate, canId: canID)
        finalTotalUsage = 0.00
        if6monthGrapgh = false
        getCurrentMonthAndYear(setLabelName: currentMonth)
    }
    
    // get 6 month graph data
    @IBAction func sixMonthClick(_ sender: Any) {
        setBackgroundColrAccordingToClic(selectedBGColor: UIColor.cornerBGFullOpack, withSelectedBTN: sixMonthBTN, withUnselectedButton: oneMonthBTN, withUnselected2BTN: customBTN, unselectedBGColor: UIColor.gray, withSelectedBool: false, unselectBool: true, withselecedLine: secondBottomLine, unselect1: customLine, unselect2: firstBottomLine)
        manageLbl.text = ""
        dataUsageArr = []
        let previousMonth = Calendar.current.date(byAdding: .month, value: -5, to: Date())
        serviceTypeUsageGraph(withStartdate: getStartDateOf6Month(lastDate: previousMonth!), withEndDate: currentdate, canId: canID)
        finalTotalUsage = 0.00
        customdateView.isHidden = true
        if6monthGrapgh = true
        currentMonth.text = "Months"
    }
    
    // click custom button
    @IBAction func customClick(_ sender: Any) {
        setBackgroundColrAccordingToClic(selectedBGColor: UIColor.cornerBGFullOpack, withSelectedBTN: customBTN, withUnselectedButton: sixMonthBTN, withUnselected2BTN: oneMonthBTN, unselectedBGColor: UIColor.gray, withSelectedBool: false, unselectBool: true, withselecedLine: customLine, unselect1: firstBottomLine, unselect2: secondBottomLine)
        manageLbl.text = "LLLLL"
        customdateView.isHidden = false
        currentMonth.isHidden = true
    }
 
    // click on button to get start date
    @IBAction func selectFromDateBTN(_ sender: Any)
    {
        hideDatePickerMode(bool: false)
        var result1 = String()
        result1 = getCurrentDate(withFormate: DateFormats.orderCurrentDateFormatOutPut)
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = DateFormats.orderCurrentDateFormatOutPut
        guard let date = dateFormatter.date(from: result1) else {
            fatalError()
        }
        datePicker.date = date
        datePicker .reloadInputViews()
        
        selectFromDate(datePicker: datePicker, hiddenTranspView: transparentView, hiddenDoneBTNView: doneBTNview)
        checkPickerFrom = "FromDATE"
    }
    
    // click on button to get end date
    @IBAction func selectToDateBTN(_ sender: Any) {
   
        hideDatePickerMode(bool: false)
        if lblSelectFromDate.text != DefaultString.setSeletctdate
        {
            selectToDate(datePicker: datePicker, getFromStringDate: fromDateString, hiddenTranspView: transparentView, hiddenDoneBTNView: doneBTNview)
            checkPickerFrom = "ToDATE"
        }
    }
    
    // click on button to get data between two dates
    @IBAction func filterBTN(_ sender: Any) {
        
        if fromDateString=="" || toDateString==""
        {
           showAlertC(message: "Please select date.")
        }
        else
        {
            dateFilterBTN.isSelected = !dateFilterBTN.isSelected
            if(dateFilterBTN.isSelected == true)
            {
                dataUsageArr = []
                serviceTypeUsageGraph(withStartdate: fromDateString, withEndDate: toDateString, canId: canID)
                finalTotalUsage = 0.00
                let origImage = UIImage(named: "Refreshicon")
                let tintedImage = origImage?.withRenderingMode(.alwaysTemplate)
                dateFilterBTN.setImage(tintedImage, for: .selected)
                dateFilterBTN.tintColor = .white
            }
            else
            {
                lblSelectToDate.text = DefaultString.setSeletctdate
                lblSelectFromDate.text = DefaultString.setSeletctdate
                toDateString = ""
                fromDateString = ""
                changeNormalButonColor()
            }
        }
    }
    
    func changeNormalButonColor()
    {
        let origImage = UIImage(named: "filterarrow")
        let tintedImage = origImage?.withRenderingMode(.alwaysTemplate)
        dateFilterBTN.setImage(tintedImage, for: .normal)
        dateFilterBTN.tintColor = .white
    }
    
    // get custom data
    @IBAction func custumdate(_ sender: Any)
    {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = DateFormats.orderCurrentDateFormatOutPut
        
        let dateFormatter1 = DateFormatter()
        dateFormatter1.dateFormat = DateFormats.orderYearMonth
        
        if checkPickerFrom == "FromDATE"
        {
            if toDateString == ""
            {
                fromDateString = dateFormatter.string(from: datePicker.date)
                lblSelectFromDate.text = dateFormatter1.string(from: datePicker.date)
            }
            else
            {
                totalNumberOfDays = 365
                var dayCount = Int()
                dayCount = daysBetweenDates(startDate: dateFormatter.string(from: datePicker.date) as String, endDate: toDateString as String)
                if dayCount>totalNumberOfDays
                {
                    showAlertC(message: ErrorMessages.selectOneYear)
                }
                    
                else if dayCount==totalNumberOfDays
                {
                    fromDateString = dateFormatter.string(from: datePicker.date)
                    lblSelectFromDate.text = dateFormatter1.string(from: datePicker.date)
                }
                else if 0>dayCount
                {
                    showAlertC(message: ErrorMessages.endYearValidation)
                }
                else
                {
                    fromDateString = dateFormatter.string(from: datePicker.date)
                    lblSelectFromDate.text = dateFormatter1.string(from: datePicker.date)
                }
            }
        }
        else
        {
            toDateString = dateFormatter.string(from: datePicker.date)
            lblSelectToDate.text = dateFormatter1.string(from: datePicker.date)
        }
    }
    
    @IBAction func doneDatePickerBTN(_ sender: Any) {
      
        hideDatePickerMode(bool: true)
    }
    
    func hideDatePickerMode(bool: Bool)  {
        transparentView.isHidden = bool
        datePickerParentView.isHidden = bool
    }
    
    //MARK: ServiceDataUsage
    func serviceTypeUsageGraph(withStartdate: String, withEndDate: String, canId: String)
    {
        let dict = ["Action":ActionKeys.getSessionHistory, "Authkey":UserAuthKEY.authKEY, "canID":canId, "fromDate":withStartdate, "toDate":withEndDate]

        CANetworkManager.sharedInstance.requestApi(serviceName: ServiceMethods.serviceBaseURL, method: kHTTPMethod.POST, postData: dict as Dictionary<String, AnyObject>) { (response, error) in
            
            print_debug(object: response)
            if response != nil
            {
                var dataResponse = NSDictionary()
                var checkStatus = String()
                var arr = NSArray()

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
                    self.graphParantView.isHidden = false

                    guard let dataArr = dataResponse.value(forKey: "response") as? NSArray else {
                           self.graphParantView.isHidden = true
                           self.notDataAvailbleView.isHidden = false
                           self.lblErrorMsg.text = dataResponse.value(forKey: "message") as? String
                           return
                       }
                    // TO REMOVE
//                    let first = dataArr.first
//                    var rev = dataArr.reversed()
//                    dataArr.
//                    dataArr = rev.reversed()
                    // TO REMOVE
                    
                    arr = dataArr
                    try! self.realm!.write
                    {
                        if let users = self.realm?.objects(DataUsageData.self) {
                            self.realm!.delete(users)
                        }
                    }
                    for entry in arr {
                        if let currentUser = Mapper<DataUsageData>().map(JSONObject: entry)
                        {
                            try! self.realm!.write {
                                self.realm!.add(currentUser)
                            }
                        }
                    }
                    
     //               DatabaseHandler.instance().getAndSaveDataUsageData(dict: dataResponse.value(forKey: "response") as? NSArray)
                    self.dataUsageResult = self.realm!.objects(DataUsageData.self)
                    self.dayOfMonthArr = [""]
                    
                    for i in 0 ..< self.dataUsageResult!.count
                    {
                        self.startDateVal = self.dataUsageResult?[i].startDt ?? ""
                        if (self.if6monthGrapgh==true)
                        {
                            self.get6MonthGraphData(startDate: self.startDateVal, DataUgaseString: self.dataUsageResult?[i].total ?? "")
                        }
                        else
                        {
                            print_debug(object: self.startDateVal)
                            self.getCurrentMonthDataOnGraph(startDate: self.startDateVal, DataUgaseString: self.dataUsageResult?[i].total ?? "")
                        }
                    }
                    let uniqueStrings = self.uniqueElementsFrom(array:self.dayOfMonthArr)
                    let reversedNames : [String] = Array(uniqueStrings.reversed())
                    
                    guard let reverseArray = NSMutableArray(array: self.dataUsageArr.reverseObjectEnumerator().allObjects).mutableCopy() as? NSMutableArray else
                    {
                        return
                    }
                  //  let usageArray1: NSMutableArray =  NSMutableArray(array: self.dataUsageArr.reverseObjectEnumerator().allObjects).mutableCopy() as! NSMutableArray
                    let usageArray1: NSMutableArray =  reverseArray
                    print_debug(object: usageArray1)
                    if (self.if6monthGrapgh==true)
                    {
                        self.getLast6MonthName()
                        self.dayOfMonthArr.removeFirst()
                        
                        guard let dataList = self.dataUsageArr as? [Double] else
                        {
                            return
                        }
                        
                        //self.setChart(self.lineChartView, numberOfDayOrMonth: self.dayOfMonthArr , values: self.dataUsageArr as! [Double])
                        self.setChart(self.lineChartView, numberOfDayOrMonth: self.dayOfMonthArr , values: dataList)

                    }
                    else
                    {
                        guard let dataList = usageArray1 as? [Double] else
                        {
                            return
                        }
                      //  self.setChart(self.lineChartView, numberOfDayOrMonth: reversedNames , values: usageArray1 as! [Double])
                        self.setChart(self.lineChartView, numberOfDayOrMonth: reversedNames , values: dataList)
                    }

                    self.lblTotalDataUsage.text = String(format: "%.2f GB", self.finalTotalUsage)
                }
                else
                {
                    guard let errorMsg = dataResponse.value(forKey: "message") as? String else
                    {
                        return
                    }
                    self.graphParantView.isHidden = true
                    self.notDataAvailbleView.isHidden = false
                    self.lblErrorMsg.text = errorMsg
                }
            }
        }
    }
    
    //MARK: Get 6 Months Graph
    func get6MonthGraphData(startDate: String, DataUgaseString: String)
    {
        let currentMonth: String = ((self.setInvoiceListDateFormate(previousDateStr: self.startDateVal, withPreviousDateFormte: DateFormats.dataUsageDateFrmt, replaeWithFormate: DateFormats.orderYearAndMonth) as NSString) as String)
        
        var st1 = String()
        let string = self.existingMonth
        if string.contains(currentMonth)
        {
            st1 = convertByteToGB(total: DataUgaseString)
            y_Axis = (st1 as NSString).doubleValue
            y_AxisTotalVal = y_AxisTotalVal + y_Axis
            dataUsageArr.removeLastObject()
            dataUsageArr.add(y_AxisTotalVal)
        }
        else
        {
            existingMonth = startDateVal
            dateCheck1 = existingDate
            dateCheck2 = convertByteToGB(total: DataUgaseString)
            y_AxisTotalVal = (dateCheck2 as NSString).doubleValue
            dataUsageArr.add(y_AxisTotalVal)
        }
        var sss = String()
        
        sss = self.convertByteToGB(total: DataUgaseString)
        self.finalTotalUsage = (sss as NSString).doubleValue + self.finalTotalUsage
    }
    
    //MARK: Get One Month Graph
    func getCurrentMonthDataOnGraph(startDate: String, DataUgaseString: String)
    {
        existingDate = setInvoiceListDateFormate(previousDateStr: startDate, withPreviousDateFormte: DateFormats.dataUsageDateFrmt, replaeWithFormate: DateFormats.orderCurrentDateFormatOutPut)
        var st1 = String()
        if dateCheck1 == existingDate
        {
            st1 = convertByteToGB(total: DataUgaseString)
            y_Axis = (st1 as NSString).doubleValue
            y_AxisTotalVal = y_AxisTotalVal + y_Axis
            dataUsageArr.removeLastObject()
            dataUsageArr.add(y_AxisTotalVal)
        }
        else
        {
            dateCheck1 = existingDate
            dateCheck2 = convertByteToGB(total: DataUgaseString)
            y_AxisTotalVal = (dateCheck2 as NSString).doubleValue
            dataUsageArr.add(y_AxisTotalVal)
        }
        var sss = String()
        
        sss = convertByteToGB(total: DataUgaseString)
        finalTotalUsage = (sss as NSString).doubleValue + finalTotalUsage
        let dayOfMonth: String = (((setInvoiceListDateFormate(previousDateStr: startDateVal, withPreviousDateFormte: DateFormats.dataUsageDateFrmt, replaeWithFormate: DateFormats.orderday) as NSString) as String) as String)


        dayOfMonthArr.append(dayOfMonth)
        
        //dataUsageDateFrmt
    }
    
    func uniqueElementsFrom(array: [String]) -> [String] {
        //Create an empty Set to track unique items
        var set = Set<String>()
        let result = array.filter {
            guard !set.contains($0) else {
                //If the set already contains this object, return false
                //so we skip it
                return false
            }
            //Add this item to the set since it will now be in the array
            set.insert($0)
            //Return true so that filtered array will contain this item.
            return true
        }
        return result
    }
    
    func getLast6MonthName()
    {
        for i in -5 ..< 0
        {
          //  let previousMonth = Calendar.current.date(byAdding: .month, value: i, to: Date())
            guard let previousMonth = Calendar.current.date(byAdding: .month, value: i, to: Date()) else
            {
                return
            }
            let dateFormatterGet = DateFormatter()
            dateFormatterGet.dateFormat = DateFormats.orderDateAndTime
            let dateFormatterPrint = DateFormatter()
            dateFormatterPrint.dateFormat = DateFormats.orderOnlyHalfNameMonth
            self.dayOfMonthArr.append(dateFormatterPrint.string(from: previousMonth))
        }
       
       // let previousMonth = Calendar.current.date(byAdding: .month, value: 0, to: Date())
        guard let previousMonth = Calendar.current.date(byAdding: .month, value: 0, to: Date()) else
        {
            return
        }
        
        let dateFormatterGet = DateFormatter()
        dateFormatterGet.dateFormat = DateFormats.orderDateAndTime
        let dateFormatterPrint = DateFormatter()
        dateFormatterPrint.dateFormat = DateFormats.orderOnlyHalfNameMonth
        dayOfMonthArr.append(dateFormatterPrint.string(from: previousMonth))
    }
    
    @IBAction func hideDatView(_ sender: Any) {
        self.navigationController?.popViewController(animated: false)
    }
}

extension Date{
    var day:Int {return Calendar.current.component(.day, from:self)}
    var month:Int {return Calendar.current.component(.month, from:self)}
    var year:Int {return Calendar.current.component(.year, from:self)}
}
