//
//  CANetworkManager.swift
//  Giftbomb
//
//Created by Affle on 09/02/16.
//  Copyright © 2016 Affle. All rights reserved.
//

import Foundation
import UIKit
import Alamofire
import SVProgressHUD

extension UIImage {
    enum JPEGQuality: CGFloat {
        case lowest  = 0
        case low     = 0.25
        case medium  = 0.5
        case high    = 0.75
        case highest = 1
    }
    
    /// Returns the data for the specified image in JPEG format.
    /// If the image object’s underlying image data has been purged, calling this function forces that data to be reloaded into memory.
    /// - returns: A data object containing the JPEG data, or nil if there was a problem generating the data. This function may return nil if the image has no data or if the underlying CGImageRef contains data in an unsupported bitmap format.
    func jpeg(_ jpegQuality: JPEGQuality) -> Data? {
        return jpegData(compressionQuality: jpegQuality.rawValue)
    }
}
public enum kHTTPMethod: String {
    case GET, POST, Delete, PUT, Multipart
}

public enum kServiceType: String {
    /*
     main        :   requestApi
     background  :   requestApiWithoutHUD
     multiMedia  :   requestApiWithMultiPart
     none        :   unknown
     */
    case main, background, multiMedia, none
}

public class CANetworkManager {
    
    //MARK:- Shared Instance
    /**
     A shared instance of `Manager`, used by top-level Alamofire request methods, and suitable for use directly
     for any ad hoc requests.
     */
    internal static let sharedInstance: CANetworkManager = {
        return CANetworkManager()
    }()
    
    
    internal func checkInternetConnection() -> Bool {
        return NetworkReachabilityManager()!.isReachable
    }
    
