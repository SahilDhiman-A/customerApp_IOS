//
//  SIPrivacyPolicyViewController.swift
//  My Spectra
//
//  Created by Bhoopendra on 10/10/19.
//  Copyright © 2019 Bhoopendra. All rights reserved.
//

import UIKit

class SIPrivacyPolicyViewController: UIViewController,UIWebViewDelegate {
  
    @IBOutlet weak var webView: UIWebView!
    
    //MARK: View controller life cycle
    override func viewDidLoad()
    {
        super.viewDidLoad()

        CANetworkManager.sharedInstance.progressHUD(show: true)
        let url = URL(string: StandinInsrcuction.siTermAndConditionURL)
        webView.loadRequest(URLRequest(url: url!))
    }
    
    //MARK: WebView Delegate
    func webViewDidStartLoad(_ webView: UIWebView)
       {
           CANetworkManager.sharedInstance.progressHUD(show: true)
       }
       
       func webView(_ webView: UIWebView, didFailLoadWithError error: Error)
       {
           CANetworkManager.sharedInstance.progressHUD(show: false)
       }
       
       func webViewDidFinishLoad(_ webView: UIWebView)
       {
           CANetworkManager.sharedInstance.progressHUD(show: false)
       }
    
    //MARK: Button Action
    @IBAction func hideTermCndtionView(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
}
