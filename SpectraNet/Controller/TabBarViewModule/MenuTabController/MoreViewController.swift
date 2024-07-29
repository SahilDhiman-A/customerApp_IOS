//
//  MoreViewController.swift
//  SpectraNet
//
//  Created by Yugasalabs-28 on 23/07/2019.
//  Copyright © 2019 Bhoopendra. All rights reserved.
//

import UIKit
import ObjectMapper
import RealmSwift

class MoreViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    // More View Outlets
    
    let kHeaderSectionTag: Int = 6900;
    var expandedSectionHeaderNumber: Int = -1
    var expandedSectionHeader: UITableViewHeaderFooterView!
    var sectionItems: Array<Any> = []
    var sectionNames: Array<Any> = []
    var subSectionImg: Array<Any> = []
    var menuSectionImg: Array<Any> = []
    
    var expendedMenu = -1
    var logoutButton = -1
    
    var realm: Realm? = nil
    var userResult:Results<UserCurrentData>? = nil
    @IBOutlet weak var moreTblView: UITableView!
    var canID = String()
    var packgID = String()
    var isUnlimitedSelected = false
    
    
    
    //MARK: View controller life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        realm = try? Realm()
        moreTblView.reloadData()
        
        // Section title Images
        menuSectionImg = ["plan.png","plan.png","MyTransaction.png","rupee","myAcnt.png","dataUsage.png","bill","help","rate_app","logout"] //"speed",
        // Section title names
        sectionNames = ["My Plan","Change Plan","My Transactions","Auto Pay","My Account","Data Usage","Pay for Another Account","Rate App","Get Help","Logout \n1.12"];
        
        //"Speed Test",
        // Section subItems title names
        sectionItems = [[],[],[],[],[],[],[],[],[],[],[],[],[]]; //[],
        // Section subItems title images
        subSectionImg = [[],[],[],[],[],[],[],[],[],[],[],[],[]] //[],
        
        self.moreTblView!.tableFooterView = UIView()
    }
    
    override func viewWillAppear(_ animated: Bool)
    {
        super.viewWillAppear(animated)
        if let text = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String {
         
        userResult = self.realm!.objects(UserCurrentData.self)
        if let userActData = userResult?[0]
        {
            packgID = userActData.Product
            canID = userActData.CANId
            
            
            if userActData.planDataVolume.lowercased() == Server.plandata_volume
            {
                
                menuSectionImg = ["plan.png","plan.png","MyTransaction.png","rupee","myAcnt.png","dataUsage.png","bill","help","faq","faq","rate_app","logout"] //"speed",
                // Section title names
                sectionNames = ["My Plan","Change Plan","My Transactions","Auto Pay","My Account","Data Usage","Pay for Another Account","Get Help", "Privacy Policy"," Legal Disclaimer","Rate App","Logout \n\(text)"];
                
                //"Speed Test",
                // Section subItems title names
                sectionItems = [[],[],[],[],[],[],[],[],[],[],[],[],[],[]]; //[],
                // Section subItems title images
                subSectionImg = [[],[],[],[],[],[],[],[],[],[],[],[],[],[]]
                
                // expendedMenu = 8
                logoutButton = 11
                isUnlimitedSelected = false
                
            }else{
                
                menuSectionImg = ["plan.png","plan.png","Group 493","MyTransaction.png","rupee","myAcnt.png","dataUsage.png","bill","help","faq","faq","rate_app","logout"] //"speed",
                // Section title names
                sectionNames = ["My Plan","Change Plan","Top-up","My Transactions","Auto Pay","My Account","Data Usage","Pay for Another Account","Get Help","Privacy Policy"," Legal Disclaimer","Rate App","Logout \n\(text)"];
                
            
                sectionItems = [[],[],[],[],[],[],[],[],[],[],[],[],[],[]]; //[],
                // Section subItems title images
                subSectionImg = [[],[],[],[],[],[],[],[],[],[],[],[],[],[]]
                
                //                expendedMenu = 9
                logoutButton = 12
                isUnlimitedSelected = true
                
                
            }
        }
        CANetworkManager.sharedInstance.progressHUD(show: false)
        if(AppDelegate.sharedInstance.navigateFrom == ""){
            menuMoreFirbaseAnalysics()
            
        }
        AppDelegate.sharedInstance.navigateFrom = ""
        }
    }
    
    func menuMoreFirbaseAnalysics(){
        
        let dictAnalysics = [AnanlysicParameters.canID:canID,
                             AnanlysicParameters.Category:AnalyticsEventsCategory.dashboard_menu,
                             AnanlysicParameters.Action:AnalyticsEventsActions.menu_all_menu,
                             AnanlysicParameters.EventType:AnanlysicParameters.ClickEvent]
        
        //,AnanlysicParameters.EventDescription:AnanlysicEventDescprion.loginwithUserNamePassword
        
        HelpingClass.sharedInstance.addFirebaseAnalysis(eventName: AnalyticsEventsName.menu_click_menu, parameters: dictAnalysics as? [String:AnyObject] ?? [String:AnyObject]() )
    }
    
    // MARK: - Tableview Methods
    func numberOfSections(in tableView: UITableView) -> Int
    {
        if sectionNames.count > 0 {
            moreTblView.backgroundView = nil
            return sectionNames.count
        } else {
            let messageLabel = UILabel(frame: CGRect(x: 50, y: 0, width: view.bounds.size.width-50, height: view.bounds.size.height))
            messageLabel.text = "Retrieving data.\nPlease wait."
            messageLabel.numberOfLines = 0;
            messageLabel.textAlignment = .center;
            messageLabel.font = UIFont(name: "HelveticaNeue", size: 18.0)!
            messageLabel.sizeToFit()
            self.moreTblView.backgroundView = messageLabel;
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if (expandedSectionHeaderNumber == section)
        {
            let arrayOfItems = self.sectionItems[section] as! NSArray
            return arrayOfItems.count;
        } else {
            return 0;
        }
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String?
    {
        if (self.sectionNames.count != 0)
        {
            return self.sectionNames[section] as? String
        }
        return ""
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat
    {
        return 60.0;
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat
    {
        return 0;
    }
    
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int)
    {
        //          recast your view as a UITableViewHeaderFooterView
        let header: UITableViewHeaderFooterView = view as! UITableViewHeaderFooterView
        
        print_debug(object: "1")
        
        header.contentView.backgroundColor = UIColor.black
        if section==0
        {
            header.contentView.backgroundColor = UIColor.bgColors
        }
        header.textLabel?.textColor = UIColor.white
        header.backgroundView?.backgroundColor = UIColor.white
        header.textLabel?.text = ""
        
        for view in header.subviews {
            
            if(view.tag == 10 || view.tag == 11 || view.tag == 12){
                view.removeFromSuperview()
            }
        }
        let headerView =  UIView.init(frame: CGRect.init(x: 0, y: 0, width: tableView.frame.width, height: 80))
        
        headerView.tag = 10
        let menuImage = header.viewWithTag(11) as? UIImageView ?? UIImageView(frame: CGRect(x: 15, y: 20, width: 20, height: 20));
        if section==expendedMenu
        {
            menuImage.frame = CGRect(x: 15, y: 20, width: 15, height: 24)
        }
        
        menuImage.image = UIImage(named: "")
        menuImage.image = UIImage(named: menuSectionImg[section] as! String)
        let templateImage = menuImage.image?.withRenderingMode(.alwaysTemplate)
        menuImage.image = templateImage
        menuImage.tintColor = UIColor.white
        menuImage.tag = 11
        //  header.addSubview(menuImage)
        
        let menutitleName =  headerView.viewWithTag(12) as? UILabel ?? UILabel()
        menutitleName.text = ""
        
        debugPrint("Section Count%@",section)
        menutitleName.font = UIFont(name: "HelveticaNeue", size: 18.0)
        if section==logoutButton
        {
            menutitleName.frame = CGRect(x: 0, y: 5, width: headerView.frame.width, height: headerView.frame.height-20)
            menutitleName.textAlignment = .center
            menutitleName.font = UIFont(name: "HelveticaNeue", size: 16.0)

            menutitleName.backgroundColor = UIColor(red: 23/255, green: 23/255, blue: 23/255, alpha: 1)
            menuImage.frame = CGRect(x: headerView.frame.width/2-80, y: 15, width: 30, height: 30)
        } else {
            menutitleName.frame = CGRect(x: 50, y: -5,width: headerView.frame.width-50, height: headerView.frame.height-10)
            menutitleName.textAlignment = .left
            menutitleName.backgroundColor = UIColor.clear
            menuImage.frame = CGRect(x: 15, y: 20, width: 20, height: 20)
            if section==expendedMenu
            {
                menuImage.frame = CGRect(x: 15, y: 15, width: 15, height: 24)
            }
        }
        menutitleName.tag = 12
        menutitleName.text = (sectionNames[section] as! String)
       
        menutitleName.textColor = UIColor.white
        menutitleName.numberOfLines = 0
        
        print_debug(object: "2")
        
        headerView.addSubview(menutitleName)
        print_debug(object: "3")
        headerView.removeFromSuperview()
        print_debug(object: "6")
        
        
        header.addSubview(headerView)
        
        
        print_debug(object: "4")
        header.addSubview(menuImage)
        print_debug(object: "5")
        let headerFrame = self.view.frame.size
        //self.view.frame.size
        let theImageView = header.viewWithTag(13) as? UIImageView ?? UIImageView(frame: CGRect(x: headerFrame.width - 32, y: 20, width: 10, height: 17));
        theImageView.image = UIImage(named: "frwd")
        
//        if section==8
//        {
//            theImageView.frame = CGRect(x: headerFrame.width - 40, y: 30, width: 17, height: 10)
//            theImageView.image = UIImage(named: "dwnArrow")
//        }
//        else
//        {
//            theImageView.frame = CGRect(x: headerFrame.width - 32, y: 30, width: 10, height: 17)
//            //theImageView.image = UIImage(named: "dwnArrow")
//        }
        if section==logoutButton
        {
            theImageView.image = UIImage(named: "")
        }
        theImageView.tag = 13 //kHeaderSectionTag + section
        
        header.addSubview(theImageView)
        
        // make headers touchable
        header.tag = section
        let headerTapGesture = UITapGestureRecognizer()
        headerTapGesture.addTarget(self, action: #selector(MoreViewController.sectionHeaderWasTouched(_:)))
        header.addGestureRecognizer(headerTapGesture)
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = moreTblView.dequeueReusableCell(withIdentifier: TableViewCellName.moreTableViewCell, for: indexPath) as! MoreTableViewCell
        
        if cell == nil
        {
            cell = MoreTableViewCell(style: UITableViewCell.CellStyle.default, reuseIdentifier: TableViewCellName.moreTableViewCell)
        }
        let section = self.sectionItems[indexPath.section] as! NSArray
        cell.lblMoreTitleName.text = section[indexPath.row] as? String
        let sectionImg = self.subSectionImg[indexPath.section] as! NSArray
        cell.moreTitleImg.image = UIImage(named: sectionImg[indexPath.row] as! String)
        let templateImage = cell.moreTitleImg.image?.withRenderingMode(.alwaysTemplate)
        cell.moreTitleImg.image = templateImage
        cell.moreTitleImg.tintColor = UIColor.white
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        
        if indexPath.row == 0
        {
            menuFAQFirbaseAnalysics()
            navigateScreenToStoryboardMain(identifier: ViewIdentifier.faqIdentifier, controller: FAQViewController.self)
        }
        else if (indexPath.row==1)
        {
            menuCreateSRFirbaseAnalysics()
            goCreateSRScreen(fromScreen: "Menu")
        }
        else if (indexPath.row==2)
        {
            menuContactUSFirbaseAnalysics()
            navigateScreenToStoryboardMain(identifier: ViewIdentifier.contactUsIdentifier, controller: ContactUSViewController.self)
        }
        else if (indexPath.row==3)
        {
            menuPrivacyPolicyFirbaseAnalysics()
            privacPolicyView(withLink: WebLinks.privacyPolicy)
        }
        else if (indexPath.row==4)
        {
            menuDisclaimerFirbaseAnalysics()
            privacPolicyView(withLink: WebLinks.disclaimer)
        }
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath)
    {
        moreTblView.deselectRow(at: indexPath, animated: true)
    }
    
    // MARK: - Expand / Collapse Methods
    @objc func sectionHeaderWasTouched(_ sender: UITapGestureRecognizer) {
        let headerView = sender.view as! UITableViewHeaderFooterView
        let section    = headerView.tag
        let eImageView = headerView.viewWithTag(13) as? UIImageView ?? UIImageView()
        if section == logoutButton
        {
            HelpingClass.saveToUserDefault(value: false as AnyObject, key: "status")
            Switcher.updateRootVC()
            return
        }
        if section != expendedMenu {
            
            let sectionData = self.sectionItems[section] as! NSArray
            
            if (sectionData.count == 0)
            {
                
                if isUnlimitedSelected == true{
                    
                    if section==0
                    {
                        menuMyPlanFirbaseAnalysics()
                        navigateScreenToStoryboard(identifier: ViewIdentifier.planIdentifier, controller: PlanViewController.self)
                    }
                    else if section == 1
                    {
                        menuChangePlanFirbaseAnalysics()
                        chnagePlanScreen(WithCanID: canID, pckgID: packgID,typeOf: "")
                    }
                    else if section == 2
                    {
                        
                        // ConsumedTopupPlanVC
                        topupScreen(WithCanID: canID, pckgID: packgID)
                        
                        //consumedTopupScreen(WithCanID: canID, pckgID: packgID)
                    }
                    else if section == 3
                    {
                        menuMyTansectionFirbaseAnalysics()
                        AppDelegate.sharedInstance.navigateFrom=TabViewScreenName.Payment
                        navigateScreen(identifier: ViewIdentifier.customTabIdentifier, controller: CustomTabViewController.self)
                    }
                    else if section == 4
                    {
                        menuAutoPayFirbaseAnalysics()
                        AppDelegate.sharedInstance.siTermCondtionAccept = ""
                        navigateScreenToStoryboardMain(identifier: ViewIdentifier.StandingInstructionIdentifier, controller: StandingInstractionViewController.self)
                    }
                    else if section == 5
                    {
                        menuMyAccountFirbaseAnalysics()
                        let vc = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: ViewIdentifier.AccountIdentifier) as? AccountViewController
                        vc?.fromScreen = FromScreen.menuScreen
                        self.navigationController?.pushViewController(vc!, animated: false)
                    }
                    else if section == 6
                    {
                        if AppDelegate.sharedInstance.segmentType == segment.userB2C
                        {
                            menuDataUsageFirbaseAnalysics()
                            navigateScreen(identifier: ViewIdentifier.dataUsageIdentifier, controller: DataUsageViewController.self)
                        }
                        else
                        {
                            navigateScreen(identifier: ViewIdentifier.mrtgIdentifier, controller: MRTGViewController.self)
                        }
                    }
                    else if section == 7
                    {
                        
                        menuPayForOtherFirbaseAnalysics()
                        navigateScreen(identifier: ViewIdentifier.payBillMultipleAccountsIdentifier, controller: PayBillMultipleAccountsViewController.self)
                        
                        
                        
                    }
                    else if section == 11
                    {
                        openMySpectraApp()
                        
                        
                    }
                    else if section == 8
                    {
                        menuFAQFirbaseAnalysics()
                        AppDelegate.sharedInstance.navigateFrom=TabViewScreenName.getHelp
                        navigateScreen(identifier: ViewIdentifier.customTabIdentifier, controller: CustomTabViewController.self)
                        
                    }
                    else if section == 9
                    {
                        menuPrivacyPolicyFirbaseAnalysics()
                        privacPolicyView(withLink: WebLinks.privacyPolicy)
                        
                    }
                    else if section == 10
                    {
                        menuDisclaimerFirbaseAnalysics()
                        privacPolicyView(withLink: WebLinks.disclaimer)
                        
                    }
                    return;
                    
                    
                    
                    
                }else{
                    if section==0
                    {
                        menuMyPlanFirbaseAnalysics()
                        navigateScreenToStoryboard(identifier: ViewIdentifier.planIdentifier, controller: PlanViewController.self)
                    }
                    else if section == 1
                    {
                        menuChangePlanFirbaseAnalysics()
                        chnagePlanScreen(WithCanID: canID, pckgID: packgID,typeOf: "")
                    }
                    else if section == 2
                    {
                        menuMyTansectionFirbaseAnalysics()
                        AppDelegate.sharedInstance.navigateFrom=TabViewScreenName.Payment
                        navigateScreen(identifier: ViewIdentifier.customTabIdentifier, controller: CustomTabViewController.self)
                    }
                    else if section == 3
                    {
                        menuAutoPayFirbaseAnalysics()
                        AppDelegate.sharedInstance.siTermCondtionAccept = ""
                        navigateScreenToStoryboardMain(identifier: ViewIdentifier.StandingInstructionIdentifier, controller: StandingInstractionViewController.self)
                    }
                    else if section == 4
                    {
                        menuMyAccountFirbaseAnalysics()
                        let vc = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: ViewIdentifier.AccountIdentifier) as? AccountViewController
                        vc?.fromScreen = FromScreen.menuScreen
                        self.navigationController?.pushViewController(vc!, animated: false)
                    }
                    else if section == 5
                    {
                        if AppDelegate.sharedInstance.segmentType == segment.userB2C
                        {
                            menuDataUsageFirbaseAnalysics()
                            navigateScreen(identifier: ViewIdentifier.dataUsageIdentifier, controller: DataUsageViewController.self)
                        }
                        else
                        {
                            navigateScreen(identifier: ViewIdentifier.mrtgIdentifier, controller: MRTGViewController.self)
                        }
                    }
                    else if section == 6
                    {
                        menuPayForOtherFirbaseAnalysics()
                        
                        navigateScreen(identifier: ViewIdentifier.payBillMultipleAccountsIdentifier, controller: PayBillMultipleAccountsViewController.self)
                        
                        
                    }
                    else if section == 10
                    {
                        openMySpectraApp()
                        
                        
                    }
                    else if section == 7
                    {
                        menuFAQFirbaseAnalysics()
                        AppDelegate.sharedInstance.navigateFrom=TabViewScreenName.getHelp
                        navigateScreen(identifier: ViewIdentifier.customTabIdentifier, controller: CustomTabViewController.self)
                        
                        
                    }
                    else if section == 8
                    {
                        menuPrivacyPolicyFirbaseAnalysics()
                        privacPolicyView(withLink: WebLinks.privacyPolicy)
                        
                    }
                    else if section == 9
                    {
                        
                        menuDisclaimerFirbaseAnalysics()
                        privacPolicyView(withLink: WebLinks.disclaimer)
                    }
                    return;
                    
                    
                }
            }
            
        }else{
            
            if (expandedSectionHeaderNumber == -1)
            {
                expandedSectionHeaderNumber = section
                tableViewExpandSection(section, imageView: eImageView)
            } else {
                if (expandedSectionHeaderNumber == section) {
                    tableViewCollapeSection(section, imageView: eImageView)
                } else {
                    let cImageView = headerView.viewWithTag(13) as? UIImageView ?? UIImageView()
                    tableViewCollapeSection(expandedSectionHeaderNumber, imageView: cImageView)
                    tableViewExpandSection(section, imageView: eImageView)
                }
            }
        }
        
        
        
    }
    
    func tableViewCollapeSection(_ section: Int, imageView: UIImageView) {
        let sectionData = self.sectionItems[section] as! NSArray
        
        expandedSectionHeaderNumber = -1;
        if (sectionData.count == 0) {
            return;
        } else {
            UIView.animate(withDuration: 0.4, animations: {
                imageView.transform = CGAffineTransform(rotationAngle: (0.0 * CGFloat(Double.pi)) / 180.0)
            })
            var indexesPath = [IndexPath]()
            for i in 0 ..< sectionData.count {
                let index = IndexPath(row: i, section: section)
                indexesPath.append(index)
            }
            moreTblView.beginUpdates()
            moreTblView.deleteRows(at: indexesPath, with: UITableView.RowAnimation.none)
            moreTblView.endUpdates()
            moreTblView.setContentOffset(.zero, animated: true)
        }
    }
    
    func tableViewExpandSection(_ section: Int, imageView: UIImageView)
    {
        let sectionData = self.sectionItems[section] as! NSArray
        
        
        if (sectionData.count == 0)
        {
            expandedSectionHeaderNumber = -1;
            return;
        }
        else
        {
            menuHelpFirbaseAnalysics()
            UIView.animate(withDuration: 0.4, animations: {
                imageView.transform = CGAffineTransform(rotationAngle: (180.0 * CGFloat(Double.pi)) / 180.0)
            })
            var indexesPath = [IndexPath]()
            for i in 0 ..< sectionData.count {
                let index = IndexPath(row: i, section: section)
                indexesPath.append(index)
            }
            expandedSectionHeaderNumber = section
            moreTblView.beginUpdates()
            moreTblView.insertRows(at: indexesPath, with: UITableView.RowAnimation.fade)
            moreTblView.endUpdates()
            moreTblView.scrollToBottom(animated: true)
        }
    }
    
    func openMySpectraApp(){
        
        if let url = URL(string: "https://apps.apple.com/in/app/my-spectra/id1480840102") {
            if #available(iOS 10, *) {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
                
            } else {
                UIApplication.shared.openURL(url)
            }
        }
    }
    
    func menuMyPlanFirbaseAnalysics(){
        
        let dictAnalysics = [AnanlysicParameters.canID:canID,
                             AnanlysicParameters.Category:AnalyticsEventsCategory.dashboard_menu,
                             AnanlysicParameters.Action:AnalyticsEventsActions.menu_my_plan,
                             AnanlysicParameters.EventType:AnanlysicParameters.ClickEvent]
        
        HelpingClass.sharedInstance.addFirebaseAnalysis(eventName: AnalyticsEventsName.menu_click_my_plan, parameters: dictAnalysics as? [String:AnyObject] ?? [String:AnyObject]() )
    }
    
    func menuChangePlanFirbaseAnalysics(){
        
        let dictAnalysics = [AnanlysicParameters.canID:canID,
                             AnanlysicParameters.Category:AnalyticsEventsCategory.dashboard_menu,
                             AnanlysicParameters.Action:AnalyticsEventsActions.menu_change_plan,
                             AnanlysicParameters.EventType:AnanlysicParameters.ClickEvent]
        
        HelpingClass.sharedInstance.addFirebaseAnalysis(eventName: AnalyticsEventsName.menu_click_change_plan, parameters: dictAnalysics as? [String:AnyObject] ?? [String:AnyObject]() )
    }
    func menuMyTansectionFirbaseAnalysics(){
        
        let dictAnalysics = [AnanlysicParameters.canID:canID,
                             AnanlysicParameters.Category:AnalyticsEventsCategory.dashboard_menu,
                             AnanlysicParameters.Action:AnalyticsEventsActions.menu_my_transactions,
                             AnanlysicParameters.EventType:AnanlysicParameters.ClickEvent]
        
        HelpingClass.sharedInstance.addFirebaseAnalysis(eventName: AnalyticsEventsName.menu_click_my_transactions, parameters: dictAnalysics as? [String:AnyObject] ?? [String:AnyObject]() )
    }
    func menuAutoPayFirbaseAnalysics(){
        
        let dictAnalysics = [AnanlysicParameters.canID:canID,
                             AnanlysicParameters.Category:AnalyticsEventsCategory.dashboard_menu,
                             AnanlysicParameters.Action:AnalyticsEventsActions.menu_auto_pay,
                             AnanlysicParameters.EventType:AnanlysicParameters.ClickEvent]
        
        HelpingClass.sharedInstance.addFirebaseAnalysis(eventName: AnalyticsEventsName.menu_click_auto_pay, parameters: dictAnalysics as? [String:AnyObject] ?? [String:AnyObject]() )
    }
    func menuMyAccountFirbaseAnalysics(){
        
        let dictAnalysics = [AnanlysicParameters.canID:canID,
                             AnanlysicParameters.Category:AnalyticsEventsCategory.dashboard_menu,
                             AnanlysicParameters.Action:AnalyticsEventsActions.menu_my_account,
                             AnanlysicParameters.EventType:AnanlysicParameters.ClickEvent]
        
        HelpingClass.sharedInstance.addFirebaseAnalysis(eventName: AnalyticsEventsName.menu_click_my_account, parameters: dictAnalysics as? [String:AnyObject] ?? [String:AnyObject]() )
    }
    func menuDataUsageFirbaseAnalysics(){
        
        let dictAnalysics = [AnanlysicParameters.canID:canID,
                             AnanlysicParameters.Category:AnalyticsEventsCategory.dashboard_menu,
                             AnanlysicParameters.Action:AnalyticsEventsActions.menu_data_usage,
                             AnanlysicParameters.EventType:AnanlysicParameters.ClickEvent]
        
        HelpingClass.sharedInstance.addFirebaseAnalysis(eventName: AnalyticsEventsName.menu_click_data_usage, parameters: dictAnalysics as? [String:AnyObject] ?? [String:AnyObject]() )
    }
    func menuPayForOtherFirbaseAnalysics(){
        
        let dictAnalysics = [AnanlysicParameters.canID:canID,
                             AnanlysicParameters.Category:AnalyticsEventsCategory.dashboard_menu,
                             AnanlysicParameters.Action:AnalyticsEventsActions.menu_pay_for_another,
                             AnanlysicParameters.EventType:AnanlysicParameters.ClickEvent]
        
        HelpingClass.sharedInstance.addFirebaseAnalysis(eventName: AnalyticsEventsName.menu_click_pay_for_anaother_account, parameters: dictAnalysics as? [String:AnyObject] ?? [String:AnyObject]() )
    }
    
    func menuHelpFirbaseAnalysics(){
        
        let dictAnalysics = [AnanlysicParameters.canID:canID,
                             AnanlysicParameters.Category:AnalyticsEventsCategory.dashboard_menu,
                             AnanlysicParameters.Action:AnalyticsEventsActions.menu_get_help,
                             AnanlysicParameters.EventType:AnanlysicParameters.ClickEvent]
        
        HelpingClass.sharedInstance.addFirebaseAnalysis(eventName: AnalyticsEventsName.menu_click_get_help, parameters: dictAnalysics as? [String:AnyObject] ?? [String:AnyObject]() )
    }
    func menuFAQFirbaseAnalysics(){
        
        let dictAnalysics = [AnanlysicParameters.canID:canID,
                             AnanlysicParameters.Category:AnalyticsEventsCategory.dashboard_menu,
                             AnanlysicParameters.Action:AnalyticsEventsActions.menu_get_help_faq,
                             AnanlysicParameters.EventType:AnanlysicParameters.ClickEvent]
        
        HelpingClass.sharedInstance.addFirebaseAnalysis(eventName: AnalyticsEventsName.menu_click_get_help_faq, parameters: dictAnalysics as? [String:AnyObject] ?? [String:AnyObject]() )
    }
    func menuCreateSRFirbaseAnalysics(){
        
        let dictAnalysics = [AnanlysicParameters.canID:canID,
                             AnanlysicParameters.Category:AnalyticsEventsCategory.dashboard_menu,
                             AnanlysicParameters.Action:AnalyticsEventsActions.menu_get_help_create_sr,
                             AnanlysicParameters.EventType:AnanlysicParameters.ClickEvent]
        
        HelpingClass.sharedInstance.addFirebaseAnalysis(eventName: AnalyticsEventsName.menu_click_get_help_create_sr, parameters: dictAnalysics as? [String:AnyObject] ?? [String:AnyObject]() )
    }
    func menuContactUSFirbaseAnalysics(){
        
        let dictAnalysics = [AnanlysicParameters.canID:canID,
                             AnanlysicParameters.Category:AnalyticsEventsCategory.dashboard_menu,
                             AnanlysicParameters.Action:AnalyticsEventsActions.menu_get_help_contact_us,
                             AnanlysicParameters.EventType:AnanlysicParameters.ClickEvent]
        
        HelpingClass.sharedInstance.addFirebaseAnalysis(eventName: AnalyticsEventsName.menu_click_get_help_contact_us, parameters: dictAnalysics as? [String:AnyObject] ?? [String:AnyObject]() )
    }
    func menuPrivacyPolicyFirbaseAnalysics(){
        
        let dictAnalysics = [AnanlysicParameters.canID:canID,
                             AnanlysicParameters.Category:AnalyticsEventsCategory.dashboard_menu,
                             AnanlysicParameters.Action:AnalyticsEventsActions.menu_get_help_privacy_policy,
                             AnanlysicParameters.EventType:AnanlysicParameters.ClickEvent]
        
        HelpingClass.sharedInstance.addFirebaseAnalysis(eventName: AnalyticsEventsName.menu_click_get_help_privacy_policy, parameters: dictAnalysics as? [String:AnyObject] ?? [String:AnyObject]() )
    }
    func menuDisclaimerFirbaseAnalysics(){
        
        let dictAnalysics = [AnanlysicParameters.canID:canID,
                             AnanlysicParameters.Category:AnalyticsEventsCategory.dashboard_menu,
                             AnanlysicParameters.Action:AnalyticsEventsActions.menu_get_help_legal_disclaimer,
                             AnanlysicParameters.EventType:AnanlysicParameters.ClickEvent]
        
        HelpingClass.sharedInstance.addFirebaseAnalysis(eventName: AnalyticsEventsName.menu_click_get_help_legal_disclaimer, parameters: dictAnalysics as? [String:AnyObject] ?? [String:AnyObject]() )
    }
}
extension UITableView {
    func scrollToBottom(animated: Bool) {
        let y = contentSize.height - frame.size.height
        if y < 0 { return }
        setContentOffset(CGPoint(x: 0, y: y), animated: animated)
    }
}

