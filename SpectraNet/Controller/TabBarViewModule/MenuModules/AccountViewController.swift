//
//  AccountViewController.swift
//  SpectraNet
//
//  Created by Yugasalabs-28 on 23/07/2019.
//  Copyright © 2019 Bhoopendra. All rights reserved.
//

import UIKit
import ObjectMapper
import RealmSwift
import Photos

class AccountViewController: UIViewController,UINavigationControllerDelegate, UIImagePickerControllerDelegate {

     var realm: Realm? = nil
    var userResult:Results<UserCurrentData>? = nil
    var userProfileResult:Results<UserProfileData>? = nil

    let networkClass = CANetworkManager()
    var dataResponse = NSDictionary()
    var userDicto = NSDictionary()
    var checkStatus = String()
    var profileListData = NSDictionary()
    var fromScreen = String()
    var imagePicker = UIImagePickerController()
    var canID = String()
    
    @IBOutlet weak var profileImgBTN: UIButton!
    @IBOutlet weak var LBLuploadImagStatus: UILabel!
    @IBOutlet weak var mobileNumberTF: UITextField!
    @IBOutlet weak var emailTF: UITextField!
    @IBOutlet weak var userAddress: UILabel!
    @IBOutlet weak var selectedCanID: UILabel!
    @IBOutlet weak var scrollView: UIScrollView!
    
    @IBOutlet weak var canIDView: UIView!
    @IBOutlet weak var lbluserNameD: UILabel!
    @IBOutlet weak var lbluserIDNameD: UILabel!
    @IBOutlet weak var lblBillingContactD: UILabel!
    @IBOutlet weak var lblBillingAdd: UILabel!
    @IBOutlet weak var lblTechContactD: UILabel!
    @IBOutlet weak var lblBillingAddD: UILabel!
    @IBOutlet weak var billingContactTF: UITextField!
    @IBOutlet weak var techContactTF: UITextField!
    @IBOutlet weak var instaLine: UILabel!
    @IBOutlet weak var billingLine: UILabel!
    @IBOutlet weak var B2BView: UIView!
    @IBOutlet weak var bottomViewHeightContant: NSLayoutConstraint!
    @IBOutlet weak var Lblusername: UILabel!
    
    @IBOutlet weak var uploadPictureLblHeight: NSLayoutConstraint!
    @IBOutlet weak var transpaantView: UIView!
    @IBOutlet weak var newAcntCanIDTF: JVFloatLabeledTextField!
    @IBOutlet weak var newAcntMobileTF: JVFloatLabeledTextField!
    @IBOutlet weak var addAcntView: UIView!
    @IBOutlet weak var resetPswdView: UIView!
    @IBOutlet weak var editBTN: UIButton!
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var btnRoundView: UIView!
    @IBOutlet weak var lblUserGSTnumber: UILabel!
    @IBOutlet weak var lblUserTANnumber: UILabel!
    @IBOutlet weak var lblUserGSTTitle: UILabel!
    @IBOutlet weak var lblUserTANTitle: UILabel!
    
    @IBOutlet weak var gstViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var managContImg: UIImageView!
    @IBOutlet weak var manageContFrwdImg: UIImageView!
    @IBOutlet weak var manageContactView: UIView!
    
    
    //MARK: View controller life cycle
    override func viewDidLoad() {
        super.viewDidLoad()

        realm = try? Realm()
        emailTF.isUserInteractionEnabled = false
        mobileNumberTF.isUserInteractionEnabled = false
        billingContactTF.isUserInteractionEnabled = false
        techContactTF.isUserInteractionEnabled = false
        addAcntView.isHidden = true
        resetPswdView.isHidden = true
        transpaantView.isHidden = true
       
        changeImageTintColor(theImageView: managContImg, withColor: UIColor.imageIcnTintColor)
        changeImageTintColor(theImageView: manageContFrwdImg, withColor: UIColor.imagefrwdTintColor)

    }
    
