//
//  JournalViewController.swift
//  HabiTrack
//
//  Created by Gavin Daniel on 8/22/19.
//  Copyright © 2019 Gavin Daniel. All rights reserved.
//

import UIKit
import SQLite

// class: DateCollectionViewCell
class DateCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var monthUILabel: UILabel!
    @IBOutlet weak var dayUILabel: UILabel!
}

// class: HabitTableViewCell
class HabitTableViewCell: UITableViewCell {
    @IBOutlet weak var habitUILabel: UILabel!
    @IBOutlet weak var timeUILabel: UILabel!
    @IBOutlet weak var streakUILabel: UILabel!
    @IBOutlet var checkBox: BEMCheckBox!
}

// class: JournalViewController
class JournalViewController: UIViewController {
    
    // variables
    var lastSelectedItem = -1
    var dateSelected = Date()
    var journal = Journal()
    
    // customViews
    var journalTableView: JournalTableView?
    var journalDateView: JournalDateView?

    @IBOutlet weak var habitTableView: UITableView!
    @IBOutlet weak var dateCollectionView: UICollectionView!
    
    // load : viewDidAppear
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        print()
        print("viewDidAppear...")
        print()
        // update views
        journalTableView?.updateTableView(habitView: habitTableView)
        journalDateView?.updateDateView(dateView: dateCollectionView)
        // set observer of application entering foreground
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(applicationWillEnterForeground),
                                               name: UIApplication.willEnterForegroundNotification,
                                               object: nil)
        // select today
        self.dateCollectionView.selectItem(at: IndexPath(row: 3, section: 0), animated: false, scrollPosition: [])
        self.dateCollectionView.delegate?.collectionView!(self.dateCollectionView, didSelectItemAt: IndexPath(item: 3, section: 0))
        // check for day change
        update()
    }
    
    // load : viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        print()
        print("viewDidLoad...")
        print()
        
        // initialize journalTableView
        self.journalTableView = JournalTableView(journal: journal, habitTableView: habitTableView, date: Date())
//        self.journalTableView?.journal = journal
//        self.journalTableView?.habitTableView = habitTableView
        
        // initialize journalDateView
        self.journalDateView = JournalDateView(dateCollectionView: dateCollectionView, journalTableView: journalTableView!, habitTableView: habitTableView)
//        self.journalDateView?.dateCollectionView = dateCollectionView
//        self.journalDateView?.journalTableView = journalTableView!
//        self.journalDateView?.habitTableView = habitTableView
        
        // set observer of application entering foreground
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(applicationWillEnterForeground),
                                               name: UIApplication.willEnterForegroundNotification,
                                               object: nil)
        
        // set the databases, dataSources and delegates
        do {
            // set the databases
            let documentDirectory = try FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
            let fileUrl = documentDirectory.appendingPathComponent("habits").appendingPathExtension("sqlite3")
            let database = try Connection(fileUrl.path)
            self.journal.database = database
            self.journal.entries.database = database
            
            // set the dataSource and delegate
            self.habitTableView.dataSource = journalTableView
            self.habitTableView.delegate = journalTableView
            
            // set the dataSource and delegate
            self.dateCollectionView.dataSource = journalDateView
            self.dateCollectionView.delegate = journalDateView
            
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
        self.habitTableView.reloadData()
        self.dateCollectionView.reloadData()
    }
    
    // load : applicationWillEnterForeground
    @objc func applicationWillEnterForeground() {
        print()
        print("applicationWillEnterForeground...")
        print()
        // check for day change
        update()
    }
    
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        print()
        print("traitCollectionDidChange")
        print()
        // check if change from light/dark mode
        if #available(iOS 13, *), traitCollection.hasDifferentColorAppearance(comparedTo: previousTraitCollection) {
            // handle theme change here.
            self.habitTableView.reloadData()
            self.dateCollectionView.reloadData()
        }
    }
    
    // custom : update
    func update() {
        print()
        print("Updating View Controller...")
        print()
        
        let date = Date()
        let defaults = UserDefaults.standard
        let lastRun = defaults.object(forKey: "lastRun") as! Date
        
        // check if last run date is different from current date
        if (Calendar.current.component(.year, from: lastRun) != Calendar.current.component(.year, from: date) ||
            Calendar.current.component(.month, from: lastRun) != Calendar.current.component(.month, from: date) ||
            Calendar.current.component(.day, from: lastRun) != Calendar.current.component(.day, from: date)) {
            
            print("Date has changed. Updating last run date...")
            
            // count number of days since last run
            let count = self.journal.entries.countDays(date1: lastRun, date2: date)
            
            // update the databases and views
            do {
                // update the database
                let documentDirectory = try FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
                let fileUrl = documentDirectory.appendingPathComponent("habits").appendingPathExtension("sqlite3")
                let database = try Connection(fileUrl.path)
                self.journal.database = database
                self.journal.entries.database = database
                // update the views
                self.journalTableView?.updateTableView(habitView: habitTableView)
                self.journalDateView?.updateDateView(dateView: dateCollectionView)
            } catch {
                print(error)
            }
            
            // add number of days since last run date
            self.journal.addDays(numDays: count, startDate: lastRun)
            
            // set the last run date to the current date
            UserDefaults.standard.set(date, forKey: "lastRun")
            
            // reload the views
            self.habitTableView.reloadData()
            self.dateCollectionView.reloadData()
            
            // update days array and views
            self.journalDateView?.updateDaysArray(date: date)
            self.journalTableView?.updateTableView(habitView: habitTableView)
            self.journalDateView?.updateDateView(dateView: dateCollectionView)
            
            // reload the views
            self.habitTableView.reloadData()
            self.dateCollectionView.reloadData()
            
        // day has not changed since last run
        } else {
            print("Day has not changed.")
        }
    }
}
