//
//  TrackOrderViewController.swift
//  My Spectra
//
//  Created by Chakshu on 12/24/19.
//  Copyright © 2019 Bhoopendra. All rights reserved.
//

import UIKit

class TrackOrderViewController: UIViewController {
    
    
    @IBOutlet weak var trackOderView: UIView!
    
    
    
    @IBOutlet weak var cafSubmitDateLabel: UILabel!
    @IBOutlet weak var cafSubmitImageView: UIImageView!
    @IBOutlet weak var cafSubmitLabel: UILabel!
    @IBOutlet weak var cafSubmitDot: UIImageView!
    
   
    @IBOutlet weak var completeDotImageView: UIImageView!
    
    @IBOutlet weak var completeImageView: UIImageView!
    
    @IBOutlet weak var completeDateLabel: UILabel!
    @IBOutlet weak var completeLabel: UILabel!
    
    
    @IBOutlet weak var varifyDot: UIImageView!
    
    @IBOutlet weak var varifyDateLabel: UILabel!
    @IBOutlet weak var varifyLabel: UILabel!
    @IBOutlet weak var varifyImageView: UIImageView!
    
    
    
    @IBOutlet weak var browsingDot: UIImageView!
    
    @IBOutlet weak var browsingDateLabel: UILabel!
    @IBOutlet weak var browsingLabel: UILabel!
    @IBOutlet weak var browsingImageView: UIImageView!
    @IBOutlet weak var customerAccountLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var backgroundScrollView: UIScrollView!
    
