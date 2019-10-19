//
//  ManageTableView.swift
//  HabiTrack
//
//  Created by Gavin Daniel on 10/18/19.
//  Copyright © 2019 Gavin Daniel. All rights reserved.
//

import Foundation
import SQLite
import MobileCoreServices

class ManageTableView: NSObject, UITableViewDataSource, UITableViewDelegate {

    var journal: Journal
    var manageTableView: UITableView
//    var dateSelected: Date
//    var buffer = 0
    
    init(journal: Journal, manageTableView: UITableView) {
        self.journal = journal
        self.manageTableView = manageTableView
//        self.dateSelected = date
        super.init()
    }
    
    // tableView : numberOfRowsInSection
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // get the number of habits in the journal
        return (journal.getTableSize())
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        print()
        print("cellForRowAt...\(indexPath.row)")
        print()
        // testing
//        buffer = 0
        // create tableView cell
        let cell = tableView.dequeueReusableCell(withIdentifier: "settings_cell", for: indexPath)
            as! ManageTableViewCell
        // since the database only increments from the last ID,
        // this for loop fixes issues with gaps in the database.
//        var count = 0
//        var buffer = 0
        do {
            // get the table
            let habits = try self.journal.database.prepare(self.journal.habitsTable)
            // testing
//            let currentDayOfWeek = Calendar.current.component(.weekday, from: dateSelected)
            // loop through the list of habits
            for habit in habits {
                if (habit[self.journal.id] == (indexPath.row+1)) {
                    cell.habitNameUILabel?.text = habit[self.journal.habit]
                    cell.habitRepeatUILabel?.text = habit[self.journal.time]
                    return (cell)
                }
            }

        } catch {
            print(error)
        }
        return (cell)
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
            if let cell: ManageTableViewCell = (tableView.cellForRow(at: indexPath) as? ManageTableViewCell) {
                habitString = cell.habitNameUILabel?.text ?? "error"
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
//                    print("firstId: \(firstId)")
//                    print("count: \(count)")
//                    print("count: \(count) == indexPath.row: \(indexPath.row)")
                    print("habit: \(habit[self.journal.habit]) == habitString: \(habitString)")
//                    if (count == indexPath.row) {
                    if (habit[self.journal.habit] == habitString) {
                        print("\tid: \(habit[self.journal.id]) == firstId+count: \(firstId+count)")
                        // get the habit whose id matches the count + first ID in the tableView
                        let habit = self.journal.habitsTable.filter(self.journal.id == (firstId+count))
                        // delete the habit
                        let deleteHabit = habit.delete()
                        do {
                            try self.journal.database.run(deleteHabit)
                            print("Deleted habit")
                            manageTableView.reloadData()
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
    
    // custom : updateTableView
    func updateTableView(tableView: UITableView) {
        manageTableView = tableView
    }
    
    
}
