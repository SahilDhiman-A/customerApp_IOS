//
//  SIPrivacyPolicyViewController.swift
//  My Spectra
//
//  Created by Bhoopendra on 10/10/19.
//  Copyright © 2019 Bhoopendra. All rights reserved.
//

import UIKit
import WebKit
class SIPrivacyPolicyViewController: UIViewController {
  
    var wKWebView: WKWebView!
    
    //MARK: View controller life cycle
    override func viewDidLoad()
    {
        super.viewDidLoad()

        CANetworkManager.sharedInstance.progressHUD(show: true)
        let url = URL(string: StandinInsrcuction.siTermAndConditionURL)
        wKWebView = WKWebView(frame: createWKWebViewFrame(size: view.frame.size))
            wKWebView.scrollView.backgroundColor = UIColor.black
        self.view.addSubview(wKWebView)
        wKWebView.navigationDelegate = self
        wKWebView.uiDelegate = self
        wKWebView.load(URLRequest(url: url!))
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

extension SIPrivacyPolicyViewController {
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

extension UIDevice {
    var hasNotch: Bool {
           guard #available(iOS 11.0, *), let window = UIApplication.shared.windows.filter({$0.isKeyWindow}).first else { return false }
           if UIDevice.current.orientation.isPortrait {
               return window.safeAreaInsets.top >= 44
           } else {
               return window.safeAreaInsets.left > 0 || window.safeAreaInsets.right > 0
           }
       }
}
extension SIPrivacyPolicyViewController: WKNavigationDelegate {
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

extension SIPrivacyPolicyViewController: WKUIDelegate {
    func webView(_ webView: WKWebView, createWebViewWith configuration: WKWebViewConfiguration, for navigationAction: WKNavigationAction, windowFeatures: WKWindowFeatures) -> WKWebView? {
        if navigationAction.targetFrame == nil {
            webView.load(navigationAction.request)
        }
        return nil
    }
}
