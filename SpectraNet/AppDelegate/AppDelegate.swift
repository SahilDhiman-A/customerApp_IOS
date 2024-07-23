//
//  AppDelegate.swift
//  SpectraNet
//
//  Created by Bhoopendra on 7/11/19.
//  Copyright © 2019 Bhoopendra. All rights reserved.
//

import UIKit
import Firebase
import Crashlytics
import RealmSwift
import IQKeyboardManagerSwift
import Siren // Line 1
enum VersionError: Error {
    case invalidResponse, invalidBundleInfo
}
@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, UNUserNotificationCenterDelegate,MessagingDelegate {
    
    //MARK:- Shared Instance
    
    internal static let sharedInstance: AppDelegate =
    {
        return AppDelegate()
    }()
    
    var realm: Realm? = nil
    var window: UIWindow?
    var navigateFrom = String()
    var segmentType = String()
    var paySIStatus = String()
    var siTermCondtionAccept = String()
    var fileUrl = NSURL()
    var dbVersion = 10
    var userResult:Results<UserCurrentData>? = nil
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
    
        navigateFrom=""
        Switcher.updateRootVC()
       
//        Fabric.with([Crashlytics.self])
      // Fabric.sharedSDK().debug = true
        
        IQKeyboardManager.shared.enable = true
        
//        var newArguments = ProcessInfo.processInfo.arguments
//        newArguments.append("-FIRDebugEnabled")
//        ProcessInfo.processInfo.setValue(newArguments, forKey: "arguments")
       FirebaseApp.configure()
        //UIApplication.shared.statusBarStyle = .lightContent
        
        let config = Realm.Configuration(
            
            schemaVersion: UInt64(dbVersion),
            
            // Set the block which will be called automatically when opening a Realm with
            // a schema version lower than the one set above
            migrationBlock: { migration, oldSchemaVersion in
                // We haven’t migrated anything yet, so oldSchemaVersion == 0
                if (oldSchemaVersion < UInt64(self.dbVersion)) {
                    // Nothing to do!
                    // Realm will automatically detect new properties and removed properties
                    // And will update the schema on disk automatically
                }
        })
        
        // Tell Realm to use this new configuration object for the default Realm
        Realm.Configuration.defaultConfiguration = config
        
        
        
        // Now that we've told Realm how to handle the schema change, opening the file
        // will automatically perform the migration
        //        let realm = try! Realm()
        print_debug(object: Realm.Configuration.defaultConfiguration.fileURL!)
        
        self.forceUpdate()
        self.registerForPushNotification(application: application)
       
        
        return true
    }
    func forceUpdate() {
           let siren = Siren.shared
           siren.rulesManager = RulesManager(globalRules: .critical,
                                             showAlertAfterCurrentVersionHasBeenReleasedForDays: 0)

           siren.wail { results in
               switch results {
               case .success(let updateResults):
                   print("AlertAction ", updateResults.alertAction)
                   print("Localization ", updateResults.localization)
                   print("Model ", updateResults.model)
                   print("UpdateType ", updateResults.updateType)
               case .failure(let error):
                   print(error.localizedDescription)
               }
           }
       }
    
    
    func registerForPushNotification(application: UIApplication){
        if #available(iOS 10.0, *) {
            // For iOS 10 display notification (sent via APNS)
            UNUserNotificationCenter.current().delegate = self
            
            let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
            UNUserNotificationCenter.current().requestAuthorization(
                options: authOptions,
                completionHandler: {_, _ in })
        } else {
            let settings: UIUserNotificationSettings =
                UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil)
            application.registerUserNotificationSettings(settings)
        }
        
        application.registerForRemoteNotifications()
    }
    
    func application(_ application: UIApplication,
                     didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        Messaging.messaging().delegate = self
        Messaging.messaging().apnsToken = deviceToken
        let token = Messaging.messaging().fcmToken
        debugPrint("Firebase registration token: \(String(describing: token))")
        
    }
    
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?) {
        debugPrint("Firebase registration token: \(String(describing: fcmToken))")
        
        //let _:[String: String] = ["token": fcmToken ?? ""]
        
        // TODO: If necessary send token to application server.
        // Note: This callback is fired at each app startup and whenever a new token is generated.
    }
    
    
    //    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any]) {
    //        print(userInfo)
    //        if let messageID = userInfo["fcm_options"] {
    //            print("Message ID: \(messageID)")
    //        }
    //    }
    //
    //
    
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any],
                     fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        debugPrint(userInfo)
        if [UIApplication.State.active].contains(application.applicationState) == true{
            showNotification(userInfo: userInfo, application: application)
        } else {
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1.5, execute: {
                self.forKilledAndBackgroundState(userInfo: userInfo)
            })
        }
        completionHandler(UIBackgroundFetchResult.newData)
    }
    
       
    
    //MARK: FUNCTION TO HANDEL PUSH IN KILLED AND Background STATE
     func forKilledAndBackgroundState(userInfo: [AnyHashable: Any])  {
        // redirect screen on click of push banner
        if let orderInfo = userInfo["order_info"] as? String {
            
            
            let orderInfoValue:[String:AnyObject] = convertToDictionary(text: orderInfo) as [String : AnyObject]? ?? [String:AnyObject]()
            if let type = orderInfoValue["type"] as? String,let can_id = userInfo["can_id"] as? String,let notificationId = userInfo["_id"] as? String{
                self.navigatePushFor(type: type, can_id: can_id, notificationId: notificationId)
            }
        }
    }
    
    func convertToDictionary(text: String) -> [String: Any]? {
        
        if let data = text.data(using: .utf8) {
            do {
                return try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
            } catch {
                debugPrint(error.localizedDescription)
            }
        }
        return nil
    }

    
    func showNotification(userInfo:[AnyHashable : Any],application:UIApplication){
        
        if let aps = userInfo["aps"] as? [String: Any] {
            if let alert = aps["alert"] as? [String: Any]{
                if let body = alert["body"] as? String, let title = alert["title"] as? String {
                    if  let urlImageString = userInfo["image_url"] as? String {
                        self.showPushNotificationView(title: title, message: body, image: urlImageString, onclickAction: {
                            
                            if let orderInfo = userInfo["order_info"] as? String {
                                
                                
                                let orderInfoValue:[String:AnyObject] = self.convertToDictionary(text: orderInfo) as [String : AnyObject]? ?? [String:AnyObject]()
                                if let type = orderInfoValue["type"] as? String ,let can_id = userInfo["can_id"] as? String,let notificationId = userInfo["_id"] as? String{
                                    self.navigatePushFor(type: type, can_id: can_id, notificationId: notificationId)
                                }
                            }
                            // redirect screen on click of push banner
                        })
                    } else {
                        self.showPushNotificationView(title: title, message: body, image: nil, onclickAction: {
                            // redirect screen on click of push banner
                            if let orderInfo = userInfo["order_info"] as? String {
                                
                                
                                let orderInfoValue:[String:AnyObject] = self.convertToDictionary(text: orderInfo) as [String : AnyObject]? ?? [String:AnyObject]()
                                if let type = orderInfoValue["type"] as? String,let can_id = userInfo["can_id"] as? String,let notificationId = userInfo["_id"] as? String{
                                    self.navigatePushFor(type: type, can_id: can_id, notificationId: notificationId)
                                }
                            }
                        })
                    }
                }
            }
        }
    }
    
    func navigatePushFor(type: String,can_id:String,notificationId:String) {
        self.readNotification(id: notificationId)
        realm = try? Realm()
        userResult = self.realm!.objects(UserCurrentData.self)
        var  canID = ""
        if(userResult?.count ?? 0 > 0){
        if let userActData = userResult?[0]
        {
            canID  = userActData.CANId
            if can_id != canID{
                
                guard let vc = UIStoryboard.init(name: "Storyboard", bundle: nil).instantiateViewController(withIdentifier: ViewIdentifier.CanIdSwitchViewController) as? CanIdSwitchViewController else {
                    return
                }
                vc.modalPresentationStyle = .overCurrentContext


                   // Specify the anchor point for the popover.
                //vc.popoverPresentationController?.barButtonItem = vc
               // vc.canID = self.canID
                vc.canID = can_id
                vc.completionBlock = {[weak self] dataReturned in
                                //Data is returned **Do anything with it **
                    let vc = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: ViewIdentifier.AccountIdentifier) as? AccountViewController
                    //vc?.fromScreen = FromScreen.menuScreen
                    self?.getTopViewController().navigationController?.pushViewController(vc!, animated: false)
                            }
                let navigationBar = UINavigationController(rootViewController: vc)
                navigationBar.navigationBar.isHidden = true
                self.getTopViewController().present(navigationBar, animated: true) {
                }
               
                
                return
            }
        }
        }
        switch type.lowercased() {
        case "offer", "payment","general", "network related":
            guard let vc = UIStoryboard.init(name: "Storyboard", bundle: nil).instantiateViewController(withIdentifier: ViewIdentifier.NotificationIdentifier) as? NotificationViewController else {
                return
            }
           
            vc.canID = canID
            vc.isComingFromAppdelegate = true
            self.getTopViewController().navigationController?.pushViewController(vc, animated: false)
        case "service bar":
            Switcher.updateRootVC()
            break
        case "invoice generation":
            AppDelegate.sharedInstance.navigateFrom=TabViewScreenName.Payment
            navigateScreen(identifier: ViewIdentifier.customTabIdentifier, controller: CustomTabViewController.self)
            break
        case "quotabasedalert":
            Switcher.updateRootVC()
            break
        case "Spectra payment remainder":
            Switcher.updateRootVC()
            break
        case "spectra disconnection notice":
            Switcher.updateRootVC()
            break
        case "spectra service bar action":
            Switcher.updateRootVC()
            break
        case "bulk case closure":
            AppDelegate.sharedInstance.navigateFrom=TabViewScreenName.sr
            navigateScreen(identifier: ViewIdentifier.customTabIdentifier, controller: CustomTabViewController.self)
            break
        case "notify customer email and sms":
            AppDelegate.sharedInstance.navigateFrom=TabViewScreenName.sr
            navigateScreen(identifier: ViewIdentifier.customTabIdentifier, controller: CustomTabViewController.self)
            break
        default:
            break
        }
        
        
    }
    func myHandler(alert: UIAlertAction){

        print("You tapped: \(alert.title)")
        
        if alert.title == AlertViewButtonTitle.title_OK{
            
            let vc = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: ViewIdentifier.AccountIdentifier) as? AccountViewController
            //vc?.fromScreen = FromScreen.menuScreen
            self.getTopViewController().navigationController?.pushViewController(vc!, animated: false)
        }
    }
    
    func readNotification(id: String) {
           let apiURL = ServiceMethods.notificationServiceBaseUrl + "notification/readnotifications?_id=\(id)"
           print_debug(object: "apiURL =" + apiURL)
           CANetworkManager.sharedInstance.requestApiWithoutHUD(serviceName: apiURL, method: kHTTPMethod.PUT, postData: [:] as Dictionary<String, AnyObject>) { (response, error) in
               if response != nil {
               // self.navigateNotificationFortype(indexPath: indexpath)
               }
           }
       }
    
    func navigateScreen(identifier: String, controller: UIViewController.Type)
    {
        if let navigation = UIApplication.shared.keyWindow?.rootViewController as? UINavigationController{
        let vc = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: identifier)
            navigation.pushViewController(vc, animated: false)
        }
    }
    
    func navigateScreenSotoryBoard(identifier: String, controller: UIViewController.Type)
    {
        if let navigation = UIApplication.shared.keyWindow?.rootViewController as? UINavigationController{
        let vc = UIStoryboard.init(name: "Storyboard", bundle: Bundle.main).instantiateViewController(withIdentifier: identifier)
            navigation.pushViewController(vc, animated: false)
        }
    }
    
    func showPushNotificationView(title: String, message : String ,image: String?, onclickAction:@escaping ()->Void) {
        if PushNotificationView.notiFicationView != nil{
            if PushNotificationView.notiFicationView?.superview != nil{
                PushNotificationView.notiFicationView?.removeFromSuperview()
            }
        }
        PushNotificationView.notiFicationView = PushNotificationView.showPush(title: title, message: message, image: image, actionOnClick: onclickAction)
        UIApplication.shared.keyWindow?.addSubview( PushNotificationView.notiFicationView!)
        UIView.animate(withDuration: 0.5, animations: {
            PushNotificationView.notiFicationView?.alpha = 1
            let size = message.heightWithConstrainedWidth(width: UIScreen.main.bounds.width - 60, font: UIFont(name: "Helvetica", size: 15.0)!)
            let titleSize = title.heightWithConstrainedWidth(width: UIScreen.main.bounds.width - 60, font: UIFont(name: "Helvetica", size: 15.0)!)
            var additionalHeight: CGFloat = 60.0
            if let imgUrl = image, let _ = URL(string: imgUrl) {
                
                if(image != "string"){
                additionalHeight += 200.0
                }
            }
            PushNotificationView.notiFicationView?.frame = CGRect(x: 0, y: 10+UIApplication.shared.keyWindow!.safeAreaInsets.top, width: (UIApplication.shared.keyWindow?.frame.width)!, height: size.height + titleSize.height + additionalHeight)
            if PushNotificationView.notiFicationView?.superview != nil{
                DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 60, execute: {
                    PushNotificationView.notiFicationView?.hideNotification()
                })
            }
        })
    }
    
    
    func autoUpdateWebServiceCall(){
        
        let dict = ["Action":ActionKeys.forceUpdate, "Authkey":UserAuthKEY.authKEY]
        print_debug(object: dict)
        
        CANetworkManager.sharedInstance.requestApiWithoutHUD(serviceName: ServiceMethods.serviceBaseURL, method: kHTTPMethod.POST, postData: dict as Dictionary<String, AnyObject>) { (response, error) in
            
            print_debug(object: response)
            if response != nil
            {
                var dataResponse = NSDictionary()
                var checkStatus = String()
                
                if let dict = response as? NSDictionary
                {
                    dataResponse = dict
                }
                
                checkStatus = ""
                if let status = dataResponse.value(forKey: "status") as? String
                {
                    checkStatus = status.lowercased()
                }
                
                if checkStatus == Server.api_status
                {
                    
                    guard let respoceValue = dataResponse.value(forKey: "response") as? [String:Any] else
                    {
                        return
                    }
                    
                    
                    if let forceUpdate = respoceValue["forceUpdate"] as? String{
                        
                        if forceUpdate != "true"{
                            
                           
                        }
                    }
                    
                    
                    
                }
                
            }
            
        }
    }
   
    
    func getTopViewController() -> UIViewController {
        
        if  let navigationController = UIApplication.shared.keyWindow?.rootViewController as? UINavigationController {
            return navigationController.viewControllers.last!
        } else if let tabBarController = UIApplication.shared.keyWindow?.rootViewController as? UITabBarController {
            return (tabBarController.selectedViewController)!
        } else {
            return UIViewController()
        }
        
    }
    
    
    
    func applicationWillResignActive(_ application: UIApplication)
    {
        
    }
    
    func applicationDidEnterBackground(_ application: UIApplication)
    {
        self.window?.endEditing(true)
    }
    
    func applicationWillEnterForeground(_ application: UIApplication)
    {
    }
    
    func applicationDidBecomeActive(_ application: UIApplication)
    {
        
    }
    
    func applicationWillTerminate(_ application: UIApplication)
    {
        
    }
    
}


extension Bundle {
    var displayName: String? {
        return object(forInfoDictionaryKey: "CFBundleDisplayName") as? String
    }
}

