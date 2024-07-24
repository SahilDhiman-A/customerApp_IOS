//
//  GetDayaStatusAccordingTime.swift
//  SpectraNet
//
//  Created by Bhoopendra on 7/30/19.
//  Copyright © 2019 Bhoopendra. All rights reserved.
//

import Foundation
import UIKit

extension UIViewController
{
    // This function used for get greeting message on home screen
    func getGreetingTime() -> String
    {
        var greeting = String()
        let date     = Date()
        let calendar = Calendar.current
        let hour     = calendar.component(.hour, from: date)
        let morning = 4; let afternoon=12; let evening=18; let night=21;
        if morning <= hour, hour < afternoon {
            greeting = "Good Morning"
        }else if afternoon <= hour, hour < evening{
            greeting = "Good Afternoon"
        }else if evening <= hour, hour <= night{
            greeting = "Good Evening"
        }else{
            greeting = "Good Evening"
        }
        return greeting
    }
    
    // This function used for PetrolPump Graph on home screen
    func setViewFraming(outOfData: Float, usageData: Float,viewHeight: Float, viewYorigin: Float) -> Float
    {
        var calculatedData = Float()
        calculatedData = usageData/outOfData
        var totlalDataPercentage = Float()
        totlalDataPercentage = calculatedData*100
        
        var calculateViewHeight = Float()
        calculateViewHeight = viewHeight*totlalDataPercentage
        
        var final = Float()
        final = viewYorigin+calculateViewHeight/100
        return final
    }
    
    // This function used for get leap year
    func isLeapYear (year : String )-> Bool{
        let date = year
        let dateFormatter3 = DateFormatter()
        dateFormatter3.dateFormat = DateFormats.orderCurrentDateFormatOutPut
        let curretYear = dateFormatter3.date(from: date as String)
        let cal = NSCalendar.current
        let year = cal.component(.year, from: (curretYear)!)
        return (( year%100 != 0) && (year%4 == 0)) || year%400 == 0;
    }
    
    // This function used for get number of days between tow dates
    func daysBetweenDates(startDate: String, endDate: String) -> Int
    {
        let dateFormatter3 = DateFormatter()
        dateFormatter3.dateFormat = DateFormats.orderCurrentDateFormatOutPut
        let end = dateFormatter3.date(from: endDate as String)
        let dateFormatter2 = DateFormatter()
        dateFormatter2.dateFormat = DateFormats.orderCurrentDateFormatOutPut
        let start = dateFormatter2.date(from: startDate as String)
        let calendar = Calendar.current
        let components = calendar.dateComponents([Calendar.Component.day], from: start!, to: end!)

        return components.day!
    }
}


