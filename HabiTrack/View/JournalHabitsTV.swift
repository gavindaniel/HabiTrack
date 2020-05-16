//
//  JournalTableView.swift
//  HabiTrack
//
//  Created by Gavin Daniel on 9/27/19.
//  Copyright © 2019 Gavin Daniel. All rights reserved.
//

import Foundation
import SQLite
import MobileCoreServices


// name: JournalHabitsTV
// desc: journal habits table view class
// last updated: 4/28/2020
// last update: cleaned up
class JournalHabitsTV: NSObject, UITableViewDataSource, UITableViewDelegate {
    // variables
    var habits: Habits
    var journalUITableView: UITableView
//    var dateSelected: Date
    var buffer = 0
    var selectedRow = [IndexPath]()
    
    
    // name: init
    // desc:
    // last updated: 4/28/2020
    // last update: cleaned up
    init(_ habits: Habits,_ habitTableView: UITableView,_ date: Date) {
        debugPrint("JournalHabitsTV", "init", "start", true)
        self.habits = habits
        self.journalUITableView = habitTableView
        dateSelected = date
        super.init()
        debugPrint("JournalHabitsTV", "init", "end", true)
    }
    
    
    // name: numberOfRowsInSection
    // desc:
    // last updated: 4/28/2020
    // last update: cleaned up
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        debugPrint("JournalHabitsTV", "numberOfRowsInSection", "start", true)
        // get the number of habits in the journal
//        var buffer = 0
        var count = 0
        do {
            // get the table
            let habits = try self.habits.database.prepare(self.habits.habitsTable)
            // testing
            let currentDayOfWeek = Calendar.current.component(.weekday, from: dateSelected)
            // loop through the list of habits
            for habit in habits {
                let startDate = getDateFromComponents(habit[self.habits.startDay], habit[self.habits.startMonth], habit[self.habits.startYear])
                if (countDaysBetweenDates(startDate, dateSelected) >= 0) {
//                if (checkDayOfWeek(days: habit[self.habits.days], dayOfWeek: currentDayOfWeek)) {
                    if(checkDayOfWeek(days: habit[self.habits.days], dayOfWeek: currentDayOfWeek)) {
                        count += 1
                    }
                }
            }
        } catch {
            print(error)
        }
        debugPrint("JournalHabitsTV", "numberOfRowsInSection", "end", true)
        return (count)
    }
    
    
    // name: cellForRowAt
    // desc:
    // last updated: 4/28/2020
    // last update: cleaned up
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        debugPrint("JournalHabitsTV", "cellForRowAt", "start", true, indexPath.row)
        // create tableView cell
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
            as! JournalHabitsTVCell
        // since the database only increments from the last ID,
        // this for loop fixes issues with gaps in the database.
        var index = 0
