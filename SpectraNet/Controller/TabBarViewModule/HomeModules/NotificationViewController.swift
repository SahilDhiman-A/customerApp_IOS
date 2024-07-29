//
//  NotificationViewController.swift
//  SpectraNet
//
//  Created by Bhoopendra on 8/5/19.
//  Copyright © 2019 Bhoopendra. All rights reserved.
//

import UIKit
import SwipeCellKit

enum DaysType: String {
    case today = "Today"
    case yesterday = "Yesterday"
    case other = "Other"
    
    func heading() -> String {
        return self.rawValue
    }
}

class NotificationViewController: UIViewController {
    
    
    
    @IBOutlet weak var notifiTblView: UITableView!
    
    var selectedIndexes = [Notification_info]()
    var iseditTrue:Bool = false
    var editButton: UIButton = UIButton()
    @IBOutlet weak var emptyStateView: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var notificationlabel: UILabel!
    @IBOutlet weak var searchButton: UIButton!
    @IBOutlet weak var archieveButton: UIButton!
    
    var notificationView = UIView()
    var refreshControl = UIRefreshControl()
    var isLoadingList : Bool = false
    var isComingFromAppdelegate : Bool = false
    var canID = String()
    var notificationData: NotificationModel?
    var currentPage = 0
    var totalPage = 0
    let pageLimit = 20
    
    
    //MARK: View controller life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.notificationData?.data?.removeAll()
        self.emptyStateView.isHidden = true
        let attributedStringColor = [NSAttributedString.Key.foregroundColor : UIColor.white];
        // create the attributed string
        notificationlabel.text = "Pull down to reload"
        let attributedString = NSAttributedString(string: "", attributes: attributedStringColor)
        refreshControl.attributedTitle = attributedString
        refreshControl.addTarget(self, action: #selector(self.refresh(_:)), for: .valueChanged)
        refreshControl.addTarget(self, action: #selector(self.refresh(_:)), for: .editingDidBegin)
        refreshControl.tintColor = UIColor.white
        
        notifiTblView.addSubview(refreshControl)
       getAllNotifications()
        notificationView = emptyStateView
    }
    /*
     Method to call Web service To call All notifications.
     
     - parameter isForRefresh: Object that take refresh is done, currentPage by defalut is 0 and added pageLimit with every call and currentPage is set to 0 for pull to refresh.
     - returns: Return values
     - warning: Warning if any
     
     # Notes: #
     1. Notes if any
     */
    
    func getAllNotifications(isForRefresh: Bool? = false,currentPage :Int? = 0 ) {
        
        
        let dict = HelpingClass.sharedInstance.deviceData
        
        if let canIdArray = dict["canId"] as? [String]{
        
            let stringRepresentation = canIdArray.joined(separator: ",")
            let apiURL = ServiceMethods.notificationServiceBaseUrl + "notification/getallnotifications?can_id=\(stringRepresentation)&skip=\(String(describing: currentPage!))&limit=\(pageLimit)"
        print_debug(object: "apiURL =" + apiURL)
        CANetworkManager.sharedInstance.requestApi(serviceName: apiURL, method: kHTTPMethod.GET, postData: [:] as Dictionary<String, AnyObject>) { (response, error) in
            if response != nil {
                if let responseData = response as? [String: Any] {
                    
                    if(currentPage == 0){
                        
                        self.notificationData?.data?.removeAll()
                    }
                  
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
                        
                            
                       
                        
                    }
                    else{
                        
                        self.notificationData?.data?.append(contentsOf: array2 ?? [NotificationData]())
                    }
//                        self.notificationData?.data?.append(contentsOf: array2 ?? [NotificationData]())
                        self.checkIfTableHasData()
                }
                if isForRefresh ?? false {
                    self.refreshControl.endRefreshing()
                }
                self.notifiTblView.reloadData()
                self.isLoadingList = false
            }
            
            self.isLoadingList = false
        }
        }
    }
    
    
    /*
     Method to check if Notification data count is zero or it has data
     
     - parameter parameterName: Description.
     - returns: Return values
     - warning: Warning if any
     
     # Notes: #
     1. Notes if any
     */
    
