//
//  FaqTableViewCell.swift
//  My Spectra
//
//  Created by Bhoopendra on 9/24/19.
//  Copyright © 2019 Bhoopendra. All rights reserved.
//

import UIKit

class FaqTableViewCell: UITableViewCell {
    @IBOutlet var faqQues: UILabel!
    @IBOutlet var faqAns: UILabel!
    @IBOutlet var faqImg: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
