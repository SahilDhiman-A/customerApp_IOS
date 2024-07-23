//
//  Define.swift
//  SpectraNet
//
//  Created by Bhoopendra on 7/11/19.
//  Copyright © 2019 Bhoopendra. All rights reserved.
//

import Foundation
import UIKit


// MARK : GLOBAL Functions
func print_debug <T> (object: T)
{
//print(object)
}

// This structer is used for Services
struct ServiceMethods{
   // static let serviceBaseURL = "https://epayuat.spectra.co/index.php"// UAT
//    static let serviceBaseUatValue = "https://custappmwuat.spectra.co/index.php"// UAT
//    static let serviceBaseFDSS =  "https://custappmwuat.spectra.co/api/v1/getfdss"// UAT
//    static let serviceBaseURLInternetNotWorking = "https://custappmwuat.spectra.co/api/v2/getInternetNotWorking/authkey/"// UAT
//    static let spectraPaymentURLExtraParameter = "&sub_segment=UAT"  //UAT
//    static let notificationServiceBaseUrl = "https://spectra.affleprojects.com/v0/"
//
        static let serviceBaseURL = "https://custappmw.spectra.co/index.php"// LiVe//
        static let serviceBaseUatValue = "https://custappmw.spectra.co/index.php"// Live
        static let serviceBaseFDSS =  "https://custappmw.spectra.co/api/v1/getfdss"// Live
        static let serviceBaseURLInternetNotWorking = "https://custappmw.spectra.co/api/v2/getInternetNotWorking/authkey/"// Live
          static let spectraPaymentURLExtraParameter =  "&sub_segment=PROD"  //Live
        static let notificationServiceBaseUrl = "https://appadmin.spectra.co/v0/" //Live
    static let spectraPaymentURL = "https://epay.spectra.co/onlinepayment/getcustomerpaymentAPI.php"
    
}

// This structer is used for Authentication key in Services in app
struct UserAuthKEY {
//    static let authKEY = "AdgT68HnjkehEqlkd4" // UAT
//    static let authKEYInternetNotWorking = "01a62ae9623beb096ec88dca3836858c" // UAT
//    static let paymentType = "UAT"
        static let authKEYInternetNotWorking = "01a62ae9623beb096ec88dca3836858c" // Live
        static let authKEY = "AdgT68HnjC8U5S3TkehEqlkd4" // LIVE
        static let paymentType = "PROD"
}

// This structure is used for StandingInstruction Module
struct StandinInsrcuction
{
    static let standingInstructionSpectraPaymentURL = "https://epay.spectra.co/autopay/pay.php"
    static let secretKey = "b77de68DAecd823Bad3Edb1c"
    static let siTermAndConditionURL = "https://custappmw.spectra.co/autopay_t_c.html"
    static let termConditionAccept = "Please accept Terms and Conditions"
    static let termConditionSelected = "Selected"
    static let termConditionUnselected = "Unselected"
    static let siDisableURL = "https://epay.spectra.co/autopay/disable.php"
    static let siEnable = "Enable"
    static let siDisable = "Disable"
    static let siButtonEnable = "ENABLE"
    static let siButtonDisable = "DISABLE"
    static let termText = "I accept the Terms & Conditions"
    static let term = "Terms & Conditions."
    static let siPaybleAmount = "10"
    // static let siReturnURL = "https%3A%2F%2Fmy.spectra.co%2Findex.php%2Fxml%2Fsipayment"
    static let siReturnURL = "https://my.spectra.co/index.php/xml/sipayment"
    static let returnURL = "returnUrl"
    static let siEnableRequestType = "1"
    static let siDisablRequestType = "0"
    static let siEnabled = "Success! Thank you. Your auto pay is registered with us."
    static let siDisabled = "Success! Thank you. Your auto pay is disabled"
    static let siDisablFailed = "Oops! Something has gone wrong. We are unable to process your request now."
    static let siEnabledFailed = "Oops! Something has gone wrong. We are unable to process your request now."
    static let displaySIMessage = "Auto Pay: Set up a standing instruction to pay your spectra bills using your Credit card (Visa & Master Card) with ease your future payments on this card will be charged automatically on 6th day from bill generation date.\nNote: Rs 10 will be charged for Card auto pay enablement and same will adjusted in O/S amount."
}
//https://my.spectra.co/index.php/xml/sipayment"
// This structer is used for TabViewName
struct TabViewScreenName
{
    static let home = ""
    static let Payment = "PaymentScren"
    static let sr = "SRScreen"
    static let getHelp = "Get Help"
    static let menu = "MenuScreen"
    
}
struct wifiSignalStength
{
    
