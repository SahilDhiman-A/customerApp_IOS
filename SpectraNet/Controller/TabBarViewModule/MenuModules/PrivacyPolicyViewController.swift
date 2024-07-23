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

class PrivacyPolicyViewController: UIViewController {

   
    var webViewlink = String()
    var wKWebView: WKWebView!
    //MARK: View controller life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        CANetworkManager.sharedInstance.progressHUD(show: true)
        let url = URL(string: webViewlink)
        if let webUrl = url
        {
            wKWebView = WKWebView(frame: createWKWebViewFrame(size: view.frame.size))
                wKWebView.scrollView.backgroundColor = UIColor.black
            self.view.addSubview(wKWebView)
            wKWebView.navigationDelegate = self
            wKWebView.uiDelegate = self
            wKWebView.load(URLRequest(url: webUrl))
        }
    }
    //MARK: Button Action
    @IBAction func backBTN(_ sender: Any) {
        self.navigationController?.popViewController(animated: false)
    }
    
    //MARK: WebView delegate
    
}
extension PrivacyPolicyViewController {
    fileprivate func createWKWebViewFrame(size: CGSize) -> CGRect {
       
        var navigationHeight: CGFloat = navigationBarHeight + 20
        if UIDevice.current.hasNotch {
            navigationHeight = navigationHeight + 30
        }
                let toolbarHeight: CGFloat = navigationHeight
                let height = size.height - navigationHeight - toolbarHeight
        return CGRect(x: 0, y: toolbarHeight, width: size.width, height: height)
    }
}
extension UIViewController {
  var navigationBarbarContentStart: CGFloat {
    return self.navigationBarTopOffset + self.navigationBarHeight
  }
  var navigationBarTopOffset: CGFloat {
    return self.navigationController?.navigationBar.frame.origin.y ?? 0
  }

  var navigationBarHeight: CGFloat {
    return self.navigationController?.navigationBar.frame.height ?? 0
  }
}

extension PrivacyPolicyViewController: WKNavigationDelegate {
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        
       
            
            CANetworkManager.sharedInstance.progressHUD(show: true)
        
    }

    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        CANetworkManager.sharedInstance.progressHUD(show: false)
      
        // if url is not valid {
        //    decisionHandler(.cancel)
        // }
        decisionHandler(.allow)
    }

    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        // dismiss indicator
        CANetworkManager.sharedInstance.progressHUD(show: false)
//            goBackButton.isEnabled = webView.canGoBack
//            goForwardButton.isEnabled = webView.canGoForward
        navigationItem.title = webView.title
    }

    func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error) {
      // show error dialog
        CANetworkManager.sharedInstance.progressHUD(show: false)
    }
}

extension PrivacyPolicyViewController: WKUIDelegate {
    func webView(_ webView: WKWebView, createWebViewWith configuration: WKWebViewConfiguration, for navigationAction: WKNavigationAction, windowFeatures: WKWindowFeatures) -> WKWebView? {
        if navigationAction.targetFrame == nil {
            webView.load(navigationAction.request)
        }
        return nil
    }
}