    func checkIfTableHasData()
    {
       
        if(self.notificationData?.data?.count == 0){
            //self.notificationlabel.text = ""
            self.notificationView.isHidden = false
           self.notifiTblView.tableHeaderView = self.notificationView
            
        }else{
            self.notificationlabel.text = "Pull down to reload"
            self.notificationView.isHidden = true
            self.notificationView = self.emptyStateView
            self.notifiTblView.tableHeaderView = UIView()
        }
    }
    
    
    /*
     Method to get data archievenotifications
     
     - parameter id: archiev notificats CanId with , For multiple canID ,indexpath : indexpath of selected call for single tableview call. .
     - returns: Return values
     - warning: Warning if any
     
     # Notes: #
     1. Notes if any
     */
    
    
    
    
    func archiveNotification(id: String, indexpath: IndexPath?) {
        if(id == ""){
            
            return
        }
        let apiURL = ServiceMethods.notificationServiceBaseUrl + "notification/archievenotifications?_id=\(id)"
        print_debug(object: "apiURL =" + apiURL)
        CANetworkManager.sharedInstance.requestApi(serviceName: apiURL, method: kHTTPMethod.PUT, postData: [:] as Dictionary<String, AnyObject>) { (response, error) in
            if response != nil {
                self.iseditTrue = false
                if let indexPath = indexpath {
                    self.notificationData?.data?[indexPath.section].notification_info?.remove(at: indexPath.row)
                    if( self.notificationData?.data?[indexPath.section].notification_info?.count == 0){
                        self.notificationData?.data?.remove(at: indexPath.section)
                        
                    }
                   
                    if(indexpath == nil){
                        self.getAllNotifications()
                        
                    }
                    
                    self.checkIfTableHasData()
                    self.notifiTblView.reloadData()
                
                } else {
                    self.selectedIndexes.removeAll()
                    self.getAllNotifications()
                }
            }
        }
    }
    
    
    /*
     Method to get data deletenotifications
     
     - parameter id: archiev notificats CanId with , For multiple canID ,indexpath : indexpath of selected call for single tableview call. .
     - returns: Return values
     - warning: Warning if any
     
     # Notes: #
     1. Notes if any
     */
    
    
    func deleteNotification(id: String, indexpath: IndexPath?) {
        
        if(id == ""){
            
            return
        }
        let apiURL = ServiceMethods.notificationServiceBaseUrl + "notification/deletenotifications?_id=\(id)"
        print_debug(object: "apiURL =" + apiURL)
        CANetworkManager.sharedInstance.requestApi(serviceName: apiURL, method: kHTTPMethod.Delete, postData: [:] as Dictionary<String, AnyObject>) { (response, error) in
            if response != nil {
                self.iseditTrue = false
                if let indexPath = indexpath {
                    self.notificationData?.data?[indexPath.section].notification_info?.remove(at: indexPath.row)
                    if( self.notificationData?.data?[indexPath.section].notification_info?.count == 0){
                        self.notificationData?.data?.remove(at: indexPath.section)
                        
                    }
                    self.checkIfTableHasData()
                    if(indexpath == nil){
                        self.getAllNotifications()
                        
                    }
                    self.notifiTblView.reloadData()
                } else {
                    self.selectedIndexes.removeAll()
                    self.getAllNotifications()
                }
            }
        }
    }
    
    
    /*
     Method to get data readnotifications
     
     - parameter id: archiev notificats CanId with , For multiple canID ,indexpath : indexpath of selected call for single tableview call. .
     - returns: Return values
     - warning: Warning if any
     
     # Notes: #
     1. Notes if any
     */
    
    func readNotification(id: String, indexpath: IndexPath) {
           let apiURL = ServiceMethods.notificationServiceBaseUrl + "notification/readnotifications?_id=\(id)"
           print_debug(object: "apiURL =" + apiURL)
           CANetworkManager.sharedInstance.requestApiWithoutHUD(serviceName: apiURL, method: kHTTPMethod.PUT, postData: [:] as Dictionary<String, AnyObject>) { (response, error) in
               if response != nil {
               // self.navigateNotificationFortype(indexPath: indexpath)
               }
           }
       }
    
    
    
