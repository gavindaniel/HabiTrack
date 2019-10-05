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
                    let habit = self.habitsTable.filter(self.id == count+firstId)
                    print("date: \(date)")
                    entries.markCompleted(habit: habitString, date: date, val: inc)
                    let currentStreak = entries.countStreak(habit: habitString, date: date)
                    let updateHabit = habit.update(self.streak <- currentStreak)
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
    }
    
    /// The method for adding a new item to the table view's data model.
    func addItem(_ habitString: String, at index: Int) {
        print("addItem")
        localHabbits.insert(habitString, at: index)
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
}
