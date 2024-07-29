//
//  AutoDetectionWIFIViewController.swift
//  My Spectra
//
//  Created by Chakshu on 22/09/20.
//  Copyright © 2020 Bhoopendra. All rights reserved.
//

import UIKit


class AutoDetectionWIFIViewController: UIViewController,UITextViewDelegate {
    var messageCode = String()
    var canId = String()
    var ETRvalue = ""
    var srNo = ""
    var typeSubype = ""
    var wifiName = "Spectra"
    var messageDisc = ""
    var strengthType = wifiSignalStength.excellent
    var modemType = "inteno"
    var bandType = wifiSignalFrequesncy.secondCase
    var voc = String()
    var seconds = 0 //This variable will hold a starting value of seconds. It could be any amount above 0.
    var timerFirst : Timer?
    @IBOutlet weak var isLanConnectedView: UIView!
    @IBOutlet weak var lanConnectedViewHeigh: NSLayoutConstraint!
    @IBOutlet weak var isLanConnectedLabel: UILabel!
    @IBOutlet weak var isLanConnectedBottomView: UIView!
    @IBOutlet weak var isLanConnectedOKeyView: UIView!
    @IBOutlet weak var isLanConnectedBacktoHomeView: UIView!
    @IBOutlet weak var lanConnectedYesView: UIView!
    @IBOutlet weak var lanConnectedNoView: UIView!
    @IBOutlet weak var timerLabel: UILabel!
    @IBOutlet weak var lanConnectedYesViewHeigh: NSLayoutConstraint!
    @IBOutlet weak var lanMBBSTextField: UITextField!
    @IBOutlet weak var isWifiView: UIView!
    @IBOutlet weak var isWifiViewHeigh: NSLayoutConstraint!
    @IBOutlet weak var wifiTimerLabel: UILabel!
    @IBOutlet weak var isWifiBottonView: UIView!
    @IBOutlet weak var wifiOKeyView: UIView!
    @IBOutlet weak var isWifiRangeSelectBottonView: UIView!
    @IBOutlet weak var fdIssueDescLabel: UILabel!
    @IBOutlet weak var bandSelectLabel: UILabel!
    @IBOutlet weak var wifiNameLabel: UILabel!
    @IBOutlet weak var bandNameLabel: UILabel!
    @IBOutlet weak var strengthNameLabel: UILabel!
    @IBOutlet weak var modenView: UIView!
    @IBOutlet weak var bandView: UIView!
    @IBOutlet weak var infoView: UIView!
    @IBOutlet weak var wifiNameCenterLayout: NSLayoutConstraint!
    @IBOutlet weak var wifiCheckSpeedView: UIView!
    @IBOutlet weak var wifiNameSpeedLabel: UILabel!
    @IBOutlet weak var bandNameSpeedLabel: UILabel!
    @IBOutlet weak var strengthNameSpeedLabel: UILabel!
    @IBOutlet weak var wifiSpeedTextField: UITextField!
    @IBOutlet weak var bestTimeTextView: UITextView!
    @IBOutlet weak var bestTimeLanTextView: UITextView!
    @IBOutlet weak var gostImageView: UIImageView!
    @IBOutlet weak var gostLabel: UILabel!
    @IBOutlet weak var lanOKeyView: UIView!
    @IBOutlet weak var infoViewLan: UIView!
    @IBOutlet weak var infoButtonLan: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bestTimeTextView.text = ""
        bestTimeLanTextView.text = ""
        bestTimeLanTextView.textColor = UIColor.lightGray
        bestTimeTextView.textColor = UIColor.lightGray
        debugPrint("Reachable via WiFi")
                let service = WiFiInfoService()
                