    /*
     Method to Refresh for pull to refresh. It currentPage is set to zero.
     
     - parameter parameterName: Description.
     - returns: Return values
     - warning: Warning if any
     
     # Notes: #
     1. Notes if any
     */
    
    @objc func refresh(_ sender: AnyObject) {
        // Code to refresh table view
        //notificationlabel.text = ""
        currentPage = 0
        self.getAllNotifications(isForRefresh: true)
    }
    
    
    // Pagination: Detect last cellvisible
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        if (((scrollView.contentOffset.y + scrollView.frame.size.height) > scrollView.contentSize.height ) && !isLoadingList){
            self.isLoadingList = true
            self.loadMoreItemsForList()
        }
    }
    
    /*
     
     Method to loadMoreItemsForList for pagination there is conditio it should be less taht totalPage.
     - parameter parameterName: Description.
     - returns: Return values
     - warning: Warning if any
     
     # Notes: #
     1. <#Notes if any#>
     */
    
    func loadMoreItemsForList(){
        //        getListFromServer(currentPage)
        
        var intValue = 00
        for dataValue in (self.notificationData?.data) as! [NotificationData] as [NotificationData] {
            intValue += dataValue.notification_info?.count ?? 0
        }
       
        if(totalPage - 1 > intValue ){
            currentPage = currentPage + pageLimit
            self.getAllNotifications(currentPage: currentPage)
            
        }
    }
    
    
    /*
     Method to set table view in editing mode and multiple select iamges are shown . and wise versa.
     
     - parameter <#parameterName#>: <#Description#>.
     - returns: <#Return values#>
     - warning: <#Warning if any#>
     
     # Notes: #
     1. <#Notes if any#>
     */
    
    @objc func editButtonClick(_ sender: UIButton) {
        
        editButton.isSelected = false
        editButton.isHighlighted = false
        editButton.isSelected = false
        selectedIndexes.removeAll()
        if(self.iseditTrue == true){
            self.iseditTrue = false
            
            searchButton.setImage(UIImage(named: "searchIcn"), for: .normal)
            archieveButton.setImage(UIImage(named: "cardboard-box-Second"), for: .normal)
            titleLabel.isHidden = false
        }else{
            self.iseditTrue = true
            
            searchButton.setImage(UIImage(named: "delete-white"), for: .normal)
            archieveButton.setImage(UIImage(named: "cardboard-box_white"), for: .normal)
            titleLabel.isHidden = true
        }
        notifiTblView.reloadData()
        
    }
    
    
    /*
     This method is to select multiple cells for the archieve and delete
     
     it first check if notification Id existes in selectedIndexes. If yes Index is removed from selectedIndexes otherwise added to selectedIndexes array.
     
     - parameter parameterName: Description.
     - returns: Return values
     - warning: Warning if any
     
     # Notes: #
     1. Notes if any
     */
    
    @objc  @IBAction func selectNotifications(_ sender: UIButton) {
        
        let buttonPosition = sender.convert(CGPoint.zero, to: self.notifiTblView)
        guard let indexPath = self.notifiTblView.indexPathForRow(at: buttonPosition) else {
            return
        }
        if let notification = notificationData?.data?[indexPath.section].notification_info?[indexPath.row] {
            
            //            let containsEntry = selectedIndexes.contains{ $0["NotificationId"] as? String  == indexValue["NotificationId"] as? String }
            let index = selectedIndexes.firstIndex(where: {$0._id == notification._id})
            if((index) != nil){
                
                selectedIndexes.remove(at: index ?? 0)
            }else{
                selectedIndexes.append(notification)
            }
            
        }
        notifiTblView.reloadData()
    }
    
    
   
    /*
     Method to back view Controller
     
     - parameter parameterName: Description.
     - returns: Return values
     - warning: Warning if any
     
     # Notes: #
     1. Notes if any
     */
    
    @IBAction func backBTN(_ sender: Any) {
        
        if(self.isComingFromAppdelegate){
            Switcher.updateRootVC()
        }else{
        self.navigationController?.popViewController(animated: false)
        }
    }
    
    /*
     Method is called when archeive button cliecked. It iseditTrueis true we will call archieve web service with string separated with "," for multiple Can Id and if it is false It is redirected to ArchieveViewController
     
     - parameter parameterName: Description.
     - returns: Return values
     - warning: Warning if any
     
     # Notes: #
     1. Notes if any
     */
    
    @IBAction func archieveButtonClick(_ sender: Any) {
        if(self.iseditTrue == true){
            let selectedNotificationIDs = selectedIndexes.map{$0._id ?? ""}
            let selectedNotificationsString = selectedNotificationIDs.joined(separator:",")
            archiveNotification(id: selectedNotificationsString, indexpath: nil)
        }else{
            
            guard let vc = UIStoryboard.init(name: "Storyboard", bundle: nil).instantiateViewController(withIdentifier: ViewIdentifier.ArchieveViewController) as? ArchieveViewController else {
                return
            }
            vc.canID = self.canID
            self.navigationController?.pushViewController(vc, animated: false)
        }
        
    }
    
    
    /*
     Method is called when archeive button cliecked. It iseditTrueis true we will call Delete web service with string separated with "," for multiple Can Id and if it is false It is redirected to NotificationSearchViewController
     
     - parameter parameterName: Description.
     - returns: Return values
     - warning: Warning if any
     
     # Notes: #
     1. Notes if any
     */
   @IBAction func searchButtonClick(_ sender: Any) {
        if(self.iseditTrue == true){
            // Action for multiple delete
            let selectedNotificationIDs = selectedIndexes.map{$0._id ?? ""}
            let selectedNotificationsString = selectedNotificationIDs.joined(separator:",")
            deleteNotification(id: selectedNotificationsString, indexpath: nil)
        }else{
            guard let vc = UIStoryboard.init(name: "Storyboard", bundle: nil).instantiateViewController(withIdentifier: ViewIdentifier.NotificationSearchViewController) as? NotificationSearchViewController else {
                return
            }
            vc.canID = self.canID
            self.navigationController?.pushViewController(vc, animated: false)
        }
    }
    
    
    /*
     Method to get day from section
     
     - parameter section: Int Idex if the section .
     - returns: Tuple with type contain DaysType object and heading is heading string value
     - warning: Warning if any
     
     # Notes: #
     1. Notes if any
     */
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

