//
//  RemoveStringAfterSpecificChar.swift
//  SpectraNet
//
//  Created by Bhoopendra on 7/18/19.
//  Copyright © 2019 Bhoopendra. All rights reserved.
//

import Foundation
import UIKit

extension UIViewController
{
    // Replace string with new string from existing string
    func replaceStringWithStr(yourString: String,replaceStr: String, withSyring: String) -> String
    {
        let replaced = yourString.replacingOccurrences(of: replaceStr, with: withSyring)
       return replaced
    }

    // convert string to float value
    func convertStringtoFloatViceversa(amount: String) -> String {
        let myFloat = (amount as NSString).floatValue
        let amount =  String(format: "%.2f", myFloat)
        return amount
    }
    
    func trimmedWhiteSpace(string: String) -> String
    {
        let trimmed = string.trimmingCharacters(in: .whitespacesAndNewlines)
        return trimmed
    }
    
  
}