    // MARK: - Properties
    var serviceName:String?
    var method:kHTTPMethod?
    var postData : Dictionary<String, AnyObject>?
    var imageArray: NSArray?
    var videosArray: NSArray?
    var internetRefresh:Int = 0
    //MARK:- Public Method
    /**
     *  Initiates HTTPS or HTTP request over |kHTTPMethod| method and returns call back in success and failure block.
     *
     *  @param serviceName  name of the service
     *  @param method       method type like Get and Post
     *  @param postData     parameters
     *  @param responeBlock call back in block
     */
    internal func requestApi(serviceName: String, method: kHTTPMethod, postData: Dictionary<String, AnyObject>, completionClosure: @escaping (_ result: AnyObject?, _ error: NSError?) -> ()) -> Void 
    {
        if NetworkReachabilityManager()?.isReachable == true {
            internetRefresh = 0
            progressHUD(show: true)
            let headers = getHeaderWithAPIName(serviceName: serviceName)
            let serviceUrl = getServiceUrl(string: serviceName)
            let params  = getPrintableParamsFromJson(postData: postData)
            
            print_debug(object: "\n\tConnecting to Host:\n\t URL : \(serviceUrl) \n\t\tParameters: \(params) , header = \(headers)")
            
            
            
            //NSAssert Statements
            assert(method != .GET || method != .POST, "kHTTPMethod should be one of kHTTPMethodGET|kHTTPMethodPOST|kHTTPMethodPOSTMultiPart.")
            //        Alamofire.Manager.sharedInstance.session.configuration
            //            .HTTPAdditionalHeaders?.updateValue("application/json",
            //                                                forKey: "Accept")
            switch method {
            case .GET:
                
                
                request(serviceUrl, method: .get, parameters: postData, encoding: URLEncoding.default, headers: headers).responseJSON { (response)  -> Void in
                    self.progressHUD(show: false)
                    switch response.result {
                    case .success(let JSON):
                        print_debug(object: "Success with JSON: \(JSON)")
                        
                        
                        
                        // //let response = self.getResponseDataDictionaryFromData(data: response.data!)
                        
                        
                        if response.error == nil {
                            if !self.methodeToLogout(result: response.result.value as AnyObject) {
                                
                                completionClosure(response.result.value as AnyObject?, response.error as NSError?)
                            }
                            
                            
                        } else {
                            self.showErrorMessage(error: response.error! as NSError)
                            completionClosure(nil, response.error as NSError?)
                            
                        }
                    case .failure(let error):
                        print_debug(object: "json error: \(error.localizedDescription)")
                        
                        
                        self.showErrorMessage(error: error as NSError)
                        completionClosure(nil, error as NSError?)
                    }
                }
                
            case .PUT:
                request(serviceUrl, method: .put, parameters: postData, encoding: JSONEncoding.default, headers: headers).responseJSON { (response)  -> Void in
                    self.progressHUD(show: false)
                    switch response.result {
                    case .success(let JSON):
                        print_debug(object: "Success with JSON: \(JSON)")
                        //let response = self.getResponseDataDictionaryFromData(data: response.data!)
                        if response.error == nil {
                            if !self.methodeToLogout(result: response.result.value! as AnyObject)  {
                                completionClosure(response.result.value as AnyObject?, response.error as NSError?)
                            }
                            
                        } else {
                            self.showErrorMessage(error: response.error! as NSError)
                            completionClosure(nil, response.error as NSError?)
                            
                        }
                    case .failure(let error):
                        
                    
                        print_debug(object: "json error: \(error.localizedDescription)")
                        
                        self.showErrorMessage(error: error as NSError)
                        completionClosure(nil, error as NSError?)
                    }
                }
                
                
            case .Delete:
                request(serviceUrl, method: .delete, parameters: postData, encoding: JSONEncoding.default, headers: headers).responseJSON { (response)  -> Void in
                    
                    self.progressHUD(show: false)
                    switch response.result {
                    case .success(let JSON):
                        print_debug(object: "Success with JSON: \(JSON)")
                        //let response = self.getResponseDataDictionaryFromData(data: response.data!)
                        if response.error == nil {
                            if !self.methodeToLogout(result: response.result.value! as AnyObject)  {
                                completionClosure(response.result.value as AnyObject?, response.error as NSError?)
                            }
                            
                        } else {
                            self.showErrorMessage(error: response.error! as NSError)
                            completionClosure(nil, response.error as NSError?)
                            
                        }
                    case .failure(let error):
                        print_debug(object: "json error: \(error.localizedDescription)")
                        
                        self.showErrorMessage(error: error as NSError)
                        completionClosure(nil, error as NSError?)
                    }
                }
                
                
            case .POST:
                request(serviceUrl, method: .post, parameters: postData, encoding: JSONEncoding.default, headers: headers).responseJSON { (response)  -> Void in
                    //////self.printResponseDataForResponse(response)
                    self.progressHUD(show: false)
                    switch response.result {
                    case .success(let JSON):
                        print_debug(object: "Success with JSON before: \(JSON)")
                        //let response = self.getResponseDataDictionaryFromData(data: response.data!)
                        
                        
                        if response.error == nil {
                            if !self.methodeToLogout(result: response.result.value! as AnyObject)  {
                                completionClosure(response.result.value as AnyObject?, response.error as NSError?)
                            }
                            
                            
                        } else {
                            self.showErrorMessage(error: response.error! as NSError)
                            completionClosure(nil, response.error as NSError?)
                            
                        }
                        
                        
                    case .failure(let error):
                        print_debug(object: "json error: \(error.localizedDescription)")
                        
                        
                        // if error.localizedDescription.
                        
                        self.showErrorMessage(error: error as NSError)
                        completionClosure(nil, error as NSError?)
                    }
                }
            default:
                break
            }
        } else {
            progressHUD(show: false)
            internetRefresh += 1
            showNoInternetAlert(serviceType: .main, serviceName: serviceName, method: method, postData: postData, completionClosure: completionClosure)
           completionClosure(nil, NSError(domain: "No Internet", code: 20, userInfo: nil))
        }
    }
    
