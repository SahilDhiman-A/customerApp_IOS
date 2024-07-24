//
//  TrackOrderData.swift
//  My Spectra
//
//  Created by Bhoopendra on 10/31/19.
//  Copyright © 2019 Bhoopendra. All rights reserved.
//

import UIKit
import RealmSwift
import ObjectMapper

class TrackOrderData: Object, Mappable {
    required convenience init?(map: Map) {
        self.init()
    }
    @objc dynamic var CANID = ""
    @objc dynamic var BusinessSegment = ""
    @objc dynamic var Name = ""
    @objc dynamic var StatusDates = ""
    @objc dynamic var Status = ""
    @objc dynamic var StateCode = ""
    @objc dynamic var StatusCode = ""

    func mapping(map: Map)
    {
        CANID <- map["CANID"]
        BusinessSegment <- map["BusinessSegment"]
        Name <- map["Name"]
        StatusDates <- map["StatusDates"]
        Status <- map["Status"]
        StateCode <- map["StateCode"]
        StatusCode <- map["StatusCode"]
    }
}
