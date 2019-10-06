//
//  CustomDate.swift
//  HabiTrack
//
//  Created by Gavin Daniel on 9/4/19.
//  Copyright © 2019 Gavin Daniel. All rights reserved.
//

import Foundation

// custom : isKeyPresentInUserDefaults
func isKeyPresentInUserDefaults(key: String) -> Bool {
    return UserDefaults.standard.object(forKey: key) != nil
}

// custom : setDefaults
func setDefaults() {
//    let defaults = UserDefaults.standard
    if (isKeyPresentInUserDefaults(key: "lastRun") == false) {
        let defaults = UserDefaults.standard
        defaults.set(Date(), forKey: "lastRun")
    }
}

// custom : getDay
func getDayAsInt(date: Date) -> Int {
    let day = Calendar.current.component(.day, from: date)
    return day
}

// custom : getMonth (return String)
func getMonthAsString(date: Date) -> String {
    let month = Calendar.current.component(.month, from: date)
    switch (month) {
    case 1:
        return ("Jan")
    case 2:
        return ("Feb")
    case 3:
        return ("Mar")
    case 4:
        return ("Apr")
    case 5:
        return ("May")
    case 6:
        return ("Jun")
    case 7:
        return ("Jul")
    case 8:
        return ("Aug")
    case 9:
        return ("Sep")
    case 10:
        return ("Oct")
    case 11:
        return ("Nov")
    case 12:
        return ("Dec")
    default:
        return ("Jan")
    }
}

// custom : getMonth (return Int)
func getMonthAsInt(month: String) -> Int {
    switch (month) {
    case "Jan":
        return (1)
    case "Feb":
        return (2)
    case "Mar":
        return (3)
    case "Apr":
        return (4)
    case "May":
        return (5)
    case "Jun":
        return (6)
    case "Jul":
        return (7)
    case "Aug":
        return (8)
    case "Sep":
        return (9)
    case "Oct":
        return (10)
    case "Nov":
        return (11)
    case "Dec":
        return (12)
    default:
        return (1)
    }
}

// getDate (from inputs)
func getDate(month: Int, day: Int) -> Date {
    let components = DateComponents(year: 2019, month: month, day: day, hour: 0, minute: 0, second: 0)
    let date = Calendar.current.date(from: components) ?? Date()
    return date
}

// custom : getDayOfWeek
func getDayOfWeek(date: Date, length: String) -> String {
//    let weekDay = Calendar.current.component(.weekday, from: Date())
    let weekDayToday = Calendar.current.component(.weekday, from: Date())
    print("date: \(date)")
    let weekDaySelected = Calendar.current.component(.weekday, from: date)
//    print("weekDay: \(weekDay)")
    print("weekDaySelected: \(weekDaySelected)")
    // check if requesting full spelling
    if (length == "long") {
        switch(weekDaySelected) {
        case (1):
            return ("Sunday")
        case (2):
            return ("Monday")
        case (3):
            return ("Tuesday")
        case (4):
            return ("Wednesday")
        case (5):
            return ("Thursday")
        case (6):
            return ("Friday")
        case (7):
            return ("Saturday")
        default:
            return("")
        }
    // else return short spelling
    } else {
        switch(weekDaySelected) {
        case (1):
            return ("Sun")
        case (2):
            return ("Mon")
        case (3):
            return ("Tue")
        case (4):
            return ("Wed")
        case (5):
            return ("Thu")
        case (6):
            return ("Fri")
        case (7):
            return ("Sat")
        default:
            return("")
        }
    }
}

// count number of days in between dates
func countDays(date1: Date, date2: Date) -> Int {
    let calendar = Calendar.current
    let d1 = calendar.startOfDay(for: date1)
    let d2 = calendar.startOfDay(for: date2)
    let components = calendar.dateComponents([.day], from: d1, to: d2).day ?? 0
    return(components)
}

