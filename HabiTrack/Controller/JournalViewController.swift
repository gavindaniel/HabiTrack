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
//    var daysArray: Array<Date> = []
    var lastSelectedItem = -1
    var dateSelected = Date()
    var journal = Journal()
    
    // testing
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
        
        // testing
        journalTableView?.updateTableView(habitView: habitTableView)
        journalDateView?.updateDateView(dateView: dateCollectionView)
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(applicationWillEnterForeground),
                                               name: UIApplication.willEnterForegroundNotification,
                                               object: nil)
        self.dateCollectionView.selectItem(at: IndexPath(row: 3, section: 0), animated: false, scrollPosition: [])
        self.dateCollectionView.delegate?.collectionView!(self.dateCollectionView, didSelectItemAt: IndexPath(item: 3, section: 0))
        
        // testing...
        update()
    }
    
    // load : viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        print()
        print("viewDidLoad...")
        print()
        
        
        // testing
        self.journalTableView = JournalTableView(journal: journal, habitTableView: habitTableView, date: Date())
        self.journalTableView?.journal = journal
        self.journalTableView?.habitTableView = habitTableView
        
        // testing
        self.journalDateView = JournalDateView(dateCollectionView: dateCollectionView, journalTableView: journalTableView!, habitTableView: habitTableView)
        self.journalDateView?.dateCollectionView = dateCollectionView
        self.journalDateView?.journalTableView = journalTableView!
        self.journalDateView?.habitTableView = habitTableView
        
        
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(applicationWillEnterForeground),
                                               name: UIApplication.willEnterForegroundNotification,
                                               object: nil)
        do {
            let documentDirectory = try FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
            let fileUrl = documentDirectory.appendingPathComponent("habits").appendingPathExtension("sqlite3")
            let database = try Connection(fileUrl.path)
            self.journal.database = database
            self.journal.entries.database = database
            
            self.habitTableView.dataSource = journalTableView
            self.habitTableView.delegate = journalTableView
            
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
        
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        
        self.habitTableView.reloadData()
        self.dateCollectionView.reloadData()
    }
    
    // load : applicationWillEnterForeground
    @objc func applicationWillEnterForeground() {
        print()
        print("applicationWillEnterForeground...")
        print()
        
        update()
    }
    
    // custom : update
    func update() {
        print()
        print("Updating View Controller...")
        print()
        let date = Date()
        let defaults = UserDefaults.standard
        let lastRun = defaults.object(forKey: "lastRun") as! Date

        // comment for testing
        if (Calendar.current.component(.year, from: lastRun) != Calendar.current.component(.year, from: date) ||
            Calendar.current.component(.month, from: lastRun) != Calendar.current.component(.month, from: date) ||
            Calendar.current.component(.day, from: lastRun) != Calendar.current.component(.day, from: date)) {
            
            // uncomment for testing
//        if (1 != 0) {
//            let nextDay = Calendar.current.date(byAdding: .day, value: 1, to: date)
//            let count = self.journal.habitEntries.countDays(date1: lastRun, date2: nextDay ?? Date())
            
            print("Date has changed. Updating last run date...")
            let count = self.journal.entries.countDays(date1: lastRun, date2: date)
            
            do {
                let documentDirectory = try FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
                let fileUrl = documentDirectory.appendingPathComponent("habits").appendingPathExtension("sqlite3")
                let database = try Connection(fileUrl.path)
                self.journal.database = database
                self.journal.entries.database = database
                
                self.journalTableView?.updateTableView(habitView: habitTableView)
                self.journalDateView?.updateDateView(dateView: dateCollectionView)
                
            } catch {
                print(error)
            }
            self.journal.addDays(numDays: count, startDate: lastRun)
            UserDefaults.standard.set(date, forKey: "lastRun")
//            updateDaysArray(date: date)
            
            // testing
            self.habitTableView.reloadData()
            self.dateCollectionView.reloadData()
            
            // testing
            print("trying to updateDaysArray...")
            self.journalDateView?.updateDaysArray(date: date)
                        
            // testing
            print("trying to update views...")
            self.journalTableView?.updateTableView(habitView: habitTableView)
            self.journalDateView?.updateDateView(dateView: dateCollectionView)
            
            
            // testing
            self.habitTableView.reloadData()
            self.dateCollectionView.reloadData()

        } else {
            print("Day has not changed.")
        }
    }
}
