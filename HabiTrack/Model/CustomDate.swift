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


