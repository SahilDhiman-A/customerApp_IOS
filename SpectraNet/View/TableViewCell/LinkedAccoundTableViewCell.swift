//
//  LinkedAccoundTableViewCell.swift
//  My Spectra
//
//  Created by Chakshu on 12/30/19.
//  Copyright © 2019 Bhoopendra. All rights reserved.
//

import UIKit

class LinkedAccoundTableViewCell: UITableViewCell {
    
    @IBOutlet weak var lblAccound: UILabel!
    @IBOutlet weak var linkedAccountValue: UIImageView!
    @IBOutlet weak var moreButton: UIButton!
    @IBOutlet weak var seperationView: UIView!
  
    
    
    var index = 0
     var faqSelect:((Int) -> Void)? = nil
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func setValueToCell(value:[String:AnyObject],faqSelect:Bool,islastValue:Bool,indexValue:Int){
        
        if let linkedCandid =  value["link_canid"] as? String{
            
            lblAccound.text = linkedCandid
        }
        
        if(faqSelect == true){
            linkedAccountValue.isHidden = false
        }else{
            linkedAccountValue.isHidden = true
        }
        
        if(islastValue == true){
            seperationView.isHidden = true
        }else{
            seperationView.isHidden = false
        }
        
        self.index = indexValue
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    @IBAction func selectMoreButton(_ sender: Any) {
        
        if let clouser = faqSelect{
            
            clouser(self.index)
        }
    }
}
