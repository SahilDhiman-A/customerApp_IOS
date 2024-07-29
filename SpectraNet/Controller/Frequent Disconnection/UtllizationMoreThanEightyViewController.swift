//
//  UtllizationMoreThanEightyViewController.swift
//  My Spectra
//
//  Created by Chakshu on 16/09/20.
//  Copyright © 2020 Bhoopendra. All rights reserved.
//

import UIKit
import ABGaugeViewKit

class UtllizationMoreThanEightyViewController: UIViewController {
    
    @IBOutlet weak var meterView: ABGaugeView!
    @IBOutlet weak var UtllizationMoreThanEightyView: UIView!
    @IBOutlet weak var UtllizationMoreThanEightyYesView: UIView!
    @IBOutlet weak var UtllizationMoreThanEightyNoView: UIView!
    @IBOutlet weak var srNumberLabel: UILabel!
    var voc = String()
    var canId = String()
    var messageCode = String()
    var srNo = ""
    var utilizationPercentage:Double = 0
    override func viewDidLoad() {
        super.viewDidLoad()
        
        meterView.isHidden = true
        meterView.blinkAnimate = false
        self.setupUI()
        // Do any additional setup after loading the view.
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        meterView.isHidden = false
        
        super.viewDidAppear(animated)
    }
    
    func setupUI()  {
        self.UtllizationMoreThanEightyView.isHidden = true
        UtllizationMoreThanEightyYesView.isHidden = true
        UtllizationMoreThanEightyNoView.isHidden = true
        switch messageCode {
        case NoInternetMessageCode.UtilisationMoreThen80:
            self.UtllizationMoreThanEightyView.isHidden = false
            meterView.needleValue = CGFloat(utilizationPercentage)
            
            break
        case NoInternetMessageCode.UpgardeYes:
            srNumberLabel.text = "Your Service request no is \(srNo)"
            UtllizationMoreThanEightyYesView.isHidden = false
            break
        case NoInternetMessageCode.UpgardeNo:
            UtllizationMoreThanEightyNoView.isHidden = false
            break
        default: break
            
        }
        
        
    }
    
    @IBAction func backBTN(_ sender: Any)
    {
        self.navigationController?.popViewController(animated: false)
    }
    
    @IBAction func yesButtonClick(_ sender: Any){
        self.upgradeAction(useKey: "isUpgradeBandwidth", useValue: "Yes")
    }
    
    @IBAction func noButtonClick(_ sender: Any){
        
        self.upgradeAction(useKey: "isUpgradeBandwidth", useValue: "No")
        
        
    }
    func upgradeAction(useKey:String,useValue:String){
        
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
                        
                        if let  srNo = responce["srNo"] as? String{
                            self.srNo = srNo
                            
                        }
                        
                        self.messageCode = messageCode
                        self.setupUI()
                        
                    }
                }
            }
            
            
            
        }
    }
    @IBAction func okeyButtonAction(_ sender: Any){
        
        Switcher.updateRootVC()
        
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
