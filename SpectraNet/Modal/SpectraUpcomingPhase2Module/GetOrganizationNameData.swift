//
//  GetOrganizationNameData.swift
//  My Spectra
//
//  Created by Bhoopendra on 10/31/19.
//  Copyright © 2019 Bhoopendra. All rights reserved.
//

import UIKit
import RealmSwift
import ObjectMapper

class GetOrganizationNameData: Object, Mappable {
    required convenience init?(map: Map) {
        self.init()
    }
    @objc dynamic var name = ""
    
    func mapping(map: Map)
    {
        name <- map["name"]
    }
}