    override func viewWillAppear(_ animated: Bool)
    {
        super.viewWillAppear(animated)
        manageContactView.isHidden = true
        userResult = self.realm!.objects(UserCurrentData.self)
        if let userData = userResult?[0]
        {
            Lblusername.text = userData.AccountName
            canID = userData.CANId
            selectedCanID.text = String(format: "CAN ID - %@", canID)
            AppDelegate.sharedInstance.segmentType = userData.Segment.lowercased()
            print_debug(object: userData.Segment)

        }
        if ConnectionCheck.isConnectedToNetwork() == true
        {
            // profile data service
            serviceTypeGetProfile()
        }
        else
        {
            noInternetCheckScreenWithMessage(errorMessage:"")
        }
        
        canIDView.isHidden = true
        B2BView.isHidden = true
        
        //MARK: Save image in localy and set in imageView
       setImageFromLocalDirectory(fileName: String(format: "%@image.jpg", canID), imageView: profileImage,withImageLblStatus:LBLuploadImagStatus)
        
        //MARK: TODO Edit Mobile And Email Functionality Below Condition should be False
//        editBTN.isHidden = true
//        profileImgBTN.isUserInteractionEnabled = false
//        uploadPictureLblHeight.constant = 0
    }
    
    override func viewDidLayoutSubviews()
    {
        super.viewDidLayoutSubviews()
        view.layoutIfNeeded()
    }
    
    // Get user profile data
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
                    self.manageContactView.isHidden = false
                    guard let profileData = self.dataResponse.value(forKey: "response") as? NSDictionary else
                    {
                        return
                    }
                    self.profileListData = profileData
                    DatabaseHandler.instance().userProfileSavedData(dicto: self.profileListData)
                    self.userProfileResult = self.realm!.objects(UserProfileData.self)
                    let profileDat = self.userProfileResult?[0]
                    print_debug(object: profileDat?.GSTN)
                    
                    if AppDelegate.sharedInstance.segmentType == segment.userB2C
                    {
                        guard let shipto = profileDat?.shipTo else
                        {
                            return
                        }
                        self.b2CUserProfileData(userMobile: shipto.mobile, userAddres: shipto.address, userEmail: shipto.email)
                    }
                    else
                    {
                        self.lblUserGSTnumber.text = profileDat?.GSTN ?? ""
                        self.lblUserTANnumber.text = profileDat?.TAN ?? ""
                        
                        guard let shipto = profileDat?.shipTo else
                        {
                            return
                        }
                        guard let billto = profileDat?.billTo else
                        {
                            return
                        }
                        self.b2BUserProfileData(billName: billto.name, billEmail: shipto.email, billMobile: billto.mobile, BillAddres: billto.address, shipMobile: shipto.mobile, shipAddress: shipto.address)
                    }
                    self.canIDView.isHidden = false
                    self.B2BView.isHidden = false
                    self.scrollView.updateContentView()
                    self.scrollView.isScrollEnabled = true
                  }
                else
                  {
                    guard let statusMessage = self.dataResponse.value(forKey: "message") as? String else
                    {
                        return
                    }
                    self.showAlertC(message: statusMessage)
                 }
            }
        }
    }
    
    // This function use for B2C user profile
    func b2CUserProfileData(userMobile: String, userAddres: String,userEmail: String)
    {
        lbluserNameD.text = profileUserB2C.userNameD
        lbluserIDNameD.text = profileUserB2C.userIdD
        lblBillingAddD.text = profileUserB2C.billingAddD
        lblBillingAdd.text = ""
        lblTechContactD.text = ""
        lblBillingContactD.text = ""
        billingContactTF.text = ""
        techContactTF.text = ""
        instaLine.isHidden = true
        billingLine.isHidden = true
        bottomViewHeightContant.constant = 0
        mobileNumberTF.text = userMobile
        emailTF.text = userEmail
        userAddress.text = userAddres
        gstViewHeightConstraint.constant = 0
        lblUserGSTnumber.text = ""
        lblUserTANnumber.text = ""
        lblUserGSTTitle.text = ""
        lblUserTANTitle.text = ""
    }

    // This function use for B2B user profile
    func b2BUserProfileData(billName: String, billEmail: String,billMobile: String, BillAddres: String,shipMobile: String, shipAddress: String)
      {
          fieldNameB2Buser()
          mobileNumberTF.text = canID
          lblBillingAdd.text = BillAddres
          lblBillingContactD.text = profileUserB2B.BillingContD
          lblTechContactD.text = profileUserB2B.techContD
          billingContactTF.text = billMobile
          Lblusername.text = billName
          techContactTF.text = shipMobile
          emailTF.text = billEmail
          userAddress.text = shipAddress
      }
   
    // title field name for B2B user
    func fieldNameB2Buser()
    {
        lbluserNameD.text = profileUserB2B.userNameD
        lbluserIDNameD.text = profileUserB2B.userIdD
        lblBillingAddD.text = profileUserB2B.billingAddD
        instaLine.isHidden = false
        billingLine.isHidden = false
        bottomViewHeightContant.constant = 65
    }
    
    @IBAction func backBTN(_ sender: Any)
    {
        if fromScreen == FromScreen.menuScreen
        {
            self.navigationController?.popViewController(animated: false)
        }
        else if fromScreen == FromScreen.otpScreen
        {
             AppDelegate.sharedInstance.navigateFrom = TabViewScreenName.menu
            navigateScreen(identifier: ViewIdentifier.customTabIdentifier, controller: CustomTabViewController.self)
        }
    }
    
    @IBAction func uploadImgBTN(_ sender: Any)
    {
        checkPhotoLibraryPermission()
    }
    