    static let excellent =  "Excellent"
    static let weak =  "Weak"
    static let noWifi =  "noWifi"
    
}
struct wifiSignalFrequesncy
{
    static let firstCase =  "2.4 GHZ"
    static let secondCase =  "5 GHZ"
}
struct NoInternetMessageCode
{
    static let  massOutrage = "213"
    static let  accountRecativeFlag = "211"
    static let  accountActiveFlag = "218"
    static let  OutstandingBalanceFlag = "219"
    static let  serviceBar = "212"
    static let  SafeCustody = "222"
    static let  OpenSR = "214"
    static let  enableSafeCustodytoActive = "220"
    //static let  OutstandingBalanceFlagSafeCustody = "220"
    static let  GPON = "216"
    static let  GPON40 = "238"
    
    static let  GPONNON = "215"
    static let  GPONNoIssue = "217"
    
    static let  GPONNONStopWatch = "GPONNONStopWatch"
    
    static let  GPONNONStopWatchON = "224"
    static let  GPONNONStopWatchONOFF = "GPONNONStopWatchONOFF"
    static let  GPONNONStopWatchONOFFAgainTimer = "GPONNONStopWatchONOFFAgainTimer"
    static let  GPONNONInternetWorking = "227"
    static let  GPONNONInternetNOTWorking = "226"
    static let  GPONNONLightNOTWorking = "228"
    static let  partner = "Partner"
    static let  partnerStopWatch = "partnerStopWatch"
    
    static let  GPON40StopWatch = "GPON40StopWatch"
    
    static let FUPFlag = "241"
    static let FUPFlagNo = "242"
    static let FUPFlagYes = "240"
    static let FDSSSRRaised = "249"
    static let UtilisationMoreThen80 = "243"
    static let UpgardeYes = "244"
    static let UpgardeNo = "245"
    static let  GPON40DGIFD = "247"  
    static let  internetWorkingFD = "248"
    static let  GPON40DGIFDTimerStop = "GPON40DGITimerStop"
    static let wANlightPAtner = "250"
    
    static let wANlightPAtnerFluctuatingLightNo = "251"
    static let autoDetectionWIFI = "252"
    static let lanSelected = "lanSelected"
    static let wifiSelected = "wifiSelected"
    static let wifiRangeSelected = "wifiRangeSelected"
    static let wifiCheckSpeedSelected = "wifiCheckSpeedSelected"
    static let lanSelectedYes = "lanSelectedYes"
    static let lanSelectedNo = "lanSelectedNo"
    static let lanSelectedYesTimerSet = "lanSelectedYesTimerSet"
    static let wANlightPAtnerFluctuatingLightNoTimerStop = "wANlightPAtnerFluctuatingLightNoTimerStop"
    static let speedYes = "256"
    static let speedYesWifi = "264"
    
    
    
    
    
}

// This Structure is ised for Email update or mobile update module
struct UpdateType {
    static let mobileUpdateDefault = "Mobile"
    static let LinkCanId = "LinkCanId"
    static let gstUpdateDefault = "GST"
    static let tanUpdateDefault = "TAN"
    static let emailUpdateDefault = "Email"
    static let enterUpdateMobileNumber = "Please enter Mobile Number"
    static let enterUpdateEmialID = "Please enter Email ID"
    static let enterUpdateGSTNumber = "Please enter GST Number"
    static let entervalidGSTNumber = "Please enter valid GST Number"
    static let enterUpdateTANNumber = "Please enter TAN Number"
    static let enterValidTANNumber = "Please enter valid TAN Number"
    static let enterChangedTANNumber = "New and old TAN Number cannot be same"
    static let enterChangeGSTNumber = "New and old GST Number cannot be same"
    static let enterChangedMobileNumber = "New and old Mobile Number cannot be same"
    static let enterChangedEmailID = "New and old Email ID cannot be same"
    static let updateMobileNumberPlaceHolder = "Mobile Number"
    static let updateGSTNumberPlaceHolder = "GST Number"
    static let updateTANNumberPlaceHolder = "TAN Number"
    static let updateEmialIDPlaceHolder = "Email ID"
    static let changedMobileNumber = "Your mobile number changed successfully"
    static let changedEmialID = "Your Email ID changed successfully"
}

// This structer is used for term and Disclaimer and Privacy policy
struct WebLinks {
    static let disclaimer = "https://www.spectra.co/legal-disclaimer"
    static let privacyPolicy = "https://www.spectra.co/privacy-policy"
}

// This structure is ised from screen moveout naming
struct FromScreen {
    static let topUpScreen = "TopUpScreen"
    static let changeTopUPScreen = "ChangeTopUPScreen"
    static let CompareTopUPScreen = "CompareTopUPScreen"
    static let otpScreen = "OTPScreen"
    static let menuScreen = "MenuScreen"
    
    static let deactivateScreen = "DeactivateScreen"
}

