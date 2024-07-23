//
//  ArchieveViewController.swift
//  My Spectra
//
//  Created by Chakshu on 25/11/20.
//  Copyright © 2020 Bhoopendra. All rights reserved.
//

import UIKit
import SwipeCellKit
class ArchieveViewController: UIViewController,UITableViewDelegate,UITableViewDataSource,SwipeTableViewCellDelegate {
    @IBOutlet weak var emptyStateView: UIView!
    @IBOutlet weak var notifiTblView: UITableView!
    var isLoadingList : Bool = false
    var canID = String()
    var notificationData: NotificationModel?
    var currentPage = 0
    var totalPage = 0
    let pageLimit = 20
    override func viewDidLoad() {
        super.viewDidLoad()
        getAllNotifications()
    }
    
    func getAllNotifications(currentPage :Int? = 0 ) {
        
        let dict = HelpingClass.sharedInstance.deviceData
        
        if let canIdArray = dict["canId"] as? [String]{
        
            let stringRepresentation = canIdArray.joined(separator: ",")
            let apiURL = ServiceMethods.notificationServiceBaseUrl + "notification/getallarchievenotifications?can_id=\(stringRepresentation)&skip=\(String(describing: currentPage!))&limit=\(pageLimit)"
            
            print_debug(object: "apiURL =" + apiURL)
            CANetworkManager.sharedInstance.requestApi(serviceName: apiURL, method: kHTTPMethod.GET, postData: [:] as Dictionary<String, AnyObject>) { (response, error) in
                if response != nil {
                    if let responseData = response as? [String: Any] {
                        
                        if let total = responseData["additionalInfo"] as? Int{
                            
                            self.totalPage = total
                        }
                            let array = self.notificationData?.data as? [NotificationData]
                        self.notificationData = NotificationModel(dictionary: responseData as NSDictionary)
                            let array2 = self.notificationData?.data as? [NotificationData]
                            self.notificationData?.data?.removeAll()
                        
                        
                       
                            self.notificationData?.data?.append(contentsOf: array ?? [NotificationData]())
                        var index = 0
                        
                        if(self.notificationData?.data?.count != 0){
                            for valueSequence in (array2 ?? [NotificationData]()) as [NotificationData] {
                                
                                if (HelpingClass.sharedInstance.convert(time: self.notificationData?.data?.last?.created_at ?? "", fromFormate: "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'", toFormate: "dd MMM YYYY") ?? "Other") == (HelpingClass.sharedInstance.convert(time: valueSequence.created_at ?? "", fromFormate: "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'", toFormate: "dd MMM YYYY") ?? "Other") {
                                    
                                    var array:Array<Notification_info> = self.notificationData?.data?.last?.notification_info ?? [Notification_info]()
                                    array.append(contentsOf: valueSequence.notification_info ?? [Notification_info]())
                                    self.notificationData?.data?.last?.notification_info = array
                                }else{

                                    self.notificationData?.data?.append(valueSequence)
                                    
                                }
                            }
                            
                        }else{
                            
                            self.notificationData?.data?.append(contentsOf: array2 ?? [NotificationData]())
                        }
    //                        self.notificationData?.data?.append(contentsOf: array2 ?? [NotificationData]())
                          
                    }
                    self.isLoadingList = false
                    if(self.notificationData?.data?.count == 0){
                        self.emptyStateView.isHidden = false
                    }else{
                        
                        self.emptyStateView.isHidden = true
                    }
                    self.notifiTblView.reloadData()
                }
            }
        }
        
    }
    
