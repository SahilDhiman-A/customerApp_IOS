//
//  DataUsageData.swift
//  SpectraNet
//
//  Created by Bhoopendra on 8/23/19.
//  Copyright © 2019 Bhoopendra. All rights reserved.
//

import UIKit
import RealmSwift
import ObjectMapper

class DataUsageData: Object, Mappable {
    required convenience init?(map: Map) {
        self.init()
    }
    @objc dynamic var actName = ""
    @objc dynamic var actNo = ""
    @objc dynamic var actid = ""
    @objc dynamic var bytesin = ""
    @objc dynamic var bytesout = ""
    @objc dynamic var closeReason = ""
    @objc dynamic var duration = ""
    @objc dynamic var ipaddr = ""
    @objc dynamic var macaddr = ""
    @objc dynamic var nasNo = ""
    @objc dynamic var sesNo = ""
    @objc dynamic var startDt = ""
    @objc dynamic var total = ""

    
    func mapping(map: Map) {
        
        actName <- map["actName"]
        actNo <- map["actNo"]
        actid <- map["actid"]
        bytesin <- map["bytesin"]
        bytesout <- map["bytesout"]
        closeReason <- map["closeReason"]
        duration <- map["duration"]
        ipaddr <- map["ipaddr"]
        macaddr <- map["macaddr"]
        nasNo <- map["nasNo"]
        sesNo <- map["sesNo"]
        startDt <- map["startDt"]
        total <- map["total"]
    }

}

