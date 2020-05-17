//
//  ManageDisplayVC.swift
//  HabiTrack
//
//  Created by Gavin Daniel on 10/24/19.
//  Copyright © 2019 Gavin Daniel. All rights reserved.
//

import Foundation
import UIKit


// name: CustomizeVC
// desc: display manage view controller class
// last updated: 4/28/2020
// last update: cleaned up
class CustomizeVC: UIViewController {
    // variables
    var manageColorCV: ManageColorCV?
    var customizeTV: CustomizeTV?
    // IBOutlet connections
    @IBOutlet weak var journalUITableView: UITableView!
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
        debugPrint("ManageDisplayVC", "viewDidAppear", "start", true)
        self.colorUICollectionView.reloadData()
        self.journalUITableView.reloadData()
        debugPrint("ManageDisplayVC", "viewDidAppear", "end", true)
    }

    
    // name: viewDidLoad
    // desc:
    // last updated: 4/28/2020
    // last update: cleaned up
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        debugPrint("ManageDisplayVC", "viewDidLoad", "start", false)
        // turn the switches on/off
        self.repeatUISwitch.isOn = getShowRepeatLabel()
        self.longestUISwitch.isOn = getShowLongestLabel()
        // initialize views
        self.manageColorCV = ManageColorCV(colorUICollectionView: colorUICollectionView)
        self.customizeTV = CustomizeTV(journalUITableView)
        // set the dataSource and delegate
        self.colorUICollectionView.dataSource = manageColorCV
        self.colorUICollectionView.delegate = manageColorCV
        self.journalUITableView.dataSource = customizeTV
        self.journalUITableView.delegate = customizeTV
        debugPrint("ManageDisplayVC", "viewDidLoad", "end", false)
    }
    
    
    // name: viewWillAppear
    // desc:
    // last updated: 4/28/2020
    // last update: cleaned up
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        debugPrint("ManageDisplayVC", "viewWillAppear", "start", false)
        closeUIButton?.tintColor = getColor("System")
        saveDispUIButton?.tintColor = getColor("System")
        // reload the views
        self.colorUICollectionView.reloadData()
        self.journalUITableView.reloadData()
        debugPrint("ManageDisplayVC", "viewWillAppear", "end", false)
    }
    
    
    // name: traitCollectionDidChange
    // desc:
    // last updated: 4/28/2020
    // last update: cleaned up
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        debugPrint("ManageDisplayVC", "traitCollectionDidChange", "start", true)
        // check if change from light/dark mode
        if #available(iOS 13, *), traitCollection.hasDifferentColorAppearance(comparedTo: previousTraitCollection) {
            // handle theme change here.
        }
        self.colorUICollectionView.reloadData()
        self.journalUITableView.reloadData()
        debugPrint("ManageDisplayVC", "traitCollectionDidChange", "end", true)
    }
    
    
    // name: closeManageView
    // desc:
    // last updated: 4/28/2020
    // last update: cleaned up
    @IBAction func cancelChanges(_ sender: AnyObject) {
        debugPrint("ManageDisplayVC", "cancelChanges", "start", false)
//        UITabBar.appearance().tintColor = getColor("System")
        dismiss(animated: true, completion: nil)
        debugPrint("ManageDisplayVC", "cancelChanges", "end", false)
    }
    
    
    // name: hideRepeatLabel
    // desc:
    // last updated: 4/28/2020
    // last update: cleaned up
    @IBAction func hideRepeatLabel(_ sender: AnyObject) {
        debugPrint("ManageDisplayVC", "hideRepeatLabel", "start", false)
        toggleShowRepeatLabel()
        debugPrint("ManageDisplayVC", "hideRepeatLabel", "end", false)
    }
    
    
    // name: hideLongestLabel
    // desc:
    // last updated: 4/28/2020
    // last update: cleaned up
    @IBAction func hideLongestLabel(_ sender: AnyObject) {
        debugPrint("ManageDisplayVC", "hideLongestLabel", "start", false)
        toggleShowLongestLabel()
        debugPrint("ManageDisplayVC", "hideLongestLabel", "end", false)
    }
    
    
    // name: saveChanges
    // desc:
    // last updated: 5/1/2020
    // last update: cleaned up
    @IBAction func saveChanges(_ sender: Any) {
        debugPrint("ManageColorCV", "saveChanges", "start", false)
        let defaultColor = getColor("System")
        let selectedColor = getColor(colorSelected)
        if (defaultColor != selectedColor) {
            UserDefaults.standard.set(colorSelected, forKey: "defaultColor")
        }
        self.colorUICollectionView.reloadData()
        self.journalUITableView.reloadData()
        debugPrint("ManageColorCV", "saveChanges", "end", false)
//        UITabBar.appearance().tintColor = getColor("System")
//        dismiss(animated: true, completion: nil)
        exit(-1)
    }
    
    
    // name: updateButtons
    // desc:
    // last updated: 5/16/2020
    // last update: new
    func updateButtons() {
//        self.saveDispUIButton.setTitleColor(getColor(colorSelected), for: .normal)
//        self.closeUIButton.setTitleColor(getColor(colorSelected), for: .normal)
    }
}
