//
//  GetLinkAccountData.swift
//  My Spectra
//
//  Created by Bhoopendra on 10/31/19.
//  Copyright © 2019 Bhoopendra. All rights reserved.
//

import UIKit
import RealmSwift
import ObjectMapper

class GetLinkAccountData:  Object, Mappable {
    required convenience init?(map: Map) {
        self.init()
    }
    @objc dynamic var base_canid = ""
    @objc dynamic var username = ""
    @objc dynamic var mobile = ""
    @objc dynamic var link_canid = ""
 

    func mapping(map: Map)
    {
        base_canid <- map["base_canid"]
        username <- map["username"]
        mobile <- map["mobile"]
        link_canid <- map["link_canid"]
    }
}
