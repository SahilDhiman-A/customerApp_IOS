//
//  KnowMoreViewController.swift
//  My Spectra
//
//  Created by Chakshu on 26/10/20.
//  Copyright © 2020 Bhoopendra. All rights reserved.
//

import UIKit

class KnowMoreViewController: UIViewController , UITableViewDelegate, UITableViewDataSource{
    var dataResponse = NSDictionary()
    var checkStatus = String()
   
    @IBOutlet weak var knowMoreTableView: UITableView!
    @IBOutlet weak var knowMoreView: UIView!
    var canID = String()
    var knowMoreObject:KnowMore?
    var  planId = String()
    @IBOutlet weak var viewHeight: NSLayoutConstraint!
    override func viewDidLoad() {
        super.viewDidLoad()

        self.knowMoreButtonclick()
        self.knowMoreTableView.isHidden = true
        self.knowMoreView.isHidden = true
        // Do any additional setup after loading the view.
    }
    
    
    func knowMoreButtonclick(){
        
        let dict = ["Action":ActionKeys.knowMoreForPlan, "Authkey":UserAuthKEY.authKEY, "planId":planId]
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
                    
                    if let consultationData = try? JSONSerialization.data(withJSONObject:  self.dataResponse, options: []) {
                        
                        let consultations = try? JSONDecoder().decode(KnowMore.self, from: consultationData)
                        
                        print_debug(object: "consultations = \(String(describing: consultations))")
                        self.knowMoreObject = consultations
                        if(self.knowMoreObject != nil){
                          
                           
                            var heightValue = 0
                            if  let font = UIFont(name: "Helvetica", size: 15.0){
                                
                                let value = self.view.frame.width - 40
                                heightValue = Int(HelpingClass.sharedInstance.heightForView(text:  self.knowMoreObject?.response.planDescription ?? "", font: font, width: value))
                            }
                            var height = 0
                            height = (self.knowMoreObject?.response.contentText.count ?? 0) * 120 + heightValue + 65
                            
                            if(height > Int(self.view.frame.height - 40)){
                                
                                height = Int(self.view.frame.height - 40)
                                self.knowMoreTableView.isScrollEnabled = true
                            }else{
                                self.knowMoreTableView.isScrollEnabled = false
                            }
                            self.viewHeight.constant = CGFloat(height)
                            self.knowMoreTableView.reloadData()
                            self.knowMoreTableView.isHidden = false
                            self.knowMoreView.isHidden = false
                        }
                    }
                    
                }
                else
                {
                   // self.showSimpleAlert(TitaleName: "", withMessage: "Oops! Something has gone wrong. Try after some time.")
                }
            }
        }
    
    }
    @IBAction func knowMoreCancelButtonClick(sender: UIButton!) {
        self.dismiss(animated: true, completion: nil)
        
    }
    
    override func viewDidLayoutSubviews() {
        
        
        super.viewDidLayoutSubviews()
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
      
        return (knowMoreObject?.response.contentText.count  ?? 0) + 1
            
        
        
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        
        if(indexPath.row == 0){
            
            var cell : KnowMoreTopTableViewCell? = (tableView.dequeueReusableCell(withIdentifier: TableViewCellName.KnowMoreTopIdenTifier) as! KnowMoreTopTableViewCell)
            
            if cell == nil {
                cell = (tableView.dequeueReusableCell(withIdentifier: TableViewCellName.KnowMoreTopIdenTifier) as! KnowMoreTopTableViewCell)
            }
            cell?.destLabel.text = knowMoreObject?.response.planDescription
           // cell?.destLabel.textColor = UIColor.black
            return cell!
            
        }else{
        
        
        var cell : KnowMoreBottonTableViewCell? = (tableView.dequeueReusableCell(withIdentifier: TableViewCellName.KnowMoreBottonIdentifier) as! KnowMoreBottonTableViewCell)
        
        if cell == nil {
            cell = (tableView.dequeueReusableCell(withIdentifier: TableViewCellName.KnowMoreBottonIdentifier) as! KnowMoreBottonTableViewCell)
        }
            
            if((knowMoreObject?.response.contentText.count ?? 0) + 1 > indexPath.row){
            if let value = knowMoreObject?.response.contentText[indexPath.row - 1]{
                
                cell?.titleLabel.text = value.title
                cell?.subTitleLabel.text = value.content
                
                if let imagename = value.iconID as? String{
                    
                    if let image =  UIImage(named: "Spectra Brand Guidelines V2-\(imagename)"){
                        cell?.iconImageView.image = image
                    }else{
                    
                    cell?.iconImageView.image = UIImage(named: "Spectra Brand Guidelines V2-1")
                    }
                }
            }
            }
            
          
      
        
        return cell!
        }
        
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        if(indexPath.row == 0){
            if  let font = UIFont(name: "Helvetica", size: 15){
                
                let value = self.view.frame.width - 60
                return HelpingClass.sharedInstance.heightForView(text:  knowMoreObject?.response.planDescription ?? "", font: font, width: value) + 40
            }
            return 100
        }else{
            
            return 100
        }
        
    }
    
    
//    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        
//        return UITableView.automaticDimension
//    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
