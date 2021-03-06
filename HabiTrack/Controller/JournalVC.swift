//
//  JournalViewController.swift
//  HabiTrack
//
//  Created by Gavin Daniel on 8/22/19.
//  Copyright © 2019 Gavin Daniel. All rights reserved.
//

import UIKit
import CoreData

// name: Global Variables
// desc: global variables
// last updated: 5/16/2020
// last update: new; added dateSelected
public var dateSelected = Date()


// name: JournalVC
// desc: journal view controller class
// last updated: 4/28/2020
// last update: cleaned up
class JournalVC: UIViewController {
    // variables
    var lastSelectedItem = -1
//    var dateSelected = Date()
    var habits = Habits()
    // customViews
    var journalHabitsTV: JournalHabitsTV?
    var journalDateCV: JournalDateCV?

    // IBOutlet connections
    @IBOutlet weak var journalUITableView: UITableView!
    @IBOutlet weak var dateUICollectionView: UICollectionView!
    @IBOutlet weak var addHabitUIButton: UIButton!
    @IBOutlet weak var dateUIButton: UIButton!
    
    
    // name: viewDidLoad
    // desc:
    // last updated: 4/28/2020
    // last update: cleaned up
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        print("******************************************************")
        debugPrint("JournalVC", "viewDidLoad", "start", false)
        // testing
        DataManager.shared.journalVC = self
        // initialize journalHabitsTV
        self.journalHabitsTV = JournalHabitsTV(habits, journalUITableView, Date())
        // initialize journalDateCV
        self.journalDateCV = JournalDateCV(dateUICollectionView, journalHabitsTV!, journalUITableView)
        // set observer of application entering foreground
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(applicationWillEnterForeground),
                                               name: UIApplication.willEnterForegroundNotification,
                                               object: nil)
        // set the databases, dataSources and delegates
        do {
            // set the databases
//            let documentDirectory = try FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
//            let fileUrl = documentDirectory.appendingPathComponent("habits").appendingPathExtension("sqlite3")
//            let database = try Connection(fileUrl.path)
//            self.habits.database = database
//            self.habits.entries.database = database
            // set the dataSource and delegate
            self.journalUITableView.dataSource = (journalHabitsTV as! UITableViewDataSource)
            self.journalUITableView.delegate = (journalHabitsTV as! UITableViewDelegate)
            // set the dataSource and delegate
            self.dateUICollectionView.dataSource = journalDateCV
            self.dateUICollectionView.delegate = journalDateCV
            
//            datePicker.datePickerMode = .date
//            datePicker.addTarget(self, action: #selector(handleDatePicker(sender:)), for: .valueChanged)
            
            self.dateUIButton.tintColor = getColor("System")
            self.addHabitUIButton.tintColor = getColor("System")
            updateDateButton(dateSelected)
//             qupdateDateArray(dateSelected)
            self.dateUICollectionView.scrollToItem(at:IndexPath(item: lastSelectedItem, section: 0), at: .right, animated: false)
        } catch {
            print(error)
        }
        debugPrint("JournalVC", "viewDidLoad", "end", false)
    }
    
    
    // name: viewWillAppear
    // desc:
    // last updated: 4/28/2020
    // last update: cleaned up
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        debugPrint("JournalVC", "viewWillAppear", "start", false)
        // reload the views
        self.journalUITableView.reloadData()
        self.dateUICollectionView.reloadData()
        debugPrint("JournalVC", "viewWillAppear", "end", false)
    }
    
    
    // name: viewDidAppear
    // desc:
    // last updated: 4/28/2020
    // last update: cleaned up
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        debugPrint("JournalVC", "viewDidAppear", "start", false)
        // update views
        self.journalUITableView.reloadData()
        self.dateUICollectionView.reloadData()
        // set observer of application entering foreground
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(applicationWillEnterForeground),
                                               name: UIApplication.willEnterForegroundNotification,
                                               object: nil)
        // select today
        let calendar = Calendar.current
        let day = calendar.component(.day, from: Date())
        self.dateUICollectionView.selectItem(at: IndexPath(row: day-1, section: 0), animated: false, scrollPosition: [])
        self.dateUICollectionView.delegate?.collectionView!(self.dateUICollectionView, didSelectItemAt: IndexPath(item: day-1, section: 0))
        // check for day change
        updateViewController()
        debugPrint("JournalVC", "viewDidAppear", "end", false)
        print("******************************************************")
    }
    
    
    // name: applicationWillEnterForeground
    // desc:
    // last updated: 4/28/2020
    // last update: cleaned up
    @objc func applicationWillEnterForeground() {
        print("******************************************************")
        debugPrint("JournalVC", "applicationWillEnterForeground", "start", false)
        // check for day change
        updateViewController()
        debugPrint("JournalVC", "applicationWillEnterForeground", "end", false)
        print("******************************************************")
    }
    
    
    // name: traitCollectionDidChange
    // desc:
    // last updated: 4/28/2020
    // last update: cleaned up
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        debugPrint("JournalVC", "traitCollectionDidChange", "start", true)
        // check if change from light/dark mode
        if #available(iOS 13, *), traitCollection.hasDifferentColorAppearance(comparedTo: previousTraitCollection) {
            // handle theme change here.
            self.journalUITableView.reloadData()
            self.dateUICollectionView.reloadData()
        }
        debugPrint("JournalVC", "traitCollectionDidChange", "end", true)
    }
    
    
    // name: updateViewController
    // desc:
    // last updated: 5/16/2020
    // last update: fixed bug with tabs remembering old states, replaced with reloadData on views.
    func updateViewController() {
        debugPrint("JournalVC", "updateViewController", "start", false)
        let dateToday = Date()
        let calendar = Calendar.current
        let defaults = UserDefaults.standard
        let lastRun = defaults.object(forKey: "lastRun") as! Date
        // check if last run date is different from current date
        if (calendar.component(.year, from: lastRun) != calendar.component(.year, from: dateToday) ||
            calendar.component(.month, from: lastRun) != calendar.component(.month, from: dateToday) ||
            calendar.component(.day, from: lastRun) != calendar.component(.day, from: dateToday)) {
            print("\tDate has changed. Updating last run date...")
            // count number of days since last run
            let count = countDaysBetweenDates(lastRun, dateToday)
            // update the databases and views
            do {
                // update the database
//                let documentDirectory = try FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
//                let fileUrl = documentDirectory.appendingPathComponent("habits").appendingPathExtension("sqlite3")
//                let database = try Connection(fileUrl.path)
//                self.habits.database = database
//                self.habits.entries.database = database
                // reload the views
                self.journalUITableView.reloadData()
                self.dateUICollectionView.reloadData()
            } catch {
                print(error)
            }
            // add number of days since last run date
            self.habits.addDays(numDays: count, startDate: lastRun)
            // set the last run date to the current date
            UserDefaults.standard.set(dateToday, forKey: "lastRun")
            // reload the views
            self.journalUITableView.reloadData()
            self.dateUICollectionView.reloadData()
        // day has not changed since last run
        } else {
            print("\tDay has not changed.")
        }
        debugPrint("JournalVC", "updateViewController", "end", false)
    } // end of update func.
    

    // name: touchesBegan
    // desc:
    // last updated: 4/29/2020
    // last update: added
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    
    // name: newHabit
    // desc:
    // last updated: 5/1/2020
    // last update: added
    @IBAction func newHabit(_ sender: Any) {
        debugPrint("JournalVC", "newHabit", "start", false)
        let storyBoard = UIStoryboard(name: "Main", bundle:nil)
        let habitVC = storyBoard.instantiateViewController(withIdentifier: "habitVC") as! HabitVC
        habitVC.habits = habits
        self.present(habitVC, animated: true, completion: nil)
    }
    
    
    // name: changeDate
    // desc:
    // last updated: 5/1/2020
    // last update: added
    @IBAction func changeDate(_ sender: Any) {
        let storyBoard = UIStoryboard(name: "Main", bundle:nil)
        let calendarVC = storyBoard.instantiateViewController(withIdentifier: "calendarVC") as! CalendarVC
        self.present(calendarVC, animated: true, completion: nil)
    }
    
    
    // name: changeDate
    // desc:
    // last updated: 5/1/2020
    // last update: added
    func updateDateButton(_ date: Date) {
        let monthString = getMonthAsString(date: date, length: "long")
        let dateString = monthString + " \(getDay(date))\(getDayOfMonthSuffix(date))"
        self.dateUIButton.setTitle(dateString, for: .normal)
    }
}
