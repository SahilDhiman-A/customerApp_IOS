//
//  GPONViewController.swift
//  My Spectra
//
//  Created by Chakshu on 02/04/20.
//  Copyright © 2020 Bhoopendra. All rights reserved.
//

import UIKit

class NONGPONViewController: UIViewController {
    
    @IBOutlet weak var gponWidthConstaint: NSLayoutConstraint!
    
    @IBOutlet weak var gponTimerWidthConstain: NSLayoutConstraint!
    
    @IBOutlet weak var iinternetNotWorkingHeight: NSLayoutConstraint!
    @IBOutlet weak var gponStopWidthConstain: NSLayoutConstraint!
    
    @IBOutlet weak var internetNotWorkingHeightConstant: NSLayoutConstraint!
    
     @IBOutlet weak var internetNotWorkingETRHeightConstant: NSLayoutConstraint!
    
    @IBOutlet weak var fdBottomConstant: NSLayoutConstraint!
    @IBOutlet weak var fdTitleHeightConstant: NSLayoutConstraint!
    @IBOutlet weak var fdSubTitleHeightConstant: NSLayoutConstraint!
    @IBOutlet weak var internetLabel: UILabel!
     @IBOutlet weak var backToHomeButtonTitleFD: UILabel!
    @IBOutlet weak var backToHomeImageViewFD: UIImageView!
    @IBOutlet weak var backToHomeButtonWidthConstain: NSLayoutConstraint!
    @IBOutlet weak var internetWorkingHeightConstain: NSLayoutConstraint!
     @IBOutlet weak var internetWorkingOkeyView: UIView!
    
    @IBOutlet weak var iNWbackToHomeButtonTitleFD: UILabel!
      @IBOutlet weak var iNWbackToHomeImageViewFD: UIImageView!
      @IBOutlet weak var iNWbackToHomeButtonWidthConstain: NSLayoutConstraint!
    
    let maxSecond = 120

    var seconds = 0 //This variable will hold a starting value of seconds. It could be any amount above 0.
    var timerFirst : Timer?
    
    var timersecond:Timer?
    var isTimerRunning = false //This will be used to make sure only one timer is created at a time.
    var isPantnerSelected = false
      var isGPONSelected = false
    
   
    var ETRvalue = "";
    var typeSubype = ""
    var powerLevel = ""
    var alarmType = ""
    var messageCode = String()
    var canId = String()
    var srNo = "";
    var voc = String()
    @IBOutlet weak var gponView: UIView!
    @IBOutlet weak var gponLabel: UILabel!
    @IBOutlet weak var gponTimer: UILabel!
    @IBOutlet weak var gponViewHight: NSLayoutConstraint!
    @IBOutlet weak var noLabel: UILabel!
    @IBOutlet weak var yesLabel: UILabel!
    
    @IBOutlet weak var gponTimerStopView: UIView!
    @IBOutlet weak var gponTimerStopLabel: UILabel!
    @IBOutlet weak var gponTimerStopTimerLabel: UILabel!
    @IBOutlet weak var gponTimerStopOKView: UIView!
    @IBOutlet weak var gponTimerStopOKLabel: UILabel!
    
    @IBOutlet weak var gponTimerStopOKOFFView: UIView!
    @IBOutlet weak var gponTimerStopOKOFFLabel: UILabel!
    @IBOutlet weak var gponTimerOFFStopLabel: UILabel!
    @IBOutlet weak var gponTimerStopOKOFFViewHight: NSLayoutConstraint!
    
    @IBOutlet weak var gponPatnerViewHeightConstain: NSLayoutConstraint!
    
    @IBOutlet weak var internetWorkingView: UIView!
    @IBOutlet weak var InternetWorkingLabel: UILabel!
    
    @IBOutlet weak var internetNOTWorkingView: UIView!
    @IBOutlet weak var InternetNOTWorkingLabel: UILabel!
    @IBOutlet weak var InternetNOTETRWorkingLabel: UILabel!
    
    
     @IBOutlet weak var gponTimerOFFISNternetWorkingLabel: UILabel!
    @IBOutlet weak var backButton: UIButton!
     @IBOutlet weak var fdView: UIView!
    @IBOutlet weak var fdLabel: UILabel!
    
    @IBOutlet weak var gostImageView: UIImageView!
    
    @IBOutlet weak var infoView: UIView!
    @IBOutlet weak var infoViewONT: UIView!
    @IBOutlet weak var infoButton: UIButton!
    @IBOutlet weak var infoButtonPatner: UIButton!
    @IBOutlet weak var infoTimerButton: UIButton!
    
    
      override func viewDidLoad() {
        super.viewDidLoad()
         switch messageCode {
            case  NoInternetMessageCode.GPON:
                
                CANetworkManager.sharedInstance.progressHUD(show: true)
                 self.serviceTypeGetSRStatus(useKey: "srNumber", useNumber: self.srNo)
            break
            default:
            self.setupUI()
            break
        
            
        }

        // Do any additional setup after loading the view.
      }
    
