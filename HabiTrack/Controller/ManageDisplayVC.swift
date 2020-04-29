//
//  ManageDisplayVC.swift
//  HabiTrack
//
//  Created by Gavin Daniel on 10/24/19.
//  Copyright © 2019 Gavin Daniel. All rights reserved.
//

import Foundation
import UIKit


// name: ManageDisplayVC
// desc: display manage view controller class
// last updated: 4/28/2020
// last update: cleaned up
class ManageDisplayVC: UIViewController {
    // variables
    var manageColorCV: ManageColorCV?
    // IBOutlet connections
    @IBOutlet weak var colorUICollectionView: UICollectionView!
    @IBOutlet weak var closeUIButton: UIButton!
    @IBOutlet weak var saveDispUIButton: UIButton!
    @IBOutlet weak var repeatUISwitch: UISwitch!
    @IBOutlet weak var longestUISwitch: UISwitch!
    
    
    // name: viewDidAppear
    // desc:
    // last updated: 4/28/2020
    // last update: cleaned up
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        debugPrint("JournalVC", "viewDidAppear", "start", false)
        manageColorCV?.updateUICollectionView(colorUICollectionView)
        debugPrint("JournalVC", "viewDidAppear", "end", false)
    }

    
    // name: viewDidLoad
    // desc:
    // last updated: 4/28/2020
    // last update: cleaned up
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        debugPrint("JournalVC", "viewDidLoad", "start", false)
        // turn the switches on/off
        self.repeatUISwitch.isOn = getShowRepeatLabel()
        self.longestUISwitch.isOn = getShowLongestLabel()
        // initialize views
        self.manageColorCV = ManageColorCV(colorUICollectionView: colorUICollectionView)
        // set the dataSource and delegate
        self.colorUICollectionView.dataSource = manageColorCV
        self.colorUICollectionView.delegate = manageColorCV
        debugPrint("JournalVC", "viewDidLoad", "end", false)
    }
    
    
    // name: viewWillAppear
    // desc:
    // last updated: 4/28/2020
    // last update: cleaned up
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        debugPrint("JournalVC", "viewWillAppear", "start", false)
        closeUIButton?.tintColor = getColor("System")
        saveDispUIButton?.tintColor = getColor("System")
        // reload the views
        self.colorUICollectionView.reloadData()
        debugPrint("JournalVC", "viewWillAppear", "end", false)
    }
    
    
    // name: traitCollectionDidChange
    // desc:
    // last updated: 4/28/2020
    // last update: cleaned up
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        debugPrint("JournalVC", "traitCollectionDidChange", "start", false)
        // check if change from light/dark mode
        if #available(iOS 13, *), traitCollection.hasDifferentColorAppearance(comparedTo: previousTraitCollection) {
            // handle theme change here.
        }
        self.colorUICollectionView.reloadData()
        debugPrint("JournalVC", "traitCollectionDidChange", "end", false)
    }
    
    
    // name: closeManageView
    // desc:
    // last updated: 4/28/2020
    // last update: cleaned up
    @IBAction func closeManageView(_ sender: AnyObject) {
        debugPrint("JournalVC", "closeManageView", "start", false)
        UITabBar.appearance().tintColor = getColor("System")
        dismiss(animated: true, completion: nil)
        debugPrint("JournalVC", "closeManageView", "end", false)
    }
    
    
    // name: hideRepeatLabel
    // desc:
    // last updated: 4/28/2020
    // last update: cleaned up
    @IBAction func hideRepeatLabel(_ sender: AnyObject) {
        debugPrint("JournalVC", "hideRepeatLabel", "start", false)
        toggleShowRepeatLabel()
        debugPrint("JournalVC", "hideRepeatLabel", "end", false)
    }
    
    
    // name: hideLongestLabel
    // desc:
    // last updated: 4/28/2020
    // last update: cleaned up
    @IBAction func hideLongestLabel(_ sender: AnyObject) {
        debugPrint("JournalVC", "hideLongestLabel", "start", false)
        toggleShowLongestLabel()
        debugPrint("JournalVC", "hideLongestLabel", "end", false)
    }
}
