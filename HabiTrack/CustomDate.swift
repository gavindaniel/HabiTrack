//
//  CustomDate.swift
//  HabiTrack
//
//  Created by Gavin Daniel on 9/4/19.
//  Copyright © 2019 Gavin Daniel. All rights reserved.
//

import Foundation

// custom : setDefaults
func setDefaults() {
    let defaults = UserDefaults.standard
    defaults.set(Date(), forKey: "lastRun")
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

// getLocalDate(from date)
func getLocalDate(date: Date) -> Date {
    var components = DateComponents()
    components.year = getYear(date: date)
    components.month = getMonth(date: date)
    components.day = getDayInt(date: date)
    let tempHour = getHour(date: date)
    print("tempHour: \(String(tempHour))")
    components.hour = getHour(date: date)
    components.minute = getMin(date: date)
    components.second = getSec(date: date)
//    components.timeZone = TimeZone.current
    let local_date = Calendar.current.date(from: components) ?? Date()
    print("local_date hour: \(Calendar.current.component(.hour, from: local_date))")
    return local_date
}


func getYear(date: Date) -> Int {
    let format = DateFormatter()
    format.timeZone = .current
    format.dateFormat = "yyyy"
    let dateString = format.string(from: date)
    print("year: \(dateString)")
//    let dateInt = Int(dateString) ?? Calendar.current.component(.year, from: Date())
//    print("dateInt: \(String(dateInt))")
    return Int(dateString) ?? Calendar.current.component(.year, from: Date())
}

func getMonth(date: Date) -> Int {
    let format = DateFormatter()
    format.timeZone = .current
    format.dateFormat = "MM"
    let dateString = format.string(from: date)
    print("month: \(dateString)")
    return Int(dateString) ?? Calendar.current.component(.month, from: Date())
}


// remove Int from name
func getDayInt(date: Date) -> Int {
    let format = DateFormatter()
    format.timeZone = .current
    format.dateFormat = "dd"
    let dateString = format.string(from: date)
    print("day: \(dateString)")
    return Int(dateString) ?? Calendar.current.component(.day, from: Date())
}

func getHour(date: Date) -> Int {
    let format = DateFormatter()
    format.timeZone = .current
    format.dateFormat = "HH"
    let dateString = format.string(from: date)
    print("hour: \(dateString)")
    let dateInt = Int(dateString) ?? Calendar.current.component(.hour, from: Date())
    print("dateInt: \(String(dateInt))")
    return Int(dateString) ?? Calendar.current.component(.hour, from: Date())
}

func getMin(date: Date) -> Int {
    let format = DateFormatter()
    format.timeZone = .current
    format.dateFormat = "mm"
    let dateString = format.string(from: date)
    print("minutes: \(dateString)")
    return Int(dateString) ?? Calendar.current.component(.minute, from: Date())
}

func getSec(date: Date) -> Int {
    let format = DateFormatter()
    format.timeZone = .current
    format.dateFormat = "ss"
    let dateString = format.string(from: date)
    print("seconds: \(dateString)")
    return Int(dateString) ?? Calendar.current.component(.second, from: Date())
}