    func deleteNotification(id: String, indexpath: IndexPath) {
        let apiURL = ServiceMethods.notificationServiceBaseUrl + "notification/deletenotifications?_id=\(id)"
        print_debug(object: "apiURL =" + apiURL)
        CANetworkManager.sharedInstance.requestApi(serviceName: apiURL, method: kHTTPMethod.PUT, postData: [:] as Dictionary<String, AnyObject>) { (response, error) in
            if response != nil {
                self.notificationData?.data?[indexpath.section].notification_info?.remove(at: indexpath.row)
                self.notifiTblView.reloadData()
            }
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
       
        return notificationData?.data?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return notificationData?.data?[section].notification_info?.count ?? 0
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        var cell : NotificationTableViewCell? = (notifiTblView.dequeueReusableCell(withIdentifier: TableViewCellName.NotificationCellIdentifier) as! NotificationTableViewCell)
        cell?.delegate = self
        if cell == nil {
            cell = NotificationTableViewCell(style: UITableViewCell.CellStyle.default, reuseIdentifier: TableViewCellName.NotificationCellIdentifier)
        }
        
        
        if let notification = notificationData?.data?[indexPath.section].notification_info?[indexPath.row] {
            
            if let type =  notification.order_info?.type as? String{
                
                if(type.lowercased() == "payment") || (type.lowercased() == "spectra payment remainder"){
                    cell?.selectButton.setImage(UIImage(named: "credit-card"), for: .normal)
                }else if(type.lowercased() == "offer" ) || (type.lowercased() == "spectra disconnection notice"){
                    cell?.selectButton.setImage(UIImage(named: "discount"), for: .normal)
                }else{
                    cell?.selectButton.setImage(UIImage(named: "megaphone"), for: .normal)
                    
                }
            }
            
            if !(notification.is_read ?? false)
            { //((objectArray[indexPath.section].sectionName) == "Today")
           
                cell?.viewContainer.layer.borderColor = UIColor.bgColors.cgColor
                cell?.viewContainer.backgroundColor = UIColor.bgColors
                cell?.titleName.textColor = UIColor.white
                cell?.dicrption.textColor = UIColor.white
            }
            else
            {
                cell?.viewContainer.layer.borderColor = UIColor.gray.cgColor
                cell?.viewContainer.backgroundColor = UIColor.gray
                cell?.titleName.textColor = UIColor.black
                cell?.dicrption.textColor = UIColor.black
            }
            cell?.selectButton.isHidden = false
            
            cell?.titleName.text = notification.order_info?.title ?? ""
            cell?.dicrption?.text = notification.order_info?.sort_description ?? ""
            
            
        }
        
        
        return cell!
    }
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> [SwipeAction]? {
        
        guard orientation == .right else { return nil }
        
        let deleteAction = SwipeAction(style: .default, title: "") { action, indexPath in
            // handle action by updating model with deletion
            self.deleteNotification(id: self.notificationData?.data?[indexPath.section].notification_info?[indexPath.row]._id ?? "", indexpath: indexPath)
        }
        deleteAction.backgroundColor = UIColor.white
        
        // customize the action appearance
        deleteAction.image = UIImage(named: "delete")
        
        
        
        return [deleteAction]
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {

        if let notification = notificationData?.data?[indexPath.section].notification_info?[indexPath.row] {
            
            
            if let canIDNotification = notification.can_id as? String{
                if canIDNotification != self.canID{
                    notificationData?.data?[indexPath.section].notification_info?[indexPath.row].is_read = true
                    tableView.reloadData()
                    guard let vc = UIStoryboard.init(name: "Storyboard", bundle: nil).instantiateViewController(withIdentifier: ViewIdentifier.CanIdSwitchViewController) as? CanIdSwitchViewController else {
                        return
                    }
                    vc.modalPresentationStyle = .overCurrentContext


                       // Specify the anchor point for the popover.
                    //vc.popoverPresentationController?.barButtonItem = vc
                   // vc.canID = self.canID
                    vc.canID = canIDNotification
                    vc.completionBlock = {[weak self] dataReturned in
                                    //Data is returned **Do anything with it **
                        let vc = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: ViewIdentifier.AccountIdentifier) as? AccountViewController
                        //vc?.fromScreen = FromScreen.menuScreen
                        self?.navigationController?.pushViewController(vc!, animated: false)
                                }
                    let navigationBar = UINavigationController(rootViewController: vc)
                    navigationBar.navigationBar.isHidden = true
                    self.present(navigationBar, animated: true) {
                    }
                    
                    return
                }
            
                
                
            }

            if let type =  notification.order_info?.type as? String{

                switch type.lowercased() {
                case "offer", "payment","general":
                    notificationData?.data?[indexPath.section].notification_info?[indexPath.row].is_read = true
                    self.openNotificationDisplay(notificationInfo: notification)
                case "service bar":
                    self.goToHomeScreen()
                    break
                case "invoice generation":
                    AppDelegate.sharedInstance.navigateFrom=TabViewScreenName.Payment
                    navigateScreen(identifier: ViewIdentifier.customTabIdentifier, controller: CustomTabViewController.self)
                    break
                case "quotabasedalert":
                    self.goToHomeScreen()
                    break
                case "Spectra payment remainder":
                    self.goToHomeScreen()
                    break
                case "spectra disconnection notice":
                    self.goToHomeScreen()
                    break
                case "spectra service bar action":
                    self.goToHomeScreen()
                    break
                case "bulk case closure":
                    AppDelegate.sharedInstance.navigateFrom=TabViewScreenName.sr
                    navigateScreen(identifier: ViewIdentifier.customTabIdentifier, controller: CustomTabViewController.self)
                    break
                case "notify customer email and sms":
                    AppDelegate.sharedInstance.navigateFrom=TabViewScreenName.sr
                    navigateScreen(identifier: ViewIdentifier.customTabIdentifier, controller: CustomTabViewController.self)
                    break
                case "network related":
                    notificationData?.data?[indexPath.section].notification_info?[indexPath.row].is_read = true
                    tableView.reloadData()
                    break


                default:
                    notificationData?.data?[indexPath.section].notification_info?[indexPath.row].is_read = true
                    tableView.reloadData()
                    break
                }


            }
            self.readNotification(id: self.notificationData?.data?[indexPath.section].notification_info?[indexPath.row]._id ?? "", indexpath: indexPath)
        }

      

        // objectArray[indexPath.section].sectionObjects[indexPath.row])
    }
    
    func readNotification(id: String, indexpath: IndexPath) {
           let apiURL = ServiceMethods.notificationServiceBaseUrl + "notification/readnotifications?_id=\(id)"
           print_debug(object: "apiURL =" + apiURL)
           CANetworkManager.sharedInstance.requestApiWithoutHUD(serviceName: apiURL, method: kHTTPMethod.PUT, postData: [:] as Dictionary<String, AnyObject>) { (response, error) in
               if response != nil {
               // self.navigateNotificationFortype(indexPath: indexpath)
               }
           }
       }
    
  
    
    func openNotificationDisplay(notificationInfo:Notification_info)  {
        
        guard let vc = UIStoryboard.init(name: "Storyboard", bundle: nil).instantiateViewController(withIdentifier: ViewIdentifier.NotificationDisplayViewController) as? NotificationDisplayViewController else {
            return
        }
        vc.modalPresentationStyle = .overCurrentContext


           // Specify the anchor point for the popover.
        //vc.popoverPresentationController?.barButtonItem = vc
       // vc.canID = self.canID
        vc.notificationvalue = notificationInfo
        self.present(vc, animated: true) {
        }
    }
    func myHandler(alert: UIAlertAction){
        debugPrint("You tapped: \(alert.title)")
        
        if alert.title == AlertViewButtonTitle.title_OK{
            
            let vc = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: ViewIdentifier.AccountIdentifier) as? AccountViewController
            //vc?.fromScreen = FromScreen.menuScreen
            self.navigationController?.pushViewController(vc!, animated: false)
        }
    }

