//
//  NumberFormatter.swift
//  SpectraNet
//
//  Created by Bhoopendra on 9/17/19.
//  Copyright © 2019 Bhoopendra. All rights reserved.
//

import Foundation
extension UIViewController
{
    // This function used for add comma pair of thousand
    func addCommaSeprettedNumberFromate(NumberString: Double) -> String
    {
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .decimal
        let formattedNumber = numberFormatter.string(from: NSNumber(value:NumberString))
        
        return formattedNumber!
    }
}
