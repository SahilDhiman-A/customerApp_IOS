//
//  ManageAccountViewController.swift
//  My Spectra
//
//  Created by Bhoopendra on 11/4/19.
//  Copyright © 2019 Bhoopendra. All rights reserved.
//

import UIKit
import ObjectMapper
import RealmSwift

class ManageContactsCell: UITableViewCell
{
    @IBOutlet weak var lblFirstName: UILabel!
    @IBOutlet weak var lblLastName: UILabel!
    @IBOutlet weak var lblEmailAdd: UILabel!
    @IBOutlet weak var lblDesignation: UILabel!
    @IBOutlet weak var lblMobileNmbr: UILabel!
    @IBOutlet weak var editContactBTN: UIButton!
    @IBOutlet weak var editContactView: UIView!
    @IBOutlet weak var marginFirstName: NSLayoutConstraint!
    @IBOutlet weak var marginLastName: NSLayoutConstraint!
}

class EditContactsCell: UITableViewCell
{
    @IBOutlet weak var firstNameTF: JVFloatLabeledTextField!
    @IBOutlet weak var lastNameTF: JVFloatLabeledTextField!
    @IBOutlet weak var emailIDTF: JVFloatLabeledTextField!
    @IBOutlet weak var designationTF: JVFloatLabeledTextField!
    @IBOutlet weak var mobileNmbrTF: JVFloatLabeledTextField!
    @IBOutlet weak var cancelBTN: UIButton!
    @IBOutlet weak var savedContactView: UIView!
    @IBOutlet weak var savedContactBTN: UIButton!
    @IBOutlet weak var lblContactTitle: UILabel!

}

class ManageContactsViewController: UIViewController,UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate
{
    var realm:Realm? = nil
    var userContacts:Results<GetContactDetailsData>? = nil
    var userToEdit: GetContactDetailsData? = nil
    
    @IBOutlet weak var contactTableView: UITableView!
    @IBOutlet weak var editTableView: UITableView!
    @IBOutlet weak var transPrntView: UIView!
    @IBOutlet weak var addNewBTN: UIButton!
    @IBOutlet weak var emptyDataView: UIView!
    @IBOutlet weak var addEmptyCaseView: UIView!
    
    var ifContactsEdit: Bool = false
    var isComeFromEmpty: Bool = false

    var canID = String()
    var userContactID = String()

    override func viewDidLoad() {
        super.viewDidLoad()
        realm = try? Realm()
       
        getContactDetails()
        emptyDataView.isHidden = true
        transPrntView.isHidden = true
        editTableView.isHidden = true
        addNewBTN.isHidden = true
        
        setCornerRadiusView(radius: Float((addEmptyCaseView.frame.height)/2), color: UIColor.cornerBGFullOpack, view: addEmptyCaseView)
       contactTableView.rowHeight = UITableView.automaticDimension

        // Do any additional setup after loading the view.
    }
    