    func goToHomeScreen()  {
        Switcher.updateRootVC()
    }
    
    // Pagination: Detect last cellvisible
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        if (((scrollView.contentOffset.y + scrollView.frame.size.height) > scrollView.contentSize.height ) && !isLoadingList){
            self.isLoadingList = true
            self.loadMoreItemsForList()
        }
    }
    
    func loadMoreItemsForList(){
        //          getListFromServer(currentPage)
        self.isLoadingList = false
        var intValue = 0
        for dataValue in (self.notificationData?.data) as! [NotificationData] as [NotificationData] {
            intValue += dataValue.notification_info?.count ?? 0
        }
        if(totalPage - 1 > intValue ){
            currentPage = currentPage + pageLimit
            self.getAllNotifications(currentPage: currentPage)
            
        }
    }
    
    @IBAction func backBTN(_ sender: Any) {
        self.navigationController?.popViewController(animated: false)
    }
  
    
    func getDayForSection(section: Int) -> (type: DaysType,heading: String) {
        let calender = Calendar.current
        var day = DaysType.today
        if let dateString = notificationData?.data?[section].created_at, let date = HelpingClass.sharedInstance.convert(time: dateString, fromFormate: "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'") {
            if calender.isDateInToday(date) {
                day = DaysType.today
            } else if calender.isDateInYesterday(date) {
                day = DaysType.yesterday
            } else {
                day = DaysType.other
                return (type: day, heading: HelpingClass.sharedInstance.convert(time: dateString, fromFormate: "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'", toFormate: "dd MMM YYYY") ?? "Other")
            }
        }
        return (type: day, heading: day.heading())
    }
    
}
