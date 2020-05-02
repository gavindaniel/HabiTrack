//
//  JournalDateView.swift
//  HabiTrack
//
//  Created by Gavin Daniel on 9/27/19.
//  Copyright © 2019 Gavin Daniel. All rights reserved.
//

import Foundation
import UIKit
import SQLite


// name: JournalDateCV
// desc: journal date collection view class
// last updated: 4/28/2020
// last update: cleaned up
class JournalDateCV: NSObject, UICollectionViewDelegate, UICollectionViewDataSource {
    // view objects
    var dateUICollectionView: UICollectionView
    var journalUITableView: UITableView
    var journalHabitsTV: JournalHabitsTV?
    // variables unique to this view
    var daysArray: Array<Date> = []
    var lastSelectedItem = -1
    var dateSelected = Date()
    
    var selectedCell = [IndexPath]()
    
    
    // name: init
    // desc:
    // last updated: 4/28/2020
    // last update: cleaned up
    init(_ dateUICollectionView: UICollectionView,_ journalHabitsTV: JournalHabitsTV,_ journalUITableView: UITableView) {
        debugPrint("JournalDateCV", "init", "start", true)
        self.dateUICollectionView = dateUICollectionView
        self.journalHabitsTV = journalHabitsTV
        self.journalUITableView = journalUITableView
        super.init()
        debugPrint("JournalDateCV", "init", "end", true)
    }
    
    
    // name: numberOfItemsInSection
    // desc:
    // last updated: 4/28/2020
    // last update: cleaned up
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        debugPrint("JournalDateCV", "numberOfItemsInSection", "start", true)
        // if the days array has not been initialized, create the array
        if (daysArray.count == 0) {
            updateDaysArray(Date())
        }
        debugPrint("JournalDateCV", "numberOfItemsInSection", "end", true)
        return (daysArray.count)
    }
        
    
    // name: cellForItemAt
    // desc:
    // last updated: 4/28/2020
    // last update: cleaned up
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        debugPrint("JournalDateCV", "cellForItemAt", "start", true, indexPath.row)
        // create collectionView item
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "dateCell", for: indexPath)
            as! JournalDateCVCell
        // add labels and style
        // comment/uncomment for month 'Oct' in date collection view
