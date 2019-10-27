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
    func createTable(habit: String) {
        // get the table for the habit specified
        let tempTable = Table(habit)
        // create the table with the columns listed below
        let createTable = tempTable.create { (table) in
            table.column(self.id, primaryKey: true)
            table.column(self.year)
            table.column(self.month)
            table.column(self.day)
            table.column(self.completed)
        }
        do {
            // try to create the table in the database for the habit specified
            try self.database.run(createTable)
        // catch any errors while accessing database
        } catch {
            print (error)
        }
    }
    
    // custom : deleteTable (delete SQL table)
    func deleteTable(habit: String) {
        // get the table for the habit specified
        let table = Table(habit)
        // drop the table for the habit specified
        let deleteTable = table.drop()
        do {
            // try to drop the table for the habit specified
            try self.database.run(deleteTable)
        // catch any errors while accessing database
        } catch {
            print (error)
        }
    }
    
    // custom : getTableSize (size of entries table for the habit specified)
    func getTableSize(habit: String) -> Int {
        var count = 0               // table size counter
        let table = Table(habit)    // table for the habit specified
        do {
            // try to get the entries table for the habit specified
            let entries = try self.database.prepare(table)
            // loop through the entries and count size
            for _ in entries {
                count += 1
            }
        // catch any errors while accessing database
        } catch {
            print (error)
        }
        // return the table size
        return (count)
    }
    
    // custom : checkDateCompleted
    func checkCompleted(habit: String, date: Date) -> Bool {
        // get the table for the habit
        let table = Table(habit)
        do {
            // try to get the entries table for the habit
            let entries = try self.database.prepare(table)
            // get the date components from the date specified
            let year = Calendar.current.component(.year, from: date)
            let month = Calendar.current.component(.month, from: date)
            let day = Calendar.current.component(.day, from: date)
            // loop through the entries
            for entry in entries {
                // check if the current entry date matches the date specified
                if (entry[self.year] == year  && entry[self.month] == month && entry[self.day] == day) {
                    // check if the entry has been completed for that date
                    if (entry[self.completed] == 1) {
                        // return true, the entry has been completed for that date
                        return true
                    }
                }
            }
        // catch any errors while accessing the database
        } catch {
            print(error)
        }
        // return false, the entry has NOT been completed for that date
        return false
    }
    
    // custom : markDateCompleted
    func markCompleted(habit: String, date: Date, val: Int) {
        // get the table for the habit
        let table = Table(habit)
        do {
            // try to get the entries table for the habit
            let entries = try self.database.prepare(table)
            // get the date components from the date specified
            let year = Calendar.current.component(.year, from: date)
            let month = Calendar.current.component(.month, from: date)
            let day = Calendar.current.component(.day, from: date)
            // loop through the entries
            for entry in entries {
                // check if the date specified matches the date for the current entry
                if (entry[self.year] == year && entry[self.month] == month && entry[self.day] == day) {
                    // get the entry from the table whose date matches the date specified
                    let tempEntry = table.filter(self.year == year).filter(self.month == month).filter(self.day == day)
                    // update the entry with the value specified for the completed column
                    let updateEntry = tempEntry.update(self.completed <- val)
                    // try to update the entry in the database
                    do {
                        try self.database.run(updateEntry)
                    // catch any errors while accessing the database
                    } catch {
                        print(error)
                    }
                }
            }
        // catch any errors while trying to access the database
        } catch {
            print(error)
        }
    }
    
    // custom : countDateStreak
    func countStreak(habit: String, date: Date, habitRepeat: Int) -> Int { //habitRepeat: String
        // get the table for the habit
        let table = Table(habit)
        // count has to be defined outside to not be binding
        var count = 0   // streak count
        // try to get the entries for the habit
        do {
            let days = try self.database.prepare(table)
            // define necessary variables if no issues get the table of entries
            var index = 1   // index in array
//            let startDateDay = getDayOfWeekString(dayOfWeek: habitRepeat, length: "long")   // string representation of start day
            var tempDate = Date()   // current day in array
//            var tempDateDay = ""    // string representation of current day in array
            var flag = false        // FIXME: Unneccsary flag???
            var flagNewWeek = true  // flag for finding the start of a new week
            // loop through the entries
            for day in days {
                // check for first day in entries
                if (index == 1) {
                    // get day of week the day the habit was created
//                    var components = DateComponents()
//                    components.year = day[self.year]
//                    components.month = day[self.month]
//                    components.day = day[self.day]
//                    startDate = Calendar.current.date(from: components) ?? Date()
//                    startDateDay = getDayOfWeek(date: startDate, length: "long")
                }
                // check if we're at date specified (selected in dateView) in the array
                if (day[self.year] == Calendar.current.component(.year, from: date) &&
                    day[self.month] == Calendar.current.component(.month, from: date) &&
                    day[self.day] == Calendar.current.component(.day, from: date)) {
                    // FIXME: Not sure if this flag is needed
                    flag = true
                    // check if current day in the array has been completed, if so increment counter
                    if (day[self.completed] == 1) {
                        // check if the habit is repeated every day
//                        print("habitRepeat == 1234567")
                        if (habitRepeat == 1234567) {     // "daily"
//                            print("\thabitRepeat = 1234567")
                            count += 1
                        }
                        // check if the habit is repeated weekly
                        else if (habitRepeat != 1234567) {     // "weekly"
//                            print("habitRepeat = weekly")
                            // get the day of the week the habit is repeated/reset
                            var components = DateComponents()
                            components.year = day[self.year]
                            components.month = day[self.month]
                            components.day = day[self.day]
                            tempDate = Calendar.current.date(from: components) ?? Date()
                            let tempDateDay = Calendar.current.component(.weekday, from: tempDate)
                            // check if same day of week as date specified (day habit started)
                            if (checkDayOfWeek(dayInt: habitRepeat, dayOfWeek: tempDateDay)) {
//                                print("startDateDay: \(startDateDay) == tempDateDay: \(tempDateDay)")
                                // set our flag true because it is the start
                                flagNewWeek = true
                            }
//                            else {
//                                flagNewWeek = false
//                            }
//                            print("flagNewWeek: \(flagNewWeek)")
                            // if it is the start of a new week, increment the streak count, reset the flag
                            if (flagNewWeek == true) {
                                count += 1
                                flagNewWeek = false
//                                print("count: \(count)")
                            }
                        }
                    }
                    // break the for loop since we've reached the date specified (selected in dateView)
                    break
                // else if we're not at the date specified (selected in dateView)
                } else {
                    // check if the current day in the array has been completed, if so increment counter
                    if (day[self.completed] == 1) {
                        // check if the habit is repeated every day
                        if (habitRepeat == 1234567) {     // "daily"
                            count += 1
                        }
                        // check if the habit is repeated weekly
                        else if (habitRepeat != 1234567) {     // "weekly"
                            // create a date variable from the date components for the current entry
                            var components = DateComponents()
                            components.year = day[self.year]
                            components.month = day[self.month]
                            components.day = day[self.day]
                            tempDate = Calendar.current.date(from: components) ?? Date()
                            let tempDateDay = Calendar.current.component(.weekday, from: tempDate)
                            // check if same day of week as date specified (day habit started)
//                            print("\telse weekly checkDayOfWeek...")
                            if (checkDayOfWeek(dayInt: habitRepeat, dayOfWeek: tempDateDay)) {
//                                print("startDateDay: \(startDateDay) = tempDateDay: \(tempDateDay)")
                                flagNewWeek = true
                            }
                            // check if a new week has been started
                            if (flagNewWeek == true) {
                                count += 1
                                flagNewWeek = false
//                                print("count: \(count)")
                            }
                        }
                    // else if the current day has NOT been completed, reset the counter
                    } else {
                        // check if the habit is repeated every day, if so reset the counter
                        if (habitRepeat == 1234567) {     // "daily"
                            count = 0
                        }
                        // check if the habit is repeated every week
                        else if (habitRepeat != 1234567) {     // "weekly"
                            // get the day of the week the habit is repeated
                            var components = DateComponents()
                            components.year = day[self.year]
                            components.month = day[self.month]
                            components.day = day[self.day]
                            tempDate = Calendar.current.date(from: components) ?? Date()
//                            let tempDateDay = getDayOfWeek(date: tempDate, length: "long")
                            let tempDateDay = Calendar.current.component(.weekday, from: tempDate)
                            // check if same day of week as date specified (day habit started), if so reset counter
//                            print("\ttesting...")
                            if (checkDayOfWeek(dayInt: habitRepeat, dayOfWeek: tempDateDay)) {
                                count = 0
                            }
                        }
                    }
                }
                // increment index for finding the first index in array
                index += 1
            }
            // FIXME: not totally sure if this if statement is necessary
            if (!flag) {
                count = 0
            }
        // catch any errors
        } catch {
            print(error)
        }
        // return streak count
        return(count)
    }
    
    // custom: checkDayExists (check if the day selected exists for the habit specified in the entries table)
    func checkDayExists(habit: String, date: Date) -> Bool {
        // get the table for the habit
        let table = Table(habit)
        do {
            // get the entries for the habit
            let entries = try self.database.prepare(table)
            // loop through the entries
            for entry in entries {
                // check if the date specified at any time in the loop matches a date in the entries table
                if (Calendar.current.component(.year, from: date) == entry[self.year] &&
                    Calendar.current.component(.month, from: date) == entry[self.month] &&
                    Calendar.current.component(.day, from: date) == entry[self.day]) {
                    // return true, the day exists in the entries table
                    return true
                }
            }
        // catch any errors while trying to get the entries table
        } catch {
            print(error)
        }
        // return false, the day specified was not found in the entries table
        return false
    }
    
    // custom : addDay(add a day to habit completed table)
    func addDay(habit: String, date: Date) {
        // try to create a table for the habit
        createTable(habit: habit)
        // get the table for the habit
        let table = Table(habit)
        // get the components for the date from the date specified
        let year = Calendar.current.component(.year, from: date)
        let month = Calendar.current.component(.month, from: date)
        let day = Calendar.current.component(.day, from: date)
        // insert the new day into the entries table for the habit
        let addDay = table.insert(self.year <- year, self.month <- month, self.day <- day, self.completed <- 0)
        do {
            // try to run the database command to insert the day into the table
            try self.database.run(addDay)
        // catch any errors from trying to run the command on the database
        } catch {
            print (error)
        }
    }
    
    // custom : addDay(add a day to habit completed table)
    func deleteDay(habit: String, date: Date) {
        // get the table
        let table = Table(habit)
        // get the date components from the date specified
        let year = Calendar.current.component(.year, from: date)
        let month = Calendar.current.component(.month, from: date)
        let day = Calendar.current.component(.day, from: date)
        // find the entry for the date specified
        let entry = table.filter(self.year == year).filter(self.month == month).filter(self.day == day)
        // delete the habit
        let deleteDay = entry.delete()
        do {
            // try to run the delete command on the database for the day specified
            try self.database.run(deleteDay)
        // catch any errors while accessing database
        } catch {
            print(error)
        }
    }
    
    // custom : countLongestStreak
    func countLongestStreak(habit: String, date: Date, habitRepeat: Int) -> Int {   // String
        // defining return variables so they're non-binding
        var count = 0           // count of current streak
        var longestStreak = 0   // longest streak in the entries
        do {
            // get the table for the habit specified
            let table = Table(habit)
            // try to get the entries for the habit specified
            let entries = try self.database.prepare(table)
            // if no issues with getting the entries, define necessary variables
//            var startDate = Date()  // date of first entry
//            var startDateDay = ""   // string form of first entry
//            let startDateDay = getDayOfWeekString(dayOfWeek: habitRepeat, length: "long")   // string form of first entry
            var tempDate = Date()   // temporary date of current entry
//            var tempDateDay = ""    // temporary string form of current entry
            var flag = false        // FIXME: Unneccessary flag???
            var flagNewWeek = true  // flag for finding the start of a new week
            var index = 1           // index for finding first entry
            for entry in entries {
                if (index == 1) {
                    // get day of week the day the habit was created
//                    var components = DateComponents()
//                    components.year = entry[self.year]
//                    components.month = entry[self.month]
//                    components.day = entry[self.day]
//                    startDate = Calendar.current.date(from: components) ?? Date()
//                    startDateDay = getDayOfWeek(date: startDate, length: "long")
                }
                // check if day in array is equal to date we're calculating streak up to
                if (entry[self.year] == Calendar.current.component(.year, from: date) &&
                    entry[self.month] == Calendar.current.component(.month, from: date) &&
                    entry[self.day] == Calendar.current.component(.day, from: date)) {
                    // FIXME: set flag true, is this neccessary???
                    flag = true
                    // check if day is completed
                    if (entry[self.completed] == 1) {
                        // check if the habit is repeated every day
                        if (habitRepeat == 0) {     // "daily"
                            count += 1  // increment streak count
                        }
                        // check if the habit is repeated every week
                        else if (habitRepeat > 0) {     // "weekly"
                            // get the date of the current entry from its components
                            var components = DateComponents()
                            components.year = entry[self.year]
                            components.month = entry[self.month]
                            components.day = entry[self.day]
                            tempDate = Calendar.current.date(from: components) ?? Date()
//                            tempDateDay = getDayOfWeek(date: tempDate, length: "long")
                            let tempDateDay = Calendar.current.component(.weekday, from: date)
                            // check if same day of week as date specified (day habit started)
//                            if (startDateDay == tempDateDay) {
                            if (checkDayOfWeek(dayInt: tempDateDay, dayOfWeek: tempDateDay)) {
                                flagNewWeek = true  // set flag to true, start of new week
                            }
                            // check if a new week has started
                            if (flagNewWeek == true) {
                                count += 1              // increment streak count
                                flagNewWeek = false     // clear the new week flag
//                                print("count: \(count)")
                            }
                        }
                        // check if the streak count is greater than 0 AND
                        // check if the current streak count is longer than the longest streak counted so far
                        if (count > 0 && count > longestStreak) {
                            longestStreak = count   // set the longest streak to the current streak count
                        }
                    }
                    // break the loop since we've reached the date specified (selected in dateView)
                    break
                // else the day in the array is not the date we're calculating streak up until
                } else {
                    // check if entry has been completed
                    if (entry[self.completed] == 1) {
                        // check if the habit is repeated every day
                        if (habitRepeat == 1234567) {     // "daily"
                            count += 1      // increment streak count
                        }
                        // check if the habit is repeated every week
                        else if (habitRepeat != 1234567) {     // "weekly"
                            // get the date for the current entry from its date components
                            var components = DateComponents()
                            components.year = entry[self.year]
                            components.month = entry[self.month]
                            components.day = entry[self.day]
                            tempDate = Calendar.current.date(from: components) ?? Date()
                            let tempDateDay = Calendar.current.component(.weekday, from: date)
                            // check if same day of week as date specified (day habit started)
                            if (checkDayOfWeek(dayInt: habitRepeat, dayOfWeek: tempDateDay)) {
                                flagNewWeek = true      // set flag to true, start of a new week
                            }
                            // check if a new week has started
                            if (flagNewWeek == true) {
                                count += 1              // increment streak counter
                                flagNewWeek = false     // reset new week flag
//                                print("count: \(count)")
                            }
                        }
                        // check if the current streak count is > 0 AND
                        // check if the current streak count is > longest streak count so far
                        if (count > 0 && count > longestStreak) {
                            longestStreak = count   // set the new longest streak to the current streak count
                        }
                    // else entry is not completed
                    } else {
                        // check if the habit is repeated every day
                        if (habitRepeat == 1234567) {     // "daily"
                            count = 0   // reset the streak count
                        }
                        // check if the habit is repeated every week
                        else if (habitRepeat != 1234567) {     // "weekly"
                            // get the date of the current entry from its date components
                            var components = DateComponents()
                            components.year = entry[self.year]
                            components.month = entry[self.month]
                            components.day = entry[self.day]
                            tempDate = Calendar.current.date(from: components) ?? Date()
                            let tempDateDay = Calendar.current.component(.weekday, from: date)
                            // check if same day of week as date specified (day habit started)
                            if (checkDayOfWeek(dayInt: habitRepeat, dayOfWeek: tempDateDay)) {
                                count = 0   // reset streak count
                            }
                        }
                        // check if count has been incremented AND if longer than current longest streak
                        if (count > 0 && count > longestStreak) {
                            // update longest streak
                            longestStreak = count
                        }
                    }
                }
                index += 1  // increment index after we've found the first entry
            } // end for loop
            // FIXME: check if the flag has not been set true; IS THIS NECCESSARY???
            if (!flag) {
                count = 0
            }
        // catch any errors while accessing database for entries table
        } catch {
            print(error)
        }
        // return the longest streak count
        return(longestStreak)
    }
}
