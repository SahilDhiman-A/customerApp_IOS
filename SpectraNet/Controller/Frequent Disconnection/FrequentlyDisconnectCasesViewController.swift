//
//  FrequentlyDisconnectCasesViewController.swift
//  My Spectra
//
//  Created by Chakshu on 15/09/20.
//  Copyright © 2020 Bhoopendra. All rights reserved.
//

import UIKit
import ObjectMapper
import RealmSwift
class FrequentlyDisconnectCasesViewController: UIViewController {

@IBOutlet weak var desctptionCenterView: NSLayoutConstraint!
@IBOutlet weak var viewHeight: NSLayoutConstraint!
@IBOutlet weak var decrptionLabel: UILabel!
@IBOutlet weak var yesNoView: UIView!
@IBOutlet weak var OkeyView: UIView!
@IBOutlet weak var backToHomeView: UIView!
@IBOutlet weak var backgroundView: UIView!

@IBOutlet weak var gostImageView: UIImageView!
@IBOutlet weak var gostLabel: UILabel!


var realm: Realm? = nil
var userResult:Results<UserCurrentData>? = nil
var messageCode = String()
var voc = String()
var canId = String()
var fupSpeed = String()
var consumedVolume = String()
var dueDateString = ""
var ETRvalue = ""
var srNo = ""
var typeSubype = ""
var powerLevel = ""
override func viewDidLoad() {
    super.viewDidLoad()
    
  
    
    self.setupUI()
   
}


override func viewWillLayoutSubviews() {
    switch messageCode {
    case NoInternetMessageCode.massOutrage:
        
        viewHeight.constant = 340
        break
    case NoInternetMessageCode.FDSSSRRaised:
        //                  if(self.powerLevel == "-40"){
        //                     viewHeight.constant = 360
        //                  }else{
        viewHeight.constant = 240
        //}
        break
    default:
        break
    }
    
}



func setupUI()  {
    
    
    if(voc == "3"){
        gostLabel.text = "Slow speed"
        gostImageView.image = UIImage(named:"slow")
    }else{
        gostLabel.text = "Frequent disconnection"
        gostImageView.image = UIImage(named:"unlink")
        
    }
    
    yesNoView.isHidden = true
    OkeyView.isHidden = true
    switch messageCode {
    
    case NoInternetMessageCode.FUPFlag:
        fUPFlag()
        break
    case NoInternetMessageCode.FUPFlagNo:
        fUPFlagNo()
        break
    case NoInternetMessageCode.massOutrage:
        
        massOutrage()
        
        break
    case NoInternetMessageCode.FUPFlagYes:
        backgroundView.isHidden = false
        yesNoView.isHidden = false
        goToTopUpButton()
        break
        
    case  NoInternetMessageCode.FDSSSRRaised:
        
        self.fDSSSRRaised()
        
        break
    default: break
        
    }
    
}

func fUPFlag(){
    
    backgroundView.isHidden = false
    yesNoView.isHidden = false
    
    if(voc == "3"){
        decrptionLabel.text = "You have exhausted your data quota of \(consumedVolume) hence you are facing slow speed disconnection. Would you like to purchase a Top Up to avoid slow speed ?"
       
    }else{
        decrptionLabel.text = "You have exhausted your data quota of \(consumedVolume) hence you are facing frequent disconnection. Would you like to purchase a Top Up to avoid frequent disconnection ?"
    }
    
}

func fUPFlagNo(){
    backgroundView.isHidden = false
    OkeyView.isHidden = false
    
   
    decrptionLabel.text =  "Your data quota is currently exhausted and will be reset on your next bill cycle date. Your speed will continue to be \(fupSpeed) till then. Kindly purchase our attractive Top-ups to enjoy enhanced speeds"
    
}
func massOutrage(){
    backgroundView.isHidden = false
    decrptionLabel.text = ""
    let attributedText = NSMutableAttributedString(string: "There is an outage in your\n area which is expected to\n be restored by\n", attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 17)])
    
    if let value = HelpingClass.sharedInstance.convert(time: ETRvalue, fromFormate: "dd/MM/yyyy hh:mm a", toFormate:"dd/MM/yyyy" ),let valueTime = HelpingClass.sharedInstance.convert(time: ETRvalue, fromFormate: "dd/MM/yyyy hh:mm a", toFormate:"hh:mm a" ){
        
        let attributedDate = NSAttributedString(string: " \(value) by \(valueTime)", attributes:  [NSAttributedString.Key.font: UIFont(name: "HelveticaNeue-Bold", size: 20)!])
        attributedText.append(attributedDate)
    }
    
    
    
    let attributedBody = NSAttributedString(string: "\n\n\n Your internet will start working\n automatically after this time.\n Sorry for the inconvenience caused.", attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 17)])
    attributedText.append(attributedBody)
    
    decrptionLabel.attributedText = attributedText
    backToHomeView.isHidden = false
    decrptionLabel.isHidden = false
    
}

