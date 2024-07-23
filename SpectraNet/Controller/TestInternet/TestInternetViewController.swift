//
//  TestInternetViewController.swift
//  My Spectra
//
//  Created by Chakshu on 12/18/19.
//  Copyright © 2019 Bhoopendra. All rights reserved.
//

import UIKit
import UIKit
import Alamofire
import WebKit
import PDFKit
class TestInternetViewController: UIViewController {

    
          var url: URL!
    var mediaUrl: String!
    
        var wKWebView: WKWebView!
    
    var isInternetView = true

        @IBOutlet weak var containerView: UIView!
       

        override func viewDidLoad() {
            super.viewDidLoad()
            
            
            //CANetworkManager.sharedInstance.progressHUD(show: true)
            
            if(mediaUrl.contains(".pdf")){
                let pdfView = PDFView(frame: createWKWebViewFrame(size: view.frame.size))
                    pdfView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
                containerView.addSubview(pdfView)
                    
                    // Fit content in PDFView.
                    pdfView.autoScales = true
                    
                    // Load Sample.pdf file from app bundle.
                self.url = URL(string: mediaUrl)
                    pdfView.document = PDFDocument(url: self.url!)
                
                
                
            }else
            {
                
               // self.mediaUrl = "http://techslides.com/demos/sample-videos/small.mp4"
            self.url = URL(string: mediaUrl)
            wKWebView = WKWebView(frame: createWKWebViewFrame(size: view.frame.size))
                wKWebView.scrollView.backgroundColor = UIColor.black
        containerView.addSubview(wKWebView)
            wKWebView.navigationDelegate = self
            wKWebView.uiDelegate = self
               
            
                let request = URLRequest(url: url)
                wKWebView.load(request)
                
            }
        }

        

        override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
            wKWebView.frame = createWKWebViewFrame(size: size)
        }

       
     @IBAction func closeButtonAction(_ sender: Any) {
   
             
            if(isInternetView){
           self.navigationController?.popViewController(animated: false)
            }else{
             
            self.dismiss(animated: true) {
       }

            }
    }
    }

    extension TestInternetViewController {
        fileprivate func createWKWebViewFrame(size: CGSize) -> CGRect {
           
            let navigationHeight: CGFloat = 60
                    let toolbarHeight: CGFloat = 44
                    let height = size.height - navigationHeight - toolbarHeight
            return CGRect(x: 0, y: toolbarHeight, width: size.width, height: height)
        }
    }

    extension TestInternetViewController: WKNavigationDelegate {
        func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
            
            if(mediaUrl.contains("webm") || mediaUrl.contains(".ogv") || mediaUrl.contains(".mp4") || mediaUrl.contains(".3gp")){
                CANetworkManager.sharedInstance.progressHUD(show: false)
            }else{
                
                CANetworkManager.sharedInstance.progressHUD(show: true)
            }
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

    extension TestInternetViewController: WKUIDelegate {
        func webView(_ webView: WKWebView, createWebViewWith configuration: WKWebViewConfiguration, for navigationAction: WKNavigationAction, windowFeatures: WKWindowFeatures) -> WKWebView? {
            if navigationAction.targetFrame == nil {
                webView.load(navigationAction.request)
            }
            return nil
        }
    }
