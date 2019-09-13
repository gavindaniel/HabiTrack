//
//  Entries.swift
//  HabiTrack
//
//  Created by Gavin Daniel on 9/1/19.
//  Copyright © 2019 Gavin Daniel. All rights reserved.
//

import Foundation
import SQLite

class Entries {
    
    var database: Connection!
    // individual habit journal entry table columns
    let id = Expression<Int>("id")
    let year = Expression<Int>("year")
    let month = Expression<Int>("month")
    let day = Expression<Int>("day")
    let completed = Expression<Int>("completed")
    
    // custom : createTable (create SQL table for each new habit)
    func createTable(habitString: String) {
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
        } catch {
            print (error)
        }
    }
    
    // custom : deleteTable (delete SQL table)
    func deleteTable(habit: String) {
        let table = Table(habit)
        let deleteTable = table.drop()
        do {
            try self.database.run(deleteTable)
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
    
    // custom : checkDateCompleted
    func checkCompleted(habit: String, date: Date) -> Bool {
        let table = Table(habit)
        do {
            let days = try self.database.prepare(table)
            var count = 1
            
            let year = Calendar.current.component(.year, from: date)
            let month = Calendar.current.component(.month, from: date)
            let tempDay = Calendar.current.component(.day, from: date)
            
            for day in days {
                // check if the day (index) in array is completed
                if (day[self.year] == year  && day[self.month] == month && day[self.day] == tempDay) {
                    if (day[self.completed] == 1) {
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
    
    // custom : markDateCompleted
    func markCompleted(habit: String, date: Date, val: Int) {
        do {
            let table = Table(habit)
            let days = try self.database.prepare(table)
            
            let year = Calendar.current.component(.year, from: date)
            let month = Calendar.current.component(.month, from: date)
            let tempDay = Calendar.current.component(.day, from: date)
            
            for day in days {
                if (day[self.year] == year && day[self.month] == month && day[self.day] == tempDay) {
                    let temp = table.filter(self.year == year).filter(self.month == month).filter(self.day == tempDay)
                    let updateHabit = temp.update(self.completed <- val)
                    do {
                        try self.database.run(updateHabit)
                    } catch {
                        print(error)
                    }
                }
            }
        } catch {
            print(error)
        }
    }
    
    // custom : countDateStreak
    func countStreak(habit: String, date: Date) -> Int {
        var index = 1
        var count = 0
        do {
            let table = Table(habit)
            let days = try self.database.prepare(table)
            
            var flag = false
            
            for day in days {
                if (day[self.year] == Calendar.current.component(.year, from: date) &&
                    day[self.month] == Calendar.current.component(.month, from: date) &&
                    day[self.day] == Calendar.current.component(.day, from: date)) {
                    flag = true
                    if (day[self.completed] == 1) {
                        count += 1
                    }
                    break
                } else {
                    if (day[self.completed] == 1) {
                        count += 1
                    } else {
                        count = 0
                    }
                }
                index += 1
            }
            if (!flag) {
                count = 0
            }
        } catch {
            print(error)
        }
        return(count)
    }
    
    func checkDayExists(habit: String, date: Date) -> Bool {
        var flag = false

        let table = Table(habit)
        
        do {
            let entries = try self.database.prepare(table)
            
            for entry in entries {
                if (Calendar.current.component(.year, from: date) == entry[self.year] &&
                    Calendar.current.component(.month, from: date) == entry[self.month] &&
                        Calendar.current.component(.day, from: date) == entry[self.day]) {
                            flag = true
                }
            }
        } catch {
            print(error)
        }
        
        return flag
    }
    
    // custom : addDay(add a day to habit completed table)
    func addDay(habit: String, date: Date) {
        createTable(habitString: habit)
        let table = Table(habit)
        let calendar = Calendar.current
        let year = calendar.component(.year, from: date)
        let month = calendar.component(.month, from: date)
        let day = calendar.component(.day, from: date)
        let addDay = table.insert(self.year <- year, self.month <- month, self.day <- day, self.completed <- 0)
        do {
            try self.database.run(addDay)
        } catch {
            print (error)
        }
    }
    
    // custom : addDay(add a day to habit completed table)
    func deleteDay(habit: String, date: Date) {
        let table = Table(habit)
        let calendar = Calendar.current
        let year = calendar.component(.year, from: date)
        let month = calendar.component(.month, from: date)
        let day = calendar.component(.day, from: date)
//        let addDay = table.insert(self.year <- year, self.month <- month, self.day <- day, self.completed <- 0)
        
        do {
            // loop through the table
            let entry = table.filter(self.year == year).filter(self.month == month).filter(self.day == day)
            // delete the habit
            let deleteDay = entry.delete()
            try self.database.run(deleteDay)
            print("Deleted entry")
        } catch {
            print(error)
        }
    }
    
    func countDays(date1: Date, date2: Date) -> Int {
        let calendar = Calendar.current
        let d1 = calendar.startOfDay(for: date1)
        let d2 = calendar.startOfDay(for: date2)
        let components = calendar.dateComponents([.day], from: d1, to: d2).day ?? 0
        return(components)
    }
}
