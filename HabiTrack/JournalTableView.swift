//
//  JournalTableView.swift
//  HabiTrack
//
//  Created by Gavin Daniel on 9/9/19.
//  Copyright © 2019 Gavin Daniel. All rights reserved.
//

import UIKit
import SQLite
import Foundation

class JournalTableView: NSObject, UITableViewDataSource, UITableViewDelegate {
    
    var dateSelected = Date()
    var journal: Journal
    var tableView: UITableView
    
    override init () {
        self.journal = Journal()
        self.tableView = UITableView()
        super.init()
    }
    
    init(journal: Journal, habitTableView: UITableView) {
        self.journal = journal
        self.tableView = habitTableView
        super.init()
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
                    // get the name of habit and size of habit entries table
                    let habitString = habit[self.journal.habit]
                    let habitStreak = self.journal.entries.countStreak(habit: habitString, date: dateSelected)
                    // set the streak
                    cell.streakUILabel?.text = String(habitStreak)
                    // check if today has already been completed
                    if (self.journal.entries.checkCompleted(habit: habitString, date: dateSelected)) {
                        cell.accessoryType = .checkmark
                    } else {
                        cell.accessoryType = .none
                    }
                    return (cell)
                } else {
                    count += 1
                }
            }
        } catch {
            print (error)
        }
        self.tableView.reloadData()
        return (cell)
    }
    
    // tableView : didSelectRowAt
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //        print("Selected row: \(indexPath.row)")
        // get the cell from the tableView
        if let cell: HabitTableViewCell = (tableView.cellForRow(at: indexPath) as? HabitTableViewCell) {
            // get the habit string from the cell
            let tempString = cell.habitUILabel?.text
            // check if the cell has been completed
            if cell.accessoryType == UITableViewCell.AccessoryType.checkmark {
                cell.accessoryType = .none
                journal.updateStreak(row: indexPath.row, inc: 0, date: dateSelected, habitString: tempString ?? "none")
            }
            else {
                cell.accessoryType = .checkmark
                journal.updateStreak(row: indexPath.row, inc: 1, date: dateSelected, habitString: tempString ?? "none")
            }
        }
        self.tableView.reloadData()
    }
    
    // tableView : editingStyle
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath)
    {
        // check if the editingStyle is delete
        if (editingStyle == UITableViewCell.EditingStyle.delete) {
            var count = 0
            var firstId = 0
            var habitString = ""
            // get the habit string from the tableview cell
            if let cell: HabitTableViewCell = (tableView.cellForRow(at: indexPath) as? HabitTableViewCell) {
                habitString = cell.habitUILabel?.text ?? "error"
            }
            // delete the habit from the table
            journal.entries.deleteTable(habit: habitString)
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
                        let tempHabit = self.journal.habitsTable.where(self.journal.id == (count+firstId))
                        // delete the habit
                        let deleteHabit = tempHabit.delete()
                        do {
                            try self.journal.database.run(deleteHabit)
                            print("Deleted habit")
                            tableView.reloadData()
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
    
    // custom : updateDate
    func updateDate(date: Date) {
        dateSelected = date
    }
	
	// custom : updateTableView
	func updateTableView(habitTableView: UITableView) {
		tableView = habitTableView
	}
}
