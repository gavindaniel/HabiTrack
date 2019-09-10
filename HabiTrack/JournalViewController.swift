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
}

// class: JournalViewController
class JournalViewController: UIViewController {

    @IBOutlet weak var habitTableView: UITableView!
    @IBOutlet weak var dateCollectionView: UICollectionView!
    
    // variables
    var journal = Journal()
    
    // testing
    var journalTableView: JournalTableView?
    var journalDateView: JournalDateView?
    
    
    // load : viewDidAppear
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(applicationWillEnterForeground),
                                               name: UIApplication.willEnterForegroundNotification,
                                               object: nil)
        self.dateCollectionView.selectItem(at: IndexPath(row: 3, section: 0), animated: false, scrollPosition: [])
        self.dateCollectionView.delegate?.collectionView!(self.dateCollectionView, didSelectItemAt: IndexPath(item: 3, section: 0))
    }
    
    // load : viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        // testing
        journalTableView = JournalTableView(journal: journal, habitTableView: habitTableView)
        journalDateView = JournalDateView(dateCollectionView: dateCollectionView, journalTableView: journalTableView!, habitTableView: habitTableView)
        
        habitTableView.dataSource = journalTableView
        habitTableView.delegate = journalTableView
        
        dateCollectionView.dataSource = journalDateView
        dateCollectionView.delegate = journalDateView
            
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

        } catch {
            print(error)
        }
    }
    
    // load : viewWillAppear
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.habitTableView.reloadData()
        self.dateCollectionView.reloadData()
    }
    
    // load : applicationWillEnterForeground
    @objc func applicationWillEnterForeground() {
        self.habitTableView.reloadData()
        self.dateCollectionView.reloadData()
    }
    
    // UIButton : addEntry (add an entry)
    @IBAction func addEntry(_ sender: Any) {
        // create table if there isn't one
        journal.createTable()
        // create alert controller
        let alert = UIAlertController(title: "Add Habit", message: nil, preferredStyle: .alert)
        // add text fields
        alert.addTextField { (tf) in
            tf.placeholder = "Habit"
        }
        alert.addTextField { (tf) in
            tf.placeholder = "Time"
        }
        // create action event "Submit"
        let submit = UIAlertAction(title: "Submit", style: .default) { (_) in
            // get habit string from text field
            guard let habit = alert.textFields?.first?.text,
                // get time string from text field
                let time = alert.textFields?.last?.text
                else {
                    return
            }
            // insert new habit into journal
            let addHabit = self.journal.habitsTable.insert(self.journal.habit <- habit,
                                                           self.journal.time <- time,
                                                           self.journal.streak <- 0,
                                                           self.journal.currentDay <- 1)
            // attempt to add habit to database
            do {
                try self.journal.database.run(addHabit)
                print("Habit Added -> habit: \(habit), time: \(time)")
                self.journal.entries.addDay(habit: habit, date: Date())
                self.habitTableView.reloadData()
            } catch {
                print (error)
            }
        }
        alert.addAction(submit)
        // create "Cancel" action
        let cancel = UIAlertAction(title: "Cancel", style: UIAlertAction.Style.cancel, handler: nil)
        alert.addAction(cancel)
        present(alert, animated: true, completion: nil)
    }
    
    // UIButton : updateTable (edit an entry)
    @IBAction func updateTable(_ sender: Any) {
        print("Updating table...")
        // create alert controller
        let alert = UIAlertController(title: "Update Habit", message: nil, preferredStyle: .alert)
        // add text fields
        alert.addTextField { (tf) in
            tf.placeholder = "Habit ID" }
        alert.addTextField {(tf) in tf.placeholder = "Habit" }
        // create 'Submit' action
        let submit = UIAlertAction(title: "Submit", style: .default) { (_) in
            // get strings from text fields
            guard let habitIdString = alert.textFields?.first?.text, let habitId = Int(habitIdString), let habitString = alert.textFields?.last?.text
                else { return }
            // find the correct in the table
            let habit = self.journal.habitsTable.filter(self.journal.id == habitId)
            // udpate the habit
            let updateHabit = habit.update(self.journal.habit <- habitString)
            
            // attempt to update the database
            do {
                try self.journal.database.run(updateHabit)
                print("Updated table.")
                self.habitTableView.reloadData()
            } catch {
                print(error)
            }
        }
        alert.addAction(submit)
        // create 'Cancel' alert action
        let cancel = UIAlertAction(title: "Cancel", style: UIAlertAction.Style.cancel, handler: nil)
        alert.addAction(cancel)
        present(alert, animated: true, completion: nil)
    }
    
    // custom : update
    func update() {
        print("Updating View Controller...")
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
            } catch {
                print(error)
            }
            self.journal.addDays(numDays: count, startDate: lastRun)
            UserDefaults.standard.set(date, forKey: "lastRun")
            journalDateView?.updateDaysArray(date: date)
            
            // testing
			self.journalTableView.updateTableView(habitTableView: habitTableView)
			self.journalDateView.updateTableView(dateCollectionView: dateCollectionView)
            self.habitTableView.reloadData()
            self.dateCollectionView.reloadData()
            
        } else {
            print("Day has not changed.")
        }
    }
    
}