    internal func requestApiWithoutHUD(serviceName: String, method: kHTTPMethod, postData: Dictionary<String, AnyObject>, completionClosure: @escaping (_ result: AnyObject?, _ error: NSError?) -> ()) -> Void
    {
        if NetworkReachabilityManager()?.isReachable == true
        {
            internetRefresh = 0
            let headers = getHeaderWithAPIName(serviceName: serviceName)
            let serviceUrl = getServiceUrl(string: serviceName)
            let params  = getPrintableParamsFromJson(postData: postData)
            
            print_debug(object: "\n\tConnecting to Host:\n\t URL : \(serviceUrl) \n\t\tParameters: \(params) , header = \(headers)")
            
            
            
            //NSAssert Statements
            assert(method != .GET || method != .POST, "kHTTPMethod should be one of kHTTPMethodGET|kHTTPMethodPOST|kHTTPMethodPOSTMultiPart.")
            //        Alamofire.Manager.sharedInstance.session.configuration
            //            .HTTPAdditionalHeaders?.updateValue("application/json",
            //                                                forKey: "Accept")
            switch method {
            case .GET:
                
                
                request(serviceUrl, method: .get, parameters: postData, encoding: URLEncoding.default, headers: headers).responseJSON { (response)  -> Void in
                    
                    switch response.result {
                    case .success(let JSON):
                        print_debug(object: "Success with JSON: \(JSON)")
                        
                        
                        
                        // //let response = self.getResponseDataDictionaryFromData(data: response.data!)
                        
                        
                        if response.error == nil {
                            if !self.methodeToLogout(result: response.result.value as AnyObject) {
                                
                                completionClosure(response.result.value as AnyObject?, response.error as NSError?)
                            }
                            
                            
                        } else {
                            self.showErrorMessage(error: response.error! as NSError)
                            completionClosure(nil, response.error as NSError?)
                            
                        }
                    case .failure(let error):
                        print_debug(object: "json error: \(error.localizedDescription)")
                        
                        
                        self.showErrorMessage(error: error as NSError)
                        completionClosure(nil, error as NSError?)
                    }
                }
                
            case .PUT:
                request(serviceUrl, method: .put, parameters: postData, encoding: JSONEncoding.default, headers: headers).responseJSON { (response)  -> Void in
                    switch response.result {
                    case .success(let JSON):
                        print_debug(object: "Success with JSON: \(JSON)")
                        //let response = self.getResponseDataDictionaryFromData(data: response.data!)
                        if response.error == nil {
                            if !self.methodeToLogout(result: response.result.value! as AnyObject)  {
                                completionClosure(response.result.value as AnyObject?, response.error as NSError?)
                            }
                            
                        } else {
                            self.showErrorMessage(error: response.error! as NSError)
                            completionClosure(nil, response.error as NSError?)
                            
                        }
                    case .failure(let error):
                        print_debug(object: "json error: \(error.localizedDescription)")
                        
                        self.showErrorMessage(error: error as NSError)
                        completionClosure(nil, error as NSError?)
                    }
                }
                
                
            case .Delete:
                request(serviceUrl, method: .delete, parameters: postData, encoding: JSONEncoding.default, headers: headers).responseJSON { (response)  -> Void in
                    
                    switch response.result {
                    case .success(let JSON):
                        print_debug(object: "Success with JSON: \(JSON)")
                        //let response = self.getResponseDataDictionaryFromData(data: response.data!)
                        if response.error == nil {
                            if !self.methodeToLogout(result: response.result.value! as AnyObject)  {
                                completionClosure(response.result.value as AnyObject?, response.error as NSError?)
                            }
                            
                        } else {
                            self.showErrorMessage(error: response.error! as NSError)
                            completionClosure(nil, response.error as NSError?)
                            
                        }
                    case .failure(let error):
                        print_debug(object: "json error: \(error.localizedDescription)")
                        
                        self.showErrorMessage(error: error as NSError)
                        completionClosure(nil, error as NSError?)
                    }
                }
                
                
                
            case .POST:
                request(serviceUrl, method: .post, parameters: postData, encoding: JSONEncoding.default, headers: headers).responseJSON { (response)  -> Void in
                    //////self.printResponseDataForResponse(response)
                    switch response.result {
                    case .success(let JSON):
                        print_debug(object: "Success with JSON before: \(JSON)")
                        //let response = self.getResponseDataDictionaryFromData(data: response.data!)
                        
                        
                        if response.error == nil {
                            if !self.methodeToLogout(result: response.result.value! as AnyObject)  {
                                completionClosure(response.result.value as AnyObject?, response.error as NSError?)
                            }
                            
                            
                        } else {
                            self.showErrorMessage(error: response.error! as NSError)
                            completionClosure(nil, response.error as NSError?)
                            
                        }
                        
                        
                    case .failure(let error):
                        print_debug(object: "json error: \(error.localizedDescription)")
                        
                        
                        // if error.localizedDescription.
                        
                        self.showErrorMessage(error: error as NSError)
                        completionClosure(nil, error as NSError?)
                    }
                }
            default:
                break
            }
        } else {
            
            internetRefresh += 1
            showNoInternetAlert(serviceType: .background, serviceName: serviceName, method: method, postData: postData, completionClosure: completionClosure)
             completionClosure(nil, NSError(domain: "No Internet", code: 20, userInfo: nil))
        }
    }
    /**
     *  Upload multiple images and videos via multipart
     *
     *  @param serviceName  name of the service
     *  @param imagesArray  array having images in NSData form
     *  @param videosArray  array having videos file path
     *  @param postData     parameters
     *  @param responeBlock call back in block
     */
    
    
    internal func requestApiWithMultiPart(serviceName: String ,method: kHTTPMethod, imageArray: NSArray, videosArray: NSArray, postData: Dictionary<String, AnyObject>, completionClosure: @escaping (_ result: AnyObject?, _ error: NSError?) -> ()) -> Void {
        
        if NetworkReachabilityManager()?.isReachable == true {
            internetRefresh = 0
            progressHUD(show: true)
             print_debug(object: "postData = \(postData)")
            
            let serviceUrl = getServiceUrl(string: serviceName)
            
            let headers = getHeaderWithAPIName(serviceName: serviceName)
            
            var type:HTTPMethod = .post
             switch method {
                
             case .POST:
                type = .post
                break
                
             case .PUT:
                type = .put
                break
             default:
                break
            }
            
            upload(multipartFormData: { (multipartFormData) in
                
                for i: Int in 0 ..< imageArray.count {
                    let imageName = "profileImg"
                    let fileName = "profileImg"
                    let image: UIImage = imageArray.object(at: i) as! UIImage
                    
                    
                    if let imageData = image.jpeg(.lowest)   {
                        
                        multipartFormData.append(imageData, withName: imageName, fileName: fileName, mimeType: "image/jpeg")
                    }
 
                }
                  for i: Int in 0 ..< videosArray.count {
                    var movieData:Data? 
                    do{
                        // movieData =  try Data.init(contentsOf: self.filePathArray[index] as! URL, options: .alwaysMapped)
                        
                        movieData = try Data.init(contentsOf: videosArray[i] as! URL)
                        
                        
                    }catch{
                        
                    }
                       multipartFormData.append(movieData!, withName: "binaryContent", fileName: "file.mp4", mimeType: "video/mp4")
                }
                for (key, value) in postData {
                    
                    print_debug(object: "multipartFormData = \(multipartFormData)")
                     print_debug(object: "value =\(value)")
                    print_debug(object: "key =\(key)")
                    
                
                    if value is String{
                        
                        print_debug(object: "(value as! String).data(using: .utf8)! = \((value as! String).data(using: .utf8)!)")
                    multipartFormData.append((value as! String).data(using: .utf8)!, withName: key)
                    }
                    else {
                        
                        do {
                            let jsonData = try JSONSerialization.data(withJSONObject: value, options:  .prettyPrinted)
                            let theJSONText = String(data: jsonData,
                                                     encoding: .ascii)
                             print_debug(object:"JSON string = \(theJSONText!)")
                          multipartFormData.append(jsonData, withName: key)
                            
                        } catch {
                             print_debug(object:error.localizedDescription)
                        }
                        //
                    }
                    }
                
                
            }, usingThreshold: UInt64.init(), to: serviceUrl, method: type, headers: headers) { (encodingResult) in
                switch encodingResult {
                case .success(let upload, _, _):
                    upload.responseJSON(completionHandler: {  response in
                        self.progressHUD(show: false)
                        print_debug(object: "success \(String(describing: response.result.value))")
                        completionClosure(response.result.value as AnyObject?, response.error as NSError?)
                    })
                case .failure(let encodingError):
                    self.progressHUD(show: false)
                    completionClosure(nil, encodingError as NSError?)
                }
            }
        } else {
            internetRefresh += 1
            self.videosArray = videosArray
            self.imageArray = imageArray
            showNoInternetAlert(serviceType: .multiMedia, serviceName: serviceName, method: .Multipart, postData: postData, completionClosure: completionClosure)
            completionClosure(nil, NSError(domain: "No Internet", code: 20, userInfo: nil))
        }
    }
    
    
    
    
    internal func requestApiWithMultiPartMultiMedia(serviceName: String ,method: kHTTPMethod, imageArray: NSArray, videosArray: NSArray, postData: Dictionary<String, AnyObject>, completionClosure: @escaping (_ result: AnyObject?, _ error: NSError?) -> ()) -> Void {
        
        if NetworkReachabilityManager()?.isReachable == true {
            progressHUD(show: true)
            internetRefresh = 0
            print_debug(object: "postData = \(postData)")
            
            let serviceUrl = getServiceUrl(string: serviceName)
            
            let headers = getHeaderWithAPIName(serviceName: serviceName)
            
            var type:HTTPMethod = .post
            switch method {
                
            case .POST:
                type = .post
                break
                
            case .PUT:
                type = .put
                break
            default:
                break
            }
            
            upload(multipartFormData: { (multipartFormData) in
                
                for i: Int in 0 ..< imageArray.count {
                    let imageName = "multimedia"
                    let fileName = "multimedia"
                    let image: UIImage = imageArray.object(at: i) as! UIImage
                    
                    if let imageData = image.pngData(){
                        
                        multipartFormData.append(imageData, withName: imageName, fileName: fileName, mimeType: "image/jpeg")
                        
                    }
                }
                for i: Int in 0 ..< videosArray.count {
                    var movieData:Data?
                    do{
                        // movieData =  try Data.init(contentsOf: self.filePathArray[index] as! URL, options: .alwaysMapped)
                        
                        movieData = try Data.init(contentsOf: videosArray[i] as! URL)
                        
                        
                    }catch{
                        
                    }
                    multipartFormData.append(movieData!, withName: "multimedia", fileName: "file.mp4", mimeType: "video/mp4")
                }
                for (key, value) in postData {
                    
                    print_debug(object: "multipartFormData = \(multipartFormData)")
                    print_debug(object: "value =\(value)")
                    print_debug(object: "key =\(key)")
                    
                    
                    if value is String{
                        
                        print_debug(object: "(value as! String).data(using: .utf8)! = \((value as! String).data(using: .utf8)!)")
                        multipartFormData.append((value as! String).data(using: .utf8)!, withName: key)
                    }
                    else {
                        
                        do {
                            let jsonData = try JSONSerialization.data(withJSONObject: value, options:  .prettyPrinted)
                            let theJSONText = String(data: jsonData,
                                                     encoding: .ascii)
                            print_debug(object:"JSON string = \(theJSONText!)")
                            multipartFormData.append(jsonData, withName: key)
                            
                        } catch {
                             print_debug(object:error.localizedDescription)
                        }
                        //
                    }
                }
                
                
            }, usingThreshold: UInt64.init(), to: serviceUrl, method: type, headers: headers) { (encodingResult) in
                switch encodingResult {
                case .success(let upload, _, _):
                    upload.responseJSON(completionHandler: {  response in
                        self.progressHUD(show: false)
                        print_debug(object: "success \(String(describing: response.result.value))")
                        completionClosure(response.result.value as AnyObject?, response.error as NSError?)
                    })
                case .failure(let encodingError):
                    self.progressHUD(show: false)
                    completionClosure(nil, encodingError as NSError?)
                }
            }
        } else {
            internetRefresh += 1
            self.videosArray = videosArray
            self.imageArray = imageArray
            showNoInternetAlert(serviceType: .multiMedia, serviceName: serviceName, method: .Multipart, postData: postData, completionClosure: completionClosure)
             completionClosure(nil, NSError(domain: "No Internet", code: 20, userInfo: nil))
        }
    }
    

