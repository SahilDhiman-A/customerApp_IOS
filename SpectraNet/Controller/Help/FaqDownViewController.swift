//
//  FaqDownViewController.swift
//  My Spectra
//
//  Created by Chakshu on 21/09/21.
//  Copyright © 2021 Bhoopendra. All rights reserved.
//

import UIKit

class FaqDownViewController: UIViewController,UITextViewDelegate {
    var canID = String()
    var faqID = String()
    var packageID = String()
    @IBOutlet weak var textView: UITextView!
    var dismissOnSubmitValue:((Int) -> Void)? = nil
    override func viewDidLoad() {
        super.viewDidLoad()
        textView.text = "Please enter the remarks"
        textView.textColor = UIColor.lightGray
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == UIColor.lightGray {
            textView.text = nil
            textView.textColor = UIColor.black
        }
    }
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
            if(text == "\n") {
                textView.resignFirstResponder()
                return false
            }
            return true
        }

        /* Older versions of Swift */
        func textView(textView: UITextView, shouldChangeTextInRange range: NSRange, replacementText text: String) -> Bool {
            if(text == "\n") {
                textView.resignFirstResponder()
                return false
            }
            return true
        }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = "Please enter the remarks"
            textView.textColor = UIColor.lightGray
        }
    }
    @IBAction func submitClick(_ button: UIButton){
        
        if(textView.text == "" || textView.text == "Please enter the remarks"){
            self.showSimpleAlert(TitaleName: "", withMessage: "Please enter the remarks")
            return
        }
        
        let apiURL = ServiceMethods.notificationServiceBaseUrl + ActionKeys.thumbsdown

        let data = ["can_id":canID,"faq_id":faqID,"reason":textView.text ?? ""] as [String : Any]
        CANetworkManager.sharedInstance.requestApi(serviceName: apiURL, method: .PUT, postData: data  as Dictionary<String, AnyObject>)  { (response, error) in
            print_debug(object: response)
            if response != nil
            {
                if let statusCode = response?["statusCode"] as? Double{
                    if(statusCode == 200){
                        self.dismiss(animated: true) {
                            if let clouser = self.dismissOnSubmitValue{
                                clouser(0)
                            }
                        }
                    }
                }
            }
        }
    }
    
    func showSimpleAlert(TitaleName: String, withMessage: String)
    {
        let alert = UIAlertController(title: TitaleName, message: withMessage,preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: AlertViewButtonTitle.title_OK,style: UIAlertAction.Style.default,handler: {(_: UIAlertAction!) in
     
      
        }))
        self.present(alert, animated: true, completion: nil)
    }
    @IBAction func crossButtonclick(_ button: UIButton){
        self.dismiss(animated: true) {
        }
    }
}