// This structer is used for All Action key in Services in app  
struct ActionKeys {
    static let userAccountData = "getAccountData"
    static let getInvoiceList = "getInvoiceList"
    static let getAccountByPassword = "getAccountByPassword"
    static let getAccountByMobile = "getAccountByMobile"
    static let sandOTP = "sendotp"
    static let resendOTP = "resendotp"
    static let forgotPassword = "forgotpassword"
    static let paymentTransactionDetails = "paymentTransactionDetail"
    static let getSRStatus = "getSRstatus"
    static let getProfile = "getprofile"
    static let getAttnSpectra = "getAttn"
    static let getRatePlan = "getrateplanByCanID"
    static let getCases = "getcasetype"
    static let createSR = "createSR"
    static let invoiceContent = "getInvoiceContent"
    static let getMRTGGbcanID = "getMRTGbycanid"
    static let getSessionHistory = "getSessionhistory"
    static let changePlane = "changeplan"
    static let getOffer = "getOffers"
    static let updateEmail = "updateemail"
    static let updateMobileNumber = "updatemobile"
    static let sendOTPforUpdateMobileNumber = "updateMobileSendOTP"
    static let sendOTPforUpdateEmailID = "updateEmailSendOTP"
    static let getTopupPlan = "getTopup"
    static let addTopUp = "addTopup"
    static let getSIStatusAutoPay = "getStatusAutopay"
    
    // Phase 2 Api TODO
    static let updateTANNumber = "updateTAN"
    static let updateGSTNumber = "updateGSTN"
    static let sendOTPtoLinkAcount = "sendOTPLinkAccount"
    static let resendOTPtoLinkAcount = "reSendOTPLinkAccount"
    static let getLinkAcount = "getLinkAccount"
    static let addLinkAccount = "addLinkAccount"
    static let removeLinkAccount = "removeLinkAccount"
    static let getOrganizationName = "getOrgName"
    static let trackOrder = "trackOrder"
    static let addContactDetails = "addContactDetails"
    static let getContactDetails = "getContactDetails"
    static let updateContactDetails = "updateContactDetails"
    static let resetpassword = "resetpassword"
    static let  consumedTopup = "consumedTopup"
    static let checkSR = "checkSR"
    static let forceUpdate = "forceUpdate"
    static let proDataChargesForPlan = "proDataChargesForPlan"
    static let proDataChargesForTopup = "proDataChargesForTopup"
    static let comparisonPlan = "comparisonPlan"
    static let knowMoreForPlan = "knowMoreForPlan"
    static let deactivateTopup = "deactivateTopup"
    static let deviceSignIn = "deviceSignIn"
    static let  deviceSignOut = "deviceSignOut"
    static let  createTransaction = "createTransaction"
    static let  updatePaymentStatus = "responsePayment"
    static let  createOrder = "createOrder"
    static let  updateStatusForAutopay = "responsePaymentForAutopay"
    static let  disableOrder = "disableOrder"
    static let getsegmentlist = "segment/getsegmentlist"
    static let gettopFiveFaqList = "faq/gettop5faqlist"
    static let getthumbscount = "faq/getthumbscount"
    static let thumbsup = "faq​/thumbsup"
    static let thumbsdown = "faq​/thumbsdown"
    static let getrecentsearchlist = "faq/getrecentsearchlist"
    static let getfaqbysegmentid =  "faq/getfaqbysegmentid"
    static let getfaqbysegmentname =  "faq/getfaqbysegmentname"
}

// This structer is used for All Logged in error message status
struct ErrorValidationMessages {
    static let wrongEmailUserName    =    "Please enter username"
    static let wrongEnterPassword    =     "Please enter password"
    static let wrongEnterNewPassword    =     "Please enter new password"
    static let wrongEnterValidPassword    =     "Please enter valid password"
    static let wrongCanID    =    "Please enter CAN ID"
    static let validCanID    =    "Please enter valid CAN ID"
    
    static let canIDAlreadyLinked    =    "CAN ID already linked"
    static let correctPassword    =     "New password and cofirm password can not be same."
    
    static let samePassword    =     "Old password and new password can not be same."
}

// This structer is used for unselect custom date
struct DefaultString
{
    static let setSeletctdate = "Select Date"
    static let pleaseSelectDate = "Please select date range"
    static let hurrey = "Hurrey!"
    static let noSRrequest = "There is no service request"
}

//This structer is used for all the keys used in service class.All the keys used in service class should be here.
struct ServiceKeys
{
    static let status = "status"
    static let canId = "canId"
    
}

struct SignINR
{
    static let ruppes = "₹"
}


