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
    let time = Expression<String>("time")
    let streak = Expression<Int>("streak")
    let currentDay = Expression<Int>("currentDay")
    
    // individual habit journal entry table columns
    var localHabbits = [String]()
    
    
    
    // custom : createTable (create SQL table)
    func createTable() {
//        print("Creating Table...")
        let createTable = self.habitsTable.create { (table) in
            table.column(self.id, primaryKey: true)
            table.column(self.habit)
            table.column(self.time)
            table.column(self.streak)
            table.column(self.currentDay)
        }
        do {
            try self.database.run(createTable)
//            print("Created Table")
        } catch {
            print (error)
        }
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

    func updateStreak(row: Int, inc: Int, date: Date, habitString: String) {
//        print("updateStreak...")
        var count = 0
        var firstId = 0
        do {
            let habits = try self.database.prepare(self.habitsTable)
            for habit in habits {
                if (count == 0) {
                    firstId = habit[self.id]
                }
                if (count == row) {
                    let tempHabit = self.habitsTable.filter(self.id == count+firstId)
                    print("date: \(date)")
                    entries.markCompleted(habit: habitString, date: date, val: inc)
                    let currentStreak = entries.countStreak(habit: habitString, date: date)
                    let updateHabit = tempHabit.update(self.streak <- currentStreak)
                    do {
                        try self.database.run(updateHabit)
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
    
    // custom : addDays
    func addDays(numDays: Int, startDate: Date) {
        var temp = 0
        var nextDay = Calendar.current.date(byAdding: .day, value: 1, to: startDate)
        while temp < numDays {
            do {
                let habits = try self.database.prepare(self.habitsTable)
                for habit in habits {
                    // do something...
                    let tempString = habit[self.habit]
                    if (entries.checkDayExists(habit: tempString, date: nextDay ?? Date()) == false) {
                        entries.addDay(habit: tempString, date: nextDay ?? Date())
                        // add day to local array
                        localHabbits.append(tempString)
                    }
                }
            } catch {
                print(error)
            }
            temp += 1
            // not sure why the ! is needed below
            nextDay = Calendar.current.date(byAdding: .day, value: 1, to: nextDay!)
        }
    }
    
    // custom : deleteDays
    func deleteDays(date: Date) {
        do {
            let habits = try self.database.prepare(self.habitsTable)
            for habit in habits {
                // do something...
                let tempString = habit[self.habit]
                entries.deleteDay(habit: tempString, date: date)
            }
        } catch {
            print(error)
        }
    }
    
    
    /// The traditional method for rearranging rows in a table view.
    func moveItem(at sourceIndex: Int, to destinationIndex: Int) {
        print("moveItem")
        guard sourceIndex != destinationIndex else { return }
        
        let defaults = UserDefaults.standard
        var localHabits = defaults.object(forKey: "localHabits") as! [String]
//        let habitString = localHabbits[sourceIndex]
        let habitString = localHabits[sourceIndex]
        localHabits.remove(at: sourceIndex)
        localHabits.insert(habitString, at: destinationIndex)
//        localHabbits.remove(at: sourceIndex)
//        localHabbits.insert(habitString, at: destinationIndex)
        
//        updateHabitIDs(oldId: sourceIndex, newId: -1)
        
        updateHabitIDs(oldId: sourceIndex + 1, newId: destinationIndex + 1)
        
//        updateHabitIDs(oldId: -1, newId: sourceIndex)
    }
    
    /// The method for adding a new item to the table view's data model.
    func addItem(_ habitString: String, at index: Int) {
        print("addItem")
//        localHabbits.insert(habitString, at: index)
        let defaults = UserDefaults.standard
        var localHabits = defaults.object(forKey: "localHabits") as! [String]
        localHabits.insert(habitString, at: index)
    }
    
    
//    func updateLocalHabits() {
//        print("updateLocalHabits...")
//        do {
//            let habits = try self.database.prepare(self.habitsTable)
//            self.localHabbits = [String]()
//            for habit in habits {
//                self.localHabbits.append(habit[self.habit])
//            }
//        } catch {
//            print(error)
//        }
//    }
    
    func updateHabitIDs(oldId: Int, newId: Int) {
        print("updateHabitIDs... oldId: \(oldId), newId: \(newId)")
        
        var flag1 = false
        var flag2 = false
        
        do {
            let habits = try self.database.prepare(self.habitsTable)
            let oldHabit = self.habitsTable.filter(self.id == oldId)
            let newHabit = self.habitsTable.filter(self.id == newId)
            for habit in habits {
                print("id: \(habit[self.id])")
                if (habit[self.id] == oldId) {
                    print("\(habit[self.id]) == \(oldId)")
//                    let oldHabit = self.habitsTable.filter(self.id == oldId)
                    print("OLD HABIT: id: \(habit[self.id]), habit: \(habit[self.habit]), time: \(habit[self.time])")
//                    let tempString = habit[self.habit]
                    flag1 = true
                    
                } else if (habit[self.id] == newId) {
                    print("\(habit[self.id]) == \(newId)")
//                    let newHabit = self.habitsTable.filter(self.id == newId)
                    print("OLD HABIT: id: \(habit[self.id]), habit: \(habit[self.habit]), time: \(habit[self.time])")
                    flag2 = true
                }
                
                if (flag1 == true && flag2 == true) {
                    let updateOldHabitIdTemp = oldHabit.update(self.id <- 998)
            // attempt to update the database
                    do {
                        try self.database.run(updateOldHabitIdTemp)
            //            try self.database.run(updateOldHabitString)
            //            try self.database.run(updateOldHabitTime)
            //            try self.database.run(updateOldHabitStreak)
            //            try self.database.run(updateOldHabitCurrentDay)
            //            try self.database.run(updateNewHabitId)
            //            try self.database.run(updateNewHabitString)
            //            try self.database.run(updateNewHabitTime)
            //            try self.database.run(updateNewHabitStreak)
            //            try self.database.run(updateNewHabitCurrentDay)
                        print("updated old habit ID temporarily.")
            //            printTable()
                    } catch {
                        print(error)
                    }
                    let updateNewHabitId = newHabit.update(self.id <- oldId)
                    do {
                                try self.database.run(updateNewHabitId)
                    //            try self.database.run(updateOldHabitString)
                    //            try self.database.run(updateOldHabitTime)
                    //            try self.database.run(updateOldHabitStreak)
                    //            try self.database.run(updateOldHabitCurrentDay)
                    //            try self.database.run(updateNewHabitId)
                    //            try self.database.run(updateNewHabitString)
                    //            try self.database.run(updateNewHabitTime)
                    //            try self.database.run(updateNewHabitStreak)
                    //            try self.database.run(updateNewHabitCurrentDay)
                                print("updated new habit ID.")
                    //            printTable()
                    } catch {
                        print(error)
                    }
                    let tempHabit = self.habitsTable.filter(self.id == 998)
                    let updateOldHabitId = tempHabit.update(self.id <- newId)
                    do {
                        try self.database.run(updateOldHabitId)
                    //            try self.database.run(updateOldHabitString)
                    //            try self.database.run(updateOldHabitTime)
                    //            try self.database.run(updateOldHabitStreak)
                    //            try self.database.run(updateOldHabitCurrentDay)
                    //            try self.database.run(updateNewHabitId)
                    //            try self.database.run(updateNewHabitString)
                    //            try self.database.run(updateNewHabitTime)
                    //            try self.database.run(updateNewHabitStreak)
                    //            try self.database.run(updateNewHabitCurrentDay)
                        print("updated old habit ID.")
                    //            printTable()
                    } catch {
                        print(error)
                    }
                    // exit the loop
                    return
                    
                } // end if statement
            } // end for loop
        } catch {
            print(error)
        }
    }
    
    
    
    // custom : printTable (select row in table)
        func printTable() {
            print()
            print("Printing table...")
    //        print()
            do {
                let habits = try self.database.prepare(self.habitsTable)
                
    //            print("# entries: \(getTableSize(habit: "habits"))")
                for habit in habits {
                    print()
                    print("id: \(habit[self.id]), habit: \(habit[self.habit]), time: \(habit[self.time])")
//                    printHabitTable(habit[self.habit])
                }
            } catch {
                print(error)
            }
        }
}
