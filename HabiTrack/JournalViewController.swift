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
class JournalViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UICollectionViewDelegate, UICollectionViewDataSource {

    // variables
    var daysArray: Array<Date> = []
    var lastSelectedItem = -1
    var dateSelected = Date()
    var journal = Journal()

    @IBOutlet weak var habitTableView: UITableView!
    @IBOutlet weak var dateCollectionView: UICollectionView!
    
    // load : viewDidAppear
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        print()
        print("viewDidAppear...")
        print()
        
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
            
            // testing...
//            update()
            
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
        self.habitTableView.reloadData()
        self.dateCollectionView.reloadData()
    }
    
    
    
    // load : applicationWillEnterForeground
    @objc func applicationWillEnterForeground() {
        print()
        print("applicationWillEnterForeground...")
        print()
//        self.habitTableView.reloadData()
//        self.dateCollectionView.reloadData()
        
        update()
        
        // testing
//        self.dateCollectionView.selectItem(at: IndexPath(row: 3, section: 0), animated: false, scrollPosition: [])
//        self.dateCollectionView.delegate?.collectionView!(self.dateCollectionView, didSelectItemAt: IndexPath(item: 3, section: 0))
        
//        self.habitTableView.reloadData()
//        self.dateCollectionView.reloadData()
    }
    
    // collectionView : numberOfItemsInSection
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // if the days array has not been initialized, create the array
        if (daysArray.count == 0) {
            updateDaysArray(date: Date())
        }
        return (daysArray.count)
    }
    
    // collectionView : cellForItemAt
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        // create collectionView item
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "dateCell", for: indexPath)
            as! DateCollectionViewCell
        // add labels
        cell.monthUILabel?.text = getMonthAsString(date: daysArray[indexPath.row])
        cell.dayUILabel?.text = String(getDayAsInt(date: daysArray[indexPath.row]))
        cell.monthUILabel?.textColor = UIColor.gray
        cell.dayUILabel?.textColor = UIColor.gray
        cell.layer.borderWidth = 1.0
        
        var tempDate = Date()
        
