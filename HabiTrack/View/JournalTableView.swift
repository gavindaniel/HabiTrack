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

class JournalTableView: NSObject, UITableViewDataSource, UITableViewDelegate {

    var journal: Journal
    var habitTableView: UITableView
    var dateSelected: Date
    var buffer = 0
    
    init(journal: Journal, habitTableView: UITableView, date: Date) {
        self.journal = journal
        self.habitTableView = habitTableView
        self.dateSelected = date
        super.init()
    }
    
    // tableView : numberOfRowsInSection
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // get the number of habits in the journal
        buffer = 0
        var count = 0
        do {
            // get the table
            let habits = try self.journal.database.prepare(self.journal.habitsTable)
            // testing
            let currentDayOfWeek = Calendar.current.component(.weekday, from: dateSelected)
            // loop through the list of habits
            for habit in habits {
                if(checkDayOfWeek(dayInt: habit[self.journal.dayOfWeek], dayOfWeek: currentDayOfWeek)) {
                    count += 1
                }
            }
        } catch {
            print(error)
        }
        return (count)
    }
    
    // tableView : cellForRowAt
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        print()
//        print("cellForRowAt...\(indexPath.row)")
//        print()
        
        // create tableView cell
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
            as! JournalTableViewCell
        // since the database only increments from the last ID,
        // this for loop fixes issues with gaps in the database.
        var count = 0
        do {
            // get the table
            let habits = try self.journal.database.prepare(self.journal.habitsTable)
            // testing
            let currentDayOfWeek = Calendar.current.component(.weekday, from: dateSelected)
            // loop through the list of habits
            for habit in habits {
                if ((count - buffer) == indexPath.row) {
                    if (checkDayOfWeek(dayInt: habit[self.journal.dayOfWeek], dayOfWeek: currentDayOfWeek)) {
                        cell.habitUILabel?.text = habit[self.journal.habit]
                        
                        //testing ...
                        let repeatString = habit[self.journal.time]
                        if (repeatString == "weekly") {
//                            let dayOfWeekString = getDayOfWeekString(dayOfWeek: habit[self.journal.dayOfWeek], length: "long")
//                            repeatString += " (\(dayOfWeekString)s)"
                        }
                        cell.timeUILabel?.text = repeatString
                        cell.timeUILabel?.isHidden = getShowRepeatLabel()
                        
                        // get the name of habit and size of habit entries table
                        let habitString = habit[self.journal.habit]
                        let habitDayOfWeek = habit[self.journal.dayOfWeek]
//                        print("calling countStreak...")
                        let currentStreak = self.journal.entries.countStreak(habit: habitString, date: dateSelected, habitRepeat: habitDayOfWeek) // habitRepeatString
//                        print("calling countLongestStreak...")
                        let longestStreak = self.journal.entries.countLongestStreak(habit: habitString, date: dateSelected, habitRepeat: habitDayOfWeek) // habitRepeatString
                        // set the streak
                        cell.streakUILabel?.text = String(currentStreak)
                        
                        // check if the current streak is equal or greater than the longest
                        if (currentStreak >= longestStreak && longestStreak > 0) {
                            cell.longestStreakUILabel?.text = "current longest streak!"
                            cell.longestStreakUILabel?.textColor = getSystemColor()
                        } else { // else return the the longest streak
                            cell.longestStreakUILabel?.text = "longest streak (\( String(longestStreak)))"
                            if #available(iOS 13.0, *) {
                                cell.longestStreakUILabel?.textColor = UIColor.systemGray
                            } else {
                                // Fallback on earlier versions
                                cell.longestStreakUILabel?.textColor = UIColor.darkGray
                            }
                        }
                        cell.longestStreakUILabel?.isHidden = getShowLongestLabel()
                        
                        if (currentStreak == 1) {
//                            if (cell.timeUILabel?.text == "weekly") {
                            if (habit[self.journal.time] == "weekly") {
                                cell.streakDayUILabel?.text = "week"
                            } else {
                                cell.streakDayUILabel?.text = "day"
                            }
                        } else {
//                            if (cell.timeUILabel?.text == "weekly") {
                            if (habit[self.journal.time] == "weekly") {
                                cell.streakDayUILabel?.text = "weeks"
                            } else {
                                cell.streakDayUILabel?.text = "days"
                            }
                        }
                        // check if today has already been completed
                        if (self.journal.entries.checkCompleted(habit: habitString, date: dateSelected)) {
                            if #available(iOS 13.0, *) {
                                cell.checkImageView?.image = UIImage(systemName: "checkmark.circle.fill")
                                let defaultColor = getSystemColor()
                                cell.checkImageView?.tintColor = defaultColor
                                
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
                        return (cell)
                    } else {
                        buffer += 1
                        count += 1
                    }
                } else {
                    count += 1
                }
            }
        } catch {
            print (error)
        }
        return (cell)
    }
    
    // tableView : didSelectRowAt
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // get the cell from the tableView
        print("didSelectRowAt...")
        if let cell: JournalTableViewCell = (tableView.cellForRow(at: indexPath) as? JournalTableViewCell) {
            // get the habit string from the cell
            let tempString = cell.habitUILabel?.text
            // check if the cell has been completed
            if #available(iOS 13.0, *) {
                if cell.checkImageView?.image == UIImage(systemName: "checkmark.circle.fill") {
                    cell.checkImageView?.image = UIImage(systemName: "circle")
                    cell.checkImageView?.tintColor = UIColor.systemGray
                    journal.updateStreak(row: indexPath.row, inc: 0, date: dateSelected, habitString: tempString ?? "none")
                } else {
                    cell.checkImageView?.image = UIImage(systemName: "checkmark.circle.fill")
                    cell.checkImageView?.tintColor = getSystemColor()
                    journal.updateStreak(row: indexPath.row, inc: 1, date: dateSelected, habitString: tempString ?? "none")
                }
            } else {
                // Fallback on earlier versions
                if cell.accessoryType == UITableViewCell.AccessoryType.checkmark {
                    cell.accessoryType = .none
                    journal.updateStreak(row: indexPath.row, inc: 0, date: dateSelected, habitString: tempString ?? "none")
                } else {
                    cell.accessoryType = .checkmark
                    journal.updateStreak(row: indexPath.row, inc: 1, date: dateSelected, habitString: tempString ?? "none")
                }
            }
        }
        self.habitTableView.reloadData()
    }
    
    // custom : updateTableView
    func updateTableView(habitView: UITableView) {
        habitTableView = habitView
    }

}
