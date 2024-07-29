//
//  SendOtpToLinkAcntdata.swift
//  My Spectra
//
//  Created by Bhoopendra on 10/31/19.
//  Copyright © 2019 Bhoopendra. All rights reserved.
//

import UIKit
import RealmSwift
import ObjectMapper

class SendOtpToLinkAcntdata: Object, Mappable {
    required convenience init?(map: Map) {
        self.init()
    }
    @objc dynamic var mobileNo = ""
    @objc dynamic var OTP = ""
  
    
    func mapping(map: Map)
    {
        mobileNo <- map["mobileNo"]
        OTP <- map["OTP"]
    }
    
}
