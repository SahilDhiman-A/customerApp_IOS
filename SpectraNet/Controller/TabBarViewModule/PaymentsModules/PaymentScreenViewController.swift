//
//  PaymentScreenViewController.swift
//  SpectraNet
//
//  Created by Bhoopendra on 9/12/19.
//  Copyright © 2019 Bhoopendra. All rights reserved.
//

import UIKit

class PaymentScreenViewController: UIViewController, UIWebViewDelegate {
    @IBOutlet weak var webview: UIWebView!
    var paymentStr = String()
    var emailStr = String()
    var mobileNoStr = String()
    var canID = String()
    var sessionTime = String()
    var tdsAmount = String()
    var postString = String()
    var dataResponse = NSDictionary()
    var checkStatus = String()
    
    var profileListData = NSDictionary()
    var paymentURLStr = String()
    
    // SI payment success or failed views
    @IBOutlet weak var transprntView: UIView!
    @IBOutlet weak var dialogView: UIView!
    @IBOutlet weak var lblStatusMsg: UILabel!
    @IBOutlet weak var okButtonView: UIView!
    var siPaymentStaus = String()

    //MARK: View controller life cycle
    override func viewDidLoad() {
        super.viewDidLoad()

        if postString != ""
        {
            loadData()
        }
        else
        {
            serviceTypeGetProfile()
        }
        hiddenAndShowViews(bool: true, statusMeg: "")
    }
    
    func loadData()
    {
        if postString != ""
        {
            paymentURLStr = StandinInsrcuction.standingInstructionSpectraPaymentURL
        }
        else
        {
            paymentURLStr = ServiceMethods.spectraPaymentURL
            if tdsAmount == ""
            {
                postString = "uid=cust_app&passcode=C%217%24uT%4099%23&payamnt=\(paymentStr)&session=\(sessionTime)&segment=Web&paytype=Normal&mobileno=\(mobileNoStr)&emailid=\(emailStr)&returnurl=\(StandinInsrcuction.returnURL)&can_id=\(canID)"
            }
            else
            {
                postString = "uid=cust_app&passcode=C%217%24uT%4099%23&payamnt=\(paymentStr)&session=\(sessionTime)&segment=Web&paytype=Normal&mobileno=\(mobileNoStr)&emailid=\(emailStr)&returnurl=\(StandinInsrcuction.returnURL)&can_id=\(canID)&tds_amount=\(tdsAmount)"
            }
        }
        
        var contentType = String()
        contentType = "application/x-www-form-urlencoded"
        let _data = Data(base64Encoded: postString.toBase64())
        webview.delegate = self
        var request = URLRequest(url: URL(string: paymentURLStr)!)
        request.httpMethod = "POST"
        request.setValue(contentType, forHTTPHeaderField: "Content-Type")
        request.httpBody = _data
        webview.reload()
        webview.loadRequest(request)
        setCornerRadiusView(radius: Float(okButtonView.frame.height/2), color: UIColor.clear, view: okButtonView)
    }
    
    func webViewDidStartLoad(_ webView: UIWebView)
    {
        print_debug(object: "Start")
    }
    
    func webView(_ webView: UIWebView, didFailLoadWithError error: Error)
    {
        print_debug(object: "Error")
    }
    
