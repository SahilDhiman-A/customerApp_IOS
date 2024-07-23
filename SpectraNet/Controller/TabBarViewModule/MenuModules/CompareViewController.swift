//
//  CompareViewController.swift
//  My Spectra
//
//  Created by Chakshu on 27/10/20.
//  Copyright © 2020 Bhoopendra. All rights reserved.
//

import UIKit

class CompareViewController: UIViewController {
    var dataResponse = NSDictionary()
    var checkStatus = String()
    var canID = String()
    var planID = String()
    var compareArray:[String] = [String]()
    @IBOutlet weak var selectPlanSecond: UIView!
    @IBOutlet weak var selectPlanFourth: UIView!
    @IBOutlet weak var selectPlanThird: UIView!
    @IBOutlet weak var selectPlanFirst: UIView!
    @IBOutlet weak var backgroundScrollView: UIScrollView!
    @IBOutlet weak var backbroundview: UIView!
    @IBOutlet weak var viewWidth: NSLayoutConstraint!
    @IBOutlet weak var transPrntView: UIView!
    var selectedPlan : ChangePlanData? = nil
    override func viewDidLoad() {
        super.viewDidLoad()
        comparePlanProccedFirbaseAnalysics()
        self.backbroundview.isHidden = true
       self.selectPlanFirst.layer.cornerRadius = (self.selectPlanFirst.frame.height / 2)
        self.selectPlanSecond.layer.cornerRadius = (self.selectPlanSecond.frame.height / 2)
        self.selectPlanThird.layer.cornerRadius = (self.selectPlanThird.frame.height / 2)
        self.selectPlanFourth.layer.cornerRadius = (self.selectPlanFourth.frame.height / 2)
        // Do any additional setup after loading the view.
    }
    func comparePlanProccedFirbaseAnalysics(){
            
                let dictAnalysics = [AnanlysicParameters.canID:canID,
                                     AnanlysicParameters.Category:AnalyticsEventsCategory.all_Menu
                                     ,AnanlysicParameters.Action:AnalyticsEventsActions.comparePlanProceedClicked
                                     ,AnanlysicParameters.EventType:AnanlysicParameters.ClickEvent]
                
                //,AnanlysicParameters.EventDescription:AnanlysicEventDescprion.loginwithUserNamePassword
            
               HelpingClass.sharedInstance.addFirebaseAnalysis(eventName: AnalyticsEventsName.Compare_Plan_Proceed, parameters: dictAnalysics as? [String:AnyObject] ?? [String:AnyObject]() )
        }
    
