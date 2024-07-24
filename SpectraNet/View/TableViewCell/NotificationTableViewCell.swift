//
//  NotificationTableViewCell.swift
//  SpectraNet
//
//  Created by Bhoopendra on 8/5/19.
//  Copyright © 2019 Bhoopendra. All rights reserved.
//

import UIKit

class NotificationTableViewCell: UITableViewCell {

    @IBOutlet var viewContainer: UIView!
    @IBOutlet var titleName: UILabel!
    @IBOutlet var dicrption: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
