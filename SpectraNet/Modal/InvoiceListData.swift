//
//  InvoiceListData.swift
//  SpectraNet
//
//  Created by Bhoopendra on 8/9/19.
//  Copyright © 2019 Bhoopendra. All rights reserved.
//

import Foundation
import RealmSwift
import ObjectMapper
class InvoiceListData: Object, Mappable
{
    required convenience init?(map: Map) {
        self.init()
    }
    @objc dynamic var invoiceNo = ""
    @objc dynamic var actNo = ""
    @objc dynamic var startdt = ""
    @objc dynamic var enddt = ""
    @objc dynamic var duedt = ""
    @objc dynamic var invoicedt = ""
    @objc dynamic var openingBalance = ""
    @objc dynamic var amount = ""
    @objc dynamic var content = ""
    @objc dynamic var itNo = ""
    @objc dynamic var usrNo = ""
    @objc dynamic var unPaidBalance = ""
    @objc dynamic var voucherNo = ""
    @objc dynamic var orgNo = ""
    @objc dynamic var cslno = ""
    @objc dynamic var invoiceCharge = ""
    @objc dynamic var displayInvNo = ""
    @objc dynamic var tdsSlab = ""
    @objc dynamic var tdsAmount = Float()
    
    func mapping(map: Map) {
        
        invoiceNo <- map["invoiceNo"]
        actNo <- map["actNo"]
        startdt <- map["startdt"]
        enddt <- map["enddt"]
        duedt <- map["duedt"]
        invoicedt <- map["invoicedt"]
        openingBalance <- map["openingBalance"]
        amount <- map["amount"]
        content <- map["content"]
        itNo <- map["itNo"]
        usrNo <- map["usrNo"]
        unPaidBalance <- map["unPaidBalance"]
        voucherNo <- map["voucherNo"]
        orgNo <- map["orgNo"]
        cslno <- map["cslno"]
        invoiceCharge <- map["invoiceCharge"]
        displayInvNo <- map["displayInvNo"]
        tdsSlab <- map["tdsSlab"]
        if let _tdsAmount = map["tdsAmount"].currentValue as? Float {
            tdsAmount =  _tdsAmount
        }
    }
}

