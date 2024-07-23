//
//  OpenSRViewController.swift
//  My Spectra
//
//  Created by Chakshu on 14/05/20.
//  Copyright © 2020 Bhoopendra. All rights reserved.
//

import UIKit

class OpenSRViewController: UIViewController {

    @IBOutlet weak var mainViewConstain: NSLayoutConstraint!
    
    @IBOutlet weak var topViewConstain: NSLayoutConstraint!
    @IBOutlet weak var titleConstain: NSLayoutConstraint!
    @IBOutlet weak var knowViewHeightConstain: NSLayoutConstraint!
    @IBOutlet weak var descrtionHeightConstain: NSLayoutConstraint!
    @IBOutlet weak var descptionView: UIView!
    var messageCode = String()
    var canId = String()
    var srNo = "";
    var ETRvalue = "";
    @IBOutlet weak var backgroundScrollView: UIScrollView!
    @IBOutlet weak var srNumberLabel: UILabel!
    @IBOutlet weak var createDateLabel: UILabel!
    @IBOutlet weak var problemTypeLabel: UILabel!
    @IBOutlet weak var createTimeLabel: UILabel!
    @IBOutlet weak var problemSubtype: UILabel!
    @IBOutlet weak var descptionLabel: UILabel!
    @IBOutlet weak var etrResolutionTime : UILabel!

   
       var typeSubype = ""
    override func viewDidLoad() {
        
        
        super.viewDidLoad()
        backgroundScrollView.isHidden = true
        CANetworkManager.sharedInstance.progressHUD(show: true)
        self.serviceTypeGetSRStatus(useKey: "srNumber", useNumber: self.srNo)
        // Do any additional setup after loading the view.
    }
     override func viewWillLayoutSubviews() {
              
    
       if(self.view.frame.size.height <= 568){
            
            titleConstain.constant = 20
            topViewConstain.constant = 0
            mainViewConstain.constant = 450
        if(self.view.frame.size.height <= 480){
            titleConstain.constant = 10
            topViewConstain.constant = 0
            mainViewConstain.constant = 300
            
            
        }
        }
               super.viewWillLayoutSubviews()
         self.backgroundScrollView.contentSize = CGSize(width: self.view.frame.size.width, height: 10000)
           }

    func serviceTypeGetSRStatus(useKey: String, useNumber: String)
       {
           let dict = ["Action":ActionKeys.checkSR, "Authkey":UserAuthKEY.authKEY, useKey:useNumber,"canId":canId]
           print_debug(object: dict)
           CANetworkManager.sharedInstance.requestApiWithoutHUD(serviceName: ServiceMethods.serviceBaseUatValue, method: kHTTPMethod.POST, postData: dict as Dictionary<String, AnyObject>) { (response, error) in
               
               print_debug(object: response)
            
            CANetworkManager.sharedInstance.progressHUD(show: false)
            
            if response != nil
            {
                
                if let status = response?["status"] as? String{
                    
                    
                    if status.lowercased() == Server.api_status{
                        
                        
                        if let array = response?["response"] as? [[String:AnyObject]]{
                            
                            
                            if array.count > 0 {
                                
                                self.backgroundScrollView.isHidden = false
                                if let value = array[0] as? [String:AnyObject]{
                                    
                                    if let ETR = value["SRstatusETR"] as? String{
                                        if let value = HelpingClass.sharedInstance.convert(time: ETR, fromFormate: "dd/MM/yyyy hh:mm a", toFormate:"dd-MM-yyyy" ){
                                            
                                            if let valueData = HelpingClass.sharedInstance.convert(time: ETR, fromFormate: "dd/MM/yyyy hh:mm a", toFormate:"hh:mm a" ){
                                                self.etrResolutionTime.text = value + "  at " + valueData
                                            }
                                            
                                                                                   
                                                    }
                                       
                                       
                                    }
                                    
                                    if let lastUpdatedOn = value["createdon"] as? String{
                                if let value = HelpingClass.sharedInstance.convert(time: lastUpdatedOn, fromFormate: "dd/MM/yyyy hh:mm a", toFormate:"dd-MM-yyyy" ){
                                        self.createDateLabel.text = value
                                                                                                                      }
                                        if let value = HelpingClass.sharedInstance.convert(time: lastUpdatedOn, fromFormate: "dd/MM/yyyy hh:mm a", toFormate:"hh:mm a" ){
                                                        self.createTimeLabel.text = value
                                                                                                                                                             }
                                                                          
                                                                          
                                                                       }
                                    
                                    if let srNumber = value["srNumber"] as? String{
                                        self.srNumberLabel.text = srNumber
                                       
                                    }
                                    if let problemType = value["problemType"] as? String{
                                        self.problemTypeLabel.text = problemType
                                                                          
                                    }
                                    if let subSubType = value["subType"] as? String{
                                        self.problemSubtype.text = subSubType
                                                                          
                                    }
                                    
                                        if let messageTemplate = value["MessageTemplate"] as? String{
                                            
                                            let value = messageTemplate
                                            
                                            //let value =  "wdojjoiwnklwdnk jwdbj jdwbjdwjbkdwjkjkbdwbjkdbjwkbjkdwjbkdwbjkdbjwkbjdkwbjdwbjwbjdjbkwdjkbwjdbbwjd dwjkd wjdwbkdjwbdkjbdkjdwbwdjbwkjjbwbwjbwjbkwjbkbjkwqbjkwbjkbjkwqbjkdqwbjkbjkwd d kjwd wdmnd wj dnw "
                                            
                                            if  let font = UIFont(name: "Helvetica", size: 17.0){
                                                           
                                            var height = HelpingClass.sharedInstance.heightForView(text:value, font: font, width: self.view.frame.width - 100)
                                                
                                                if(height>0){
                                                    
                                                    if height > 80{
                                                        height = 80
                                                    }
                                    self.knowViewHeightConstain.constant = 600 + height + 40
                                    self.descrtionHeightConstain.constant = height + 20 + 10
                                    self.descptionView.isHidden = false
                                    self.view.layoutIfNeeded()
                                                }
                                                else
                                                {
                                    self.descrtionHeightConstain.constant = 0
                                    self.knowViewHeightConstain.constant = 430 + 40
                                    self.descptionView.isHidden = true
                                    self.view.layoutIfNeeded()
                                                }
                                                
                                              
                                                
                                            }
                                           self.descptionLabel.text = value
                                                                              
                                        }
                                   
                                   DispatchQueue.main.async {
                                      self.backgroundScrollView.contentSize = CGSize(width: self.view.frame.size.width, height: 10000)
                                   }
                                    
                                    
                                }
                                
                                
                            }
                            
                            
                            
                        }
                        
                    }
                }
                
                
                 
           }
       }
    }
    
    @IBAction func backToHome(_ sender: Any)
      {
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