// This structer is used for all Viewcontroller Storyboard Indentifier
struct ViewIdentifier {
    static let homeIdentifier = "HomeView"
    static let invoiceIdentifier = "InvoiceDetail"
    static let loginIdentifier = "LoginView"
    static let otpIdentifier = "OTPViewC"
    static let forgotPswdIdentifier = "ForgotPasswordView"
    static let customTabIdentifier = "CustomTab"
    static let menuIdentifier = "MoreView"
    static let SRIdentifier = "SRView"
    static let AccountIdentifier = "AccountView"
    static let StandingInstructionIdentifier = "StandingInstractionVC"
    static let NotificationIdentifier = "NotificationVC"
    static let planIdentifier = "PlanView"
    static let CanIDSelectedIdentifier = "CanIDVC"
    static let PayNowIdentifier = "PayNowVC"
    static let CreateSRIdentifier = "CreateSRVC"
    static let dataUsageIdentifier = "DataUsageVC"
    static let faqIdentifier = "FaqVC"
    static let invoiceDetailsIdentifier = "InvoiceContentVC"
    static let caseTypeIdentifier = "CaseTypeCell"
    static let mrtgIdentifier = "MRTGVC"
    static let businessIdentifier = "BusinessFaqVC"
    static let paymentstatusIndentifier = "PaymentStatusVC"
    static let accountActivationIdentifier = "AccountActivationVC"
    static let NoInternetIdentifier = "NoInternetVC"
    static let contactUsIdentifier = "ContactUSVC"
    static let privacyIdentifier = "PrivacyPolicyVC"
    static let cancelledAccountIdentifier = "AccountCancelledVC"
    static let paymentScreenIdentifier = "PaymentScreenVC"
    static let changePlaneIndetifier = "ChangePlanVC"
    static let editProfileIdentifier = "EditProfileVC"
    static let topupIdentifier = "TopupPlanVC"
    static let siTermCondition = "SIPrivacyPolicyVC"
    static let manageContactIdentifier = "ManageContactsVC"
    static let chatBot = "ChatBot"
    static let testInternetIdentifier = "TestInternetViewController"
    static let payBillMultipleAccountsIdentifier = "PayBillMultipleAccountsViewController"
    static let payBillMultipleAccountsPaymentIdentifier = "PayBillMultipleAccountsPaymentViewController"
    static let LinkCanIdIdentifier = "LinkCanIdViewController"
    static let trackOrderIdentifier = "TrackOrderViewController"
    static let viewLinkedAccountIdentifier = "ViewLinkedAccountViewController"
    static let ConsumedTopupPlanVC = "ConsumedTopupPlanVC"
    static let OutstandingBalancePaymentIdentifier = "OutstandingBalancePaymentIdentifier"
    static let TroubleshootViewControllerIdentifier = "TroubleshootViewControllerIdentifier"
    static let NONGPONViewControllerIdentifier = "NONGPONViewControllerIdentifier"
    static let OpenSRViewControllerIdentifier = "OpenSRViewControllerIdentifier"
    static let  FrequentDisconnectionViewController = "FrequentDisconnectionViewController"
    static let FrequentlyDisconnectCasesViewController = "FrequentlyDisconnectCasesViewController"
    static let UtllizationMoreThanEightyViewController = "UtllizationMoreThanEightyViewController"
    static let AutoDetectionWIFIViewController = "AutoDetectionWIFIViewController"
    static let ComparePlanViewController = "ComparePlanViewController"
    static let KnowMoreIdentifier = "KnowMoreIdentifier"
    static let CompareViewController = "CompareViewController"
    static let ArchieveViewController = "ArchieveViewController"
    static let NotificationSearchViewController = "NotificationSearchViewController"
    static let ChangePlanCompareViewController = "ChangePlanCompareViewController"
    static let NotificationDisplayViewController = "NotificationDisplayViewController"
    static let CanIdSwitchViewController = "CanIdSwitchViewController"
    static let FaqDownViewController = "FaqDownViewController"
    static let FAQReasonViewController = "FAQReasonViewController"
    static let RecentSearchViewController = "RecentSearchViewController"
    
}

struct contactUsData
{
    static let newConnectionContact = "18602660099"
    static let supportLineContact = "18001215678"
    static let emailID = "support@spectra.co"
}

// This structer is used for All Tableview Cell Indentifier
struct TableViewCellName {
    static let homeTableViewCell = "HomeCell"
    static let invoiceTableViewCell = "InvoiceCell"
    static let TrasactionTableViewCell = "TrasactionCell"
    static let moreTableViewCell = "MoreCell"
    static let helpTableViewCell = "HelpCell"
    static let srTableViewCell = "SRCell"
    static let notificationTableViewCell = "NotificationCell"
    static let NotificationCellIdentifier = "NotificationCellIdentifier"
    static let canIDTableViewCell = "CANIDCell"
    static let caseTypeTableViewCell = "CaseTypeCell"
    static let mrtgIDTableViewCell = "MrtgCell"
    static let changePlanTableViewCell = "ChangePlanCell"
    static let comparePlanTableViewCell = "comparePlanCell"
    static let faqTableViewCell = "FaqCell"
    static let TopupTableViewCell = "TopupCell"
    static let TopupTableViewCellPlan = "TopCellPlan"
    static let TopupCellIdentifier = "TopupCellIdentifier"
    static let siTableViewCell = "SICell"
    static let manageContactCell = "Cell"
    static let editContactCell = "EditCell"
    static let chatUserMessageCell = "ChatUserMessageCell"
    static let chatBotMessageCell = "ChatBotMessageCell"
    static let KnowMoreTopIdenTifier = "KnowMoreTopIdenTifier"
    static let KnowMoreBottonIdentifier = "KnowMoreBottonIdentifier"
    static let FAQIdentierCell = "FAQIdentierCell"
    static let FAQHeaderTableViewCell = "FAQHeaderTableViewCell"
    static let RecentSerachCell = "RecentSerachCell"
    static let LocalSearchTableViewCell = "LocalSearchTableViewCell"
    static let RecentFAQTableViewCell = "RecentFAQTableViewCell"
}

