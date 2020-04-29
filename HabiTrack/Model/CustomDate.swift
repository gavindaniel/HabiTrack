//
//  CustomDate.swift
//  HabiTrack
//
//  Created by Gavin Daniel on 9/4/19.
//  Copyright © 2019 Gavin Daniel. All rights reserved.
//

import Foundation


// name: isKeyPresentInUserDefaults
// desc:
// last updated: 4/28/2020
// last update: cleaned up
func isKeyPresentInUserDefaults(key: String) -> Bool {
    debugPrint("CustomDate", "isKeyPresentInUserDefaults", "start", true)
    debugPrint("CustomDate", "isKeyPresentInUserDefaults", "end", true)
    return UserDefaults.standard.object(forKey: key) != nil
}


// name: setDateDefaults
// desc:
// last updated: 4/28/2020
// last update: cleaned up
func setDateDefaults() {
    debugPrint("CustomDate", "setDateDefaults", "start", true)
    if (isKeyPresentInUserDefaults(key: "lastRun") == false) {
        let defaults = UserDefaults.standard
        defaults.set(Date(), forKey: "lastRun")
    }
    debugPrint("CustomDate", "setDateDefaults", "end", true)
}


// name: getDayAsInt
// desc:
// last updated: 4/28/2020
// last update: cleaned up
func getDayAsInt(date: Date) -> Int {
    debugPrint("CustomDate", "getDayAsInt", "start", true)
    let day = Calendar.current.component(.day, from: date)
    debugPrint("CustomDate", "getDayAsInt", "end", true)
    return day
}


// name: getDayOfWeek
// desc:
// last updated: 4/28/2020
// last update: cleaned up
func getDayOfWeek(date: Date, length: String) -> String {
    debugPrint("CustomDate", "getDayOfWeek", "start", true)
//    print("date: \(date)")
    let weekDaySelected = Calendar.current.component(.weekday, from: date)
//    print("weekDaySelected: \(weekDaySelected)")
    // check if requesting full spelling
    debugPrint("CustomDate", "getDayOfWeek", "end", true)
    return (getDayOfWeekString(dayOfWeek: weekDaySelected, length: length))
}


// name: getDate
// desc:
// last updated: 4/28/2020
// last update: cleaned up
func getDate(year: Int, month: Int, day: Int) -> Date {
    debugPrint("CustomDate", "getDate", "start", true)
    let components = DateComponents(year: year, month: month, day: day, hour: 0, minute: 0, second: 0)
    let date = Calendar.current.date(from: components) ?? Date()
    debugPrint("CustomDate", "getDate", "end", true)
    return date
}


