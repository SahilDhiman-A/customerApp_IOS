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
    var userCurrentData:Results<UserCurrentData>? = nil
    var MRTGData:Results<MRTGGraphData>? = nil

    var realm: Realm? = nil
    @IBOutlet weak var img: UIImageView!
    @IBOutlet weak var scrollView: UIScrollView!
    var canID = String()
    @IBOutlet weak var mrtgIdTble: UITableView!
    @IBOutlet weak var mrtgIDView: UIView!
    var mrtgRangArr = NSArray()
    var mrtgDateRange = String()
    @IBOutlet weak var selectGraphView: UIView!
    @IBOutlet weak var seletedDropDownImg: UIImageView!
    @IBOutlet weak var lblCurrentGraphName: UILabel!
   
    //MARK: View controller life cycle
    override func viewDidLoad()
    {
        super.viewDidLoad()
        realm = try? Realm()
        // get user can id
        lblCurrentGraphName.text = "24 Hours"
        mrtgRangArr = ["24 Hours","Today","Yesterday or Last Day","Last 7 Days","This Week","Last Week","Last 30 Days","This Month","Last Month","Last 365 Days","Last 2 Years","This Years"]

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
            noInternetCheckScreenWithMessage(errorMessage:"")
        }
        
        scrollView.minimumZoomScale = 1.0
        scrollView.maximumZoomScale = 6.0
        mrtgIDView.isHidden = true
        
    }
   
    //MARK: Zooming Image
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        
        return img
    }
    
   //MARK: Service Get MRTG
    func serviceGetMRTGGbcanId()
    {
        let dict = ["Action":ActionKeys.getMRTGGbcanID, "Authkey":UserAuthKEY.authKEY,"dateType":mrtgDateRange, "canID":canID]
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
                    let base64String = dataResponse.value(forKey: "response")
                    
                    guard let base64 = base64String as? String else
                    {
                        return
                    }
                    let string: String = base64
                    if let imageData = Data(base64Encoded: string),
                        let image = UIImage(data: imageData)
                    {
                        self.img.image = image
                    }
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
    
    //MARK: Table View delegate
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
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
        lblCurrentGraphName.text = mrtgRangArr[indexPath.row] as? String
        mrtgIDView.isHidden = true
        serviceGetMRTGGbcanId()
    }
    
    //MARK: Button Actions
    @IBAction func hideMrtgViewBTN(_ sender: Any)
    {
        mrtgIDView.isHidden = true
    }
   
    @IBAction func dropDownBTN(_ sender: Any)
    {
        mrtgIDView.isHidden = false
    }
    
    @IBAction func backBTN(_ sender: Any)
    {
        self.navigationController?.popViewController(animated: false)
    }
       
}
