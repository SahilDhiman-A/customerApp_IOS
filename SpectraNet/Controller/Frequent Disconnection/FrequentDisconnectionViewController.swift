//
//  FrequentDisconnectionViewController.swift
//  My Spectra
//
//  Created by Chakshu on 14/09/20.
//  Copyright © 2020 Bhoopendra. All rights reserved.
//

import UIKit
import CoreLocation

class FrequentDisconnectionViewController: UIViewController {
    
    @IBOutlet weak var progressView: UIView!
    @IBOutlet weak var infoView: UIView!
    
    @IBOutlet weak var progressImageView: UIImageView!
    @IBOutlet weak var ghostImageView: UIImageView!
    @IBOutlet weak var trobleshootTextView: UITextView!
    @IBOutlet weak var titleLabel: UILabel!
    var canID = String()
    var voc = String()
    let locationManager = CLLocationManager()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        progressView.isHidden = true
        progressImageView.isHidden = true
        progressImageView.loadGif(name: "loader_1")
        
        if(voc == "3"){
            
            titleLabel.text = "I am facing slow speed"
            ghostImageView.image = UIImage(named:"slow")
            trobleshootTextView.text = "Sorry to hear that.\n \n \n Please ensure your ONT (White box) is properly plugged in and connected to Spectra WiFi Router/Switch while we troubleshoot."
        }else{
            titleLabel.text = "I am facing frequent disconnection"
            ghostImageView.image = UIImage(named:"unlink")
            trobleshootTextView.text = "Sorry to hear that.\n \n \n Please ensure your ONT (White box) is properly plugged in and connected to Spectra WiFi Router/Switch while we troubleshoot."
        }
        
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
       
        
       
