//
//  SRData.swift
//  SpectraNet
//
//  Created by Bhoopendra on 8/9/19.
//  Copyright © 2019 Bhoopendra. All rights reserved.
//

import Foundation
import RealmSwift
import ObjectMapper

class SRData: Object, Mappable
{
    required convenience init?(map: Map) {
        self.init()
    }
    @objc dynamic var ETR = ""
    @objc dynamic var lastUpdatedOn = ""
    @objc dynamic var problemType = ""
    @objc dynamic var source = ""
    @objc dynamic var status = ""
    @objc dynamic var srNumber = ""
    @objc dynamic var subSubType = ""
    @objc dynamic var subType = ""
 
    func mapping(map: Map)
    {
        ETR <- map["ETR"]
        lastUpdatedOn <- map["lastUpdatedOn"]
        problemType <- map["problemType"]
        source <- map["source"]
        status <- map["status"]
        srNumber <- map["srNumber"]
        subSubType <- map["subSubType"]
        subType <- map["subType"]
    }
}
