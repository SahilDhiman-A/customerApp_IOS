//
//  TransactionTableViewCell.swift
//  SpectraNet
//
//  Created by Yugasalabs-28 on 23/07/2019.
//  Copyright © 2019 Bhoopendra. All rights reserved.
//

import UIKit

class TransactionTableViewCell: UITableViewCell {

    @IBOutlet weak var viewContainer: UIView!
    
    @IBOutlet weak var lblTransNmbr: UILabel!
    @IBOutlet weak var lblTransDate: UILabel!
    @IBOutlet weak var lblTypePayment: UILabel!
    @IBOutlet weak var lblTransAmnt: UILabel!
    @IBOutlet var lblPaymentMode: UILabel!
    @IBOutlet weak var lblDesc: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
