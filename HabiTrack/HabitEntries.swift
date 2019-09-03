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
    func checkDateCompleted(habit: String, date: Date) -> Bool {
//        print("check date completed...")
        let table = Table(habit)
        do {
            let days = try self.database.prepare(table)
            var count = 1
            
            let year = Calendar.current.component(.year, from: date)
            let month = Calendar.current.component(.month, from: date)
            let tempDay = Calendar.current.component(.day, from: date)
            
//            print("year: \(year), month: \(month), day: \(tempDay)")
            
            // testing
//            let temp = table.filter(self.id == row)
            
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
    
    // custom : checkCompleted
    func checkCompleted(habit: String, index: Int) -> Bool {
        let table = Table(habit)
        do {
            let days = try self.database.prepare(table)
            var count = 1
            for day in days {
                // check if the day (index) in array is completed
                if (count == index) {
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
    
    // custom : markDateCompleted
    func markDateCompleted(habit: String, date: Date, val: Int) {
        print("mark date: \(date) completed...")
        do {
            let table = Table(habit)
            let days = try self.database.prepare(table)
            
            let year = Calendar.current.component(.year, from: date)
            let month = Calendar.current.component(.month, from: date)
            let tempDay = Calendar.current.component(.day, from: date)
            print("year: \(year), month: \(month), day: \(tempDay)")
            
            for day in days {
                print("year: \(day[self.year]), month: \(day[self.month]), day: \(day[self.day])")
                if (day[self.year] == year && day[self.month] == month && day[self.day] == tempDay) {
                    let temp = table.filter(self.year == year).filter(self.month == month).filter(self.day == tempDay)
                    let updateHabit = temp.update(self.completed <- val)
                    do {
                        try self.database.run(updateHabit)
                    } catch {
                        print(error)
                    }
                }
                print("incrementing...")
            }
        } catch {
            print(error)
        }
    }
    
    // custom : markCompleted
    func markCompleted(habit: String, row: Int, val: Int) {
        do {
            let table = Table(habit)
            let days = try self.database.prepare(table)
            for day in days {
                if (day[self.id] == row) {
                    let temp = table.filter(self.id == row)
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
    func countDateStreak(habit: String, date: Date) -> Int {
//        print("counting \(habit) date streak...")
        var index = 1
        var count = 0
        
        let year = Calendar.current.component(.year, from: date)
        let month = Calendar.current.component(.month, from: date)
        let tempDay = Calendar.current.component(.day, from: date)
//        print("year: \(year), month: \(month), day: \(tempDay)")
//        print("date: \(date)")
        
        do {
            let table = Table(habit)
            let days = try self.database.prepare(table)
            for day in days {
//                print("year: \(day[self.year]), month: \(day[self.month]), day: \(day[self.day])")
                if (day[self.completed] == 1) {
                    count += 1
//                    print("count: \(count)")
                } else {
//                    print("not completed -> year: \(day[self.year]), month: \(day[self.month]), day: \(day[self.day])")
//                    if (day[self.year] != year && day[self.month] != month && day[self.day] != tempDay) {
//                        count = 0
//                        print("count: \(count)")
//                    }
//                    print("day[self.day]: \(day[self.day]) != \(tempDay)")
                    if (day[self.day] != tempDay) {
                        count = 0
//                        print("count: \(count)")
                    }
                }
                index += 1
            }
        } catch {
            print(error)
        }
        //        print("streak: \(count)")
        return(count)
    }
    
    // custom : countStreak
    func countStreak(habit: String) -> Int {
        var index = 1
        var count = 0
        do {
            let table = Table(habit)
            let days = try self.database.prepare(table)
            for day in days {
                    if (day[self.completed] == 1) {
                        count += 1
                    } else {
                        if (index != getTableSize(habit: habit)) {
                            count = 0
                        }
                    }
                index += 1
            }
        } catch {
            print(error)
        }
//        print("streak: \(count)")
        return(count)
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
//            print("Day Added -> year: \(year), month: \(month), day: \(day)")
        } catch {
            print (error)
        }
    }
    
    func countDays(date1: Date, date2: Date) -> Int {
        let calendar = Calendar.current
        let d1 = calendar.startOfDay(for: date1)
        let d2 = calendar.startOfDay(for: date2)
        let components = calendar.dateComponents([.day], from: d1, to: d2).day ?? 0
//        print("# days between \(d1) and \(d2): \(components)")
        return(components)
    }
}