// This structer is used for all the Alerts Title's
struct AlertViewTitle {
    static let title_Error =   "Error!"
    static let title_Success    =   "Success!"
    static let Logout  =   "Logout"
    static let Delete  =   "Delete"
    static let Alert  =   "Alert!"
    static let resultGenerated = "Result generated"
}

// This structer is used for all the Alert's Button Title
struct AlertViewButtonTitle
{
    static let title_OK = "OK"
    static let title_Switch = "Switch"
    static let Logout  =   "Logout"
    static let Delete  =   "Delete"
    static let Cancel  =   "Cancel"
}

// This structer is used for all the Alert messages
struct AlertViewMessage
{
    static let internetConnection = "Please check your internet connection."
    static let pleaseTryAgain = "Please Try Again."
    static let enterCanIDForgot = "Enter your CAN ID to reset your password"
    static let enterUsernameForgot = "Enter your username to reset your password"
    static let invaliOTP = "Oops! Something has gone wrong.OTP does not match"
    static let notEnterOTP = "OTP cannot be blank"
    static let enterCanID = "Please enter CAN ID"
    static let enterUserName = "Please enter Username"
    static let enterDownloadingSpeed = "Please enter downloading speed"
    static let switchCanId = "This notification is associated with another CANID. You need to switch CANID to proceed."
}

// This structer is used for all the error messages in the app
struct ErrorMessages
{
    static let yearValidation    =     "Please enter valid Year."
    static let endYearValidation    =     "End year should be greater than the start year."
    static let selectOneYear    =     "You can select maximum period of 1 year."
    static let maxLimitAmount = "TDS amount excceded the maximum limit"
    static let ifUserDiniedPermission = "You have denied your permission.So please enable gallery permission from phone setting"
    static let errorMsg    =     "Something is wrong"
    static let noDueAmount    =     "No Due amount for this CanID"
    static let payableAmount    =     "Please enter payable amount."
}

// This structer is used for all the Date Formats Values used in the app
struct DateFormats
{
    static let orderday = "d"
    static let orderYear = "yyyy"
    static let orderYearMonth = "MMMM yyyy"
    static let orderYearAndMonth = "yyyy-MM"
    static let orderOnlyHalfNameMonth = "MMM"
    static let orderDateFormat = "dd/MM/yyyy"
    static let dateFormatOnly = "MMM dd, yyyy"
    static let orderOnlyFullNameMonth = "MMMM"
    static let orderDateTime = "MM-dd-yyyy HH:mm"
    static let orderDateFormatResult = "dd-MM-yyyy"
    static let orderDateTimeFormatResult = "dd-MM-yyyy hh:mm"
    static let dataUsageDateFrmt = "YYYY-MM-dd HH:mm:ss.SS"
    static let orderDateAndTime = "yyyy-MM-dd HH:mm:ss"
    static let orderCurrentDateFormatOutPut = "yyyy-MM-dd"
    static let orderDate12HoursFormate = "MM/dd/yyyy hh:mm:ss a"
    static let orderDate24WithTime = "dd-MM-yyyy HH:mm"
    static let orderDate12WithoutTime = "dd-MM-yyyy"
    
    static let orderTime12 = "hh:mm a"
    
    
    static let orderInvoiceDate = "yyyy-MM-dd'T'HH:mm:ssZ"
    static let orderDateTime24Frmate = "dd/MM/yyyy hh:mm a"
}

struct contactManage {
    static let addNewContact = "Add New Contact"
    static let editContact  = "Edit Contact"
    static let enterName = "Please enter your first name"
    static let enterLastName = "Please enter your last name"
    static let enterEmail = "Please enter your email ID"
    static let enterValidEmail = "Please enter valid email ID"
    
    static let enterMobile = "Please enter your mobile number"
    static let enterValidMobile = "Please enter valid mobile number"
    
    static let enterjobTitle = "Please enter your designation"
    
}
// This structer is used for all Invoice Subject And File name
struct SpectraInvoiceTitle
{
    static let invoiceFileName = "INV_"
    static let invoiceTitle = "Spectra Invoice - "
}

// This structer is used for all Send email status message
struct SpectraSendEmail
{
    static let emailSent = "Sent"
    static let emailCancelled = "User cancelled"
    static let emailFailed = "Sending mail is failed"
    static let emailBySimulator = "Email not configured"
}

