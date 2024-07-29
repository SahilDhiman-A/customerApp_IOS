//
//  FAQHeaderTableViewCell.swift
//  My Spectra
//
//  Created by Chakshu on 22/09/21.
//  Copyright © 2021 Bhoopendra. All rights reserved.
//

import UIKit

class RecentSerachCell: UITableViewCell {

    @IBOutlet var lblHeader: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func setValueInCell(faqValue:String){
        lblHeader.text = faqValue
    }
    

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