//        var buffer = 0
        if (indexPath.row == 0) {
            buffer = 0
        }
        do {
            // get the table
            let habits = try self.habits.database.prepare(self.habits.habitsTable)
            // testing
            let currentDayOfWeek = Calendar.current.component(.weekday, from: dateSelected)
            // loop through the list of habits
            for habit in habits {
//                print("\tcount: \(index)\tbuffer: \(buffer)")
//                let numHabits = self.habits.getTableSize()
                if ((index - buffer) == indexPath.row) {
                    let startDate = getDateFromComponents(habit[self.habits.startDay], habit[self.habits.startMonth], habit[self.habits.startYear])
                    if (countDaysBetweenDates(startDate, dateSelected) >= 0) {
                        if (checkDayOfWeek(days: habit[self.habits.days], dayOfWeek: currentDayOfWeek)) {
                            // get the habit string and put it in the cell
//                            print("\thabit...\(habit[self.habits.name])")
                            cell.habitUILabel?.text = habit[self.habits.name]
                            cell.habitUILabel?.isHidden = false
                            // get the name of habit and size of habit entries table
                            let habitString = habit[self.habits.name]
                            let habitDayOfWeek = habit[self.habits.days]
                            let currentStreak = self.habits.entries.countStreak(habit: habitString, date: dateSelected, habitRepeat: habitDayOfWeek)
                            let longestStreak = self.habits.entries.countLongestStreak(habit: habitString, date: dateSelected, habitRepeat: habitDayOfWeek) // habitRepeatString
                            // set the streak
                            cell.streakUILabel?.text = String(currentStreak)
                            cell.streakUILabel?.isHidden = false
                            // if the current streak is equal or greater than the longest, change streak color
                            if (currentStreak >= longestStreak && longestStreak > 0) {
                                cell.streakUILabel?.textColor = getColor("System")
                            } else {
                                cell.streakUILabel?.textColor = UIColor.label
                            }
                            // check if today has already been completed
                            if (self.habits.entries.checkCompleted(habit: habitString, date: dateSelected)) {
                                if #available(iOS 13.0, *) {
                                    cell.checkImageView?.image = UIImage(systemName: "checkmark.circle.fill")
                                    cell.checkImageView?.tintColor = getColor("System")
                                } else {
                                    // Fallback on earlier versions
                                    cell.accessoryType = .checkmark
                                }
                            } else {
                                if #available(iOS 13.0, *) {
                                    cell.checkImageView?.image = UIImage(systemName: "circle")
                                    cell.checkImageView?.tintColor = UIColor.systemGray
                                } else {
                                    // Fallback on earlier versions
                                    cell.accessoryType = .none
                                }
                            }
                            cell.checkImageView?.isHidden = false
                            debugPrint("\tJournalHabitsTV", "cellForRowAt", "end", true, indexPath.row)
                            return (cell)
                        }
                        else {
                            buffer += 1
                            index += 1
                        }
                    }
                    else {
                        buffer += 1
                        index += 1
                    }
                } else {
                    index += 1
                }
            }
        } catch {
            print (error)
        }
        debugPrint("JournalHabitsTV", "cellForRowAt", "end", true, indexPath.row)
        return (cell)
    }
    
    
    // name: didSelectRowAt
    // desc:
    // last updated: 4/28/2020
    // last update: cleaned up
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        debugPrint("JournalHabitsTV", "didSelectRowAt", "start", false, indexPath.row)
        // get the cell from the tableView
        if let cell: JournalHabitsTVCell = (tableView.cellForRow(at: indexPath) as? JournalHabitsTVCell) {
            // get the habit string from the cell
            let tempString = cell.habitUILabel?.text
            // check if the cell has been completed
            if #available(iOS 13.0, *) {
                if cell.checkImageView?.image == UIImage(systemName: "checkmark.circle.fill") {
                    cell.checkImageView?.image = UIImage(systemName: "circle")
                    cell.checkImageView?.tintColor = UIColor.systemGray
                    habits.updateStreak(row: indexPath.row, inc: 0, date: dateSelected, habitString: tempString ?? "none")
                } else {
                    cell.checkImageView?.image = UIImage(systemName: "checkmark.circle.fill")
                    cell.checkImageView?.tintColor = getColor("System")
                    habits.updateStreak(row: indexPath.row, inc: 1, date: dateSelected, habitString: tempString ?? "none")
                }
            } else {
                // Fallback on earlier versions
                if cell.accessoryType == UITableViewCell.AccessoryType.checkmark {
                    cell.accessoryType = .none
                    habits.updateStreak(row: indexPath.row, inc: 0, date: dateSelected, habitString: tempString ?? "none")
                } else {
                    cell.accessoryType = .checkmark
                    habits.updateStreak(row: indexPath.row, inc: 1, date: dateSelected, habitString: tempString ?? "none")
                }
            }
        }
        self.journalUITableView.reloadData()
        debugPrint("JournalHabitsTV", "didSelectRowAt", "end", false, indexPath.row)
    }

    
    // name: updateUITableView
    // desc:
    // last updated: 4/28/2020
    // last update: cleaned up
    func updateUITableView(_ journalUITableView: UITableView) {
        debugPrint("JournalHabitsTV", "updateUITableView", "start", false)
        self.journalUITableView = journalUITableView
        debugPrint("JournalHabitsTV", "updateUITableView", "end", false)
    }
}
