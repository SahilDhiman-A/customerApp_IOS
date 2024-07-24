//
//  InvoicePDFContentData.swift
//  My Spectra
//
//  Created by Bhoopendra on 10/23/19.
//  Copyright © 2019 Bhoopendra. All rights reserved.
//

import UIKit
import RealmSwift
import ObjectMapper

class InvoicePDFContentData:  Object, Mappable {
    required convenience init?(map: Map) {
        self.init()
    }
    @objc dynamic var _response: Data? = nil
  
    
    func mapping(map: Map)
    {
        if let str = map["response"].currentValue as? String  {
            _response = str.data(using: .utf8)
        }
//        _response <- map["response"]
    }
}
