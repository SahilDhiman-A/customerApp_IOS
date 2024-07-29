//
//  GetContactDetailsData.swift
//  My Spectra
//
//  Created by Bhoopendra on 10/31/19.
//  Copyright © 2019 Bhoopendra. All rights reserved.
//

import UIKit
import RealmSwift
import ObjectMapper

class GetContactDetailsData: Object, Mappable {
    required convenience init?(map: Map) {
        self.init()
    }
    @objc dynamic var contactId = ""
    @objc dynamic var firstName = ""
    @objc dynamic var lastName = ""
    @objc dynamic var jobTitle = ""
    @objc dynamic var email = ""
    @objc dynamic var mobilePhone = ""

    func mapping(map: Map)
    {
        contactId <- map["contactId"]
        firstName <- map["firstName"]
        lastName <- map["lastName"]
        jobTitle <- map["jobTitle"]
        email <- map["email"]
        mobilePhone <- map["mobilePhone"]
    }
    
}
