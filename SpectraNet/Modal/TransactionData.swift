//
//  TransactionData.swift
//  SpectraNet
//
//  Created by Bhoopendra on 8/9/19.
//  Copyright © 2019 Bhoopendra. All rights reserved.
//


import Foundation
import Foundation
import RealmSwift
import ObjectMapper
class TransactionData: Object, Mappable
{
    required convenience init?(map: Map) {
        self.init()
    }
    @objc dynamic var amount = ""
    @objc dynamic var _description = ""
    @objc dynamic var paymentMode = ""
    @objc dynamic var transactionDate = ""
    @objc dynamic var transactionNo = ""
    @objc dynamic var type = ""
    
    func mapping(map: Map) {
        
        amount <- map["amount"]
        _description <- map["description"]
        paymentMode <- map["paymentMode"]
        transactionDate <- map["transactionDate"]
        transactionNo <- map["transactionNo"]
        type <- map["type"]
    }
}
/*
 amount = "118.0";
 description = "Test 123";
 paymentMode = "";
 transactionDate = "19-03-2019";
 transactionNo = 1777597;
 type = "Settlement (Credit)";
 */
/*
 
 @objc dynamic var amount = ""
 @objc dynamic var balance = ""
 @objc dynamic var coaNo = ""
 @objc dynamic var cslno = ""
 @objc dynamic var i18Key = ""
 @objc dynamic var invoiceNo = ""
 @objc dynamic var journalNo = ""
 @objc dynamic var ledgerActNo = ""
 @objc dynamic var narration = ""
 @objc dynamic var orientation = ""
 @objc dynamic var srlNo = ""
 @objc dynamic var transactionDate = ""
 @objc dynamic var voucherNo = ""
 @objc dynamic var voucherType = ""
 @objc dynamic var voucherTypeId = "" //instrumentDetail
 @objc dynamic var instrumentDetail = ""
 @objc dynamic var instrumentType = ""
 
 {
 
 amount <- map["amount"]
 balance <- map["balance"]
 coaNo <- map["coaNo"]
 cslno <- map["cslno"]
 i18Key <- map["i18Key"]
 invoiceNo <- map["invoiceNo"]
 journalNo <- map["journalNo"]
 ledgerActNo <- map["ledgerActNo"]
 narration <- map["narration"]
 orientation <- map["orientation"]
 srlNo <- map["srlNo"]
 transactionDate <- map["transactionDate"]
 voucherNo <- map["voucherNo"]
 voucherType <- map["voucherType"]
 voucherTypeId <- map["voucherTypeId"]
 instrumentDetail <- map["instrumentDetail"]
 instrumentType <- map["instrumentType"]
 }
 */
