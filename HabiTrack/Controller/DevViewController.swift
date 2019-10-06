//
//  DevViewController.swift
//  HabiTrack
//
//  Created by Gavin Daniel on 8/22/19.
//  Copyright © 2019 Gavin Daniel. All rights reserved.
//

import UIKit
import SQLite

class DevViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    var list = ["Print Table (Script)",
                "Delete Journal Table (Script)",
                "Force Add Day (Script)",
                "Force Delete Day (Script)",
                "Delete Habit (Pop-up)",
                "Force Update Local Habit Table (Script)",
                "Print Local Table (Script)",
                "Update Habit IDs (Script)",
                "Force Update Habit ID (Script)"]
    
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
        //        print("Selected row: \(indexPath.row)")
        if (list[indexPath.row] == "Print Table (Script)") {
            printTable()
        }
        else if (list[indexPath.row] == "Delete Journal Table (Script)") {
            deleteTable()
        }
        else if (list[indexPath.row] == "Force Add Day (Script)") {
            addDays()
        }
        else if (list[indexPath.row] == "Force Delete Day (Script)") {
            deleteDays()
        }
        else if (list[indexPath.row] == "Delete Habit (Pop-up)") {
            deleteHabitById()
        }
        else if (list[indexPath.row] == "Force Update Local Habit Table (Script)") {
//            self.journal.updateLocalHabits()
            updateLocalHabits()
        }
        else if (list[indexPath.row] == "Print Local Table (Script)") {
            printLocalTable()
        }
        else if (list[indexPath.row] == "Update Habit IDs (Script)") {
            updateHabitIDs()
        }
        else if (list[indexPath.row] == "Force Update Habit ID (Script)") {
            updateID()
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
    func printTable() {
        print()
        print("Printing table...")
//        print()
        do {
            let habits = try self.database.prepare(self.journal.habitsTable)
            
//            print("# entries: \(getTableSize(habit: "habits"))")
            for habit in habits {
                print()
                print("id: \(habit[self.journal.id]), habit: \(habit[self.journal.habit]), time: \(habit[self.journal.time])")
                printHabitTable(habit[self.journal.habit])
            }
        } catch {
            print(error)
        }
    }
    
    // UIButton : printTable
    func printHabitTable(_ habit: String) {
//        print("Printing \(habit) entries table...")
        do {
            let table = Table(habit)
            let habits = try self.database.prepare(table)
//            print("# entries: \(getTableSize(habit: habit))")
            for entry in habits {
                print("\tid: \(entry[self.journal.entries.id]), year: \(entry[self.journal.entries.year]), month: \(entry[self.journal.entries.month]), day: \(entry[self.journal.entries.day]), done: \(entry[self.journal.entries.completed])")
            }
        } catch {
            print (error)
        }
    }
    
    // custom : deleteTable (delete SQL table)
    func deleteTable() {
        print("Deleting Table...")
        let deleteTable = self.journal.habitsTable.drop()
        do {
            try self.database.run(deleteTable)
            print("Deleted Table")
        } catch {
            print (error)
        }
    }
    
    // custom : Add Day to "Paint" Habit Table
    func addDay(habit: String) {
        // to be changed for testing
//        let habit = "Paint"
        print("Force adding day to \(habit) entries table...")
        let table = Table(habit)
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
    
    // custom: addDays
    func addDays() {
        var temp = 0
//        var nextDay = Calendar.current.date(byAdding: .day, value: 1, to: Date)
        //        print("nextDay: \(nextDay)")
        let table = Table("habits")
        let numDays = 1
        while temp < numDays {
            do {
                let habits = try self.database.prepare(table)
                for habit in habits {
                    // do something...
//                    let tempString = habit[self.journal.habit]
//                    self.journal.habitEntries.addDay(habit: tempString, date: Date())
                    addDay(habit: habit[self.journal.habit])
                }
            } catch {
                print(error)
            }
            temp += 1
            // not sure why the ! is needed below
//            nextDay = Calendar.current.date(byAdding: .day, value: 1, to: nextDay!)
        }
    }
    
    // custom : addDay(add a day to habit completed table)
    func deleteDay(habit: String, date: Date) {
        let table = Table(habit)
        let calendar = Calendar.current
        let year = calendar.component(.year, from: date)
        let month = calendar.component(.month, from: date)
        let day = calendar.component(.day, from: date)
        //        let addDay = table.insert(self.year <- year, self.month <- month, self.day <- day, self.completed <- 0)
        
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
    
    // custom : deleteDays
    func deleteDays() {
        let table = Table("habits")
        let numDays = 1
        do {
            let habits = try self.database.prepare(table)
            for habit in habits {
                // do something...
                let tempString = habit[self.journal.habit]
                //                    entries.addDay(habit: tempString, date: nextDay ?? Date())
                let day = Calendar.current.date(byAdding: .day, value: numDays, to: Date())
                deleteDay(habit: tempString, date: day ?? Date())
            }
        } catch {
            print(error)
        }
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
    
    func updateLocalHabits() {
        print("updateLocalHabits...")
        
        if (isKeyPresentInUserDefaults(key: "localHabits") == false) {
            let defaults = UserDefaults.standard
            defaults.set([String](), forKey: "localHabits")
        }
        do {
            let table = Table("habits")
            let habits = try self.database.prepare(table)
//            self.journal.localHabbits = [String]()
            let defaults = UserDefaults.standard
            var localHabits = defaults.object(forKey: "localHabits") as! [String]
            
//            let localHabits = [String]()
            localHabits = [String]()
            
            for habit in habits {
//                self.journal.localHabbits.append(habit[self.journal.habit])
                localHabits.append(habit[self.journal.habit])
            }
//            let defaults = UserDefaults.standard
//            defaults.set(self.journal.localHabbits, forKey: "localHabits")
            defaults.set(localHabits, forKey: "localHabits")
        } catch {
            print(error)
        }
    }
    
    // custom : printTable (select row in table)
    func printLocalTable() {
        print()
        print("Printing local table...")
        print()
//        let habits = self.journal.localHabbits
        let defaults = UserDefaults.standard
        let habits = defaults.object(forKey: "localHabits") as! [String]
        var count = 1
//            print("# entries: \(getTableSize(habit: "habits"))")
        for habit in habits {
            print()
            print("id: \(count), habit: \(habit)")
//                    printHabitTable(habit[self.journal.habit])
            count += 1
            
        }
    }
    
    func updateHabitIDs() {
        print("updateHabitIDs...")
        do {
            let table = Table("habits")
            let habits = try self.database.prepare(table)
            var count = 1
            var diff = 0
            for habit in habits {
                if (count == 1) {
                    diff = habit[self.journal.id] - count
                    count = habit[self.journal.id]
                }
                let tempHabit = self.journal.habitsTable.filter(self.journal.id == count)
                
                let newId = count - diff
                let updateHabit = tempHabit.update(self.journal.id <- newId)
                
                // attempt to update the database
                do {
                    try self.journal.database.run(updateHabit)
                    print("updated habit ID.")
                } catch {
                    print(error)
                }
                
                count += 1
            }
        } catch {
            print(error)
        }
    }
    
    func updateID() {
        let oldId = 999
        let newId = 4
        let tempHabit = self.journal.habitsTable.filter(self.journal.id == oldId)
        let updateHabit = tempHabit.update(self.journal.id <- newId)
        
        // attempt to update the database
        do {
            try self.journal.database.run(updateHabit)
            print("updated habit ID.")
        } catch {
            print(error)
        }
    }
}

