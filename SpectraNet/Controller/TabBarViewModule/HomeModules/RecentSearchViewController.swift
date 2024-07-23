//
//  RecentSearchViewController.swift
//  My Spectra
//
//  Created by Chakshu on 21/09/21.
//  Copyright © 2021 Bhoopendra. All rights reserved.
//

import UIKit
import RealmSwift

class RecentSearchViewController: UIViewController {
    var realm: Realm? = nil
    var userResult:Results<UserCurrentData>? = nil
    var userdata:Results<UserData>? = nil
    var canID = String()
    var searchedString = String()
    var recentSearches = [String]()
    var sengentId = String()
    var sengentvalue = String()
    var localSearchValue = [String]()
    var  faqData = [FAQ]()
    var selectedIndexValue = -1
    var packgID = String()
    var faqUseful = 0
    var selectedSubIndexValue = -1
    @IBOutlet weak var recentHeightConstant: NSLayoutConstraint!
    var isSearch = false
    @IBOutlet weak var tfSearch: UITextField!
    @IBOutlet weak var recentSearchView: UIView!
    @IBOutlet weak var noSerachFound: UIView!
    @IBOutlet weak var noSerachFoundLabel: UILabel!
    @IBOutlet weak var recentTableView: UITableView!
    @IBOutlet weak var faqTableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.getCanIdValue()
        // Do any additional setup after loading the view.
    }
    
    func getLocatSerachData() -> [String:String] {
        let data = ["Home Screen":LocalSearch.home.lowercased() ,
                    "View SR Status":LocalSearch.viewSR.lowercased() ,
                    "View Invoice List": LocalSearch.voiceList.lowercased(),
                    "My Profile": LocalSearch.profile.lowercased() ,
                    "View Usage": LocalSearch.viewUseage.lowercased() ,
                    "My Plan":LocalSearch.myPlan.lowercased(),
                    "View Transaction":LocalSearch.viewTranaction.lowercased(),
                    "Check Auto Pay status":LocalSearch.autopayStatus.lowercased(),
                    "View Contact":LocalSearch.ViewContact.lowercased(),
                    "View MRTG":LocalSearch.viewMRTG.lowercased(),
                    "View Plan Change offer":LocalSearch.viewPlanChangeOffer.lowercased(),
                    "Create SR":LocalSearch.createSR.lowercased(),
                    "Change Password":LocalSearch.changePassword.lowercased(),
                    "Update Mobile Number" :LocalSearch.UpdateMobileNumber.lowercased(),
                    "Update Email id":LocalSearch.UpdateEmailId.lowercased(),
                    "Link multiple accounts":LocalSearch.linkMultipleAccounts.lowercased(),
                    "Update Contact Details":LocalSearch.updateContactDetails.lowercased(),
                    "FAQ":LocalSearch.faq.lowercased() ]
        
        return data
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
                    
                    let array = consultations?.data
                    for data in (array ?? []) as [Datum]{
                        if(data.name  == self.sengentvalue){
                            self.sengentId = data.id ?? ""
                           
                        }
                    }
                }
                
            }else{
                CANetworkManager.sharedInstance.progressHUD(show: false)
            }
        
        
        }
    }

    
    func getCanIdValue()  {
        realm = try? Realm()
        userResult = self.realm!.objects(UserCurrentData.self)
        if(userResult?.count ?? 0 > 0){
            if let userActData = userResult?[0]
            {
                canID = userActData.CANId
                sengentvalue = userActData.Segment
                packgID = userActData.Product
                self.getSegmentID()
                self.getRecentSerach()
            }
        }
    }
    
    func getRecentSerach()  {
        let apiURL = ServiceMethods.notificationServiceBaseUrl + ActionKeys.getrecentsearchlist + "/" + canID
        CANetworkManager.sharedInstance.requestApi(serviceName: apiURL, method: .GET, postData: [:]  as Dictionary<String, AnyObject>)  { (response, error) in
            print_debug(object: response)
            if response != nil
            {
                if let data = response?["data"] as? Dictionary<String, AnyObject>{
                    if let searchInfo = data["search_info"] as? [String]?{
                        self.recentSearches = searchInfo ?? []
                        self.refreshRecentButton()
                    }
                }
            }
        }
        
    }
    func refreshRecentButton()  {
        
        if(self.recentSearches.count>0)
        {
            recentHeightConstant.constant = CGFloat(self.recentSearches.count * 60)
            noSerachFound.isHidden = true
            recentSearchView.isHidden = false
            faqTableView.isHidden = true
            self.recentTableView.reloadData()
        }else{
            noSerachFound.isHidden = false
            recentSearchView.isHidden = true
            noSerachFoundLabel.text = "No recent search found"
        }
    }
    
    
    @IBAction func backBTN(_ sender: Any)
    {
        self.navigationController?.popViewController(animated: false)
    }
    @objc func searchText(textField: UITextField) {
        debugPrint(textField.text ?? "")
        //self.getserachedValue(segmentId: sengentId, searchedValue: textField.text ?? "")
    }
    
    func localSearch(serachedString:String)  {
        
        let result = self.getLocatSerachData().filter { (key, value) in
            value.split(separator: "/").contains("\(serachedString)") // your search text replaces 'else'
        } as [String:String]
        debugPrint("dddfff ",Array( result.keys))
        let value = Array(result.keys)
        self.localSearchValue = value.sorted { $0.localizedCaseInsensitiveCompare($1) == ComparisonResult.orderedAscending }
        noDataOnSearch()
    }
    
    func noDataOnSearch()  {
        
        self.recentSearchView.isHidden = true
        self.faqTableView.isHidden = true
        self.noSerachFound.isHidden = true
        if(self.localSearchValue.count == 0 && self.faqData.count == 0){
            self.noSerachFound.isHidden = false
        self.noSerachFoundLabel.text = "No record(s) found"
        }else{
            self.faqTableView.isHidden = false
            self.faqTableView.backgroundColor = UIColor.clear
            self.faqTableView.reloadData()
        }
    }
    
    func homeSearchFirbaseAnalysics(search:String){
        
        if(search == ""){
            return
        }
            
                let dictAnalysics = [AnanlysicParameters.canID:canID,
                                     AnanlysicParameters.Category:AnalyticsEventsCategory.home
                                     ,AnanlysicParameters.Action:AnalyticsEventsActions.searchTopic + search + "}"
                                     ,AnanlysicParameters.EventType:AnanlysicParameters.ClickEvent]
                
                //,AnanlysicParameters.EventDescription:AnanlysicEventDescprion.loginwithUserNamePassword
            
               HelpingClass.sharedInstance.addFirebaseAnalysis(eventName: AnalyticsEventsName.home_Search, parameters: dictAnalysics as? [String:AnyObject] ?? [String:AnyObject]() )
        }

}

