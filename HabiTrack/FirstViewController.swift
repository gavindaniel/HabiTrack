//
//  FirstViewController.swift
//  HabiTrack
//
//  Created by Gavin Daniel on 8/22/19.
//  Copyright © 2019 Gavin Daniel. All rights reserved.
//

import UIKit
import SQLite

class DateCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var monthUILabel: UILabel!
    @IBOutlet weak var dayUILabel: UILabel!
    
}

class HabitTableViewCell: UITableViewCell {
    
    @IBOutlet weak var habitUILabel: UILabel!
    @IBOutlet weak var timeUILabel: UILabel!
    @IBOutlet weak var streakUILabel: UILabel!
    
}

class JournalViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UICollectionViewDelegate, UICollectionViewDataSource {

    var month = "Aug"
    var days = 31
    
    var habitList = ["Brush teeth", "Workout", "Yoga","Code", "Paint", "Clean", "Vacuum", "Laundry"]
    var habitsList = Array(repeating: "", count: 0)
    var timeList = ["Morning","Afternoon","Evening","Evening"]
    var timeTemp = "Evening"
    
    var streakArray = Array(repeating: 0, count: 8)
    var doneArray = Array(repeating: false, count: 8)
    
    var daysArray = [1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28,29,30,31]
    
    var database: Connection!
    let habitsTable = Table("habits")
    let id = Expression<Int>("id")
    let habit = Expression<String>("habit")
    let time = Expression<String>("time")
    let streak = Expression<Int>("streak")
    
    @IBOutlet weak var habitTableView: UITableView!
    @IBOutlet weak var dateCollectionView: UICollectionView!
    
    
    func getHabit() {
        
    }
    
    
    // UIButton : createTable
    @IBAction func createTable(_ sender: Any)
    {
        print("Create Table")
        
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
    
    // UIButton : addEntry
    @IBAction func addEntry(_ sender: Any)
    {
        print("Add Entry")
        
        let alert = UIAlertController(title: "Add Habit", message: nil, preferredStyle: .alert)
        alert.addTextField { (tf) in
            tf.placeholder = "Habit"
        }
        alert.addTextField { (tf) in
            tf.placeholder = "Time"
        }
    
        let action = UIAlertAction(title: "Submit", style: .default) { (_) in
            guard let habit = alert.textFields?.first?.text, let time = alert.textFields?.last?.text
                else {
                    return
                }
            print(habit)
            print(time)
            
            let addHabit = self.habitsTable.insert(self.habit <- habit, self.time <- time, self.streak <- 0)
            
            do {
                try self.database.run(addHabit)
                print("Habit Added")
//                self.habitTableView.reloadData()
            } catch {
                print (error)
            }
            
            
        }
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
        
    }
    
    // UIButton : printTable
    @IBAction func printTable(_ sender: Any) {
        print("Printing table...")
        
        do {
            let habits = try self.database.prepare(self.habitsTable)
            for habit in habits {
                print("id: \(habit[self.id]), habit: \(habit[self.habit]), time: \(habit[self.time]), streak: \(habit[self.streak])")
            }
        } catch {
            print (error)
        }
    }
    
    // collectionView : numberOfItemsInSection
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
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
        return (habitList.count)
    }
    
    // tableView : cellForRowAt
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
            as! HabitTableViewCell
        
        cell.habitUILabel?.text = habitList[indexPath.row]
        cell.timeUILabel?.text = timeTemp
        cell.streakUILabel?.text = String(streakArray[indexPath.row])
        
        return (cell)
    }
    
    // tableView : editingStyle
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath)
    {
        if (editingStyle == UITableViewCell.EditingStyle.delete) {
            habitList.remove(at: indexPath.row)
            habitTableView.reloadData()
        }
    }
    
    // tableView : didSelectRowAt
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        print(indexPath.row)
        
        if let cell = tableView.cellForRow(at: indexPath) {
            if cell.accessoryType == UITableViewCell.AccessoryType.checkmark {
                cell.accessoryType = .none
                streakArray[indexPath.row] -= 1
            }
            else {
                cell.accessoryType = .checkmark
                streakArray[indexPath.row] += 1
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

}