func fDSSSRRaised(){
    
    backgroundView.isHidden = false
    
    
    OkeyView.isHidden = false
    
    let attributedText = NSMutableAttributedString(string: "Service Request no. \(self.srNo) for \(self.typeSubype) registered and assigned to Technical team.\nResolution time is\n", attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 17)])
    if let value = HelpingClass.sharedInstance.convert(time: ETRvalue, fromFormate: "dd/MM/yyyy hh:mm a", toFormate:"dd/MM/yyyy" ),let valueTime = HelpingClass.sharedInstance.convert(time: ETRvalue, fromFormate: "dd/MM/yyyy hh:mm a", toFormate:"hh:mm a" ){
        let attributedDate = NSAttributedString(string: " \(value) by \(valueTime)", attributes:  [NSAttributedString.Key.font: UIFont(name: "HelveticaNeue-Bold", size: 20)!])
        attributedText.append(attributedDate)
    }
    
    decrptionLabel.attributedText =  attributedText
    viewHeight.constant = 240
   
}


func goToTopUpButton()  {
    realm = try? Realm()
    userResult = self.realm!.objects(UserCurrentData.self)
    if let userActData = userResult?[0]
    {
        
        let vc = UIStoryboard.init(name: "Storyboard", bundle: Bundle.main).instantiateViewController(withIdentifier: ViewIdentifier.topupIdentifier) as? TopupPlanViewController
        vc?.canID = canId
        vc?.basePlan = userActData.Product
        vc?.isFromMySRScreen =  true
        self.navigationController?.pushViewController(vc!, animated: false)
        
        
        
    }
}

@IBAction func yesButtonClick(_ sender: Any){
    self.setTopUPAction(useKey: "getTopup", useValue: "Yes")
}

@IBAction func noButtonClick(_ sender: Any){
    
    //  messageCode = ""
    self.setTopUPAction(useKey: "getTopup", useValue: "No")
    
}
@IBAction func backToHome(_ sender: Any)
{
    Switcher.updateRootVC()
    
}
func setTopUPAction(useKey:String,useValue:String){
    
    CANetworkManager.sharedInstance.progressHUD(show: true)
    
    let apiURL = ServiceMethods.serviceBaseFDSS + "/canId/\(canId)/voc/\(voc)"
    let dict = [useKey:useValue] as [String : Any]
    CANetworkManager.sharedInstance.requestApiWithoutHUD(serviceName: apiURL, method: kHTTPMethod.POST, postData: dict as Dictionary<String, AnyObject>) { (response, error) in
        CANetworkManager.sharedInstance.progressHUD(show: false)
        
        print_debug(object: response)
        
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
            
            if let responce = dataResponse["response"] as? [String:AnyObject]{
                
                if let  messageCode = responce["messageCode"] as? String{
                    
                    if let  fupSpeed = responce["fupSpeed"] as? String{
                        self.fupSpeed = fupSpeed
                        
                    }
                    
                    self.messageCode = messageCode
                    self.setupUI()
                    
                }
            }
        }
        
        
        
    }
}

//func serviceTypeGetSRStatus(useKey: String, useNumber: String)
//{
//    let dict = ["Action":ActionKeys.getSRStatus, "Authkey":UserAuthKEY.authKEY, useKey:useNumber]
//    print_debug(object: dict)
//    CANetworkManager.sharedInstance.requestApiWithoutHUD(serviceName: ServiceMethods.serviceBaseURL, method: kHTTPMethod.POST, postData: dict as Dictionary<String, AnyObject>) { (response, error) in
//        
//        print_debug(object: response)
//        
//        CANetworkManager.sharedInstance.progressHUD(show: false)
//        
//        if response != nil
//        {
//            
//            if let status = response?["status"] as? String{
//                
//                
//                if status.lowercased() == Server.api_status{
//                    
//                    
//                    if let array = response?["response"] as? [[String:AnyObject]]{
//                        
//                        
//                        if array.count > 0 {
//                            if let value = array[0] as? [String:AnyObject]{
//                                
//                                if let subSubType = value["subType"] as? String,let problemType = value["problemType"] as? String{
//                                    
//                                    self.typeSubype = problemType + "-" + subSubType
//                                    
//                                }
//                                if let ETR = value["ETR"] as? String{
//                                    
//                                    if let value = HelpingClass.sharedInstance.convert(time: ETR, fromFormate: "MM/dd/yyyy hh:mm:ss a", toFormate:"dd/MM/yyyy hh:mm a" ){
//                                        self.ETRvalue = value
//                                        
//                                    }
//                                    
//                                }
//                                
//                                self.setupUI()
//                                
//                            }
//                            
//                            
//                        }
//                        
//                        
//                        
//                    }
//                    
//                }
//            }
//            
//            
//            
//        }
//    }
//}

@IBAction func backBTN(_ sender: Any)
{
    self.navigationController?.popViewController(animated: false)
}
}
