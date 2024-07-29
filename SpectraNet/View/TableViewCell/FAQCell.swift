//
//  SITableViewCell.swift
//  My Spectra
//
//  Created by Bhoopendra on 10/10/19.
//  Copyright © 2019 Bhoopendra. All rights reserved.
//

import UIKit
import AVFoundation

class FAQCell: UITableViewCell {
    @IBOutlet var lblQuestion: UILabel!
    @IBOutlet var lblAnswer: UILabel!
    @IBOutlet var topImage: UIImageView!
    @IBOutlet var selectButton: UIButton!
    @IBOutlet var downButton: UIButton!
    @IBOutlet var upButton: UIButton!
    @IBOutlet var faqUseFullView: UIView!
    @IBOutlet var faqMediaView: UIView!
    @IBOutlet var faqHypeLinkButton: UIButton!
    @IBOutlet var faqImageView: UIImageView!
    @IBOutlet var faqPlayButton: UIButton!
    @IBOutlet var seprateView: UIView!
    var playURL = ""
    @IBOutlet weak var mediaViewHeight: NSLayoutConstraint!
    var faqSelect:((Int) -> Void)? = nil
    var downRatingClick:((Int) -> Void)? = nil
    var upwordRatingClick:((Int) -> Void)? = nil
    var selectMediaOpenValue:((Int) -> Void)? = nil
    var openLinkAttached:((Int) -> Void)? = nil
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setValueInCell(faqVAlue:FAQ,indexValue:Int,seletedIndexValue:Int,isFinalBool:Bool){
        lblQuestion.text = faqVAlue.question
        selectButton.tag = indexValue
        downButton.tag = indexValue
        upButton.tag = indexValue
        faqHypeLinkButton.tag = indexValue
        faqPlayButton.isHidden = true
        if(indexValue == seletedIndexValue){
            topImage.image = UIImage(named: "uparrow")
            lblQuestion.textColor  = .bgColors
            lblAnswer.text = faqVAlue.answer
            faqUseFullView.isHidden = false
            seprateView.isHidden = false
            mediaViewHeight.constant = 0
            if let link = faqVAlue.link{
                mediaViewHeight.constant = 40
                faqHypeLinkButton.setTitle(link, for: .normal)
                faqHypeLinkButton.titleLabel?.numberOfLines = 0
            }
            if let image = faqVAlue.imageURL{
                mediaViewHeight.constant = 190
                CANetworkManager.sharedInstance.downloadImagewithUrl(urlName: image) { (image, error) in
                    self.faqImageView.image = image
                }
            }
            if let video = faqVAlue.videoURL{
                mediaViewHeight.constant = 190
                faqPlayButton.isHidden = false
                self.playURL = video
                if  let urlVideo = URL(string: video){
                    self.faqImageView.backgroundColor = UIColor.black
                }
            }
        }else{
            mediaViewHeight.constant = 0
            topImage.image = UIImage(named: "canarrow")
            lblQuestion.textColor = UIColor.black
            lblAnswer.text = ""
            faqUseFullView.isHidden = true
            seprateView.isHidden = true
        }
        if isFinalBool == true{
            seprateView.isHidden = true
        }
        
       
        self.bringSubviewToFront(selectButton)
    
    }
    
    func getThumbnailImageFromVideoUrl(url: URL, completion: @escaping ((_ image: UIImage?)->Void)) {
        DispatchQueue.global().async { //1
            let asset = AVAsset(url: url) //2
            let avAssetImageGenerator = AVAssetImageGenerator(asset: asset) //3
            avAssetImageGenerator.appliesPreferredTrackTransform = true //4
            let thumnailTime = CMTimeMake(value: 2, timescale: 1) //5
            do {
                let cgThumbImage = try avAssetImageGenerator.copyCGImage(at: thumnailTime, actualTime: nil) //6
                let thumbImage = UIImage(cgImage: cgThumbImage) //7
                DispatchQueue.main.async { //8
                    completion(thumbImage) //9
                }
            } catch {
                debugPrint(error.localizedDescription) //10
                DispatchQueue.main.async {
                    completion(nil) //11
                }
            }
        }
    }
    @IBAction func playVideo(_ button: UIButton)
      {
        
        if(playURL == ""){
            return
        }
        let vc = UIStoryboard.init(name: "Storyboard", bundle: Bundle.main).instantiateViewController(withIdentifier: ViewIdentifier.testInternetIdentifier) as? TestInternetViewController
            
                vc?.mediaUrl = playURL
                vc?.isInternetView = false
        AppDelegate.sharedInstance.getTopViewController().present(vc!, animated: true) {
                    
                
                }
            }
        
        
    
    @IBAction func selectButton(_ button: UIButton)
      {
        if let clouser = faqSelect{
            
            clouser(button.tag)
        }
        
    }
    @IBAction func openLink(_ button: UIButton){
        if let clouser = openLinkAttached{
            
            clouser(button.tag)
        }
        
    }
    @IBAction func downButtonSelect(_ button: UIButton){
        if let clouser = downRatingClick{
            clouser(button.tag)
        }
    }
    @IBAction func upButtonSelect(_ button: UIButton){
        if let clouser = upwordRatingClick{
            
            clouser(button.tag)
        }
        
        
    }
}
