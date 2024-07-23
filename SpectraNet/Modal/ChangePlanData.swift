//
//  ChangePlanData.swift
//  SpectraNet
//
//  Created by Bhoopendra on 9/16/19.
//  Copyright © 2019 Bhoopendra. All rights reserved.
//

import UIKit
import RealmSwift
import ObjectMapper

class ChangePlanData: Object, Mappable {
    required convenience init?(map: Map) {
        self.init()
    }
    @objc dynamic var data = ""
    @objc dynamic var charges = ""
    @objc dynamic var frequency = ""
    @objc dynamic var planid = ""
    @objc dynamic var speed = ""
    @objc dynamic var _description = ""
   
    func mapping(map: Map) {
        
        data <- map["data"]
        charges <- map["charges"]
        frequency <- map["frequency"]
        planid <- map["planid"]
        speed <- map["speed"]
       _description <- map["description"]
    }
}