    var canID = ""
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.setUpUI()
    }
    
    
    
    func setUpUI()  {
        setCornerRadiusView(radius: 20, color: UIColor.clear, view: trackOderView)
        
        backgroundScrollView.isHidden = true
        trackOderView.isHidden = true
        
        
        self.webServiceToGetTrackOrder()

    }
    
    
    override func viewWillLayoutSubviews(){
        super.viewWillLayoutSubviews()
      backgroundScrollView.contentSize = CGSize(width: self.view.frame.size.width, height: 705)
    }
    
    
    func webServiceToGetTrackOrder() {
        
        
        let dict = ["Action":ActionKeys.trackOrder, "Authkey":UserAuthKEY.authKEY, "canID":canID]
        
        CANetworkManager.sharedInstance.requestApi(serviceName: ServiceMethods.serviceBaseURL, method: kHTTPMethod.POST, postData: dict as Dictionary<String, AnyObject>) {[weak self] (response, error) in
            
            print_debug(object: response)
            
            self?.backgroundScrollView.isHidden = false
           
            
            if response != nil
            {
                
                if let responseValue = response?["response"] as? [String:AnyObject]{
                    
                     self?.trackOderView.isHidden = false
                    if let name = responseValue["Name"] as? String{
                        
                        self?.nameLabel.text = name
                        
                    }
                    if let canID = responseValue["CANID"] as? String{
                        
                        self?.customerAccountLabel.text = canID
                        
                    }
                    
                    if let statusDates = responseValue["StatusDates"] as? String{
                        
                        let array = statusDates.components(separatedBy: ",")
                        
                        print_debug(object: array)
                    
                        
                        
                        for string in array{
                            
                            
                            self?.setValueToOrder(value: string)
                            
                        }
                        
                        
                        
            
        }
                }else{
                    
                    if let message = response?["message"] as? String{
                        self?.showSimpleAlert(TitaleName: "", withMessage: message)
                    }
                }
             
            }else{
                if let message = response?["message"] as? String{
                    self?.showSimpleAlert(TitaleName: "", withMessage: message)
                }
            }
        }
            }
            
          
    
    
    func setValueToOrder(value :String){
        
        
        print_debug(object: value)
        
        
        let array = value.components(separatedBy: "|")
        print_debug(object: array)
        if(array.count>1){
            
            if let value = array[0] as? String, let data  = array[1] as? String{
                
                
                if let date = HelpingClass.sharedInstance.convert(time: data, fromFormate: "MM/dd/yyyy hh:mm:ss a") as? Date{
                    
                    
                    if let dateValue = HelpingClass.sharedInstance.convert(date: date, fromFormate: "dd-MM-yyyy") as? String{
                
                
                
                    
                switch value
                {
                case "CAF Submitted":
                    
                 
                    changeImageTintColor(theImageView: cafSubmitDot, withColor: UIColor.trackOrderSelectedColor)
                    changeImageTintColor(theImageView: cafSubmitImageView, withColor: UIColor.trackOrderSelectedColor)
//                    cafSubmitDot.image = UIImage(named: "Group 502")
//                    cafSubmitImageView.image = UIImage(named: "orderMadeSelected")
                    cafSubmitDateLabel.text = dateValue
                    cafSubmitLabel.textColor = UIColor.trackOrderSelectedColor
                     cafSubmitDateLabel.textColor = UIColor.trackOrderSelectedColor
                    cafSubmitLabel.text = value
                    
                    break
                case "Documents Verified":
                    changeImageTintColor(theImageView: completeDotImageView, withColor: UIColor.trackOrderSelectedColor)
                    changeImageTintColor(theImageView: completeImageView, withColor: UIColor.trackOrderSelectedColor)
//                    completeDotImageView.image = UIImage(named: "Group 502")
//                    completeImageView.image = UIImage(named: "internetWorkingSelected")
                    completeDateLabel.text = dateValue
                    completeLabel.textColor = UIColor.trackOrderSelectedColor
                    completeDateLabel.textColor = UIColor.trackOrderSelectedColor
                    completeLabel.text = value
                    
                    break
                case "Installation completed":
                    
                    changeImageTintColor(theImageView: varifyDot, withColor: UIColor.trackOrderSelectedColor)
                    changeImageTintColor(theImageView: varifyImageView, withColor: UIColor.trackOrderSelectedColor)
//                    varifyDot.image = UIImage(named: "Group 502")
//                    varifyImageView.image = UIImage(named: "installationDoneSelected")
                    varifyDateLabel.text = dateValue
                    varifyDateLabel.textColor = UIColor.trackOrderSelectedColor
                    varifyLabel.textColor = UIColor.trackOrderSelectedColor
                    varifyLabel.text = value
                    
                    
                    break
                case "Happy Browsing":
                    changeImageTintColor(theImageView: browsingDot, withColor: UIColor.trackOrderSelectedColor)
                    changeImageTintColor(theImageView: browsingImageView, withColor: UIColor.trackOrderSelectedColor)
//                    browsingDot.image = UIImage(named: "Group 502")
//                    browsingImageView.image = UIImage(named: "documentsVerifiedSelected")
                    browsingLabel.text = value
                    browsingLabel.textColor = UIColor.trackOrderSelectedColor
                     browsingDateLabel.textColor = UIColor.trackOrderSelectedColor
                    browsingDateLabel.text = dateValue
                    
                    break
                default:
                    break
                    
                }
                
                    }
            }
            }
            
            
            
        }
        
    }
    
    
    
    
    @IBAction func logoutButtonClick(_ sender: Any) {
        
        HelpingClass.saveToUserDefault(value: false as AnyObject, key: "status")
        Switcher.updateRootVC()
    }
    
    func showSimpleAlert(TitaleName: String, withMessage: String)
    {
        let alert = UIAlertController(title: TitaleName, message: withMessage,preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: AlertViewButtonTitle.title_OK,style: UIAlertAction.Style.default,handler: {(_: UIAlertAction!) in
            
        
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
    @IBAction func callFromPhone(_ sender: Any) {
        
        if let url = URL(string: "tel://18001215678"), UIApplication.shared.canOpenURL(url) {
            if #available(iOS 10, *) {
                UIApplication.shared.open(url)
            } else {
                UIApplication.shared.openURL(url)
            }
        }
    }
    func changeImageTintColor(theImageView: UIImageView, withColor: UIColor)
    {
        theImageView.image = theImageView.image?.withRenderingMode(.alwaysTemplate)
        theImageView.tintColor = withColor
    }

    
    @IBAction func myAccountClick(_ sender: Any) {
           let vc = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: ViewIdentifier.AccountIdentifier) as? AccountViewController
           vc?.fromScreen = FromScreen.deactivateScreen
           self.navigationController?.pushViewController(vc!, animated: false)
           
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
