//
//  NotificationDisplayViewController.swift
//  My Spectra
//
//  Created by Chakshu on 23/12/20.
//  Copyright © 2020 Bhoopendra. All rights reserved.
//

import UIKit

class NotificationDisplayViewController: UIViewController {

    
    var notificationvalue:Notification_info? = nil
    var notificationSearchValue:NotificationSearchData? = nil
    var  isfromSearch = false
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var detailLabel: UILabel!
    @IBOutlet weak var promotionImage: UIImageView!
    @IBOutlet weak var mediaBuitton: UIButton!
    @IBOutlet weak var imageHeightConstant: NSLayoutConstraint!
    @IBOutlet weak var mediaButtonHeightConstant: NSLayoutConstraint!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setUpUI()
    }
    
    func setUpUI(){
        
        
        if(isfromSearch){
            
            if let titleValue = self.notificationSearchValue?.order_info?.title as? String {
                
                titleLabel.text = titleValue
            }
            
            if let imageURl = self.notificationSearchValue?.image_url as? String {
                
                CANetworkManager.sharedInstance.downloadImagewithUrl(urlName: imageURl) { (image, error) in
                    self.promotionImage.image = image
                }
                
                
            }
            
            
            if let detail = self.notificationSearchValue?.order_info?.detailed_description as? String {
                
                detailLabel.text = detail
            }
            
        }
        else
        {
        if let titleValue = self.notificationvalue?.order_info?.title as? String {
            
            titleLabel.text = titleValue
        }
        
        if let imageURl = self.notificationvalue?.image_url as? String {
            
            CANetworkManager.sharedInstance.downloadImagewithUrl(urlName: imageURl) { (image, error) in
                self.promotionImage.image = image
            }
            
            
        }
        
        
        if let detail = self.notificationvalue?.order_info?.detailed_description as? String {
            
            detailLabel.text = detail
        }
        }
        
        
    }
    
    override func viewDidLayoutSubviews() {
        
        CANetworkManager.sharedInstance.progressHUD(show: false)
        if(isfromSearch){
            if let imageURl = self.notificationSearchValue?.image_url as? String,imageURl != "" {
            self.imageHeightConstant.constant = 130
            self.mediaButtonHeightConstant.constant = 0
            self.mediaBuitton.isHidden = true
            }else  if let pdf_url = self.notificationSearchValue?.pdf_url as? String,pdf_url != ""{
                self.imageHeightConstant.constant = 0
                self.mediaButtonHeightConstant.constant = 40
                self.mediaBuitton.isHidden = false
                
            }
            else  if let video_url = self.notificationSearchValue?.video_url as? String,video_url != ""{
                self.imageHeightConstant.constant = 0
                self.mediaButtonHeightConstant.constant = 40
                self.mediaBuitton.isHidden = false
                
            }
            else{
                self.imageHeightConstant.constant = 0
                self.mediaButtonHeightConstant.constant = 0
                self.mediaBuitton.isHidden = true
                
            }
            
        }else{
            
        if let imageURl = self.notificationvalue?.image_url as? String,imageURl != "" {
        self.imageHeightConstant.constant = 130
        self.mediaButtonHeightConstant.constant = 0
        self.mediaBuitton.isHidden = true
        }else if let pdf_url = self.notificationvalue?.pdf_url as? String,pdf_url != ""{
            self.imageHeightConstant.constant = 0
            self.mediaButtonHeightConstant.constant = 40
            self.mediaBuitton.isHidden = false
            
        }
        else if let video_url = self.notificationvalue?.video_url as? String,video_url != ""{
            self.imageHeightConstant.constant = 0
            self.mediaButtonHeightConstant.constant = 40
            self.mediaBuitton.isHidden = false
            
        }
        
        else{
            self.imageHeightConstant.constant = 0
            self.mediaButtonHeightConstant.constant = 0
            self.mediaBuitton.isHidden = true
            
        }
        }
    }
    
    @IBAction func knowMoreCancelButtonClick(sender: UIButton!) {
        self.dismiss(animated: true, completion: nil)
        
    }
    
    @IBAction func mediaButtonClick(_ sender: Any) {
        
        if(isfromSearch){
            
            if let mediaURL = self.notificationSearchValue?.pdf_url as? String,mediaURL != "" {
                
                
        let vc = UIStoryboard.init(name: "Storyboard", bundle: Bundle.main).instantiateViewController(withIdentifier: ViewIdentifier.testInternetIdentifier) as? TestInternetViewController
            
                vc?.mediaUrl = mediaURL
                vc?.isInternetView = false
                self.present(vc!, animated: true) {
                    
                
                }
            }else{
                if let mediaURL = self.notificationSearchValue?.video_url as? String,mediaURL != "" {
                    
                    
            let vc = UIStoryboard.init(name: "Storyboard", bundle: Bundle.main).instantiateViewController(withIdentifier: ViewIdentifier.testInternetIdentifier) as? TestInternetViewController
                
                    vc?.mediaUrl = mediaURL
                    vc?.isInternetView = false
                    self.present(vc!, animated: true) {
                        
                    
                    }
                }
                
            }
    }
        else{
        
        if let mediaURL = self.notificationvalue?.pdf_url as? String,mediaURL != "" {
            
            
    let vc = UIStoryboard.init(name: "Storyboard", bundle: Bundle.main).instantiateViewController(withIdentifier: ViewIdentifier.testInternetIdentifier) as? TestInternetViewController
        
            vc?.mediaUrl = mediaURL
            vc?.isInternetView = false
            self.present(vc!, animated: true) {
                
            
            }
        }else{
            
            if let mediaURL = self.notificationvalue?.video_url as? String,mediaURL != "" {
                
                
        let vc = UIStoryboard.init(name: "Storyboard", bundle: Bundle.main).instantiateViewController(withIdentifier: ViewIdentifier.testInternetIdentifier) as? TestInternetViewController
            
                vc?.mediaUrl = mediaURL
                vc?.isInternetView = false
                self.present(vc!, animated: true) {
                    
                
                }
            }
        }
//            self.navigationController?.pushViewController(vc, animated: false)
        
        }
        }
}