// This structer is used for Reactivate SR Service
struct SRCreateCreateCaseType {
    static let reactivateAccount = "I want to re-activate my services"
}

// This structer is used for Create SR Status
struct SRCreatedStatus
{
    static let srRequestSuccessfullySubmit = "Your service request has been submitted successfully. Your service request number is"
    static let cancelledAcntToReactivate = "cancelledAcntToReactivate"
    static let yourServiceNumber = "Your service request number is"
}

// This structer is used for All B2B Profile user title name
struct profileUserB2B
{
    static let userNameD = "Company Name"
    static let userIdD = "CAN ID"
    static let billingAddD = "Billing Address"
    static let BillingContD = "Billing Contact"
    static let techContD = "Technical Contact"
    static let userPhotoStatusD = "Change Profile Picture  "
    static let userPhotoStatusDEmpty = "Upload Profile Picture "
}

// This structer is used for All B2C Profile user title name
struct profileUserB2C
{
    static let userNameD = "Name"
    static let userIdD = "Mobile No"
    static let billingAddD = ""
    static let BillingContD = ""
    static let techContD = ""
}

// This structer is used for Check B2B OR B2C User
struct segment
{
    static let userB2C = "home"
}


// This structer is used for All FAQ B2C questions

// This Structure used for API dependiesis
struct Server
{
    static let api_status = "success"
    static let api_statusFailed = "failure"
    static let srCase_status = "in progress"
    static let plandata_volume = "unlimited"
    static let sr_status = "resolved"
    static let sr_statusCanecled = "canceled"
}

struct Payment
{
    static let success_status = "SUCCESS"
    static let failure_status = "FAILURE"
    static let paymentSuccess_text = "Payment Successful"
    static let paymentFailure_text = "Payment Declined"
    static let paymentBtn_Success = "BACK TO HOME"
    static let paymentBtn_Faluire = "TRY AGAIN"
    static let paymentFailure_Message = "We were unable to process your payment."
}

struct UserDefaultKeys{
    
    static let isLoginFrom = "isLoginFrom"
    static let mobileNumber = "mobileNumber"
    static let canID = "canID"
    
    static let loginPhoneNumber = "loginPhoneNumber"
}


struct AnalyticsEventsName
{
    static let registeredMobileNumber = "login_rmn"
    static let login_user_pwd = "login_user_pwd"
    static let forgot_password = "forgot_password"
    static let otp_validation = "otp_validation"
    static let otp_resend = "otp_resend"
    
    //New
    static let pay_Now = "Pay_Now"
    static let notification_Open = "Notification_Open"
    static let compare_Plan = "Compare_Plan"
    static let Compare_Plan_Proceed = "Compare_Plan_Proceed"
    static let add_new_CanID = "Add_new_CanID"
    static let home_Search = "Home_Search"
    static let help_Search = "Help_Search"
    static let help_View_Topics = "Help_View_Topics"
    static let pay_advance = "Pay_advance"
    static let faq_Topic_Clicked = "FAQ_Topic_Clicked"

    
    
    // Deshroard
    static let view_all_service_requests = "view_all_service_requests"
    static let view_details = "view_details"
    static let menu_click_home = "menu_click_home"
    static let menu_click_payments = "menu_click_payments"
    static let menu_click_my_sr = "menu_click_my_sr"
    static let menu_click_menu = "menu_click_menu"
    static let menu_click_my_plan = "menu_click_my_plan"
    static let menu_click_change_plan = "menu_click_change_plan"
    static let menu_click_my_transactions = "menu_click_my_transactions"
    static let menu_click_auto_pay = "menu_click_auto_pay"
    static let menu_click_my_account = "menu_click_my_account"
    static let menu_click_data_usage = "menu_click_data_usage"
    static let menu_click_pay_for_anaother_account = "menu_click_pay_for_anaother_account"
    static let menu_click_get_help = "menu_click_get_help"
    static let menu_click_get_help_faq = "menu_click_faq"
    static let menu_click_get_help_create_sr = "menu_click_get_help_create_sr"
    static let menu_click_get_help_contact_us = "menu_click_get_help_contact_us"
    static let menu_click_get_help_privacy_policy = "menu_get_help_privacy_policy"
    static let menu_click_get_help_legal_disclaimer = "menu_get_help_legal_disclaimer"
    
    //service Request
    static let service_request_know_more = "service_request_know_more"
    static let raise_new_service_request = "raise_new_service_request"
    static let search_by_sr_number = "search_by_sr_number"
    static let raise_new_service_request_Submit = "raise_new_service_request_Submit"
    
    //Payment
    static let view_invoice_details = "view_invoice_details"
    static let apply_invoice_filter = "apply_invoice_filter"
    static let share_invoice_via_email = "share_invoice_via_email"
    static let share_invoice_details = "share_invoice_details"
    static let apply_filter_trancations = "apply_filter_trancations"
    