        locationManager.requestAlwaysAuthorization()
       // locationManager.requestWhenInUseAuthorization()
           
    }
    @IBAction func troubleshootAction(_ sender: Any) {
        
        self.troubleshoot()
       
        
    }
    func troubleshoot()
    {
        URLCache.shared.removeAllCachedResponses()
       // progressImageView.loadGif(name: "loader_1")
       //self.canID = "209903" //188526 //"188500" //188705 //9019453 //188526//188346 //9053646 //167238 //9056012 //9066601 //209903 //160915
        progressView.isHidden = false
        progressImageView.isHidden = false
        let apiURL = ServiceMethods.serviceBaseFDSS + "/canId/\(canID)/voc/\(voc)"
        print_debug(object: "apiURL =" + apiURL)
        CANetworkManager.sharedInstance.requestApiWithoutHUD(serviceName: apiURL, method: kHTTPMethod.GET, postData: [:] as Dictionary<String, AnyObject>) { (response, error) in
            
            print_debug(object: response)
            DispatchQueue.main.async {
                self.progressImageView.loadGif(name: "loader_2")
            }
            
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.5, execute: {
                self.setUPView(response: response)
            })
            
        }
    }
    
    func setUPView(response:AnyObject?){
        
        if response != nil
        {
            self.progressView.isHidden = true
            self.progressImageView.isHidden = true
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
                        
                        
                        
                        switch messageCode {
                        
                        //,NoInternetMessageCode.OpenSR
                        
                        case NoInternetMessageCode.autoDetectionWIFI:
                            if let vc = UIStoryboard.init(name: "Storyboard", bundle: Bundle.main).instantiateViewController(withIdentifier: ViewIdentifier.AutoDetectionWIFIViewController) as? AutoDetectionWIFIViewController{
                                
                                vc.voc = voc
                                vc.messageCode = messageCode
                                vc.canId = self.canID
                                self.navigationController?.pushViewController(vc, animated: false)
                            }
                        case NoInternetMessageCode.GPON40DGIFD,NoInternetMessageCode.wANlightPAtner:
                            
                            if let vc = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: ViewIdentifier.NONGPONViewControllerIdentifier) as? NONGPONViewController
                            {
                                
                                if let srNo = responce["srNo"] as? String{
                                    vc.srNo = srNo
                                    
                                }
                                
                                if let powerLevel = responce["powerLevel"] as? String{
                                    vc.powerLevel = powerLevel
                                    
                                }
                                if let alarmType = responce["alarmType"] as? String{
                                    vc.alarmType = alarmType
                                    
                                }
                                
                                vc.voc = voc
                                vc.messageCode = messageCode
                                vc.canId = self.canID
                                
                                
                                self.navigationController?.pushViewController(vc, animated: false)
                            }
                            
                            break
                        case NoInternetMessageCode.UtilisationMoreThen80:
                            
                            if let vc = UIStoryboard.init(name: "Storyboard", bundle: Bundle.main).instantiateViewController(withIdentifier: ViewIdentifier.UtllizationMoreThanEightyViewController) as? UtllizationMoreThanEightyViewController{
                                
                                vc.messageCode = messageCode
                                vc.voc = voc
                                vc.canId = self.canID
                                if let utilizationPercentage = responce["utilizationPercentage"] as? Double{
                                    vc.utilizationPercentage = utilizationPercentage
                                }
                                self.navigationController?.pushViewController(vc, animated: false)
                                
                            }
                            
                        case NoInternetMessageCode.FUPFlag,NoInternetMessageCode.massOutrage,NoInternetMessageCode.FDSSSRRaised:
                            if let vc = UIStoryboard.init(name: "Storyboard", bundle: Bundle.main).instantiateViewController(withIdentifier: ViewIdentifier.FrequentlyDisconnectCasesViewController) as? FrequentlyDisconnectCasesViewController{
                                
                                vc.messageCode = messageCode
                                vc.voc = voc
                                if let dueDate = responce["dueDate"] as? String{
                                    vc.dueDateString = dueDate
                                }
                                
                                if let dueDate = responce["etr"] as? String{
                                    vc.dueDateString = dueDate
                                }
                                if let srNo = responce["srNo"] as? String{
                                    vc.srNo = srNo
                                }
                                
                                if let srNo = responce["srNo"] as? String{
                                    vc.srNo = srNo
                                }
                                
                                if let subSubType = responce["subType"] as? String,let problemType = responce["type"] as? String{
                                    
                                    vc.typeSubype = problemType + "-" + subSubType
                                    
                                }
                                
                                if let ETR = responce["etr"] as? String{
                                    
                                    vc.ETRvalue = ETR
                                    
                                }
                                if let  fupSpeed = responce["consumedVolume"] as? String{
                                    vc.consumedVolume = fupSpeed
                                }
                                   
                                if let powerLevel = responce["powerLevel"] as? String{
                                    vc.powerLevel = powerLevel
                                }
                                vc.canId = self.canID
                                self.navigationController?.pushViewController(vc, animated: false)
                                
                            }
                            
                            
                            
                        case NoInternetMessageCode.OpenSR:
                            
                            if let vc = UIStoryboard.init(name: "Storyboard", bundle: Bundle.main).instantiateViewController(withIdentifier: ViewIdentifier.OpenSRViewControllerIdentifier) as? OpenSRViewController
                            {
                                
                                vc.messageCode = messageCode
                                
                                vc.canId = self.canID
                                
                                if let srNo = responce["srNo"] as? String{
                                    vc.srNo = srNo
                                }
                                self.navigationController?.pushViewController(vc, animated: false)
                                
                                
                                
                            }
                            
                        default: break
                            
                            
                        }
                    }
                }
            }
        }
    }
    
    
    
    @IBAction func backBTN(_ sender: Any)
    {
        self.navigationController?.popViewController(animated: false)
    }
    @IBAction func infoButtonClick(_ sender: Any){
        infoView.isHidden = false
        
    }
    @IBAction func infoButtonCrossClick(_ sender: Any){
        infoView.isHidden = true
        
    }
    
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
}
