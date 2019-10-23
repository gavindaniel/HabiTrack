//
//  TabBarVC.swift
//  HabiTrack
//
//  Created by Gavin Daniel on 10/21/19.
//  Copyright © 2019 Gavin Daniel. All rights reserved.
//

import Foundation
import UIKit

class TabBarVC: UITabBarController, UITabBarControllerDelegate {
    
    @IBOutlet weak var mainUITabBar: UITabBar!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Assign self for delegate for that ViewController can respond to UITabBarControllerDelegate methods
        self.delegate = self
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Create Tab one
        let tabOne = JournalVC()
        if #available(iOS 13.0, *) {
            let tabOneBarItem = UITabBarItem(title: "Journal", image: UIImage(systemName: "list.bullet"), selectedImage: UIImage(systemName: "list.bullet"))
            tabOne.tabBarItem = tabOneBarItem
        } else {
            // Fallback on earlier versions
        }
        
        
        
        
        // Create Tab two
        let tabTwo = SettingsVC()
        if #available(iOS 13.0, *) {
            let tabTwoBarItem2 = UITabBarItem(title: "Settings", image: UIImage(systemName: "gear"), selectedImage: UIImage(systemName: "gear"))
            tabTwo.tabBarItem = tabTwoBarItem2
        } else {
            // Fallback on earlier versions
        }
        
        
        // Create Tab two
        let tabThree = DevelopmentVC()
        if #available(iOS 13.0, *) {
            let tabThreeBarItem3 = UITabBarItem(title: "Development", image: UIImage(systemName: "chevron.left.slash.chevron.right"), selectedImage: UIImage(systemName: "chevron.left.slash.chevron.right"))
            tabThree.tabBarItem = tabThreeBarItem3
        } else {
            // Fallback on earlier versions
        }
        
        self.viewControllers = [tabOne, tabTwo, tabThree]
    }
    
    // UITabBarControllerDelegate method
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        print("Selected \(viewController.title!)")
    }
    
}
