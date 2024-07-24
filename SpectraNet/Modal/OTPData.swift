//
//  OTPData.swift
//  SpectraNet
//
//  Created by Bhoopendra on 8/9/19.
//  Copyright © 2019 Bhoopendra. All rights reserved.
//

import Foundation
import Foundation
import RealmSwift
import ObjectMapper
class OTPData: Object, Mappable
{
    required convenience init?(map: Map) {
        self.init()
    }
    @objc dynamic var mobileNo = ""
    @objc dynamic var OTP = ""
  
    func mapping(map: Map) {
        
        mobileNo <- map["mobileNo"]
        OTP <- map["OTP"]
    }
}

