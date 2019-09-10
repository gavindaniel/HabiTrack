//
//  JournalDataSource.swift
//  HabiTrack
//
//  Created by Gavin Daniel on 9/9/19.
//  Copyright © 2019 Gavin Daniel. All rights reserved.
//

import Foundation
import UIKit

class JournalTableDataSource: NSObject, UITableViewDataSource {
    
    var journal: Journal!
    var dateSelected = Date()
    
    @IBOutlet weak var journalTableView: UITableView!
    
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
        self.journalTableView.reloadData()
        return (cell)
    }
    
}
