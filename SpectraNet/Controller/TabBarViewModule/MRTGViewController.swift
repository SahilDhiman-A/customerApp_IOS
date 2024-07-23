//
//  MRTGViewController.swift
//  SpectraNet
//
//  Created by Yugasalabs-28 on 29/08/2019.
//  Copyright © 2019 Bhoopendra. All rights reserved.
//

import UIKit
import RealmSwift
import ObjectMapper

class MRTGViewController: UIViewController,UIScrollViewDelegate,UITableViewDelegate,UITableViewDataSource {
    var networkClass = CANetworkManager()
    var userCurrentData:Results<UserCurrentData>? = nil
    var MRTGData:Results<MRTGGraphData>? = nil

    let realm = try? Realm()
    @IBOutlet var img: UIImageView!
    @IBOutlet var scrollView: UIScrollView!
    var canID = String()
    @IBOutlet var mrtgIdTble: UITableView!
    @IBOutlet var mrtgIDView: UIView!
    var mrtgRangArr = NSArray()
    var mrtgDateRange = String()
    
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        // get user can id
        mrtgRangArr = ["24 Hours","To day","Yesterday or Last Day","Last 7 Days","This Week","Last Week","Last 30 Days","This Month","Last Month","Last 365 Days","Last 2 Years","This Years"]

        userCurrentData = self.realm!.objects(UserCurrentData.self)
        if let userData = userCurrentData?[0]
        {
            canID = userData.CANId
        }
        mrtgDateRange = "1"
        if ConnectionCheck.isConnectedToNetwork() == true
        {
            self .serviceGetMRTGGbcanId()
        }
        else
        {
            NoInternetCheckScreen()
        }
        
        scrollView.minimumZoomScale = 1.0
        scrollView.maximumZoomScale = 6.0
        mrtgIDView.isHidden = true
        
    }
    
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        
        return img
    }
    @IBAction func backBTN(_ sender: Any) {
        self.navigationController?.popViewController(animated: false)
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    func serviceGetMRTGGbcanId()
    {
        //canID = "9019422"
        let dict = NSMutableDictionary()
        dict .setValue(ActionKeys.getMRTGGbcanID, forKey: "Action")
        dict .setValue(canID, forKey: "canID")//"9019422"
        dict .setValue(mrtgDateRange, forKey: "dateType")
        dict .setValue(UserAuthKEY.authKEY, forKey: "Authkey")
        print(dict)
        networkClass.requestApi(serviceName: ServiceMethods.serviceBaseURL, method: kHTTPMethod.POST, postData: dict as! Dictionary<String, AnyObject>) { (response, error) in
            
            print(response as Any)
            if response != nil
            {
                var dataResponse = NSDictionary()
                var checkStatus = String()
                
                dataResponse = response as! NSDictionary
                checkStatus = dataResponse.value(forKey: "status") as! String
                if checkStatus == "success"
                {
                    let base64String = dataResponse.value(forKey: "response")
                    
                    
//
//                    try! self.realm!.write
//                    {
//                        if let users = self.realm?.objects(MRTGGraphData.self) {
//                            self.realm!.delete(users)
//                        }
//                    }
//
//                   // for entry in arr {
//
//                        if let currentUser = Mapper<MRTGGraphData>().map(JSONObject: base64String) {
//
//                            try! self.realm!.write {
//                                self.realm!.add(currentUser)
//                            }
//                        }
//                  //  }
//
//                    self.MRTGData = self.realm!.objects(MRTGGraphData.self)
//                   print(self.MRTGData?.count)
                    
                    let string: String = base64String as! String
                    if let imageData = Data(base64Encoded: string),
                        let image = UIImage(data: imageData)
                    {
                        self.img.image = image
                    }
                }
                else
                {
                    self.showAlertC(message:dataResponse.value(forKey: "message") as! String)
                }
            }
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return mrtgRangArr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        var cell : MrtgTableViewCell? = (mrtgIdTble.dequeueReusableCell(withIdentifier: TableViewCellName.mrtgIDTableViewCell) as! MrtgTableViewCell)
        
        if cell == nil {
            cell = MrtgTableViewCell(style: UITableViewCell.CellStyle.default, reuseIdentifier: TableViewCellName.mrtgIDTableViewCell)
        }
      
        cell?.lblMRTGId.text = mrtgRangArr[indexPath.row] as? String
        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        mrtgDateRange = String(format: "%d", indexPath.row+1)
        mrtgIDView.isHidden = true
        serviceGetMRTGGbcanId()
    }
    
    @IBAction func hideMrtgViewBTN(_ sender: Any) {
        mrtgIDView.isHidden = true
    }
    @IBAction func mrtgDateRangeBTN(_ sender: Any) {
        mrtgIDView.isHidden = false
    }
    
//    func base64Convert(base64String: String?) -> UIImage{
//        if (base64String?.isEmpty)! {
//            return #imageLiteral(resourceName: "no_image_found")
//        }else {
//            let dataDecoded : Data = Data(base64Encoded: base64String!, options: .ignoreUnknownCharacters)!
//            let decodedimage = UIImage(data: dataDecoded)
//            return decodedimage!
//        }
//    }
}
