//
//  StringRegexValidation.swift
//  My Spectra
//
//  Created by Bhoopendra on 11/6/19.
//  Copyright © 2019 Bhoopendra. All rights reserved.
//

import Foundation
import UIKit

extension UIViewController
{
    // Check GST validation
    func isValidGSTIN(_ gstin : String)-> Bool {
        let gstinRegex = "^[0-9]{2}[A-Z]{5}[0-9]{4}[A-Z]{1}[1-9A-Z]{1}Z[0-9A-Z]{1}$"
        let test = NSPredicate(format: "SELF MATCHES %@", gstinRegex)
        return test.evaluate(with: gstin)
    }
    // let gstinRegex = "^([0][1-9]|[1-2][0-9]|[3][0-5])([a-zA-Z]{5}[0-9]{4}[a-zA-Z]{1}[1-9a-zA-Z]{1}[zZ]{1}[0-9a-zA-Z]{1})+$"

    // Check TAN validation
    func validateTANCardNumber(_ strTANNumber : String) -> Bool{
           let regularExpression = "[A-Z]{4}[0-9]{5}[A-Z]{1}"
           let panCardValidation = NSPredicate(format : "SELF MATCHES %@", regularExpression)
           return panCardValidation.evaluate(with: strTANNumber)
       }

    // Check EMAIL validation
    func validateEmail(enteredEmail:String) -> Bool {
            let emailFormat = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
            let emailPredicate = NSPredicate(format:"SELF MATCHES %@", emailFormat)
            let email = emailPredicate.evaluate(with: enteredEmail)

            return email
        }
     
    func isValidEmail(emailStr:String) -> Bool {
          let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"

          let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
          return emailPred.evaluate(with: emailStr)
      }
}

extension String {

     func isValidEmail(emailStr:String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"

        let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailPred.evaluate(with: emailStr)
    }
    
    var isValidMobileNo: Bool
    {
        let PHONE_REGEX = "^[6-9][0-9]{9}$";
        let phoneTest = NSPredicate(format: "SELF MATCHES %@", PHONE_REGEX)
        let result =  phoneTest.evaluate(with: self)
        return result
    }
   
    
}