    //Change plan
    static let change_plan_click = "change_plan_click"
    static let change_plan_select = "change_plan_click"
    static let change_plan_success = "change_plan_success"
    static let change_plan_canceled = "change_plan_canceled"
    static let change_plan_failed = "change_plan_failed"
    
    //My Account
    
    static let change_account = "change_account"
    static let my_account_reset_password = "my_account_reset_password"
    static let manage_contact = "manage_contact"
    static let upload_profile_picture = "upload_profile_picture"
    static let edit_profile = "edit_profile"
    static let reset_password_success = "reset_password_success"
    static let reset_password_cancel = "reset_password_cancel"
    static let edit_contact_success = "edit_contact_success"
    static let edit_contact_failed = "edit_contact_failed"
    static let add_contact_success = "add_contact_success"
    static let add_contact_failed = "add_contact_failed"
    
    //Get help section
    static let faq_selected = "faq_selected"
}

struct AnalyticsEventsCategory
{
    static let Login = "login"
    static let dashboard = "dashboard"
    static let home = "Home"
    static let Payments = "Payments"
    static let dashboard_menu = "dashboard_menu"
    static let service_request = "service_request"
    static let payment_invoices = "payment_invoices"
    static let change_plan = "change_plan"
    static let my_account = "my_account"
    static let my_account_manage_contact = "my_account_manage_contact"
    static let get_help = "Get Help"
    static let all_Menu = "All menu"
    static let get_help_faq = "Get Help - FAQ"
    static let all_Menu_MyAccount = "All menu - My account"
    
    
    
}

struct AnalyticsEventsActions
{
    static let registeredMobileNumber = "registered_mobile_number"
    static let username_password = "username_password"
    static let can_id = "can_id"
    static let username = "username"
    static let otp_validation = "otp_validation"
    static let otp_resend = "otp_resend"
    
    //Home
    static let payNowClick = "Pay now clicked"
    static let payInAdvanceClick = "Pay in Advance"
    static let notificationClicked = "Notification clicked"
    static let comparePlanClicked = "Compare plan clicked"
    static let comparePlanProceedClicked = "Compare plan proceed clicked"
    static let newCanIDAdded = "New Can ID added"
    static let searchTopic = "Search - {"
    static let viewAllTopicsClicked = "View all topics clicked"
    static let serviceRequestClicked = "Service request clicked"
    
    // Deshroard
    
    static let view_all_service_request_click = "view_all_service_request_click"
    static let view_details = "view_details"
    static let menu_home = "menu_home"
    static let menu_payments = "menu_payments"
    static let menu_my_sr = "menu_my_sr"
    static let menu_all_menu = "menu_all_menu"
    static let menu_my_plan = "menu_my_plan"
    static let menu_change_plan = "menu_change_plan"
    static let menu_my_transactions = "menu_my_transactions"
    static let menu_auto_pay = "menu_auto_pay"
    static let menu_my_account = "menu_my_account"
    static let menu_data_usage = "menu_data_usage"
    static let menu_pay_for_another = "menu_pay_for_another"
    static let menu_get_help = "menu_get_help"
    static let menu_get_help_faq = "menu_get_help_faq"
    static let menu_get_help_create_sr = "menu_get_help_create_sr"
    static let menu_get_help_contact_us = "menu_get_help_contact_us"
    static let menu_get_help_privacy_policy = "menu_get_help_privacy_policy"
    static let menu_get_help_legal_disclaimer = "menu_get_help_legal_disclaimer"
    
    //service Request
    static let know_more_click = "know_more_click"
    static let raise_new_service_request = "raise_new_service_request"
    static let search = "search"
    static let raise_new_service_request_Submit = "raise_new_service_request_Submit"
    //Payment
    static let payment_invoices = "payment_invoices"
    static let Email_share = "Invoice shared - Email"
    static let invoiceShare = "Invoice details shared"
    static let payment_transactions = "payment_transactions"
    static let transectionFilter = "Transactions Filter"
    
    //Change plan
    static let change_plan_click = "change_plan_click"
    static let change_plan_select = "change_plan_select"
    static let change_plan_success = "change_plan_success"
    static let change_plan_canceled = "change_plan_canceled"
    static let change_plan_failed = "change_plan_failed"
    
    //My Account
    
    static let change_account = "change_account"
    static let reset_password = "reset_password"
    static let manage_contact = "manage_contact"
    static let upload_profile_picture = "upload_profile_picture"
    static let edit_profile_click = "edit_profile_click"
    static let reset_password_success = "reset_password_success"
    static let reset_password_cancel = "reset_password_cancel"
    
    static let edit_contact_success = "edit_contact_success"
    static let edit_contact_failed = "edit_contact_failed"
    static let add_contact_success = "add_contact_success"
    static let add_contact_failed = "add_contact_failed"
    
    //Get help section
    static let faq_selected = "faq_selected"
    static let get_help_clicked = "Get help clicked"
    
    
    
}
struct AnanlysicParameters{
    
