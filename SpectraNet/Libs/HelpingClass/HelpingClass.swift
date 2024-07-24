//
//  HelpingClass.swift
//  SpectraNet
//
//  Created by Bhoopendra on 9/19/19.
//  Copyright © 2019 Bhoopendra. All rights reserved.
//

import UIKit

class HelpingClass: NSObject {

    
    //MARK: User default
    
    // save to user default
    class func saveToUserDefault (value: AnyObject? , key: String!)
    {
        let defaults = UserDefaults.standard
        defaults.set(value, forKey: key! as String)
        defaults.synchronize()
    }
    
    // Get from user default
    class func userDefaultForKey ( key: String?) -> String
    {
        let defaults = UserDefaults.standard
        let value = defaults.string(forKey: key! as String)
        if (value != nil) {
            return value!
        }
        return ""
    }
    
    // Remove from user default
    class  func removeFromUserDefaultForKey(key: NSString!)
    {
        let defaults = UserDefaults.standard
        let value = defaults.string(forKey: key! as String)
        if (value != nil) {
            defaults.removeObject(forKey: key! as String)
        }
        defaults.synchronize()
    }
}
