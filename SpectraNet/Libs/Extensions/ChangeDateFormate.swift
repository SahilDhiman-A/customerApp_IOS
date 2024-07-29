//
//  ChangeDateFormate.swift
//  SpectraNet
//
//  Created by Yugasalabs-28 on 29/07/2019.
//  Copyright © 2019 Bhoopendra. All rights reserved.
//

import Foundation
import UIKit

extension UIViewController
{
    // Change Date Formate
    func setChangeDateFormate(previousDateStr: String) -> String {
        
        if(previousDateStr == ""){
            return ""
        }
        
        let inputFormatter = DateFormatter()
        inputFormatter.dateFormat = DateFormats.orderDateFormat
        let showDate = inputFormatter.date(from: previousDateStr)
        inputFormatter.dateFormat = DateFormats.dateFormatOnly
        let resultString = inputFormatter.string(from: showDate!)
        return resultString
    }
    
    func selectFromDate(datePicker: UIDatePicker, hiddenTranspView: UIView, hiddenDoneBTNView: UIView) {
        
        let date = Date()
        let format = DateFormatter()
        format.dateFormat = DateFormats.orderDateAndTime
        datePicker.date = date
        let date1 = Calendar.current.date(byAdding: .year, value: -5, to: Date())
        
        let calendar = Calendar.current
        var minDateComponent = calendar.dateComponents([.day,.month,.year], from: Date())
        minDateComponent.day = calendar.component(.day, from: date1!)
        minDateComponent.month = calendar.component(.month, from: date1!)
        minDateComponent.year = calendar.component(.year, from: date1!)
        
        let minDate = calendar.date(from: minDateComponent)
        
        var maxDateComponent = calendar.dateComponents([.day,.month,.year], from: date)
        maxDateComponent.day = calendar.component(.day, from: date)
        maxDateComponent.month = calendar.component(.month, from: date)
        maxDateComponent.year = calendar.component(.year, from: date)
        
        let maxDate = calendar.date(from: maxDateComponent)
        datePicker.minimumDate = minDate! as Date
        datePicker.maximumDate =  maxDate! as Date
        
        hiddenTranspView.isHidden = false
        hiddenDoneBTNView.isHidden = false
        datePicker.isHidden = false
        
        datePicker.backgroundColor = UIColor.white
    }
    
    func daysBetweenDates(startDate: Date, endDate: Date) -> Int {
        let calendar = Calendar.current
        let components = calendar.dateComponents([Calendar.Component.day], from: startDate, to: endDate)
        return components.day!
    }
    
    func selectToDate(datePicker: UIDatePicker, getFromStringDate: String, hiddenTranspView: UIView, hiddenDoneBTNView: UIView)
    {
        let format = DateFormatter()
        format.dateFormat = DateFormats.orderCurrentDateFormatOutPut
        let date1 = format.date(from: getFromStringDate)
        let calendar = Calendar.current
        var minDateComponent = calendar.dateComponents([.day,.month,.year], from: Date())
        minDateComponent.day = calendar.component(.day, from: date1!)
        minDateComponent.month = calendar.component(.month, from: date1!)
        minDateComponent.year = calendar.component(.year, from: date1!)
        
        let minDate = calendar.date(from: minDateComponent)
        var yearValue = Float()
        var dayValue = Int()
        var getCurrentDate1 = String()
         getCurrentDate1 = getCurrentDate(withFormate: DateFormats.orderCurrentDateFormatOutPut)
        
        let minYear: Int = minDateComponent.year!
        let maxYear: Int = getCurrentYear()
        
        if getCurrentDate1 == getFromStringDate
        {
            yearValue = 0
        }
        else if minYear < maxYear
        {
            yearValue = 1
        }
        else if minYear == maxYear
        {
            let oldDate = format.date(from: getFromStringDate)
            let newDate = format.date(from: getCurrentDate1)
            guard let oldDateStr = oldDate, let newDateStr = newDate else
            {
                return
            }
            print_debug(object: daysBetweenDates(startDate: oldDateStr, endDate: newDateStr))
            dayValue = daysBetweenDates(startDate: oldDateStr, endDate: newDateStr)
        }
        else
        {
            yearValue = 1
        }
        var maxDateComponent = calendar.dateComponents([.day,.month,.year], from: Date())
        maxDateComponent.day = calendar.component(.day, from: date1!)+Int(dayValue)
        maxDateComponent.month = calendar.component(.month, from: date1!)
        maxDateComponent.year = calendar.component(.year, from: date1!)+Int(yearValue)
        
        let maxDate = calendar.date(from: maxDateComponent)
        datePicker.minimumDate = minDate! as Date
        datePicker.maximumDate =  maxDate! as Date
        
        hiddenTranspView.isHidden = false
        hiddenDoneBTNView.isHidden = false
        datePicker.isHidden = false
        datePicker.backgroundColor = UIColor.white
    }
    
