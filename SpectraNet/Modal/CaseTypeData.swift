//
//  CaseTypeData.swift
//  SpectraNet
//
//  Created by Bhoopendra on 8/23/19.
//  Copyright © 2019 Bhoopendra. All rights reserved.
//

import UIKit
import RealmSwift
import ObjectMapper

class CaseTypeData: Object, Mappable {
    required convenience init?(map: Map) {
        self.init()
    }
    @objc dynamic var actName = ""
    @objc dynamic var actNo = ""
    
    func mapping(map: Map)
    {
        actName <- map["actName"]
        actNo <- map["actNo"]
    }
    
}