    //MARK: TableView delegate
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        if tableView==contactTableView
        {
            return userContacts?.count ?? 0
        }
       else if tableView==editTableView
        {
           return 1
         }
       return userContacts?.count ?? 0
    }
        
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        if (tableView==contactTableView)
        {
            var cell : ManageContactsCell? = (tableView.dequeueReusableCell(withIdentifier: TableViewCellName.manageContactCell) as! ManageContactsCell)
            if cell == nil
            {
                cell = ManageContactsCell(style: UITableViewCell.CellStyle.default, reuseIdentifier: TableViewCellName.manageContactCell)
            }
            cell?.editContactBTN.addTarget(self, action: #selector(editContactsButton), for: .touchUpInside)
            setCornerRadiusView(radius: Float((cell?.editContactView.frame.height)!/2), color: UIColor.cornerBGFullOpack, view: cell!.editContactView)
           
            if let changePlanData = userContacts?[indexPath.row]
            {
               cell?.lblFirstName.text = changePlanData.firstName
               cell?.lblLastName.text = changePlanData.lastName
               cell?.lblEmailAdd.text = changePlanData.email
               cell?.lblDesignation.text = changePlanData.jobTitle
               cell?.lblMobileNmbr.text = changePlanData.mobilePhone
//                if (changePlanData.firstName.count > changePlanData.lastName.count ) {
//                    cell?.marginFirstName.priority = UILayoutPriority.required
//                    cell?.marginLastName.priority = UILayoutPriority.fittingSizeLevel
//                } else {
//                    cell?.marginFirstName.priority = UILayoutPriority.fittingSizeLevel
//                    cell?.marginLastName.priority = UILayoutPriority.required
//                }
            }
           
            return cell!
        }
       else if (tableView==editTableView)
       {
            var cell : EditContactsCell? = (tableView.dequeueReusableCell(withIdentifier: TableViewCellName.editContactCell) as! EditContactsCell)
            if cell == nil
            {
                cell = EditContactsCell(style: UITableViewCell.CellStyle.default, reuseIdentifier: TableViewCellName.editContactCell)
            }
            cell?.savedContactBTN.addTarget(self, action: #selector(savedContactButton), for: .touchUpInside)
            cell?.cancelBTN.addTarget(self, action: #selector(cancelContactButton), for: .touchUpInside)
            setCornerRadiusView(radius: Float((cell?.savedContactView.frame.height)!/2), color: UIColor.cornerBGFullOpack, view: cell!.savedContactView)

            if ifContactsEdit == true
            {
                if let changePlanData = userToEdit
                {
                    cell?.firstNameTF.text = changePlanData.firstName
                    cell?.lastNameTF.text = changePlanData.lastName
                    cell?.emailIDTF.text = changePlanData.email
                    cell?.designationTF.text = changePlanData.jobTitle
                    cell?.mobileNmbrTF.text = changePlanData.mobilePhone
                    cell?.lblContactTitle.text = contactManage.editContact
                }
            }
            else
            {
                cell?.firstNameTF.text = ""
                cell?.lastNameTF.text = ""
                cell?.emailIDTF.text = ""
                cell?.designationTF.text = ""
                cell?.mobileNmbrTF.text = ""
                cell?.lblContactTitle.text = contactManage.addNewContact
            }
                
            return cell!
        }
        return UITableViewCell()
    }
//    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
//    {
//
//        return UITableView.automaticDimension
//    }
//
    
    
    //MARK: Button Actions
    @objc func editContactsButton(sender: UIButton!)
    {
        let buttonPosition = sender.convert(CGPoint.zero, to: contactTableView)
        let indexPath = contactTableView.indexPathForRow(at:buttonPosition)
        guard let row = indexPath?.row else { return }
        userToEdit = userContacts?[row]
        
       if let userSelected = userToEdit
       {
            userContactID = userSelected.contactId
        }
        ifContactsEdit = true
        transPrntView.isHidden = false
        editTableView.isHidden = false
        editTableView.delegate = self
        editTableView.dataSource = self
        editTableView.reloadData()
      
    }
    
    
    @IBAction func addNewContactBTN(_ sender: Any)
    {
        if (sender as AnyObject).tag == 101 {
            isComeFromEmpty = true
        }
        else
        {
            isComeFromEmpty = false
        }
        
        ifContactsEdit = false
        emptyDataView.isHidden = true
        transPrntView.isHidden = false
        editTableView.isHidden = false
        editTableView.delegate = self
        editTableView.dataSource = self
        editTableView.reloadData()
    }
    
    //MARK: Button Actions
    @objc func cancelContactButton(sender: UIButton!)
    {
        view.endEditing(true)
        transPrntView.isHidden = true
        editTableView.isHidden = true
        if isComeFromEmpty == true
        {
            emptyDataView.isHidden = false
        }
    }
    
    @IBAction func bckBTN(_ sender: Any)
    {
        self.navigationController?.popViewController(animated: false)
    }
    
    
    //MARK: Button Actions
    @objc func savedContactButton(sender: UIButton!)
    {
        view.endEditing(true)
        if let cell = editTableView.cellForRow(at: IndexPath(row: 0, section:0)) as? EditContactsCell {
            let firstName = trimmedWhiteSpace(string: cell.firstNameTF.text ?? "")
            let lastName = trimmedWhiteSpace(string: cell.lastNameTF.text ?? "")
            let jobTitle = trimmedWhiteSpace(string: cell.designationTF.text ?? "")
            let email = trimmedWhiteSpace(string: cell.emailIDTF.text ?? "")
            let mobile = cell.mobileNmbrTF.text ?? ""

            if firstName == "" {
                showAlertC(message: contactManage.enterName)
            }
            else if lastName == ""
            {
                showAlertC(message: contactManage.enterLastName)
            }
            else if email == ""
            {
                showAlertC(message: contactManage.enterEmail)
            }
            else if jobTitle == ""
            {
                showAlertC(message: contactManage.enterjobTitle)
            }
            else if mobile == ""
            {
                showAlertC(message: contactManage.enterMobile)
            }
            else
            {
                if email.isValidEmail(emailStr: email) == false
                {
                   showAlertC(message: contactManage.enterValidEmail)
                }
                
               else if mobile.isValidMobileNo == false
                {
                    showAlertC(message: contactManage.enterValidMobile)
                }
                else
                {
                    if ifContactsEdit == true
                    {
                        updateContactDetails(firstName: firstName, lastName: lastName, jobTitle: jobTitle, email: email, mobile: mobile,contactID: userContactID)
                    }
                    else
                    {
                        addNewContactDetails(firstName: firstName, lastName: lastName, jobTitle: jobTitle, email: email, mobile: mobile)
                    }
                }
            }
        }
    }
    

    
    func addNewContactDetails(firstName: String,lastName: String, jobTitle: String, email: String, mobile: String)
     {
         let dict = ["Action":ActionKeys.addContactDetails, "Authkey":UserAuthKEY.authKEY, "canID":canID,"firstName":firstName,"lastName":lastName,"jobTitle":jobTitle,"email":email,"mobilePhone":mobile]
         print_debug(object: dict)
         CANetworkManager.sharedInstance.requestApi(serviceName: ServiceMethods.serviceBaseURL, method: kHTTPMethod.POST, postData: dict as Dictionary<String, AnyObject>) { (response, error) in
                       
         print_debug(object: response)
         if response != nil
             {
               guard let gstResponse = response as? NSDictionary else
               {
                   return
               }
               
               guard let status = gstResponse.value(forKey: "status") as? String else
               {
                   return
               }
               
               guard let gstStatus = gstResponse.value(forKey: "message") as? String else
               {
                   return
               }
               
               let statusCase = status.lowercased()
               switch statusCase
               {
               case Server.api_status:
                   self.showSimpleAlert(TitaleName: "", withMessage: gstStatus)
               case Server.api_statusFailed:
                   self.showAlertC(message: gstStatus)
               default:
                   print("no match")
               }
             }
         }
     }
     
    func updateContactDetails(firstName: String,lastName: String, jobTitle: String, email: String, mobile: String,contactID: String)
        {
            let dict = ["Action":ActionKeys.updateContactDetails, "Authkey":UserAuthKEY.authKEY, "canID":canID,"contactId": contactID,"firstName":firstName,"lastName":lastName,"jobTitle":jobTitle,"email":email,"mobilePhone":mobile]
            print_debug(object: dict)
            CANetworkManager.sharedInstance.requestApi(serviceName: ServiceMethods.serviceBaseURL, method: kHTTPMethod.POST, postData: dict as Dictionary<String, AnyObject>) { (response, error) in
                          
            print_debug(object: response)
            if response != nil
                {
                  guard let gstResponse = response as? NSDictionary else
                  {
                      return
                  }
                  
                  guard let status = gstResponse.value(forKey: "status") as? String else
                  {
                      return
                  }
                  
                  guard let gstStatus = gstResponse.value(forKey: "message") as? String else
                  {
                      return
                  }
                  
                  let statusCase = status.lowercased()
                  switch statusCase
                  {
                  case Server.api_status:
                      self.showSimpleAlert(TitaleName: "", withMessage: gstStatus)
                  case Server.api_statusFailed:
                      self.showAlertC(message: gstStatus)
                  default:
                      print("no match")
                  }
                }
            }
        }
     
     func getContactDetails()
     {
         let dict = ["Action":ActionKeys.getContactDetails, "Authkey":UserAuthKEY.authKEY, "canID":canID]
         print_debug(object: dict)
         CANetworkManager.sharedInstance.requestApi(serviceName: ServiceMethods.serviceBaseURL, method: kHTTPMethod.POST, postData: dict as Dictionary<String, AnyObject>) { (response, error) in
                       
         print_debug(object: response)
         if response != nil
             {
               guard let status = response?.value(forKey: "status") as? String else
               {
                   return
               }
                
               let statusCase = status.lowercased()
               switch statusCase {
               case Server.api_status:
                    guard let userResponse = response?.value(forKey: "response") as? NSDictionary else
                    {
                        return
                    }
                    guard let responseArr = userResponse.value(forKey: "results") as? NSArray else
                    {
                        return
                    }
                    
                    DatabaseHandler.instance().getAndSaveUpdateGetContactsData(dict: responseArr)
                    self.userContacts = self.realm?.objects(GetContactDetailsData.self)
                    self.contactTableView.isHidden = false
                    self.emptyDataView.isHidden = false
                    self.addNewBTN.isHidden = false
                    self.addNewBTN.isHidden = false
                    self.contactTableView.delegate = self
                    self.contactTableView.dataSource = self
                    self.contactTableView.reloadData()
                
               case Server.api_statusFailed:
                    self.emptyDataView.isHidden = false
                    self.contactTableView.isHidden = true
                    self.transPrntView.isHidden = true
                    self.editTableView.isHidden = true
                    self.addNewBTN.isHidden = true
               default:
                   print("no match")
               }
             }
         }
     }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool
         {
         if let cell = editTableView.cellForRow(at: IndexPath(row: 0, section:0)) as? EditContactsCell
         {
            if textField==cell.mobileNmbrTF
            {
             let maxLength = 10
             let currentString: NSString = textField.text! as NSString
             let newString: NSString = currentString.replacingCharacters(in: range, with: string) as NSString
              if newString.length == 10
               {
               }
               else if newString.length<10
               {
                
               }
                 return newString.length <= maxLength
              }
            else if (textField==cell.firstNameTF)
            {
                let maxLength = 20
                let currentString: NSString = textField.text! as NSString
                let newString: NSString = currentString.replacingCharacters(in: range, with: string) as NSString
                if newString.length>20
                {
                    textField.resignFirstResponder()
                   // cell.lastNameTF.becomeFirstResponder()
                }
                return newString.length <= maxLength
            }
            else if (textField==cell.lastNameTF)
            {
                let maxLength = 20
                let currentString: NSString = textField.text! as NSString
                let newString: NSString = currentString.replacingCharacters(in: range, with: string) as NSString
                if newString.length>20
                {
                    textField.resignFirstResponder()
                   // cell.emailIDTF.becomeFirstResponder()
                }
                return newString.length <= maxLength
            }
            else if (textField==cell.emailIDTF)
            {
                let maxLength = 30
                let currentString: NSString = textField.text! as NSString
                let newString: NSString = currentString.replacingCharacters(in: range, with: string) as NSString
                if newString.length>30
                {
                    textField.resignFirstResponder()
                   // cell.designationTF.becomeFirstResponder()
                }
                return newString.length <= maxLength
            }
            else if (textField==cell.designationTF)
            {
                let maxLength = 30
                let currentString: NSString = textField.text! as NSString
                let newString: NSString = currentString.replacingCharacters(in: range, with: string) as NSString
                if newString.length>30
                {
                    textField.resignFirstResponder()
                   // cell.mobileNmbrTF.becomeFirstResponder()

                }
                return newString.length <= maxLength
            }
          }
           return true
       }

     func showSimpleAlert(TitaleName: String, withMessage: String)
         {
             let alert = UIAlertController(title: TitaleName, message: withMessage,preferredStyle: UIAlertController.Style.alert)
             alert.addAction(UIAlertAction(title: AlertViewButtonTitle.title_OK,style: UIAlertAction.Style.default,handler: {(_: UIAlertAction!) in
                self.transPrntView.isHidden = true
                self.editTableView.isHidden = true
                self.getContactDetails()
             }))
             self.present(alert, animated: true, completion: nil)
         }
    }
