//
//  KnowMoreBottonTableViewCell.swift
//  My Spectra
//
//  Created by Chakshu on 26/10/20.
//  Copyright © 2020 Bhoopendra. All rights reserved.
//

import UIKit

class KnowMoreBottonTableViewCell: UITableViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var subTitleLabel: UILabel!
    @IBOutlet weak var iconImageView: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
