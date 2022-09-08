//
//  CustomDate.swift
//  HabiTrack
//
//  Created by Gavin Daniel on 9/4/19.
//  Copyright © 2019 Gavin Daniel. All rights reserved.
//

import Foundation

let calendar = Calendar.current
var dateArray = [Date]()
var lastSelectedCell = -1
var lastSelectedMonth = -1

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


// name: countDaysBetweenDates
// desc:
// last updated: 4/28/2020
// last update: cleaned up
func countDaysBetweenDates(_ date1: Date,_ date2: Date) -> Int {
    debugPrint("CustomDate", "countDaysBetweenDates", "start", true)
    let calendar = Calendar.current
    let d1 = calendar.startOfDay(for: date1)
    let d2 = calendar.startOfDay(for: date2)
    let components = calendar.dateComponents([.day], from: d1, to: d2).day ?? 0
    debugPrint("CustomDate", "countDaysBetweenDates", "end", true)
    return(components)
}


// name: checkDayOfWeek
// desc: since arrays aren't supported with sqlite
// last updated: 4/28/2020
// last update: cleaned up
func checkDayOfWeek(days: Int, dayOfWeek: Int) -> Bool {
    debugPrint("CustomDate", "checkDayOfWeek", "start", true)
    let dayString = String(days)
    if (dayString.contains(String(dayOfWeek))) {
//        print("\(dayInt) contains a \(dayOfWeek)")
        debugPrint("CustomDate", "checkDayOfWeek", "end", true)
        return true
    } else {
        debugPrint("CustomDate", "checkDayOfWeek", "end", true)
        return false
    }
}


//// name: updateDaysArray
//// desc:
//// last updated: 4/28/2020
//// last update: cleaned up
//func updateDateArray(_ date: Date) -> [Date] {
//    debugPrint("CustomDate", "updateDaysArray", "start", true)
//    var dateArray = [Date]()
//    let calendar = Calendar.current
//    // get first day of month of the selected date
////    let dateComponents = DateComponents(year: calendar.component(.year, from: date), month: calendar.component(.month, from: date), day: 1)
//    var tempDate = calendar.date(byAdding: .day, value: -14, to: date)!
////    let weekday = calendar.component(.weekday, from: tempDate)
////    // check if not sunday
////    if (weekday != 1) {
////        let buffer = 1 - weekday
////        tempDate = calendar.date(byAdding: .day, value: buffer, to: tempDate)!
////    }
//    print("start date: \(tempDate)")
////        let range = calendar.range(of: .day, in: .month, for: tempDate)!
////        let numDays = range.count
////        print(numDays) // 31
//    for _ in 1...7 {
//        for _ in 1...5 {
//        dateArray.append(tempDate)
//        // increment day count
//        tempDate = calendar.date(byAdding: .day, value: 1, to: tempDate)!
////            print("\tday: \(day)")
//        }
//    }
////        self.journalUITableView.reloadData()
//    debugPrint("CustomDate", "updateDaysArray", "end", true)
//    return dateArray
//}

func updateDateArray(_ date: Date) -> [Date] {
    debugPrint("CustomDate", "updateDaysArray", "start", true)
    let calendar = Calendar.current
    if (lastSelectedMonth != calendar.component(.month, from: date)) {
        var tempDateArray = [Date]()
        var indexSelected = -1
        // get first day of month of the selected date
        let dateComponents = DateComponents(year: calendar.component(.year, from: date), month: calendar.component(.month, from: date), day: 1)
        var tempDate = calendar.date(from: dateComponents)!
        let weekday = calendar.component(.weekday, from: date)
        let buffer = 1 - weekday
        tempDate = calendar.date(byAdding: .day, value: buffer, to: tempDate)!
        var index = 1
        for _ in 1...8 {
            for _ in 1...5 {
            tempDateArray.append(tempDate)
            // increment day count
            tempDate = calendar.date(byAdding: .day, value: 1, to: tempDate)!
    //            print("\tday: \(day)")
                if (tempDate == date) {
                    indexSelected = index + 3
                    print("fa;sdlfkja;dslkfja;sdlkfja;lkdsfja;ldskjf;aldfkjs")
//                    DataManager.shared.journalVC.lastSelectedItem = indexSelected
                }
            index += 1
            }
        }
        lastSelectedMonth = calendar.component(.month, from: date)
        DataManager.shared.journalVC.dateUICollectionView.scrollToItem(at:IndexPath(item: indexSelected, section: 0), at: .right, animated: false)
//        DataManager.shared.journalVC.dateUICollectionView.scrollToItem(at:IndexPath(item: DataManager.shared.journalVC.lastSelectedItem, section: 0), at: .right, animated: false)
        
        debugPrint("CustomDate", "updateDaysArray", "end", true)
        return tempDateArray
    }
//        self.journalUITableView.reloadData()
    
    
    
    debugPrint("CustomDate", "updateDaysArray", "end", true)
    return dateArray
}


