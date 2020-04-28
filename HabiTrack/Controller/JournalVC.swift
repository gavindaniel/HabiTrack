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
class JournalDateCVCell: UICollectionViewCell {
    @IBOutlet weak var monthUILabel: UILabel!
    @IBOutlet weak var dayUILabel: UILabel!
}

// class: HabitTableViewCell
class JournalHabitsTVCell: UITableViewCell {
    @IBOutlet weak var habitUILabel: UILabel!
    @IBOutlet weak var streakUILabel: UILabel!
    @IBOutlet weak var checkImageView: UIImageView!
    
//    @IBOutlet var checkBox: BEMCheckBox!
}

class JournalTitleCVCell: UICollectionViewCell {
    @IBOutlet weak var journalTitleLabel: UILabel!
    @IBOutlet weak var weekDayLabel: UILabel!
    @IBOutlet weak var newEntryUIButton: UIButton!
}

// class: JournalViewController
class JournalVC: UIViewController {
    
    // variables
    var lastSelectedItem = -1
    var dateSelected = Date()
    var journal = Journal()
    
    // customViews
    var journalHabitsTV: JournalHabitsTV?
    var journalDateCV: JournalDateCV?
    var journalTitleCV: JournalTitleCV?
    
    @IBOutlet weak var journalUITV: UITableView!
    @IBOutlet weak var dateUICV: UICollectionView!
    @IBOutlet weak var titleUICV: UICollectionView!

    // load : viewDidAppear
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        debugPrint("JournalVC", "viewDidAppear", "start", false)
        // update views
        journalHabitsTV?.updateTableView(habitView: journalUITV)
        journalDateCV?.updateDateView(dateUICV)
        journalTitleCV?.updateTitleView(titleView: titleUICV)
        
        // set observer of application entering foreground
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(applicationWillEnterForeground),
                                               name: UIApplication.willEnterForegroundNotification,
                                               object: nil)
        // select today
        let calendar = Calendar.current
        let day = calendar.component(.day, from: Date())
        self.dateUICV.selectItem(at: IndexPath(row: day-1, section: 0), animated: false, scrollPosition: [])
        self.dateUICV.delegate?.collectionView!(self.dateUICV, didSelectItemAt: IndexPath(item: day-1, section: 0))
        // check for day change
        updateViewController()
        debugPrint("JournalVC", "viewDidAppear", "end", false)
    }
    
    // load : viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        debugPrint("JournalVC", "viewDidLoad", "start", false)
        // initialize journalTitleTableView
        self.journalTitleCV = JournalTitleCV(titleTableView: titleUICV, date: Date())
        
        // initialize journalHabitsTV
        self.journalHabitsTV = JournalHabitsTV(journal: journal, habitTableView: journalUITV, date: Date())
        
        // initialize journalDateCV
        self.journalDateCV = JournalDateCV(dateUICV, journalHabitsTV: journalHabitsTV!, habitUITV: journalUITV, journalTitleCV: journalTitleCV!,
                                           titleUICV: titleUICV)
        
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
            self.titleUICV.dataSource = journalTitleCV
            self.titleUICV.delegate = journalTitleCV
            
            // set the dataSource and delegate
            self.journalUITV.dataSource = journalHabitsTV
            self.journalUITV.delegate = journalHabitsTV
            
            // set the dataSource and delegate
            self.dateUICV.dataSource = journalDateCV
            self.dateUICV.delegate = journalDateCV
            
        } catch {
            print(error)
        }
        debugPrint("JournalVC", "viewDidLoad", "end", false)
    }
    
    // load : viewWillAppear
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        debugPrint("JournalVC", "viewWillAppear", "start", false)
        // reload the views
        self.titleUICV.reloadData()
        self.journalUITV.reloadData()
        self.dateUICV.reloadData()
        debugPrint("JournalVC", "viewWillAppear", "end", false)
    }
    
    // load : applicationWillEnterForeground
    @objc func applicationWillEnterForeground() {
        debugPrint("JournalVC", "applicationWillEnterForeground", "start", false)
        // check for day change
        updateViewController()
        debugPrint("JournalVC", "applicationWillEnterForeground", "end", false)
    }
    
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        debugPrint("JournalVC", "traitCollectionDidChange", "start", false)
        // check if change from light/dark mode
        if #available(iOS 13, *), traitCollection.hasDifferentColorAppearance(comparedTo: previousTraitCollection) {
            // handle theme change here.
            self.journalUITV.reloadData()
            self.dateUICV.reloadData()
        }
        debugPrint("JournalVC", "traitCollectionDidChange", "end", false)
    }
    
    // custom : update
    func updateViewController() {
        debugPrint("JournalVC", "update", "start", false)
        let dateToday = Date()
        let defaults = UserDefaults.standard
        let lastRun = defaults.object(forKey: "lastRun") as! Date
        
        // check if last run date is different from current date
        if (Calendar.current.component(.year, from: lastRun) != Calendar.current.component(.year, from: dateToday) ||
            Calendar.current.component(.month, from: lastRun) != Calendar.current.component(.month, from: dateToday) ||
            Calendar.current.component(.day, from: lastRun) != Calendar.current.component(.day, from: dateToday)) {
            
            print("\tDate has changed. Updating last run date...")
            
            // count number of days since last run
            let count = countDays(date1: lastRun, date2: dateToday)
            
            // update the databases and views
            do {
                // update the database
                let documentDirectory = try FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
                let fileUrl = documentDirectory.appendingPathComponent("habits").appendingPathExtension("sqlite3")
                let database = try Connection(fileUrl.path)
                self.journal.database = database
                self.journal.entries.database = database
                // update the views
                self.journalTitleCV?.updateTitleView(titleView: titleUICV)
                self.journalHabitsTV?.updateTableView(habitView: journalUITV)
                self.journalDateCV?.updateDateView(dateUICV)
            } catch {
                print(error)
            }
            
            // add number of days since last run date
            self.journal.addDays(numDays: count, startDate: lastRun)
            
            // set the last run date to the current date
            UserDefaults.standard.set(dateToday, forKey: "lastRun")
            
            // reload the views
            self.titleUICV.reloadData()
            self.journalUITV.reloadData()
            self.dateUICV.reloadData()
            
            // update days array and views
            self.journalDateCV?.updateDaysArray(dateToday)
            self.journalHabitsTV?.updateTableView(habitView: journalUITV)
            self.journalDateCV?.updateDateView(dateUICV)
            
            // reload the views
            self.titleUICV.reloadData()
            self.journalUITV.reloadData()
            self.dateUICV.reloadData()
            
        // day has not changed since last run
        } else {
            print("\tDay has not changed.")
        }
        debugPrint("JournalVC", "update", "start", false)
    } // end of update func.
}
