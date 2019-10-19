//
//  ManageJournalVC.swift
//  HabiTrack
//
//  Created by Gavin Daniel on 10/18/19.
//  Copyright © 2019 Gavin Daniel. All rights reserved.
//

import Foundation
import SQLite

class ManageTableViewCell: UITableViewCell {
    @IBOutlet weak var habitNameUILabel: UILabel!
}

class ManageJournalVC: UIViewController {
    
    
    var journal = Journal()
    
    var manageTableView: ManageTableView?
    @IBOutlet weak var manageUITableView: UITableView!
    
    // load : viewDidAppear
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        print()
        print("viewDidAppear...")
        print()
        // update views
        manageTableView?.updateTableView(tableView: manageUITableView)
    }

    // load : viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        print()
        print("viewDidLoad...")
        print()
        
        // initialize journalTitleTableView
        self.manageTableView = ManageTableView(journal: journal, manageTableView: manageUITableView)
        
        // set the databases, dataSources and delegates
        do {
            // set the databases
            let documentDirectory = try FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
            let fileUrl = documentDirectory.appendingPathComponent("habits").appendingPathExtension("sqlite3")
            let database = try Connection(fileUrl.path)
            self.journal.database = database
            self.journal.entries.database = database
            
            // set the dataSource and delegate
            self.manageUITableView.dataSource = manageTableView
            self.manageUITableView.delegate = manageTableView
            
            
        } catch {
            print(error)
        }
    }
    
    // load : viewWillAppear
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        print()
        print("viewWillAppear...")
        print()
        // reload the views
        self.manageUITableView.reloadData()
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        print()
        print("traitCollectionDidChange")
        print()
        // check if change from light/dark mode
        if #available(iOS 13, *), traitCollection.hasDifferentColorAppearance(comparedTo: previousTraitCollection) {
            // handle theme change here.
            self.manageUITableView.reloadData()
        }
    }
}
