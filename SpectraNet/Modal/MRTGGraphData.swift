//
//  MRTGGraphData.swift
//  SpectraNet
//
//  Created by Bhoopendra on 9/5/19.
//  Copyright © 2019 Bhoopendra. All rights reserved.
//

import UIKit
import RealmSwift
import ObjectMapper

class MRTGGraphData:  Object, Mappable {
    required convenience init?(map: Map) {
        self.init()
    }
    @objc dynamic var response = ""
    
    func mapping(map: Map)
    {
        response <- map["response"]
    }
    
}
