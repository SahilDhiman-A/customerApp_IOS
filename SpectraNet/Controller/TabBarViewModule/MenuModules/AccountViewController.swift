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
    var parentCanID = String()
    
    @IBOutlet weak var addNewButton: UIButton!
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
    
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var gstViewHeightConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var resetPasswordImageView: UIImageView!
    @IBOutlet weak var managContImg: UIImageView!
    @IBOutlet weak var manageContFrwdImg: UIImageView!
    @IBOutlet weak var manageContactView: UIView!
    var childIds = [[String:AnyObject]]()
    var isChildxists = false
    
    @IBOutlet weak var B2BViewTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var backgroundView: UIView!
    
    @IBOutlet weak var loginBackgroundView: UIView!
    
    @IBOutlet weak var resetPasswordButton: UIView!
    @IBOutlet weak var loginButton: UIView!
    @IBOutlet weak var loginView: UIView!
    @IBOutlet weak var newPasswoedTF: JVFloatLabeledTextField!
    
    @IBOutlet weak var oldPasswordTextField: JVFloatLabeledTextField!
    @IBOutlet weak var confirmNewPassword: JVFloatLabeledTextField!
    
    @IBOutlet weak var resetPasswordForwordButton: UIImageView!
    //MARK: View controller life cycle
    @IBOutlet weak var linkedCanIDLable: UILabel!
    
    @IBOutlet weak var backGroundViewTop: NSLayoutConstraint!
    
    @IBOutlet weak var emptyView: UIView!
    @IBOutlet weak var accountView: UIView!
    @IBOutlet weak var accountManagerNameLabel: UITextField!
    @IBOutlet weak var accountManagerEmailLabel: UITextField!
    @IBOutlet weak var accountManagerPhoneNumberLabel: UITextField!
    
    
  var isIDSNotLinked = false
    
    var isCanItLogin = false
    
    @IBOutlet weak var canIdViewWidthConstraint: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        realm = try? Realm()
        emailTF.isUserInteractionEnabled = false
        mobileNumberTF.isUserInteractionEnabled = false
        billingContactTF.isUserInteractionEnabled = false
        techContactTF.isUserInteractionEnabled = false
        addAcntView.isHidden = true
      
        transpaantView.isHidden = true
        resetPswdView.isHidden = true
        
        setCornerRadiusView(radius: 15, color: UIColor.clear, view: backgroundView)
        setCornerRadiusView(radius: Float(loginButton.frame.height/2), color: UIColor.clear, view: loginButton)
        setCornerRadiusView(radius: Float(resetPasswordButton.frame.height/2), color: UIColor.clear, view: resetPasswordButton)
        
        setCornerRadiusView(radius: 15, color: UIColor.clear, view: resetPswdView)
         setCornerRadiusView(radius: 15, color: UIColor.clear, view: emptyView)
        setCornerRadiusView(radius: 15, color: UIColor.clear, view: loginView)
        setCornerRadiusView(radius: 15, color: UIColor.clear, view: loginView)
        changeImageTintColor(theImageView: managContImg, withColor: UIColor.imageIcnTintColor)
        
        changeImageTintColor(theImageView: resetPasswordForwordButton, withColor: UIColor.imagefrwdTintColor)
        
        changeImageTintColor(theImageView: resetPasswordImageView, withColor: UIColor.imageIcnTintColor)
        
        changeImageTintColor(theImageView: manageContFrwdImg, withColor: UIColor.imagefrwdTintColor)

    }
    
    override func viewWillAppear(_ animated: Bool)
    {
        super.viewWillAppear(animated)
        isIDSNotLinked = false
        
        
//        if(self.fromScreen == FromScreen.deactivateScreen){
//
//            self.backButton.isHidden = true
//
//
//        }
        if let isloginFrom = HelpingClass.userDefaultForKey(key: UserDefaultKeys.isLoginFrom) as? String{
            
            if isloginFrom == UserDefaultKeys.canID{
                self.isCanItLogin = true
            }else{
                
                 self.isCanItLogin = false
            }
        }
        linkedCanIDLable.isHidden = true
        linkedCanIDLable.text = ""
        self.backgroundView.isHidden = true
       // manageContactView.isHidden = true
        self.isChildxists = false
        self.emptyView.isHidden = true
        self.accountView.isHidden = true
        self.addNewButton.setTitle("ADD NEW", for: .normal)
        userResult = self.realm!.objects(UserCurrentData.self)
        
        
        let allUsers = self.realm!.objects(UserData.self)
        
      
        if let userData = userResult?[0]
        {
            
            print_debug(object: "userResult \(userResult)")
            Lblusername.text = userData.AccountName
            canID = userData.CANId
            parentCanID = userData.CANId
            
            selectedCanID.text = String(format: "CAN ID - %@", userData.CANId)
            if let isloginFrom = HelpingClass.userDefaultForKey(key: UserDefaultKeys.isLoginFrom) as? String{
                
                if isloginFrom == UserDefaultKeys.canID{
                    
                    
                    if(allUsers.count > 0){
                    if let user = allUsers[0] as? UserData {
                    
                    parentCanID = user.CANId
                        
                    }
                    }
                    
                }
                
            }
           
            AppDelegate.sharedInstance.segmentType = userData.Segment.lowercased()
            print_debug(object: userData.Segment)

        }
        if ConnectionCheck.isConnectedToNetwork() == true
        {
            // profile data service
            getLinkAccountByCanID()
            serviceTypeGetProfile()
            
        }
        else
        {
            noInternetCheckScreenWithMessage(errorMessage:"")
        }
        
        canIDView.isHidden = true
        B2BView.isHidden = true
        addNewButton.isHidden = true
        //MARK: Save image in localy and set in imageView
       setImageFromLocalDirectory(fileName: String(format: "%@image.jpg", canID), imageView: profileImage,withImageLblStatus:LBLuploadImagStatus)
        
        //MARK: TODO Edit Mobile And Email Functionality Below Condition should be False
//        editBTN.isHidden = true
//        profileImgBTN.isUserInteractionEnabled = false
//        uploadPictureLblHeight.constant = 0
    }
    
    override func viewWillLayoutSubviews() {
        
        if self.view.frame.height <= 568{
            
            canIdViewWidthConstraint.constant = 150
        }
        super.viewWillLayoutSubviews()
    }
    
    func getLinkAccountByCanID()
    {
        var dict = ["Action":ActionKeys.getLinkAcount, "Authkey":UserAuthKEY.authKEY]
        
        if let isloginFrom = HelpingClass.userDefaultForKey(key: UserDefaultKeys.isLoginFrom) as? String{
            
            if isloginFrom == UserDefaultKeys.canID{
                dict["baseCanID"] = parentCanID
                
            }else{
                
                 if let mobileNumber = HelpingClass.userDefaultForKey(key: UserDefaultKeys.loginPhoneNumber) as? String{
                 dict["mobileNo"] = mobileNumber
                }
            }
        }
        print_debug(object: dict)
        CANetworkManager.sharedInstance.requestApiWithoutHUD(serviceName: ServiceMethods.serviceBaseURL, method: kHTTPMethod.POST, postData: dict as Dictionary<String, AnyObject>) { [weak self] (response, error) in
            
            print_debug(object: response)
            if response != nil
            {
                
                self?.isIDSNotLinked = true
                self?.B2BViewTopConstraint.constant = 21
                if let  responseValue = response?["status"] as? String{
                    
                    
                    if responseValue != Server.api_status
                    {
                        if let  statusMessage = response?[ "message"] as? String {
                          //  self?.showAlertC(message: statusMessage)
                            
                        }
                        return
                    }
                    
                }
                
                if let  responseValue = response?["response"] as? [[String:AnyObject]]{
                    
                    if responseValue.count > 0{
                        
                        if let isloginFrom = HelpingClass.userDefaultForKey(key: UserDefaultKeys.isLoginFrom) as? String{
                              if isloginFrom == UserDefaultKeys.canID{
                        
                        self?.B2BViewTopConstraint.constant = 21
                         self?.childIds = responseValue
                          self?.isChildxists = true
                         self?.noLikedIdSelected()
                              }else{
                                
                                
                                self?.B2BViewTopConstraint.constant = 21
                                self?.childIds = responseValue
                                self?.isChildxists = true
                              self?.noLikedIdSelected()
                                
                            }
                        }else{
                             self?.noLikedIdSelected()
                            
                        }
                    }else{
                       self?.noLikedIdSelected()
                    }
                    
                    
                }
            }
        }
    }
    
    func noLikedIdSelected(){
        
        self.B2BViewTopConstraint.constant = 21
        self.isChildxists = false
        self.addNewButton.setTitle("Add new", for: .normal)
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
        CANetworkManager.sharedInstance.requestApi(serviceName: ServiceMethods.serviceBaseUatValue, method: kHTTPMethod.POST, postData: dict as Dictionary<String, AnyObject>) { (response, error) in
            
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
                   self.backgroundView.isHidden = false //self.manageContactView.isHidden = false
                    guard let profileData = self.dataResponse.value(forKey: "response") as? NSDictionary else
                    {
                        return
                    }
                    
                    self.canIDView.isHidden = false
                    self.B2BView.isHidden = false
                    self.resetPswdView.isHidden = true
                    self.addNewButton.isHidden = false
                    self.accountView.isHidden = false
                    self.scrollView.updateContentView()
                    self.scrollView.isScrollEnabled = true
                    
                    self.backGroundViewTop.constant = 30
                    
                    self.linkedCanIDLable.isHidden = true
                    self.B2BViewTopConstraint.constant = 21
                    self.linkedCanIDLable.text = ""
                    self.profileListData = profileData
                    DatabaseHandler.instance().userProfileSavedData(dicto: self.profileListData)
                    self.userProfileResult = self.realm!.objects(UserProfileData.self)
                    let profileDat = self.userProfileResult?[0]
                    print_debug(object: profileDat?.GSTN)
                    
                    
                    if let accountManager = profileDat?.accountManager{
                        
                        if let name = accountManager.name as? String{
                            
                            self.accountManagerNameLabel.text = name
                        }
                        
                        if let email = accountManager.email as? String{
                            
                            self.accountManagerEmailLabel.text = email
                        }
                        
                        if let mobile = accountManager.mobile as? String{
                            
                            self.accountManagerPhoneNumberLabel.text = mobile
                        }
                    }
                    
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
                  
                    
                    
                  }
                else
                  {
                    self.emptyView.isHidden = false
                     self.backgroundView.isHidden = false
                    self.canIDView.isHidden = false
                    self.B2BView.isHidden = true
                      self.accountView.isHidden = true
                    self.resetPswdView.isHidden = true
                    self.addNewButton.isHidden = false
                    self.scrollView.updateContentView()
                    self.scrollView.isScrollEnabled = false
                    
                    if( self.canID ==  self.parentCanID){
                        self.linkedCanIDLable.isHidden = true
                        self.B2BViewTopConstraint.constant = 21
                        self.backGroundViewTop.constant = -410
                        self.linkedCanIDLable.text = ""
                    }else{
                         self.linkedCanIDLable.isHidden = false
                        self.B2BViewTopConstraint.constant = 70
                         self.backGroundViewTop.constant = -410
                        self.linkedCanIDLable.text = String(format: "Linked CAN ID - %@",  self.canID)
                    }
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
        }else{
            
            self.navigationController?.popViewController(animated: false)
        }
    }
    
    @IBAction func uploadImgBTN(_ sender: Any)
    {
        checkPhotoLibraryPermission()
        uploadPhotoFirbaseAnalysics()
    }
    func uploadPhotoFirbaseAnalysics(){
        
        let dictAnalysics = [AnanlysicParameters.canID:canID,
                             AnanlysicParameters.Category:AnalyticsEventsCategory.my_account,
                             AnanlysicParameters.Action:AnalyticsEventsActions.upload_profile_picture,
                             AnanlysicParameters.EventType:AnanlysicParameters.ClickEvent]

        HelpingClass.sharedInstance.addFirebaseAnalysis(eventName: AnalyticsEventsName.upload_profile_picture, parameters: dictAnalysics as? [String:AnyObject] ?? [String:AnyObject]() )
        
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
            DispatchQueue.main.async() {
                self.noInternetCheckScreenWithMessage(errorMessage: ErrorMessages.ifUserDiniedPermission)
            }
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
        DispatchQueue.main.async() {
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary)
        {
        let myPickerController = UIImagePickerController()
        myPickerController.delegate = self
        myPickerController.sourceType = .photoLibrary
        myPickerController.allowsEditing = true
            self.present(myPickerController, animated: false, completion: nil)
        }
        }
    }
    
    // Navigate List of users CANID view controller
    @IBAction func showCanIDClick(_ sender: Any)
    {
        
         //vc.data = self.childIds
        
        
        if(self.isIDSNotLinked == true){
        
        if  let vc = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: ViewIdentifier.CanIDSelectedIdentifier) as? CanIDViewController{
            vc.data = self.childIds
           
            self.navigationController?.pushViewController(vc, animated: false)
            
        }
        }
