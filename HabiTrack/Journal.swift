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
    let habitEntries = HabitEntries()
    // habits table columns
    let id = Expression<Int>("id")
    let habit = Expression<String>("habit")
    let time = Expression<String>("time")
    let streak = Expression<Int>("streak")
    let currentDay = Expression<Int>("currentDay")
    // individual habit journal entry table columns
//    let year = Expression<Int>("year")
//    let month = Expression<Int>("month")
//    let day = Expression<Int>("day")
//    let completed = Expression<Int>("completed")
    
    
    
    // custom : createTable (create SQL table)
    func createTable() {
        print("Creating Table...")
        let createTable = self.habitsTable.create { (table) in
            table.column(self.id, primaryKey: true)
            table.column(self.habit)
            table.column(self.time)
            table.column(self.streak)
            table.column(self.currentDay)
        }
        do {
            try self.database.run(createTable)
            print("Created Table")
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
    
    // custom : updateStreak
    func updateStreak(row: Int, inc: Int, habitString: String) {
        print("Updating streak...")
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
                    let tempRow = 1
                    habitEntries.markCompleted(habit: habitString, row: tempRow, val: inc)
                    let currentStreak = habitEntries.countStreak(habit: habitString)
                    let updateHabit = habit.update(self.streak <- currentStreak)
                    do {
                        try self.database.run(updateHabit)
                        print("Updated streak")
//                        self.habitTableView.reloadData()
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
}
