//
//  SITableViewCell.swift
//  My Spectra
//
//  Created by Bhoopendra on 10/10/19.
//  Copyright © 2019 Bhoopendra. All rights reserved.
//

import UIKit

class SITableViewCell: UITableViewCell {
    @IBOutlet var lblSIDisplayMsg: UILabel!
    @IBOutlet var termSelectUnselectBTN: UIButton!
    @IBOutlet var lblHyperLinkedTerm: UILabel!
    @IBOutlet var changeSIView: UIView!
    @IBOutlet var changeDisabalView: UIView!
    @IBOutlet var changeAutoPayView: UIView!
    @IBOutlet var autoPayBTN: UIButton!
    @IBOutlet var changeSIBTN: UIButton!
    @IBOutlet var disableBTN: UIButton!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
