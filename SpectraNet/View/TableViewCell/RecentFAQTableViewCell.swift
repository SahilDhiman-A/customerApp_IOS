//
//  RecentFAQTableViewCell.swift
//  My Spectra
//
//  Created by Chakshu on 23/09/21.
//  Copyright © 2021 Bhoopendra. All rights reserved.
//

import UIKit

class RecentFAQTableViewCell: UITableViewCell {
    var canID = String()
    var faqFullValue:FAQCategory?
    var data = [FAQ]()
    var faqUseful = 0
    var selectedIndexValue = -1
    var selectedSubIndexValue = -1
    var faqSelect:((Int) -> Void)? = nil
    var upDownWordCardClick:((Int,Int) -> Void)? = nil
    var downRatingClick:((Int) -> Void)? = nil
    var selectUpValue:((Int) -> Void)? = nil
    @IBOutlet weak var faqTableView: UITableView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    func setValueInCell(faqValue:[FAQ]){
        self.data = faqValue
        faqTableView.reloadData()
    }
    @IBAction func selectButtonClick(_ button: UIButton)
    {
        if let clouser = faqSelect{
            clouser(button.tag)
        }
    }
    func calculateHeight(){
        var const =  0
        for value in self.data{
            let size = value.question?.heightWithConstrainedWidth(width: UIScreen.main.bounds.width - 120, font: UIFont(name: "HelveticaNeue-Bold", size: 16.0)!)
            const = const + Int(size!.height + 35)
        }
       
        if(selectedSubIndexValue >= 0){
            if let faq = data[selectedSubIndexValue] as? FAQ{
                
                let size = faq.answer?.heightWithConstrainedWidth(width: UIScreen.main.bounds.width - 100, font: UIFont(name: "HelveticaNeue-Bold", size: 16.0)!)
                const = const +  Int(size!.height + CGFloat(faqUseful))
                if faq.link != nil{
                    const = const + 40
                }
                if faq.imageURL != nil{
                    const = const + 160
                }
                if faq.videoURL != nil{
                    const = const + 160
                }
            }
        }
        
       
        self.faqTableView.reloadData()
    }
    func getThumbsCount(canID:String,faqID:String,intValue:Int)  {
        
        let apiURL = ServiceMethods.notificationServiceBaseUrl + ActionKeys.getthumbscount
        
        let data = ["can_id":canID,"faq_id":faqID]
        CANetworkManager.sharedInstance.requestApi(serviceName: apiURL, method: .GET, postData: data  as Dictionary<String, AnyObject>)  { (response, error) in
            print_debug(object: response)
            if response != nil
            {
            if let additionalInfo = response?["additionalInfo"] as? Int{
                    if additionalInfo == 1{
                        self.faqUseful = 20
                    }else{
                        self.faqUseful = 80
                    }
                    self.selectedSubIndexValue = intValue
                    self.calculateHeight()
                if let clouser = self.upDownWordCardClick{
                    clouser(self.faqUseful,intValue)
                }
                }
            }
        }
        }
    func openLinkOnApp(url:String){
        guard let url = URL(string: url) else { return }
        UIApplication.shared.open(url)
    }
    func setThumbsUP(canID:String,faqID:String,intValue:Int)  {
        let apiURL = ServiceMethods.notificationServiceBaseUrl + ActionKeys.thumbsup + "?can_id=" + canID + "&faq_id=" + faqID
       
        CANetworkManager.sharedInstance.requestApi(serviceName: apiURL, method: .PUT, postData: [:]  as Dictionary<String, AnyObject>)  { (response, error) in
            print_debug(object: response)
            if response != nil
            {
                if let statusCode = response?["statusCode"] as? Double{
                    
                    if(statusCode == 200){
                    self.faqUseful = 20
                    self.selectedIndexValue = intValue
                    self.calculateHeight()
                        if let clouser = self.selectUpValue{
                            clouser(self.faqUseful)
                        }
                    }
                    
                }
            }
        }
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
extension RecentFAQTableViewCell:UITableViewDelegate,UITableViewDataSource{
    
   
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell : FAQCell? = (tableView.dequeueReusableCell(withIdentifier: TableViewCellName.FAQIdentierCell) as! FAQCell)
        if cell == nil
        {
            cell = FAQCell(style: UITableViewCell.CellStyle.default, reuseIdentifier: TableViewCellName.FAQIdentierCell)
        }
        if let faq = data[indexPath.row] as? FAQ{
            cell?.setValueInCell(faqVAlue: faq, indexValue: indexPath.row, seletedIndexValue: selectedSubIndexValue,isFinalBool:(data.count - 1) == indexPath.row)
        }
        if(self.faqUseful > 20){
            cell?.faqUseFullView.isHidden = false
        }else{
            cell?.faqUseFullView.isHidden = true
        }
        cell?.faqSelect = {
            [weak self] intValue in
            if let faq = self?.data[indexPath.row]{
                if(self?.selectedSubIndexValue  == intValue){
//
                    self?.selectedSubIndexValue = -1
                    self?.calculateHeight()
                    tableView.reloadData()
                    if let clouser = self?.upDownWordCardClick{
                        clouser(0,intValue)
                                       }
                    return
                }
                self?.faqClickedFirbaseAnalysics(faqString: faq.question ?? "")
                self?.getThumbsCount(canID: self?.canID ?? "", faqID: faq.id ?? "",intValue:intValue)
            }
        }
        
        cell?.openLinkAttached = {
            [weak self] intValue in
            if let faq = self?.data[indexPath.row]{
                self?.openLinkOnApp(url: faq.link ?? "")
            }
        }
       
        cell?.downRatingClick = {
            [weak self] intValue in
            if let clouser = self?.downRatingClick{
                clouser(intValue)
            }
        }
       
        cell?.upwordRatingClick = {
            [weak self] intValue in
            if let faq = self?.data[indexPath.row]{
                self?.setThumbsUP(canID: self?.canID ?? "", faqID: faq.id ?? "", intValue: intValue)
            }
        }
 
        return cell ?? UITableViewCell()
    }
    func faqClickedFirbaseAnalysics(faqString:String){
            
                let dictAnalysics = [AnanlysicParameters.canID:canID,
                                     AnanlysicParameters.Category:AnalyticsEventsCategory.get_help_faq
                                     ,AnanlysicParameters.Action:faqString
                                     ,AnanlysicParameters.EventType:AnanlysicParameters.ClickEvent]
                
                //,AnanlysicParameters.EventDescription:AnanlysicEventDescprion.loginwithUserNamePassword
            
               HelpingClass.sharedInstance.addFirebaseAnalysis(eventName: AnalyticsEventsName.faq_Topic_Clicked, parameters: dictAnalysics as? [String:AnyObject] ?? [String:AnyObject]() )
        }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        if let faq = data[indexPath.row] as? FAQ{
            let size = faq.question?.heightWithConstrainedWidth(width: UIScreen.main.bounds.width - 120, font: UIFont(name: "HelveticaNeue-Bold", size: 16.0)!)
            var height = (size?.height ?? 60) + 35
           
            if(selectedSubIndexValue >= 0){
                
                if(indexPath.row == selectedSubIndexValue){
                if let faq = data[selectedSubIndexValue] as? FAQ{
                    
                    let size = faq.answer?.heightWithConstrainedWidth(width: UIScreen.main.bounds.width - 100, font: UIFont(name: "HelveticaNeue-Bold", size: 16.0)!)
                    height = height +  CGFloat(Int(size!.height + CGFloat(faqUseful)))
                }
                    if faq.link != nil{
                        height = height + 40
                    }
                    if faq.imageURL != nil{
                        height = height + 160
                    }
                    if faq.videoURL != nil{
                        height = height + 160
                    }
                
            }
            }
            print_debug(object: "size?.height  \(height  )")
            return height
        }
    }
    
}
