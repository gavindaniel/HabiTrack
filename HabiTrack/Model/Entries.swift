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
    func countStreak(habit: String, date: Date, habitRepeat: String) -> Int {
        var index = 1
        var count = 0
        do {
            let table = Table(habit)
            let days = try self.database.prepare(table)
            
            var flag = false
            
            var startDate = Date()
            var startDateDay = ""
            var tempDate = Date()
            var tempDateDay = ""
            
            var flagNewWeek = true
            
            for day in days {
                if (index == 1) {
                    // get day of week the day the habit was created
                    var components = DateComponents()
                    components.year = day[self.year]
                    components.month = day[self.month]
                    components.day = day[self.day]
                    startDate = Calendar.current.date(from: components) ?? Date()
                    startDateDay = getDayOfWeek(date: startDate, length: "long")
                }
                if (day[self.year] == Calendar.current.component(.year, from: date) &&
                    day[self.month] == Calendar.current.component(.month, from: date) &&
                    day[self.day] == Calendar.current.component(.day, from: date)) {
                    flag = true
                    if (day[self.completed] == 1) {
                        if (habitRepeat == "daily") {
                            count += 1
                        }
                        else if (habitRepeat == "weekly") {
                            print("habitRepeat = weekly")
                            var components = DateComponents()
                            components.year = day[self.year]
                            components.month = day[self.month]
                            components.day = day[self.day]
                            tempDate = Calendar.current.date(from: components) ?? Date()
                            tempDateDay = getDayOfWeek(date: tempDate, length: "long")
                            // check if same day of week as date specified (day habit started)
                            print("startDateDay: \(startDateDay) = tempDateDay: \(tempDateDay)")
                            if (startDateDay == tempDateDay) {
                                flagNewWeek = true
                            }
//                            else {
//                                flagNewWeek = false
//                            }
                            print("flagNewWeek: \(flagNewWeek)")
                            if (flagNewWeek == true) {
                                count += 1
                                flagNewWeek = false
                                print("count: \(count)")
                            }
                        }
                    }
                    break
                } else {
                    if (day[self.completed] == 1) {
                        if (habitRepeat == "daily") {
                            count += 1
                        }
                        else if (habitRepeat == "weekly") {
                            var components = DateComponents()
                            components.year = day[self.year]
                            components.month = day[self.month]
                            components.day = day[self.day]
                            tempDate = Calendar.current.date(from: components) ?? Date()
                            tempDateDay = getDayOfWeek(date: tempDate, length: "long")
                            // check if same day of week as date specified (day habit started)
//                            if (startDateDay == tempDateDay) {
//                                count += 1
//                            }
                            // check if same day of week as date specified (day habit started)
                            print("startDateDay: \(startDateDay) = tempDateDay: \(tempDateDay)")
                            if (startDateDay == tempDateDay) {
                                flagNewWeek = true
                            }
//                            else {
//                                flagNewWeek = false
//                            }
                            print("flagNewWeek: \(flagNewWeek)")
                            if (flagNewWeek == true) {
                                count += 1
                                flagNewWeek = false
                                print("count: \(count)")
                            }
                        }
                    } else {
                        if (habitRepeat == "daily") {
                            count = 0
                        }
                        else if (habitRepeat == "weekly") {
                            var components = DateComponents()
                            components.year = day[self.year]
                            components.month = day[self.month]
                            components.day = day[self.day]
                            tempDate = Calendar.current.date(from: components) ?? Date()
                            let tempDateDay = getDayOfWeek(date: tempDate, length: "long")
                            // check if same day of week as date specified (day habit started)
                            if (startDateDay == tempDateDay) {
                                count = 0
                            }
                        }
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
    
    // custom : countLongestStreak
    func countLongestStreak(habit: String, date: Date, habitRepeat: String) -> Int {
        var index = 1
        var count = 0
        var longestStreak = 0
        do {
            let table = Table(habit)
            let days = try self.database.prepare(table)
            
            var flag = false
            
            var startDate = Date()
            var startDateDay = ""
            var tempDate = Date()
            var tempDateDay = ""
            
            var flagNewWeek = true
            
            for day in days {
                if (index == 1) {
                    // get day of week the day the habit was created
                    var components = DateComponents()
                    components.year = day[self.year]
                    components.month = day[self.month]
                    components.day = day[self.day]
                    startDate = Calendar.current.date(from: components) ?? Date()
                    startDateDay = getDayOfWeek(date: startDate, length: "long")
                }
                // check if day in array is equal to date we're calculating streak up to
                if (day[self.year] == Calendar.current.component(.year, from: date) &&
                    day[self.month] == Calendar.current.component(.month, from: date) &&
                    day[self.day] == Calendar.current.component(.day, from: date)) {
                    // set flag true
                    flag = true
                    // check if day is completed
                    if (day[self.completed] == 1) {
                        // increment count
                        if (habitRepeat == "daily") {
                            count += 1
                        }
                        else if (habitRepeat == "weekly") {
                            var components = DateComponents()
                            components.year = day[self.year]
                            components.month = day[self.month]
                            components.day = day[self.day]
                            tempDate = Calendar.current.date(from: components) ?? Date()
                            tempDateDay = getDayOfWeek(date: tempDate, length: "long")
                            // check if same day of week as date specified (day habit started)
//                            if (startDateDay == tempDateDay) {
//                                count += 1
//                            }
                            if (startDateDay == tempDateDay) {
                                flagNewWeek = true
                            }
//                            else {
//                                flagNewWeek = false
//                            }
                            print("flagNewWeek: \(flagNewWeek)")
                            if (flagNewWeek == true) {
                                count += 1
                                flagNewWeek = false
                                print("count: \(count)")
                            }
                        }
                        if (count > 0 && count > longestStreak) {
                            longestStreak = count
                        }
                    }
                    break
                // else the day in the array is not the date we're calculating streak up until
                } else {
                    // check if day completed
                    if (day[self.completed] == 1) {
                        // increment count
                        if (habitRepeat == "daily") {
                            count += 1
                        }
                        else if (habitRepeat == "weekly") {
                            var components = DateComponents()
                            components.year = day[self.year]
                            components.month = day[self.month]
                            components.day = day[self.day]
                            tempDate = Calendar.current.date(from: components) ?? Date()
                            tempDateDay = getDayOfWeek(date: tempDate, length: "long")
                            // check if same day of week as date specified (day habit started)
//                            if (startDateDay == tempDateDay) {
//                                count += 1
//                            }
                            if (startDateDay == tempDateDay) {
                                flagNewWeek = true
                            }
//                            else {
//                                flagNewWeek = false
//                            }
                            print("flagNewWeek: \(flagNewWeek)")
                            if (flagNewWeek == true) {
                                count += 1
                                flagNewWeek = false
                                print("count: \(count)")
                            }
                        }
                        if (count > 0 && count > longestStreak) {
                            longestStreak = count
                        }
                    // else day is not completed
                    } else {
                        if (habitRepeat == "daily") {
                            count = 0
                        }
                        else if (habitRepeat == "weekly") {
                            var components = DateComponents()
                            components.year = day[self.year]
                            components.month = day[self.month]
                            components.day = day[self.day]
                            tempDate = Calendar.current.date(from: components) ?? Date()
                            let tempDateDay = getDayOfWeek(date: tempDate, length: "long")
                            // check if same day of week as date specified (day habit started)
                            if (startDateDay == tempDateDay) {
                                count = 0
                            }
                        }
                        // check if count has been incremented AND if longer than current longest streak
                        if (count > 0 && count > longestStreak) {
                            // update longest streak
                            longestStreak = count
                        }
                        // reset count
//                        count = 0
                    }
                }
                index += 1
            } // end for loop
            // check if the flag has not been set true
            if (!flag) {
                count = 0
            }
        } catch {
            print(error)
        }
        return(longestStreak)
    }
}