// check photo permission
    func checkPhotoLibraryPermission() {
        let status = PHPhotoLibrary.authorizationStatus()
        switch status {
        case .authorized:
           //handle authorized status
            print_debug(object: "authorized")
            self.photoLibrary()
        case .denied, .restricted :
           //handle denied status
            print_debug(object: "denied")
            noInternetCheckScreenWithMessage(errorMessage: ErrorMessages.ifUserDiniedPermission)
            //   checkPhotoLibraryPermission()
        case .notDetermined:
               // ask for permissions
            PHPhotoLibrary.requestAuthorization { status in
                switch status {
                case .authorized:
                   // as above
                    print_debug(object: "Status authorized")
                    self.photoLibrary()
                        
                case .denied, .restricted:
                   // as above
                    print_debug(object: "Status denied")
                case .notDetermined:
                   // won't happen but still
                    print_debug(object: "Status denied")
                @unknown default:
                    print_debug(object: "Error")
                }
            }
        @unknown default:
            print_debug(object: "Error")
        }
    }
  
    // Open photo library
    func photoLibrary()
    {
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary)
        {
        let myPickerController = UIImagePickerController()
        myPickerController.delegate = self
        myPickerController.sourceType = .photoLibrary
        myPickerController.allowsEditing = true
        present(myPickerController, animated: false, completion: nil)
        }
    }
    
    // Navigate List of users CANID view controller
    @IBAction func showCanIDClick(_ sender: Any)
    {
       navigateScreen(identifier: ViewIdentifier.CanIDSelectedIdentifier, controller: CanIDViewController.self)
    }
    
    @IBAction func clickManageContacts(_ sender: UIButton)
    {
        manageContactsScreen(canID: canID)
    }
     
    // photo library delegate method
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        var image : UIImage!
          if let img = info[UIImagePickerController.InfoKey.editedImage] as? UIImage
          {
              image = img
          }
          else if let img = info[UIImagePickerController.InfoKey.originalImage] as? UIImage
          {
              image = img
          }

        picker.dismiss(animated: false, completion: nil)
    
        // Remove image from local
        removeImageLocalPath(localPathName:String(format: "%@image.jpg", canID))
        // Save image in local
        saveImageInLocalDirectory(withUsercanID: canID, userImage: image)
        // Set image in user profile from local and set status message
        setImageFromLocalDirectory(fileName: String(format: "%@image.jpg", canID), imageView: profileImage,withImageLblStatus:LBLuploadImagStatus)
    }
    
    @IBAction func cancelAddNewAcnt(_ sender: Any)
    {
    }
    
    // Navigate edit email or mobile number screen
    @IBAction func editProfileClick(_ sender: Any)
    {
        goEditProfileScreen(userName: Lblusername.text ?? "", canID: canID)
    }
  
    @IBAction func sendOTPBTN(_ sender: Any)
    {
        
    }
    
  /*
    
    func sendOTPtoLinkAccount()
       {
           let dict = ["Action":ActionKeys.sendOTPtoLinkAcount, "Authkey":UserAuthKEY.authKEY, "canID":canID]
           print_debug(object: dict)
           CANetworkManager.sharedInstance.requestApi(serviceName: ServiceMethods.serviceBaseURL, method: kHTTPMethod.POST, postData: dict as Dictionary<String, AnyObject>) { (response, error) in
                         
           print_debug(object: response)
           if response != nil
               {
               }
           }
       }
    
    func resendOTPtoLinkAccount()
    {
        let dict = ["Action":ActionKeys.resendOTPtoLinkAcount, "Authkey":UserAuthKEY.authKEY, "mobileNo":"7290080228","OTP":"9121"]
        print_debug(object: dict)
        CANetworkManager.sharedInstance.requestApi(serviceName: ServiceMethods.serviceBaseURL, method: kHTTPMethod.POST, postData: dict as Dictionary<String, AnyObject>) { (response, error) in
                      
        print_debug(object: response)
        if response != nil
            {
            }
        }
    }
    
    func getLinkAccountByCanID()
    {
        let dict = ["Action":ActionKeys.getLinkAcount, "Authkey":UserAuthKEY.authKEY, "baseCanID":canID]
        print_debug(object: dict)
        CANetworkManager.sharedInstance.requestApi(serviceName: ServiceMethods.serviceBaseURL, method: kHTTPMethod.POST, postData: dict as Dictionary<String, AnyObject>) { (response, error) in
                      
        print_debug(object: response)
        if response != nil
            {
            }
        }
    }
    
    func getLinkAccountByUserName()
    {
        let dict = ["Action":ActionKeys.getLinkAcount, "Authkey":UserAuthKEY.authKEY, "baseCanID":canID,
        "userName": "139525","mobileNo": ""]
        print_debug(object: dict)
        CANetworkManager.sharedInstance.requestApi(serviceName: ServiceMethods.serviceBaseURL, method: kHTTPMethod.POST, postData: dict as Dictionary<String, AnyObject>) { (response, error) in
                      
        print_debug(object: response)
        if response != nil
            {
            }
        }
    }
    
    func addLinkAccount()
       {
           let dict = ["Action":ActionKeys.addLinkAccount, "Authkey":UserAuthKEY.authKEY, "baseCanID":canID,"linkCanID":"183709","userName":"","mobileNo":"139525"]
           print_debug(object: dict)
           CANetworkManager.sharedInstance.requestApi(serviceName: ServiceMethods.serviceBaseURL, method: kHTTPMethod.POST, postData: dict as Dictionary<String, AnyObject>) { (response, error) in
                         
           print_debug(object: response)
           if response != nil
               {
               }
           }
       }
    
    func removeLinkAccount()
    {
        let dict = ["Action":ActionKeys.removeLinkAccount, "Authkey":UserAuthKEY.authKEY, "baseCanID":canID,"linkCanID":"183709","userName":"","mobileNo":"139525"]
        print_debug(object: dict)
        CANetworkManager.sharedInstance.requestApi(serviceName: ServiceMethods.serviceBaseURL, method: kHTTPMethod.POST, postData: dict as Dictionary<String, AnyObject>) { (response, error) in
                      
        print_debug(object: response)
        if response != nil
            {
            }
        }
    }
    
    func GetOrganizationNameByCanID()
    {
        let dict = ["Action":ActionKeys.getOrganizationName, "Authkey":UserAuthKEY.authKEY, "canID":canID]
        print_debug(object: dict)
        CANetworkManager.sharedInstance.requestApi(serviceName: ServiceMethods.serviceBaseURL, method: kHTTPMethod.POST, postData: dict as Dictionary<String, AnyObject>) { (response, error) in
                      
        print_debug(object: response)
        if response != nil
            {
            }
        }
    }
    
    func trackOrderByCanID()
       {
           let dict = ["Action":ActionKeys.trackOrder, "Authkey":UserAuthKEY.authKEY, "canID":canID]
           print_debug(object: dict)
           CANetworkManager.sharedInstance.requestApi(serviceName: ServiceMethods.serviceBaseURL, method: kHTTPMethod.POST, postData: dict as Dictionary<String, AnyObject>) { (response, error) in
                         
           print_debug(object: response)
           if response != nil
               {
               }
           }
       }
  
    */
    func changeImageTintColor(theImageView: UIImageView, withColor: UIColor)
    {
        theImageView.image = theImageView.image?.withRenderingMode(.alwaysTemplate)
        theImageView.tintColor = withColor
    }
    
}

// Extension used for scroll according content size
extension UIScrollView {
    func updateContentView() {
        contentSize.height = subviews.sorted(by: { $0.frame.maxY < $1.frame.maxY }).last?.frame.maxY ?? contentSize.height
    }
}

