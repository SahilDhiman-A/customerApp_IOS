//
//  InvoiceTableViewCell.swift
//  SpectraNet
//
//  Created by Bhoopendra on 7/18/19.
//  Copyright © 2019 Bhoopendra. All rights reserved.
//

import UIKit

class InvoiceTableViewCell: UITableViewCell {

    @IBOutlet var lblInvoiceNmbr: UILabel!
    @IBOutlet var lblAmount: UILabel!
    @IBOutlet var lblInvoicedate: UILabel!
    @IBOutlet var lblInvoicePeriod: UILabel!
    @IBOutlet var lblDueDate: UILabel!
    @IBOutlet var invoiceViewButton: UIButton!
    @IBOutlet var invoiceEmailButton: UIButton!
    @IBOutlet var emailView: UIView!
    @IBOutlet var viewInvoiceView: UIView!
    
    @IBOutlet var lblOpeningAmt: UILabel!
    
    @IBOutlet var lblInvoiceAmt: UILabel!
    @IBOutlet var lblPayment: UILabel!
    @IBOutlet var lblTdsAmt: UILabel!
    @IBOutlet var lblAmountD: UILabel!
    @IBOutlet var lblManageScreen: UILabel!
    @IBOutlet var lblOPENINGAmountD: UILabel!
    @IBOutlet var lbINVOICElAmountD: UILabel!
    @IBOutlet var lblPAYMENTAmountD: UILabel!
    @IBOutlet var lblTDSAmountD: UILabel!
    @IBOutlet var lblBtnName: UILabel!
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
