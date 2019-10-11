//
//  Journal.swift
//  HabiTrack
//
//  Created by Gavin Daniel on 8/31/19.
//  Copyright © 2019 Gavin Daniel. All rights reserved.
//

import Foundation
import SQLite

class Journal {

    var database: Connection!
    let habitsTable = Table("habits")
    let entries = Entries()
    // habits table columns
    let id = Expression<Int>("id")
    let habit = Expression<String>("habit")
    let time = Expression<String>("time") // repeat
    let streak = Expression<Int>("streak")
    let currentDay = Expression<Int>("currentDay")
    
    
    // custom : createTable (create SQL table)
    func createTable() {
        // create the habit table with the columns specified below
        let createTable = self.habitsTable.create { (table) in
            table.column(self.id, primaryKey: true)
            table.column(self.habit)
            table.column(self.time)
            table.column(self.streak)
            table.column(self.currentDay)
        }
        do {
            // try to create the table in the database
            try self.database.run(createTable)
        // catch any errors while creating table in database
        } catch {
            print (error)
        }
    }


    // custom : getTableSize (size of database table)
    func getTableSize() -> Int {
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
        // return the size of the table
        return (count)
    }

    // custome : updateStreak
    func updateStreak(row: Int, inc: Int, date: Date, habitString: String) {
        var index = 0       // index of for loop array
        var firstId = 0     // id of first entry in table
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
                    let repeatString = habit[self.time]
                    // mark the entry completed for the date specified and the value specified for the completed column
                    entries.markCompleted(habit: habitString, date: date, val: inc)
                    // count the current streak for the habit and date specified
                    let currentStreak = entries.countStreak(habit: habitString, date: date, habitRepeat: repeatString)
                    // update the habit with the current streak
                    let updateHabit = tempHabit.update(self.streak <- currentStreak)
                    do {
                        // try to update the database with the updated habit
                        try self.database.run(updateHabit)
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
    }
    
    // custom : addDays
    func addDays(numDays: Int, startDate: Date) {
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
                    let habitString = habit[self.habit]
                    // check if the next day exists in the entries table for the current habit
                    if (entries.checkDayExists(habit: habitString, date: nextDay ?? Date()) == false) {
                        // add the next day to the entries table for the current habit
                        entries.addDay(habit: habitString, date: nextDay ?? Date())
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
    }
    
    // custom : deleteDays
    func deleteDays(date: Date) {
        do {
            // try to get the table of habits from the database
            let habits = try self.database.prepare(self.habitsTable)
            // loop through the habits
            for habit in habits {
                // get the string of the current habit
                let habitString = habit[self.habit]
                // delete the day specified for the current habit
                entries.deleteDay(habit: habitString, date: date)
            }
        // catch any errors while getting the table of habits from the database
        } catch {
            print(error)
        }
    }
    
    
    /// The traditional method for rearranging rows in a table view.
    func moveItem(at sourceIndex: Int, to destinationIndex: Int) {
        print()
        print("moveItem")
        print()
        guard sourceIndex != destinationIndex else { return }
        
        let defaults = UserDefaults.standard
        var localHabits = defaults.object(forKey: "localHabits") as! [String]
        let habitString = localHabits[sourceIndex]
        localHabits.remove(at: sourceIndex)
        localHabits.insert(habitString, at: destinationIndex)
        updateHabitIDs(oldId: sourceIndex + 1, newId: destinationIndex + 1)
    }
    
    /// The method for adding a new item to the table view's data model.
    func addItem(_ habitString: String, at index: Int) {
        print("addItem")
        let defaults = UserDefaults.standard
        var localHabits = defaults.object(forKey: "localHabits") as! [String]
        localHabits.insert(habitString, at: index)
    }
    
    // custom : updateHabitIDs (for drag and drop to properly update the habits in the database)
    func updateHabitIDs(oldId: Int, newId: Int) {
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
    }
}
