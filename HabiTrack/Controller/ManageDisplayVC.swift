//
//  ManageDisplayVC.swift
//  HabiTrack
//
//  Created by Gavin Daniel on 10/24/19.
//  Copyright © 2019 Gavin Daniel. All rights reserved.
//

import Foundation
import UIKit

class ManageDisplayVC: UIViewController {
    
    
    @IBOutlet weak var closeUIButton: UIButton!
    @IBOutlet weak var repeatUISwitch: UISwitch!
    @IBOutlet weak var longestUISwitch: UISwitch!
    
    
    // load : viewDidAppear
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        print()
        print("viewDidAppear...")
        print()
    }

    // load : viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        print()
        print("viewDidLoad...")
        print()
        
        // testing
        self.repeatUISwitch.isOn = getShowRepeatLabel()
        self.longestUISwitch.isOn = getShowLongestLabel()
        
    }
    
    // load : viewWillAppear
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        print()
        print("viewWillAppear...")
        print()
        closeUIButton?.tintColor = getSystemColor()
        // reload the views
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        print()
        print("traitCollectionDidChange")
        print()
        // check if change from light/dark mode
        if #available(iOS 13, *), traitCollection.hasDifferentColorAppearance(comparedTo: previousTraitCollection) {
            // handle theme change here.
        }
    }
    
    @IBAction func closeManageView(_ sender: AnyObject) {
        UITabBar.appearance().tintColor = getSystemColor()
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func hideRepeatLabel(_ sender: AnyObject) {
        toggleShowRepeatLabel()
    }
    @IBAction func hideLongestLabel(_ sender: AnyObject) {
        toggleShowLongestLabel()
    }
}
