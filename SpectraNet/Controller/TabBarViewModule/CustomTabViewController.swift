//
//  CustomTabViewController.swift
//  SpectraNet
//
//  Created by Yugasalabs-28 on 23/07/2019.
//  Copyright © 2019 Bhoopendra. All rights reserved.
//

import UIKit

class CustomTabViewController: UITabBarController {
    
    var tabBarItems = UITabBarItem()
    
    //MARK: View controller life cycle
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        UITabBarItem.appearance().setTitleTextAttributes([NSAttributedString.Key.font: UIFont(name: "HelveticaNeue-medium", size: 18)!], for: .normal)
        UITabBarItem.appearance().setTitleTextAttributes([NSAttributedString.Key.font: UIFont(name: "HelveticaNeue-medium", size: 18)!], for: .selected)
        
        UITabBarItem.appearance().setTitleTextAttributes([NSAttributedString.Key.foregroundColor : UIColor(red: 255.0/255.0, green: 108.0/255.0, blue: 102.0/255.0, alpha: 1.0)], for: .selected)
        UITabBarItem.appearance().setTitleTextAttributes([NSAttributedString.Key.foregroundColor : UIColor.darkGray], for: .normal)

        let selectedImg1 = UIImage(named: "HomeIcn")?.withRenderingMode(.alwaysOriginal)
        let deselectedImg1 = UIImage(named: "HomeIcn")?.withRenderingMode(.alwaysTemplate)
        tabBarItems = self.tabBar.items![0]
        tabBarItems.image = deselectedImg1
        tabBarItems.selectedImage = selectedImg1
        
        let selectedImg2 = UIImage(named: "tabInvoice")?.withRenderingMode(.alwaysOriginal)
        let deselectedImg2 = UIImage(named: "tabInvoice")?.withRenderingMode(.alwaysTemplate)
        tabBarItems = self.tabBar.items![1]
        tabBarItems.image = deselectedImg2
        tabBarItems.selectedImage = selectedImg2
        
        let selectedImg3 = UIImage(named: "tabSR")?.withRenderingMode(.alwaysOriginal)
        let deselectedImg3 = UIImage(named: "tabSR")?.withRenderingMode(.alwaysTemplate)
        tabBarItems = self.tabBar.items![2]
        tabBarItems.image = deselectedImg3
        tabBarItems.selectedImage = selectedImg3
        
        let selectedImg4 = UIImage(named: "tabMenu")?.withRenderingMode(.alwaysOriginal)
        let deselectedImg4 = UIImage(named: "tabMenu")?.withRenderingMode(.alwaysTemplate)
        tabBarItems = self.tabBar.items![3]
        tabBarItems.image = deselectedImg4
        tabBarItems.selectedImage = selectedImg4

        if    AppDelegate.sharedInstance.navigateFrom==TabViewScreenName.Payment
         {
            self.selectedIndex = 1
        }
        else if (AppDelegate.sharedInstance.navigateFrom==TabViewScreenName.sr)
        {
            self.selectedIndex = 2
        }
        else if (AppDelegate.sharedInstance.navigateFrom==TabViewScreenName.menu)
        {
            self.selectedIndex = 3
        }
        else
        {
            self.selectedIndex = 0
        }
    }
  
}

