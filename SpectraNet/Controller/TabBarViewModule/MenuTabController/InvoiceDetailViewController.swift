//
//  InvoiceDetailViewController.swift
//  SpectraNet
//
//  Created by Bhoopendra on 7/17/19.
//  Copyright © 2019 Bhoopendra. All rights reserved.
//

import UIKit
import ObjectMapper
import RealmSwift
import MessageUI

class InvoiceDetailViewController: UIViewController,UITableViewDelegate,UITableViewDataSource,MFMailComposeViewControllerDelegate,UIWebViewDelegate {
  
    var realm: Realm? = nil
    var userResult:Results<UserCurrentData>? = nil
    var userInvoiceResult:Results<InvoiceListData>? = nil
    var userTranscationResult:Results<TransactionData>? = nil
    var dataResponse = NSDictionary()
    var checkStatus = String()
    
    @IBOutlet weak var lblTitleName: UILabel!
    @IBOutlet weak var invoiceBTN: UIButton!
    @IBOutlet weak var ledgerBTN: UIButton!
    @IBOutlet weak var invoiceBtnLine: UILabel!
    @IBOutlet weak var ledgerBtnLine: UILabel!
    @IBOutlet weak var invoiceTblView: UITableView!
    
    var canID = String()
    @IBOutlet weak var transparentView: UIView!
    
    // invoice Details Outlets
    @IBOutlet weak var lblOutstandingAmt: UILabel!
    @IBOutlet weak var lblInvoiceDueStatus: UILabel!
    @IBOutlet weak var lblDueDate: UILabel!
    @IBOutlet weak var invoiceDuePayBTN: UIButton!
    
    @IBOutlet weak var lblSelectFromDate: UILabel!
    @IBOutlet weak var lblSelectToDate: UILabel!
    @IBOutlet weak var lblSelectFromIMG: UIImageView!
    @IBOutlet weak var lblSelectToIMG: UIImageView!
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var filterInvoiceBTN: UIButton!
   
    @IBOutlet weak var ledgerLblSelectFromDate: UILabel!
    @IBOutlet weak var ledgerLblSelectToDate: UILabel!
    @IBOutlet weak var ledgerLblSelectFromIMG: UIImageView!
    @IBOutlet weak var ledgerLblSelectToIMG: UIImageView!
    @IBOutlet weak var ledgerFilterInvoiceBTN: UIButton!
    
    @IBOutlet weak var doneButtonView: UIView!
    var checkPickerFrom = String()
    var fromDateString = String()
    var toDateString = String()
    
    @IBOutlet var ledgerTbleView: UITableView!
    @IBOutlet var invoicePayNwView: UIView!
    var outStadingAmntStr = String()
    var getDateWithFormate = String()
    @IBOutlet var ledgerFilterView: UIView!
    @IBOutlet var invoiceFilterView: UIView!
    @IBOutlet var invoiceStatusView: UIView!
    @IBOutlet var ledgerStatusView: UIView!

    @IBOutlet var pdfParantView: UIView!
    @IBOutlet var pdfWebView: UIWebView!
    var invoiceNumber = String()
    var sendInvoiceNumber = String()
    var htmlStr = String()
    var totalNumberOfDays = Int()
    var preBarred = Bool()
    var tdsAmount = String()
    var tdsPercent = String()

    //MARK: View controller life cycle
    override func viewDidLoad()
    {
        super.viewDidLoad()
        realm = try? Realm()
    }

    override func viewWillAppear(_ animated: Bool)
    {
        super.viewWillAppear(animated)
        hitServiceClickOnTab()
        checkInvoiceOrTrasactionScreen()
    }
  
