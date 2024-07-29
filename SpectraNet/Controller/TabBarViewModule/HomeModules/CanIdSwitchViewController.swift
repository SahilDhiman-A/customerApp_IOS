//
//  CanIdSwitchViewController.swift
//  My Spectra
//
//  Created by Chakshu on 13/01/21.
//  Copyright © 2021 Bhoopendra. All rights reserved.
//

import UIKit
typealias v2CB = (_ infoToReturn :String) ->()

class CanIdSwitchViewController: UIViewController {
    @IBOutlet weak var titleLabel: UILabel!
    var canID = String()
   
    var completionBlock:v2CB?
    var notFirstTime = false
    override func viewDidLoad() {
        super.viewDidLoad()
        titleLabel.text = "This notification is associated with another CAN ID: \(self.canID). You need to switch CAN ID to proceed."
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        super.viewWillAppear(animated)
        
       
    }
    
    
    @IBAction func backButton(sender: UIButton!) {
        
        self.dismiss(animated: false, completion: nil)
    }
    
    @IBAction func switchButtonClick(sender: UIButton!) {
        
        self.dismiss(animated: false) {
            guard let cb = self.completionBlock else {return}
            cb("any value")
        }
        
        
       
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
