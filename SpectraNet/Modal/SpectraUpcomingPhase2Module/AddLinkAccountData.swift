//
//  AddLinkAccountData.swift
//  My Spectra
//
//  Created by Bhoopendra on 10/31/19.
//  Copyright © 2019 Bhoopendra. All rights reserved.
//

import UIKit
import RealmSwift
import ObjectMapper

class AddLinkAccountData: Object, Mappable {
    required convenience init?(map: Map) {
        self.init()
    }
    @objc dynamic var id = ""
    
    func mapping(map: Map)
    {
        id <- map["id"]
    }
}
