//
//  DeviceCheck.swift
//  SpectraNet
//
//  Created by Bhoopendra on 7/18/19.
//  Copyright © 2019 Bhoopendra. All rights reserved.
//

import Foundation
import UIKit

extension UITableView {
    
    func scrollToBottom(){
        
        DispatchQueue.main.async {
            if self.numberOfRows(inSection: 0) == 0 { return }
            let indexPath = IndexPath(
                row: self.numberOfRows(inSection:  self.numberOfSections - 1) - 1,
                section: self.numberOfSections - 1)
            self.scrollToRow(at: indexPath, at: .bottom, animated: true)
        }
    }
    
    func scrollToTop() {
        DispatchQueue.main.async {
            if self.numberOfRows(inSection: 0) == 0 { return }
            let indexPath = IndexPath(row: 0, section: 0)
            self.scrollToRow(at: indexPath, at: .top, animated: false)
        }
    }
}