extension NotificationViewController:UITableViewDelegate,UITableViewDataSource,SwipeTableViewCellDelegate{
    
    // MARK: - Table view data source
    func numberOfSections(in tableView: UITableView) -> Int {
        
        return notificationData?.data?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return notificationData?.data?[section].notification_info?.count ?? 0
    }
    
    
    
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        var cell : NotificationTableViewCell? = (notifiTblView.dequeueReusableCell(withIdentifier: TableViewCellName.notificationTableViewCell) as! NotificationTableViewCell)
        cell?.delegate = self
        if cell == nil {
            cell = NotificationTableViewCell(style: UITableViewCell.CellStyle.default, reuseIdentifier: TableViewCellName.notificationTableViewCell)
        }
        // Configure the cell...
        
       
        
        if let notification = notificationData?.data?[indexPath.section].notification_info?[indexPath.row] {
            if(iseditTrue == true){
                
                let index = selectedIndexes.firstIndex(where: {$0._id == notification._id })
                
                if((index) != nil){
                    cell?.selectButton.setImage(UIImage(named: "check"), for: .normal)
                }else{
                    
                    cell?.selectButton.setImage(UIImage(named: "CheckboxEmpty"), for: .normal)
                }
//                if  getDayForSection(section: indexPath.section).type == .today  //((objectArray[indexPath.section].sectionName) == "Today")
                if !(notification.is_read ?? false)
                {
                    cell?.viewContainer.layer.borderWidth = 2
                    cell?.viewContainer.layer.borderColor = UIColor.bgColors.cgColor
                    cell?.viewContainer.backgroundColor = UIColor.white
                    cell?.titleName.textColor = UIColor.black
                    
                    cell?.dicrption.textColor = UIColor.black
                }
                else
                {
                    cell?.viewContainer.layer.borderColor = UIColor.white.cgColor
                    cell?.viewContainer.backgroundColor = UIColor.white
                    cell?.titleName.textColor = UIColor.black
                    cell?.dicrption.textColor = UIColor.black
                }
                cell?.selectButton.backgroundColor = UIColor.clear
                cell?.selectButton.isHidden = false

                cell?.selectButton.isEnabled  = true

                cell?.selectButton.isUserInteractionEnabled = true
            }else{
                
                if let type =  notification.order_info?.type as? String{
                    
                    if(type.lowercased() == "payment") || (type.lowercased() == "spectra payment remainder"){
                        cell?.selectButton.setImage(UIImage(named: "credit-card"), for: .normal)
                    }else if(type.lowercased() == "offer") || (type.lowercased() == "spectra disconnection notice"){
                        cell?.selectButton.setImage(UIImage(named: "discount"), for: .normal)
                    }else{
                        cell?.selectButton.setImage(UIImage(named: "megaphone"), for: .normal)
                        
                    }
                }
                
                if !(notification.is_read ?? false)
                {
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
                cell?.selectButton.isEnabled  = false
                cell?.selectButton.backgroundColor = UIColor.white.withAlphaComponent(0.2)
                cell?.selectButton.isUserInteractionEnabled = false
            }
            cell?.titleName.text = notification.order_info?.title ?? ""
            cell?.dicrption?.text = notification.order_info?.sort_description ?? ""
        }
        
        
        return cell!
    }
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> [SwipeAction]? {
        if(iseditTrue == false){
            guard orientation == .right else { return nil }
            
            let deleteAction = SwipeAction(style: .default, title: "") { action, indexPath in
                // handle action by updating model with deletion
                self.deleteNotification(id: self.notificationData?.data?[indexPath.section].notification_info?[indexPath.row]._id ?? "", indexpath: indexPath)
            }
            deleteAction.backgroundColor = UIColor.white
            
            // customize the action appearance
            deleteAction.image = UIImage(named: "delete")
            let archieveButton = SwipeAction(style: .destructive, title: "") { action, indexPath in
                // handle action by updating model with deletion
                self.archiveNotification(id: self.notificationData?.data?[indexPath.section].notification_info?[indexPath.row]._id ?? "", indexpath: indexPath)
            }
            
            // customize the action appearance
            archieveButton.image = UIImage(named: "cardboard-box")
            archieveButton.backgroundColor = UIColor.white
            
            
            return [deleteAction,archieveButton]
        }else{
            
            return []
        }
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {

        if let notification = notificationData?.data?[indexPath.section].notification_info?[indexPath.row] {
            
            self.readNotification(id: self.notificationData?.data?[indexPath.section].notification_info?[indexPath.row]._id ?? "", indexpath: indexPath)
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
                        tableView.reloadData()
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
        }

       
            
       

        // objectArray[indexPath.section].sectionObjects[indexPath.row])
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40.0
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
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        
        
        return getDayForSection(section: section).heading.capitalized
    }
    
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView?
    {
        
        let frame: CGRect = tableView.frame
        let label = UILabel(frame: CGRectMake(20, 10, 200, 21))
        label.textAlignment = NSTextAlignment.left
        label.text = getDayForSection(section: section).heading.capitalized //objectArray[section].sectionName
        if  let font = UIFont(name: "HelveticaNeue-Medium", size: 12.0){
            label.font = font
            label.textColor = UIColor.lightText
        }
        
        
        let headerView: UIView = UIView(frame: CGRectMake(0, 0, frame.size.width, frame.size.height))
        headerView.backgroundColor = UIColor.clear
        
        if(section == 0){
            editButton  = UIButton(frame: CGRectMake(frame.size.width - 100, 10, 100, 20)) //
            if(self.iseditTrue == true){
                editButton.setTitle("Cancel", for: .normal)
            }else{
                editButton.setTitle("Edit", for: .normal)
                
            }
            
            editButton.setTitleColor(UIColor.red, for: .normal)
            
            editButton.addTarget(self, action: #selector(NotificationViewController.editButtonClick(_:)), for: .touchUpInside)
            headerView.addSubview(editButton)
        }
        headerView.addSubview(label)
        return headerView
    }
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView){

    
}


}
