//
//  FirstViewController.swift
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
//    @IBOutlet weak var habitUITextField: UITextField!
}

// class: JournalViewController
class JournalViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UICollectionViewDelegate, UICollectionViewDataSource {

    // variables
    let currentMonth = "Aug"
    let days = 31
    var daysArray = [1]
    
    let date = Date()
    let calendar = Calendar.current
    var lastSavedYear = 0
    var lastSavedMonth = 0
    var lastSavedDay = 0
    
    // new
    var journal = Journal()

    @IBOutlet weak var habitTableView: UITableView!
    @IBOutlet weak var dateCollectionView: UICollectionView!
    
    // viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        do {
            let documentDirectory = try FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
            let fileUrl = documentDirectory.appendingPathComponent("habits").appendingPathExtension("sqlite3")
            let database = try Connection(fileUrl.path)
            
            self.journal.database = database
            self.journal.habitEntries.database = database
            
        } catch {
            print(error)
        }
    }
    
    // custom : createDaysArray (init daysArray)
    func createDaysArray() {
        var day = 2
        while day <= days {
            daysArray.append(day)
            day += 1
        }
    }
    
    // UIButton : addEntry (add an entry)
    @IBAction func addEntry(_ sender: Any) {
        print("Adding habit...")
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
                
                self.journal.habitEntries.addDay(habit: habit, date: Date())
                
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
    
    // collectionView : numberOfItemsInSection
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // if the days array has not been initialized, create the array
        if (daysArray.count == 1) {
            createDaysArray()
        }
        return (daysArray.count)
    }
    
    // collectionView : cellForItemAt
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        // create collectionView item
        let item = collectionView.dequeueReusableCell(withReuseIdentifier: "dateCell", for: indexPath)
            as! DateCollectionViewCell
        // add labels
        item.monthUILabel?.text = currentMonth
        item.dayUILabel?.text = String(daysArray[indexPath.row])
        // return initialized item
        return (item)
    }
    
    // collectionView : didSelectItemAt
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath)
    {
        // check if the cell was selected
        if let cell = collectionView.cellForItem(at: indexPath) {
            cell.isSelected = true;
        }
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
                    cell.streakUILabel?.text = String(habit[self.journal.streak])
                    return (cell)
                } else {
                    count += 1
                }
            }
        } catch {
            print (error)
        }
        return (cell)
    }
    
    
    // tableView : editingStyle
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath)
    {
        // check if the editingStyle is delete
        if (editingStyle == UITableViewCell.EditingStyle.delete) {
            print("Deleting habit...")
            // variables
            var count = 0
            var firstId = 0
            var tempString = ""
            // get the habit string from the tableview cell
            if let cell: HabitTableViewCell = (tableView.cellForRow(at: indexPath) as? HabitTableViewCell) {
                tempString = cell.habitUILabel?.text ?? "error"
            }
            // delete the habit from the table
            journal.habitEntries.deleteTable(habit: tempString)
            // do something
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
                        // attempt to delete the habit from the database
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
    
    
    // tableView : didSelectRowAt
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("Selected row: \(indexPath.row)")
        // get the cell from the tableView
        if let cell: HabitTableViewCell = (tableView.cellForRow(at: indexPath) as? HabitTableViewCell) {
            // get the habit string from the cell
            let tempString = cell.habitUILabel?.text
            // check if the cell has been completed
            if cell.accessoryType == UITableViewCell.AccessoryType.checkmark {
                cell.accessoryType = .none
                journal.updateStreak(row: indexPath.row, inc: 0, habitString: tempString ?? "none")
            }
            else {
                cell.accessoryType = .checkmark
                journal.updateStreak(row: indexPath.row, inc: 1, habitString: tempString ?? "none")
            }
        }
        self.habitTableView.reloadData()
    }

    func update() {
        print("Updating View Controller...")
        
        let date = Date()
        print("date: \(date)")
        let defaults = UserDefaults.standard
        let lastRun = defaults.object(forKey: "lastRun") as! Date
        print("last run: \(lastRun))")
        
        let yearToday = Calendar.current.component(.year, from: date)
        let monthToday = Calendar.current.component(.month, from: date)
        let dayToday = Calendar.current.component(.day, from: date)
        let yearLastRun = Calendar.current.component(.year, from: lastRun)
        let monthLastRun = Calendar.current.component(.month, from: lastRun)
        let dayLastRun = Calendar.current.component(.day, from: lastRun)

        if (yearLastRun != yearToday || monthLastRun != monthToday || dayLastRun != dayToday) {
            print("Date has changed. Updating last run date...")

            // not sure why the ! is needed below
            let nextDay = Calendar.current.date(byAdding: .day, value: 1, to: date)
            
            let count = self.journal.habitEntries.countDays(date1: lastRun, date2: nextDay ?? Date())
            
            // testing
            do {
                let documentDirectory = try FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
                let fileUrl = documentDirectory.appendingPathComponent("habits").appendingPathExtension("sqlite3")
                let database = try Connection(fileUrl.path)
                
                self.journal.database = database
                self.journal.habitEntries.database = database
                
            } catch {
                print(error)
            }
            
            self.journal.habitEntries.addDays(numDays: count, startDate: lastRun)
            
            UserDefaults.standard.set(Date(), forKey: "lastRun")
        } else {
            print("Day has not changed.")
        }
    }
    
    
    func initDate() {
        // save date
        print("initializing date...")
        if (lastSavedDay == 0) {
            print("should be updating date...")
            let date = Date()
            let calendar = Calendar.current
            lastSavedYear = calendar.component(.year, from: date)
            lastSavedMonth = calendar.component(.month, from: date)
            lastSavedDay = calendar.component(.day, from: date)
        }
        print("last saved -> year: \(lastSavedYear), month: \(lastSavedMonth), day: \(lastSavedDay)")
    }
    
    func setDefaults() {
        let defaults = UserDefaults.standard
        defaults.set(Date(), forKey: "lastRun")
    }
}