    // Get current date
    func getCurrentDate(withFormate: String)-> String
    {
        let date = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = withFormate
        let result = formatter.string(from: date)

        return result
    }
    
    // Get total number of days in current month
    func getLastNumberOfMonthPreviousDate(numberOfMonth: Int) -> String//
    {
        guard let previousMonth = Calendar.current.date(byAdding: .month, value: Int(numberOfMonth), to: Date()) else {
            return ""
        }
        let formatter = DateFormatter()
        // initially set the format based on your datepicker date / server String
        formatter.dateFormat = DateFormats.orderDateAndTime
        
        let myString = formatter.string(from: previousMonth) // string purpose I add here
        // convert your string to date
        let yourDate = formatter.date(from: myString)
        //then again set the date format whhich type of output you need
        formatter.dateFormat = DateFormats.orderCurrentDateFormatOutPut
        // again convert your date to string
        let myStringafd = formatter.string(from: yourDate!)
        return myStringafd
    }
    
    // Get change date formate
    func setInvoiceListDateFormate(previousDateStr: String, withPreviousDateFormte: String, replaeWithFormate: String) -> String {
        
        let inputFormatter = DateFormatter()
        inputFormatter.dateFormat = withPreviousDateFormte
        guard let showDate = inputFormatter.date(from: previousDateStr) else {
            return ""
        }
        inputFormatter.dateFormat = replaeWithFormate
        let resultString = inputFormatter.string(from: showDate)
        return resultString
    }
    
    // Change backgrond color of button click Data usage screen
    func setBackgroundColrAccordingToClic(selectedBGColor : UIColor,withSelectedBTN: UIButton, withUnselectedButton: UIButton,withUnselected2BTN: UIButton, unselectedBGColor: UIColor,withSelectedBool: Bool, unselectBool: Bool, withselecedLine: UILabel, unselect1: UILabel, unselect2: UILabel)
    {
        withSelectedBTN.setTitleColor(selectedBGColor, for: .normal)
        withUnselectedButton.setTitleColor(unselectedBGColor, for: .normal)
        withUnselected2BTN.setTitleColor(unselectedBGColor, for: .normal)
        withselecedLine.isHidden = withSelectedBool
        unselect1.isHidden = unselectBool
        unselect2.isHidden = unselectBool
    }
    
    // get Start date of Current month
    func getStartDateOfCurrentMonth() -> String
    {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.dateFormat = DateFormats.orderCurrentDateFormatOutPut
        var startDate = Date()
        var interval = TimeInterval()
        Calendar.current.dateInterval(of: .month, start: &startDate, interval: &interval, for: Date())
        let fromDate = formatter.string(from: startDate)
        var startDateOfCurrentMonth = String()
        startDateOfCurrentMonth = fromDate
        
        return startDateOfCurrentMonth
    }
    
    // Get Start date of last 6th month
    func getStartDateOf6Month(lastDate: Date) -> String
    {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.dateFormat = DateFormats.orderCurrentDateFormatOutPut
        var startDate = Date()
        startDate = lastDate
        var interval = TimeInterval()
        Calendar.current.dateInterval(of: .month, start: &startDate, interval: &interval, for: lastDate)
        let fromDate = formatter.string(from: startDate)
        var startDateOfCurrentMonth = String()
        startDateOfCurrentMonth = fromDate
        
        return startDateOfCurrentMonth
    }
   
    // Get Current with year : example: nameofMonth NameOfCurrentYear
    func getCurrentMonthAndYear(setLabelName: UILabel)
    {
        let calendar = NSCalendar.init(calendarIdentifier: NSCalendar.Identifier.gregorian)
        let currentYearInt = (calendar?.component(NSCalendar.Unit.year, from: Date()))!
        
        let currentDate = Date()
        let nameFormatter = DateFormatter()
        nameFormatter.dateFormat = DateFormats.orderOnlyFullNameMonth
        let name = nameFormatter.string(from: currentDate)
        setLabelName.text = String(format: "%@ %d",name,currentYearInt)
    }
    
    func getCurrentYear() -> Int
    {
         let calendar = NSCalendar.init(calendarIdentifier: NSCalendar.Identifier.gregorian)
         let currentYearInt = (calendar?.component(NSCalendar.Unit.year, from: Date()))!
        return currentYearInt
    }
    
    // Convert Byte to GB
    func convertByteToGB(total: String) -> String
    {
        let myFloat = (total as NSString).floatValue
        let final = myFloat/1024/1024/1024
        let str = String(format: "%.2f", final)
        return str
    }
}
