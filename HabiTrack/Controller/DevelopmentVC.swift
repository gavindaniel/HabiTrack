//
//  DevViewController.swift
//  HabiTrack
//
//  Created by Gavin Daniel on 8/22/19.
//  Copyright © 2019 Gavin Daniel. All rights reserved.
//

import UIKit
import CoreData

class DevelopmentVC: UIViewController, UITableViewDelegate, UITableViewDataSource {

    var list = ["Force Delete Database Table",
                "Force Update Local Table From Database",
                "Force Update Database Habit IDs",
                "Print Database Journal Table",
                "Print Local Journal Table",
                "Print Current Date",
                "Print Date Selected",
                "Print Last Cell Selected",
                "Add Entry Days for Habit",
                "Delete Habit Entry Days",
                "Delete Habit From Database",
                "Update Habit Weekdays"]
    
    var database: Connection!
    let habits = Habits()
    
    @IBOutlet weak var devTableView: UITableView!
    
    
    // name: viewDidLoad
    // desc:
    // last updated: 4/28/2020
    // last update: cleaned up
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        do {
            let documentDirectory = try FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
            let fileUrl = documentDirectory.appendingPathComponent("habits").appendingPathExtension("sqlite3")
            let database = try Connection(fileUrl.path)
            self.database = database
            self.habits.database = database
        } catch {
            print(error)
        }
    }
    
    
    // name: numberOfRowsInSection
    // desc:
    // last updated: 4/28/2020
    // last update: cleaned up
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (list.count)
    }
    
    
    // name: cellForRowAt
    // desc:
    // last updated: 4/28/2020
    // last update: cleaned up
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: UITableViewCell.CellStyle.default, reuseIdentifier: "devCell")
        cell.textLabel?.text = list[indexPath.row]
        return (cell)
    }
    
    
    // name: didSelectRowAt
    // desc:
    // last updated: 4/28/2020
    // last update: cleaned up
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selection = list[indexPath.row]
        switch selection {
        case "Force Delete Database Table":
            deleteDatabaseTable()
        case "Force Update Local Table From Database":
            updateLocalTable()
        case "Force Update Database Habit IDs":
            updateHabitIDs()
        case "Print Database Journal Table":
            printDatabaseTable()
        case "Print Local Journal Table":
            printLocalTable()
        case "Print Current Date":
            printDayOfWeek()
        case "Print Date Selected":
            printDateSelected()
//            break
        case "Print Last Cell Selected":
            printLastCellSelected()
        case "Add Entry Days for Habit":
            addDays()
        case "Delete Habit Entry Days":
            deleteDays()
        case "Delete Habit From Database":
            deleteHabit()
        case "Update Habit Weekdays":
            updateHabitWeekdays()
        default:
            print("default")
        }
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    
    // name: deleteDatabaseTable
    // desc: Force Delete Database Table
    // last updated: 5/16/2020
    // last update: cleaned up
    func deleteDatabaseTable() {
        print("Force Delete Database Table...")
        // create alert controller
        let alert = UIAlertController(title: "Force Delete Database Table?", message: nil, preferredStyle: .alert)
        // create 'Submit' action
        let confirm = UIAlertAction(title: "Confirm", style: .default) { (_) in
            // delete the database table
            let deleteTable = self.habits.habitsTable.drop()
            do {
                try self.database.run(deleteTable)
                print("Deleted Table")
            } catch {
                print (error)
            }
        }
        alert.addAction(confirm)
        // create 'Cancel' alert action
        let cancel = UIAlertAction(title: "Cancel", style: UIAlertAction.Style.cancel, handler: nil)
        alert.addAction(cancel)
        present(alert, animated: true, completion: nil)
    }
    
    
    // name: updateLocalTable
    // desc: Force Update Local Table From Database
    // last updated: 5/16/2020
    // last update: cleaned up
    func updateLocalTable() {
        print("Force Update Local Table From Database...")
        // create alert controller
        let alert = UIAlertController(title: "Force Update Local Table From Database?", message: nil, preferredStyle: .alert)
        // create 'Submit' action
        let confirm = UIAlertAction(title: "Confirm", style: .default) { (_) in
            if (isKeyPresentInUserDefaults(key: "localHabits") == false) {
                let defaults = UserDefaults.standard
                defaults.set([String](), forKey: "localHabits")
            }
            do {
                let table = Table("habits")
                let habitsTable = try self.database.prepare(table)
                let defaults = UserDefaults.standard
                var localHabits = [String]()
                for habit in habitsTable {
                    localHabits.append(habit[self.habits.name])
                }
                defaults.set(localHabits, forKey: "localHabits")
            } catch {
                print(error)
            }
        }
        alert.addAction(confirm)
        // create 'Cancel' alert action
        let cancel = UIAlertAction(title: "Cancel", style: UIAlertAction.Style.cancel, handler: nil)
        alert.addAction(cancel)
        present(alert, animated: true, completion: nil)
    }
    
    
    // name: updateHabitIDs
    // desc: Force Update Database Habit IDs
    // last updated: 5/16/2020
    // last update: cleaned up
    func updateHabitIDs() {
        print("Force Update Database Habit IDs...")
        // create alert controller
        let alert = UIAlertController(title: "Force Update Database Habit IDs?", message: nil, preferredStyle: .alert)
        // create 'Submit' action
        let confirm = UIAlertAction(title: "Confirm", style: .default) { (_) in
            print("updateHabitIDs...")
            do {
                // define variable(s)
                let table = Table("habits")
                let habits = try self.database.prepare(table)
                var index = 1, currId = 1, diff = 0, numUpdates = 0
                // loop through habits table
                for habit in habits {
                    // calculate difference = current habit ID - loop index
                    currId = habit[self.habits.id]
                    diff = currId - index
                    // check if there is a difference
                    if (diff > 0) {
                        // calculate the new ID based on the difference between database table and local table
                        let newId = currId - diff
                        // get the habit with the current ID
                        let tempHabit = self.habits.habitsTable.filter(self.habits.id == currId)
                        let updateHabit = tempHabit.update(self.habits.id <- newId)
                        // attempt to update the database
                        do {
                            try self.habits.database.run(updateHabit)
                            print("\tupdated habit ID...\(habit[self.habits.id])->\(newId)")
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
        }
        alert.addAction(confirm)
        // create 'Cancel' alert action
        let cancel = UIAlertAction(title: "Cancel", style: UIAlertAction.Style.cancel, handler: nil)
        alert.addAction(cancel)
        present(alert, animated: true, completion: nil)
    }
    
    
    // name:
    // desc:
    // last updated: 4/28/2020
    // last update: cleaned up
    func printDayOfWeek() {
        print("current Date: \(Date())")
    }
    
    
    // name: printDateSelected
    // desc: print globabl date selected
    // last updated: 5/16/2020
    // last update: new
    func printDateSelected() {
        print("date selected: \(dateSelected)")
    }
    
    
    // name: printLastCellSelected
    // desc: print journal date cell selected
    // last updated: 7/1/2020
    // last update: new
    func printLastCellSelected() {
        print("last cell selected: \(lastSelectedCell)")
    }
    
    
    // name:
    // desc:
    // last updated: 4/28/2020
    // last update: cleaned up
    func printDatabaseTable() {
        print()
        print("Printing database table...")
        do {
            let habits = try self.database.prepare(self.habits.habitsTable)
            for habit in habits {
                print("\tid: \(habit[self.habits.id]), name: \(habit[self.habits.name]), days: \(habit[self.habits.days]), start date: \(habit[self.habits.startDay])/\(habit[self.habits.startMonth])/\(habit[self.habits.startYear])")
                // uncomment to print daily entries
//                printJournalEntries(habit[self.habits.habit])
            }
        } catch {
            print(error)
        }
    }
    
    
    // name: printJournalEntries
    // desc:
    // last updated: 4/28/2020
    // last update: cleaned up
    func printJournalEntries(_ habit: String) {
        do {
            let table = Table(habit)
            let habits = try self.database.prepare(table)
            for entry in habits {
                print("\t\tid: \(entry[self.habits.entries.id]), year: \(entry[self.habits.entries.year]), month: \(entry[self.habits.entries.month]), day: \(entry[self.habits.entries.day]), done: \(entry[self.habits.entries.completed])")
            }
        } catch {
            print (error)
        }
    }
    
    
    // name:
    // desc:
    // last updated: 4/28/2020
    // last update: cleaned up
    func printLocalTable() {
        print()
        print("Printing local table...")
        let defaults = UserDefaults.standard
        let habits = defaults.object(forKey: "localHabits") as! [String]
        var count = 1
        for habit in habits {
            print("\tid: \(count), habit: \(habit)")
//            printJournalEntries(habit[self.habits.habit])
            count += 1
        }
    }
    
    
    // name: addDays
    // desc:
    // last updated: 4/28/2020
    // last update: cleaned up
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
                            let dayAdd = table.insert(self.habits.entries.year <- year, self.habits.entries.month <- month, self.habits.entries.day <- day, self.habits.entries.completed <- 0)
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
//                let habit = self.habits.habitsTable.filter(self.habits.habit == habitString)
                // udpate the habit
                let table = Table(habitString)
                let year = Calendar.current.component(.year, from: Date())
                let month = Calendar.current.component(.month, from:  Date())
                let day = Calendar.current.component(.day, from:  Date())
                let dayAdd = table.insert(self.habits.entries.year <- year, self.habits.entries.month <- month, self.habits.entries.day <- day, self.habits.entries.completed <- 0)
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
    
    
    // name: deleteDays
    // desc:
    // last updated: 4/28/2020
    // last update: cleaned up
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
                                let entry = table.filter(self.habits.entries.year == year).filter(self.habits.entries.month == month).filter(self.habits.entries.day == day)
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
                    let entry = table.filter(self.habits.entries.year == year).filter(self.habits.entries.month == month).filter(self.habits.entries.day == day)
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
    
    
    // name: deleteHabit
    // desc:
    // last updated: 5/16/2020
    // last update: cleaned up
    func deleteHabit() {
        print("deleting habit from database table...")
        // create alert controller
        let alert = UIAlertController(title: "Delete Habit From Database", message: nil, preferredStyle: .alert)
        // add text fields
        alert.addTextField { (tf) in
            tf.placeholder = "Habit" }
        // create 'Submit' action
        let submit = UIAlertAction(title: "Submit", style: .default) { (_) in
            // get strings from text fields
            guard let habitString = alert.textFields?.first?.text
                else { return }
            // find the correct in the table
            let habit = self.habits.habitsTable.filter(self.habits.name == habitString)
            // udpate the habit
            let deleteHabit = habit.delete()
            
            // attempt to update the database
            do {
                try self.habits.database.run(deleteHabit)
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
    
    
    // name: updateHabitWeekdays
    // desc: Pop-up for updating the repeat days for a habit
    // last updated: 5/16/2020
    // last update: cleaned up
    func updateHabitWeekdays() {
        print("updating day of week for habits entry...")
        // create alert controller
        let alert = UIAlertController(title: "Update Weekdays For Habit", message: nil, preferredStyle: .alert)
        // add text fields
        alert.addTextField { (tf) in
            tf.placeholder = "Habit" }
        alert.addTextField { (tf) in
            tf.placeholder = "1234567" }
        // create 'Submit' action
        let submit = UIAlertAction(title: "Submit", style: .default) { (_) in
            // get strings from text fields
            guard let habitString = alert.textFields?.first?.text, let habitWeekdayString = alert.textFields?.last?.text, let habitWeekdays = Int(habitWeekdayString)
                else { return }
            // find the correct in the table
            let habit = self.habits.habitsTable.filter(self.habits.name == habitString)
            // udpate the habit
            let updateHabit = habit.update(self.habits.days <- habitWeekdays)
            
            // attempt to update the database
            do {
                try self.habits.database.run(updateHabit)
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
    } // end func
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    // name: getTableSize
    // desc:
    // last updated: 5/16/2020
    // last update: cleaned up
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
}

