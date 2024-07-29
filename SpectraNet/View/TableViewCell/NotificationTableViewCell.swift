//
//  NotificationTableViewCell.swift
//  SpectraNet
//
//  Created by Bhoopendra on 8/5/19.
//  Copyright © 2019 Bhoopendra. All rights reserved.
//

import UIKit
import SwipeCellKit
class NotificationTableViewCell: SwipeTableViewCell {

    @IBOutlet var viewContainer: UIView!
    @IBOutlet var titleName: UILabel!
    @IBOutlet var dicrption: UILabel!
    @IBOutlet var selectButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
