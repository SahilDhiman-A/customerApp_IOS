//
//  TopupPlanData.swift
//  My Spectra
//
//  Created by Bhoopendra on 9/27/19.
//  Copyright © 2019 Bhoopendra. All rights reserved.
//

import UIKit
import RealmSwift
import ObjectMapper

class TopupPlanData: Object, Mappable {
    required convenience init?(map: Map) {
        self.init()
    }
    @objc dynamic var id = ""
    @objc dynamic var name = ""
    @objc dynamic var price = ""
    @objc dynamic var tax = ""
    @objc dynamic var total = ""
    @objc dynamic var data = ""
    @objc dynamic var type = ""
    @objc dynamic var status = ""
    
    func mapping(map: Map)
    {
        id <- map["id"]
        name <- map["name"]
        price <- map["price"]
        tax <- map["tax"]
        total <- map["total"]
        data <- map["data"]
        type <- map["type"]
        status <- map["status"]
    }
    
}
