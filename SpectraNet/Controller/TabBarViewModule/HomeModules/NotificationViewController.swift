//
//  NotificationViewController.swift
//  SpectraNet
//
//  Created by Bhoopendra on 8/5/19.
//  Copyright © 2019 Bhoopendra. All rights reserved.
//

import UIKit

class NotificationViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
   
    
    @IBOutlet weak var notifiTblView: UITableView!
    var names = ["Today": ["Due outstanding amount", "Launching new package"], "Yesterday": ["Hi from Spectra", "Due outstanding amount", "Lettuce"], "3 August 2019": ["Hi from Spectra", "Due outstanding amount", "Lettuce"]]
   
    struct Objects {
        
        var sectionName : String!
        var sectionObjects : [String]!
    }
    var objectArray = [Objects]()

    //MARK: View controller life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        for (key, value) in names {
            print("\(key) -> \(value)")
            objectArray.append(Objects(sectionName: key, sectionObjects: value))
        }
        print_debug(object: objectArray)
    }
    
    // MARK: - Table view data source
    func numberOfSections(in tableView: UITableView) -> Int {
        return objectArray.count
    }
    
     func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return objectArray[section].sectionObjects.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        var cell : NotificationTableViewCell? = (notifiTblView.dequeueReusableCell(withIdentifier: TableViewCellName.notificationTableViewCell) as! NotificationTableViewCell)
        
        if cell == nil {
            cell = NotificationTableViewCell(style: UITableViewCell.CellStyle.default, reuseIdentifier: TableViewCellName.notificationTableViewCell)
        }
        // Configure the cell...
     //   cell.textLabel?.text = objectArray[indexPath.section].sectionObjects[indexPath.row]
        if ((objectArray[indexPath.section].sectionName) == "Today")
        {
            cell?.viewContainer.backgroundColor = UIColor.bgColors
            cell?.titleName.textColor = UIColor.white
            cell?.dicrption.textColor = UIColor.white
        }
        else
        {
            cell?.viewContainer.backgroundColor = UIColor.white
            cell?.titleName.textColor = UIColor.black
            cell?.dicrption.textColor = UIColor.black
        }
        
        return cell!
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        print_debug(object: objectArray[indexPath.section].sectionObjects[indexPath.row])
    }
    
     func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
       
        
        return objectArray[section].sectionName
    }
    
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int){
        view.tintColor = UIColor.clear
        let header = view as! UITableViewHeaderFooterView
        header.textLabel?.textColor = UIColor.white
    }
  
    @IBAction func backBTN(_ sender: Any) {
        self.navigationController?.popViewController(animated: false)
    }
}
