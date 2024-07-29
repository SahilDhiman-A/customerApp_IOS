//
//  GetHelpViewController.swift
//  My Spectra
//
//  Created by Chakshu on 10/06/21.
//  Copyright © 2021 Bhoopendra. All rights reserved.
//

import UIKit
import RealmSwift
import MessageUI

class GetHelpViewController: UIViewController {
    var realm: Realm? = nil
    var userResult:Results<UserCurrentData>? = nil
    var userdata:Results<UserData>? = nil
    var canID = String()
    var sengentId = String()
    var packageID = String()
    var selectedIndexValue = -1
    var data = [FAQ]()
    var faqUseful = 0
    @IBOutlet weak var tfSearch: UITextField!
    @IBOutlet weak var faqTableView: UITableView!
    @IBOutlet weak var faqHeightConstant: NSLayoutConstraint!
    @IBOutlet weak var noSearchLabel: UILabel!
    @IBOutlet weak var faqViewBottomConstraint : NSLayoutConstraint!
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.faqHeightConstant.constant = CGFloat(100)
        faqTableView.isHidden = true
        self.data.removeAll()
        selectedIndexValue = -1
        self.getSegmentID()
    }
    @objc func searchText(textField: UITextField) {
      
        self.getTopFiveSegment(segmentId: sengentId, searchedValue: textField.text ?? "")
    }
    
    func faqSearchFirbaseAnalysics(search:String){
            
        if(search == ""){
            return
        }
                let dictAnalysics = [AnanlysicParameters.canID:canID,
                                     AnanlysicParameters.Category:AnalyticsEventsCategory.get_help
                                     ,AnanlysicParameters.Action:AnalyticsEventsActions.searchTopic + search + "}"
                                     ,AnanlysicParameters.EventType:AnanlysicParameters.ClickEvent]
                
                //,AnanlysicParameters.EventDescription:AnanlysicEventDescprion.loginwithUserNamePassword
            
               HelpingClass.sharedInstance.addFirebaseAnalysis(eventName: AnalyticsEventsName.help_Search, parameters: dictAnalysics as? [String:AnyObject] ?? [String:AnyObject]() )
        }
    
    
    func faqTopicClickedFirbaseAnalysics(topicClicked:String){
            
                let dictAnalysics = [AnanlysicParameters.canID:canID,
                                     AnanlysicParameters.Category:AnalyticsEventsCategory.get_help_faq
                                     ,AnanlysicParameters.Action:topicClicked
                                     ,AnanlysicParameters.EventType:AnanlysicParameters.ClickEvent]
                
                //,AnanlysicParameters.EventDescription:AnanlysicEventDescprion.loginwithUserNamePassword
            
               HelpingClass.sharedInstance.addFirebaseAnalysis(eventName: AnalyticsEventsName.faq_Topic_Clicked, parameters: dictAnalysics as? [String:AnyObject] ?? [String:AnyObject]() )
        }
    func getCanIdValue() -> String  {
        realm = try? Realm()
        userResult = self.realm!.objects(UserCurrentData.self)
        if(userResult?.count ?? 0 > 0){
            if let userActData = userResult?[0]
            {
                canID = userActData.CANId
                packageID = userActData.Product
                return userActData.Segment
            }else{
                return ""
            }
        }
        return ""
    }
    
    func getSegmentID()  {
        
        let this = self
       // faqHeightConstant.constant = 100
        let apiURL = ServiceMethods.notificationServiceBaseUrl + ActionKeys.getsegmentlist
        CANetworkManager.sharedInstance.progressHUD(show: true)
        CANetworkManager.sharedInstance.requestApiWithoutHUD(serviceName: apiURL, method: .GET, postData: [:] as Dictionary<String, AnyObject>) { (response, error) in
            print_debug(object: response)
            if response != nil
            {
                if let consultationData = try? JSONSerialization.data(withJSONObject:  response ?? [], options: []) {
                    let consultations = try? JSONDecoder().decode(SegmentList.self, from: consultationData)
                    let value =  this.getCanIdValue()
                    let array = consultations?.data
                    for data in (array ?? []) as [Datum]{
                        if(data.name  == value){
                            self.sengentId = data.id ?? ""
                            this.getTopFiveSegment(segmentId: data.id ?? "", searchedValue: "")
                        }
                    }
                }
            }else{
                CANetworkManager.sharedInstance.progressHUD(show: false)
            }
            
            
        }
    }
    
    func getTopFiveSegment(segmentId:String,searchedValue:String)  {
        self.faqSearchFirbaseAnalysics(search:searchedValue)
        faqUseful = 0
        selectedIndexValue = -1
        var apiURL = ServiceMethods.notificationServiceBaseUrl + ActionKeys.gettopFiveFaqList + "/" + segmentId
        
        if(searchedValue != ""){
            apiURL = apiURL + "?searchKey=" + searchedValue
        }
        
        CANetworkManager.sharedInstance.requestApiWithoutHUD(serviceName: apiURL, method: .GET, postData: [:] as Dictionary<String, AnyObject>) { (response, error) in
            print_debug(object: response)
            if response != nil
            {
                if let consultationData = try? JSONSerialization.data(withJSONObject:  response ?? [], options: []) {
                    
                    let consultations = try? JSONDecoder().decode(FAQList.self, from: consultationData)
                    self.data.removeAll()
                    
                    let valueData = consultations?.data
                    
                    for value in  (valueData ?? []) as [FAQ] {
                        
                        if(value.isActive ?? false){
                            self.data.append(value)
                        }
                        
                        
                    }
                    self.calculateHeight()
                }
                CANetworkManager.sharedInstance.progressHUD(show: false)
            }else{
                
                CANetworkManager.sharedInstance.progressHUD(show: false)
            }
        }
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
                    self.selectedIndexValue = intValue
                    self.calculateHeight()
                }
            }
        }
    }
    func openLinkOnApp(url:String){
        guard let url = URL(string: url) else { return }
        UIApplication.shared.open(url)
    }
    @IBAction func faqButtonClick(_ button: UIButton){
        navigateScreenToStoryboardMain(identifier: ViewIdentifier.faqIdentifier, controller: FAQViewController.self)
        viewAllTopicFirbaseAnalysics()
    }
    @IBAction func newSRClick(_ button: UIButton){
        srRAiseHelpClickedFirbaseAnalysics()
        goCreateSRScreen(fromScreen: "")
        
    }
    func srRAiseHelpClickedFirbaseAnalysics(){
            
                let dictAnalysics = [AnanlysicParameters.canID:canID,
                                     AnanlysicParameters.Category:AnalyticsEventsCategory.get_help
                                     ,AnanlysicParameters.Action:AnalyticsEventsActions.serviceRequestClicked
                                     ,AnanlysicParameters.EventType:AnanlysicParameters.ClickEvent]
                
                //,AnanlysicParameters.EventDescription:AnanlysicEventDescprion.loginwithUserNamePassword
            
               HelpingClass.sharedInstance.addFirebaseAnalysis(eventName: AnalyticsEventsName.raise_new_service_request, parameters: dictAnalysics as? [String:AnyObject] ?? [String:AnyObject]() )
        }
    
    func viewAllTopicFirbaseAnalysics(){
           
               let dictAnalysics = [AnanlysicParameters.canID:canID,
                                    AnanlysicParameters.Category:AnalyticsEventsCategory.get_help
                                    ,AnanlysicParameters.Action:AnalyticsEventsActions.viewAllTopicsClicked
                                    ,AnanlysicParameters.EventType:AnanlysicParameters.ClickEvent]
               
               //,AnanlysicParameters.EventDescription:AnanlysicEventDescprion.loginwithUserNamePassword
           
              HelpingClass.sharedInstance.addFirebaseAnalysis(eventName: AnalyticsEventsName.help_View_Topics, parameters: dictAnalysics as? [String:AnyObject] ?? [String:AnyObject]() )
       }
    
    @IBAction func knowYourBill(_ button: UIButton){
        if let vc = UIStoryboard.init(name: "Storyboard", bundle: Bundle.main).instantiateViewController(withIdentifier: ViewIdentifier.testInternetIdentifier) as? TestInternetViewController{
            
            vc.mediaUrl = "https://www.spectra.co/know-your-bill"
                
        self.navigationController?.pushViewController(vc , animated: true)
        }
    }
    @IBAction func phoneContactClick(_ button: UIButton){
        menuContactUSFirbaseAnalysics()
        self.dialNumber(number: contactUsData.newConnectionContact)
    }
    @IBAction func emailClick(_ button: UIButton){
        menuContactUSFirbaseAnalysics()
        if MFMailComposeViewController.canSendMail() {
            let composeVC = MFMailComposeViewController()
            composeVC.mailComposeDelegate = self
            composeVC.setToRecipients([contactUsData.emailID])
            composeVC.setSubject("")
            composeVC.setMessageBody("", isHTML: false)
            self.present(composeVC, animated: true, completion: nil)
        }
        
    }
    
    func menuContactUSFirbaseAnalysics(){
        
        let dictAnalysics = [AnanlysicParameters.canID:canID,
                             AnanlysicParameters.Category:AnalyticsEventsCategory.dashboard_menu,
                             AnanlysicParameters.Action:AnalyticsEventsActions.menu_get_help_contact_us,
                             AnanlysicParameters.EventType:AnanlysicParameters.ClickEvent]
        
        HelpingClass.sharedInstance.addFirebaseAnalysis(eventName: AnalyticsEventsName.menu_click_get_help_contact_us, parameters: dictAnalysics as? [String:AnyObject] ?? [String:AnyObject]() )
    }
    
   
    func dialNumber(number : String) {
        if let url = URL(string: "tel://\(number)"),
           UIApplication.shared.canOpenURL(url) {
            if #available(iOS 10, *) {
                UIApplication.shared.open(url, options: [:], completionHandler:nil)
            } else {
                UIApplication.shared.openURL(url)
            }
        } else {
            // add error message here
        }
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
                    }
                    
                }
            }
        }
    }
    func setThumbsDown(canID:String,faqID:String,intValue:Int)  {
        
        guard let vc = UIStoryboard.init(name: "StoryboardMain", bundle: nil).instantiateViewController(withIdentifier: ViewIdentifier.FaqDownViewController) as? FaqDownViewController else {
            return
        }
        vc.modalPresentationStyle = .overCurrentContext
        vc.canID = canID
        vc.faqID = faqID
        
        vc.dismissOnSubmitValue = {
            [weak self] intValue in
            self?.thanksViewShow()
        }
        let navigationBar = UINavigationController(rootViewController: vc)
        navigationBar.navigationBar.isHidden = true
        self.present(navigationBar, animated: true) {
        }
    }
    
    func thanksViewShow(){
        guard let vc = UIStoryboard.init(name: "StoryboardMain", bundle: nil).instantiateViewController(withIdentifier: ViewIdentifier.FAQReasonViewController) as? FAQReasonViewController else {
            return
        }
        vc.modalPresentationStyle = .overCurrentContext
        let navigationBar = UINavigationController(rootViewController: vc)
        navigationBar.navigationBar.isHidden = true
        self.present(navigationBar, animated: true) {
        }
    }
    
    func calculateHeight(){
        var const =  0
        for value in self.data{
            let size = value.question?.heightWithConstrainedWidth(width: UIScreen.main.bounds.width - 120, font: UIFont(name: "HelveticaNeue-Bold", size: 16.0)!)
            const = const + Int(size!.height  + 30)
            
        }
       
        if(selectedIndexValue >= 0){
            if let faq = data[selectedIndexValue] as? FAQ{
                
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
        //const = const
        if(const) == 0{
            const = const +  60
        }
        const = const +  30
        if(self.data.count>0){
            self.faqTableView.isHidden = false
        noSearchLabel.isHidden = true
       }
    else{
        self.faqTableView.isHidden = true
        noSearchLabel.isHidden = false
     }
        self.faqHeightConstant.constant = CGFloat(const + 20)
        self.faqViewBottomConstraint.constant = CGFloat((const + 690)) - UIScreen.main.bounds.height
        self.faqTableView.reloadData()
    }
    
}


extension GetHelpViewController:UITableViewDelegate,UITableViewDataSource{
    
    
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
            cell?.setValueInCell(faqVAlue: faq, indexValue: indexPath.row, seletedIndexValue: selectedIndexValue,isFinalBool:(data.count - 1) == indexPath.row)
            
        }
        if(self.faqUseful > 20){
            cell?.faqUseFullView.isHidden = false
        }else{
            cell?.faqUseFullView.isHidden = true
        }
        cell?.faqSelect = {
            [weak self] intValue in
            
            if(self?.selectedIndexValue  == intValue){
                self?.selectedIndexValue = -1
                self?.calculateHeight()
                tableView.reloadData()
                return
            }
            if let faq = self?.data[indexPath.row]{
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
            if let faq = self?.data[indexPath.row]{
                self?.setThumbsDown(canID: self?.canID ?? "", faqID: faq.id ?? "", intValue: intValue)
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
            var height = (size?.height ?? 60) + 30
            
        
            if(selectedIndexValue >= 0){
                
                if(indexPath.row == selectedIndexValue){
                    if let faq = data[selectedIndexValue] as? FAQ{
                        
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
extension GetHelpViewController: UITextFieldDelegate {
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool{
        return true
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool{
        
        NSObject.cancelPreviousPerformRequests(
                            withTarget: self,
                            selector: #selector(FAQViewController.searchText),
                            object: textField)
                        self.perform(
                            #selector(FAQViewController.searchText),
                            with: textField,
                            afterDelay: 0.2)
        textField.resignFirstResponder()
       
        return true
        
    }
//    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
//        if let text = textField.text,
//           let textRange = Range(range, in: text) {
//            let updatedText = text.replacingCharacters(in: textRange,
//                                                       with: string)
//            if updatedText.count > 3 {
//                NSObject.cancelPreviousPerformRequests(
//                    withTarget: self,
//                    selector: #selector(GetHelpViewController.searchText),
//                    object: textField)
//                self.perform(
//                    #selector(GetHelpViewController.searchText),
//                    with: textField,
//                    afterDelay: 1.0)
//            }
//        }
//        return true
//    }
}
extension GetHelpViewController: MFMailComposeViewControllerDelegate {
    func mailComposeController(_ controller: MFMailComposeViewController,
                               didFinishWith result: MFMailComposeResult, error: Error?) {
        // Check the result or perform other tasks.
        
        // Dismiss the mail compose view controller.
        controller.dismiss(animated: true, completion: nil)
    }
    
}