    static let Category = "Category"
    static let canID = "CanID"
    static let Action = "Action"
    static let EventDescription = "Event_description"
    static let EventType = "Event_type"
    
    static let ClickEvent = "Click_event"
}
struct AnanlysicEventDescprion{
    
    static let registeredMobileNumber = "Login%20via%20registered%20mobile%20number"
    static let loginwithUserNamePassword = "login%20via%20username/password"
    static let forgotPassword = "Forgot%20password"
    static let OTPValidation = "OTP%20validation"
    static let OTPResend = "OTP%20resend"
    
}
struct LocalSearch {
    static let  home =  "Home/My Account/Account/My SR/SR/Raise new SR/Service request/Bill/Invoice/Payment/Data/Data consumed/Data check/Data volume/My Account/Mobile no/My address/Reset Password/Manage Contact/Another account/RMN/Registered Mobile no/Mobile no/Contact details/Contact/Address/Password/Plan details/Data/Speed/Invoice/Bill/Payment/New Plan/Upgrade/Customer name/Can id/RMN/Registered no/Registered Mobile Number/Mobile no/Contact no/Address/Phone no/Email id/Change/Payment/Payment receipt/Pay/Payment/AutoPay/Set up /Auto debit/Customer name/Can id/RMN/Registered no/Registered Mobile Number/Mobile no/Contact no/Address/Phone no/Email id/Change/TopUp/New Top Up/Data required/TopUp status/Add Another Account/Add another CAN id/Attach another account/New account/Add Can id/Pay/Payment/AutoPay/Set up /Auto debitSwitch account/My Profile/View Usage/Usage/View data/data/Data consumed/Data check/Data volume/payment/option/new plan/bill cycle/check my bill/change plan/tariff/self care portal/self care/shift different room/shift within the society/transfer ownership/transfer/FUP/FTTH/symmetric speed/asymmetric bandwidth/IP address/static/dynamic/service availability/GB data/data consumed/check usage/identify proof/address/Wi-Fi/router/spectra voice"
    static let switchAccount = "Menu- My Account"
    static let viewSR = "My SR/SR/Raise new SR/Service request"
    static let voiceList =  "Bill/Invoice/Payment"
    static let profile = "My Account/Mobile no/My address/Reset Password/Manage Contact/Another account"
    static let viewUseage = "Data/Data consumed/Data check/Data volume"
    static let loginWithMobile = "RMN/Registered Mobile no/Mobile no/Contact details"
    static let myPlan = "Plan details/Data/Speed/Invoice/Bill/Payment/New Plan/Upgrade"
    static let viewTranaction = "Payment/Payment receipt"
    static let viewTopUp = "Top Up/Upgrade"
    static let loginWithUSername  = "Login/credential/User name/Password"
    static let autopayStatus  =  "Pay/Payment/AutoPay/Set up /Auto debit/"
    static let ViewContact = "Customer name/Can id/RMN/Registered no/Registered Mobile Number/Mobile no/Contact no/Address/Phone no/Email id/Change"
    static let viewMRTG = "Utilisation/Data usage/Bandwidth usage"
    static let  viewPlanChangeOffer =   "Plan details/Data/Speed/Invoice/Bill/Payment/New Plan/Upgrade/Plan change/New offre/New scheme"
    static let   forgotPassword  =  "Password/Reset Password/OTP password/Change Password"
    static let  createSR  =  "Raise SR/New SR/Complaint/Issue/Raise concern"
    static let  trackMyOrder  =  "Account status/My account"
    static let  changePassword  =   "Password/Reset Password/OTP password/Change Password"
    static let   UpdateMobileNumber  =   "RMN/Registered Mobile no/Mobile no/Contact details /Update New no/Update Phone No/Update contact details"
    static let   UpdateEmailId  =  "Email id/Registered Email id/New Email id/Change Email id"
    static let  topUpAvailed  =   "TopUp/New Top Up/Data required/TopUp status"
    static let  linkMultipleAccounts =   "Add Another Account/Add another CAN id/Attach another account/New account/Add Can id"
    static let  updateContactDetails  =   "RMN/Registered Mobile no/Mobile no/Contact details /Update New no/Update Phone No/Update contact details"
    static let  addContact  =  "RMN/Registered Mobile no/Mobile no/Contact details /Update New no/Update Phone No/Update contact details"
    static let  addAutopay =   "Pay/Payment/AutoPay/Set up /Auto debit"
    static let  faq =   "data/Data consumed/Data check/Data volume/payment/option/new plan/bill cycle/check my bill/change plan/tariff/self care portal/self care/shift different room/shift within the society/transfer ownership/transfer/FUP/FTTH/symmetric speed/asymmetric bandwidth/IP address/static/dynamic/service availability/GB data/data consumed/check usage/identify proof/address/Wi-Fi/router/spectra voice"
    
}