    //MARK:- Alert
    func showNoInternetAlert(serviceType: kServiceType, serviceName: String, method: kHTTPMethod, postData: Dictionary<String, AnyObject>, completionClosure: @escaping (_ result: AnyObject?, _ error: NSError?) -> ())  {
        
      //  HelpingClass.sharedInstance.displayAlert(title: AlertViewTitle.title_Error, message: AlertViewMessage.internetConnection , buttonTitles: [AlertViewButtonTitle.Cancel],viewControler:UIApplication.topViewController()!)
        
    }
    
     internal   func downloadImagewithUrl(urlName: String, downloadClosure: @escaping (_ result: UIImage?, _ error: NSError?) -> ()) -> Void {
     
        Alamofire.request(urlName).responseData { response in
            debugPrint(response)
            
            if let image = response.result.value as? UIImage {
               downloadClosure(image, nil)
            }
        }
    }
    
    func showErrorMessage(error: NSError) {
       //   HelpingClass.sharedInstance.displayAlert(title: AlertViewTitle.title_Error, message: AlertViewMessage.pleaseTryAgain , buttonTitles: [AlertViewButtonTitle.Cancel],viewControler:UIApplication.topViewController()!)
        
        //        AppHelper.showALertWithTag(677, title: ConstantValues.App_Name.rawValue, message:error.localizedDescription, delegate: nil, cancelButtonTitle: nil, otherButtonTitle: AlerViewButtonText.val_OK.rawValue)
    }
    
    
    /*
     if let value = result[ServiceMethods.service_responseStatus.rawValue] as? Int {
     if ( value == ResponseStatus.responseStatusfail.rawValue) {
     if let array = result[ServiceMethods.service_errorList.rawValue]  as? [[String: AnyObject]] {
     if array.count > 0 {
     if  array[0]["errorCode"] as? String == "402"{
     
     AppHelper.sharedInstance.logoutFromApp()
     return true
     
     }
     
     
     
     }
     
     else
     {
     
     if let value = result[ServiceMethods.service_responseCode.rawValue] as? String{
     
     if value == ResponseCode.somthingWrong.rawValue
     {
     
     AppHelper.sharedInstance.showSomeThingWrongMessage()
     
     return true
     
     }
     }
     
     
     }
     }
     
     
     
     
     }
     
     return false
     }
     return false
     */
    