// name: getDayTh
// desc:
// last updated: 4/28/2020
// last update: cleaned up
func getDayTh(date: Date) -> String {
    debugPrint("CustomDate", "getDayTh", "start", true)
    // variables
    let day = Calendar.current.component(.day, from: date)
    // 1st, 21st, 31st
    debugPrint("CustomDate", "getDayTh", "end", true)
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


// name: getMonthAsString
// desc:
// last updated: 4/28/2020
// last update: cleaned up
func getMonthAsString(date: Date, length: String) -> String {
    debugPrint("CustomDate", "getMonthAsString", "start", true)
    let month = Calendar.current.component(.month, from: date)
    if (length == "short") {
        debugPrint("CustomDate", "getMonthAsString", "end", true)
        switch (month) {
        case 1: return ("Jan")
        case 2: return ("Feb")
        case 3: return ("Mar")
        case 4: return ("Apr")
        case 5: return ("May")
        case 6: return ("Jun")
        case 7: return ("Jul")
        case 8: return ("Aug")
        case 9: return ("Sep")
        case 10: return ("Oct")
        case 11: return ("Nov")
        case 12: return ("Dec")
        default: return ("")
        }
    }
    // else return full spelling
    else {
        debugPrint("CustomDate", "getMonthAsString", "end", true)
        switch (month) {
        case 1: return ("January")
        case 2: return ("February")
        case 3: return ("March")
        case 4: return ("April")
        case 5: return ("May")
        case 6: return ("June")
        case 7: return ("July")
        case 8: return ("August")
        case 9: return ("September")
        case 10: return ("October")
        case 11: return ("November")
        case 12: return ("December")
        default: return ("")
        }
    }
}


// name: getMonthAsInt
// desc:
// last updated: 4/28/2020
// last update: cleaned up
func getMonthAsInt(month: String) -> Int {
    debugPrint("CustomDate", "getMonthAsInt", "start", true)
    debugPrint("CustomDate", "getMonthAsInt", "end", true)
    switch (month) {
    case "Jan": return (1)
    case "Feb": return (2)
    case "Mar": return (3)
    case "Apr": return (4)
    case "May": return (5)
    case "Jun": return (6)
    case "Jul": return (7)
    case "Aug": return (8)
    case "Sep": return (9)
    case "Oct": return (10)
    case "Nov": return (11)
    case "Dec": return (12)
    default: return (1)
    }
}


// name: getDayOfWeekString
// desc:
// last updated: 4/28/2020
// last update: cleaned up
func getDayOfWeekString(dayOfWeek: Int, length: String) -> String {
    debugPrint("CustomDate", "getDayOfWeekString", "start", true)
    if (length == "long") {
        debugPrint("CustomDate", "getDayOfWeekString", "end", true)
        switch(dayOfWeek) {
        case (1): return ("Sunday")
        case (2): return ("Monday")
        case (3): return ("Tuesday")
        case (4): return ("Wednesday")
        case (5): return ("Thursday")
        case (6): return ("Friday")
        case (7): return ("Saturday")
        default: return("")
        }
    // else if short spelling
    } else if (length == "short") {
        debugPrint("CustomDate", "getDayOfWeekString", "end", true)
        switch(dayOfWeek) {
        case (1): return ("Sun")
        case (2): return ("Mon")
        case (3): return ("Tue")
        case (4): return ("Wed")
        case (5): return ("Thu")
        case (6): return ("Fri")
        case (7): return ("Sat")
        default: return("")
        }
        // else return single letter spelling "S"
    } else {
        debugPrint("CustomDate", "getDayOfWeekString", "end", true)
        switch(dayOfWeek) {
        case (1): return ("S")
        case (2): return ("M")
        case (3): return ("T")
        case (4): return ("W")
        case (5): return ("Th")
        case (6): return ("F")
        case (7): return ("S")
        default: return("")
        }
    }
}





// name: countDays
// desc:
// last updated: 4/28/2020
// last update: cleaned up
func countDays(date1: Date, date2: Date) -> Int {
    debugPrint("CustomDate", "countDays", "start", true)
    let calendar = Calendar.current
    let d1 = calendar.startOfDay(for: date1)
    let d2 = calendar.startOfDay(for: date2)
    let components = calendar.dateComponents([.day], from: d1, to: d2).day ?? 0
    debugPrint("CustomDate", "countDays", "end", true)
    return(components)
}


// name: getDateAsString
// desc:
// last updated: 4/28/2020
// last update: cleaned up
func getDateAsString(date: Date, length: String) -> String {
    debugPrint("CustomDate", "getDateAsString", "start", true)
//    if today, return 'Today'
    if (countDays(date1: Date(), date2: date) == 0) {
        debugPrint("CustomDate", "getDateAsString", "end", true)
        return "Today"
    }
    // 'Tomorrow'
    else if (countDays(date1: Date(), date2: date) == 1) {
        debugPrint("CustomDate", "getDateAsString", "end", true)
        return "Tomorrow"
    }
    // 'Yesterday'
    else if (countDays(date1: Date(), date2: date) == -1) {
        debugPrint("CustomDate", "getDateAsString", "end", true)
        return "Yesterday"
    }
    // return abbreviated length
    else {
        let tempString = "\(getMonthAsString(date: date, length: length)) \(getDayTh(date: date))"
        debugPrint("CustomDate", "getDateAsString", "end", true)
        return tempString
    }
}


// name: getStreakAsString
// desc:
// last updated: 4/28/2020
// last update: cleaned up
// get streak as string
func getStreakAsString(streak: Int) -> String {
    debugPrint("CustomDate", "getStreakAsString", "start", true)
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
    debugPrint("CustomDate", "getStreakAsString", "end", true)
    return dateString
}


// name: checkDayOfWeek
// desc:
// last updated: 4/28/2020
// last update: cleaned up
// since arrays aren't supported with sqlite
func checkDayOfWeek(dayInt: Int, dayOfWeek: Int) -> Bool {
    debugPrint("CustomDate", "checkDayOfWeek", "start", true)
    let dayString = String(dayInt)
    if (dayString.contains(String(dayOfWeek))) {
//        print("\(dayInt) contains a \(dayOfWeek)")
        debugPrint("CustomDate", "checkDayOfWeek", "end", true)
        return true
    } else {
        debugPrint("CustomDate", "checkDayOfWeek", "end", true)
        return false
    }
}


// name: getRepeatDaysString
// desc:
// last updated: 4/28/2020
// last update: cleaned up
// get Days of Week Habit repeats
func getRepeatDaysString(dayInt: Int) -> String {
    debugPrint("CustomDate", "getRepeatDaysString", "start", true)
    var repeatString = ""
    var dayOfWeek = 1, count = 1
    while (dayOfWeek <= 7) {
//        print("dayInt: \(dayInt), dayOfWeek: \(dayOfWeek)")
        if (checkDayOfWeek(dayInt: dayInt, dayOfWeek: dayOfWeek)) {
//            print("yay true")
            if (count != 1) {
                repeatString += ", "
            } else {
                repeatString += "Repeats: "
            }
            repeatString += getDayOfWeekString(dayOfWeek: dayOfWeek, length: "short")
//            print("repeatString: \(repeatString)")
            count += 1
        }
        dayOfWeek += 1
    }
//    print("return repeatString: \(repeatString)")
    debugPrint("CustomDate", "getRepeatDaysString", "end", true)
    return repeatString
}
