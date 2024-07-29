//
//  HelpingClass.swift
//  SpectraNet
//
//  Created by Bhoopendra on 9/19/19.
//  Copyright © 2019 Bhoopendra. All rights reserved.
//

import UIKit
import FirebaseAnalytics

class HelpingClass: NSObject {

    
    //MARK: User default
    
    static let sharedInstance = HelpingClass()
    var planSucessData = [String:String]()
    
    var deviceData = [String:[String]]();
    var  autoPayType = "1"
    fileprivate override init() {
        // Code to be executed once
        
        
    }
    
    func getCurrentMillis()->Int64
       {
           return  Int64(NSDate().timeIntervalSince1970 * 1000)
       }
    
    public func isValidPassword(value:String) -> Bool {
        let passwordRegex = "^(?=.*[A-Za-z])(?=.*\\d)(?=.*[$@$!%*#?&])[A-Za-z\\d$@$!%*#?&]{8,}$"
        return NSPredicate(format: "SELF MATCHES %@", passwordRegex).evaluate(with: value)
    }
    
    func heightForView(text:String, font:UIFont, width:CGFloat) -> CGFloat{
        let label:UILabel = UILabel(frame: CGRect(x: 0, y: 0, width: width, height: CGFloat.greatestFiniteMagnitude))
        label.numberOfLines = 0
        label.lineBreakMode = NSLineBreakMode.byWordWrapping
        label.font = font
        label.text = text

        label.sizeToFit()
        return label.frame.height
    }
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
    class  func removeFromUserDefaultForKey(key: String!)
    {
        let defaults = UserDefaults.standard
        let value = defaults.string(forKey: key! as String)
        if (value != nil) {
            defaults.removeObject(forKey: key! as String)
        }
        defaults.synchronize()
    }
    
    
    func convert(time : String ,fromFormate:String ,toFormate:String) -> String? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = fromFormate
        if let date = dateFormatter.date(from: time){
        dateFormatter.dateFormat = toFormate
        
         let result = dateFormatter.string(from: date)
            
            return result
        }
        
        return nil
        
        
        
    }
    func convert(time : String ,fromFormate:String) -> Date?{
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = fromFormate
        let date = dateFormatter.date(from: time)
        return date
        
    }
    func convert(date : Date ,fromFormate:String ) -> String? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = fromFormate
        let dateString = dateFormatter.string(from: date)
        
        return dateString
    }
    
    func addFirebaseAnalysis(eventName:String,parameters:[String:AnyObject]){
        
        
        print_debug(object: "evemtName = \(eventName)")
        print_debug(object: "parameters = \(parameters)")
       // Analytics.setAnalyticsCollectionEnabled(true)

        Analytics.logEvent(eventName, parameters: parameters)
    }
    
}
