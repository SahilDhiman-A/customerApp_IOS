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
    @objc dynamic var type = ""
    @objc dynamic var status = ""
    @objc dynamic var volume = ""
    @objc dynamic var descriptionTopUp = ""
    @objc dynamic var pgPrice = ""
    @objc dynamic var value = 1
    
    func mapping(map: Map)
    {
        id <- map["topup_id"]
        name <- map["topup_name"]
        price <- map["price"]
        descriptionTopUp <- map["description"]
        type <- map["type"]
        status <- map["status"]
        volume <- map["data_volume"]
         value  <- map["pg_price"]
        
        pgPrice = String(value)
        
        
       // print_debug(object: pgPrice)
    }
    
}
