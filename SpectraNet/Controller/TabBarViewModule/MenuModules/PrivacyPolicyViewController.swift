//
//  PrivacyPolicyViewController.swift
//  SpectraNet
//
//  Created by Bhoopendra on 9/9/19.
//  Copyright © 2019 Bhoopendra. All rights reserved.
//

import UIKit
import WebKit
import SVProgressHUD

class PrivacyPolicyViewController: UIViewController,UIWebViewDelegate {

    @IBOutlet weak var wbView: UIWebView!
    var webViewlink = String()
    
    //MARK: View controller life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        CANetworkManager.sharedInstance.progressHUD(show: true)
        let url = URL(string: webViewlink)
        if let webUrl = url
        {
            wbView.loadRequest(URLRequest(url: webUrl))
        }
    }
    //MARK: Button Action
    @IBAction func backBTN(_ sender: Any) {
        self.navigationController?.popViewController(animated: false)
    }
    
    //MARK: WebView delegate
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
}


