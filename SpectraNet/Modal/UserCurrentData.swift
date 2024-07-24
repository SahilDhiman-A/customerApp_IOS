//
//  UserCurrentData.swift
//  SpectraNet
//
//  Created by Bhoopendra on 8/9/19.
//  Copyright © 2019 Bhoopendra. All rights reserved.
//

import Foundation
import RealmSwift
import ObjectMapper

class UserCurrentData: Object, Mappable
{
    required convenience init?(map: Map) {
        self.init()
    }
    @objc dynamic var AccountActivationdate = ""
    @objc dynamic var AccountName = ""
    @objc dynamic var AccountStatus = ""
    @objc dynamic var BarringDate = ""
    @objc dynamic var BillEndDate = ""
    @objc dynamic var BillFrequency = ""
    @objc dynamic var BillStartDate = ""
    @objc dynamic var CANId = ""
    @objc dynamic var CancelledDate = ""
    @objc dynamic var DataConsumption = Double()
  //  @objc dynamic var DataConsumption = ""

    @objc dynamic var DueDate = ""
    @objc dynamic var ETR = ""
    @objc dynamic var ExETRCount = ""
    @objc dynamic var ExETRFlag = ""
    @objc dynamic var ExtendedETR = ""
    @objc dynamic var InvoiceAmount = ""
    @objc dynamic var InvoiceCreationDate = ""
    @objc dynamic var LastPayment = ""
    @objc dynamic var LastPaymentDate = ""
    @objc dynamic var MCaseStatus = ""
    @objc dynamic var MOpenSRCount = ""
    @objc dynamic var MSRCreatedOn = ""
    @objc dynamic var MSRNumber = ""
    @objc dynamic var MassOutage = ""
    @objc dynamic var Mcasecategory = ""
    @objc dynamic var McreationSubSubType = ""
    @objc dynamic var McreationSubSubTypeID = ""
    @objc dynamic var McreationSubType = ""
    @objc dynamic var McreationSubTypeID = ""
    @objc dynamic var McreationType = ""
    @objc dynamic var McreationTypeID = ""
    @objc dynamic var MultipleOpenSRFlag = ""
    @objc dynamic var OpenSRCount = ""
    @objc dynamic var OpenSRFlag = ""
    @objc dynamic var OutStandingAmount = ""
    @objc dynamic var Product = ""
    @objc dynamic var ProductSegment = ""
    @objc dynamic var SRCaseStatus = ""
    @objc dynamic var SRCreatedOn = ""
    @objc dynamic var SRETR = ""
    @objc dynamic var SRExETR = ""
    @objc dynamic var SRExETRFlag = ""
    @objc dynamic var SRNumber = ""
    @objc dynamic var SRcasecategory = ""
    @objc dynamic var SRcreationSubSubType = ""
    @objc dynamic var SRcreationSubSubTypeID = ""
    @objc dynamic var SRcreationSubType = ""
    @objc dynamic var SRcreationSubTypeID = ""
    @objc dynamic var SRcreationType = ""
    @objc dynamic var SRcreationTypeID = ""
    @objc dynamic var Segment = ""
    @objc dynamic var guid = ""
    @objc dynamic var planDataVolume = ""
    @objc dynamic var OutstandingBalanceFlag = false
    @objc dynamic var PreBarredFlag = false
    @objc dynamic var PreCanceledFlag = false
    @objc dynamic var FUPEnabled = true
    @objc dynamic var FUPFlag = true
    @objc dynamic var CallRestrictionFlag = false
    @objc dynamic var CancellationFlag = true
    @objc dynamic var BabyCareFlag = false
    @objc dynamic var BarringFlag = false
    @objc dynamic var Speed = ""
    @objc dynamic var actInProgressFlag = false
    dynamic var ivrNotification = List<String>()
    
  //  @objc dynamic var ivrNotification = NSArray()
    
