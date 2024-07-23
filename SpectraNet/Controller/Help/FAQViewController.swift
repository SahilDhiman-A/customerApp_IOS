//
//  FAQViewController.swift
//  My Spectra
//
//  Created by Chakshu on 21/09/21.
//  Copyright © 2021 Bhoopendra. All rights reserved.
//

import UIKit
import RealmSwift
class FAQViewController: UIViewController {
    var realm: Realm? = nil
    var userResult:Results<UserCurrentData>? = nil
    var userdata:Results<UserData>? = nil
    var canID = String()
    var sengentId = String()
    var seletedIndexValue = -1
    var  faqData = [FAQCategory]()
    var selectedSubIndexValue = -1
    var faqUseful = 0
    @IBOutlet weak var tfSearch: UITextField!
    @IBOutlet weak var faqTableView: UITableView!
    @IBOutlet weak var searchView: UIView!
    @IBOutlet weak var noSearchFoundView: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()

    self.getSegmentID()
        self.noSearchFoundView.isHidden = true
        self.faqTableView.tableFooterView?.backgroundColor = UIColor.clear
    // Do any additional setup after loading the view.
}
    func getSegmentID()  {
        
        let this = self
      
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
                            self.getfaqbysegmentname(segmentId: self.sengentId, searchedValue: "")
                        }
                    }
                }
                
            }else{
                CANetworkManager.sharedInstance.progressHUD(show: false)
            }
        
        
        }
    }

    func getCanIdValue() -> String  {
        realm = try? Realm()
        userResult = self.realm!.objects(UserCurrentData.self)
        if(userResult?.count ?? 0 > 0){
            if let userActData = userResult?[0]
            {
                canID = userActData.CANId
                return userActData.Segment
               // return "Home"
            }else{
                return ""
            }
        }
        
        return ""
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
    func getfaqbysegmentname(segmentId : String, searchedValue:String){
        self.faqSearchFirbaseAnalysics(search:searchedValue)
        faqUseful = 0
        seletedIndexValue = -1
        selectedSubIndexValue = -1
        var apiURL = ServiceMethods.notificationServiceBaseUrl + ActionKeys.getfaqbysegmentid + "/" + segmentId + "/" + canID
        
        if(searchedValue != ""){
            apiURL = apiURL + "?searchKey=" + searchedValue
        }
        
        CANetworkManager.sharedInstance.requestApi(serviceName: apiURL, method: .GET, postData: [:]  as Dictionary<String, AnyObject>)  { (response, error) in
            print_debug(object: response)
            if response != nil
            {
                if let consultationData = try? JSONSerialization.data(withJSONObject:  response ?? [], options: []) {
                    
                    let consultations = try? JSONDecoder().decode(FAQFullData.self, from: consultationData)
                    print_debug(object: consultations?.data?.count)
                    self.faqData.removeAll()
                    
                    for value in (consultations?.data ?? []) as [FAQCategory] {
                        if let data = value as? FAQCategory,let faqData = data.faqInfo as? [FAQ]{
                            
                            
                            if(data.categoryInfo?.isActive ?? false){
                            var selectedData = data
                            if(!(faqData.isEmpty)){
                                var dataValue = [FAQ]()
                                for value in  (faqData ) as [FAQ] {
                                    if(value.isActive ?? false){
                                        dataValue.append(value)
                                    }
                                }
                                if(dataValue.count > 0){
                                selectedData.changeFaqInf0(faqInfoValue: dataValue)
                                self.faqData.append(selectedData)
                                }
                            }
                        }
                        }
                    }
                    
                    
                    if(self.faqData.count > 0)
                    {
                        self.noSearchFoundView.isHidden = true
                    }else{
                        self.noSearchFoundView.isHidden = false
                    }
                    self.tfSearch.resignFirstResponder()
                    self.faqTableView.backgroundColor = UIColor.clear
                    self.faqTableView.reloadData()
                    
                }
                
            }
            
        }
        
    }
    @objc func searchText(textField: UITextField) {
        debugPrint(textField.text ?? "")
        searchView.isHidden = true
        self.getfaqbysegmentname(segmentId: sengentId, searchedValue: textField.text ?? "")
    }
    
    @IBAction func searchButtonClick(_ sender: Any)
    {
        searchView.isHidden = false
        
    }
    @IBAction func searchButtonCancel(_ sender: Any)
    {
        searchView.isHidden = true
    }
    @IBAction func backBTN(_ sender: Any)
    {
        self.navigationController?.popViewController(animated: false)
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
        self.faqUseful = 20
        self.faqTableView.reloadData()
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
extension FAQViewController: UITextFieldDelegate {
    
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
}

extension FAQViewController:UITableViewDelegate,UITableViewDataSource{
    
    func numberOfSections(in tableView: UITableView) -> Int{
        
        return faqData.count
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
       return 1
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell : FAQHeaderTableViewCell? = (tableView.dequeueReusableCell(withIdentifier: TableViewCellName.FAQHeaderTableViewCell) as! FAQHeaderTableViewCell)
        if cell == nil
        {
            cell = FAQHeaderTableViewCell(style: UITableViewCell.CellStyle.default, reuseIdentifier: TableViewCellName.FAQHeaderTableViewCell)
        }
        cell?.canID = canID
        cell?.faqUseful = faqUseful
       // if(self.selectedSubIndexValue == -1){
        cell?.selectedSubIndexValue = self.selectedSubIndexValue
       // }
        if let faqValue = faqData[indexPath.section] as? FAQCategory{
            print_debug(object: "aa \(indexPath.section)  == seletedIndexValue =\(seletedIndexValue)")
            cell?.setValueInCell(faqValue: faqValue, indexValue: indexPath.section, seletedIndexValue: seletedIndexValue)
            
        }
       
        cell?.upDownWordCardClick = {
            [weak self] intValue,indexValue in
            print_debug(object: "upDownWordCardClick =\(intValue)indexValue \(indexValue) self?.selectedSubIndexValue =\(String(describing: self?.selectedSubIndexValue))")
            if( self?.selectedSubIndexValue == indexValue){
                self?.selectedSubIndexValue = -1
                self?.faqUseful = 0
                tableView.reloadData()
                print_debug(object: " if condition")
                return
            }
            self?.faqUseful = intValue
            self?.selectedSubIndexValue = indexValue
            print_debug(object: "final VAlue upDownWordCardClick =\(intValue)indexValue \(indexValue) self?.selectedSubIndexValue =\(String(describing: self?.selectedSubIndexValue))")
            tableView.reloadData()
        }
        cell?.faqSelect = {
            [weak self] intValue in
            print_debug(object: "intValue =\(intValue)")
            print_debug(object: "intValue =\(self?.seletedIndexValue)")
        
            self?.faqUseful = 0
            self?.selectedSubIndexValue = -1
            if( self?.seletedIndexValue == intValue){
                print_debug(object: " if condition")
                self?.seletedIndexValue = -1
            }else{
                print_debug(object: " else condition")
            self?.seletedIndexValue = intValue
            }
            self?.selectedSubIndexValue = -1
            tableView.reloadData()
            
        }
        cell?.selectUpValue = {
            [weak self] intValue in
            //self?.selectedSubIndexValue = -1
            self?.faqUseful = intValue
            tableView.reloadData()
        }
        cell?.downRatingClick = {
            [weak self] intValue in
            if let faqValue = self?.faqData[indexPath.section] as? FAQCategory{
                if let faqID = faqValue.faqInfo?[intValue] as? FAQ{
                    self?.setThumbsDown(canID: self?.canID ?? "", faqID: faqID.id ?? "", intValue: intValue)
                }
                
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
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView?{
        
        let view = UIView(frame: CGRectMake(0, 0, 500, 30))
        view.backgroundColor = UIColor.clear
        return view
    }
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat{
        
        return 30
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat{
        if(indexPath.section == seletedIndexValue){
            return CGFloat(calculateHeight())
        }
        return 70
    }
    func calculateHeight() -> Int{
        var const =  0
        
        if let data = faqData[seletedIndexValue].faqInfo {
        for value in data{
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
       return const + 80
        
        }
        return 0
    }
    
    
}
