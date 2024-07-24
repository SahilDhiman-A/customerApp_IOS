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
import Fabric
import RealmSwift
import IQKeyboardManagerSwift

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    //MARK:- Shared Instance
      
    internal static let sharedInstance: AppDelegate =
    {
           return AppDelegate()
    }()
       
    
    var window: UIWindow?
    var navigateFrom = String()
    var segmentType = String()
    var paySIStatus = String()
    var siTermCondtionAccept = String()
    var fileUrl = NSURL()
    var dbVersion = 4
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        navigateFrom=""
        Switcher.updateRootVC()
        FirebaseApp.configure()
        Fabric.with([Crashlytics.self])
        Fabric.sharedSDK().debug = true

        IQKeyboardManager.shared.enable = true

        
        UIApplication.shared.statusBarStyle = .lightContent
        
        let config = Realm.Configuration(
            // Set the new schema version. This must be greater than the previously used
            // version (if you've never set a schema version before, the version is 0).
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
        
        return true
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