    func hitServiceClickOnTab()
    {
        userResult = self.realm!.objects(UserCurrentData.self)
        if let userActData = userResult?[0]
        {
            outStadingAmntStr = userActData.OutStandingAmount
            getDateWithFormate = userActData.DueDate
            lblOutstandingAmt.text = outStadingAmntStr
            canID = userActData.CANId
            preBarred = userActData.PreBarredFlag
        }
        
        datePicker.isHidden = true
        transparentView.isHidden = true
        doneButtonView.isHidden = true
        checkPickerFrom = ""
        
        if outStadingAmntStr == "0"
        {
            setdataIntoDueDateLBL(setTextDueDates: "", withBool: true, setDueDatesStatus: "",prebarredFlag: preBarred)
            lblOutstandingAmt.text = "No Dues"
        }
        else
        {
            if (getDateWithFormate == "")
            {
                setdataIntoDueDateLBL(setTextDueDates: "", withBool: true, setDueDatesStatus: "", prebarredFlag: preBarred)
                lblOutstandingAmt.text = "No Dues"
            }
            else
            {
                self.setdataIntoDueDateLBL(setTextDueDates: "Due on", withBool: false, setDueDatesStatus: setChangeDateFormate(previousDateStr: getDateWithFormate), prebarredFlag: preBarred)
                lblOutstandingAmt.text = convertStringtoFloatViceversa(amount: outStadingAmntStr)
            }
        }
        
        if ConnectionCheck.isConnectedToNetwork() == true
        {
            serviceTypeGetInvoiceListAPI()
        }
        else
        {
            noInternetCheckScreenWithMessage(errorMessage:"")
        }
        
        ledgerTbleView.isHidden=true
        self.tabBarController?.tabBar.isHidden = false
        setCornerRadiusView(radius: Float(invoicePayNwView.frame.height/2), color: UIColor.cornerBGFullOpack, view: invoicePayNwView)
        setCornerRadiusView(radius: Float(ledgerFilterView.frame.height/2), color: UIColor.clear, view: ledgerFilterView)
        setCornerRadiusView(radius: Float(invoiceFilterView.frame.height/2), color: UIColor.clear, view: invoiceFilterView)
        self.ledgerTbleView.estimatedRowHeight = 252
        self.ledgerTbleView.rowHeight = UITableView.automaticDimension
        invoiceStatusView.isHidden = true
        ledgerStatusView.isHidden = true
        pdfParantView.isHidden = true
    }
    
    func checkInvoiceOrTrasactionScreen()
    {
        if    AppDelegate.sharedInstance.navigateFrom==TabViewScreenName.Payment
        {
            setBelowlineColor(below1stTabLine: invoiceBtnLine, withColor: UIColor.black, below2ndTabLine: ledgerBtnLine, withColor2: .bgColors, btn1stTab: invoiceBTN, with1stBtnTabColor: UIColor.darkGray, btn2ndTab: ledgerBTN, with2ndBtnTabColor: .bgColors, setstatus: "PAYMENTS", toLabel: lblTitleName)
            ledgerTbleView.isHidden = false
            
            if ConnectionCheck.isConnectedToNetwork() == true
            {
                self.serviceTypeLedgerData(dateFrom: getLastNumberOfMonthPreviousDate(numberOfMonth: -6), toDate: getCurrentDate(withFormate: DateFormats.orderCurrentDateFormatOutPut))
            }
            else
            {
                noInternetCheckScreenWithMessage(errorMessage:"")
            }
            AppDelegate.sharedInstance.navigateFrom=""
            setTextWhenNotFilter(fromDateLabel: lblSelectFromDate, withFromStr: DefaultString.setSeletctdate, toDateLable: lblSelectToDate)
        }
        else
        {
            setBelowlineColor(below1stTabLine: invoiceBtnLine, withColor: .bgColors, below2ndTabLine: ledgerBtnLine, withColor2: UIColor.black, btn1stTab: invoiceBTN, with1stBtnTabColor: .bgColors , btn2ndTab: ledgerBTN, with2ndBtnTabColor: UIColor.darkGray, setstatus: "PAYMENTS", toLabel: lblTitleName)
            ledgerTbleView.isHidden = true
            setTextWhenNotFilter(fromDateLabel: ledgerLblSelectFromDate, withFromStr: DefaultString.setSeletctdate, toDateLable: ledgerLblSelectToDate)
        }
    }
 