//        let defaults = UserDefaults.standard
//        let lastRun = defaults.object(forKey: "lastRun") as! Date
        
        if (lastSelectedItem != -1) {
//            let month = Calendar.current.component(.month, from: Date())
//            let day = Calendar.current.component(.day, from: Date())
            let month = Calendar.current.component(.month, from: dateSelected)
            let day = Calendar.current.component(.day, from: dateSelected)
//            let month = Calendar.current.component(.month, from: lastRun)
//            let day = Calendar.current.component(.day, from: lastRun)
            tempDate = getDate(month: month, day: day)
        }

        let tempDay = Calendar.current.component(.day, from: tempDate)
        
        // check if today, mark blue, else mark gray
        if (tempDay == getDayAsInt(date: daysArray[indexPath.row])) {
            print("tempDay: \(tempDay) == daysArray: \(getDayAsInt(date: daysArray[indexPath.row]))")
            cell.layer.borderColor = UIColor.blue.cgColor
            cell.monthUILabel?.textColor = UIColor.blue
            cell.dayUILabel?.textColor = UIColor.blue
        } else {
            cell.layer.borderColor = UIColor.lightGray.cgColor
            cell.monthUILabel?.textColor = UIColor.gray
            cell.dayUILabel?.textColor = UIColor.gray
        }
        cell.layer.cornerRadius = 10.0;
        // return initialized item
        return (cell)
    }
    
    // collectionView : didDeselectItemAt
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        if let cell: DateCollectionViewCell = (collectionView.cellForItem(at: indexPath) as? DateCollectionViewCell) {
            // clear the selection
            cell.layer.borderWidth = 1.0
            cell.layer.borderColor = UIColor.lightGray.cgColor
            cell.layer.cornerRadius = 10.0;
            cell.monthUILabel?.textColor = UIColor.gray
            cell.dayUILabel?.textColor = UIColor.gray
        }
    }
    
    // collectionView : didSelectItemAt
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//        print("Selected item: \(indexPath.row)")
        // get the cell from the tableView
        if let cell: DateCollectionViewCell = (collectionView.cellForItem(at: indexPath) as? DateCollectionViewCell) {
            // if the selected item is different from the last, deselect the last item
            print("lastSelectedItem: \(lastSelectedItem) != indexPath.row: \(indexPath.row)")
//            if (lastSelectedItem != indexPath.row) {
                lastSelectedItem = indexPath.row
                
                let month = cell.monthUILabel?.text ?? String(Calendar.current.component(.month, from: Date()))
                let day = cell.dayUILabel?.text ?? String(Calendar.current.component(.day, from: Date()))
                let date = getDate(month: getMonthAsInt(month: month), day: Int(day) ?? Calendar.current.component(.day, from: Date()))
                dateSelected = date
                print("dateSelected: \(dateSelected)")
                // FIXME: replace 'days' with a calculation for number of days in the month
                // loop through cells and deselect
                var tempIndex = 0
                while tempIndex < daysArray.count {
                    if (tempIndex != lastSelectedItem) {
                        self.dateCollectionView.deselectItem(at: IndexPath(row: tempIndex, section: 0), animated: false)
                    }
                    // increment index
                    tempIndex += 1
                }
//            }
            // change the border fo the selected item
            cell.layer.borderWidth = 1.0
            cell.layer.borderColor = UIColor.blue.cgColor
            cell.layer.cornerRadius = 10.0;
            cell.monthUILabel?.textColor = UIColor.blue
            cell.dayUILabel?.textColor = UIColor.blue
        }
        self.habitTableView.reloadData()
        // testing ...
        updateDaysArray(date: dateSelected)
        self.dateCollectionView.reloadData()
    }
    
    // tableView : numberOfRowsInSection
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // get the number of habits in the journal
        return (journal.getTableSize())
    }
    
    // tableView : cellForRowAt
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // create tableView cell
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
            as! HabitTableViewCell
        // since the database only increments from the last ID,
        // this for loop fixes issues with gaps in the database.
        var count = 0
        do {
            // get the table
            let habits = try self.journal.database.prepare(self.journal.habitsTable)
            // loop through the list of habits
            for habit in habits {
                if (count == indexPath.row) {
                    cell.habitUILabel?.text = habit[self.journal.habit]
                    cell.timeUILabel?.text = habit[self.journal.time]
                    // get the name of habit and size of habit entries table
                    let habitString = habit[self.journal.habit]
                    let habitStreak = self.journal.entries.countStreak(habit: habitString, date: dateSelected)
                    // set the streak
                    cell.streakUILabel?.text = String(habitStreak)
                    // check if today has already been completed
                    if (self.journal.entries.checkCompleted(habit: habitString, date: dateSelected)) {
                        cell.accessoryType = .checkmark
                    } else {
                        cell.accessoryType = .none
                    }
                    return (cell)
                } else {
                    count += 1
                }
            }
        } catch {
            print (error)
        }
        self.habitTableView.reloadData()
        return (cell)
    }
    
    // tableView : didSelectRowAt
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        print("Selected row: \(indexPath.row)")
        // get the cell from the tableView
        if let cell: HabitTableViewCell = (tableView.cellForRow(at: indexPath) as? HabitTableViewCell) {
            // get the habit string from the cell
            let tempString = cell.habitUILabel?.text
            // check if the cell has been completed
            if cell.accessoryType == UITableViewCell.AccessoryType.checkmark {
                cell.accessoryType = .none
                journal.updateDateStreak(row: indexPath.row, inc: 0, date: dateSelected, habitString: tempString ?? "none")
            }
            else {
                cell.accessoryType = .checkmark
                journal.updateDateStreak(row: indexPath.row, inc: 1, date: dateSelected, habitString: tempString ?? "none")
            }
        }
        self.habitTableView.reloadData()
    }

    // tableView : editingStyle
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath)
    {
        // check if the editingStyle is delete
        if (editingStyle == UITableViewCell.EditingStyle.delete) {
            var count = 0
            var firstId = 0
            var habitString = ""
            // get the habit string from the tableview cell
            if let cell: HabitTableViewCell = (tableView.cellForRow(at: indexPath) as? HabitTableViewCell) {
                habitString = cell.habitUILabel?.text ?? "error"
            }
            // delete the habit from the table
            journal.entries.deleteTable(habit: habitString)
            do {
                // get the habits table
                let habits = try self.journal.database.prepare(self.journal.habitsTable)
                // loop through the table
                for habit in habits {
                    // get the id of the first habit
                    if (count == 0) {
                        firstId = habit[self.journal.id]
                    }
                    if (count == indexPath.row) {
                        // get the habit whose id matches the count + first ID in the tableView
                        let habit = self.journal.habitsTable.filter(self.journal.id == (count+firstId))
                        // delete the habit
                        let deleteHabit = habit.delete()
                        do {
                            try self.journal.database.run(deleteHabit)
                            print("Deleted habit")
                            habitTableView.reloadData()
                            return
                        } catch {
                            print(error)
                        }
                    } else {
                        count += 1
                    }
                }
            } catch {
                print (error)
            }
        }
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
                
//                self.journal.entries.addDay(habit: habit, date: Date())
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
    
    // custom : updateDaysArray (init daysArray)
    func updateDaysArray(date: Date) {
        daysArray = []
        var day = Calendar.current.date(byAdding: .day, value: -3, to: date)
        var count = -3
        while count <= 3 {
//            print("count: \(count)\tday: \(Calendar.current.component(.day, from: day ?? date))")
            daysArray.append(day ?? Date())
            // increment day count
            day = Calendar.current.date(byAdding: .day, value: 1, to: day ?? date)
            count += 1
        }
        self.habitTableView?.reloadData()
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
            } catch {
                print(error)
            }
            self.journal.addDays(numDays: count, startDate: lastRun)
            UserDefaults.standard.set(date, forKey: "lastRun")
            updateDaysArray(date: date)
            
            // testing
            self.habitTableView.reloadData()
            self.dateCollectionView.reloadData()

        } else {
            print("Day has not changed.")
        }
    }
}