    override func viewWillAppear(_ animated: Bool) {
        self.compairionPlanAPIHit()
    }
    
    
  
    
    func compairionPlanAPIHit(){
        var width = 0
        let dict = ["Action":ActionKeys.comparisonPlan, "Authkey":UserAuthKEY.authKEY, "planIdList":compareArray] as [String : Any]
        print_debug(object: dict)
        CANetworkManager.sharedInstance.requestApi(serviceName: ServiceMethods.serviceBaseUatValue, method: kHTTPMethod.POST, postData: dict as Dictionary<String, AnyObject>) { (response, error) in
            
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
                    
                    self.backbroundview.isHidden = false
                    if let response =  self.dataResponse["response"] as? [AnyObject]{
                        
                       
                        
                        for (index, element) in response.enumerated() {
                          debugPrint("Item \(index): \(element)")
                            
                            let value = 10 + index
                            
                            if let view = self.backbroundview.viewWithTag(value){
                                
                                view.isHidden = false
                                if let subView = view.viewWithTag(value){
                                    
                                    if let speedView = subView.viewWithTag(100) as? UIView{
                                        
                                        if let speed =  element["speed"] as? String {
                                            
                                            
                                            for view in speedView.subviews{
                                                debugPrint("view \(view)")
                                                
                                                
                                                if let speedLabel = view as? UILabel{
                                                    
                                                    if(value == 10){
                                                        speedLabel.text = "Current Plan"
                                                        
                                                    }else{
                                                        if let name = element["description"] as? String {
                                                            speedLabel.text = name
                                                        } else {
                                                            speedLabel.text = "New Plan \(index)"
                                                        }
                                                        
                                                    }
                                                    
                                                    
                                                }
                                                
                                            }
                                            
                                               
                                            
                                        }
                                    }
                                    
                                    if let speedView = subView.viewWithTag(200) as? UIView{
                                        
                                        if let speed =  element["speed"] as? String {
                                            
                                            
                                            for view in speedView.subviews{
                                                debugPrint("view \(view)")
                                                
                                                
                                                if let speedLabel = view as? UILabel{
                                                    speedLabel.text = speed
                                                    if  let font = UIFont(name: "Helvetica", size: 14.0){
                                                        speedLabel.font = font
                                                    }
                                                    
                                                }
                                                
                                            }
                                            
                                               
                                            
                                        }
                                    }
                                        
                                        if let dataView = subView.viewWithTag(300) as? UIView{

                                            if let data =  element["data"] as? String {

                                                for view in dataView.subviews{
                                                    debugPrint("view \(view)")
                                                    
                                                    
                                                    if let dataLabel = view as? UILabel{
                                                        dataLabel.text = data
                                                        
                                                        if  let font = UIFont(name: "Helvetica", size: 14.0){
                                                            dataLabel.font = font
                                                        }
                                                        
                                                    }
                                                    
                                                }
                                               

                                            }
                                        }


                                            if let chargesView = subView.viewWithTag(400) as? UIView{

                                                if let charges =  element["charges"] as? String {

                                                    for view in chargesView.subviews{
                                                        debugPrint("view \(view)")
                                                        
                                                        
                                                        if let chargesLabel = view as? UILabel{
                                                            chargesLabel.text = charges
                                                            if  let font = UIFont(name: "Helvetica", size: 14.0){
                                                                chargesLabel.font = font
                                                            }
                                                        }
                                                        
                                                    }
                                                   

                                                }
                                            }

                                            if let frequencyView = subView.viewWithTag(500) as? UIView{

                                                if let frequency =  element["frequency"] as? String {


                                                    for view in frequencyView.subviews{
                                                        debugPrint("view \(view)")
                                                        
                                                        
                                                        if let frequencyLabel = view as? UILabel{
                                                            frequencyLabel.text = frequency
                                                            if  let font = UIFont(name: "Helvetica", size: 14.0){
                                                                frequencyLabel.font = font
                                                            }
                                                        }
                                                        
                                                    }

                                                }
                                            }
                                    
                                    if let specialBenefitView = subView.viewWithTag(600) as? UIView{
                                        
                                        var string = "NA"

                                        if let specialBenefit =  element["specialBenefit"] as? String {

                                            string = specialBenefit
                                            
                                                
                                            }
                                        
                                        for view in specialBenefitView.subviews{
                                            debugPrint("view \(view)")
                                            
                                            
                                            if let frequencyLabel = view as? UILabel{
                                                frequencyLabel.text = string
                                                if  let font = UIFont(name: "Helvetica", size: 14.0){
                                                    frequencyLabel.font = font
                                                }
                                            }

                                        }
                                    }

                                        
                                        
                                    }
                                    
                                }
                            }
                        
                        width = 133 * (response.count + 1)
                        self.viewWidth.constant = CGFloat(width)
                        self.backgroundScrollView.contentSize = CGSize(width:CGFloat(width + 60), height:self.view.frame.size.height - 70)
                        }
                    
                   
                   
                    }
                else
                {
                    self.showSimpleAlert(TitaleName: "", withMessage: "Oops! Something has gone wrong. Try after some time.")
                }
            }
        }
    
    }
    func showSimpleAlert(TitaleName: String, withMessage: String)
    {
        let alert = UIAlertController(title: TitaleName, message: withMessage,preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: AlertViewButtonTitle.title_OK,style: UIAlertAction.Style.default,handler: {(_: UIAlertAction!) in
            
        }))
        self.present(alert, animated: true, completion: nil)
    }
    @IBAction func backBTN(_ sender: Any)
    {
        self.navigationController?.popViewController(animated: false)
    }
    
    
    
    @IBAction func selectPlanClicked(_ sender: UIButton) {
        if let response =  self.dataResponse["response"] as? [AnyObject]{
            if(response.count > sender.tag){
                if let value = response[sender.tag] as? [String:AnyObject]{
                    if let planid = value["planid"] as? String{
                        planID = planid
                        transPrntView.isHidden = false
                        
                    }
                }
            }
        }
    }
    
    
    @IBAction func cancelPlanBtn(_ sender: Any)
    {
        transPrntView.isHidden = true
       
    }
    
    @IBAction func changePlanBTN(_ sender: Any)
       {
           serviceTypeProDataChargesForPlan()
       }
    
    
    func serviceTypeProDataChargesForPlan()
      {
          
          let dict = ["Action":ActionKeys.proDataChargesForPlan, "Authkey":UserAuthKEY.authKEY, "canId":canID, "planId":planID]
          print_debug(object: dict)
          CANetworkManager.sharedInstance.requestApi(serviceName: ServiceMethods.serviceBaseUatValue, method: kHTTPMethod.POST, postData: dict as Dictionary<String, AnyObject>) { (response, error) in
              
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
                      if let response =  self.dataResponse["response"] as? [String:AnyObject]{
                          
                          self.transPrntView.isHidden = true
                          let vc = UIStoryboard.init(name: "Storyboard", bundle: Bundle.main).instantiateViewController(withIdentifier: ViewIdentifier.ChangePlanCompareViewController) as? ChangePlanCompareViewController
                          vc?.differenceResponce = response
                          vc?.canID = self.canID
                          vc?.pckgID = self.planID
                        vc?.data =  self.selectedPlan?.data ?? ""
                        vc?.spead =  self.selectedPlan?.speed ?? ""
                        vc?.frequency = self.selectedPlan?.frequency ?? ""
                          self.navigationController?.pushViewController(vc!, animated: false)
                      
                      
                  }
                  else
                  {
                      
                  }
                  
                  }
                  else
                  {
                      let string = self.dataResponse.value(forKey: "message") as? String
                      self.showSimpleAlert(TitaleName: "", withMessage: string ?? "")
                      
                      
                  }
              }
          }
          
      }
    
    @IBAction func knowMoreButtonClick(_ sender: UIButton)
    {
        if let response =  self.dataResponse["response"] as? [AnyObject]{
            
            
            if(response.count > sender.tag){
                
                if let value = response[sender.tag] as? [String:AnyObject]{
                    
                    if let planid = value["planid"] as? String{
                        
                        self.knowMoreViewAdd(planId: planid)
                    }
                }
            }
            
        }
    }
    func knowMoreViewAdd(planId:String) {
        let vc = UIStoryboard.init(name: "Storyboard", bundle: Bundle.main).instantiateViewController(withIdentifier: ViewIdentifier.KnowMoreIdentifier) as? KnowMoreViewController
        vc?.canID = canID
        vc?.planId = planId
        //vc?.knowMoreObject = knowMoreObject
        self.present(vc ?? UIViewController(), animated: false, completion: nil)
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