//func updateDateArray(_ date: Date) -> [Date] {
//    debugPrint("CustomDate", "updateDaysArray", "start", true)
//    var dateArray = [Date]()
//    let calendar = Calendar.current
//    // get first day of month of the selected date
//    let dateComponents = DateComponents(year: calendar.component(.year, from: date), month: calendar.component(.month, from: date), day: 1)
//    var tempDate = calendar.date(from: dateComponents)!
//    let weekday = calendar.component(.weekday, from: tempDate)
//    // check if not sunday
//    if (weekday != 1) {
//        let buffer = 1 - weekday
//        tempDate = calendar.date(byAdding: .day, value: buffer, to: tempDate)!
//    }
//    print("start date: \(tempDate)")
////        let range = calendar.range(of: .day, in: .month, for: tempDate)!
////        let numDays = range.count
////        print(numDays) // 31
//    for _ in 1...7 {
//        for _ in 1...5 {
//        dateArray.append(tempDate)
//        // increment day count
//        tempDate = calendar.date(byAdding: .day, value: 1, to: tempDate)!
////            print("\tday: \(day)")
//        }
//    }
////        self.journalUITableView.reloadData()
//    debugPrint("CustomDate", "updateDaysArray", "end", true)
//    return dateArray
//}


// name:
// desc:
// last updated: 4/29/2020
// last update: new
func checkDateBeforeStart(date: Date, startDate: Date) -> Bool {
    return false
}


// name: getDayIntFromDate
// desc:
// last updated: 5/16/2020
// last update: refactored
func getDay(_ date: Date) -> Int {
    debugPrint("CustomDate", "getDayIntFromDate", "start", true)
    let day = Calendar.current.component(.day, from: date)
    debugPrint("CustomDate", "getDayIntFromDate", "end", true)
    return day
}


// name: getMonthIntFromDate
// desc:
// last updated: 4/28/2020
// last update: cleaned up
func getMonth(_ date: Date) -> Int {
    debugPrint("CustomDate", "getMonthIntFromDate", "start", true)
    let month = Calendar.current.component(.month, from: date)
    debugPrint("CustomDate", "getMonthIntFromDate", "end", true)
    return month
}


// name: getDayTh
// desc:
// last updated: 4/28/2020
// last update: cleaned up
func getDayOfMonthSuffix(_ date: Date) -> String {
    debugPrint("CustomDate", "getDayTh", "start", true)
    // variables
    let day = getDay(date)
    if (day >= 11 && day <= 13) {
        return "th";
    }
    switch (day % 10) {
        case 1:  return "st";
        case 2:  return "nd";
        case 3:  return "rd";
        default: return "th";
    }
}


// name: getDateAsString
// desc:
// last updated: 4/28/2020
// last update: cleaned up
func getDateAsString(_ date: Date, length: String) -> String {
    debugPrint("CustomDate", "getDateAsString", "start", true)
//    if today, return 'Today'
    if (countDaysBetweenDates(Date(), date) == 0) {
        debugPrint("CustomDate", "getDateAsString", "end", true)
        return "Today"
    }
    // 'Tomorrow'
    else if (countDaysBetweenDates(Date(), date) == 1) {
        debugPrint("CustomDate", "getDateAsString", "end", true)
        return "Tomorrow"
    }
    // 'Yesterday'
    else if (countDaysBetweenDates(Date(), date) == -1) {
        debugPrint("CustomDate", "getDateAsString", "end", true)
        return "Yesterday"
    }
    // return abbreviated length
    else {
        let tempString = "\(getMonthAsString(date: date, length: length)) \(getDayOfMonthSuffix(date))"
        debugPrint("CustomDate", "getDateAsString", "end", true)
        return tempString
    }
}