extension RecentSearchViewController: UITextFieldDelegate {
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool{
        recentSearchView.isHidden = true
        noSerachFound.isHidden = true
        return true
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool{
        
        if(textField.text == ""){
            getRecentSerach()
            
        }else{
           
            self.localSearch(serachedString: textField.text ?? "")
            self.getFaqBySegmentName(segmentId: sengentId, searchedValue: textField.text ?? "")
            self.homeSearchFirbaseAnalysics(search:textField.text ?? "")
        }
        textField.resignFirstResponder()
       
        return true
        
    }
    func getFaqBySegmentName(segmentId : String, searchedValue:String){
        
        if(searchedString == searchedValue){
            noDataOnSearch()
            return
        }
        
        searchedString = searchedValue
        faqUseful = 0
        selectedIndexValue = -1
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
                    var dataValue = [FAQ]()
                    for value in (consultations?.data ?? []) as [FAQCategory] {
                        if let data = value as? FAQCategory,let faqDataValue = data.faqInfo as? [FAQ]{
                            if(data.categoryInfo?.isActive ?? false){
                            if(!(faqDataValue.isEmpty)){
                               
                                for value in  (faqDataValue ) as [FAQ] {
                                    if(value.isActive ?? false){
                                        dataValue.append(value)
                                    }
                                }

                                self.faqData = dataValue
                            }
                        }
                        }
                    }
                    

                    self.tfSearch.resignFirstResponder()
                    
                    self.noDataOnSearch()
                }
                
            }else{
                self.noDataOnSearch()
            }
            
        }
        
    }
    func navigateLocalSearch(intValue:Int){
        
        if intValue < self.localSearchValue.count{
            
            if let value = self.localSearchValue[intValue] as? String{
                
                switch value.lowercased() {
                case "home screen":
                    homeScreenNavigate()
                    break
                case "view sr status":
                    srScreenNavigate()
                    break
                case "view invoice list":
                    AppDelegate.sharedInstance.navigateFrom=TabViewScreenName.Payment
                    navigateScreen(identifier: ViewIdentifier.customTabIdentifier, controller: CustomTabViewController.self)
                    break
                case "my account":
                    accountChangeView()
                    break
                case "view usage":
                    if AppDelegate.sharedInstance.segmentType == segment.userB2C
                    {
                        navigateScreen(identifier: ViewIdentifier.dataUsageIdentifier, controller: DataUsageViewController.self)
                    }
                    else
                    {
                        navigateScreen(identifier: ViewIdentifier.mrtgIdentifier, controller: MRTGViewController.self)
                    }
                    break
                case "my plan":
                    navigateScreenToStoryboard(identifier: ViewIdentifier.planIdentifier, controller: PlanViewController.self)
                    break
                case "view transaction":
                    AppDelegate.sharedInstance.navigateFrom=TabViewScreenName.Payment
                    navigateScreen(identifier: ViewIdentifier.customTabIdentifier, controller: CustomTabViewController.self)
                    break
                case "check auto pay status":
                    autoPay()
                    break
                case "view contact":
                    clickManageContacts()
                    break
                case "view mrtg":
                    if AppDelegate.sharedInstance.segmentType == segment.userB2C
                    {
                        navigateScreen(identifier: ViewIdentifier.dataUsageIdentifier, controller: DataUsageViewController.self)
                    }
                    else
                    {
                        navigateScreen(identifier: ViewIdentifier.mrtgIdentifier, controller: MRTGViewController.self)
                    }
                    break
                case "view plan change offer":
                    chnagePlanScreen(WithCanID: canID, pckgID: packgID,typeOf: "")
                    break
                case "create sr":
                    srScreenNavigate()
                    break
                case "change password":
                    accountChangeView()
                    break
                case "update mobile number":
                    accountChangeView()
                    break
                case "update email id":
                    accountChangeView()
                    break
                case "link multiple accounts":
                    navigateScreen(identifier: ViewIdentifier.payBillMultipleAccountsIdentifier, controller: PayBillMultipleAccountsViewController.self)
                    break
                case "faq":
                    navigateScreenToStoryboardMain(identifier: ViewIdentifier.faqIdentifier, controller: FAQViewController.self)
                    break
                    
                default:
                    break
                    
                }
            }
        }
    }
    func autoPay(){
        AppDelegate.sharedInstance.siTermCondtionAccept = ""
        navigateScreenToStoryboardMain(identifier: ViewIdentifier.StandingInstructionIdentifier, controller: StandingInstractionViewController.self)

    }
    func clickManageContacts()
    {
        manageContactsScreen(canID: canID)
    }
    func homeScreenNavigate(){
        AppDelegate.sharedInstance.navigateFrom=TabViewScreenName.home
        navigateScreen(identifier: ViewIdentifier.customTabIdentifier, controller: CustomTabViewController.self)
    }
    func srScreenNavigate(){
        AppDelegate.sharedInstance.navigateFrom=TabViewScreenName.sr
        navigateScreen(identifier: ViewIdentifier.customTabIdentifier, controller: CustomTabViewController.self)
    }
    func accountChangeView()
    {
        let vc = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: ViewIdentifier.AccountIdentifier) as? AccountViewController
        //vc?.fromScreen = FromScreen.menuScreen
        self.navigationController?.pushViewController(vc!, animated: false)
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
            
            self?.faqUseful = 20
            self?.faqTableView.reloadData()
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
       // self.selectedSubIndexValue = -1
        

    }
}
extension RecentSearchViewController:UITableViewDelegate,UITableViewDataSource{
    
