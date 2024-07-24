//
//  MyPlanData.swift
//  SpectraNet
//
//  Created by Bhoopendra on 8/9/19.
//  Copyright © 2019 Bhoopendra. All rights reserved.
//

import Foundation
import RealmSwift
import ObjectMapper

class MyPlanData: Object, Mappable
{
    required convenience init?(map: Map) {
        self.init()
    }
    @objc dynamic var additionalInfo = ""
    @objc dynamic var basePrice = ""
    @objc dynamic var cno = ""
    @objc dynamic var createdt = ""
    @objc dynamic var defaultTimeout = ""
    @objc dynamic var _description = ""
    @objc dynamic var discount = ""
    @objc dynamic var domno = ""
    @objc dynamic var maxsessions = ""
    @objc dynamic var mbytesIn = ""
    @objc dynamic var mbytesOut = ""
    @objc dynamic var mbytesin_oninv = ""
    @objc dynamic var mbytesout_oninv = ""
    @objc dynamic var minbytepulse = ""
    @objc dynamic var mintimepulse = ""
    @objc dynamic var mrp = ""
    @objc dynamic var pcno = ""
    @objc dynamic var qosno_quotaexp = ""
    @objc dynamic var quotaExpiryPolicy = ""
    @objc dynamic var quotaExpirySvcno = ""
    @objc dynamic var quotano = ""
    @objc dynamic var rateplanentrycharge = ""
    @objc dynamic var rateplanexitcharge = ""
    @objc dynamic var servicePlanId = ""
    @objc dynamic var servicePlanNo = ""
    @objc dynamic var servicePlanType = ""
    @objc dynamic var sescount = ""
    @objc dynamic var setno = ""
    @objc dynamic var showadvertisement = ""
    @objc dynamic var status = ""
    @objc dynamic var stno = ""
    @objc dynamic var taxes = ""
    @objc dynamic var thirdpartyaaa = ""
    @objc dynamic var timeLimit = ""
    @objc dynamic var timeLimituom = ""
    @objc dynamic var transferValidity = ""
    @objc dynamic var tsMbytesin = ""
    @objc dynamic var tsMbytesout = ""
    @objc dynamic var tsTimelimit = ""
    @objc dynamic var updatedt = ""
    @objc dynamic var useBytesQuota = ""
    @objc dynamic var useSum = ""
    @objc dynamic var useTimeQuota = ""
    @objc dynamic var usetcplimit = ""
    @objc dynamic var usrcount = ""
    @objc dynamic var validPeriod = ""
    @objc dynamic var validityExpiryPolicy = ""
    @objc dynamic var validityExpirySvcno = ""
    @objc dynamic var validprduom = ""
    @objc dynamic var autorecharge = ""

    func mapping(map: Map) {
        
        additionalInfo <- map["additionalInfo"]
        basePrice <- map["basePrice"]
        cno <- map["cno"]
        createdt <- map["createdt"]
        defaultTimeout <- map["defaultTimeout"]
        _description <- map["description"]
        discount <- map["discount"]
        domno <- map["domno"]
        maxsessions <- map["maxsessions"]
        mbytesIn <- map["mbytesIn"]
        mbytesOut <- map["mbytesOut"]
        mbytesin_oninv <- map["mbytesin_oninv"]
        mbytesout_oninv <- map["mbytesout_oninv"]
        minbytepulse <- map["minbytepulse"]
        mintimepulse <- map["mintimepulse"]
        mrp <- map["mrp"]
        pcno <- map["pcno"]
        qosno_quotaexp <- map["qosno_quotaexp"]
        quotaExpiryPolicy <- map["quotaExpiryPolicy"]
        quotaExpirySvcno <- map["quotaExpirySvcno"]
        quotano <- map["quotano"]
        rateplanentrycharge <- map["rateplanentrycharge"]
        rateplanexitcharge <- map["rateplanexitcharge"]
        servicePlanId <- map["servicePlanId"]
        servicePlanNo <- map["servicePlanNo"]
        servicePlanType <- map["servicePlanType"]
        sescount <- map["sescount"]
        setno <- map["setno"]
        showadvertisement <- map["showadvertisement"]
        status <- map["status"]
        stno <- map["stno"]
        taxes <- map["taxes"]
        thirdpartyaaa <- map["thirdpartyaaa"]
        timeLimit <- map["timeLimit"]
        timeLimituom <- map["timeLimituom"]
        transferValidity <- map["transferValidity"]
        tsMbytesin <- map["tsMbytesin"]
        tsMbytesout <- map["tsMbytesout"]
        tsTimelimit <- map["tsTimelimit"]
        updatedt <- map["updatedt"]
        useBytesQuota <- map["useBytesQuota"]
        useSum <- map["useSum"]
        useTimeQuota <- map["useTimeQuota"]
        usetcplimit <- map["usetcplimit"]
        usrcount <- map["usrcount"]
        validPeriod <- map["validPeriod"]
        validityExpiryPolicy <- map["validityExpiryPolicy"]
        validityExpirySvcno <- map["validityExpirySvcno"]
        validprduom <- map["validprduom"]
        autorecharge <- map["autorecharge"]

    }
}


