//
//  InvoiceContentViewController.swift
//  SpectraNet
//
//  Created by Bhoopendra on 8/19/19.
//  Copyright © 2019 Bhoopendra. All rights reserved.
//

import UIKit
import ObjectMapper
import RealmSwift
import WebKit
import PDFKit

class InvoiceContentViewController: UIViewController,UIWebViewDelegate
{
    var invoiceContent = InvoicePDFContentData()
    var userResult:Results<UserCurrentData>? = nil
    var canID = ""
    var realm:Realm? = nil
    @IBOutlet weak var pdfView: PDFView!
    @IBOutlet weak var webView2: UIWebView!
    var invoiceNumber = String()
    var sendInvoiceNumber = String()
    var htmlStr = String()
    
    //MARK: View controller life cycle
    override func viewDidLoad() {
        super.viewDidLoad()

        realm = try? Realm()
        if ConnectionCheck.isConnectedToNetwork() == true
        {
            if AppDelegate.sharedInstance.fileUrl.absoluteString == ""
            {
                 serviceTypeInvoiceContentData()
            }
            else
            {
//            if !FileManager.default.fileExists(atPath:AppDelegate.sharedInstance.fileUrl.path!)
//            {
                serviceTypeInvoiceContentData()
//            }
//            else
//            {
//                if let document = PDFDocument(url: AppDelegate.sharedInstance.fileUrl as URL) {
//                    pdfView.document = document
//                }
//            }
          }
        }
        else
        {
            noInternetCheckScreenWithMessage(errorMessage:"")
        }
        webView2.isHidden = true
    }

    func serviceTypeInvoiceContentData()
    {
        let dict = ["Action":ActionKeys.invoiceContent, "Authkey":UserAuthKEY.authKEY,"invoiceNo":invoiceNumber]
        print_debug(object: dict)

        CANetworkManager.sharedInstance.requestApi(serviceName: ServiceMethods.serviceBaseURL, method: kHTTPMethod.POST, postData: dict as Dictionary<String, AnyObject>) { (response, error) in
            
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
                    guard let invoiceHtml = dataResponse.value(forKey: "response") as? String else
                    {
                        return
                    }
                    
                //    DatabaseHandler.instance().getAndSaveInvoicePDFContentData(htmlString: invoiceHtml)
                 //   self.invoiceContent = self.realm!.obj

                    self.htmlStr = invoiceHtml
                    self.webView2.loadHTMLString(self.htmlStr, baseURL: nil)
                    self.webView2.delegate = self
                    self.webView2.isHidden = true
                }
                else
                {
                    guard let errorMsg = dataResponse.value(forKey: "message") as? String else
                    {
                        return
                    }
                    self.showAlertC(message: errorMsg)
                }
            }
        }
    }
    
    
    @IBAction func backButton(_ sender: Any)
    {
        self.navigationController?.popViewController(animated: false)
    }
    
    @IBAction func shareInvoice(_ sender: Any)
    {
        // loadPDFAndShare()
        shareInvoiceDetailFirbaseAnalysics()
        let title = String(format: "%@%@",SpectraInvoiceTitle.invoiceTitle,sendInvoiceNumber )
        //let content = AppDelegate.sharedInstance.fileUrl
        
        let url = NSURL.fileURL(withPath: AppDelegate.sharedInstance.fileUrl.absoluteString ?? "")
        print_debug(object: url)
        let objectsToShare = [title, url] as [Any]
        let vc = UIActivityViewController(activityItems: objectsToShare, applicationActivities: [])
        self.present(vc, animated: true)
    }
  
    func shareInvoiceDetailFirbaseAnalysics(){
        
        let dictAnalysics = [AnanlysicParameters.canID:canID,
                             AnanlysicParameters.Category:AnalyticsEventsCategory.Payments,
                             AnanlysicParameters.Action:AnalyticsEventsActions.invoiceShare,
                             AnanlysicParameters.EventType:AnanlysicParameters.ClickEvent]

       HelpingClass.sharedInstance.addFirebaseAnalysis(eventName: AnalyticsEventsName.share_invoice_details, parameters: dictAnalysics as? [String:AnyObject] ?? [String:AnyObject]() )
        
    }
    func webViewDidFinishLoad(_ webView: UIWebView)
    {
        openPDFView()
    }
    
    func openPDFView()
    {
        let render = UIPrintPageRenderer()
        render.addPrintFormatter((self.webView2?.viewPrintFormatter())!, startingAtPageAt: 0)
        let page = CGRect(x: 0, y: 0, width: webView2.frame.width, height: webView2.frame.height)
        render.setValue(NSValue(cgRect:page),forKey:"paperRect")
        render.setValue(NSValue(cgRect:page), forKey: "printableRect")
        let pdfData = NSMutableData()
        UIGraphicsBeginPDFContextToData(pdfData,page, nil)
        
        for i in 1...render.numberOfPages-1
        {
            UIGraphicsBeginPDFPage();
            let bounds = UIGraphicsGetPDFContextBounds()
            render.drawPage(at: i - 1, in: bounds)
        }
        
        UIGraphicsEndPDFContext();
        let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        print_debug(object: documentsDirectory)

        var nameOfFile = String()
        nameOfFile = String(format: "INV_%@.pdf",sendInvoiceNumber )
        
        AppDelegate.sharedInstance.fileUrl = documentsDirectory.appendingPathComponent(nameOfFile) as NSURL;
        
        if !FileManager.default.fileExists(atPath:AppDelegate.sharedInstance.fileUrl.path!) {
        do {
            try pdfData.write(to: AppDelegate.sharedInstance.fileUrl as URL)
            if let document = PDFDocument(url: AppDelegate.sharedInstance.fileUrl as URL) {
                pdfView.document = document
            }
        }
        catch
        {
            debugPrint("error saving file:", error);
        }
        }
        else
        {
            if let document = PDFDocument(url: AppDelegate.sharedInstance.fileUrl as URL) {
                pdfView.document = document
            }
        }
    }
}
