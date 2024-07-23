//
//  ContactUSViewController.swift
//  SpectraNet
//
//  Created by Bhoopendra on 9/5/19.
//  Copyright © 2019 Bhoopendra. All rights reserved.
//

import UIKit
import MessageUI


class ContactUSViewController: UIViewController,MFMailComposeViewControllerDelegate {
   
    @IBOutlet weak var lblNewConnection: UILabel!
    @IBOutlet weak var lblSupportLine: UILabel!
    @IBOutlet weak var lblEmailAdd: UILabel!
    
    //MARK: View controller life cycle
    override func viewDidLoad()
    {
        super.viewDidLoad()
        lblNewConnection.text = contactUsData.newConnectionContact
        lblSupportLine.text = contactUsData.supportLineContact
        lblEmailAdd.text = contactUsData.emailID
    }
    
    //MARK: Button Action
    @IBAction func backBTN(_ sender: Any)
    {
        self.navigationController?.popViewController(animated: false)
    }
  
    //MARK: New Connection Call
    @IBAction func newConnectionCall(_ sender: Any) {
        
        guard let number1 = URL(string: "tel://" + contactUsData.newConnectionContact) else { return }
        UIApplication.shared.open(number1)
    }
    
    //MARK: Support Line Call
    @IBAction func supportLinecall(_ sender: Any) {
        guard let number2 = URL(string: "tel://" + contactUsData.supportLineContact) else { return }
        UIApplication.shared.open(number2)
    }
    
    //MARK: Send Email 
    @IBAction func sendEmailBTN(_ sender: Any)
    {
        if MFMailComposeViewController.canSendMail()
        {
            let mail = MFMailComposeViewController()
            mail.mailComposeDelegate = self
            mail.setToRecipients([contactUsData.emailID])
            present(mail, animated: true, completion: nil)
        } else {
            showAlertC(message: SpectraSendEmail.emailBySimulator)
        }
    }
    
    //MARK: MailComposer delegate
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        switch result.rawValue {
        case MFMailComposeResult.cancelled.rawValue:
            showAlertC(message: SpectraSendEmail.emailCancelled)

        case MFMailComposeResult.saved.rawValue:
            print_debug(object: "Saved")
        case MFMailComposeResult.sent.rawValue:
            showAlertC(message: SpectraSendEmail.emailSent)
        case MFMailComposeResult.failed.rawValue:
            showAlertC(message: String(describing: error?.localizedDescription))
            print_debug(object: "Error: \(String(describing: error?.localizedDescription))")
        default:
            break
        }
        controller.dismiss(animated: true, completion: nil)
    }
}
