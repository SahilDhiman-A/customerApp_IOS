//
//  LocalSearchTableViewCell.swift
//  My Spectra
//
//  Created by Chakshu on 23/09/21.
//  Copyright © 2021 Bhoopendra. All rights reserved.
//

import UIKit

class LocalSearchTableViewCell: UITableViewCell {

    @IBOutlet var lblHeader: UILabel!
    @IBOutlet var selectButton: UIButton!
    var faqSelect:((Int) -> Void)? = nil
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    func setValueInCell(localSearch:String,tagValue:Int){
        selectButton.tag = tagValue
        lblHeader.text = localSearch
    }
    
    @IBAction func selectButtonClick(_ button: UIButton)
      {
        if let clouser = faqSelect{
            clouser(button.tag)
        }
        
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
