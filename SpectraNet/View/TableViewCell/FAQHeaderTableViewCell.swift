//
//  FAQHeaderTableViewCell.swift
//  My Spectra
//
//  Created by Chakshu on 22/09/21.
//  Copyright © 2021 Bhoopendra. All rights reserved.
//

import UIKit

class FAQHeaderTableViewCell: UITableViewCell {
    var canID = String()
    @IBOutlet var lblHeader: UILabel!
    @IBOutlet weak var plusButton: UIButton!
    @IBOutlet weak var selectButton: UIButton!
    @IBOutlet weak var faqTableView: UITableView!
    @IBOutlet var seprateTopView: UIView!
    @IBOutlet weak var faqHeightConstant: NSLayoutConstraint!
    @IBOutlet weak var faqTopHeightConstant: NSLayoutConstraint!
    var faqFullValue:FAQCategory?
    var data = [FAQ]()
    var faqUseful = 0
    var selectedIndexValue = -1
    var selectedSubIndexValue = -1
    var faqSelect:((Int) -> Void)? = nil
    var upDownWordCardClick:((Int,Int) -> Void)? = nil
    var downRatingClick:((Int) -> Void)? = nil
    var selectUpValue:((Int) -> Void)? = nil
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    func setValueInCell(faqValue:FAQCategory,indexValue:Int,seletedIndexValue:Int){
        lblHeader.text = faqValue.categoryInfo?.name
        lblHeader.textColor = UIColor.black
        selectButton.tag = indexValue
        faqFullValue = faqValue
        selectedIndexValue = 0
        self.plusButton.setImage(UIImage(named: "Plus"), for: .normal)
        seprateTopView.isHidden = true
        if(indexValue == seletedIndexValue){
            lblHeader.textColor = .bgColors
            seprateTopView.isHidden = false
            self.plusButton.setImage(UIImage(named: "Minus"), for: .normal)
            data = faqValue.faqInfo ?? [FAQ]()
            self.calculateHeight()
            
        }else{
            self.faqHeightConstant.constant = CGFloat(0)
            self.faqTopHeightConstant.constant = CGFloat(60)
        }
        self.setNeedsLayout()
        self.faqTableView.reloadData()
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
        
        self.faqHeightConstant.constant = CGFloat(const)
        self.faqTopHeightConstant.constant = CGFloat(const+60)
        
    }
    


    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    @IBAction func selectButtonClick(_ button: UIButton)
    {
        if let clouser = faqSelect{
            clouser(button.tag)
        }
    }
    func getThumbsCount(canID:String,faqID:String,intValue:Int)  {
        
        let apiURL = ServiceMethods.notificationServiceBaseUrl + ActionKeys.getthumbscount
        
        let data = ["can_id":canID,"faq_id":faqID]
        CANetworkManager.sharedInstance.progressHUD(show: true)
        CANetworkManager.sharedInstance.requestApiWithoutHUD(serviceName: apiURL, method: .GET, postData: data  as Dictionary<String, AnyObject>)  { (response, error) in
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
                print_debug(object: " self.selectedSubIndexValue set 1 =\( self.selectedSubIndexValue)")
                self.calculateHeight()
                print_debug(object: " self.self.upDownWordCardClick set 1 =\( self.upDownWordCardClick)")
            if let clouser = self.upDownWordCardClick{
                clouser(self.faqUseful,intValue)
            }
            }else{
                self.faqUseful = 20
                self.selectedSubIndexValue = intValue
                print_debug(object: " self.selectedSubIndexValue set 2 =\( self.selectedSubIndexValue)")
                self.calculateHeight()
            if let clouser = self.upDownWordCardClick{
                clouser(self.faqUseful,intValue)
            }
                self.faqTableView.reloadData()

            }
                CANetworkManager.sharedInstance.progressHUD(show: false)
            }else{
                self.faqUseful = 20
                self.selectedSubIndexValue = intValue
                print_debug(object: " self.selectedSubIndexValue set 3 =\( self.selectedSubIndexValue)")
                self.calculateHeight()
            if let clouser = self.upDownWordCardClick{
                clouser(self.faqUseful,intValue)
            }
                CANetworkManager.sharedInstance.progressHUD(show: false)
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
}
extension FAQHeaderTableViewCell:UITableViewDelegate,UITableViewDataSource{
    
    
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
            print_debug(object: "faqSelect ===== \(self?.selectedSubIndexValue)")
            if let faq = self?.data[indexPath.row]{
                if(self?.selectedSubIndexValue  == intValue){
                    print_debug(object: " if value faqSelect =====")
                    self?.selectedSubIndexValue = -1
                    self?.calculateHeight()
                    tableView.reloadData()
                    if let clouser = self?.upDownWordCardClick{
                        clouser(0,intValue)
                                       }
                    return
                }
                
                self?.getThumbsCount(canID: self?.canID ?? "", faqID: faq.id ?? "",intValue:intValue)
                print_debug(object: " if value after  faqSelect ===== \(intValue)")
                self?.faqClickedFirbaseAnalysics(faqString: faq.question ?? "")
            }else{
                print_debug(object: " else Part \(intValue)")
                if let clouser = self?.upDownWordCardClick{
                    clouser(0,intValue)
                    }
                tableView.reloadData()
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
            return height
        }
    }
    
}
