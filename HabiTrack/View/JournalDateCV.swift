//
//  JournalDateView.swift
//  HabiTrack
//
//  Created by Gavin Daniel on 9/27/19.
//  Copyright © 2019 Gavin Daniel. All rights reserved.
//

import Foundation
import UIKit
import CoreData


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
//    var dateArray = [Date]()
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
        if (dateArray.count == 0) {
            dateArray = updateDateArray(Date())
            self.journalUITableView.reloadData()
        }
        debugPrint("JournalDateCV", "numberOfItemsInSection", "end", true)
        return (dateArray.count)
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
//        cell.monthUILabel?.text = getMonthAsString(date: dateArray[indexPath.row], length: "short")
        // comment/uncomment for day of week 'Fri' in date collection view
        let calendar = Calendar.current
        let weekday = calendar.component(.weekday, from: dateArray[indexPath.row])
        cell.monthUILabel?.text = getWeekdayAsString(weekday, length: "short")
        cell.dayUILabel?.text = String(getDay(dateArray[indexPath.row]))
        cell.layer.cornerRadius = 10.0
        cell.layer.borderWidth = 1.0
        // get the day from either today or the last selected date.
        let day = calendar.component(.day, from: dateSelected)
        let month = calendar.component(.month, from: dateSelected)
        // check if day selected, mark blue, else mark gray
        if (day == getDay(dateArray[indexPath.row]) && month == getMonth(dateArray[indexPath.row])) {
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
            if (calendar.component(.day, from: Date()) == calendar.component(.day, from: dateArray[indexPath.row]) &&
                calendar.component(.month, from: Date()) == calendar.component(.month, from: dateArray[indexPath.row]) &&
                calendar.component(.year, from: Date()) == calendar.component(.year, from: dateArray[indexPath.row])) {
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
                if (month == getMonth(dateArray[indexPath.row])) {
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
                } else {
                    if #available(iOS 13.0, *) {
                        cell.layer.borderColor = UIColor.systemGray5.cgColor
                        cell.monthUILabel?.textColor = UIColor.systemGray5
                        cell.dayUILabel?.textColor = UIColor.systemGray5
                    } else {
                        // Fallback on earlier versions
                        cell.layer.borderColor = UIColor.lightGray.cgColor
                        cell.monthUILabel?.textColor = UIColor.lightGray
                        cell.dayUILabel?.textColor = UIColor.lightGray
                    }
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
        debugPrint("JournalDateCV", "didDeselectItemAt", "start", true, indexPath.row)
        if let cell: JournalDateCVCell = (collectionView.cellForItem(at: indexPath) as? JournalDateCVCell) {
            // clear the selection
            let tempDay = Calendar.current.component(.day, from: Date())
            // check if date selected, mark a different shade of gray
            if (tempDay == getDay(dateArray[indexPath.row])) {
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
        debugPrint("JournalDateCV", "didDeselectItemAt", "end", true, indexPath.row)
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
            print("lastSelectedCell: \(lastSelectedCell)")
            print("indexPath.row: \(indexPath.row)")
//            if (lastSelectedCell != indexPath.row) {
            let calendar = Calendar.current
            print("dateSelected: \(dateSelected)")
            print("\(calendar.component(.month, from: dateArray[indexPath.row]))")
            print("\t\(calendar.component(.month, from: dateSelected))")
            print()
            print("\(calendar.component(.day, from: dateArray[indexPath.row]))")
            print("\t\(calendar.component(.day, from: dateSelected))")
            if (calendar.component(.month, from: dateArray[indexPath.row]) != calendar.component(.month, from: dateSelected) ||
                calendar.component(.day, from: dateArray[indexPath.row]) != calendar.component(.day, from: dateSelected)) {
                print("work please")
                let lastSelectedItem = indexPath.row
                lastSelectedCell = lastSelectedItem
                let calendar = Calendar.current
                let day = Int(cell.dayUILabel?.text ?? "1") ?? 1
                let month = calendar.component(.month, from: dateArray[indexPath.row])
                let year = calendar.component(.year, from: Date())
                let date = getDateFromComponents(day, month, year)
//                dateSelected = date
                // loop through cells and deselect
                var tempIndex = 0
                // check to deselect cells not selected
                while tempIndex < dateArray.count {
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
    //        dateArray = updateDateArray(dateSelected)
                print("\tupdate plz")
                dateArray = updateDateArray(date)
                DataManager.shared.journalVC.updateDateButton(date)
                DataManager.shared.journalVC.dateUICollectionView.reloadData()
                DataManager.shared.journalVC.journalUITableView.reloadData()
                dateSelected = date
            }
        }
        debugPrint("JournalDateCV", "didSelectItemAt", "end", false, indexPath.row)
    }
    
    
    // name: updateUICollectionView
    // desc:
    // last updated: 4/28/2020
    // last update: cleaned up
    func updateUICollectionView(_ dateUICollolectionView: UICollectionView) {
        debugPrint("JournalDateCV", "updateUICollectionView", "start", true)
        dateUICollectionView = dateUICollolectionView
        debugPrint("JournalDateCV", "updateUICollectionView", "end", true)
    }
}
