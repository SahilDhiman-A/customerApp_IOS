//
//  PushNotificationView.swift
//  My Spectra
//
//  Created by shubam garg on 03/12/20.
//  Copyright © 2020 Bhoopendra. All rights reserved.
//

import UIKit

class PushNotificationView: UIView {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var notificationMessage: UILabel!
    @IBOutlet var appIcon: UIImageView!
    @IBOutlet var line: UILabel!
    @IBOutlet weak var imgViewBottom: NSLayoutConstraint!
    
    @IBOutlet weak var imgView: UIImageView!
    var action:(()->Void)?
    
    static var notiFicationView : PushNotificationView?
    
    override func awakeFromNib() {
        notificationMessage.textColor = .black
        titleLabel.textColor = .black
        notificationMessage.font = UIFont(name: "Helvetica", size: 15.0)
        titleLabel.font = UIFont(name: "Helvetica", size: 15.0)
        titleLabel.text = "Spectra"
        self.layer.masksToBounds = true
        self.layer.cornerRadius = 10
        self.layer.borderColor = UIColor.black.cgColor
        self.layer.borderWidth = 0.5
        
        self.appIcon.layer.cornerRadius = 4.0
        self.appIcon.layer.masksToBounds = true
        self.line.backgroundColor = UIColor.white
        
        
    }
    
    
    //MARK: STATIC FUNCTION TO SHOW THE NOTIFICATION POPUP
    
    static func showPush(title: String, message:String, image: String?, actionOnClick:@escaping ()->Void) -> PushNotificationView{
        //        UIApplication.shared.setStatusBarHidden(true, with: .fade)
        let viewToBeloaded = Bundle.main.loadNibNamed("PushNotificationView", owner: self, options: nil)?[0] as? PushNotificationView
        let size = message.heightWithConstrainedWidth(width: UIScreen.main.bounds.width - 60, font:  UIFont(name: "Helvetica", size: 14.0)!)
        let titleSize = title.heightWithConstrainedWidth(width: UIScreen.main.bounds.width - 60, font:  UIFont(name: "Helvetica", size: 14.0)!)
        viewToBeloaded?.alpha = 0
        var additonalHeight:CGFloat = 40.0
        if let imgUrl = image, let _ = URL(string: imgUrl) {
            additonalHeight += 200.0
        }
        viewToBeloaded!.frame = CGRect(x: 0, y: -(size.height + titleSize.height + 40), width: (UIApplication.shared.keyWindow?.frame.width)!, height: size.height + titleSize.height + additonalHeight)
        viewToBeloaded?.titleLabel.text = title
        viewToBeloaded?.notificationMessage.text = message
        viewToBeloaded?.action = actionOnClick
        viewToBeloaded?.isUserInteractionEnabled = true
        if let imgUrl = image {
            if let url = URL(string: imgUrl) {
                if let data = try? Data(contentsOf: url) {
                    viewToBeloaded?.imgView.image = UIImage(data: data)
                    viewToBeloaded?.imgView.contentMode = .scaleAspectFill
                    viewToBeloaded?.imgViewBottom.constant = 10
                    viewToBeloaded?.imgView.isHidden = false
                    viewToBeloaded?.imgView.isUserInteractionEnabled = true
                    
                }
            }
        } else {
            viewToBeloaded?.imgViewBottom.constant = 0
            viewToBeloaded?.imgView.isHidden = true
        }
        return viewToBeloaded!
    }
    
    // FUNCTION TO HIDE THE POPUP
    func hideNotification(){
        UIView.animate(withDuration: 1.0, animations: {
            self.alpha = 0
            self.frame = CGRect(x: 0, y: -60, width: (UIApplication.shared.keyWindow?.frame.width)!, height: self.frame.height)
        }) { (true) in
            //                UIApplication.shared.setStatusBarHidden(false, with: .fade)
            self.removeFromSuperview()
        }
    }
    
    @IBAction func tapAction(_ sender: AnyObject) {
        debugPrint("notificationTaped")
        action!()
        hideNotification()
    }
    
    @IBAction func cancelNotificationButton(_ sender: UIButton) {
        hideNotification()
    }
    
}
