//
//  SecondViewController.swift
//  HabiTrack
//
//  Created by Gavin Daniel on 8/22/19.
//  Copyright © 2019 Gavin Daniel. All rights reserved.
//

import UIKit
import SQLite

class SettingsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    var list = ["Manage Habits", "Dark Mode", "Print Table", "Print Habit Table", "Delete Table"]
    
    var database: Connection!
    let habitsTable = Table("habits")
    let id = Expression<Int>("id")
    let habit = Expression<String>("habit")
    let time = Expression<String>("time")
    
    let year = Expression<Int>("year")
    let month = Expression<Int>("month")
    let day = Expression<Int>("day")
    let completed = Expression<Int>("completed")
    
    @IBOutlet weak var settingsTableView: UITableView!

    
    // custom : getTableSize (size of database table)
    func getTableSize(habit: String) -> Int {
        var count = 0;
        do {
//            let habits = try self.database.prepare(self.habitsTable)
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
            let habits = try self.database.prepare(self.habitsTable)
//            print("# entries: \(getTableSize())")
            print("# entries: \(getTableSize(habit: "habits"))")
            for habit in habits {
                print("id: \(habit[self.id]), habit: \(habit[self.habit]), time: \(habit[self.time])")
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
            //            getTableSize()
            print("# entries: \(getTableSize(habit: habit))")
            for entry in habits {
                print("id: \(entry[self.id]), year: \(entry[self.year]), month: \(entry[self.month]), day: \(entry[self.day]), done: \(entry[self.completed])")
            }
        } catch {
            print (error)
        }
    }
    
    // custom : deleteTable (delete SQL table)
    func deleteTable() {
        print("Deleting Table...")
        let deleteTable = self.habitsTable.drop()
        do {
            try self.database.run(deleteTable)
            print("Deleted Table")
        } catch {
            print (error)
        }
    }
    
    // tableView : numberOfRowsInSection
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (list.count)
    }
    
    // tableView : cellForRowAt -> cell
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: UITableViewCell.CellStyle.default, reuseIdentifier: "settingCell")
        cell.textLabel?.text = list[indexPath.row]
        
        return (cell)
    }
    
    // tableView : didSelectRowAt
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("Selected row: \(indexPath.row)")
//        if let cell = tableView.cellForRow(at: indexPath) {
            if (list[indexPath.row] == "Print Table") {
//                print(Date())
//                let date = Date()
//                let calendar = Calendar.current
//                print(calendar.component(.year, from: date))
//                print(calendar.component(.month, from: date))
//                print(calendar.component(.day, from: date))
                printTable()
            }
        if (list[indexPath.row] == "Print Habit Table") {
            printHabitTable("Paint")
        }
            else if (list[indexPath.row] == "Delete Table") {
                deleteTable()
            }
//        }
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
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
}

