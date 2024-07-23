//
//  ConsumedTableViewCell.swift
//  My Spectra
//
//  Created by Chakshu on 28/01/20.
//  Copyright © 2020 Bhoopendra. All rights reserved.
//

import UIKit

class ConsumedTableViewCell: UITableViewCell {

    
    @IBOutlet var lblTopupName: UILabel!
    @IBOutlet var lblTopupVolume: UILabel!
    @IBOutlet var lblTopupType: UILabel!
    @IBOutlet var lblTopupPrice: UILabel!
    @IBOutlet var lblToupExcludingTaxes: UILabel!
    
    @IBOutlet var roundPayBtnView: UIView!
    @IBOutlet var roundInvoiceBtnView: UIView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
