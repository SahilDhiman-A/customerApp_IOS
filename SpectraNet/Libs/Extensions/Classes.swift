//
//  Classes.swift
//  SpectraNet
//
//  Created by Bhoopendra on 9/18/19.
//  Copyright © 2019 Bhoopendra. All rights reserved.
//

import Foundation

extension UIViewController
{
   func noInternetCheckScreenWithMessage(errorMessage: String)
    {
        let vc = UIStoryboard.init(name: "StoryboardMain", bundle: Bundle.main).instantiateViewController(withIdentifier: ViewIdentifier.NoInternetIdentifier) as? NoInternetViewController
        vc?.errorMsg = errorMessage
        self.navigationController?.pushViewController(vc!, animated: false)
    }
    
    func privacPolicyView(withLink: String)
    {
        if ConnectionCheck.isConnectedToNetwork() == true
        {
            let vc = UIStoryboard.init(name: "StoryboardMain", bundle: Bundle.main).instantiateViewController(withIdentifier: ViewIdentifier.privacyIdentifier) as? PrivacyPolicyViewController
            vc?.webViewlink = withLink
            self.navigationController?.pushViewController(vc!, animated: false)
        }
        else
        {
            noInternetCheckScreenWithMessage(errorMessage:"")
        }
    }
    
    func chnagePlanScreen(WithCanID: String, pckgID: String,typeOf:String)
    {
        let vc = UIStoryboard.init(name: "Storyboard", bundle: Bundle.main).instantiateViewController(withIdentifier: ViewIdentifier.changePlaneIndetifier) as? ChangePlanViewController
        vc?.canID = WithCanID
        vc?.pckgID = pckgID
        vc?.typeOfUpgrade = typeOf
        self.navigationController?.pushViewController(vc!, animated: false)
    }
    
    func topupScreen(WithCanID: String, pckgID: String)
       {
           let vc = UIStoryboard.init(name: "Storyboard", bundle: Bundle.main).instantiateViewController(withIdentifier: ViewIdentifier.topupIdentifier) as? TopupPlanViewController
           vc?.canID = WithCanID
           vc?.basePlan = pckgID
           self.navigationController?.pushViewController(vc!, animated: false)
       }
    
    
    func consumedTopupScreen(WithCanID: String, pckgID: String)
    {
        let vc = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: ViewIdentifier.ConsumedTopupPlanVC) as? ConsumedTopUpViewController
        vc?.canID = WithCanID
        vc?.basePlan = pckgID
        self.navigationController?.pushViewController(vc!, animated: false)
    }
    
    func goPyamentScreen(postStr: String)
      {
            let vc = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: ViewIdentifier.paymentScreenIdentifier) as? PaymentScreenViewController
            vc?.postString = postStr
            self.navigationController?.pushViewController(vc!, animated: false)
      }
    
    func goPayNowScreen(canID: String, outstandingAmt: String, tdsAmt: String, tdsPrcnt: String, ifFromTopup:String)
    {
        
        
        let vc = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: ViewIdentifier.PayNowIdentifier) as? PayNowViewController
        vc?.outStandingAmt = outstandingAmt
        vc?.tdsAmount = tdsAmt
        vc?.tdsPercent = tdsPrcnt
        vc?.canID = canID
        vc?.screenFrom = ifFromTopup
        self.navigationController?.pushViewController(vc!, animated: false)
    }
    
    func goCreateSRScreen(fromScreen: String)
       {
           let vc = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: ViewIdentifier.CreateSRIdentifier) as? CreateSRViewController
           vc?.screenFrom = fromScreen
           self.navigationController?.pushViewController(vc!, animated: false)
       }
    
//    func goEditProfileScreen(userName: String,canID: String, userDict: NSDictionary,gst: String, tan: String)
//    {
//        let vc = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: ViewIdentifier.editProfileIdentifier) as? EditProfileViewController
//        vc?.userDict = userDict
//        vc?.userName = userName
//        vc?.canID = canID
//        vc?.gstNumber = gst
//        vc?.tanNumber = tan
//        self.navigationController?.pushViewController(vc!, animated: false)
//    }
//
    func goEditProfileScreen(userName: String,canID: String)
       {
           let vc = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: ViewIdentifier.editProfileIdentifier) as? EditProfileViewController
           vc?.userName = userName
           vc?.canID = canID
           self.navigationController?.pushViewController(vc!, animated: false)
       }
     
    
    
    func siPrivacyPolicyScreen()
    {
        let vc = UIStoryboard.init(name: "StoryboardMain", bundle: Bundle.main).instantiateViewController(withIdentifier: ViewIdentifier.siTermCondition) as? SIPrivacyPolicyViewController
        self.navigationController?.present(vc!, animated: true, completion: nil)
    }
    
    func manageContactsScreen(canID: String)
    {
        let vc = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: ViewIdentifier.manageContactIdentifier) as? ManageContactsViewController
        vc?.canID = canID
        self.navigationController?.pushViewController(vc!, animated: false)
    }
    
    func navigateScreen(identifier: String, controller: UIViewController.Type)
    {
        let vc = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: identifier)
        self.navigationController?.pushViewController(vc, animated: false)
    }
    func navigateScreenToStoryboard(identifier: String, controller: UIViewController.Type)
    {
        let vc = UIStoryboard.init(name: "Storyboard", bundle: Bundle.main).instantiateViewController(withIdentifier: identifier)
        self.navigationController?.pushViewController(vc, animated: false)
    }
    func navigateScreenToStoryboardMain(identifier: String, controller: UIViewController.Type)
    {
        let vc = UIStoryboard.init(name: "StoryboardMain", bundle: Bundle.main).instantiateViewController(withIdentifier: identifier)
        self.navigationController?.pushViewController(vc, animated: false)
    }
}
