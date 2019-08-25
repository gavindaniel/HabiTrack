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
    @IBOutlet weak var habitUITextField: UITextField!
}

// class: JournalViewController
class JournalViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UICollectionViewDelegate, UICollectionViewDataSource {

    // variables
    let month = "Aug"
    let days = 31
    var daysArray = [1]
    
    var database: Connection!
    let habitsTable = Table("habits")
    let id = Expression<Int>("id")
    let habit = Expression<String>("habit")
    let time = Expression<String>("time")
    let streak = Expression<Int>("streak")
    
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
    
    // UIButton : createTable (create SQL table)
   func createTable() {
        print("Creating Table...")
        let createTable = self.habitsTable.create { (table) in
            table.column(self.id, primaryKey: true)
            table.column(self.habit)
            table.column(self.time)
            table.column(self.streak)
        }
        do {
            try self.database.run(createTable)
            print("Created Table")
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
            
            let addHabit = self.habitsTable.insert(self.habit <- habit, self.time <- time, self.streak <- 0)
            
            do {
                try self.database.run(addHabit)
                print("Habit Added -> habit: \(habit), time: \(time)")
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
//                print("Updated Habit -> id: \(habitIdString), habit: \(habitString)")
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
    
    // UIButton : printTable
    @IBAction func printTable(_ sender: Any) {
        print("Printing table...")
        do {
            let habits = try self.database.prepare(self.habitsTable)
//            getTableSize()
            print("# entries: \(getTableSize())")
            for habit in habits {
                print("id: \(habit[self.id]), habit: \(habit[self.habit]), time: \(habit[self.time]), streak: \(habit[self.streak])")
            }
        } catch {
            print (error)
        }
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
        
        item.monthUILabel?.text = month
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
                    // testing
//                    cell.habitUITextField?.text = habit[self.habit]
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
        if (editingStyle == UITableViewCell.EditingStyle.delete) {
            print("Deleting habit...")
            // new
            var count = 0
            var firstId = 0
            do {
                let habits = try self.database.prepare(self.habitsTable)
//                print("row: \(indexPath.row)")
                for habit in habits {
                    if (count == 0) {
                        firstId = habit[self.id]
//                        print("firstId: \(firstId)")
                    }
//                    print("count: \(count)")
                    if (count == indexPath.row) {
//                        print("count: \(count) == row\(indexPath.row)")
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
//                        print("incrementing count...")
                        count += 1
                    }
                }
            } catch {
                print (error)
            }
        }
    }
    
    // custom : updateStreak
    func updateStreak(row: Int, inc: Int) {
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
                    let currentStreak = habit[self.streak] + inc
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
        if let cell = tableView.cellForRow(at: indexPath) {
            if cell.accessoryType == UITableViewCell.AccessoryType.checkmark {
                cell.accessoryType = .none
                updateStreak(row: indexPath.row, inc: -1)
            }
            else {
                cell.accessoryType = .checkmark
                updateStreak(row: indexPath.row, inc: 1)
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
        let calendar = Calendar.current
        print(calendar.component(.year, from: date))
        print(calendar.component(.month, from: date))
        print(calendar.component(.day, from: date))
    }
    
}