    //MARK:- Progress HUD
    func progressHUD(show: Bool) {
        if show {

           // SVProgressHUD.setDefaultStyle(.light)
            SVProgressHUD.setRingThickness(5)
          //  SVProgressHUD.setRingNoTextRadius(20)
            SVProgressHUD.setDefaultStyle(.light)
            SVProgressHUD.setForegroundColor(UIColor.viewBackgroundFullOpack)
           // SVProgressHUD.setBackgroundColor(UIColor.white.withAlphaComponent(0.9))
            SVProgressHUD.setBackgroundColor(UIColor.clear)
            SVProgressHUD.setDefaultMaskType(.black)
            SVProgressHUD.show()
        } else {
            SVProgressHUD.dismiss()
        }
    }
    
    //MARK:- Internal helper Methods
    private func getHeaderWithAPIName(serviceName: String) -> [String: String] {
        
        var headers = [ "Accept": "application/json", "Content-Type": "application/json"]
    
//        if let value = HelpingClass.sharedInstance.userDefaultForKey(key: UserDefaultKeys.accessToken) {
//         headers["Authorization"] = value as? String
//            // headers["Authorization"] = "Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VyX2lkIjoiNWMzZjE2ZTExYjExODI2NzA0ZDc2NDhlIiwiaWF0IjoxNTQ3NjM4NDk3fQ.z19MiNp3hqoQpoq8ageAFnhnDQyz9kY2LYlqdop5xks"
//       }
 
        
        return headers
    }
    
    
    private func getServiceUrl(string: String) -> String {
        
        let urlString =  string.addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlQueryAllowed)!
        if string.range(of:"http") != nil {
            return urlString
        } else if string.range(of:"https") != nil{
            return urlString
            
        } else {
            return ServiceMethods.serviceBaseURL + urlString
        }
    }
    
    private func getPrintableParamsFromJson(postData: Dictionary<String, AnyObject>) -> String {
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: postData, options:JSONSerialization.WritingOptions.prettyPrinted)
            let theJSONText = String(data:jsonData, encoding:String.Encoding.ascii)
            return theJSONText ?? ""
        } catch let error as NSError {
            print_debug(object: error)
            return ""
        }
    }
    
    func methodeToLogout(result: AnyObject) -> Bool {
        
        if let values:Double = result[ServiceKeys.status] as? Double {
      
            if(values  == 403){
              //  HelpingClass.sharedInstance.logoutFuctionality()

                    return true
                }
        }
        
        return false
        
    }
    
    
    
}
