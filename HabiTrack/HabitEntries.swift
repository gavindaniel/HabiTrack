//
//  HabitEntries.swift
//  HabiTrack
//
//  Created by Gavin Daniel on 9/1/19.
//  Copyright © 2019 Gavin Daniel. All rights reserved.
//

import Foundation
import SQLite

class HabitEntries {
    
    var database: Connection!
    // individual habit journal entry table columns
    let id = Expression<Int>("id")
    let year = Expression<Int>("year")
    let month = Expression<Int>("month")
    let day = Expression<Int>("day")
    let completed = Expression<Int>("completed")
    
    // custom : createTable (create SQL table for each new habit)
    func createTable(habitString: String) {
//        print("Creating \(habitString) Table...")
        let tempTable = Table(habitString)
        let createTable = tempTable.create { (table) in
            table.column(self.id, primaryKey: true)
            table.column(self.year)
            table.column(self.month)
            table.column(self.day)
            table.column(self.completed)
        }
        do {
            try self.database.run(createTable)
//            print("Created Table")
            //            addDay(habit: habitString, date: Date())
        } catch {
            print (error)
        }
    }
    
    // custom : getTableSize (size of database table)
    func getTableSize(habit: String) -> Int {
        var count = 0;
        let table = Table(habit)
        do {
            let days = try self.database.prepare(table)
            for _ in days {
                count += 1
            }
        } catch {
            print (error)
        }
        return (count)
    }
    
    // custom : checkCompleted
    func checkCompleted(habit: String, index: Int) -> Bool {
//        print("checking if \(habit) is completed at index: \(index) ...")
        let table = Table(habit)
//        let size = getTableSize(habit: habit)
        do {
            let days = try self.database.prepare(table)
            var count = 1
            for day in days {
                // check if the day (index) in array is completed
//                print("day[self.completed]: \(day[self.completed])")
                if (count == index) {
//                    print("count: \(count) == index: \(index)")
                    if (day[self.completed] == 1) {
//                        print("day at index is completed")
                        return true
                    }
                }
                count += 1
            }
        } catch {
            print(error)
        }
        // most recent day (today) not completed, return false
        return false
    }
    
    // custom : deleteTable (delete SQL table)
    func deleteTable(habit: String) {
//        print("Deleting \(habit) Table...")
        let table = Table(habit)
        let deleteTable = table.drop()
        do {
            try self.database.run(deleteTable)
//            print("Deleted Table")
        } catch {
            print (error)
        }
    }
    
    // custom : markCompleted
    func markCompleted(habit: String, row: Int, val: Int) {
//        print("Updating completed...")
        do {
            let table = Table(habit)
            let days = try self.database.prepare(table)
            for day in days {
//                print("id: \(day[self.id]), completed: \(day[self.completed])")
                if (day[self.id] == row) {
//                    print("id == \(row)")
                    let temp = table.filter(self.id == row)
                    let updateHabit = temp.update(self.completed <- val)
                    do {
                        try self.database.run(updateHabit)
//                        print("Habit (completed) updated")
                    } catch {
                        print(error)
                    }
                }
            }
        } catch {
            print(error)
        }
    }
    
    // custom : countStreak
    func countStreak(habit: String) -> Int {
//        print("Counting \(habit) habit streak...")
        var count = 0
        do {
            let table = Table(habit)
            let days = try self.database.prepare(table)
            for day in days {
//                print("id: \(day[self.id]), completed: \(day[self.completed])")
                if (day[self.completed] == 1) {
//                    print("incrementing count...")
                    count += 1
                } else {
                    count = 0
                }
            }
        } catch {
            print(error)
        }
//        print("streak: \(count)")
        return(count)
    }
    
    
    // custom : addDay(add a day to habit completed table)
    func addDay(habit: String, date: Date) {
//        print("Adding day to \(habit) table...")
        
        createTable(habitString: habit)
        let table = Table(habit)
        let calendar = Calendar.current
        let year = calendar.component(.year, from: date)
        let month = calendar.component(.month, from: date)
        let day = calendar.component(.day, from: date)
        let addDay = table.insert(self.year <- year, self.month <- month, self.day <- day, self.completed <- 0)
        do {
            try self.database.run(addDay)
//            print("Day Added -> year: \(year), month: \(month), day: \(day)")
        } catch {
            print (error)
        }
    }
    
    func countDays(date1: Date, date2: Date) -> Int {
//        print("counting number of days between dates...")
        let calendar = Calendar.current
        let d1 = calendar.startOfDay(for: date1)
        let d2 = calendar.startOfDay(for: date2)
        let components = calendar.dateComponents([.day], from: d1, to: d2).day ?? 0
//        print("# days between \(d1) and \(d2): \(components)")
        return(components)
    }
}