                if let info = service.getWiFiInfo() {
                    
                    print_debug(object: "\(info)")
                    
                    
                    if info.rssi == wifiSignalStength.noWifi{
                        self.messageCode = NoInternetMessageCode.lanSelected
                    }else{
                    
                    self.wifiName = info.networkName
                    self.strengthType = info.rssi
                    self.messageCode = NoInternetMessageCode.wifiSelected
                    }
                   
                } else {
                    self.messageCode = NoInternetMessageCode.lanSelected
                    //messageCode = NoInternetMessageCode.wifiSelected
                }
        if(voc == "3"){
            gostLabel.text = "Slow speed"
            gostImageView.image = UIImage(named:"slow")
        }else{
            gostLabel.text = "Frequent disconnection"
            gostImageView.image = UIImage(named:"unlink")
            
        }
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillHide), name:UIResponder.keyboardWillHideNotification, object: nil)
        

        
        self.setupUI()
        
        // Do any additional setup after loading the view.
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == UIColor.lightGray {
            textView.text = nil
            textView.textColor = UIColor.black
        }
    }
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
            if(text == "\n") {
                textView.resignFirstResponder()
                return false
            }
        let newText = (textView.text as NSString).replacingCharacters(in: range, with: text)
        let numberOfChars = newText.count
        return numberOfChars < 250
        }

        /* Older versions of Swift */
        func textView(textView: UITextView, shouldChangeTextInRange range: NSRange, replacementText text: String) -> Bool {
            if(text == "\n") {
                textView.resignFirstResponder()
                return false
            }
            let newText = (textView.text as NSString).replacingCharacters(in: range, with: text)
            let numberOfChars = newText.count
            return numberOfChars < 250
            }
       
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = ""
            textView.textColor = UIColor.lightGray
        }
    }
    
    @objc func keyboardWillHide(notification: NSNotification){
       
        
        if(messageCode ==  NoInternetMessageCode.wifiCheckSpeedSelected){
            
            wifiOKeyView.alpha = 0.8
            wifiOKeyView.isUserInteractionEnabled = false
            if let value = Int(wifiSpeedTextField.text ?? ""){
                
                if(value > 0){
                    wifiOKeyView.alpha = 1.0
                    wifiOKeyView.isUserInteractionEnabled = true
                    
                }
            }
            
        }
        if(messageCode ==  NoInternetMessageCode.lanSelectedYesTimerSet){
            
            lanOKeyView.alpha = 0.8
            lanOKeyView.isUserInteractionEnabled = false
            if let value = Int(lanMBBSTextField.text ?? ""){
                
                if(value > 0){
                    lanOKeyView.alpha = 1.0
                    lanOKeyView.isUserInteractionEnabled = true
                    
                }
            }
            
        }
    }
    
    func setupUI()  {
        self.infoButtonLan.isHidden = true
        gostLabel.isHidden = true
        gostImageView.isHidden = true
        self.isLanConnectedView.isHidden = true
        self.lanConnectedYesView.isHidden = true
        self.isWifiView.isHidden = true
        self.isLanConnectedBottomView.isHidden = true
        self.isLanConnectedOKeyView.isHidden = true
        self.isLanConnectedBacktoHomeView.isHidden = true
        self.modenView.isHidden = true
        self.bandView.isHidden = true
        wifiCheckSpeedView.isHidden = true
        switch messageCode {
        case  NoInternetMessageCode.lanSelected:
            self.lanSelected()
            break
        case  NoInternetMessageCode.wifiSelected:
            self.wifiSelected()
            break
            
        case  NoInternetMessageCode.wifiRangeSelected:
            self.wifiRangeSelected()
            break
        case  NoInternetMessageCode.wifiCheckSpeedSelected:
            self.wifiCheckSpeedSelected()
            break
        case  NoInternetMessageCode.lanSelectedYes:
            self.lanSelectedYes()
            break
        case  NoInternetMessageCode.lanSelectedNo:
            self.lanSelectedNo()
            break
        case  NoInternetMessageCode.lanSelectedYesTimerSet:
            self.lanSelectedYesTimerSet()
            break
        case  NoInternetMessageCode.speedYes,NoInternetMessageCode.speedYesWifi:
            self.speedYes()
            break
        case  NoInternetMessageCode.FDSSSRRaised:
            self.fDSSSRRaised()
            break
        default: break
        }
    }
    
    func fDSSSRRaised(){
        
        self.isLanConnectedView.isHidden = false
        self.isLanConnectedOKeyView.isHidden = false
       // self.isLanConnectedOKeyView.alpha = 0.8;
        let attributedText = NSMutableAttributedString(string: "Service Request no. \(self.srNo) for \(self.typeSubype) registered and assigned to Technical team.\nResolution time is\n", attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 17)])
        if let value = HelpingClass.sharedInstance.convert(time: ETRvalue, fromFormate: "dd/MM/yyyy hh:mm a", toFormate:"dd/MM/yyyy" ),let valueTime = HelpingClass.sharedInstance.convert(time: ETRvalue, fromFormate: "dd/MM/yyyy hh:mm a", toFormate:"hh:mm a" ){
            
            let attributedDate = NSAttributedString(string: " \(value) by \(valueTime)", attributes:  [NSAttributedString.Key.font: UIFont(name: "HelveticaNeue-Bold", size: 20)!])
            attributedText.append(attributedDate)
        }
        
        isLanConnectedLabel.attributedText =  attributedText
        lanConnectedViewHeigh.constant = 250
    }
    func speedYes(){
        isLanConnectedLabel.text = messageDisc
        
        self.isLanConnectedView.isHidden = false
        self.isLanConnectedBacktoHomeView.isHidden = false
        
    }
    
    func lanSelected(){
        
       // isLanConnectedOKeyView.alpha = 0.8
       // isLanConnectedOKeyView.isUserInteractionEnabled = false
        self.infoButtonLan.isHidden = false
        self.isLanConnectedView.isHidden = false
        self.isLanConnectedBottomView.isHidden = false
        gostLabel.isHidden = false
        gostImageView.isHidden = false
    }
    
    
    
    func wifiSelected(){
        
        self.isWifiView.isHidden = false
        self.wifiNameLabel.text = wifiName
        self.strengthNameLabel.text = "\(strengthType)"
        bandSelectLabel.text = "Select the router"
        self.modenView.isHidden = false
        wifiNameCenterLayout.constant = 0
        gostLabel.isHidden = false
        gostImageView.isHidden = false
    }
    func wifiRangeSelected(){
        
        self.isWifiView.isHidden = false
        self.wifiNameLabel.text = wifiName
        self.strengthNameLabel.text = "\(strengthType)"
        bandSelectLabel.text = "Select the frequency band"
        self.bandView.isHidden = false
        wifiNameCenterLayout.constant = 0
        
    }
    
    func wifiCheckSpeedSelected(){
        
        
        if((strengthType == wifiSignalStength.excellent && bandType == wifiSignalFrequesncy.secondCase) ||  (strengthType.lowercased() == wifiSignalStength.excellent.lowercased() && bandType.lowercased() == wifiSignalFrequesncy.firstCase.lowercased())){
            wifiNameSpeedLabel.text = wifiName
            bandNameSpeedLabel.text = bandType
            strengthNameSpeedLabel.text =  "\(strengthType)"
            wifiOKeyView.alpha = 0.8
            wifiOKeyView.isUserInteractionEnabled = false
            wifiCheckSpeedView.isHidden = false
            bestTimeTextView.layer.borderColor = UIColor.gray.cgColor
            bestTimeTextView.layer.borderWidth = 1
            
        }
        else{
            
            
          
            self.isWifiBottonView.isHidden = true
            self.isWifiRangeSelectBottonView.isHidden = false
            self.isWifiView.isHidden = false
            self.wifiNameLabel.text = wifiName
            self.strengthNameLabel.text = "\(strengthType)"
            bandNameLabel.text = bandType
            bandNameLabel.isHidden = false
            self.bandView.isHidden = false
            wifiNameCenterLayout.constant = -50
            
           
            wifiTimerLabel.text = "02.00"
            seconds = 120
            timerFirst = Timer.scheduledTimer(timeInterval: 1, target: self,   selector: (#selector(AutoDetectionWIFIViewController.updateTimer)), userInfo: nil, repeats: true)
//            if(strengthType.lowercased() == wifiSignalStength.excellent.lowercased() && bandType.lowercased() == wifiSignalFrequesncy.firstCase.lowercased())
//            {
//                isWifiViewHeigh.constant = 230
//                fdIssueDescLabel.text = "Please shift to 5 GHz band."
//            }else
        if(strengthType.lowercased() == wifiSignalStength.weak.lowercased() && bandType.lowercased() == wifiSignalFrequesncy.firstCase.lowercased())
            {
                isWifiViewHeigh.constant = 270
                fdIssueDescLabel.text = "You are too far from the WiFi router. Please move closer for signal strength to become Good / Excellent. Also, please shift to 5 GHz band."
            }else if(strengthType.lowercased() == wifiSignalStength.weak.lowercased() && bandType.lowercased() == wifiSignalFrequesncy.secondCase.lowercased())
            {
                isWifiViewHeigh.constant = 270
                fdIssueDescLabel.text = "You are too far from the WiFi router. Please move closer for signal strength to become Good / Excellent."
            }
        }
        
       
    }
    
    func lanSelectedYes(){
        
        seconds = 120
        lanConnectedYesViewHeigh.constant = 160
        self.lanConnectedYesView.isHidden = false
        timerLabel.text = "02.00"
        timerFirst = Timer.scheduledTimer(timeInterval: 1, target: self,   selector: (#selector(AutoDetectionWIFIViewController.updateTimer)), userInfo: nil, repeats: true)
    }
    
    func lanSelectedNo(){
        self.lanConnectedNoView.isHidden = false
        
    }
    
    func lanSelectedYesTimerSet(){
        lanOKeyView.alpha = 0.8
        lanOKeyView.isUserInteractionEnabled = false
        timerLabel.text = "00.00"
        self.lanConnectedYesView.isHidden = false
        lanConnectedYesViewHeigh.constant = 480
        bestTimeLanTextView.layer.borderColor = UIColor.gray.cgColor
        bestTimeLanTextView.layer.borderWidth = 1
    }
    
    @objc func updateTimer() {
        if seconds == 0 {
            timerFirst?.invalidate()
            timerFirst = nil
            if(messageCode ==  NoInternetMessageCode.lanSelectedYes ){
                messageCode = NoInternetMessageCode.lanSelectedYesTimerSet
            }else{
                let service = WiFiInfoService()
                if let info = service.getWiFiInfo() {
                    
                    if info.rssi == wifiSignalStength.excellent{
                        
                        wifiName = info.networkName
                        strengthType = info.rssi
                        messageCode = NoInternetMessageCode.wifiCheckSpeedSelected
                        
                    }else{
                        messageCode = NoInternetMessageCode.lanSelectedNo
                        
                    }
                    
                }else{
                    
                    messageCode = NoInternetMessageCode.lanSelectedNo
                }
               //
                
            }
            setupUI()
            
            
            //Send alert to indicate "time's up!"
        } else if seconds > 0   {
            seconds -= 1
            timerLabel.text = timeString(time: TimeInterval(seconds))
            wifiTimerLabel.text = timeString(time: TimeInterval(seconds))
        }else{
            
            timerFirst?.invalidate()
            timerFirst = nil
        }
    }
    
    @IBAction func backBTN(_ sender: Any)
    {
        self.navigationController?.popViewController(animated: false)
    }
    
    @IBAction func isLanSelectedYesButton(_ sender: Any)
    {
        
        messageCode = NoInternetMessageCode.lanSelectedYes
        self.setupUI()
    }
    @IBAction func isLanSelectedNoButton(_ sender: Any)
    {
        messageCode = NoInternetMessageCode.lanSelectedNo
        self.setupUI()
        
    }
    
    @IBAction func okeyIsLanSelectedNoButton(_ sender: Any){
        AppDelegate.sharedInstance.navigateFrom=TabViewScreenName.sr
        navigateScreen(identifier: ViewIdentifier.customTabIdentifier, controller: CustomTabViewController.self)
        
    }
    
    @IBAction func okeyIsLanSelectedYesButton(_ sender: Any){
        
        
        if(lanMBBSTextField.text != ""){
            
            if let value = Int(lanMBBSTextField.text ?? ""){
                
                if(value > 0){
        
        self.upgradeAction(useKey: "speedOnLan", useValue: "\(value)")
                }else{
                    showAlertC(message: AlertViewMessage.enterDownloadingSpeed)
                    
                }
            }else{
                showAlertC(message: AlertViewMessage.enterDownloadingSpeed)
                
            }
        }else{
            
            showAlertC(message: AlertViewMessage.enterDownloadingSpeed)
        }
        
    }
    
    func upgradeAction(useKey:String,useValue:String){
        
        CANetworkManager.sharedInstance.progressHUD(show: true)
        
        let apiURL = ServiceMethods.serviceBaseFDSS + "/canId/\(canId)/voc/\(voc)"
        var dict = [useKey:useValue] as [String : Any]
        
        if(useKey == "speedOnLan"){
            if(bestTimeLanTextView.text != "" && bestTimeLanTextView.text != "hh:mm"){
                dict["comment"] = bestTimeLanTextView.text
            }
        }else{
        if(bestTimeTextView.text != "" && bestTimeTextView.text != "hh:mm"){
            dict["comment"] = bestTimeTextView.text
        }
        }
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
                        
                        if let  srNo = responce["srNo"] as? String{
                            self.srNo = srNo
                            
                        }
                        if let subSubType = responce["subType"] as? String,let problemType = responce["type"] as? String{
                            
                            self.typeSubype = problemType + "-" + subSubType
                            
                        }
                        
                        if let ETR = responce["etr"] as? String{
                            
                            self.ETRvalue = ETR
                            
                        }
                        
                        //"":"You
                        if let messageDescription = responce["messageDescription"] as? String{
                            
                            self.messageDisc = messageDescription
                            
                        }
                        
                        
                        
                        self.messageCode = messageCode
                        self.setupUI()
                        
                    }
                }
            }
            
            
            
        }
    }
    @IBAction func infoButtonClick(_ sender: Any)
    {
        infoView.isHidden = false
        
    }
    
    @IBAction func infoButtonCrossClick(_ sender: Any)
    {
        infoView.isHidden = true
        
    }
    @IBAction func okeyButtonAction(_ sender: Any){
        
        Switcher.updateRootVC()
        
    }
    @IBAction func intenoAction(_ sender: Any){
        
        
        bandType = wifiSignalFrequesncy.secondCase
        messageCode =  NoInternetMessageCode.wifiCheckSpeedSelected
        self.setupUI()
    }
    @IBAction func dlinkAction(_ sender: Any){
        messageCode = NoInternetMessageCode.wifiRangeSelected
        self.setupUI()
        
    }
    @IBAction func fiveGHZAction(_ sender: Any){
        
        bandType = wifiSignalFrequesncy.secondCase
        messageCode =  NoInternetMessageCode.wifiCheckSpeedSelected
        self.setupUI()
        
    }
    @IBAction func twoGHZAction(_ sender: Any){
        
        bandType = wifiSignalFrequesncy.firstCase
        messageCode =  NoInternetMessageCode.wifiCheckSpeedSelected
        self.setupUI()
        
    }
    
    @IBAction func speedTestAction(_ sender: Any){
        

        if let vc = UIStoryboard.init(name: "Storyboard", bundle: Bundle.main).instantiateViewController(withIdentifier: ViewIdentifier.testInternetIdentifier) as? TestInternetViewController{
            
            vc.mediaUrl = "http://fiber.spectra.co/"
                
        self.navigationController?.pushViewController(vc , animated: true)
        }
    }
    
    func timeString(time:TimeInterval) -> String {
        
        let minutes = Int(time) / 60 % 60
        let seconds = Int(time) % 60
        return String(format:"%02i:%02i",  minutes,seconds)
    }
    @IBAction func okeyWiFISelectedButton(_ sender: Any){
        
        if(wifiSpeedTextField.text != ""){
            
            if let value = Int(wifiSpeedTextField.text ?? ""){
                
                
                if(value > 0){
                if(bandType == wifiSignalFrequesncy.firstCase){
                    
                    //“speedOn2.4Ghz”:“15”
                    self.upgradeAction(useKey: "speedOn2.4Ghz", useValue: "\(value)")
                }else{
                    //“speedOn5Ghz”:“80”
                    self.upgradeAction(useKey: "speedOn5Ghz", useValue: "\(value)")
                }
                }else{
                    
                    showAlertC(message: AlertViewMessage.enterDownloadingSpeed)
                }
        
       
            }else{
                showAlertC(message: AlertViewMessage.enterDownloadingSpeed)
                
            }
        }else{
            
            showAlertC(message: AlertViewMessage.enterDownloadingSpeed)
        }
    }
    
    
    @IBAction func infoLanButtonClick(_ sender: Any)
    {
        infoViewLan.isHidden = false
        
    }
    
    @IBAction func infoLanButtonCloseClick(_ sender: Any)
    {
        infoViewLan.isHidden = true
        
    }
    
}
