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
func getMonthAsString(date: Date, length: String) -> String {
    let month = Calendar.current.component(.month, from: date)
    if (length == "short") {
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
            return ("")
        }
    }
    // else return full spelling
    else {
        switch (month) {
        case 1:
            return ("January")
        case 2:
            return ("February")
        case 3:
            return ("March")
        case 4:
            return ("April")
        case 5:
            return ("May")
        case 6:
            return ("June")
        case 7:
            return ("July")
        case 8:
            return ("August")
        case 9:
            return ("September")
        case 10:
            return ("October")
        case 11:
            return ("November")
        case 12:
            return ("December")
        default:
            return ("")
        }
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

// get day as a string of 1st, 2nd, 3rd, 4th, exc.
func getDayTh(date: Date) -> String {
    
    let day = Calendar.current.component(.day, from: date)
    
    // 1st, 21st, 31st
    if (day == 1 || day == 21 || day == 31) {
        let dayString = "\(day)st"
//        return("\(day)st")
        return(dayString)
    // 2nd , 22nd
    } else if (day == 2 || day == 22) {
        let dayString = "\(day)nd"
        return(dayString)
    // 3rd, 23rd
    } else if (day == 3 || day == 23) {
        let dayString = "\(day)rd"
        return(dayString)
    // else th
    } else {
        let dayString = "\(day)th"
        return(dayString)
    }
    
}

// getDate (from inputs)
func getDate(month: Int, day: Int) -> Date {
//    print("month: \(month) day: \(day)")
    let components = DateComponents(year: 2019, month: month, day: day, hour: 0, minute: 0, second: 0)
    let date = Calendar.current.date(from: components) ?? Date()
    return date
}

// custom : getDayOfWeekString
func getDayOfWeekString(dayOfWeek: Int, length: String) -> String {
    if (length == "long") {
        switch(dayOfWeek) {
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
        switch(dayOfWeek) {
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

// custom : getDayOfWeek
func getDayOfWeek(date: Date, length: String) -> String {
//    print("date: \(date)")
    let weekDaySelected = Calendar.current.component(.weekday, from: date)
//    print("weekDaySelected: \(weekDaySelected)")
    // check if requesting full spelling
    return (getDayOfWeekString(dayOfWeek: weekDaySelected, length: length))
}

// count number of days in between dates
func countDays(date1: Date, date2: Date) -> Int {
    let calendar = Calendar.current
    let d1 = calendar.startOfDay(for: date1)
    let d2 = calendar.startOfDay(for: date2)
    let components = calendar.dateComponents([.day], from: d1, to: d2).day ?? 0
    return(components)
}

// get date as string format 'Month Day'
func getDateAsString(date: Date, length: String) -> String {
//    if today, return 'Today'
    if (countDays(date1: Date(), date2: date) == 0) {
        return "Today"
    }
    // 'Tomorrow'
    else if (countDays(date1: Date(), date2: date) == 1) {
        return "Tomorrow"
    }
    // 'Yesterday'
    else if (countDays(date1: Date(), date2: date) == -1) {
        return "Yesterday"
    }
    // return abbreviated length
    else {
        let tempString = "\(getMonthAsString(date: date, length: length)) \(getDayTh(date: date))"
        return tempString
    }
}

// get streak as string
func getStreakAsString(streak: Int) -> String {
    
//    var numDays = streak
    var numWeeks = 0
//    var numMonths = 0
    var numYears = 0
    
    var dateString = ""
    
    if (streak / 365 > 0) {
        numYears = streak / 365
        if (numYears > 1) {
            dateString += "\(numYears) years "
        } else {
            dateString += "\(numYears) year "
        }
        if (streak % 365 == 0) {
            dateString += "0 months 0 weeks 0 days"
        } else if (streak % 7 == 1) {
            dateString += "1 day"
        } else  {
            dateString += "\(streak % 7) days"
        }
    }
    if (streak / 7 > 0) {
        numWeeks = streak / 7
        if (numWeeks > 1) {
            dateString += "\(numWeeks) weeks "
        } else {
            dateString += "\(numWeeks) week "
        }
        if (streak % 7 == 0) {
            dateString += "0 days"
        } else if (streak % 7 == 1) {
            dateString += "1 day"
        } else  {
            dateString += "\(streak % 7) days"
        }
    }
    if (streak < 7) {
        if (streak == 0) {
            dateString += "0 days"
        } else if (streak == 1) {
            dateString += "1 day"
        } else {
            dateString += "\(streak) days"
        }
    }
    
    return dateString
}


// since arrays aren't supported with sqlite
func checkDayOfWeek(dayInt: Int, dayOfWeek: Int) -> Bool {
    let dayString = String(dayInt)
    if (dayString.contains(String(dayOfWeek))) {
        print("\(dayInt) contains a \(dayOfWeek)")
        return true
    } else {
        return false
    }
//    if (dayString.contains("1")) {
//        print("\(dayInt) contains a 1")
//        return true
//    }
//    else if (dayString.contains("2")) {
//        print("\(dayInt) contains a 2")
//    } else if (dayString.contains("3")) {
//        print("\(dayInt) contains a 3")
//    } else if (dayString.contains("4")) {
//        print("\(dayInt) contains a 4")
//    } else if (dayString.contains("5")) {
//        print("\(dayInt) contains a 5")
//    } else if (dayString.contains("6")) {
//        print("\(dayInt) contains a 6")
//    } else if (dayString.contains("7")) {
//        print("\(dayInt) contains a 7")
//    }
}