// name: getStreakAsString
// desc: get streak as string
// last updated: 4/28/2020
// last update: cleaned up
func getStreakAsString(_ streak: Int) -> String {
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


// name: getRepeatDaysAsString
// desc: get Days of Week Habit repeats
// last updated: 4/29/2020
// last update: renamed
func getRepeatDaysAsString(_ days: Int) -> String {
    debugPrint("CustomDate", "getRepeatDaysAsString", "start", true)
    var repeatString = ""
    var dayOfWeek = 1, count = 1
    while (dayOfWeek <= 7) {
//        print("dayInt: \(dayInt), dayOfWeek: \(dayOfWeek)")
        if (checkDayOfWeek(days: days, dayOfWeek: dayOfWeek)) {
//            print("yay true")
            if (count != 1) {
                repeatString += ", "
            } else {
                repeatString += "Repeats: "
            }
            repeatString += getWeekdayAsString(dayOfWeek, length: "short")
//            print("repeatString: \(repeatString)")
            count += 1
        }
        dayOfWeek += 1
    }
//    print("return repeatString: \(repeatString)")
    debugPrint("CustomDate", "getRepeatDaysString", "end", true)
    return repeatString
}


// name: getDateFromString
// desc: get date from a string
// last updated: 4/29/2020
// last update: new
func getDateFromString(_ dateString: String) -> Date {
    debugPrint("CustomDate", "getDateFromString", "start", false)
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "dd/MM/yyyy" //Your date format
    dateFormatter.timeZone = TimeZone(abbreviation: "GMT+0:00") //Current time zone
    //according to date format your date string
    guard let date = dateFormatter.date(from: dateString) else {
        fatalError()
    }
    print("\t\(date)") //Convert String to Date
    debugPrint("CustomDate", "getDateFromString", "end", false)
    return date
}


// name: getDayOfWeekAsString
// desc:
// last updated: 4/28/2020
// last update: cleaned up
//func getDayOfWeekAsString(date: Date, length: String) -> String {
//    debugPrint("CustomDate", "getDayOfWeekAsString", "start", true)
//    let weekDaySelected = Calendar.current.component(.weekday, from: date)
//    debugPrint("CustomDate", "getDayOfWeekAsString", "end", true)
//    return (getDayOfWeekString(dayOfWeek: weekDaySelected, length: length))
//}


// name: getDateFromComponents
// desc:
// last updated: 5/16/2020
// last update: cleaned up
func getDateFromComponents(_ day: Int,_ month: Int,_ year: Int) -> Date {
    debugPrint("CustomDate", "getDateFromComponents", "start", true)
    let components = DateComponents(year: year, month: month, day: day, hour: 0, minute: 0, second: 0)
    let date = Calendar.current.date(from: components) ?? Date()
    debugPrint("CustomDate", "getDateFromComponents", "end", true)
    return date
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


// name: getMonthFromString
// desc:
// last updated: 4/28/2020
// last update: cleaned up
func getMonthFromString(month: String) -> Int {
    debugPrint("CustomDate", "getMonthFromString", "start", true)
    debugPrint("CustomDate", "getMonthFromString", "end", true)
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


// name: getWeekdayAsString
// desc:
// last updated: 4/28/2020
// last update: cleaned up
func getWeekdayAsString(_ dayOfWeek: Int, length: String) -> String {
    debugPrint("CustomDate", "getWeekdayAsString", "start", true)
    if (length == "long") {
        debugPrint("CustomDate", "getWeekdayAsString", "end", true)
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
        debugPrint("CustomDate", "getWeekdayAsString", "end", true)
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
        debugPrint("CustomDate", "getWeekdayAsString", "end", true)
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
