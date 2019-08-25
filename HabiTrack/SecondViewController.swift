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

    var list = ["Manage Habits", "Dark Mode", "Print Table"]
    
    var database: Connection!
    let habitsTable = Table("habits")
    let id = Expression<Int>("id")
    let habit = Expression<String>("habit")
    let time = Expression<String>("time")
    let streak = Expression<Int>("streak")
    
    @IBOutlet weak var settingsTableView: UITableView!

    
    // custom : getTableSize (size of database table)
    func getTableSize() -> Int {
        var count = 0;
        do {
            let habits = try self.database.prepare(self.habitsTable)
            for _ in habits {
                count += 1
            }
        } catch {
            print(error)
        }
        return (count)
    }
    
    // custom : printTable (select row in table)
    func printTableSelect() {
        print("Printing table...")
        do {
            let habits = try self.database.prepare(self.habitsTable)
            //            getTableSize()
            print("# entries: \(getTableSize())")
            for habit in habits {
                print("id: \(habit[self.id]), habit: \(habit[self.habit]), time: \(habit[self.time]), streak: \(habit[self.streak])")
            }
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
        let cell = UITableViewCell(style: UITableViewCell.CellStyle.default, reuseIdentifier: "settingCell")
        cell.textLabel?.text = list[indexPath.row]
        
        return (cell)
    }
    
    // tableView : didSelectRowAt
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("Selected row: \(indexPath.row)")
//        if let cell = tableView.cellForRow(at: indexPath) {
            if (list[indexPath.row] == "Print Table") {
                printTableSelect()
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

