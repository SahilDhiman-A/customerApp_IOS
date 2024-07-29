//
//  TopupTableViewCell.swift
//  My Spectra
//
//  Created by Bhoopendra on 9/27/19.
//  Copyright © 2019 Bhoopendra. All rights reserved.
//

import UIKit

class TopupTableViewCell: UITableViewCell {

    
       @IBOutlet var lblTopupTitle: UILabel!
    
       @IBOutlet var lblTopupName: UILabel!
       @IBOutlet var lblTopupVolume: UILabel!
       @IBOutlet var lblTopupPrice: UILabel!
       @IBOutlet var lblToupExcludingTaxes: UILabel!
     
       @IBOutlet var roundPayBtnView: UIView!
       @IBOutlet var roundInvoiceBtnView: UIView!

       @IBOutlet var topupPayBTN: UIButton!
    
    @IBOutlet var buyLabel: UILabel!
       @IBOutlet var topupInvoiceBTN: UIButton!
    @IBOutlet weak var buyButtonHeight: NSLayoutConstraint!
    @IBOutlet weak var buyButtonWidth: NSLayoutConstraint!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
