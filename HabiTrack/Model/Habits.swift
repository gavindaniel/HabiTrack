//
//  Journal.swift
//  HabiTrack
//
//  Created by Gavin Daniel on 8/31/19.
//  Copyright © 2019 Gavin Daniel. All rights reserved.
//

import Foundation
import SQLite


// name: Habits
// desc: habits class
// last updated: 4/29/2020
// last update: refactored from 'Journal' to 'Habits'. Refactored column names. Added start date.
class Habits {
    // variables
    var database: Connection!
    let habitsTable = Table("habits")
    let entries = Entries()
    // habits table columns
    let id = Expression<Int>("id")
    let name = Expression<String>("name")
    let days = Expression<Int>("days")
    let streak = Expression<Int>("streak")
    let startYear = Expression<Int>("startYear")
    let startMonth = Expression<Int>("startMonth")
    let startDay = Expression<Int>("startDay")
    
    
    // name: createTable
    // desc: createTable (create SQL table)
    // last updated: 4/29/2020
    // last update: refactored from 'Journal' to 'Habits'. Refactored column names. Added start date.
    func createTable() {
        debugPrint("Habits", "createTable", "start", false)
        // create the habit table with the columns specified below
        let createTable = self.habitsTable.create { (table) in
            table.column(self.id, primaryKey: true)
            table.column(self.name)
            table.column(self.days)
            table.column(self.streak)
            table.column(self.startYear)
            table.column(self.startMonth)
            table.column(self.startDay)
        }
        do {
            // try to create the table in the database
            try self.database.run(createTable)
        // catch any errors while creating table in database
        } catch {
            print (error)
        }
        debugPrint("Habits", "createTable", "end", false)
    }


