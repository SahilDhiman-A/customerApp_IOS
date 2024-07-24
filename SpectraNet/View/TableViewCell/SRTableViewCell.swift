//
//  SRTableViewCell.swift
//  SpectraNet
//
//  Created by Yugasalabs-28 on 24/07/2019.
//  Copyright © 2019 Bhoopendra. All rights reserved.
//

import UIKit

class SRTableViewCell: UITableViewCell {

    @IBOutlet weak var lblSRNmbr: UILabel!
    @IBOutlet weak var lblPrblmType: UILabel!
    @IBOutlet weak var lblSubPrblmType: UILabel!
    @IBOutlet weak var lblResolve: UILabel!
    @IBOutlet var statusImg: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
