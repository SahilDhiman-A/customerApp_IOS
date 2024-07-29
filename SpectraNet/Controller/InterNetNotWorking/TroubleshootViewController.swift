//
//  TroubleshootViewController.swift
//  My Spectra
//
//  Created by Chakshu on 31/03/20.
//  Copyright © 2020 Bhoopendra. All rights reserved.
//

import UIKit
import SwiftGifOrigin

class TroubleshootViewController: UIViewController {
    
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var descptionLabel: UILabel!
    @IBOutlet weak var progressView: UIView!
     @IBOutlet weak var progressImageView: UIImageView!
    @IBOutlet weak var descptionTextView: UIImageView!
    @IBOutlet weak var textViewBackgroundHeight: NSLayoutConstraint!
    @IBOutlet weak var textViewHeight: NSLayoutConstraint!
     @IBOutlet weak var backgroundScrollView: UIScrollView!
     var canID = String()
    override func viewDidLoad() {
        super.viewDidLoad()
 progressView.isHidden = true
 progressImageView.isHidden = true
 progressImageView.loadGif(name: "loader_1")
        backgroundScrollView.isScrollEnabled = false
        // Do any additional setup after loading the view.
    }
    

    @IBAction func troubleshootAction(_ sender: Any) {
        
        self.troubleshoot()
        
    }
    @IBAction func backBTN(_ sender: Any)
    {
        self.navigationController?.popViewController(animated: false)
    }
    override func viewWillLayoutSubviews() {
           if  let font = UIFont(name: "Helvetica", size: 17.0){
            
            let text = """
            Sorry to hear that you are experiencing a network issue.

             While we identify the issue please ensure that you are connected to mobile network for effective troubleshooting side by side.

            Also, ensure your ONT & Router/ ONT & Switch are connected.
"""

            let height = HelpingClass.sharedInstance.heightForView(text:text, font: font, width: self.view.frame.width - 120)
               textViewHeight.constant = height
            textViewBackgroundHeight.constant = height + 100
            
            if(self.view.frame.size.height <= 568)
            {
                textView.font = UIFont(name: "Helvetica", size: 14.0)
                
    self.textViewBackgroundHeight.constant = height
    self.backgroundScrollView.isScrollEnabled = true
            }
            
            backgroundScrollView.contentSize = CGSize(width: self.view.frame.size.width, height: textViewHeight.constant + 200)
           }
        
           
           super.viewWillLayoutSubviews()
       }
    
          func troubleshoot()
          {
                         URLCache.shared.removeAllCachedResponses()
                          progressImageView.loadGif(name: "loader_1")
                         // self.canID = "9053646"
                          progressView.isHidden = false
                          progressImageView.isHidden = false
                          let apiURL = ServiceMethods.serviceBaseURLInternetNotWorking + UserAuthKEY.authKEYInternetNotWorking + "/" + ServiceKeys.canId + "/" +  self.canID  
                   
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
                                                
                                                
            case NoInternetMessageCode.accountActiveFlag, NoInternetMessageCode.accountRecativeFlag, NoInternetMessageCode.OutstandingBalanceFlag,NoInternetMessageCode.serviceBar,NoInternetMessageCode.SafeCustody,NoInternetMessageCode.massOutrage:
                                               
                                               
                                                       
                                                      
                                                           
                                                           
                            if   let vc = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: ViewIdentifier.OutstandingBalancePaymentIdentifier) as? OutstandingBalancePaymentViewController{
                                
                                
                            if let outstandingAount = responce["outstandingAmount"] as? AnyObject{
                                
                                
                                
                                    vc.outStandingAmount = "\(outstandingAount)"
                                        }
                                
                            if let description = responce["messageDescription"] as? String{
                                vc.desctptionText = description
                                                       
                                        }
                        if let previousPlan = responce["Product"] as? String{
                                        vc.previousPlan = previousPlan
                                                                                
                                            }
                                                           
                            if let dueDate = responce["dueDate"] as? String{
                                vc.dueDateString = dueDate
                                    }
                                
                                if let dueDate = responce["etr"] as? String{
                                        vc.dueDateString = dueDate
                                }
                                            
                                
                                
                                if let invoiceList = responce["invoiceList"] as? [String:AnyObject]{
                                                                
                                    vc.invoice =   invoiceList
                                }
                                
                        if let endDate = responce["endDate"] as? String{
                                vc.endDate = endDate
                                                                                                                                                                            }
                                                           
                                                           
                                                           
                                             vc.messageCode = messageCode
                                  
                                    vc.canId = self.canID
                            self.navigationController?.pushViewController(vc, animated: false)
                                                }
                                                           
                case NoInternetMessageCode.GPONNON, NoInternetMessageCode.GPON,NoInternetMessageCode.GPONNoIssue,NoInternetMessageCode.partner,NoInternetMessageCode.GPON40:
                    
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
                                    
                                    
                                    
                                    vc.messageCode = messageCode
                                    vc.canId = self.canID
                                    
                                    if let productSegment = responce["productSegment"] as? String{
                                        if productSegment == "Partner"{
                                            
                                             vc.messageCode = productSegment
                                        }
                                         
                                    }
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
            
            
                                                
                                            default:
                                            break
                                                       
                                        }
                                               
                                    }
                                                       
                                                   
                                               }
                                               
                                              
                                               
                                              }else{
                                                
                                                self.progressView.isHidden = true
                                                self.progressImageView.isHidden = true
            //                                   self.showViews(withBool: false)
            //                                   self.createdSRNmbrLBL.text = String(format: "%@", (dataResponse.value(forKey: "message") as? String)!)
                                           }
                                           

                                          }else{
                                            
                                                           self.progressView.isHidden = true
                                                                                  self.progressImageView.isHidden = true
                                }
                                   
                                   
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