    func numberOfSections(in tableView: UITableView) -> Int{
        if(tableView == faqTableView){
            
            var count = self.localSearchValue.count
            if(self.faqData.count > 0){
                count = count + 1
            }
            return count
        }else{
            return 1
        }
        
    }
   
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath){
        if(tableView == faqTableView){
            
        }else{
        if let value = recentSearches[indexPath.row] as? String{
            
            if(searchedString == value){
                noDataOnSearch()
                return
            }
            self.localSearch(serachedString: value)
            self.getFaqBySegmentName(segmentId: sengentId, searchedValue: value )
            self.homeSearchFirbaseAnalysics(search:value)
        }
        }
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if(tableView == faqTableView){
            
            
            return 1
        }else{
        return self.recentSearches.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if(tableView == faqTableView){
            if(indexPath.section == self.localSearchValue.count){
                var cell : RecentFAQTableViewCell? = (tableView.dequeueReusableCell(withIdentifier: TableViewCellName.RecentFAQTableViewCell) as! RecentFAQTableViewCell)
                
                if cell == nil
                {
                    cell = RecentFAQTableViewCell(style: UITableViewCell.CellStyle.default, reuseIdentifier: TableViewCellName.RecentFAQTableViewCell)
                    
                }
                
                cell?.canID = canID
                cell?.faqUseful = self.faqUseful
                if(self.selectedSubIndexValue == -1){
                cell?.selectedSubIndexValue = self.selectedSubIndexValue
                }
                cell?.setValueInCell(faqValue: faqData)
                cell?.upDownWordCardClick = {
                    [weak self] intValue,indexValue in
                    
                    if( self?.selectedSubIndexValue == indexValue){
                        self?.selectedSubIndexValue = -1
                        self?.faqUseful = 0
                        self?.faqTableView.reloadData()
                        return
                    }
                    self?.faqUseful = intValue
                    self?.selectedSubIndexValue = indexValue
                    self?.faqTableView.reloadData()
                }
                cell?.faqSelect = {
                    [weak self] intValue in
                    self?.faqUseful = 0
                    self?.selectedSubIndexValue = -1
                    if( self?.selectedIndexValue == intValue){
                        self?.selectedIndexValue = -1
                    }else{
                    self?.selectedIndexValue = intValue
                    }
                    self?.faqTableView.reloadData()
                }
                cell?.selectUpValue = {
                    [weak self] intValue in
                   // self?.selectedSubIndexValue = -1
                    self?.faqUseful = intValue
                    self?.faqTableView.reloadData()
                }
                cell?.downRatingClick = {
                    [weak self] intValue in
                    if let faqID = self?.faqData[intValue] as? FAQ{
                        
                            self?.setThumbsDown(canID: self?.canID ?? "", faqID: faqID.id ?? "", intValue: intValue)
                       
                        
                    }
                    
                }
                return cell ?? UITableViewCell()
                
            }
            var cell : LocalSearchTableViewCell? = (tableView.dequeueReusableCell(withIdentifier: TableViewCellName.LocalSearchTableViewCell) as! LocalSearchTableViewCell)
            
            if cell == nil
            {
                cell = LocalSearchTableViewCell(style: UITableViewCell.CellStyle.default, reuseIdentifier: TableViewCellName.LocalSearchTableViewCell)
            }
            if let value = self.localSearchValue[indexPath.section] as? String{
                cell?.setValueInCell(localSearch: value, tagValue: indexPath.section)
                
            }
            cell?.faqSelect = {
                [weak self] intValue in
                self?.navigateLocalSearch(intValue: intValue)
                
            }
            return cell ?? UITableViewCell()
        }else{
        var cell : RecentSerachCell? = (tableView.dequeueReusableCell(withIdentifier: TableViewCellName.RecentSerachCell) as! RecentSerachCell)
        
        if cell == nil
        {
            cell = RecentSerachCell(style: UITableViewCell.CellStyle.default, reuseIdentifier: TableViewCellName.RecentSerachCell)
        }
        if let value = recentSearches[indexPath.row] as? String{
            
            cell?.setValueInCell(faqValue: value)
        }
        
        return cell ?? UITableViewCell()
        }
    }
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView?{
        
        if(tableView == faqTableView){
        let view = UIView(frame: CGRectMake(0, 0, 500, 30))
        view.backgroundColor = UIColor.clear
        return view
        }else{
            
            return UIView()
        }
    }
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat{
        if(tableView == faqTableView){

        return 10
        }else{
            return 0
        }
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat{
        if(tableView == faqTableView){
            
            if(indexPath.section == self.localSearchValue.count){
            
             return CGFloat(calculateHeight())
            }
               
        }
        return 60
    }
    
    func calculateHeight() -> Int{
        var const =  0
        for value in self.faqData{
            let size = value.question?.heightWithConstrainedWidth(width: UIScreen.main.bounds.width - 120, font: UIFont(name: "HelveticaNeue-Bold", size: 16.0)!)
            const = const + Int(size!.height + 35)
            
        }
       
        if(selectedSubIndexValue >= 0){
            if let faq = self.faqData[selectedSubIndexValue] as? FAQ{
                
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
    

       
    }
    