    func webViewDidFinishLoad(_ webView: UIWebView)
    {
        print_debug(object: "Finished")
        let currentURL = webView.stringByEvaluatingJavaScript(from: "window.location.href")!
        print_debug(object: "\(currentURL)")

        
        if currentURL.contains("https://epay.spectra.co/onlinepayment/returnUrl?passkey=")
        {
          //  let newURL = URL(string: currentURL)!
            guard let newURL = URL(string: currentURL) else
            {
                return
            }
            let referrer = newURL["passkey"]
            print_debug(object: referrer)

            let decodedData = Data(base64Encoded: referrer ?? "")!
            let decodedString = String(data: decodedData, encoding: .utf8)!
            print_debug(object: decodedString)

            var urlStatus = String()
            if decodedString.contains("status=SUCCESS")
            {
                urlStatus = Payment.success_status
            }
            else
            {
                urlStatus = Payment.failure_status
            }
            let vc = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: ViewIdentifier.paymentstatusIndentifier) as? PaymentStatusViewController
            vc?.status = urlStatus
           // vc?.ifSiPayment = ""
            vc?.payableAmount = paymentStr
            self.navigationController?.pushViewController(vc!, animated: false)
        }
        else if currentURL.contains("https://my.spectra.co/index.php/xml/sipayment?result=")
        {
            guard let getSiUrl = URL(string: currentURL) else
            {
                return
            }
            
            let referrer = getSiUrl["result"]
            
            let decodedUrl = referrer?.removingPercentEncoding!
            print_debug(object: decodedUrl)
            
            guard let decoded = decodedUrl?.convertToDictionary() else
            {
                return
            }
            guard let paymentStatus = decoded["paymentStaus"] as? Bool else
            {
                return
            }
            
            print_debug(object: paymentStatus)
            if paymentStatus == true
            {
                siPaymentStaus = Payment.success_status
                hiddenAndShowViews(bool: false, statusMeg: StandinInsrcuction.siEnabled)
            }
            else
            {
                siPaymentStaus = Payment.failure_status
                hiddenAndShowViews(bool: false, statusMeg: StandinInsrcuction.siEnabledFailed)
            }
        }
    }
    
    func getCurrentMillis()->Int64{
        return  Int64(NSDate().timeIntervalSince1970 * 1000)
    }

    @IBAction func backBTM(_ sender: Any)
    {
        self.navigationController?.popViewController(animated: false)
    }
    
    func serviceTypeGetProfile()
    {
        let dict = ["Action":ActionKeys.getProfile, "Authkey":UserAuthKEY.authKEY, "canID":canID]
        print_debug(object: dict)

        CANetworkManager.sharedInstance.requestApi(serviceName: ServiceMethods.serviceBaseURL, method: kHTTPMethod.POST, postData: dict as Dictionary<String, AnyObject>) { (response, error) in
            
            print_debug(object: response)
            if response != nil
            {
                if let dict = response as? NSDictionary
                {
                    self.dataResponse = dict
                }
                                                  
                self.checkStatus = ""
                if let status = self.dataResponse.value(forKey: "status") as? String
                {
                    self.checkStatus = status.lowercased()
                }
                
                if self.checkStatus == Server.api_status
                {
                    guard let userProfile = self.dataResponse.value(forKey: "response") as? NSDictionary else
                    {
                        return
                    }
                    self.profileListData = userProfile
                    
                    if AppDelegate.sharedInstance.segmentType == segment.userB2C
                    {
                        guard let UserB2CData = self.profileListData.value(forKey: "shipTo") as? NSDictionary else
                        {
                            return
                        }
                        self.setData(dict: UserB2CData)
                    }
                    else
                    {
                        guard let UserB2BData = self.profileListData.value(forKey: "billTo") as? NSDictionary else
                        {
                            return
                        }
                        self.setData(dict: UserB2BData)
                    }
                }
                else
                {
                    guard let errorMsg = self.dataResponse.value(forKey: "message") as? String else
                    {
                        return
                    }
                    self.showAlertC(message: errorMsg)
                }
            }
        }
    }
    
    func setData(dict: NSDictionary)
    {
        emailStr = ""
        if let email = dict.value(forKey: "email") as? String
        {
            emailStr = email
        }
        
        mobileNoStr = ""
        if let mobileNmbr = dict.value(forKey: "mobile") as? String
        {
            mobileNoStr = mobileNmbr
        }
        
        loadData()
    }
    @IBAction func cliuckStatusButton(_ sender: Any)
    {
        hiddenAndShowViews(bool: true, statusMeg: "")
        if siPaymentStaus == Payment.success_status
        {
            navigateScreen(identifier: ViewIdentifier.customTabIdentifier, controller: CustomTabViewController.self)
        }
        else
        {
            self.navigationController?.popViewController(animated: false)
        }
    }
    
    func hiddenAndShowViews(bool: Bool,statusMeg: String)
    {
        transprntView.isHidden = bool
        dialogView.isHidden = bool
        lblStatusMsg.text = statusMeg
    }
}

extension String
{
    func fromBase64() -> String?
    {
        guard let data = Data(base64Encoded: self) else {
            return nil
        }

        return String(data: data, encoding: .utf8)
    }

    func toBase64() -> String
    {
        return Data(self.utf8).base64EncodedString()
    }
}
extension URL {
    subscript(queryParam: String) -> String? {
        guard let url = URLComponents(string: self.absoluteString) else { return nil }
        if let parameters = url.queryItems {
            return parameters.first(where: { $0.name == queryParam })?.value
        } else if let paramPairs = url.fragment?.components(separatedBy: "?").last?.components(separatedBy: "&") {
            for pair in paramPairs where pair.contains(queryParam) {
                return pair.components(separatedBy: "=").last
            }
            return nil
        } else {
            return nil
        }
    }
}
