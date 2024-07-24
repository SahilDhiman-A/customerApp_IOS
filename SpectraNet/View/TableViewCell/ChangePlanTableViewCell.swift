//
//  ChangePlanTableViewCell.swift
//  SpectraNet
//
//  Created by Bhoopendra on 9/16/19.
//  Copyright © 2019 Bhoopendra. All rights reserved.
//

import UIKit

class ChangePlanTableViewCell: UITableViewCell {
    @IBOutlet var lblplanName: UILabel!
    @IBOutlet var lblPlanCharge: UILabel!
    @IBOutlet var availData: UILabel!
    @IBOutlet var lblSped: UILabel!
    @IBOutlet var lblFrequency: UILabel!
    @IBOutlet var roundBtnView: UIView!
    
    @IBOutlet var selctpackageBTN: UIButton!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
