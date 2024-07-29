//
//  NotificationSearchViewController.swift
//  My Spectra
//
//  Created by Chakshu on 26/11/20.
//  Copyright © 2020 Bhoopendra. All rights reserved.
//

import UIKit

class NotificationSearchViewController: UIViewController {
    @IBOutlet weak var notifiTblView: UITableView!
    @IBOutlet weak var tfSearch: UITextField!
    var canID = String()
    var notificationData: NotificationSearchModal?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tfSearch.delegate = self
    }
    
    @IBAction func backBTN(_ sender: Any) {
        self.navigationController?.popViewController(animated: false)
    }
    
    
    @objc func searchText(textField: UITextField) {
        debugPrint(textField.text)
        searchNotifications(searchText: textField.text ?? "")
    }
    
    func searchNotifications(searchText: String) {
        
        let dict = HelpingClass.sharedInstance.deviceData
        
        if let canIdArray = dict["canId"] as? [String]{
            let stringRepresentation = canIdArray.joined(separator: ",")
        let apiURL = ServiceMethods.notificationServiceBaseUrl + "notification/searchnotification?can_id=\(stringRepresentation)&search_keyword=\(searchText)"
        print_debug(object: "apiURL =" + apiURL)
        CANetworkManager.sharedInstance.requestApi(serviceName: apiURL, method: kHTTPMethod.GET, postData: [:] as Dictionary<String, AnyObject>) { (response, error) in
            if response != nil {
                if let responseData = response as? [String: Any] {
                    self.notificationData = NotificationSearchModal(dictionary: responseData as NSDictionary)
                }
                self.notifiTblView.reloadData()
            }
        }
    }
    }
    
    
}

extension NotificationSearchViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if let text = textField.text,
            let textRange = Range(range, in: text) {
            let updatedText = text.replacingCharacters(in: textRange,
                                                       with: string)
            if updatedText.count > 3 {
                NSObject.cancelPreviousPerformRequests(
                    withTarget: self,
                    selector: #selector(NotificationSearchViewController.searchText),
                    object: textField)
                self.perform(
                    #selector(NotificationSearchViewController.searchText),
                    with: textField,
                    afterDelay: 1.0)
            }
        }
        return true
    }
}

extension NotificationSearchViewController: UITableViewDelegate,UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return notificationData?.data?.count ?? 0
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        var cell : NotificationTableViewCell? = (notifiTblView.dequeueReusableCell(withIdentifier: TableViewCellName.NotificationCellIdentifier) as! NotificationTableViewCell)
        if cell == nil {
            cell = NotificationTableViewCell(style: UITableViewCell.CellStyle.default, reuseIdentifier: TableViewCellName.NotificationCellIdentifier)
        }
        
        
        if let notification = notificationData?.data?[indexPath.row] {
            
            
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
            
//            if  getDayForSection(row: indexPath.row).type == .today
//            {
//                cell?.viewContainer.layer.borderColor = UIColor.bgColors.cgColor
//                cell?.viewContainer.backgroundColor = UIColor.bgColors
//                cell?.titleName.textColor = UIColor.white
//                cell?.dicrption.textColor = UIColor.white
//            }
//            else
//            {
//                cell?.viewContainer.layer.borderColor = UIColor.gray.cgColor
//                cell?.viewContainer.backgroundColor = UIColor.gray
//                cell?.titleName.textColor = UIColor.black
//                cell?.dicrption.textColor = UIColor.black
//            }
            cell?.selectButton.isHidden = false
            
            cell?.titleName.text = notification.order_info?.title ?? ""
            cell?.dicrption?.text = notification.order_info?.sort_description ?? ""
            
            
        }
        
        
        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {

        if let notification = notificationData?.data?[indexPath.row] {
            
            
            if let canIDNotification = notification.can_id as? String{
                if canIDNotification != self.canID{
                    notificationData?.data?[indexPath.row].is_read = true
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
                    notificationData?.data?[indexPath.row].is_read = true
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
                    notificationData?.data?[indexPath.row].is_read = true
                    tableView.reloadData()
                    break


                default:
                    notificationData?.data?[indexPath.row].is_read = true
                    tableView.reloadData()
                    break
                }

                self.readNotification(id: notification._id ?? "", indexpath: indexPath)
            }
            
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
    func openNotificationDisplay(notificationInfo:NotificationSearchData)  {
        
        guard let vc = UIStoryboard.init(name: "Storyboard", bundle: nil).instantiateViewController(withIdentifier: ViewIdentifier.NotificationDisplayViewController) as? NotificationDisplayViewController else {
            return
        }
        vc.modalPresentationStyle = .overCurrentContext


           // Specify the anchor point for the popover.
        //vc.popoverPresentationController?.barButtonItem = vc
       // vc.canID = self.canID
        vc.isfromSearch = true
        vc.notificationSearchValue = notificationInfo
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
    
    func getDayForSection(row: Int) -> (type: DaysType,heading: String) {
        let calender = Calendar.current
        var day = DaysType.today
        if let dateString = notificationData?.data?[row].created_at, let date = HelpingClass.sharedInstance.convert(time: dateString, fromFormate: "YYYY-MM-dd'T'HH:mm:ss.sssZ") {
            if calender.isDateInToday(date) {
                day = DaysType.today
            } else if calender.isDateInYesterday(date) {
                day = DaysType.yesterday
            } else {
                day = DaysType.other
                return (type: day, heading: HelpingClass.sharedInstance.convert(time: dateString, fromFormate: "YYYY-MM-dd'T'HH:mm:ss.sssZ", toFormate: "dd MMM YYYY") ?? "Other")
            }
        }
        return (type: day, heading: day.heading())
    }
}
