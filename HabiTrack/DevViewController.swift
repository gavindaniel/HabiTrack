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

    var list = ["Print Table", "Print Eat Table", "Print Paint Table", "Print Code Table", "Delete Table", "Add Day"]
    
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
        } catch {
            print(error)
        }
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
        print("Printing table...")
        do {
            let habits = try self.database.prepare(self.journal.habitsTable)
            
            print("# entries: \(getTableSize(habit: "habits"))")
            for habit in habits {
                print("id: \(habit[self.journal.id]), habit: \(habit[self.journal.habit]), time: \(habit[self.journal.time])")
            }
        } catch {
            print(error)
        }
    }
    
    // UIButton : printTable
    func printHabitTable(_ habit: String) {
        print("Printing \(habit) entries table...")
        do {
            let table = Table(habit)
            let habits = try self.database.prepare(table)
            print("# entries: \(getTableSize(habit: habit))")
            for entry in habits {
                print("id: \(entry[self.journal.habitEntries.id]), year: \(entry[self.journal.habitEntries.year]), month: \(entry[self.journal.habitEntries.month]), day: \(entry[self.journal.habitEntries.day]), done: \(entry[self.journal.habitEntries.completed])")
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
    func addDay() {
        // to be changed for testing
        let habit = "Paint"
        print("Force adding day to \(habit) entries table...")
        let table = Table(habit)
        let year = Calendar.current.component(.year, from: Date())
        let month = Calendar.current.component(.month, from:  Date())
        let day = Calendar.current.component(.day, from:  Date())
        let dayAdd = table.insert(self.journal.habitEntries.year <- year, self.journal.habitEntries.month <- month, self.journal.habitEntries.day <- day, self.journal.habitEntries.completed <- 0)
        do {
            try self.database.run(dayAdd)
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
        print("Selected row: \(indexPath.row)")
        if (list[indexPath.row] == "Print Table") {
            printTable()
        }
        else if (list[indexPath.row] == "Print Eat Table") {
            printHabitTable("Eat")
        }
        else if (list[indexPath.row] == "Print Paint Table") {
            printHabitTable("Paint")
        }
        else if (list[indexPath.row] == "Print Code Table") {
            printHabitTable("Code")
        }
        else if (list[indexPath.row] == "Delete Table") {
            deleteTable()
        }
        else if (list[indexPath.row] == "Add Day") {
            addDay()
        }
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    
}