//        CanIDViewController
//       navigateScreen(identifier: ViewIdentifier., controller: .self)
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
    
    @IBAction func addNewCanIDButtonClick(_ sender: Any) {
        
        
        var linkedCanIds = [String]()
        
        for subdata in self.childIds{
            
            if let linkedCanIdValue = subdata["link_canid"] as? String{
                linkedCanIds.append(linkedCanIdValue)
                
            }
        }

        if  let vc = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: ViewIdentifier.LinkCanIdIdentifier) as? LinkCanIdViewController{
            vc.baseCanID = parentCanID
              vc.linkedCanIDS = linkedCanIds
            self.navigationController?.pushViewController(vc, animated: false)
            
        }

    }
    
   
    @IBAction func resetPasswordAction(_ sender: Any) {
        
        oldPasswordTextField.text = ""
        newPasswoedTF.text = ""
        confirmNewPassword.text = ""
        transpaantView.isHidden = false
        resetPswdView.isHidden = false
        resetPasswordFirbaseAnalysics()
    }
    
    func resetPasswordFirbaseAnalysics(){
        
        let dictAnalysics = [AnanlysicParameters.canID:canID,
                             AnanlysicParameters.Category:AnalyticsEventsCategory.my_account,
                             AnanlysicParameters.Action:AnalyticsEventsActions.reset_password,
                             AnanlysicParameters.EventType:AnanlysicParameters.ClickEvent]

        HelpingClass.sharedInstance.addFirebaseAnalysis(eventName: AnalyticsEventsName.my_account_reset_password, parameters: dictAnalysics as? [String:AnyObject] ?? [String:AnyObject]() )
        
    }
    
    func resetPasswordSuccessFirbaseAnalysics(){
        
        let dictAnalysics = [AnanlysicParameters.canID:canID,
                             AnanlysicParameters.Category:AnalyticsEventsCategory.my_account,
                             AnanlysicParameters.Action:AnalyticsEventsActions.reset_password_success,
                             AnanlysicParameters.EventType:AnanlysicParameters.ClickEvent]

        HelpingClass.sharedInstance.addFirebaseAnalysis(eventName: AnalyticsEventsName.reset_password_success, parameters: dictAnalysics as? [String:AnyObject] ?? [String:AnyObject]() )
        
    }
    
    func resetPasswordCaneclFirbaseAnalysics(){
        
        let dictAnalysics = [AnanlysicParameters.canID:canID,
                             AnanlysicParameters.Category:AnalyticsEventsCategory.my_account,
                             AnanlysicParameters.Action:AnalyticsEventsActions.reset_password_cancel,
                             AnanlysicParameters.EventType:AnanlysicParameters.ClickEvent]

        HelpingClass.sharedInstance.addFirebaseAnalysis(eventName: AnalyticsEventsName.reset_password_cancel, parameters: dictAnalysics as? [String:AnyObject] ?? [String:AnyObject]() )
        
    }
    
    @IBAction func cancelPasswordButtonCleck(_ sender: Any) {
        
        oldPasswordTextField.text = ""
        newPasswoedTF.text = ""
        confirmNewPassword.text = ""
        
        transpaantView.isHidden = true
        resetPswdView.isHidden = true
        resetPasswordCaneclFirbaseAnalysics()
    }
    
    func validatePassword() -> Bool {
        
        
        if(oldPasswordTextField.text?.count ?? 0 == 0){
            
             self.showAlertC(message: ErrorValidationMessages.wrongEnterPassword)
              return false
            
        
        }else if(newPasswoedTF.text?.count ?? 0 == 0){
            self.showAlertC(message: ErrorValidationMessages.wrongEnterNewPassword)
              return false
        }
        else if(!HelpingClass.sharedInstance.isValidPassword(value:newPasswoedTF.text ?? "")){
             self.showAlertC(message: ErrorValidationMessages.wrongEnterValidPassword)
              return false
            
        }
        else if(oldPasswordTextField!.text == newPasswoedTF!.text){
            
            self.showAlertC(message: ErrorValidationMessages.samePassword)
            return false
        }
        else if(newPasswoedTF!.text != confirmNewPassword!.text){
            
             self.showAlertC(message: ErrorValidationMessages.correctPassword)
              return false
        }
        
        
        
        return true
        
    }
    
    @IBAction func updatePasswodButtonClick(_ sender: Any) {
        
        if(validatePassword()){
        
        
           
            
        if let oldPasswod = oldPasswordTextField.text,let password = newPasswoedTF.text{
            
            
            
           let  oldPasswodEncodeStr = oldPasswod.data(using: .utf8)?.base64EncodedString() as Any as! String
            
        
             let passwordEncodeStr = password.data(using: .utf8)?.base64EncodedString() as Any as! String
            
          
            let dict = ["Action":ActionKeys.resetpassword, "Authkey":UserAuthKEY.authKEY, "canID":self.parentCanID,"oldPassword":oldPasswodEncodeStr,"newPassword":passwordEncodeStr]
        print_debug(object: dict)
        CANetworkManager.sharedInstance.requestApi(serviceName: ServiceMethods.serviceBaseURL, method: kHTTPMethod.POST, postData: dict as Dictionary<String, AnyObject>) { (response, error) in
            
            print_debug(object: response)
            self.resetPasswordSuccessFirbaseAnalysics()
            self.transpaantView.isHidden = true
             self.resetPswdView.isHidden = true
               
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
                        HelpingClass.saveToUserDefault(value: false as AnyObject, key: "status")
                        
                        self.loginBackgroundView.isHidden = false
                    }
                    else
                    {
                        guard let statusMessage = self.dataResponse.value(forKey: "message") as? String else
                        {
                            return
                        }
                        self.showAlertC(message: statusMessage)
                    }
                    
                    
                }else
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
    }
    
    @IBAction func loginAction(_ sender: Any) {
        
        HelpingClass.saveToUserDefault(value: false as AnyObject, key: "status")
        Switcher.updateRootVC()
        
        
    }
    
    
}

// Extension used for scroll according content size
extension UIScrollView {
    func updateContentView() {
        contentSize.height = subviews.sorted(by: { $0.frame.maxY < $1.frame.maxY }).last?.frame.maxY ?? contentSize.height
    }
}

extension AccountViewController:UITextFieldDelegate{
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool
    {
        
        let maxLength = 20
        let currentString: NSString = textField.text! as NSString
        let newString: NSString =
            currentString.replacingCharacters(in: range, with: string) as NSString
        if newString.length>20
        {
            textField.resignFirstResponder()
            
        }
        return newString.length <= maxLength
        
        
        
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool
    {
        textField.resignFirstResponder();
        
        return true;
    }
    
    
}
