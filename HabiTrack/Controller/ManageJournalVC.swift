//
//  ManageJournalVC.swift
//  HabiTrack
//
//  Created by Gavin Daniel on 10/18/19.
//  Copyright © 2019 Gavin Daniel. All rights reserved.
//

import Foundation
import SQLite

class ColorCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var colorUIImageView: UIImageView!
}

class ManageHabitsTVCell: UITableViewCell {
    @IBOutlet weak var habitNameUILabel: UILabel!
    @IBOutlet weak var habitRepeatUILabel: UILabel!
}

class ManageJournalVC: UIViewController {
    
    var journal = Journal()
    var manageHabitsTV: ManageHabitsTV?
    
    @IBOutlet weak var manageUIView: UIView!
    @IBOutlet weak var manageUITableView: UITableView!
    @IBOutlet weak var closeUIButton: UIButton!
    @IBOutlet weak var saveHabitsUIButton: UIButton!
    @IBOutlet weak var customDispUIButton: UIButton!
    
    
    // load : viewDidAppear
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
//        print()
//        print("viewDidAppear...")
//        print()
        // update views
        manageHabitsTV?.updateTableView(manageUITableView)
    }

    // load : viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
//        print()
//        print("viewDidLoad...")
//        print()
        
        // initialize views
        self.manageHabitsTV = ManageHabitsTV(journal, manageUITV: manageUITableView)
        
        // set the databases, dataSources and delegates
        do {
            // set the databases
            let documentDirectory = try FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
            let fileUrl = documentDirectory.appendingPathComponent("habits").appendingPathExtension("sqlite3")
            let database = try Connection(fileUrl.path)
            self.journal.database = database
            self.journal.entries.database = database
            
            // set the dataSource and delegate
            self.manageUITableView.dataSource = manageHabitsTV
            self.manageUITableView.delegate = manageHabitsTV
            
            // testing drag and drop delegate
            self.manageUITableView.dragInteractionEnabled = true
            self.manageUITableView.dragDelegate = manageHabitsTV
            self.manageUITableView.dragDelegate = manageHabitsTV
            
            
        } catch {
            print(error)
        }
    }
    
    // load : viewWillAppear
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
//        print()
//        print("viewWillAppear...")
//        print()
        closeUIButton?.tintColor = getSystemColor()
        saveHabitsUIButton?.tintColor = getSystemColor()
        customDispUIButton?.tintColor = getSystemColor()
        // reload the views
        self.manageUITableView.reloadData()
//        self.colorUICollectionView.reloadData()
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
//        print()
//        print("traitCollectionDidChange")
//        print()
        // check if change from light/dark mode
        if #available(iOS 13, *), traitCollection.hasDifferentColorAppearance(comparedTo: previousTraitCollection) {
            // handle theme change here.
            self.manageUITableView.reloadData()
//            self.colorUICollectionView.reloadData()
        }
    }
    
    @IBAction func closeManageView(_ sender: AnyObject) {
        UITabBar.appearance().tintColor = getSystemColor()
        dismiss(animated: true, completion: nil)
    }
}
