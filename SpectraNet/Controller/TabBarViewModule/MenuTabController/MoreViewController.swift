//
//  MoreViewController.swift
//  SpectraNet
//
//  Created by Yugasalabs-28 on 23/07/2019.
//  Copyright © 2019 Bhoopendra. All rights reserved.
//

import UIKit
import ObjectMapper
import RealmSwift

class MoreViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    // More View Outlets
    
    let kHeaderSectionTag: Int = 6900;
    var expandedSectionHeaderNumber: Int = -1
    var expandedSectionHeader: UITableViewHeaderFooterView!
    var sectionItems: Array<Any> = []
    var sectionNames: Array<Any> = []
    var subSectionImg: Array<Any> = []
    var menuSectionImg: Array<Any> = []


    var realm: Realm? = nil
    var userResult:Results<UserCurrentData>? = nil
    @IBOutlet weak var moreTblView: UITableView!
    var canID = String()
    var packgID = String()
    
    
    //MARK: View controller life cycle
    override func viewDidLoad() {
        super.viewDidLoad()

        realm = try? Realm()
       moreTblView.reloadData()
     
        // Section title Images
        menuSectionImg = ["plan.png","plan.png","MyTransaction.png","rupee","myAcnt.png","dataUsage.png","help","logout"]
        // Section title names
       sectionNames = ["My Plan","Change Plan","My Transactions","Auto Pay","My Account","Data Usage","Get Help","Logout"];
       // Section subItems title names
       sectionItems = [[],[],[],[],[],[],["FAQ","Create SR","Contact Us","Privacy Policy"," Legal Disclaimer"],[]];
       // Section subItems title images
        subSectionImg = [[],[],[],[],[],[],["faq","CreateSR","contact","faq","faq"],[]]
       
        self.moreTblView!.tableFooterView = UIView()
    }
    
    override func viewWillAppear(_ animated: Bool)
    {
        super.viewWillAppear(animated)
              
        userResult = self.realm!.objects(UserCurrentData.self)
        if let userActData = userResult?[0]
        {
            packgID = userActData.Product
            canID = userActData.CANId
        }
        CANetworkManager.sharedInstance.progressHUD(show: false)
    }

    // MARK: - Tableview Methods
      func numberOfSections(in tableView: UITableView) -> Int
      {
          if sectionNames.count > 0 {
              moreTblView.backgroundView = nil
              return sectionNames.count
          } else {
              let messageLabel = UILabel(frame: CGRect(x: 50, y: 0, width: view.bounds.size.width-50, height: view.bounds.size.height))
              messageLabel.text = "Retrieving data.\nPlease wait."
              messageLabel.numberOfLines = 0;
              messageLabel.textAlignment = .center;
              messageLabel.font = UIFont(name: "HelveticaNeue", size: 18.0)!
              messageLabel.sizeToFit()
              self.moreTblView.backgroundView = messageLabel;
          }
          return 0
      }
      
      func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
          if (expandedSectionHeaderNumber == section)
          {
              let arrayOfItems = self.sectionItems[section] as! NSArray
              return arrayOfItems.count;
          } else {
              return 0;
          }
      }
      
      func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String?
      {
          if (self.sectionNames.count != 0)
          {
              return self.sectionNames[section] as? String
          }
          return ""
      }
      
      func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat
      {
          return 80.0;
      }
      
      func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat
      {
          return 0;
      }

      func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int)
      {
//          recast your view as a UITableViewHeaderFooterView
          let header: UITableViewHeaderFooterView = view as! UITableViewHeaderFooterView

          header.contentView.backgroundColor = UIColor.black
          if section==0
          {
              header.contentView.backgroundColor = UIColor.bgColors
          }
          header.textLabel?.textColor = UIColor.white
          header.backgroundView?.backgroundColor = UIColor.white
          header.textLabel?.text = ""

        let headerView = header.viewWithTag(10) ?? UIView.init(frame: CGRect.init(x: 0, y: 0, width: tableView.frame.width, height: 80))
        headerView.tag = 10
        let menuImage = header.viewWithTag(11) as? UIImageView ?? UIImageView(frame: CGRect(x: 15, y: 30, width: 20, height: 20));
        if section==6
        {
            menuImage.frame = CGRect(x: 15, y: 30, width: 15, height: 24)
        }
       
          menuImage.image = UIImage(named: "")
          menuImage.image = UIImage(named: menuSectionImg[section] as! String)
           let templateImage = menuImage.image?.withRenderingMode(.alwaysTemplate)
          menuImage.image = templateImage
          menuImage.tintColor = UIColor.white
          menuImage.tag = 11
        //  header.addSubview(menuImage)

        let menutitleName =  headerView.viewWithTag(12) as? UILabel ?? UILabel()
          menutitleName.text = ""
          
      print("Section Count%@",section)
        if section==7
        {
            menutitleName.frame = CGRect(x: 0, y: 10, width: headerView.frame.width, height: headerView.frame.height-20)
            menutitleName.textAlignment = .center
            menutitleName.backgroundColor = UIColor(red: 23/255, green: 23/255, blue: 23/255, alpha: 1)
            menuImage.frame = CGRect(x: headerView.frame.width/2-80, y: 25, width: 30, height: 30)
        } else {
            menutitleName.frame = CGRect(x: 50, y: 5, width: headerView.frame.width-50, height: headerView.frame.height-10)
            menutitleName.textAlignment = .left
            menutitleName.backgroundColor = UIColor.clear
            menuImage.frame = CGRect(x: 15, y: 30, width: 20, height: 20)
            if section==6
            {
                menuImage.frame = CGRect(x: 15, y: 30, width: 15, height: 24)
            }
        }
          menutitleName.tag = 12
          menutitleName.text = (sectionNames[section] as! String)
          menutitleName.font = UIFont(name: "HelveticaNeue", size: 18.0)
          menutitleName.textColor = UIColor.white
        
          headerView.addSubview(menutitleName)
          header.addSubview(headerView)
          header.addSubview(menuImage)

          let headerFrame = self.view.frame.size
          //self.view.frame.size
        let theImageView = header.viewWithTag(13) as? UIImageView ?? UIImageView(frame: CGRect(x: headerFrame.width - 32, y: 30, width: 10, height: 17));
          theImageView.image = UIImage(named: "frwd")

          if section==6
          {
              theImageView.frame = CGRect(x: headerFrame.width - 40, y: 30, width: 17, height: 10)
              theImageView.image = UIImage(named: "dwnArrow")
          }
          else
          {
            theImageView.frame = CGRect(x: headerFrame.width - 32, y: 30, width: 10, height: 17)
            //theImageView.image = UIImage(named: "dwnArrow")
        }
         if section==7
         {
              theImageView.image = UIImage(named: "")
         }
          theImageView.tag = 13 //kHeaderSectionTag + section
           
          header.addSubview(theImageView)

          // make headers touchable
          header.tag = section
          let headerTapGesture = UITapGestureRecognizer()
          headerTapGesture.addTarget(self, action: #selector(MoreViewController.sectionHeaderWasTouched(_:)))
          header.addGestureRecognizer(headerTapGesture)
      }
      
     func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = moreTblView.dequeueReusableCell(withIdentifier: TableViewCellName.moreTableViewCell, for: indexPath) as! MoreTableViewCell
 
            if cell == nil
            {
                cell = MoreTableViewCell(style: UITableViewCell.CellStyle.default, reuseIdentifier: TableViewCellName.moreTableViewCell)
            }
            let section = self.sectionItems[indexPath.section] as! NSArray
            cell.lblMoreTitleName.text = section[indexPath.row] as? String
            let sectionImg = self.subSectionImg[indexPath.section] as! NSArray
            cell.moreTitleImg.image = UIImage(named: sectionImg[indexPath.row] as! String)
            let templateImage = cell.moreTitleImg.image?.withRenderingMode(.alwaysTemplate)
            cell.moreTitleImg.image = templateImage
            cell.moreTitleImg.tintColor = UIColor.white
          
          return cell
      }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
         if indexPath.row == 0
         {
             navigateScreen(identifier: ViewIdentifier.faqIdentifier, controller: FaqViewController.self)
         }
         else if (indexPath.row==1)
         {
             goCreateSRScreen(fromScreen: "Menu")
         }
         else if (indexPath.row==2)
         {
             navigateScreen(identifier: ViewIdentifier.contactUsIdentifier, controller: ContactUSViewController.self)
         }
         else if (indexPath.row==3)
         {
             privacPolicyView(withLink: WebLinks.privacyPolicy)
         }
         else if (indexPath.row==4)
         {
             privacPolicyView(withLink: WebLinks.disclaimer)
         }
     }
      
      func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath)
      {
        moreTblView.deselectRow(at: indexPath, animated: true)
        }
    
      // MARK: - Expand / Collapse Methods
      @objc func sectionHeaderWasTouched(_ sender: UITapGestureRecognizer) {
          let headerView = sender.view as! UITableViewHeaderFooterView
          let section    = headerView.tag
          let eImageView = headerView.viewWithTag(13) as? UIImageView ?? UIImageView()
         if section == 7
        {
        HelpingClass.saveToUserDefault(value: false as AnyObject, key: "status")
        Switcher.updateRootVC()
          return
        }
        if section != 6 {
            
            let sectionData = self.sectionItems[section] as! NSArray
            
              if (sectionData.count == 0)
              {
                  if section==0
                  {
                        navigateScreen(identifier: ViewIdentifier.planIdentifier, controller: PlanViewController.self)
                  }
                  else if section == 1
                  {
                        chnagePlanScreen(WithCanID: canID, pckgID: packgID,typeOf: "")
                  }
                  else if section == 2
                  {
                        AppDelegate.sharedInstance.navigateFrom=TabViewScreenName.Payment
                        navigateScreen(identifier: ViewIdentifier.customTabIdentifier, controller: CustomTabViewController.self)
                  }
                  else if section == 3
                  {
                        AppDelegate.sharedInstance.siTermCondtionAccept = ""
                        navigateScreen(identifier: ViewIdentifier.StandingInstructionIdentifier, controller: StandingInstractionViewController.self)
                  }
                  else if section == 4
                  {
                        let vc = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: ViewIdentifier.AccountIdentifier) as? AccountViewController
                        vc?.fromScreen = FromScreen.menuScreen
                        self.navigationController?.pushViewController(vc!, animated: false)
                  }
                  else if section == 5
                  {
                    if AppDelegate.sharedInstance.segmentType == segment.userB2C
                     {
                        navigateScreen(identifier: ViewIdentifier.dataUsageIdentifier, controller: DataUsageViewController.self)
                     }
                    else
                     {
                        navigateScreen(identifier: ViewIdentifier.mrtgIdentifier, controller: MRTGViewController.self)
                    }
                  }
                
                  return;
              }
        }
        
          if (expandedSectionHeaderNumber == -1)
          {
              expandedSectionHeaderNumber = section
              tableViewExpandSection(section, imageView: eImageView)
          } else {
              if (expandedSectionHeaderNumber == section) {
                  tableViewCollapeSection(section, imageView: eImageView)
              } else {
                  let cImageView = headerView.viewWithTag(13) as? UIImageView ?? UIImageView()
                  tableViewCollapeSection(expandedSectionHeaderNumber, imageView: cImageView)
                  tableViewExpandSection(section, imageView: eImageView)
              }
          }
      }
      
      func tableViewCollapeSection(_ section: Int, imageView: UIImageView) {
          let sectionData = self.sectionItems[section] as! NSArray
          
          expandedSectionHeaderNumber = -1;
          if (sectionData.count == 0) {
              return;
          } else {
              UIView.animate(withDuration: 0.4, animations: {
                  imageView.transform = CGAffineTransform(rotationAngle: (0.0 * CGFloat(Double.pi)) / 180.0)
              })
              var indexesPath = [IndexPath]()
              for i in 0 ..< sectionData.count {
                  let index = IndexPath(row: i, section: section)
                  indexesPath.append(index)
              }
              moreTblView.beginUpdates()
              moreTblView.deleteRows(at: indexesPath, with: UITableView.RowAnimation.none)
              moreTblView.endUpdates()
              moreTblView.setContentOffset(.zero, animated: true)
          }
      }
      
      func tableViewExpandSection(_ section: Int, imageView: UIImageView)
      {
          let sectionData = self.sectionItems[section] as! NSArray
          
        
          if (sectionData.count == 0)
          {
              expandedSectionHeaderNumber = -1;
              return;
          }
          else
          {
              UIView.animate(withDuration: 0.4, animations: {
                  imageView.transform = CGAffineTransform(rotationAngle: (180.0 * CGFloat(Double.pi)) / 180.0)
              })
              var indexesPath = [IndexPath]()
              for i in 0 ..< sectionData.count {
                  let index = IndexPath(row: i, section: section)
                  indexesPath.append(index)
              }
              expandedSectionHeaderNumber = section
              moreTblView.beginUpdates()
              moreTblView.insertRows(at: indexesPath, with: UITableView.RowAnimation.fade)
              moreTblView.endUpdates()
             moreTblView.scrollToBottom(animated: true)
          }
      }
}
extension UITableView {
    func scrollToBottom(animated: Bool) {
        let y = contentSize.height - frame.size.height
        if y < 0 { return }
        setContentOffset(CGPoint(x: 0, y: y), animated: animated)
    }
}