    override func viewWillLayoutSubviews() {
        
        if(self.view.frame.size.height <= 568)
        {
            gponWidthConstaint.constant = 100
            gponTimerWidthConstain.constant = 100
            gponStopWidthConstain.constant = 100
            internetLabel.font =  UIFont(name: "Helvetica", size: 16.0)
            
        }
        
         switch messageCode {
            case  NoInternetMessageCode.GPON:
            internetNotWorkingHeightConstant.constant = 370
            break
            case  NoInternetMessageCode.GPON40:
            gponViewHight.constant = 250
            break
         case NoInternetMessageCode.GPONNONStopWatchON:
             if(isPantnerSelected == true){
                 gponViewHight.constant = 250
             }
            break
            
    case NoInternetMessageCode.partner,NoInternetMessageCode.partnerStopWatch,NoInternetMessageCode.wANlightPAtner:
            // if(isPantnerSelected == true){
                 gponPatnerViewHeightConstain.constant = 200
             //}
            break
            default:
            break
        }
        super.viewWillLayoutSubviews()
    }
    
    func gPONNON(){
        
        seconds = 120
        gponView.isHidden = false
        if(self.view.frame.size.height <= 568)
        {
        gponLabel.font =  UIFont(name: "Helvetica", size: 16.0)
        gponTimer.font =  UIFont(name: "Helvetica", size: 18.0)
        }
        gponLabel.text = "Can you please check if the\n 9F/10F light on your Switch is\n ON or OFF ?"
        gponTimer.text = "02:00"
        timerFirst = Timer.scheduledTimer(timeInterval: 1, target: self,   selector: (#selector(NONGPONViewController.updateTimer)), userInfo: nil, repeats: true)
    }
    
    func gPONNONStopWatch(){
        gponTimerStopView.isHidden = false
                                if(self.view.frame.size.height <= 568)
                                          {
                                          gponTimerStopLabel.font =  UIFont(name: "Helvetica", size: 16.0)
                                          gponTimerStopTimerLabel.font =  UIFont(name: "Helvetica", size: 16.0)
                                          }
                                gponTimerStopLabel.text = "Can you please check if the\n 9F/10F light on your Switch is\n ON or OFF ?"
                                gponTimerStopTimerLabel.text = "00:00"
                                self.noLabel.text = "OFF"
                                self.yesLabel.text = "ON"
        
    }
    
    func gPONNONStopWatchON(){
        if(isPantnerSelected == true){
                            seconds = 120
                            gponView.isHidden = false
                            if(self.view.frame.size.height <= 568)
                                                     {
                                                     gponLabel.font =  UIFont(name: "Helvetica", size: 16.0)
                                                     gponTimer.font =  UIFont(name: "Helvetica", size: 18.0)
                                                     }
                            gponLabel.text = "While our connectivity to your premises is fine, we have found an issue in the equipment at your premises. Please reboot your WiFi Router and wait for 2 minute."
        //                     if(self.isPantnerSelected == true){
        //
        //                      gponLabel.text =
        //                          seconds = 10
        //                          gponTimerOFFStopLabel.text = "02:00"
        //                    }
                            gponTimer.text = "02:00"
                            timerFirst = Timer.scheduledTimer(timeInterval: 1, target: self,   selector: (#selector(NONGPONViewController.updateTimer)), userInfo: nil, repeats: true)
                            
                        }else{
                            gponTimerStopOKView.isHidden = false
                            
                                                             if(self.view.frame.size.height <= 568)
                                                                       {
                                                                       gponTimerStopOKLabel.font =  UIFont(name: "Helvetica", size: 16.0)
                                                                      
                                                                       }
                            gponTimerStopOKLabel.text = "Please hold on while we\n check our connectivity to your switch again.\n\n\n We are able to successfully\n reach your switch. Please\n check if your internet is\n working now.\n\nHas internet started working ?"
                        }
        
    }
    
    func gPONNONStopWatchONOFF(){
        gponTimerStopOKOFFView.isHidden = false
          if(self.view.frame.size.height <= 568)
           {
           gponTimerStopOKOFFLabel.font =  UIFont(name: "Helvetica", size: 16.0)
              gponTimerOFFStopLabel.font =  UIFont(name: "Helvetica", size: 16.0)
          
           }
          
            if(self.isGPONSelected == true){
               gponTimerStopOKOFFLabel.text = "Kindly check if the Ethernet cable is connected to the WAN port of your WiFi Router. If not, kindly connect it to the WAN port."
              seconds = 120
              gponTimerOFFStopLabel.text = "02:00"
            }
            
            else{
                gponTimerStopOKOFFLabel.text = "Sorry… just one final step\n before we reach our\n conclusion\n Kindly check if the Ethernet\n cable is connected to Port 1\n on the Switch and reboot the\n Switch. Wait for 2 minutes\n"
              seconds = maxSecond
              gponTimerOFFStopLabel.text = "02:00"
          }
          
          
        
          
          timersecond = Timer.scheduledTimer(timeInterval: 1, target: self,   selector: (#selector(NONGPONViewController.updateTimerSecond)), userInfo: nil, repeats: true)
              gponTimerStopOKOFFViewHight.constant = 270
        
    }
    
    func gPONNONStopWatchONOFFAgainTimer(){
        
        gponTimerStopOKOFFView.isHidden = false
                      if(self.view.frame.size.height <= 568)
                                      {
                                      gponTimerStopOKOFFLabel.font =  UIFont(name: "Helvetica", size: 16.0)
                                         
                                     
                                      }
                      
                      if(self.isGPONSelected == true){
                           gponTimerStopOKOFFLabel.text = "Kindly check if the Ethernet cable is connected to the WAN port of your WiFi Router. If not, kindly connect it to the WAN port."
                        }else{
                            gponTimerStopOKOFFLabel.text = "Sorry… just one final step\n before we reach our\n conclusion\n Kindly check if the Ethernet\n cable is connected to Port 1\n on the Switch and reboot the\n Switch. Wait for 2 minutes\n"
                      }
        
         gponTimerStopOKOFFViewHight.constant = 420
    }
    
    func gPONNONInternetWorking(){
        
        internetWorkingView.isHidden = false
                 if(self.view.frame.size.height <= 568)
                                                      {
                                                      InternetWorkingLabel.font =  UIFont(name: "Helvetica", size: 16.0)
                                                         
                                                     
                                                      }
        InternetWorkingLabel.text = "Please continue to enjoy\n Spectra’s fastest internet\n services"
    }
    
    func gPONNONLightNOTWorking(){
        
                     internetNOTWorkingView.isHidden = false 
                       if(self.view.frame.size.height <= 568)
                                                                          {
                           InternetNOTWorkingLabel.font =  UIFont(name: "Helvetica", size: 16.0)
                                                                             
                                                                         
                                                                          }
                     InternetNOTWorkingLabel.text =  "There seems to be an issue\n which needs to be\n investigated by our technical\n experts.\n\n Service Request No. \(self.srNo) of\n \(self.typeSubype) has been\n raised and dispatched to our\n technical team for quick\n resolution. Resolution time is"
                       
                       if(self.ETRvalue != ""){
                       InternetNOTETRWorkingLabel.text = "\(ETRvalue)."
                       }
    }
    
      func setupUI()  {
        backButton.isHidden = true
        fdView.isHidden = true
        gponView.isHidden = true
        gponTimerStopView.isHidden = true
        gponTimerStopOKView.isHidden = true
        gponTimerStopOKOFFView.isHidden = true
        internetWorkingView.isHidden = true
        internetNOTWorkingView.isHidden = true
         switch messageCode {
         case NoInternetMessageCode.GPONNON:
            gPONNON()
           
            break
        case NoInternetMessageCode.GPONNONStopWatch:
                        
              gPONNONStopWatch()
            break
            
            case NoInternetMessageCode.GPONNONStopWatchON:
                
                gPONNONStopWatchON()
                         
                       break
            
            case NoInternetMessageCode.GPONNONStopWatchONOFF:
                
                gPONNONStopWatchONOFF()
        
                                    
                break
            case NoInternetMessageCode.GPONNONStopWatchONOFFAgainTimer:
                        
                gPONNONStopWatchONOFFAgainTimer()
            break
            case NoInternetMessageCode.GPONNONInternetWorking:
                gPONNONInternetWorking()
                 
            break
         case  NoInternetMessageCode.GPONNONLightNOTWorking:
            gPONNONLightNOTWorking()
               
            break
         case  NoInternetMessageCode.GPONNONInternetNOTWorking:
            
            gPONNONInternetNOTWorking()
           
            break
            case  NoInternetMessageCode.GPON:
           
                gPON()
            break
         case  NoInternetMessageCode.GPONNoIssue:
            gPONNoIssue()
            
         break
         case  NoInternetMessageCode.partner:
        
            partner()

          break
        case  NoInternetMessageCode.partnerStopWatch:
            partnerStopWatch()
            break
            
         case  NoInternetMessageCode.GPON40:
            
            gPON40()
              
            break
            case NoInternetMessageCode.GPON40StopWatch:
                
                gPON40StopWatch()
                
                break
             case NoInternetMessageCode.GPON40DGIFD:
                gPON40DGIFD()
            
            break
         case NoInternetMessageCode.GPON40DGIFDTimerStop:
           gPON40DGIFDTimerStop()
            break
          case NoInternetMessageCode.internetWorkingFD:
             internetWorkingFD()
            break
            
         case NoInternetMessageCode.FDSSSRRaised:
            
            fDSSSRRaised()
            
            break
            
         case NoInternetMessageCode.wANlightPAtner:
            
            self.wANlightPAtner()
                             
            break
         case NoInternetMessageCode.wANlightPAtnerFluctuatingLightNo:
            
            self.wANlightPAtnerFluctuatingLightNo()
            break
         case NoInternetMessageCode.wANlightPAtnerFluctuatingLightNoTimerStop:
            
            self.wANlightPAtnerFluctuatingLightNoTimerStop()
            break
            default:
            break
        }
        
    }
    
    func gPONNONInternetNOTWorking(){
        if(self.view.frame.size.height <= 568)
                                                                                     {
                                      InternetNOTWorkingLabel.font =  UIFont(name: "Helvetica", size: 16.0)
                                              InternetNOTETRWorkingLabel.font =  UIFont(name: "Helvetica", size: 16.0)
                                                                                    
                                                                                     }
                    internetNOTWorkingView.isHidden = false
                    InternetNOTWorkingLabel.text = "There seems to be an issue\n which needs to be\n investigated by our technical\n experts.\n\n Service Request No. \(self.srNo) of\n \(self.typeSubype) has been\n raised and dispatched to our\n technical team for quick\n resolution. Resolution time is"
                     if(self.ETRvalue != ""){
                    InternetNOTETRWorkingLabel.text = "\(ETRvalue)."
                    }
        
    }
    func gPON(){
    
        internetNOTWorkingView.isHidden = false
                   
                   iinternetNotWorkingHeight.constant = 200
                  
                   if(self.view.frame.size.height <= 568)
                                                                                       {
                   InternetNOTWorkingLabel.font =  UIFont(name: "Helvetica", size: 16.0)
                   InternetNOTETRWorkingLabel.font =  UIFont(name: "Helvetica", size: 16.0)
                                      
                                                                                                }
                  
                   InternetNOTWorkingLabel.text = " Oops.. we have found an issue in your connectivity. Service Request No. \(self.srNo) of \(self.typeSubype) has been raised and dispatched to our technical team for quick resolution. Resolution time is"
                   
                   
                     if(self.ETRvalue != ""){
                   InternetNOTETRWorkingLabel.text = "\(ETRvalue)."
                   }
                    internetNotWorkingHeightConstant.constant = 370
    }
    
    func gPONNoIssue(){

        if(self.view.frame.size.height <= 568)
                                                                                               {
                                                InternetWorkingLabel.font =  UIFont(name: "Helvetica", size: 16.0)
                                                       
                                                                                              
                                                                                               }
            internetWorkingView.isHidden = false
            InternetWorkingLabel.text = "Please continue to enjoy\n Spectra’s fastest internet\n services"
        
    }
    
    func partner(){
    
    if(self.view.frame.size.height <= 568)
    {
        gponTimerStopLabel.font =  UIFont(name: "Helvetica", size: 16.0)
         gponTimer.font =  UIFont(name: "Helvetica", size: 18.0)
                                                        
         noLabel.font =  UIFont(name: "Helvetica", size: 16.0)
                                 yesLabel.font =  UIFont(name: "Helvetica", size: 16.0)
               
                                                      
     }
           
          gponTimerStopView.isHidden = false
          gponTimerStopLabel.text = "Can you please check if the\n WAN light on your WiFi Router\n is RED or GREEN ?"
          gponTimerStopTimerLabel.text = ""
         
          self.isPantnerSelected = true
          self.noLabel.text = "RED"
           self.yesLabel.text = "GREEN"
    
    messageCode = NoInternetMessageCode.partnerStopWatch
    }
    
    func partnerStopWatch(){
        if(self.view.frame.size.height <= 568)            {
        gponTimerStopLabel.font =  UIFont(name: "Helvetica", size: 16.0)
        gponTimer.font =  UIFont(name: "Helvetica", size: 18.0)
                                                        
        noLabel.font =  UIFont(name: "Helvetica", size: 16.0)
        yesLabel.font =  UIFont(name: "Helvetica", size: 16.0)
               
                                                      
                                                       }
           seconds = 120
          gponTimerStopView.isHidden = false
          gponTimerStopLabel.text = "Can you please check if the\n WAN light on your WiFi Router\n is RED or GREEN ?"
          gponTimer.text = "00:00"
          //timerFirst = Timer.scheduledTimer(timeInterval: 1, target: self,   selector: (#selector(NONGPONViewController.updateTimer)), userInfo: nil, repeats: true)
          self.isPantnerSelected = true
          self.noLabel.text = "RED"
           self.yesLabel.text = "GREEN"
    }
    func gPON40(){
        self.isGPONSelected =  true
        seconds = 120
        gponView.isHidden = false

            if(self.view.frame.size.height <= 568)            {
          gponLabel.font =  UIFont(name: "Helvetica", size: 16.0)
            gponTimer.font =  UIFont(name: "Helvetica", size: 18.0)
                                                
                }
             if(isPantnerSelected == true){
                   gponLabel.text = "While our connectivity to your\n premises is fine, it seems that\n your WiFi Router/Switch is\n powered OFF. Kindly switch\n on the power supply and wait\n for 2 minute."
          }
          
          else if(self.alarmType == "DGI" && self.powerLevel == "-40"){
        gponLabel.text = "While our connectivity to your\n premises is fine, it seems that\n your WiFi Router/Switch is\n powered OFF. Kindly switch\n on the power supply and wait\n for 2 minute."
          }else{
             gponLabel.text = "While our connectivity to your\n premises is fine, we have found an issue in the equipment at your premises. Please reboot your ONT (white box) and your WiFi Router/Switch and wait for 2 minute."
            
          }
        gponTimer.text = "02:00"
        timerFirst = Timer.scheduledTimer(timeInterval: 1, target: self,   selector: (#selector(NONGPONViewController.updateTimer)), userInfo: nil, repeats: true)
        
    }
    
    func gPON40StopWatch(){
        gponTimerStopOKOFFView.isHidden = false
          if(self.view.frame.size.height <= 568)            {
                    gponTimerStopOKOFFLabel.font =  UIFont(name: "Helvetica", size: 16.0)
                                                                  
                                                                   }
          if(isPantnerSelected == true){
          gponTimerStopOKOFFLabel.text = "While our connectivity to your premises is fine, we have found an issue in the equipment at your premises. Please reboot your WiFi Router and wait for 2 minute."
                       }
                       
                  else if(self.alarmType == "DGI" && self.powerLevel == "-40"){
                     gponTimerStopOKOFFLabel.text = "While our connectivity to your\n premises is fine, it seems that\n your WiFi Router/Switch is\n powered OFF. Kindly switch\n on the power supply and wait\n for 2 minute."
                       }else{
                          gponTimerStopOKOFFLabel.text = "While our connectivity to your\n premises is fine, we have found an issue in the equipment at your premises. Please reboot your ONT (white box) and your WiFi Router/Switch and wait for 2 minute."
                         
                       }
        
          gponTimerStopOKOFFViewHight.constant = 420
        
    }
    
    func gPON40DGIFD(){
        backButton.isHidden = false
        fdView.isHidden = false
        if(voc == "3"){
        fdLabel.text = "Slow speed"
        gostImageView.image = UIImage(named:"slow")
           }else{
        fdLabel.text = "Frequent disconnection"
        gostImageView.image = UIImage(named:"unlink")
              
           }
        infoButton.isHidden = false
        seconds = 120
        gponView.isHidden = false
         gponLabel.text = "ONT not plugged in properly. Replug the white ONT box and reboot Wifi Router/Switch and wait for a minute."
        gponTimer.text = "02:00"
        timerFirst = Timer.scheduledTimer(timeInterval: 1, target: self,   selector: (#selector(NONGPONViewController.updateTimer)), userInfo: nil, repeats: true)
        
    }
    
    func gPON40DGIFDTimerStop(){
        infoTimerButton.isHidden = false
        backButton.isHidden = false
                   fdView.isHidden = false
             if(voc == "3"){
               fdLabel.text = "Slow speed"
               gostImageView.image = UIImage(named:"slow")
                  }else{
               fdLabel.text = "Frequent disconnection"
               gostImageView.image = UIImage(named:"unlink")
                     
                  }
                 gponTimerStopOKOFFView.isHidden = false
                                  if(self.view.frame.size.height <= 568){
                                                  gponTimerStopOKOFFLabel.font =  UIFont(name: "Helvetica", size: 16.0)
                                                 
                                                  }
                       gponTimerStopOKOFFLabel.text = "ONT not plugged in properly. Replug the white ONT box and reboot Wifi Router/Switch and wait for a minute."
               fdBottomConstant.constant = 50
                   fdTitleHeightConstant.constant = 100
               gponTimerStopOKOFFViewHight.constant = 300
        
    }
    func internetWorkingFD(){
        
        backButton.isHidden = false
             fdView.isHidden = true
            internetWorkingView.isHidden = false
                            if(self.view.frame.size.height <= 568)
                            {
            InternetWorkingLabel.font =  UIFont(name: "Helvetica", size: 16.0)
                                                                    
                                                                
                        }
             
             backToHomeButtonTitleFD.text = "OKAY"
             backToHomeImageViewFD.image = UIImage(named:"frwd")
             backToHomeButtonWidthConstain.constant = 130
           //  internetWorkingHeightConstain.constant = 235
            setCornerRadiusView(radius: Float(25), color: UIColor.clear, view: internetWorkingOkeyView)
           
        InternetWorkingLabel.text = "Please continue to enjoy\n Spectra’s fastest internet\n services"
    }
    
    func fDSSSRRaised(){
        
        iNWbackToHomeButtonTitleFD.text = "OKAY"
        iNWbackToHomeImageViewFD.image = UIImage(named:"frwd")
        iNWbackToHomeButtonWidthConstain.constant = 130
        backButton.isHidden = false
        if(self.view.frame.size.height <= 568)
            {
        InternetNOTWorkingLabel.font =  UIFont(name: "Helvetica", size: 16.0)
        InternetNOTETRWorkingLabel.font =  UIFont(name: "Helvetica", size: 16.0)
                                                                        
                                                                         }
        internetNOTWorkingView.isHidden = false
        InternetNOTWorkingLabel.text = "Service Request no. \(self.srNo) for \(self.typeSubype) registered and assigned to Technical team.\nResolution time is\n"
        
        if let value = HelpingClass.sharedInstance.convert(time: ETRvalue, fromFormate: "dd/MM/yyyy hh:mm a", toFormate:"dd/MM/yyyy" ),let valueTime = HelpingClass.sharedInstance.convert(time: ETRvalue, fromFormate: "dd/MM/yyyy hh:mm a", toFormate:"hh:mm a" ){
                                        
        InternetNOTETRWorkingLabel.text =  " \(value) by \(valueTime)"
                                          
        }
        
        
        internetNotWorkingHeightConstant.constant = 280
        iinternetNotWorkingHeight.constant = 140
    }
    func wANlightPAtner(){
        infoButtonPatner.isHidden = false
        backButton.isHidden = false
        fdView.isHidden = false
        if(voc == "3"){
               fdLabel.text = "Slow speed"
               gostImageView.image = UIImage(named:"slow")
                  }else{
               fdLabel.text = "Frequent disconnection"
               gostImageView.image = UIImage(named:"unlink")
                     
                  }
        
        if(self.view.frame.size.height <= 568)
                          {
            gponTimerStopLabel.font =  UIFont(name: "Helvetica", size: 16.0)
            gponTimer.font =  UIFont(name: "Helvetica", size: 18.0)
                                                                              
            noLabel.font =  UIFont(name: "Helvetica", size: 16.0)
            yesLabel.font =  UIFont(name: "Helvetica", size: 16.0)
                                     
                                                                            
                           }
                                 
                    gponTimerStopView.isHidden = false
                                gponTimerStopLabel.text = "Is the WAN light on your WiFi Router fluctuating?"
                                gponTimerStopTimerLabel.text = ""
                               
                                
                                self.noLabel.text = "NO"
                                 self.yesLabel.text = "YES"
        
    }
    
    
    func wANlightPAtnerFluctuatingLightNo(){
        backButton.isHidden = false
        fdView.isHidden = true
        seconds = 120
        gponView.isHidden = false
         gponLabel.text = "Spectra connectivity to your premises is fine.\n\n Please reboot your Wi-Fi router and wait."
        gponTimer.text = "02:00"
        timerFirst = Timer.scheduledTimer(timeInterval: 1, target: self,   selector: (#selector(NONGPONViewController.updateTimer)), userInfo: nil, repeats: true)
        
    }
    
    func wANlightPAtnerFluctuatingLightNoTimerStop(){
    
                backButton.isHidden = false
                fdView.isHidden = true
              gponTimerStopOKOFFView.isHidden = false
                              if(self.view.frame.size.height <= 568){
                                              gponTimerStopOKOFFLabel.font =  UIFont(name: "Helvetica", size: 16.0)
                                             
                                              }
    gponTimerStopOKOFFLabel.text = "Spectra connectivity to your premises is fine.\n\n Please reboot your Wi-Fi router and wait."
        if(voc == "3"){
            internetLabel.text = "Are you still facing Slow speed?"
            
        }else{
    internetLabel.text = "Are you still facing Frequent Disconnection?"
        }
            fdTitleHeightConstant.constant = 150
          fdSubTitleHeightConstant.constant = 50
           gponTimerStopOKOFFViewHight.constant = 380
    }
    
    
    @objc func updateTimer() {
         if seconds == 0 {
            
            if(self.isPantnerSelected == true){
                 seconds -= 1
                timerFirst?.invalidate()
                timerFirst = nil
                switch messageCode {
               case NoInternetMessageCode.GPON40DGIFD:
                                  messageCode = NoInternetMessageCode.GPON40DGIFDTimerStop
                case  NoInternetMessageCode.GPONNONStopWatchON:
                    break
                    messageCode = NoInternetMessageCode.GPON40StopWatch
                                 
                            break
                            default:
                            messageCode = NoInternetMessageCode.partnerStopWatch
                            break
                            
                 }
                
                
                setupUI()
                
            }else{
                timerFirst?.invalidate()
                timerFirst = nil
                
                if(self.isGPONSelected){
                    
                    
                    switch messageCode {
                        case NoInternetMessageCode.GPON40DGIFD:
                        messageCode = NoInternetMessageCode.GPON40DGIFDTimerStop
                    case  NoInternetMessageCode.GPON40StopWatch:
                    messageCode = NoInternetMessageCode.GPONNONStopWatchONOFFAgainTimer
                                     
                                break
                                default:
                                messageCode = NoInternetMessageCode.GPON40StopWatch
                                break
                                
                     }
                    messageCode = NoInternetMessageCode.GPON40StopWatch
                    setupUI()
                    
                }else{
                    
                    if(messageCode ==  NoInternetMessageCode.GPON40DGIFD ){
            messageCode = NoInternetMessageCode.GPON40DGIFDTimerStop
                    } else if(messageCode ==  NoInternetMessageCode.wANlightPAtnerFluctuatingLightNo){
                        messageCode = NoInternetMessageCode.wANlightPAtnerFluctuatingLightNoTimerStop
                    }
                    
                    else{
            messageCode = NoInternetMessageCode.GPONNONStopWatch
                    }
            setupUI()
                }
            }
              //Send alert to indicate "time's up!"
         } else if seconds > 0   {
              seconds -= 1
              gponTimer.text = timeString(time: TimeInterval(seconds))
         }else{
            
            timerFirst?.invalidate()
            timerFirst = nil
        }
    }
    
    
    @objc func updateTimerSecond() {
         if seconds == 0 {
             seconds -= 1
              timersecond?.invalidate()
            timersecond = nil
            
                     
            
             messageCode = NoInternetMessageCode.GPONNONStopWatchONOFFAgainTimer
            setupUI()
              //Send alert to indicate "time's up!"
         } else if seconds > 0   {
              seconds -= 1
              gponTimerOFFStopLabel.text = timeString(time: TimeInterval(seconds))
         }
        else{
            
            timerFirst?.invalidate()
            timerFirst = nil
        }
    }
    
    @IBAction func okGPONNONButtonClick(_ sender: Any)
       {
          if(messageCode ==  NoInternetMessageCode.wANlightPAtner ){
        self.frequentDisconnectInterWorkingOptionClick(useKey: "fluctuatingLight", useValue: "Yes")
                   
          }else{
        self.callwebserviceWithHud(useKey: "statusof9F/10Flight", useValue: "ON")
        }
        
      }
    
    @IBAction func noGPONNONButtonClick(_ sender: Any)
          {
           messageCode = NoInternetMessageCode.GPONNONStopWatchONOFF
           setupUI()
           
         }
    
    func timeString(time:TimeInterval) -> String {
   
    let minutes = Int(time) / 60 % 60
    let seconds = Int(time) % 60
        return String(format:"%02i:%02i",  minutes,seconds)
    }
    
    @IBAction func internetOKButtonClick(_ sender: Any)
    {
          if(messageCode ==  NoInternetMessageCode.GPON40DGIFDTimerStop ){
//            messageCode = NoInternetMessageCode.internetWorkingFD
//                      setupUI()
              self.frequentDisconnectInterWorkingOptionClick(useKey: "isInternetWorking", useValue: "Yes")
          } else if (messageCode ==  NoInternetMessageCode.wANlightPAtnerFluctuatingLightNoTimerStop){
             self.frequentDisconnectInterWorkingOptionClick(useKey: "facingIssue", useValue: "Yes")
            
          }
            
          else{
          self.callwebserviceWithHud(useKey: "isInternetWorking", useValue: "Yes")
        }
    }
    
    @IBAction func lightOnOfClickButtonClick(_ sender: Any)
    {
        
         if(messageCode ==  NoInternetMessageCode.wANlightPAtner ){
            self.frequentDisconnectInterWorkingOptionClick(useKey: "fluctuatingLight", useValue: "No")
         }
           
         else{
          self.callwebserviceWithoutHud(useKey: "statusof9F/10Flight", useValue: "OFF")
        }
       
     
    }
    
    @IBAction func internetCancelButtonClick(_ sender: Any)
    {
         switch messageCode {
            case  NoInternetMessageCode.GPON40:
          messageCode =   NoInternetMessageCode.GPONNONStopWatchONOFF
           self.setupUI()
            break
         case NoInternetMessageCode.GPON40StopWatch:
            // To Do
            
            if(self.alarmType == "DGI" && self.powerLevel == "-40"){
                self.callwebserviceWithoutHud(useKey: "isInternetWorking", useValue: "No")
            }
            else if(self.isPantnerSelected == true){
                
                self.callwebserviceWithoutHud(useKey: "isInternetWorking", useValue: "No")
            }
            else{
            
           messageCode = NoInternetMessageCode.GPONNONStopWatchONOFF//Pantner
            self.setupUI()
            }
            break
         case  NoInternetMessageCode.GPON40DGIFDTimerStop:
                       
        self.frequentDisconnectInterWorkingOptionClick(useKey: "isInternetWorking", useValue: "No")
             break
          case  NoInternetMessageCode.wANlightPAtnerFluctuatingLightNoTimerStop:
             self.frequentDisconnectInterWorkingOptionClick(useKey: "facingIssue", useValue: "No")
            break
            default:
                self.callwebserviceWithoutHud(useKey: "isInternetWorking", useValue: "No")
            break
        }
    }
    
    @IBAction func backToHome(_ sender: Any)
    {
           Switcher.updateRootVC()
    }
    
    
    func frequentDisconnectInterWorkingOptionClick(useKey:String,useValue:String){
        
        CANetworkManager.sharedInstance.progressHUD(show: true)
        
           let apiURL = ServiceMethods.serviceBaseFDSS + "/canId/\(canId)/voc/\(voc)"
         let dict = [useKey:useValue] as [String : Any]
        CANetworkManager.sharedInstance.requestApiWithoutHUD(serviceName: apiURL, method: kHTTPMethod.POST, postData: dict as Dictionary<String, AnyObject>) { (response, error) in
               CANetworkManager.sharedInstance.progressHUD(show: false)
            
            print_debug(object: response)
            
            var dataResponse = NSDictionary()
            var checkStatus = String()
            if let dict = response as? NSDictionary
                {
                dataResponse = dict
                }
                                                                            
                    checkStatus = ""
                    if let status = dataResponse.value(forKey: "status") as? String
                        {
                        checkStatus = status.lowercased()
                        }
                                          
            if checkStatus == Server.api_status
                    {
                                           
                    if let responce = dataResponse["response"] as? [String:AnyObject]{
                                           
                        if let  messageCode = responce["messageCode"] as? String{
                                        if let srNo = responce["srNo"] as? String{
                                                                   self.srNo = srNo
                                                               }

                                if let subSubType = responce["subType"] as? String,let problemType = responce["type"] as? String{
                                                                       
                                self.typeSubype = problemType + "-" + subSubType
                                                                       
                                                                   }
                            
                                  if let ETR = responce["etr"] as? String{
                                       
                                      
                                       self.ETRvalue = ETR
                                           
                                      
                                      
                                   }
                            
                            self.messageCode = messageCode
                            self.setupUI()
                            
                        }
                        }
            }
        
                       
                        
        }
    }
    
    
    
    func serviceTypeGetSRStatus(useKey: String, useNumber: String)
       {
           let dict = ["Action":ActionKeys.getSRStatus, "Authkey":UserAuthKEY.authKEY, useKey:useNumber]
           print_debug(object: dict)
           CANetworkManager.sharedInstance.requestApiWithoutHUD(serviceName: ServiceMethods.serviceBaseURL, method: kHTTPMethod.POST, postData: dict as Dictionary<String, AnyObject>) { (response, error) in
               
               print_debug(object: response)
            
            CANetworkManager.sharedInstance.progressHUD(show: false)
            
            if response != nil
            {
                
                if let status = response?["status"] as? String{
                    
                    
                    if status.lowercased() == Server.api_status{
                        
                        
                        if let array = response?["response"] as? [[String:AnyObject]]{
                            
                            
                            if array.count > 0 {
                                if let value = array[0] as? [String:AnyObject]{
                                    
                                    
                                    
                                     if let subSubType = value["subType"] as? String,let problemType = value["problemType"] as? String{
                                        
                                        self.typeSubype = problemType + "-" + subSubType
                                        
                                    }
                                    
                                    if let ETR = value["ETR"] as? String{
                                        
                                        if let value = HelpingClass.sharedInstance.convert(time: ETR, fromFormate: "MM/dd/yyyy hh:mm:ss a", toFormate:"dd/MM/yyyy hh:mm a" ){
                                        self.ETRvalue = ETR
                                            
                                        }
                                       
                                    }
                                   
                                    
                                    if(self.messageCode == NoInternetMessageCode.OpenSR){
                                      
                                        if let vc = UIStoryboard.init(name: "Storyboard", bundle: Bundle.main).instantiateViewController(withIdentifier: ViewIdentifier.OpenSRViewControllerIdentifier) as? OpenSRViewController
                                                        {
                                                                        
                                                            vc.messageCode = self.messageCode
                                                                                                        
                                                                        vc.canId = self.canId
                                                                        
                                                                        
                                                                vc.srNo = self.srNo
                                                           
                                                                    self.navigationController?.pushViewController(vc, animated: false)
                                                                                                               
                                                                       
                                                                        
                                        }
                                        
                                       
                                                                     
                                        
                                    }else{
                                        self.setupUI()}
                                    
                                }
        
                                
                            }
                            
                            
                        }
                        
                    }else{
                        
                        self.showSimpleAlert(TitaleName: "", withMessage: "Oops! Something has gone wrong. Try after some time.")
                        self.navigationController?.popViewController(animated: true)
                    }
                }
                
                
                 
           }else{
               
               self.showSimpleAlert(TitaleName: "", withMessage: "Oops! Something has gone wrong. Try after some time.")
               self.navigationController?.popViewController(animated: true)
           }
       }
    }
    
    
    func callwebserviceWithHud(useKey: String, useValue: String){
           
           
           let apiURL = ServiceMethods.serviceBaseURLInternetNotWorking + UserAuthKEY.authKEYInternetNotWorking + "/" + ServiceKeys.canId + "/"  + self.canId
           
           let dict = [useKey:useValue] as [String : Any]
           
           print_debug(object: "apiURL =" + apiURL)
           CANetworkManager.sharedInstance.requestApi(serviceName: apiURL, method: kHTTPMethod.POST, postData: dict as Dictionary<String, AnyObject>) { (response, error) in
               
               print_debug(object: response)
               if response != nil
               {
                   var dataResponse = NSDictionary()
                   var checkStatus = String()
                   if let dict = response as? NSDictionary
                   {
                       dataResponse = dict
                   }
                   
                   checkStatus = ""
                   if let status = dataResponse.value(forKey: "status") as? String
                   {
                       checkStatus = status.lowercased()
                   }
                   
                   if checkStatus == Server.api_status
                   {
                       
                       if let responce = dataResponse["response"] as? [String:AnyObject]{
                           
                           
                           
                           if let  messageCode = responce["messageCode"] as? String{
                               
                               self.messageCode = messageCode
                               
                           }
                        
                        if let srNo = responce["srNo"] as? String{
                                              self.srNo = srNo
                            self.serviceTypeGetSRStatus(useKey: "srNumber", useNumber: self.srNo)
                            
                        }else{
                                        
                           self.setupUI()
                        }
                       }
                   }else{
                       
                       self.showSimpleAlert(TitaleName: "", withMessage: "Oops! Something has gone wrong. Try after some time.")
                       self.navigationController?.popViewController(animated: true)
                   }
               }else{
                   
                   self.showSimpleAlert(TitaleName: "", withMessage: "Oops! Something has gone wrong. Try after some time.")
                   self.navigationController?.popViewController(animated: true)
               }
           }
       }
    
    func callwebserviceWithoutHud(useKey: String, useValue: String){
        
        CANetworkManager.sharedInstance.progressHUD(show: true)

        let apiURL = ServiceMethods.serviceBaseURLInternetNotWorking + UserAuthKEY.authKEYInternetNotWorking + "/" + ServiceKeys.canId + "/"  + self.canId
        
        let dict = [useKey:useValue] as [String : Any]
        
        print_debug(object: "apiURL =" + apiURL)
        CANetworkManager.sharedInstance.requestApiWithoutHUD(serviceName: apiURL, method: kHTTPMethod.POST, postData: dict as Dictionary<String, AnyObject>) { (response, error) in
            
            print_debug(object: response)
            if response != nil
            {
                var dataResponse = NSDictionary()
                var checkStatus = String()
                if let dict = response as? NSDictionary
                {
                    dataResponse = dict
                }
                
                checkStatus = ""
                if let status = dataResponse.value(forKey: "status") as? String
                {
                    checkStatus = status.lowercased()
                }
                
                if checkStatus == Server.api_status
                {
                    
                    if let responce = dataResponse["response"] as? [String:AnyObject]{
                        
                        
                        
                        if let  messageCode = responce["messageCode"] as? String,  let  problemType = responce["problemType"] as? String {
                            
                            if(messageCode == "218" && problemType == "statusof9F/10FlightOFF" ){
                                self.messageCode = "226"
                            }else{
                            self.messageCode = messageCode
                            }
                            
                        }
                        if let srNo = responce["srNumber"] as? String{
                        self.srNo = srNo
                        }
                        
                        if let srNo = responce["srNo"] as? String{
                        self.srNo = srNo
                        }
                        self.serviceTypeGetSRStatus(useKey: "srNumber", useNumber: self.srNo)
                    }
                }else{
                    
                    self.showSimpleAlert(TitaleName: "", withMessage: "Oops! Something has gone wrong. Try after some time.")
                    self.navigationController?.popViewController(animated: true)
                }
            }else{
                
                self.showSimpleAlert(TitaleName: "", withMessage: "Oops! Something has gone wrong. Try after some time.")
                self.navigationController?.popViewController(animated: true)
            }
        }
    }
    
    
    func showSimpleAlert(TitaleName: String, withMessage: String)
    {
        let alert = UIAlertController(title: TitaleName, message: withMessage,preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: AlertViewButtonTitle.title_OK,style: UIAlertAction.Style.default,handler: {(_: UIAlertAction!) in
            
        self.navigationController?.popViewController(animated: true)
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
    @IBAction func backBTN(_ sender: Any)
             {
                 self.navigationController?.popViewController(animated: false)
             }
    
    @IBAction func infoButtonClick(_ sender: Any)
    {
        infoView.isHidden = false
        
    }
    
    @IBAction func infoButtonCrossClick(_ sender: Any)
    {
        infoView.isHidden = true
        
    }
    
    @IBAction func infoButtonClickONT(_ sender: Any)
    {
        infoViewONT.isHidden = false
        
    }
    
    @IBAction func infoButtonCrossClickONT(_ sender: Any)
    {
        infoViewONT.isHidden = true
        
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
