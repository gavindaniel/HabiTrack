//
//  ManageJournalVC.swift
//  HabiTrack
//
//  Created by Gavin Daniel on 10/18/19.
//  Copyright © 2019 Gavin Daniel. All rights reserved.
//

import UIKit
import CoreData


// name: ManageJournalVC
// desc: add habit view controller class
// last updated: 4/28/2020
// last update: cleaned up
class ManageJournalVC: UIViewController {
    // variables
//    var habits = Habits()
//    var manageHabitsTV: ManageHabitsTV?
    // IBOutlet connections
    @IBOutlet weak var manageUIView: UIView!
    @IBOutlet weak var manageUITableView: UITableView!
    @IBOutlet weak var closeUIButton: UIButton!
    @IBOutlet weak var saveHabitsUIButton: UIButton!
    @IBOutlet weak var customDispUIButton: UIButton!
    
    
    // name: viewDidAppear
    // desc:
    // last updated: 4/28/2020
    // last update: cleaned up
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        debugPrint("ManageJournalVC", "viewDidAppear", "start", false)
//        manageHabitsTV?.updateUITableView(manageUITableView)
        debugPrint("ManageJournalVC", "viewDidAppear", "end", false)
    }

    
    // name: viewDidLoad
    // desc:
    // last updated: 4/28/2020
    // last update: cleaned up
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        debugPrint("ManageJournalVC", "viewDidLoad", "start", false)
        // initialize views
//        self.manageHabitsTV = ManageHabitsTV(habits, manageUITableView)
        // set the databases, dataSources and delegates
        do {
            // set the databases
//            let documentDirectory = try FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
//            let fileUrl = documentDirectory.appendingPathComponent("habits").appendingPathExtension("sqlite3")
//            let database = try Connection(fileUrl.path)
//            self.habits.database = database
//            self.habits.entries.database = database
            // set the dataSource and delegate
//            self.manageUITableView.dataSource = (manageHabitsTV as! UITableViewDataSource)
//            self.manageUITableView.delegate = (manageHabitsTV as! UITableViewDelegate)
            // testing drag and drop delegate
            self.manageUITableView.dragInteractionEnabled = true
//            self.manageUITableView.dragDelegate = (manageHabitsTV as! UITableViewDragDelegate)
//            self.manageUITableView.dragDelegate = (manageHabitsTV as! UITableViewDragDelegate)
        } catch {
            print(error)
        }
        debugPrint("ManageJournalVC", "viewDidLoad", "end", false)
    }
    
    
    // name: viewWillAppear
    // desc:
    // last updated: 4/28/2020
    // last update: cleaned up
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        debugPrint("ManageJournalVC", "viewWillAppear", "start", false)
        let tempColor = getColor("System")
        closeUIButton?.tintColor = tempColor
        saveHabitsUIButton?.tintColor = tempColor
        customDispUIButton?.tintColor = tempColor
        // reload the views
        self.manageUITableView.reloadData()
//        self.colorUICollectionView.reloadData()
        debugPrint("ManageJournalVC", "viewWillAppear", "end", false)
    }
    
    
    // name: traitCollectionDidChange
    // desc:
    // last updated: 4/28/2020
    // last update: cleaned up
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        debugPrint("ManageJournalVC", "traitCollectionDidChange", "start", true)
        // check if change from light/dark mode
        if #available(iOS 13, *), traitCollection.hasDifferentColorAppearance(comparedTo: previousTraitCollection) {
            // handle theme change here.
            self.manageUITableView.reloadData()
//            self.colorUICollectionView.reloadData()
        }
        debugPrint("ManageJournalVC", "traitCollectionDidChange", "end", true)
    }
    
    
    // name: closeManageView
    // desc:
    // last updated: 4/28/2020
    // last update: cleaned up
    @IBAction func closeManageView(_ sender: AnyObject) {
        debugPrint("ManageJournalVC", "closeManageView", "start", false)
        UITabBar.appearance().tintColor = getColor("System")
        dismiss(animated: true, completion: nil)
        debugPrint("ManageJournalVC", "closeManageView", "end", false)
    }
}
