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
    
    var database: Connection!
    let habitsTable = Table("habits")
    let id = Expression<Int>("id")
    let habit = Expression<String>("habit")
    let time = Expression<String>("time")
    let streak = Expression<Int>("streak")
     let currentDay = Expression<Int>("currentDay")
    
    let year = Expression<Int>("year")
    let month = Expression<Int>("month")
    let day = Expression<Int>("day")
    let completed = Expression<Int>("completed")

    @IBOutlet weak var habitTableView: UITableView!
    @IBOutlet weak var dateCollectionView: UICollectionView!
    
    // custom : createDaysArray (init daysArray)
    func createDaysArray() {
        var day = 2
        while day <= days {
            daysArray.append(day)
            day += 1
        }
    }
    
    // custom : createTable (create SQL table)
   func createTable() {
        print("Creating Table...")
        let createTable = self.habitsTable.create { (table) in
            table.column(self.id, primaryKey: true)
            table.column(self.habit)
            table.column(self.time)
            table.column(self.streak)
            table.column(self.currentDay)
        }
        do {
            try self.database.run(createTable)
            print("Created Table")
        } catch {
            print (error)
        }
    }
    
    // custom : createTable (create SQL table for each new habit)
    func createHabitTable(_ habitString: String) {
        print("Creating \(habitString) Table...")
        let tempTable = Table(habitString)
        let createTable = tempTable.create { (table) in
            table.column(self.id, primaryKey: true)
            table.column(self.year)
            table.column(self.month)
            table.column(self.day)
            table.column(self.completed)
        }
        do {
            try self.database.run(createTable)
            print("Created Table")
            addDay(habit: habitString)
        } catch {
            print (error)
        }
    }
    
    // custom : addDay(add a day to habit completed table)
    func addDay(habit: String) {
        print("Adding day...")
        do {
            let table = Table(habit)
            let date = Date()
            let calendar = Calendar.current
            let year = calendar.component(.year, from: date)
            let month = calendar.component(.month, from: date)
            let day = calendar.component(.day, from: date)
            
            let addDay = table.insert(self.year <- year, self.month <- month, self.day <- day, self.completed <- 0)
            
            
                try self.database.run(addDay)
                print("Day Added -> year: \(year), month: \(month), day: \(day)")
        } catch {
            print (error)
        }
    }
    
    // UIButton : addEntry (add an entry)
    @IBAction func addEntry(_ sender: Any) {
        print("Adding habit...")
        createTable()
        let alert = UIAlertController(title: "Add Habit", message: nil, preferredStyle: .alert)
        alert.addTextField { (tf) in
            tf.placeholder = "Habit"
        }
        alert.addTextField { (tf) in
            tf.placeholder = "Time"
        }
        let action = UIAlertAction(title: "Submit", style: .default) { (_) in
            guard let habit = alert.textFields?.first?.text,
                let time = alert.textFields?.last?.text
            else {
                return
            }

            let addHabit = self.habitsTable.insert(self.habit <- habit, self.time <- time, self.streak <- 0, self.currentDay <- 1)
            
            do {
                try self.database.run(addHabit)
                print("Habit Added -> habit: \(habit), time: \(time)")
                self.createHabitTable(habit)
                self.habitTableView.reloadData()
            } catch {
                print (error)
            }
        }
        alert.addAction(action)
        let cancel = UIAlertAction(title: "Cancel", style: UIAlertAction.Style.cancel, handler: nil)
        alert.addAction(cancel)
        present(alert, animated: true, completion: nil)
    }
    
    // UIButton : deleteHabit (delete an entry)
    // *** Disconnected - Not being used ***
    @IBAction func deleteHabit(_ sender: Any) {
        print("Deleting entry...")
        let alert = UIAlertController(title: "Delete Habit", message: nil, preferredStyle: .alert)
        alert.addTextField { (tf) in
            tf.placeholder = "Habit ID" }
        let action = UIAlertAction(title: "Submit", style: .default) { (_) in
            guard let habitIdString = alert.textFields?.first?.text,
                let habitId = Int(habitIdString)
            else { return }
            
            let habit = self.habitsTable.filter(self.id == habitId)
            let deleteHabit = habit.delete()
            do {
                try self.database.run(deleteHabit)
                print("Deleted Habit #: \(habitIdString)")
            } catch {
                print(error)
            }
        }
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
    
    // UIButton : updateTable (edit an entry)
    @IBAction func updateTable(_ sender: Any) {
        print("Updating table...")
        let alert = UIAlertController(title: "Update Habit", message: nil, preferredStyle: .alert)
        alert.addTextField { (tf) in
            tf.placeholder = "Habit ID" }
        alert.addTextField {(tf) in tf.placeholder = "Habit" }
        let action = UIAlertAction(title: "Submit", style: .default) { (_) in
            guard let habitIdString = alert.textFields?.first?.text, let habitId = Int(habitIdString), let habitString = alert.textFields?.last?.text
                else { return }
            
            let habit = self.habitsTable.filter(self.id == habitId)
            let updateHabit = habit.update(self.habit <- habitString)
            do {
                try self.database.run(updateHabit)
                print("Updated table.")
                self.habitTableView.reloadData()
            } catch {
                print(error)
            }
        }
        alert.addAction(action)
        let cancel = UIAlertAction(title: "Cancel", style: UIAlertAction.Style.cancel, handler: nil)
        alert.addAction(cancel)
        present(alert, animated: true, completion: nil)
    }
    
    // custom : getTableSize (size of database table)
    func getTableSize() -> Int {
        var count = 0;
        do {
            let habits = try self.database.prepare(self.habitsTable)
            for _ in habits {
                count += 1
            }
        } catch {
            print (error)
        }
        return (count)
    }
    
    // collectionView : numberOfItemsInSection
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if (daysArray.count == 1) {
            createDaysArray()
        }
        return (daysArray.count)
    }
    
    // collectionView : cellForItemAt
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let item = collectionView.dequeueReusableCell(withReuseIdentifier: "dateCell", for: indexPath)
            as! DateCollectionViewCell
        
        item.monthUILabel?.text = currentMonth
        item.dayUILabel?.text = String(daysArray[indexPath.row])
    
        return (item)
    }
    
    // collectionView : didSelectItemAt
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath)
    {
        if let cell = collectionView.cellForItem(at: indexPath) {
            cell.isSelected = true;
        }
    }
    
    // tableView : numberOfRowsInSection
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (getTableSize())
    }
    
    // tableView : cellForRowAt
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
            as! HabitTableViewCell
        
        // since the database only increments from the last ID,
        // this for loop fixes issues with gaps in the database.
        var count = 0
        do {
            let habits = try self.database.prepare(self.habitsTable)
            for habit in habits {
                if (count == indexPath.row) {
                    cell.habitUILabel?.text = habit[self.habit]
                    cell.timeUILabel?.text = habit[self.time]
                    cell.streakUILabel?.text = String(habit[self.streak])
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
    
    // custom : deleteTable (delete SQL table)
    func deleteHabitTable(habit: String) {
        print("Deleting \(habit) Table...")
        let table = Table(habit)
        let deleteTable = table.drop()
        do {
            try self.database.run(deleteTable)
            print("Deleted Table")
        } catch {
            print (error)
        }
    }
    
    // tableView : editingStyle
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath)
    {
        if (editingStyle == UITableViewCell.EditingStyle.delete) {
            print("Deleting habit...")
            // new
            var count = 0
            var firstId = 0
            
            var tempString = ""
            if let cell: HabitTableViewCell = (tableView.cellForRow(at: indexPath) as! HabitTableViewCell) {
                tempString = cell.habitUILabel?.text as! String
            }
            deleteHabitTable(habit: tempString)
            do {
                let habits = try self.database.prepare(self.habitsTable)
                for habit in habits {
                    if (count == 0) {
                        firstId = habit[self.id]
                    }
                    if (count == indexPath.row) {
                        let habit = self.habitsTable.filter(self.id == (count+firstId))
                        let deleteHabit = habit.delete()
                        do {
                            try self.database.run(deleteHabit)
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
    
    // custom : markCompleted
    func markCompleted(habit: String, row: Int, val: Int) {
        print("Updating completed...")
        do {
            let table = Table(habit)
            let days = try self.database.prepare(table)
            for day in days {
                print("id: \(day[self.id]), completed: \(day[self.completed])")
                if (day[self.id] == row) {
                    print("id == \(row)")
                    let temp = table.filter(self.id == row)
                    let updateHabit = temp.update(self.completed <- val)
                    do {
                        try self.database.run(updateHabit)
                        print("Habit (completed) updated")
                    } catch {
                        print(error)
                    }
                }
            }
        } catch {
            print(error)
        }
    }
    
    // custom : countStreak
    func countStreak(habit: String) -> Int {
        print("Counting streak...")
        var count = 0
        do {
            let table = Table(habit)
            let days = try self.database.prepare(table)
            for day in days {
                print("id: \(day[self.id]), completed: \(day[self.completed])")
                if (day[self.completed] == 1) {
                    print("incrementing count...")
                    count += 1
                }
            }
        } catch {
            print(error)
        }
        print("streak: \(count)")
        return(count)
    }
    
    // custom : updateStreak
    func updateStreak(row: Int, inc: Int, habitString: String) {
        print("Updating streak...")
        var count = 0
        var firstId = 0
        do {
            let habits = try self.database.prepare(self.habitsTable)
            for habit in habits {
                if (count == 0) {
                    firstId = habit[self.id]
                }
                if (count == row) {
                    let habit = self.habitsTable.filter(self.id == count+firstId)
                    let tempRow = 1
                    markCompleted(habit: habitString, row: tempRow, val: inc)
                    let currentStreak = countStreak(habit: habitString)
                    let updateHabit = habit.update(self.streak <- currentStreak)
                    do {
                        try self.database.run(updateHabit)
                        print("Updated streak")
                        self.habitTableView.reloadData()
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
    
    // tableView : didSelectRowAt
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("Selected row: \(indexPath.row)")
        if let cell: HabitTableViewCell = (tableView.cellForRow(at: indexPath) as! HabitTableViewCell) {
            let tempString = cell.habitUILabel?.text as! String
            if cell.accessoryType == UITableViewCell.AccessoryType.checkmark {
                cell.accessoryType = .none
//                let temp = cell.
                updateStreak(row: indexPath.row, inc: 0, habitString: tempString)
            }
            else {
                cell.accessoryType = .checkmark
                updateStreak(row: indexPath.row, inc: 1, habitString: tempString)
            }
        }
        self.habitTableView.reloadData()
    }
    
    // viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        do {
            let documentDirectory = try FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
            let fileUrl = documentDirectory.appendingPathComponent("habits").appendingPathExtension("sqlite3")
            let database = try Connection(fileUrl.path)
            self.database = database
        } catch {
            print(error)
        }
        
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
            UserDefaults.standard.set(Date(), forKey: "lastRun")
        } else {
            print("Day has not changed.")
        }
//        if (lastRun != date) {
//            print("Date has changed. Updating last saved date...")
//            UserDefaults.standard.set(Date(), forKey: "lastRun")
//        } else {
//            print("Date has not changed.")
//        }
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
