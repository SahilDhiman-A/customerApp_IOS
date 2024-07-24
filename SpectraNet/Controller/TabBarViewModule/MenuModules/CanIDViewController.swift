//
//  CanIDViewController.swift
//  SpectraNet
//
//  Created by Bhoopendra on 8/8/19.
//  Copyright © 2019 Bhoopendra. All rights reserved.
//

import UIKit
import ObjectMapper
import RealmSwift

class CanIDViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {

    var realm:Realm? = nil
    var userResult:Results<UserData>? = nil
    var userCurrentData:Results<UserCurrentData>? = nil
    @IBOutlet weak var tblView: UITableView!
 
    //MARK: View controller life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        realm = try? Realm()
        userResult = self.realm!.objects(UserData.self)
    }
    
    //MARK: TableView delegate
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return userResult?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        var cell : CanIDTableViewCell? = (tblView.dequeueReusableCell(withIdentifier: TableViewCellName.canIDTableViewCell) as! CanIDTableViewCell)
        
        if cell == nil {
            cell = CanIDTableViewCell(style: UITableViewCell.CellStyle.default, reuseIdentifier: TableViewCellName.canIDTableViewCell)
        }
        
         cell?.lblAcount.text = String(format: "Account %d", indexPath.row+1)

        if indexPath.row==0 {
          
        }
        else
        {
            cell?.lblAcount.textColor = UIColor.bgHalfOpackWithWhite
            cell?.lblUserCanID.textColor = UIColor.viewBackgroundHalfOpack
        }
        
        if let userData = userResult?[indexPath.row]
        {
            cell?.lblUserCanID.text = String(format: "CAN ID - %@", userData.CANId)
        }
        
        
        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        self.userResult = self.realm!.objects(UserData.self)

        try! self.realm!.write
         {
            if let users = self.realm?.objects(UserCurrentData.self) {
            self.realm!.delete(users)
          }
        }

        let userData: UserCurrentData = userResult![indexPath.row].convertToUserCurrentData()
        try! self.realm!.write
        {
            self.realm!.add(userData)
        }
      self.userCurrentData = self.realm!.objects(UserCurrentData.self)
        
        if userData.CancellationFlag == true
        {
            self.navigateScreen(identifier: ViewIdentifier.cancelledAccountIdentifier, controller: AccountCancelledViewController.self)
        }
       else if userData.actInProgressFlag == true
        {
            self.navigateScreen(identifier: ViewIdentifier.accountActivationIdentifier, controller: AccountActivationViewController.self)
        }
        else
        {
            AppDelegate.sharedInstance.navigateFrom=""
            navigateScreen(identifier: ViewIdentifier.customTabIdentifier, controller: CustomTabViewController.self)
        }
    }
    
    //MARK: Button Action
    @IBAction func backBTN(_ sender: Any)
    {
        self.navigationController?.popViewController(animated: false)
    }

}
