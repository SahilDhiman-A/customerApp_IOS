//
//  TopupTableViewCell.swift
//  My Spectra
//
//  Created by Bhoopendra on 9/27/19.
//  Copyright © 2019 Bhoopendra. All rights reserved.
//

import UIKit

class TopupTableViewCell: UITableViewCell {

    
       @IBOutlet var lblTopupName: UILabel!
       @IBOutlet var lblTopupPrice: UILabel!
       @IBOutlet var lblTopupTax: UILabel!
       @IBOutlet var lblToupTotalCharge: UILabel!
       @IBOutlet var lblTopupData: UILabel!
       @IBOutlet var lblToupType: UILabel!
       @IBOutlet var lblTopupStatus: UILabel!
       @IBOutlet var roundPayBtnView: UIView!
       @IBOutlet var roundInvoiceBtnView: UIView!

       @IBOutlet var topupPayBTN: UIButton!
       @IBOutlet var topupInvoiceBTN: UIButton!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
