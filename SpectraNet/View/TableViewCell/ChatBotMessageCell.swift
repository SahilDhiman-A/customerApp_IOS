//
//  SRTableViewCell.swift
//  SpectraNet
//
//  Created by Yugasalabs-28 on 24/07/2019.
//  Copyright © 2019 Bhoopendra. All rights reserved.
//

import UIKit

class ChatBotMessageCell: UITableViewCell {

    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var messageView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        setCornerRadiusView(radius: 5, color: UIColor.clear, view: messageView)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    func setCornerRadiusView(radius: Float, color: UIColor, view: UIView)
    {
        view.layer.cornerRadius = CGFloat(radius)
        view.clipsToBounds = true
        view.layer.borderWidth = 2
        view.layer.borderColor = color.cgColor
    }
}