    // name: getTableSize
    // desc:
    // last updated: 4/28/2020
    // last update: cleaned up
    // custom : getTableSize (size of database table)
    func getTableSize() -> Int {
        debugPrint("Habits", "getTableSize", "start", false)
        var count = 0   // table size counter
        do {
            // try to get the habits table from the database
            let habits = try self.database.prepare(self.habitsTable)
            // loop through the habits
            for _ in habits {
                count += 1  // increment table size count
            }
        // catch any errors while getting the table from the database
        } catch {
            print (error)
        }
        debugPrint("Habits", "getTableSize", "end", false)
        // return the size of the table
        return (count)
    }

    
    // name: updateStreak
    // desc:
    // last updated: 4/28/2020
    // last update: cleaned up
    // custome : updateStreak
    func updateStreak(row: Int, inc: Int, date: Date, habitString: String) {
        debugPrint("Habits", "updateStreak", "start", false)
        var index = 0       // index of for loop array
        var firstId = 0     // id of first entry in table
        print("updateStreak...\(row) \(habitString) \(inc) \(date)")
        do {
            // try to get the table of habits from the database
            let habits = try self.database.prepare(self.habitsTable)
            for habit in habits {
                if (index == 0) {
                    firstId = habit[self.id]
                }
                // check if the index equals the row specified to be updated
                if (index == row) {
                    // get the habit whose ID matches the index + the first ID incase it doesn't start at 1
                    let tempHabit = self.habitsTable.filter(self.id == index + firstId)
                    // get the string of how often the habit is repeated
//                    let repeatString = habit[self.time]
                    let days = habit[self.days]
                    // mark the entry completed for the date specified and the value specified for the completed column
                    entries.markCompleted(habit: habitString, date: date, val: inc)
                    // count the current streak for the habit and date specified
                    let currentStreak = entries.countStreak(habit: habitString, date: date, habitRepeat: days) // repeatString
                    // update the habit with the current streak
                    let updateHabit = tempHabit.update(self.streak <- currentStreak)
                    do {
                        // try to update the database with the updated habit
                        try self.database.run(updateHabit)
                        debugPrint("Habits", "updateStreak", "end", false)
                        return
                    // catch any errors while trying to update the database
                    } catch {
                        print(error)
                    }
                // if the index does not equal the row to be updated, increment the index
                } else {
                    index += 1
                }
            }
        // catch any errors while getting the habits table from the database
        } catch {
            print (error)
        }
        debugPrint("Habits", "updateStreak", "end", false)
    }
    
    
    // name: addDays
    // desc:
    // last updated: 4/28/2020
    // last update: cleaned up
    // custom : addDays
    func addDays(numDays: Int, startDate: Date) {
        debugPrint("Habits", "addDays", "start", false)
        var index = 0   // index for counting number of days that have been added
        // get the next day from the date specified to start at
        var nextDay = Calendar.current.date(byAdding: .day, value: 1, to: startDate)
        // while the index is less than the number of days to be added (as specified)
        while index < numDays {
            do {
                // try to get the table of habits from the database
                let habits = try self.database.prepare(self.habitsTable)
                // loop through the habits table
                for habit in habits {
                    // get the string of the current habit in the table
                    let nameString = habit[self.name]
                    // check if the next day exists in the entries table for the current habit
                    if (entries.checkDayExists(habit: nameString, date: nextDay ?? Date()) == false) {
                        // add the next day to the entries table for the current habit
                        entries.addDay(habit: nameString, date: nextDay ?? Date())
                    }
                }
            // catch any errors while trying to get the table of habits from the database
            } catch {
                print(error)
            }
            // increment the index
            index += 1
            // increment the next day
            nextDay = Calendar.current.date(byAdding: .day, value: 1, to: nextDay!)
        }
        debugPrint("Habits", "addDays", "end", false)
    }
    
    
    // name: deleteDays
    // desc:
    // last updated: 4/28/2020
    // last update: cleaned up
    // custom : deleteDays
    func deleteDays(date: Date) {
        debugPrint("Habits", "deleteDays", "start", false)
        do {
            // try to get the table of habits from the database
            let habits = try self.database.prepare(self.habitsTable)
            // loop through the habits
            for habit in habits {
                // get the string of the current habit
                let nameString = habit[self.name]
                // delete the day specified for the current habit
                entries.deleteDay(habit: nameString, date: date)
            }
        // catch any errors while getting the table of habits from the database
        } catch {
            print(error)
        }
        debugPrint("Habits", "deleteDays", "end", false)
    }
    
    
    // name: moveItem
    // desc:
    // last updated: 4/28/2020
    // last update: cleaned up
    /// The traditional method for rearranging rows in a table view.
    func moveItem(at sourceIndex: Int, to destinationIndex: Int) {
        debugPrint("Habits", "moveItem", "start", false)
        print()
        print("moveItem")
        print()
        guard sourceIndex != destinationIndex else { return }
        
        let defaults = UserDefaults.standard
        var localHabits = defaults.object(forKey: "localHabits") as! [String]
        let habitString = localHabits[sourceIndex]
        localHabits.remove(at: sourceIndex)
        localHabits.insert(habitString, at: destinationIndex)
        defaults.set(localHabits, forKey: "localHabits")
        updateHabitIDs(oldId: sourceIndex + 1, newId: destinationIndex + 1)
        debugPrint("Habits", "moveItem", "end", false)
    }
    
    
    // name: addItem
    // desc:
    // last updated: 4/28/2020
    // last update: cleaned up
    /// The method for adding a new item to the table view's data model.
    func addItem(_ habitString: String, at index: Int) {
        debugPrint("Habits", "addItem", "start", false)
        print("addItem")
        let defaults = UserDefaults.standard
        var localHabits = defaults.object(forKey: "localHabits") as! [String]
        localHabits.insert(habitString, at: index)
        defaults.set(localHabits, forKey: "localHabits")
        debugPrint("Habits", "addItem", "end", false)
    }
    
    
    // name: updateHabitIDs
    // desc:
    // last updated: 4/28/2020
    // last update: cleaned up
    // custom : updateHabitIDs (for drag and drop to properly update the habits in the database)
    func updateHabitIDs(oldId: Int, newId: Int) {
        debugPrint("Habits", "updateHabitIDs", "start", false)
        // flags for finding the habits whose IDs match the ones specified
        var flag1 = false
        var flag2 = false
        do {
            // try to get the table of habits from the database
            let habits = try self.database.prepare(self.habitsTable)
            // get the habit string of the first habit to update
            let oldHabit = self.habitsTable.filter(self.id == oldId)
            // get the habit string of the second habit to update
            let newHabit = self.habitsTable.filter(self.id == newId)
            // loop through the table of habits
            for habit in habits {
                // check if the current habit ID matches the first ID specified
                if (habit[self.id] == oldId) {
                    flag1 = true    // set flag to true, found the first habit to update
                // check if the current habit ID matches the second ID specified
                } else if (habit[self.id] == newId) {
                    flag2 = true    // set flag to true, found the second habit to update
                }
                // check if both habits to be updated have been found
                if (flag1 == true && flag2 == true) {
                    // update the first habits id to an ID that is not being used (has to be unique)
                    let updateOldHabitIdTemp = oldHabit.update(self.id <- 999)
                    do {
                        // try to update the habit in the database
                        try self.database.run(updateOldHabitIdTemp)
                    // catch any errors while trying to update the habit in the database
                    } catch {
                        print(error)
                    }
                    // update the second habits id to the first habits ID since it is no longer being used
                    let updateNewHabitId = newHabit.update(self.id <- oldId)
                    do {
                        // try to update the habit in the database
                        try self.database.run(updateNewHabitId)
                    // catch any errors while trying to update the habit in the database
                    } catch {
                        print(error)
                    }
                    // find the first habit whose id was updated to an ID not being used
                    let tempHabit = self.habitsTable.filter(self.id == 999)
                    // update the first habits id to the second habits ID since it is no longer being used
                    let updateOldHabitId = tempHabit.update(self.id <- newId)
                    do {
                        // try to update the habit in the database
                        try self.database.run(updateOldHabitId)
                    // catch any errors while trying to update the habit in the database
                    } catch {
                        print(error)
                    }
                    // exit the loop since both habits have been updated
                    return
                }
            } // end for loop
        // catch any errors while trying to get the table of habits from the database
        } catch {
            print(error)
        }
        debugPrint("Habits", "updateHabitIDs", "end", false)
    }
} // end class
