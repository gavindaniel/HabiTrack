//
//  DevViewController.swift
//  HabiTrack
//
//  Created by Gavin Daniel on 8/22/19.
//  Copyright © 2019 Gavin Daniel. All rights reserved.
//

import UIKit
import SQLite

class DevelopmentVC: UIViewController, UITableViewDelegate, UITableViewDataSource {

    var list = ["Delete Database Table (S)",
//                "Force Update Habit ID (S)",
                "Update Local Table From Database (S)",
                "Force Update Habit IDs (S)",
                "Print Database Journal Table",
                "Print Local Journal Table",
                "Print Current Date",
                "Print Date Selected",
                "Delete Habit",
                "Force Add Days",
                "Update Habit Day",
                "Update Habit Repeat"]
    
    var database: Connection!
    let journal = Journal()
    
    @IBOutlet weak var devTableView: UITableView!
    
    // viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        do {
            let documentDirectory = try FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
            let fileUrl = documentDirectory.appendingPathComponent("habits").appendingPathExtension("sqlite3")
            let database = try Connection(fileUrl.path)
            self.database = database
            self.journal.database = database
        } catch {
            print(error)
        }
    }
    
    // tableView : numberOfRowsInSection
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (list.count)
    }
    
    // tableView : cellForRowAt -> cell
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: UITableViewCell.CellStyle.default, reuseIdentifier: "devCell")
        cell.textLabel?.text = list[indexPath.row]
        
        return (cell)
    }
    
    // tableView : didSelectRowAt
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selection = list[indexPath.row]
        switch selection {
        case "Delete Database Table (S)":
            deleteDatabaseTable()
//        case "Force Update Habit ID (S)":
//            updateID()
        case "Update Local Table From Database (S)":
            updateLocalTable()
        case "Force Update Habit IDs (S)":
            updateHabitIDs()
        case "Print Database Journal Table":
            printDatabaseTable()
        case "Print Local Journal Table":
            printLocalTable()
        case "Print Current Date":
            printDayOfWeek()
        case "Print Date Selected":
//            printDateSelected()
            break
        case "Delete Habit":
            deleteHabitById()
        case "Force Add Days":
            addDays()
        case "Force Delete Days":
            deleteDays()
        case "Update Habit Day":
            updateDayOfWeek()
        case "Update Habit Repeat":
            updateRepeatById()
        default:
            print("default")
        }
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    // custom : getTableSize (size of database table)
    func getTableSize(habit: String) -> Int {
        var count = 0;
        do {
            let table = Table(habit)
            let habits = try self.database.prepare(table)
            for _ in habits {
                count += 1
            }
        } catch {
            print(error)
        }
        return (count)
    }
    
    
    // custom : printTable (select row in table)
    func printDatabaseTable() {
        print()
        print("Printing database table...")
        do {
            let habits = try self.database.prepare(self.journal.habitsTable)
            for habit in habits {
                print("\tid: \(habit[self.journal.id]), habit: \(habit[self.journal.habit]), time: \(habit[self.journal.time]), current day: \(habit[self.journal.dayOfWeek])")
                // uncomment to print daily entries
//                printJournalEntries(habit[self.journal.habit])
            }
        } catch {
            print(error)
        }
    }
    
    
    // UIButton : printEntriesTable
    func printJournalEntries(_ habit: String) {
        do {
            let table = Table(habit)
            let habits = try self.database.prepare(table)
            for entry in habits {
                print("\t\tid: \(entry[self.journal.entries.id]), year: \(entry[self.journal.entries.year]), month: \(entry[self.journal.entries.month]), day: \(entry[self.journal.entries.day]), done: \(entry[self.journal.entries.completed])")
            }
        } catch {
            print (error)
        }
    }
    

    // custom : printTable (select row in table)
    func printLocalTable() {
        print()
        print("Printing local table...")
        let defaults = UserDefaults.standard
        let habits = defaults.object(forKey: "localHabits") as! [String]
        var count = 1
        for habit in habits {
            print("\tid: \(count), habit: \(habit)")
//            printJournalEntries(habit[self.journal.habit])
            count += 1
        }
    }
    
    
    // custom : deleteTable (delete SQL table)
    func deleteDatabaseTable() {
        print("Deleting Table...")
        let deleteTable = self.journal.habitsTable.drop()
        do {
            try self.database.run(deleteTable)
            print("Deleted Table")
        } catch {
            print (error)
        }
    }
    
    
    // custom : Add Day Entry to a Habit
    func addDays() {
        // to be changed for testing
        print("Force adding day...")
        // create alert controller
        let alert = UIAlertController(title: "Add Day(s) To Habit", message: nil, preferredStyle: .alert)
        // add text fields
        alert.addTextField { (tf) in
            tf.placeholder = "Habit" }
        alert.addTextField { (tf) in
        tf.placeholder = "# Days" }
        // create 'Submit' action
        let submit = UIAlertAction(title: "Submit", style: .default) { (_) in
            // get strings from text fields
            guard let habitString = alert.textFields?.first?.text, let numDaysString = alert.textFields?.last?.text, let numDays = Int(numDaysString)
            else { return }
            
            if (habitString == "All") {
                var temp = 0
                let table = Table("habits")
                while temp < numDays {
                    do {
                        let habits = try self.database.prepare(table)
                        for _ in habits {
                            let year = Calendar.current.component(.year, from: Date())
                            let month = Calendar.current.component(.month, from:  Date())
                            let day = Calendar.current.component(.day, from:  Date())
                            let dayAdd = table.insert(self.journal.entries.year <- year, self.journal.entries.month <- month, self.journal.entries.day <- day, self.journal.entries.completed <- 0)
                            do {
                                try self.database.run(dayAdd)
                            } catch {
                                print(error)
                            }
                        }
                    } catch {
                        print(error)
                    }
                    temp += 1
                }
            } else {
                // find the correct in the table
//                let habit = self.journal.habitsTable.filter(self.journal.habit == habitString)
                // udpate the habit
                let table = Table(habitString)
                let year = Calendar.current.component(.year, from: Date())
                let month = Calendar.current.component(.month, from:  Date())
                let day = Calendar.current.component(.day, from:  Date())
                let dayAdd = table.insert(self.journal.entries.year <- year, self.journal.entries.month <- month, self.journal.entries.day <- day, self.journal.entries.completed <- 0)
                do {
                    try self.database.run(dayAdd)
                } catch {
                    print(error)
                }
            }
        }
        alert.addAction(submit)
        // create 'Cancel' alert action
        let cancel = UIAlertAction(title: "Cancel", style: UIAlertAction.Style.cancel, handler: nil)
        alert.addAction(cancel)
        present(alert, animated: true, completion: nil)
    }
    
    
    
    // custom : Delete Day Entry for a Habit
    func deleteDays() {
        // to be changed for testing
        print("Force deleting day...")
        // create alert controller
        let alert = UIAlertController(title: "Delete Day(s) From Habit", message: nil, preferredStyle: .alert)
        // add text fields
        alert.addTextField { (tf) in
            tf.placeholder = "Habit" }
        alert.addTextField { (tf) in
        tf.placeholder = "# Days" }
        // create 'Submit' action
        let submit = UIAlertAction(title: "Submit", style: .default) { (_) in
            // get strings from text fields
            guard let habitString = alert.textFields?.first?.text, let numDaysString = alert.textFields?.last?.text, let numDays = Int(numDaysString)
            else { return }
            
            if (habitString == "All") {
                var temp = 0
                let table = Table("habits")
                while temp < numDays {
                    do {
                        let habits = try self.database.prepare(table)
                        for _ in habits {
                            let year = Calendar.current.component(.year, from: Date())
                            let month = Calendar.current.component(.month, from:  Date())
                            let day = Calendar.current.component(.day, from:  Date())
                            do {
                                // loop through the table
                                let entry = table.filter(self.journal.entries.year == year).filter(self.journal.entries.month == month).filter(self.journal.entries.day == day)
                                // delete the habit
                                let deleteDay = entry.delete()
                                try self.database.run(deleteDay)
                                print("Deleted entry")
                            } catch {
                                print(error)
                            }
                        }
                    } catch {
                        print(error)
                    }
                    temp += 1
                }
            } else {
                // find the correct in the table
                let table = Table(habitString)
                let year = Calendar.current.component(.year, from: Date())
                let month = Calendar.current.component(.month, from:  Date())
                let day = Calendar.current.component(.day, from:  Date())
                do {
                    // loop through the table
                    let entry = table.filter(self.journal.entries.year == year).filter(self.journal.entries.month == month).filter(self.journal.entries.day == day)
                    // delete the habit
                    let deleteDay = entry.delete()
                    try self.database.run(deleteDay)
                    print("Deleted entry")
                } catch {
                    print(error)
                }
            }
        }
        alert.addAction(submit)
        // create 'Cancel' alert action
        let cancel = UIAlertAction(title: "Cancel", style: UIAlertAction.Style.cancel, handler: nil)
        alert.addAction(cancel)
        present(alert, animated: true, completion: nil)
    }
    
    func deleteHabitById() {
        print("deleting habit from table...")
        // create alert controller
        let alert = UIAlertController(title: "Delete Habit", message: nil, preferredStyle: .alert)
        // add text fields
        alert.addTextField { (tf) in
            tf.placeholder = "Habit ID" }
        // create 'Submit' action
        let submit = UIAlertAction(title: "Submit", style: .default) { (_) in
            // get strings from text fields
            guard let habitIdString = alert.textFields?.first?.text, let habitId = Int(habitIdString)
                else { return }
            // find the correct in the table
            let habit = self.journal.habitsTable.filter(self.journal.id == habitId)
            // udpate the habit
            let deleteHabit = habit.delete()
            
            // attempt to update the database
            do {
                try self.journal.database.run(deleteHabit)
                print("deleted habit.")
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
    
    func updateLocalTable() {
        print("updateLocalTable...")
        if (isKeyPresentInUserDefaults(key: "localHabits") == false) {
            let defaults = UserDefaults.standard
            defaults.set([String](), forKey: "localHabits")
        }
        do {
            let table = Table("habits")
            let habits = try self.database.prepare(table)
            let defaults = UserDefaults.standard
            var localHabits = [String]()
            for habit in habits {
                localHabits.append(habit[self.journal.habit])
            }
            defaults.set(localHabits, forKey: "localHabits")
        } catch {
            print(error)
        }
    }
    
    
    func updateHabitIDs() {
        print("updateHabitIDs...")
        do {
            // define variable(s)
            let table = Table("habits")
            let habits = try self.database.prepare(table)
            var index = 1, currId = 1, diff = 0, numUpdates = 0
            // loop through habits table
            for habit in habits {
                // calculate difference = current habit ID - loop index
                currId = habit[self.journal.id]
                diff = currId - index
                // check if there is a difference
                if (diff > 0) {
                    // calculate the new ID based on the difference between database table and local table
                    let newId = currId - diff
                    // get the habit with the current ID
                    let tempHabit = self.journal.habitsTable.filter(self.journal.id == currId)
                    let updateHabit = tempHabit.update(self.journal.id <- newId)
                    // attempt to update the database
                    do {
                        try self.journal.database.run(updateHabit)
                        print("\tupdated habit ID...\(habit[self.journal.id])->\(newId)")
                        numUpdates += 1
                    } catch {
                        print(error)
                    }
                }
                // increment ID
                index += 1
            } // end for loop
            // check for no updates
            if (numUpdates == 0) {
                print("\tno IDs updated")
            }
        } catch {
            print(error)
        }
    } // end func
//
//    func updateID() {
//        let oldId = 999
//        let newId = 4
//        let tempHabit = self.journal.habitsTable.filter(self.journal.id == oldId)
//        let updateHabit = tempHabit.update(self.journal.id <- newId)
//
//        // attempt to update the database
//        do {
//            try self.journal.database.run(updateHabit)
//            print("updated habit ID.")
//        } catch {
//            print(error)
//        }
//    }
    
    func updateRepeatById() {
        print("updating repeat for habit...")
        // create alert controller
        let alert = UIAlertController(title: "Update Repeat", message: nil, preferredStyle: .alert)
        // add text fields
        alert.addTextField { (tf) in
            tf.placeholder = "Habit ID" }
        alert.addTextField { (tf) in
            tf.placeholder = "Repeat" }
        // create 'Submit' action
        let submit = UIAlertAction(title: "Submit", style: .default) { (_) in
            // get strings from text fields
            guard let habitIdString = alert.textFields?.first?.text, let habitId = Int(habitIdString), let habitRepeat = alert.textFields?.last?.text
                else { return }
            // find the correct in the table
            let habit = self.journal.habitsTable.filter(self.journal.id == habitId)
            // udpate the habit
            let updateHabit = habit.update(self.journal.time <- habitRepeat)
            
            // attempt to update the database
            do {
                try self.journal.database.run(updateHabit)
                print("updated habit repeat.")
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
    
    func updateDayOfWeek() {
        print("updating day of week for journal entry...")
        // create alert controller
        let alert = UIAlertController(title: "Update Week Day", message: nil, preferredStyle: .alert)
        // add text fields
        alert.addTextField { (tf) in
            tf.placeholder = "Habit ID" }
        alert.addTextField { (tf) in
            tf.placeholder = "Day Of Week" }
        // create 'Submit' action
        let submit = UIAlertAction(title: "Submit", style: .default) { (_) in
            // get strings from text fields
            guard let habitIdString = alert.textFields?.first?.text, let habitId = Int(habitIdString), let habitDayString = alert.textFields?.last?.text, let habitDayOfWeek = Int(habitDayString)
                else { return }
            // find the correct in the table
            let habit = self.journal.habitsTable.filter(self.journal.id == habitId)
            // udpate the habit
            let updateHabit = habit.update(self.journal.dayOfWeek <- habitDayOfWeek)
            
            // attempt to update the database
            do {
                try self.journal.database.run(updateHabit)
                print("updated habit repeat.")
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
    
    func printDayOfWeek() {
        print("current Date: \(Date())")
    }
    
}

