//
//  DatabaseHandler.swift
//  My Spectra
//
//  Created by Bhoopendra on 10/16/19.
//  Copyright © 2019 Bhoopendra. All rights reserved.
//

import UIKit
import Realm
import RealmSwift
import ObjectMapper

class DatabaseHandler: NSObject {
    //MARK: Get instance
       class func instance()->DatabaseHandler {
           return DatabaseHandler()
       }
    
    func getAndSaveLoginData(dict:NSArray?)
        {
            let realm = try! Realm()
            try! realm.write
            {
                let dataUsageResult = realm.objects(UserData.self)
                realm.delete(dataUsageResult)
            }
        
            guard let dito = dict else
            {
                return
            }
            for entry in dito
            {
                if let currentUser = Mapper<UserData>().map(JSONObject: entry)
                {
                    try! realm.write
                    {
                        realm.add(currentUser)
                    }
                }
            }
        }
    
    func getAndSaveSendOTPData(dict:NSArray?)
          {
              let realm = try! Realm()
              try! realm.write
              {
                  let dataUsageResult = realm.objects(OTPData.self)
                  realm.delete(dataUsageResult)
              }
          
              guard let dito = dict else
              {
                  return
              }
              for entry in dito
              {
                  if let currentUser = Mapper<OTPData>().map(JSONObject: entry)
                  {
                      try! realm.write
                      {
                          realm.add(currentUser)
                      }
                  }
              }
          }
    
    func getAndSaveUserHomeAccountData(dict:NSArray?)
     {
         let realm = try! Realm()
         try! realm.write
         {
             let dataUsageResult = realm.objects(UserCurrentData.self)
             realm.delete(dataUsageResult)
         }
     
         guard let dito = dict else
         {
             return
         }
         for entry in dito
         {
             if let currentUser = Mapper<UserCurrentData>().map(JSONObject: entry)
             {
                 try! realm.write
                 {
                     realm.add(currentUser)
                 }
             }
         }
     }
    
    func getAndSaveInvoiceListData(dict:NSArray?)
       {
           let realm = try! Realm()
           try! realm.write
           {
               let dataUsageResult = realm.objects(InvoiceListData.self)
               realm.delete(dataUsageResult)
           }
       
           guard let dito = dict else
           {
               return
           }
           for entry in dito
           {
               if let currentUser = Mapper<InvoiceListData>().map(JSONObject: entry)
               {
                   try! realm.write
                   {
                       realm.add(currentUser)
                   }
               }
           }
       }
    
    func getAndSaveInvoicePDFContentData(htmlString:String)
    {
        let realm = try! Realm()
        try! realm.write
        {
            let dataUsageResult = realm.objects(InvoicePDFContentData.self)
            realm.delete(dataUsageResult)
        }
       //   if let currentUser = Mapper<InvoicePDFContentData>().map(JSONObject: htmlString)
        
        let pdfData = InvoicePDFContentData()
        pdfData._response = htmlString.data(using: .utf8)
        try? realm.write {
            realm.add(pdfData)
        }
        
//        if let currentUser = Mapper<InvoicePDFContentData>().map(JSONString: htmlString)
//        {
//            do {
//                try? realm.write
//                {
//                    realm.add(currentUser)
//                }
//            } catch {
//                debugPrint("data saving errro = "+error.localizedDescription)
//            }
//            try! realm.write
//            {
//                realm.add(currentUser)
//            }
//        }
    }
    
    
    
    func getAndSaveTransactionData(dict:NSArray?)
          {
              let realm = try! Realm()
              try! realm.write
              {
                  let dataUsageResult = realm.objects(TransactionData.self)
                  realm.delete(dataUsageResult)
              }
          
              guard let dito = dict else
              {
                  return
              }
              for entry in dito
              {
                  if let currentUser = Mapper<TransactionData>().map(JSONObject: entry)
                  {
                      try! realm.write
                      {
                          realm.add(currentUser)
                      }
                  }
              }
          }
    
    func getAndSaveSRData(dict:NSArray?)
        {
            let realm = try! Realm()
            try! realm.write
            {
                let dataUsageResult = realm.objects(SRData.self)
                realm.delete(dataUsageResult)
            }
             
            guard let dito = dict else
            {
                return
            }
            for entry in dito
            {
                if let currentUser = Mapper<SRData>().map(JSONObject: entry)
                {
                    try! realm.write
                    {
                        realm.add(currentUser)
                    }
                }
            }
        }
    
    func getAndSaveChangePlan(dict:NSArray?)
       {
           let realm = try! Realm()
           try! realm.write
           {
               let dataUsageResult = realm.objects(ChangePlanData.self)
               realm.delete(dataUsageResult)
           }
       
           guard let dito = dict else
           {
               return
           }
           for entry in dito
           {
               if let currentUser = Mapper<ChangePlanData>().map(JSONObject: entry)
               {
                   try! realm.write
                   {
                       realm.add(currentUser)
                   }
               }
           }
       }
    
    func getAndSaveListOfTopupPlan(dict:NSArray?)
    {
        let realm = try! Realm()
        try! realm.write
        {
            let dataUsageResult = realm.objects(TopupPlanData.self)
            realm.delete(dataUsageResult)
        }
    
        guard let dito = dict else
        {
            return
        }
        for entry in dito
        {
            if let currentUser = Mapper<TopupPlanData>().map(JSONObject: entry)
            {
                try! realm.write
                {
                    realm.add(currentUser)
                }
            }
        }
    }
    
     func getAndSaveDataUsageData(dict:NSArray?)
     {
        let realm = try! Realm()
        try! realm.write
        {
            let dataUsageResult = realm.objects(DataUsageData.self)
            realm.delete(dataUsageResult)
        }
        
        guard let dito = dict else
        {
            return
        }
        for entry in dito
        {
            if let currentUser = Mapper<DataUsageData>().map(JSONObject: entry)
            {
                try! realm.write
                {
                    realm.add(currentUser)
                }
            }
        }
    }
    
    func getAndSaveUpdateGetContactsData(dict:NSArray?)
      {
          let realm = try! Realm()
          try! realm.write
          {
              let dataUsageResult = realm.objects(GetContactDetailsData.self)
              realm.delete(dataUsageResult)
          }
      
          guard let dito = dict else
          {
              return
          }
          for entry in dito
          {
              if let currentUser = Mapper<GetContactDetailsData>().map(JSONObject: entry)
              {
                  
                  do {
                      try? realm.write
                      {
                      realm.add(currentUser)
                      }
                  } catch
                  {
                      print("data saving errro = "+error.localizedDescription)
                  }
              }
          }
      }
    
    
    func userProfileSavedData(dicto: NSDictionary?) {
        
        let realm = try! Realm()
        try! realm.write
        {
            let dataUsageResult = realm.objects(UserProfileData.self)
            realm.delete(dataUsageResult)
            
            let _billTo = realm.objects(billTo.self)
            realm.delete(_billTo)
            
            let _shipTo = realm.objects(shipTo.self)
            realm.delete(_shipTo)
        }
                     
        if let currentUser = Mapper<UserProfileData>().map(JSONObject: dicto)
        {
            try! realm.write
            {
                realm.add(currentUser)
            }
        }
    }
}