//        cell.monthUILabel?.text = getMonthAsString(date: daysArray[indexPath.row], length: "short")
        // comment/uncomment for day of week 'Fri' in date collection view
        let calendar = Calendar.current
        let weekday = calendar.component(.weekday, from: daysArray[indexPath.row])
        cell.monthUILabel?.text = getDayOfWeekAsString(weekday, length: "short")
        cell.dayUILabel?.text = String(getDayAsInt(date: daysArray[indexPath.row]))
        cell.layer.cornerRadius = 10.0
        cell.layer.borderWidth = 1.0
        // get today's date
        var tempDate = Date()
        // check that this isn't the initial load of the program, if not get the date from last selected.
        if (lastSelectedItem != -1) {
            let year = calendar.component(.year, from: dateSelected)
            let month = calendar.component(.month, from: dateSelected)
            let day = calendar.component(.day, from: dateSelected)
            tempDate = getDateFromComponents(day, month, year)
        }
        // get the day from either today or the last selected date.
        let tempDay = Calendar.current.component(.day, from: tempDate)
        // check if day selected, mark blue, else mark gray
        if (tempDay == getDayAsInt(date: daysArray[indexPath.row])) {
            let defaultColor = getColor("System")
            cell.layer.borderColor = defaultColor.cgColor
            cell.monthUILabel?.textColor = defaultColor
            cell.dayUILabel?.textColor = defaultColor
            // testing
            cell.layer.borderWidth = 2.0
            cell.monthUILabel?.font = UIFont.boldSystemFont(ofSize: 16.0)
            cell.dayUILabel?.font = UIFont.boldSystemFont(ofSize: 16.0)
        } else {
            // unbolds days that were previously, there was a bug where days before the day selected were bold.
            cell.monthUILabel?.font = UIFont.systemFont(ofSize: 16.0)
            cell.dayUILabel?.font = UIFont.systemFont(ofSize: 16.0)
            // testing if today, make a different shade of gray so people know which day is today if not selected.
            if (Calendar.current.component(.day, from: Date()) == Calendar.current.component(.day, from: daysArray[indexPath.row]) &&
                Calendar.current.component(.month, from: Date()) == Calendar.current.component(.month, from: daysArray[indexPath.row]) &&
                Calendar.current.component(.year, from: Date()) == Calendar.current.component(.year, from: daysArray[indexPath.row])) {
                cell.layer.borderWidth = 2.0
                if #available(iOS 13.0, *) {
                    cell.layer.borderColor = UIColor.systemGray.cgColor
                    cell.monthUILabel?.textColor = UIColor.systemGray
                    cell.dayUILabel?.textColor = UIColor.systemGray
                } else {
                    // Fallback on earlier versions
                    cell.layer.borderColor = UIColor.darkGray.cgColor
                    cell.monthUILabel?.textColor = UIColor.darkGray
                    cell.dayUILabel?.textColor = UIColor.darkGray
                }
            } else {
                if #available(iOS 13.0, *) {
                    cell.layer.borderColor = UIColor.systemGray2.cgColor
                    cell.monthUILabel?.textColor = UIColor.systemGray2
                    cell.dayUILabel?.textColor = UIColor.systemGray2
                } else {
                    // Fallback on earlier versions
                    cell.layer.borderColor = UIColor.lightGray.cgColor
                    cell.monthUILabel?.textColor = UIColor.lightGray
                    cell.dayUILabel?.textColor = UIColor.lightGray
                }
            }
        }
        debugPrint("JournalDateCV", "cellForItemAt", "end", true, indexPath.row)
        // return initialized item
        return (cell)
    }
    
    
    // name: didDeselectItemAt
    // desc:
    // last updated: 4/28/2020
    // last update: cleaned up
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        debugPrint("JournalDateCV", "didDeselectItemAt", "start", false, indexPath.row)
        if let cell: JournalDateCVCell = (collectionView.cellForItem(at: indexPath) as? JournalDateCVCell) {
            // clear the selection
            let tempDay = Calendar.current.component(.day, from: Date())
            // check if date selected, mark a different shade of gray
            if (tempDay == getDayAsInt(date: daysArray[indexPath.row])) {
                if #available(iOS 13.0, *) {
                    cell.layer.borderColor = UIColor.systemGray.cgColor
                    cell.monthUILabel?.textColor = UIColor.systemGray
                    cell.dayUILabel?.textColor = UIColor.systemGray
                } else {
                    // Fallback on earlier versions
                    cell.layer.borderColor = UIColor.darkGray.cgColor
                    cell.monthUILabel?.textColor = UIColor.darkGray
                    cell.dayUILabel?.textColor = UIColor.darkGray
                }
            } else {
                if #available(iOS 13.0, *) {
                    cell.layer.borderColor = UIColor.systemGray2.cgColor
                    cell.monthUILabel?.textColor = UIColor.systemGray2
                    cell.dayUILabel?.textColor = UIColor.systemGray2
                } else {
                    // Fallback on earlier versions
                    cell.layer.borderColor = UIColor.lightGray.cgColor
                    cell.monthUILabel?.textColor = UIColor.lightGray
                    cell.dayUILabel?.textColor = UIColor.lightGray
                }
            }
        }
        debugPrint("JournalDateCV", "didDeselectItemAt", "end", false, indexPath.row)
    }
    
    
    // name: didSelectItemAt
    // desc:
    // last updated: 4/28/2020
    // last update: cleaned up
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        debugPrint("JournalDateCV", "didSelectItemAt", "start", false, indexPath.row)
        // get the cell from the tableView
        if let cell: JournalDateCVCell = (collectionView.cellForItem(at: indexPath) as? JournalDateCVCell) {
            // if the selected item is different from the last, deselect the last item
            lastSelectedItem = indexPath.row
            let calendar = Calendar.current
            let day = Int(cell.dayUILabel?.text ?? "1") ?? 1
            let month = calendar.component(.month, from: daysArray[indexPath.row])
            let year = calendar.component(.year, from: Date())
            let date = getDateFromComponents(day, month, year)
//            print("date: \(date)")
            self.dateSelected = date
//            print("dateSelected: \(dateSelected)")
            // FIXME: replace 'days' with a calculation for number of days in the month
            // loop through cells and deselect
            var tempIndex = 0
            // check to deselect cells not selected
            while tempIndex < daysArray.count {
                if (tempIndex != lastSelectedItem) {
                    self.dateUICollectionView.deselectItem(at: IndexPath(row: tempIndex, section: 0), animated: false)
                }
                // increment index
                tempIndex += 1
            }
            // change the border fo the selected item
            let defaultColor = getColor("System")
            cell.layer.borderColor = defaultColor.cgColor
            cell.monthUILabel?.textColor = defaultColor
            cell.dayUILabel?.textColor = defaultColor
        }
        self.journalHabitsTV?.dateSelected = dateSelected
        // testing
//        self.journalTitleCV?.dateSelected = dateSelected
        updateDaysArray(dateSelected)
        self.dateUICollectionView.reloadData()
        // testing
//        self.titleUICollectionView.reloadData()
        debugPrint("JournalDateCV", "didSelectItemAt", "end", false, indexPath.row)
    }
    
    
    // name: updateDaysArray
    // desc:
    // last updated: 4/28/2020
    // last update: cleaned up
    func updateDaysArray(_ date: Date) {
        debugPrint("JournalDateCV", "updateDaysArray", "start", true)
        daysArray = []
        var index = 1
        let calendar = Calendar.current
        let dateComponents = DateComponents(year: calendar.component(.year, from: date), month: calendar.component(.month, from: date), day: 1)
        var day = calendar.date(from: dateComponents)!
//        print("start day: \(day)")
        let range = calendar.range(of: .day, in: .month, for: day)!
        let numDays = range.count
//        print(numDays) // 31
        while index <= numDays {
            daysArray.append(day)
            // increment day count
            day = Calendar.current.date(byAdding: .day, value: 1, to: day)!
//            print("\tday: \(day)")
            index += 1
        }
        self.journalUITableView.reloadData()
        debugPrint("JournalDateCV", "updateDaysArray", "end", true)
    }
    
    
    // name: updateUICollectionView
    // desc:
    // last updated: 4/28/2020
    // last update: cleaned up
    func updateUICollectionView(_ dateUICollolectionView: UICollectionView) {
        debugPrint("JournalDateCV", "updateUICollectionView", "start", false)
        dateUICollectionView = dateUICollolectionView
        debugPrint("JournalDateCV", "updateUICollectionView", "end", false)
    }
}