    func mapping(map: Map)
    {
        DueDate <- map["DueDate"]
        AccountActivationdate <- map["AccountActivationdate"]
        AccountName <- map["AccountName"]
        AccountStatus <- map["AccountStatus"]
        BarringDate <- map["BarringDate"]
        BillEndDate <- map["BillEndDate"]
        BillFrequency <- map["BillFrequency"]
        BillStartDate <- map["BillStartDate"]
        CANId <- map["CANId"]
        CancelledDate <- map["CancelledDate"]
        ETR <- map["ETR"]
        ExETRFlag <- map["ExETRFlag"]
        ExtendedETR <- map["ExtendedETR"]
        InvoiceAmount <- map["InvoiceAmount"]
        InvoiceCreationDate <- map["InvoiceCreationDate"]
        LastPayment <- map["LastPayment"]
        LastPaymentDate <- map["LastPaymentDate"]
        MCaseStatus <- map["MCaseStatus"]
        MOpenSRCount <- map["MOpenSRCount"]
        MSRCreatedOn <- map["MSRCreatedOn"]
        MSRNumber <- map["MSRNumber"]
        MassOutage <- map["MassOutage"]
        Mcasecategory <- map["Mcasecategory"]
        McreationSubSubType <- map["McreationSubSubType"]
        McreationSubSubTypeID <- map["McreationSubSubTypeID"]
        McreationSubType <- map["McreationSubType"]
        McreationSubTypeID <- map["McreationSubTypeID"]
        McreationType <- map["McreationType"]
        McreationTypeID <- map["McreationTypeID"]
        MultipleOpenSRFlag <- map["MultipleOpenSRFlag"]
        OpenSRCount <- map["OpenSRCount"]
        OpenSRFlag <- map["OpenSRFlag"]
        OutStandingAmount <- map["OutStandingAmount"]
        Product <- map["Product"]
        ProductSegment <- map["ProductSegment"]
        SRCaseStatus <- map["SRCaseStatus"]
        SRCreatedOn <- map["SRCreatedOn"]
        SRETR <- map["SRETR"]
        SRExETR <- map["SRExETR"]
        SRExETRFlag <- map["SRExETRFlag"]
        SRNumber <- map["SRNumber"]
        SRcasecategory <- map["SRcasecategory"]
        SRcreationSubSubType <- map["SRcreationSubSubType"]
        SRcreationSubSubTypeID <- map["SRcreationSubSubTypeID"]
        SRcreationSubType <- map["SRcreationSubType"]
        SRcreationSubTypeID <- map["SRcreationSubTypeID"]
        SRcreationType <- map["SRcreationType"]
        SRcreationTypeID <- map["SRcreationTypeID"]
        Segment <- map["Segment"]
        guid <- map["guid"]
        planDataVolume <- map["planDataVolume"]
        Speed<-map["Speed"]
//        ivrNotification <- map["ivrNotification"]
        
      //  DataConsumption<-map["DataConsumption"]

        
//        if let _ivrNotification = map["ivrNotification"].currentValue as? NSArray {
//            ivrNotification =  _ivrNotification
//        }
        if let _DataConsumption = map["DataConsumption"].currentValue as? Double {
            DataConsumption =  _DataConsumption
        }
        
        if let _OutstandingBalanceFlag = map["OutstandingBalanceFlag"].currentValue as? String {
            OutstandingBalanceFlag =  _OutstandingBalanceFlag.lowercased() == "true"
            
        }
        
        if let _PreBarredFlag = map["PreBarredFlag"].currentValue as? String {
            PreBarredFlag =  _PreBarredFlag.lowercased() == "true"
        }
        
        if let _PreCanceledFlag = map["PreCanceledFlag"].currentValue as? String {
            PreCanceledFlag =  _PreCanceledFlag.lowercased() == "true"
        }
        
        if let _FUPEnabled = map["FUPEnabled"].currentValue as? String {
            FUPEnabled =  _FUPEnabled.lowercased() == "true"
        }
        
        if let _FUPFlag = map["FUPFlag"].currentValue as? String {
            FUPFlag =  _FUPFlag.lowercased() == "true"
        }
        
        if let _CallRestrictionFlag = map["CallRestrictionFlag"].currentValue as? String {
            CallRestrictionFlag =  _CallRestrictionFlag.lowercased() == "true"
        }
        
        if let _CancellationFlag = map["CancellationFlag"].currentValue as? String {
            CancellationFlag =  _CancellationFlag.lowercased() == "true"
        }
        
        if let _BabyCareFlag = map["BabyCareFlag"].currentValue as? String {
            BabyCareFlag =  _BabyCareFlag.lowercased() == "true"
        }
        
        if let _BarringFlag = map["BarringFlag"].currentValue as? String {
            BarringFlag =  _BarringFlag.lowercased() == "true"
        }
        if let _actInProgressFlag = map["actInProgressFlag"].currentValue as? String {
            actInProgressFlag =  _actInProgressFlag.lowercased() == "true"
        }

        if let _ivrNotificationArray = map["ivrNotification"].currentValue as? [[String: Any]] {
            var listIVR = List<String>()
            for obj in _ivrNotificationArray {
                listIVR.append(obj["message"] as? String ?? "")
                // TO REMOVE
//                listIVR.append((obj["message"] as? String ?? "") + " 1 ")
//                listIVR.append((obj["message"] as? String ?? "") + " 2 ")
                // TO REMOVE
            }
            ivrNotification = listIVR
        }
    }
}


