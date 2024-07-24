//
//  StandingInstractionViewController.swift
//  My Spectra
//
//  Created by Bhoopendra on 9/26/19.
//  Copyright © 2019 Bhoopendra. All rights reserved.
//

import UIKit
import ObjectMapper
import RealmSwift

class StandingInstractionViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
  
    var realm:Realm? = nil
    var userCurrent:Results<UserCurrentData>? = nil
    var dataResponse = NSDictionary()
    var checkStatus = String()
    
    @IBOutlet weak var lblAutoPayStstus: UILabel!
    @IBOutlet weak var lblAutoPaydefaultTitle: UILabel!
    // SI using table view cell
    @IBOutlet weak var siTableView: UITableView!
    @IBOutlet weak var transparantView: UIView!
    @IBOutlet weak var dialogeView: UIView!
    @IBOutlet weak var roundOkButonView: UIView!
    @IBOutlet weak var lblDisableStatus: UILabel!
    
    var postString = String()
    var requestType = String()
    var canID = String()
    var paymentStaus = String()
    
    //MARK: View controller life cycle
    override func viewDidLoad()
    {
        super.viewDidLoad()
        realm = try? Realm()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
       
        siTableView.isHidden = true
        userCurrent = self.realm!.objects(UserCurrentData.self)
        if let userActData = userCurrent?[0]
            {
                canID = userActData.CANId
            }
       // show and hide auto pay flag
        autoFlagHide(withBool: true)
        
        if AppDelegate.sharedInstance.siTermCondtionAccept == ""
        {
            AppDelegate.sharedInstance.siTermCondtionAccept = StandinInsrcuction.termConditionUnselected
        }
        else if AppDelegate.sharedInstance.siTermCondtionAccept == StandinInsrcuction.termConditionSelected
        {
            AppDelegate.sharedInstance.siTermCondtionAccept = StandinInsrcuction.termConditionSelected
        }
        else if AppDelegate.sharedInstance.siTermCondtionAccept == StandinInsrcuction.termConditionUnselected
        {
            AppDelegate.sharedInstance.siTermCondtionAccept = StandinInsrcuction.termConditionUnselected
        }
       print_debug(object: AppDelegate.sharedInstance.siTermCondtionAccept)
           
        serviceTypeSIStatus()
        hiddenAndShowViews(bool: true, statusMeg: "")
        setCornerRadiusView(radius: Float(roundOkButonView.frame.height/2), color: UIColor.clear, view: roundOkButonView)
        siTableView.tableFooterView = UIView()
    }
    
    @objc func handleTermTapped(gesture: UITapGestureRecognizer)
    {
        self.siTableView.setContentOffset(.zero, animated: true)
        siPrivacyPolicyScreen()
    }
    
    func checkRange(_ range: NSRange, contain index: Int) -> Bool {
        return index > range.location && index < range.location + range.length
    }
  
    func postParamInPyamentScreen(withRequestType: String) {
        postString = "secretKey=\(StandinInsrcuction.secretKey)&canID=\(canID)&billAmount=\(StandinInsrcuction.siPaybleAmount)&returnUrl=\(StandinInsrcuction.siReturnURL)&requetType=\(requestType)"
        goPyamentScreen(postStr: postString)
    }
   
    // back previuos screen
    @IBAction func backClick(sender: UIButton)
    {
        self.navigationController?.popViewController(animated: false)
    }
 
    // SIStatus ebable or disable API response
    func serviceTypeSIStatus()
    {
        let dict = ["Action":ActionKeys.getSIStatusAutoPay, "Authkey":UserAuthKEY.authKEY, "canID":canID]
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
                let dict = self.dataResponse.value(forKey: "response") as AnyObject
               guard let siStatus = dict.value(forKey: "siStatus") as? String else
               {
                    return
                }
                AppDelegate.sharedInstance.paySIStatus = siStatus
               // AppDelegate.sharedInstance.paySIStatus = "Enable"
                // SIStatus Enable than show Auto-Pay ON
                if AppDelegate.sharedInstance.paySIStatus == StandinInsrcuction.siDisable
                {
                    self.autoFlagHide(withBool: true)
                }
                else
                {
                    self.autoFlagHide(withBool: false)
                }
              
                self.siTableView.isHidden = false
                self.siTableView.delegate = self
                self.siTableView.dataSource = self
                self.siTableView.reloadData()
                self.siTableView.setContentOffset(.zero, animated: true)
               // self.siTableView.contentInsetAdjustmentBehavior = .never

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
          }
       }
  
    func autoFlagHide(withBool: Bool)
    {
        lblAutoPaydefaultTitle.isHidden = true
        lblAutoPayStstus.isHidden = true
    }
    
    //MARK: TableView delegate
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return 1
    }
        
   func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            
        var cell : SITableViewCell? = (siTableView.dequeueReusableCell(withIdentifier: TableViewCellName.siTableViewCell) as! SITableViewCell)
            
        if cell == nil {
            cell = SITableViewCell(style: UITableViewCell.CellStyle.default, reuseIdentifier: TableViewCellName.siTableViewCell)
        }
            setCornerRadiusView(radius: Float(cell!.changeSIView.frame.height/2), color: UIColor.cornerBGFullOpack, view: cell!.changeSIView)
            setCornerRadiusView(radius: Float(cell!.changeDisabalView.frame.height/2), color: UIColor.cornerBGFullOpack, view: cell!.changeDisabalView)
            setCornerRadiusView(radius: Float(cell!.changeAutoPayView.frame.height/2), color: UIColor.cornerBGFullOpack, view: cell!.changeAutoPayView)
           
            cell?.autoPayBTN.addTarget(self, action: #selector(clickAutoButton), for: .touchUpInside)
            cell?.changeSIBTN.addTarget(self, action: #selector(clickChangeSIButton), for: .touchUpInside)
            cell?.disableBTN.addTarget(self, action: #selector(clickDisableButton), for: .touchUpInside)
            cell?.termSelectUnselectBTN.addTarget(self, action: #selector(clickTermSelectUnselect), for: .touchUpInside)

            if AppDelegate.sharedInstance.paySIStatus == StandinInsrcuction.siEnable
                {
                    cell?.changeSIView.isHidden = false
                    cell?.changeDisabalView.isHidden = false
                    cell?.changeAutoPayView.isHidden = true
                    cell?.termSelectUnselectBTN.isHidden = true
                    cell?.lblHyperLinkedTerm.isHidden = true
                }
                else if AppDelegate.sharedInstance.paySIStatus == StandinInsrcuction.siDisable
                {
                    cell?.changeSIView.isHidden = true
                    cell?.changeDisabalView.isHidden = true
                    cell?.changeAutoPayView.isHidden = false
                    cell?.termSelectUnselectBTN.isHidden = false
                    cell?.lblHyperLinkedTerm.isHidden = false
                    
                    let formattedText = String.format(strings: [StandinInsrcuction.term], boldFont: UIFont(name: "HelveticaNeue", size: 16)!,boldColor: UIColor.white,inString: StandinInsrcuction.termText,font: UIFont(name: "HelveticaNeue", size: 15)!,color: UIColor.white)
                    cell?.lblHyperLinkedTerm.attributedText = formattedText
                    let tap = UITapGestureRecognizer(target: self, action: #selector(handleTermTapped))
                    cell?.lblHyperLinkedTerm.addGestureRecognizer(tap)
                }
            return cell!
        }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
            
        return UITableView.automaticDimension
    }
    
    @objc func clickTermSelectUnselect(sender: UIButton!)
     {
         sender.isSelected = !sender.isSelected
         if sender.isSelected
         {
             AppDelegate.sharedInstance.siTermCondtionAccept = StandinInsrcuction.termConditionSelected
         }
        else
         {
             AppDelegate.sharedInstance.siTermCondtionAccept = StandinInsrcuction.termConditionUnselected
         }
     }
    
    @objc func clickAutoButton(sender: UIButton!)
     {
        self.siTableView.setContentOffset(.zero, animated: true)
         if AppDelegate.sharedInstance.siTermCondtionAccept == StandinInsrcuction.termConditionSelected
         {
             requestType = StandinInsrcuction.siEnableRequestType
             postParamInPyamentScreen(withRequestType: requestType)
         }
         else
         {
             showAlertC(message: StandinInsrcuction.termConditionAccept)
         }
     }
     
    @objc func clickChangeSIButton(sender: UIButton!)
     {
             self.siTableView.setContentOffset(.zero, animated: true)
             requestType = StandinInsrcuction.siEnableRequestType
             postParamInPyamentScreen(withRequestType: requestType)
     }
     
    @objc func clickDisableButton(sender: UIButton!)
     {
        self.siTableView.setContentOffset(.zero, animated: true)
         if AppDelegate.sharedInstance.paySIStatus == StandinInsrcuction.siEnable
         {
             AppDelegate.sharedInstance.paySIStatus = StandinInsrcuction.siDisable
             serviceTypeDisabelSI()
         }
         else
         {
             AppDelegate.sharedInstance.paySIStatus = StandinInsrcuction.siEnable
            requestType = StandinInsrcuction.siEnableRequestType
            postParamInPyamentScreen(withRequestType: requestType)
         }
     }
    
    func serviceTypeDisabelSI() {

        let dict = ["secretKey":StandinInsrcuction.secretKey, "billAmount":StandinInsrcuction.siPaybleAmount, "canID":canID, "returnUrl":StandinInsrcuction.returnURL, "requetType":StandinInsrcuction.siDisablRequestType]

        CANetworkManager.sharedInstance.requestApi(serviceName: StandinInsrcuction.siDisableURL, method: kHTTPMethod.POST, postData: dict as Dictionary<String, AnyObject>) { (response, error) in

        print_debug(object: response)
        if response != nil
        {
            guard let responseDict = response as? NSDictionary else
            {
                return
            }
            
            guard let status = responseDict.value(forKey: "status") as? String else
            {
                return
            }
            if status.lowercased() == Server.api_status
            {
                let dict = responseDict.value(forKey: "response") as AnyObject
                guard let siStatus = dict.value(forKey: "StandardInstrunction") as? String else
                {
                    return
                }
                AppDelegate.sharedInstance.paySIStatus = siStatus
                self.hiddenAndShowViews(bool: false, statusMeg: StandinInsrcuction.siDisabled)
            }
            else
            {
                self.hiddenAndShowViews(bool: false, statusMeg: StandinInsrcuction.siDisablFailed)
                AppDelegate.sharedInstance.paySIStatus = StandinInsrcuction.siEnable
            }
         }
     }
  }
    
    func hiddenAndShowViews(bool: Bool,statusMeg: String)
     {
         transparantView.isHidden = bool
         dialogeView.isHidden = bool
         lblDisableStatus.text = statusMeg
     }
     
    @IBAction func userDisabledButton(_ sender: Any)
    {
        
        hiddenAndShowViews(bool: true, statusMeg: "")
        if AppDelegate.sharedInstance.paySIStatus == StandinInsrcuction.siDisable
        {
            autoFlagHide(withBool: true)
        }
        else
        {
            autoFlagHide(withBool: false)
        }
        siTableView.isHidden = false
        siTableView.delegate = self
        siTableView.dataSource = self
        siTableView.reloadData()
    }
}
extension String {
    static func format(strings: [String],
                    boldFont: UIFont = UIFont.boldSystemFont(ofSize: 14),
                    boldColor: UIColor = UIColor.blue,
                    inString string: String,
                    font: UIFont = UIFont.systemFont(ofSize: 14),
                    color: UIColor = UIColor.black) -> NSAttributedString {
        let attributedString =
            NSMutableAttributedString(string: string,
                                    attributes: [
                                        NSAttributedString.Key.font: font,
                                        NSAttributedString.Key.foregroundColor: color])
      
        let boldFontAttribute = [NSAttributedString.Key.font: boldFont, NSAttributedString.Key.foregroundColor: boldColor]
        for bold in strings {
            attributedString.addAttributes(boldFontAttribute, range: (string as NSString).range(of: bold))
        }
        let rangeToUnderLine = (StandinInsrcuction.termText as NSString).range(of: StandinInsrcuction.term)

        attributedString.addAttribute(NSAttributedString.Key.underlineStyle, value: NSUnderlineStyle.single.rawValue, range: rangeToUnderLine)
        
        return attributedString
    }
}
extension UILabel {
    func indexOfAttributedTextCharacterAtPoint(point: CGPoint) -> Int {
        assert(self.attributedText != nil, "This method is developed for attributed string")
        let textStorage = NSTextStorage(attributedString: self.attributedText!)
        let layoutManager = NSLayoutManager()
        textStorage.addLayoutManager(layoutManager)
        let textContainer = NSTextContainer(size: self.frame.size)
        textContainer.lineFragmentPadding = 0
        textContainer.maximumNumberOfLines = self.numberOfLines
        textContainer.lineBreakMode = self.lineBreakMode
        layoutManager.addTextContainer(textContainer)

        let index = layoutManager.characterIndex(for: point, in: textContainer, fractionOfDistanceBetweenInsertionPoints: nil)
        return index
    }
}