    //MARK: Table View delegate
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        if tableView==ledgerTbleView
        {
            return userTranscationResult?.count ?? 0
        }
        else if tableView==invoiceTblView
        {
            return userInvoiceResult?.count ?? 0
        }
        return userInvoiceResult?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
         if (tableView==invoiceTblView)
        {
            var cell : InvoiceTableViewCell? = (invoiceTblView.dequeueReusableCell(withIdentifier: TableViewCellName.invoiceTableViewCell) as! InvoiceTableViewCell)
            if cell == nil {
                cell = InvoiceTableViewCell(style: UITableViewCell.CellStyle.default, reuseIdentifier: TableViewCellName.invoiceTableViewCell)
            }
            
            if let invoiceStr = userInvoiceResult?[indexPath.row]
            {
                
                cell?.lblInvoiceNmbr.text = invoiceStr.displayInvNo
                cell?.lblDueDate.text = setInvoiceListDateFormate(previousDateStr: invoiceStr.duedt, withPreviousDateFormte: DateFormats.orderInvoiceDate, replaeWithFormate: DateFormats.orderDateFormatResult)
                cell?.lblInvoicePeriod.text = String(format: "%@ - %@",setInvoiceListDateFormate(previousDateStr: invoiceStr.startdt, withPreviousDateFormte: DateFormats.orderInvoiceDate, replaeWithFormate: DateFormats.orderDateFormat),  setInvoiceListDateFormate(previousDateStr: invoiceStr.enddt, withPreviousDateFormte: DateFormats.orderInvoiceDate, replaeWithFormate: DateFormats.orderDateFormat))
                cell?.lblInvoicedate.text = setInvoiceListDateFormate(previousDateStr: invoiceStr.invoicedt, withPreviousDateFormte: DateFormats.orderInvoiceDate, replaeWithFormate: DateFormats.orderDateFormatResult)

                if AppDelegate.sharedInstance.segmentType == segment.userB2C
                {
                    cell?.lblManageScreen.isHidden = true
                    cell?.lblManageScreen.text = "I"
                    cell?.lblAmount.text = convertStringtoFloatViceversa(amount: invoiceStr.amount)
                    cell?.lblAmountD.text = "Amount"
                    cell?.lblOpeningAmt.text = ""
                    cell?.lblInvoiceAmt.text = ""
                    cell?.lblPayment.text = ""
                    cell?.lblTdsAmt.text = ""
                    cell?.lblOPENINGAmountD.isHidden = true
                    cell?.lbINVOICElAmountD.isHidden = true
                    cell?.lblPAYMENTAmountD.isHidden = true
                    cell?.lblTDSAmountD.isHidden = true
                    cell?.lblBtnName.text = "EMAIL"
                }
                else
                {
                    cell?.lblManageScreen.isHidden = true
                    cell?.lblAmount.text = convertStringtoFloatViceversa(amount: invoiceStr.unPaidBalance)
                    cell?.lblAmountD.text = "Unpaid Balance"
                    cell?.lblManageScreen.text = "iIIIIIl"
                    cell?.lblOpeningAmt.text = convertStringtoFloatViceversa(amount: invoiceStr.openingBalance)
                    cell?.lblInvoiceAmt.text = convertStringtoFloatViceversa(amount: invoiceStr.invoiceCharge)
                    cell?.lblTdsAmt.text = String(format: "%.2f ",invoiceStr.tdsAmount)
                    cell?.lblPayment.text = convertStringtoFloatViceversa(amount: invoiceStr.unPaidBalance)
                    cell?.lblOPENINGAmountD.isHidden = false
                    cell?.lbINVOICElAmountD.isHidden = false
                    cell?.lblPAYMENTAmountD.isHidden = false
                    cell?.lblTDSAmountD.isHidden = false
                    cell?.lblBtnName.text = "PAY NOW"
                }
            }
            
            cell?.invoiceViewButton.addTarget(self, action: #selector(invoiceViewButtonAction), for: .touchUpInside)
            cell?.invoiceEmailButton.addTarget(self, action: #selector(invoiceEmailButtonAction), for: .touchUpInside)
            setCornerRadiusView(radius: Float((cell?.viewInvoiceView.frame.height)!/2), color: UIColor.cornerBGFullOpack, view: cell!.viewInvoiceView)
            setCornerRadiusView(radius: Float((cell?.emailView.frame.height)!/2), color: UIColor.cornerBGFullOpack , view: cell!.emailView)
           
            return cell!
        }
        else if (tableView==ledgerTbleView)
        {
            var cell : TransactionTableViewCell? = (ledgerTbleView.dequeueReusableCell(withIdentifier: TableViewCellName.TrasactionTableViewCell) as! TransactionTableViewCell)
            
            if cell == nil
            {
                cell = TransactionTableViewCell(style: UITableViewCell.CellStyle.default, reuseIdentifier: TableViewCellName.TrasactionTableViewCell)
            }
            
            if let trasData = userTranscationResult?[indexPath.row]
            {
                cell?.lblTransDate.text = trasData.transactionDate
                cell?.lblTransNmbr.text = trasData.transactionNo
                cell?.lblTypePayment.text = trasData.type
                cell?.lblTransAmnt.text = convertStringtoFloatViceversa(amount: trasData.amount)
                cell?.lblPaymentMode.text = trasData.paymentMode
                cell?.lblDesc.text = trasData._description
            }
            return cell!
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        if tableView==invoiceTblView {
            if AppDelegate.sharedInstance.segmentType == segment.userB2C
            {
                return 294
            }
            else
            {
                return 415
            }
        }
        return UITableView.automaticDimension
    }
    
    
    @objc func invoiceViewButtonAction(sender: UIButton!)
    {
        let buttonPosition = sender.convert(CGPoint.zero, to: invoiceTblView)
        let indexPath = invoiceTblView.indexPathForRow(at:buttonPosition)
        
       if let trasData = userInvoiceResult?[indexPath!.row]
       {
            let vc = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: ViewIdentifier.invoiceDetailsIdentifier) as? InvoiceContentViewController
            vc?.invoiceNumber = trasData.invoiceNo
            vc?.sendInvoiceNumber = trasData.displayInvNo
            self.navigationController?.pushViewController(vc!, animated: false)
       }
    }
    
    @objc func invoiceEmailButtonAction(sender: UIButton!)
    {
        let buttonPosition = sender.convert(CGPoint.zero, to: invoiceTblView)
        let indexPath = invoiceTblView.indexPathForRow(at:buttonPosition)
        var paybleAmount = String()
       
        if let trasData = userInvoiceResult?[indexPath!.row]
        {
            sendInvoiceNumber = trasData.displayInvNo
            invoiceNumber = trasData.invoiceNo
            paybleAmount = trasData.invoiceCharge
            tdsAmount = String(format: "%.2f", trasData.tdsAmount)
            tdsPercent = trasData.tdsSlab
        }
        
        sendEmailCallMethod(withPaybleAmount: paybleAmount)
    }
    
    func sendEmailCallMethod(withPaybleAmount: String)
    {
        if AppDelegate.sharedInstance.segmentType == segment.userB2C
        {
            DispatchQueue.main.async {
                self.serviceTypeInvoiceContentData()
            }
        }
        else
        {
            goPayNowScreen(canID: canID, outstandingAmt: withPaybleAmount, tdsAmt: tdsAmount, tdsPrcnt: tdsPercent,ifFromTopup: "")
        }
    }
  
    @IBAction func duePaymentBTN(_ sender: Any)
    {
        goPayNowScreen(canID: canID, outstandingAmt: lblOutstandingAmt.text ?? "0.00", tdsAmt: "", tdsPrcnt: "",ifFromTopup: "")
    }
    
    @IBAction func filterTransactionBTN(_ sender: Any)
    {
        if ConnectionCheck.isConnectedToNetwork() == true
        {
           if (fromDateString != "" && toDateString != "")
           {
             ledgerFilterInvoiceBTN.isSelected = !ledgerFilterInvoiceBTN.isSelected
            if(ledgerFilterInvoiceBTN.isSelected == true)
            {
                self.serviceTypeLedgerData(dateFrom: fromDateString, toDate: toDateString)
            }
            else
            {
                ledgerLblSelectToDate.text = DefaultString.setSeletctdate
                ledgerLblSelectFromDate.text = DefaultString.setSeletctdate
                toDateString = ""
                fromDateString = ""
                self.serviceTypeLedgerData(dateFrom: getLastNumberOfMonthPreviousDate(numberOfMonth: -6), toDate: getCurrentDate(withFormate: DateFormats.orderCurrentDateFormatOutPut))
            }
         }
        else
        {
            showAlertC(message: DefaultString.pleaseSelectDate)
        }
        }
        else
        {
            noInternetCheckScreenWithMessage(errorMessage:"")
        }
    }
    
    @IBAction func ledgerSelectFromButton(_ sender: Any)
    {
        var result1 = String()
        result1 = getCurrentDate(withFormate: DateFormats.orderCurrentDateFormatOutPut)

        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = DateFormats.orderCurrentDateFormatOutPut //Your date format
        //according to date format your date string
        guard let date = dateFormatter.date(from: result1) else {
            fatalError()
        }
        datePicker.date = date
        datePicker .reloadInputViews()
        
        selectFromDate(datePicker: datePicker, hiddenTranspView: transparentView, hiddenDoneBTNView: doneButtonView)
        checkPickerFrom = "FromDATE"
        ledgerStatusView.isHidden = true
        ledgerFilterInvoiceBTN.isSelected = false

    }
    @IBAction func ledgerSelctTODateButton(_ sender: Any)
    {
        if ledgerLblSelectFromDate.text != DefaultString.setSeletctdate
        {
            selectToDate(datePicker: datePicker, getFromStringDate: fromDateString, hiddenTranspView: transparentView, hiddenDoneBTNView: doneButtonView)
            checkPickerFrom = "ToDATE"
            ledgerStatusView.isHidden = true
            ledgerFilterInvoiceBTN.isSelected = false
        }
    }
    
    @IBAction func selctTODateButton(_ sender: Any)
    {
        if lblSelectFromDate.text == DefaultString.setSeletctdate
        {
           print("Select From Date")
        }
        else
        {
            selectToDate(datePicker: datePicker, getFromStringDate: fromDateString, hiddenTranspView: transparentView, hiddenDoneBTNView: doneButtonView)
            checkPickerFrom = "ToDATE"
            invoiceStatusView.isHidden = true
            filterInvoiceBTN.isSelected = false
        }
    }
    
    @IBAction func selectFromButton(_ sender: Any)
    {
        selectFromDate(datePicker: datePicker, hiddenTranspView: transparentView, hiddenDoneBTNView: doneButtonView)
            checkPickerFrom = "FromDATE"
        invoiceStatusView.isHidden = true
        filterInvoiceBTN.isSelected = false
    }
    
    private func doneHandler()
    {
        transparentView.isHidden = true
    }
    
    private func completetionalHandler(month: Int, year: Int) {
        print( "month = ", month, " year = ", year )

    }
  
    // get date from selected date picker
    @IBAction func getDate(_ sender: Any)
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
                ledgerLblSelectFromDate.text = dateFormatter1.string(from: datePicker.date)
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
                    ledgerLblSelectFromDate.text = dateFormatter1.string(from: datePicker.date)
                }
                else if 0>dayCount
                {
                    showAlertC(message: ErrorMessages.endYearValidation)
                }
                else
                {
                    fromDateString = dateFormatter.string(from: datePicker.date)
                    lblSelectFromDate.text = dateFormatter1.string(from: datePicker.date)
                    ledgerLblSelectFromDate.text = dateFormatter1.string(from: datePicker.date)
                }
            }
        }
        else
        {
            toDateString = dateFormatter.string(from: datePicker.date)
            lblSelectToDate.text = dateFormatter1.string(from: datePicker.date)
            ledgerLblSelectToDate.text = dateFormatter1.string(from: datePicker.date)
        }
    }
    
    @IBAction func doneDatePickerBTN(_ sender: Any) {
        transparentView.isHidden = true
        doneButtonView.isHidden = true
        datePicker.isHidden = true
    }
   
  //************************************************************ SERVICES ******************************************************
    func serviceTypeGetInvoiceListAPI()
    {
        let dict = ["Action":ActionKeys.getInvoiceList, "Authkey":UserAuthKEY.authKEY, "canID":canID]
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
                        if let users = self.realm?.objects(InvoiceListData.self) {
                            self.realm!.delete(users)
                        }
                    }
                        
                    for entry in arr
                    {
                        if let currentUser = Mapper<InvoiceListData>().map(JSONObject: entry)
                        {
                            try! self.realm!.write
                            {
                                self.realm!.add(currentUser)
                            }
                        }
                    }
                    self.userInvoiceResult = self.realm!.objects(InvoiceListData.self)
                    self.invoiceTblView.delegate = self
                    self.invoiceTblView.dataSource = self
                    self.invoiceTblView.reloadData()
                    self.invoiceStatusView.isHidden = true
                    self.ledgerStatusView.isHidden = true
                }
                else
                {
                    guard let errorMsg = self.dataResponse.value(forKey: "message") as? String else
                    {
                        return
                    }
                    self.showAlertC(message: errorMsg)
                }
            }
            else
            {
                self.invoiceTblView.delegate = self
                self.invoiceTblView.dataSource = self
                self.invoiceTblView.reloadData()
            }
        }
    }
    
    @IBAction func filterInvoiceBTN(_ sender: Any)
    {
    if ConnectionCheck.isConnectedToNetwork() == true
    {
        if (fromDateString != "" && toDateString != "")
        {
            filterInvoiceBTN.isSelected = !filterInvoiceBTN.isSelected
            
            if(filterInvoiceBTN.isSelected == true)
            {
                let dict = ["Action":ActionKeys.getInvoiceList, "Authkey":UserAuthKEY.authKEY,"startDate":fromDateString, "canID":canID, "endDate":toDateString]
                print_debug(object: dict)
                
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
                            var dict1 = NSDictionary()
                            if let dict = response as? NSDictionary
                            {
                                dict1 = dict
                            }

                            var arr = NSArray()
                            //arr = dict1.value(forKey: "response") as! NSArray
                            guard let responseArr = dict1.value(forKey: "response") as? NSArray else
                            {
                                return
                            }
                            arr = responseArr
                            try! self.realm!.write
                            {
                                if let users = self.realm?.objects(InvoiceListData.self) {
                                    self.realm!.delete(users)
                                }
                            }

                            for entry in arr {

                                if let currentUser = Mapper<InvoiceListData>().map(JSONObject: entry) {

                                    try! self.realm!.write {
                                        self.realm!.add(currentUser)
                                    }
                                }
                            }
//                         DatabaseHandler.instance().getAndSaveInvoiceListData(dict:responseArr)

                            self.userInvoiceResult = self.realm!.objects(InvoiceListData.self)
                            self.invoiceTblView.delegate = self
                            self.invoiceTblView.dataSource = self
                            self.invoiceTblView.reloadData()
                            self.invoiceStatusView.isHidden = true
                            self.ledgerStatusView.isHidden = true
                        }
                        else
                        {
                            self.invoiceStatusView.isHidden = false
                            self.ledgerStatusView.isHidden = true
                            guard let errorMsg = dataResponse.value(forKey: "message") as? String else
                            {
                                return
                            }
                            self.showAlertC(message: errorMsg)
                        }
                    }
                }
            }
            else
            {
                lblSelectToDate.text = DefaultString.setSeletctdate
                lblSelectFromDate.text = DefaultString.setSeletctdate
                toDateString = ""
                fromDateString = ""
                serviceTypeGetInvoiceListAPI()
            }
        }
        else
        {
            showAlertC(message: DefaultString.pleaseSelectDate)
        }
    }
    else
    {
        noInternetCheckScreenWithMessage(errorMessage:"")
    }
    }
    
    
    func serviceTypeLedgerData(dateFrom: String, toDate: String)
    {
        let dict = ["Action":ActionKeys.paymentTransactionDetails, "Authkey":UserAuthKEY.authKEY,"fromDate":dateFrom, "canID":canID, "toDate":toDate]
        print_debug(object: dict)
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
                    
                    let trasactionArray: NSMutableArray =  NSMutableArray(array: arr.reverseObjectEnumerator().allObjects).mutableCopy() as! NSMutableArray

                    try! self.realm!.write
                    {
                        if let users = self.realm?.objects(TransactionData.self) {
                            self.realm!.delete(users)
                        }
                    }
                    
                    for entry in trasactionArray {
                        
                        if let currentUser = Mapper<TransactionData>().map(JSONObject: entry) {
                            
                            try! self.realm!.write {
                                self.realm!.add(currentUser)
                            }
                        }
                    }
                    // DatabaseHandler.instance().getAndSaveTransactionData(dict:responseArr)
                    self.userTranscationResult = self.realm!.objects(TransactionData.self)
                    self.ledgerTbleView.delegate=self
                    self.ledgerTbleView.dataSource=self
                    self.ledgerTbleView.reloadData()
                    self.invoiceStatusView.isHidden = true
                    self.ledgerStatusView.isHidden = true
                }
                else
                {
                    self.invoiceStatusView.isHidden = true
                    self.ledgerStatusView.isHidden = false
                    guard let errorMsg = dataResponse.value(forKey: "message") as? String else
                    {
                        return
                    }
                    self.showAlertC(message: errorMsg)
                }
            }
            else
            {
                self.invoiceStatusView.isHidden = true
                self.ledgerStatusView.isHidden = false
            }
        }
    }
    
    @IBAction func clickInvoiceBTN(_ sender: Any)
    {
        if ConnectionCheck.isConnectedToNetwork() == true
        {
            serviceTypeGetInvoiceListAPI()
        }
        else
        {
            noInternetCheckScreenWithMessage(errorMessage:"")
        }
        
       setTextWhenNotFilter(fromDateLabel: lblSelectFromDate, withFromStr: DefaultString.setSeletctdate, toDateLable: lblSelectToDate)

        setBelowlineColor(below1stTabLine: invoiceBtnLine, withColor: .bgColors, below2ndTabLine: ledgerBtnLine, withColor2: UIColor.black, btn1stTab: invoiceBTN, with1stBtnTabColor: .bgColors , btn2ndTab: ledgerBTN, with2ndBtnTabColor: UIColor.darkGray, setstatus: "PAYMENTS", toLabel: lblTitleName)
        ledgerTbleView.isHidden = true
    }
    
    @IBAction func clickLedgerBTN(_ sender: Any)
    {
        setTextWhenNotFilter(fromDateLabel: ledgerLblSelectFromDate, withFromStr: DefaultString.setSeletctdate, toDateLable: ledgerLblSelectToDate)

        setBelowlineColor(below1stTabLine: invoiceBtnLine, withColor: UIColor.black, below2ndTabLine: ledgerBtnLine, withColor2: .bgColors, btn1stTab: invoiceBTN, with1stBtnTabColor: UIColor.darkGray, btn2ndTab: ledgerBTN, with2ndBtnTabColor: .bgColors, setstatus: "PAYMENTS", toLabel: lblTitleName)
        ledgerTbleView.isHidden = false
        toDateString = ""
        fromDateString = ""
        
        if ConnectionCheck.isConnectedToNetwork() == true
        {
            self.serviceTypeLedgerData(dateFrom: getLastNumberOfMonthPreviousDate(numberOfMonth: -6), toDate: getCurrentDate(withFormate: DateFormats.orderCurrentDateFormatOutPut))
        }
        else
        {
            noInternetCheckScreenWithMessage(errorMessage:"")
        }
    }
    
    func setdataIntoDueDateLBL(setTextDueDates: String,withBool: Bool,setDueDatesStatus: String,prebarredFlag: Bool )
    {
        if prebarredFlag==false
        {
            lblInvoiceDueStatus.textColor = UIColor.black
        }
        else
        {
            lblInvoiceDueStatus.textColor = UIColor.red
        }
        
        lblDueDate.text = setTextDueDates
        invoicePayNwView.isHidden = withBool
        lblInvoiceDueStatus.text = setDueDatesStatus
    }
    
    func setTextWhenNotFilter(fromDateLabel: UILabel, withFromStr: String, toDateLable: UILabel)
    {
        fromDateLabel.text = withFromStr
        toDateLable.text = withFromStr
    }
  
    func serviceTypeInvoiceContentData()
    {
        let dict = ["Action":ActionKeys.invoiceContent, "Authkey":UserAuthKEY.authKEY,"invoiceNo":invoiceNumber]
        print_debug(object: dict)
        
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
                    guard let ivoiceHtml = dataResponse.value(forKey: "response") as? String else
                    {
                        return
                    }
                    self.htmlStr = ivoiceHtml
                    self.pdfWebView.loadHTMLString(self.htmlStr, baseURL: nil)
                    self.pdfWebView.delegate = self
                    self.pdfWebView.isHidden = true
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
    
    func webViewDidFinishLoad(_ webView: UIWebView)
    {
        openPDFView()
    }
    
    func openPDFView()
    {
        let render = UIPrintPageRenderer()
        render.addPrintFormatter((self.pdfWebView?.viewPrintFormatter())!, startingAtPageAt: 0)
        let page = CGRect(x: 0, y: 0, width: pdfWebView.frame.width, height: pdfWebView.frame.height)
        render.setValue(NSValue(cgRect:page),forKey:"paperRect")
        render.setValue(NSValue(cgRect:page), forKey: "printableRect")
        let pdfData = NSMutableData()
        UIGraphicsBeginPDFContextToData(pdfData,page, nil)
        
        for i in 1...render.numberOfPages-1
        {
            UIGraphicsBeginPDFPage();
            let bounds = UIGraphicsGetPDFContextBounds()
            render.drawPage(at: i - 1, in: bounds)
        }
        
        UIGraphicsEndPDFContext();
        let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        print_debug(object: documentsDirectory)

        var nameOfFile = String()
        nameOfFile = String(format: "INV_%@.pdf",sendInvoiceNumber)
        AppDelegate.sharedInstance.fileUrl = documentsDirectory.appendingPathComponent(nameOfFile) as NSURL;
        if !FileManager.default.fileExists(atPath:AppDelegate.sharedInstance.fileUrl.path!)
        {
            do {
                try pdfData.write(to: AppDelegate.sharedInstance.fileUrl as URL)
                attachedPdfFileToMail(withSubject: String(format: "%@%@",SpectraInvoiceTitle.invoiceTitle,sendInvoiceNumber ),fileName: String(format: "%@",nameOfFile ))
            }
            catch
            {
                print("error saving file:", error);
            }
        }
        else
        {
            attachedPdfFileToMail(withSubject: String(format: "%@%@",SpectraInvoiceTitle.invoiceTitle,sendInvoiceNumber ),fileName: String(format: "%@",nameOfFile ))
        }
    }

    func attachedPdfFileToMail(withSubject: String,fileName: String)
    {
    if MFMailComposeViewController.canSendMail()
    {
    let mailComposer = MFMailComposeViewController()
    mailComposer.setSubject(withSubject)
    mailComposer.setMessageBody(withSubject, isHTML: false)
    mailComposer.setToRecipients([""])
        
    do {
    let attachmentData = try Data(contentsOf: AppDelegate.sharedInstance.fileUrl as URL)
    mailComposer.addAttachmentData(attachmentData, mimeType: "application/pdf", fileName: fileName)
    mailComposer.mailComposeDelegate = self
    self.present(mailComposer, animated: true
    , completion: nil)
    } catch let error {
    print("We have encountered error \(error.localizedDescription)")
    }
    
    }
    else
    {
         showAlertC(message: SpectraSendEmail.emailBySimulator)
    }
}
    
//MARK:- MailcomposerDelegate
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        switch result {
        case .cancelled:
            showAlertC(message: SpectraSendEmail.emailCancelled)
            break
            
        case .saved:
          
            break
            
        case .sent:
            break
            
        case .failed:
            showAlertC(message: SpectraSendEmail.emailFailed)
            break
        default:
            break
        }
        controller.dismiss(animated: true)
    }
}

