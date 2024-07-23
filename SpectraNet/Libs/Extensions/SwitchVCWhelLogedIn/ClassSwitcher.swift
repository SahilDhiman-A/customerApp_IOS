//
//  ClassSwitcher.swift
//  SpectraNet
//
//  Created by Bhoopendra on 8/2/19.
//  Copyright © 2019 Bhoopendra. All rights reserved.
//

import Foundation
import UIKit

class Switcher {
    
    static func updateRootVC()
    {
        let status = UserDefaults.standard.bool(forKey: "status")
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)

        if(status == true)
        {
            let navigationController = UINavigationController(rootViewController: storyBoard.instantiateViewController(withIdentifier: ViewIdentifier.customTabIdentifier))
            navigationController.setNavigationBarHidden(true, animated: true)
            appDelegate.window?.rootViewController = navigationController
        }
        else
        {
            
            HelpingClass.removeFromUserDefaultForKey(key: UserDefaultKeys.loginPhoneNumber as String)
            HelpingClass.removeFromUserDefaultForKey(key: UserDefaultKeys.isLoginFrom as String)
            let navigationController = UINavigationController(rootViewController: storyBoard.instantiateViewController(withIdentifier: ViewIdentifier.loginIdentifier))
            navigationController.setNavigationBarHidden(true, animated: true)
            appDelegate.window?.rootViewController = navigationController
        }
    }
}
