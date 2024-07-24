//
//  CanIDTableViewCell.swift
//  SpectraNet
//
//  Created by Bhoopendra on 8/8/19.
//  Copyright © 2019 Bhoopendra. All rights reserved.
//

import UIKit

class CanIDTableViewCell: UITableViewCell {
    @IBOutlet var lblAcount: UILabel!
    @IBOutlet var lblUserCanID: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
