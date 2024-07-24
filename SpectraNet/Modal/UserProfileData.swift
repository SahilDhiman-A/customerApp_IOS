//
//  UserProfileData.swift
//  My Spectra
//
//  Created by Bhoopendra on 11/6/19.
//  Copyright © 2019 Bhoopendra. All rights reserved.
//

import UIKit
import RealmSwift
import ObjectMapper

class UserProfileData:Object, Mappable {
    required convenience init?(map: Map) {
        self.init()
    }
    @objc dynamic var GSTN = ""
    @objc dynamic var TAN = ""
    @objc dynamic var installationA = ""
    @objc dynamic var installationB = ""
    @objc dynamic var BillingTo:BillingTo? = nil
    @objc dynamic var billTo:billTo? = nil
    @objc dynamic var shipTo:shipTo? = nil 

    
    func mapping(map: Map)
    {
        GSTN <- map["GSTN"]
        TAN <- map["TAN"]
        installationA <- map["installationA"]
        installationB <- map["installationB"]
        
        if let _ = map["BillingTo"].currentValue as? String {
            
        } else if let _ = map["BillingTo"].currentValue as? [String: AnyObject] {
            BillingTo <- map["BillingTo"]
        }
        
        billTo <- map["billTo"]
        shipTo <- map["shipTo"]
    }
    
}
class BillingTo: Object, Mappable {
    required convenience init?(map: Map) {
           self.init()
       }
    
   @objc dynamic var address = ""
   @objc dynamic var contactId = ""
   @objc dynamic var email = ""
   @objc dynamic var name = ""
    
    func mapping(map: Map)
    {
        address <- map["address"]
        contactId <- map["contactId"]
        email <- map["email"]
        name <- map["name"]
    }
}

class billTo: Object, Mappable {
    required convenience init?(map: Map) {
           self.init()
       }
    
   @objc dynamic var address = ""
   @objc dynamic var contactId = ""
   @objc dynamic var email = ""
   @objc dynamic var name = ""
   @objc dynamic var mobile = ""
   @objc dynamic var username = ""
    
    func mapping(map: Map)
    {
        address <- map["address"]
        contactId <- map["contactId"]
        email <- map["email"]
        name <- map["name"]
        mobile <- map["mobile"]
        username <- map["username"]
    }
}

class shipTo: Object, Mappable {
    required convenience init?(map: Map) {
           self.init()
       }
    
   @objc dynamic var address = ""
   @objc dynamic var contactId = ""
   @objc dynamic var email = ""
   @objc dynamic var name = ""
   @objc dynamic var mobile = ""
    
    func mapping(map: Map)
    {
        address <- map["address"]
        contactId <- map["contactId"]
        email <- map["email"]
        name <- map["name"]
        mobile <- map["mobile"]
    }
}

