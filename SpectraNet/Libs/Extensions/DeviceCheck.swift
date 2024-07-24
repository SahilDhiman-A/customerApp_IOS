//
//  DeviceCheck.swift
//  SpectraNet
//
//  Created by Bhoopendra on 7/18/19.
//  Copyright © 2019 Bhoopendra. All rights reserved.
//

import Foundation
import UIKit

extension UIScreen {

    // this enum used for check devices size
    enum SizeType: CGFloat {
        case Unknown = 0.0
        case iPhone4 = 960.0
        case iPhone5 = 1136.0
        case iPhone6 = 1334.0
        case iPhone6Plus = 1920.0
        case iPhone6SPlus = 2208.0
        case iPhoneXR = 1792.0
        case iPhoneX_XS = 2436.0
        case iPhoneXSMax = 2688.0
    }
    
    var sizeType: SizeType {
        let height = nativeBounds.height
        guard let sizeType = SizeType(rawValue: height) else { return .Unknown }
        return sizeType
    }
    
}


