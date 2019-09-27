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

class JournalDateView: NSObject, UICollectionViewDelegate, UICollectionViewDataSource {

    var dateCollectionView: UICollectionView
    var habitTableView: UITableView
    var journalTableView: JournalTableView?
    
    var daysArray: Array<Date> = []
    var lastSelectedItem = -1
    var dateSelected = Date()
    
    init(dateCollectionView: UICollectionView, journalTableView: JournalTableView, habitTableView: UITableView) {
        self.dateCollectionView = dateCollectionView
        self.journalTableView = journalTableView
        self.habitTableView = habitTableView
        super.init()
    }

    // collectionView : numberOfItemsInSection
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // if the days array has not been initialized, create the array
        if (daysArray.count == 0) {
            updateDaysArray(date: Date())
        }
        return (daysArray.count)
    }
        
    // collectionView : cellForItemAt
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//        print("cellForItemAt... indexPath: \(indexPath.row)")
        // create collectionView item
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "dateCell", for: indexPath)
            as! DateCollectionViewCell
        // add labels
        cell.monthUILabel?.text = getMonthAsString(date: daysArray[indexPath.row])
        cell.dayUILabel?.text = String(getDayAsInt(date: daysArray[indexPath.row]))
//        cell.monthUILabel?.textColor = UIColor.gray
//        cell.dayUILabel?.textColor = UIColor.gray
//        cell.layer.borderWidth = 1.0
        
        var tempDate = Date()
        
        if (lastSelectedItem != -1) {
            let month = Calendar.current.component(.month, from: dateSelected)
            let day = Calendar.current.component(.day, from: dateSelected)
            tempDate = getDate(month: month, day: day)
        }

        let tempDay = Calendar.current.component(.day, from: tempDate)
        
        // check if day selected, mark blue, else mark gray
        if (tempDay == getDayAsInt(date: daysArray[indexPath.row])) {
//            print("tempDay: \(tempDay) == daysArray: \(getDayAsInt(date: daysArray[indexPath.row]))")
            cell.layer.borderColor = UIColor.systemBlue.cgColor
            cell.monthUILabel?.textColor = UIColor.systemBlue
            cell.dayUILabel?.textColor = UIColor.systemBlue
        } else {
            // testing if today, mark black so people know which day is today
            if (Calendar.current.component(.day, from: Date()) == getDayAsInt(date: daysArray[indexPath.row])) {
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
        cell.layer.cornerRadius = 10.0
        cell.layer.borderWidth = 1.0
        // return initialized item
        return (cell)
    }
    
    // collectionView : didDeselectItemAt
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        if let cell: DateCollectionViewCell = (collectionView.cellForItem(at: indexPath) as? DateCollectionViewCell) {
            // clear the selection
            
//            cell.layer.cornerRadius = 10.0
//            cell.layer.borderWidth = 1.0
            
            // testing
            let tempDay = Calendar.current.component(.day, from: Date())
            
            // check if today, mark blue, else mark gray
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
    }
    
    // collectionView : didSelectItemAt
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//        print("Selected item: \(indexPath.row)")
        // get the cell from the tableView
        if let cell: DateCollectionViewCell = (collectionView.cellForItem(at: indexPath) as? DateCollectionViewCell) {
            // if the selected item is different from the last, deselect the last item
//            print("lastSelectedItem: \(lastSelectedItem) != indexPath.row: \(indexPath.row)")
//            if (lastSelectedItem != indexPath.row) {
                lastSelectedItem = indexPath.row
                
                let month = cell.monthUILabel?.text ?? String(Calendar.current.component(.month, from: Date()))
                let day = cell.dayUILabel?.text ?? String(Calendar.current.component(.day, from: Date()))
                let date = getDate(month: getMonthAsInt(month: month), day: Int(day) ?? Calendar.current.component(.day, from: Date()))
                dateSelected = date
                print("dateSelected: \(dateSelected)")
                // FIXME: replace 'days' with a calculation for number of days in the month
                // loop through cells and deselect
                var tempIndex = 0
                while tempIndex < daysArray.count {
                    if (tempIndex != lastSelectedItem) {
                        self.dateCollectionView.deselectItem(at: IndexPath(row: tempIndex, section: 0), animated: false)
                    }
                    // increment index
                    tempIndex += 1
                }
//            }
            // change the border fo the selected item
            cell.layer.borderColor = UIColor.blue.cgColor
            cell.monthUILabel?.textColor = UIColor.blue
            cell.dayUILabel?.textColor = UIColor.blue
        }
        self.habitTableView.reloadData()
        // testing ...
        updateDaysArray(date: dateSelected)
        self.dateCollectionView.reloadData()
    }
    
    // custom : updateDaysArray (init daysArray)
    func updateDaysArray(date: Date) {
        daysArray = []
        var count = -3
        let max_count = 3
        var day = Calendar.current.date(byAdding: .day, value: count, to: date)
        
        while count <= max_count {
            daysArray.append(day ?? Date())
            // increment day count
            day = Calendar.current.date(byAdding: .day, value: 1, to: day ?? date)
            count += 1
        }
        self.habitTableView.reloadData()
    }
    
    // custom : updateTableView
    func updateDateView(dateView: UICollectionView) {
        print("\t\t\tupdating date view...")
        dateCollectionView = dateView
        print("\t\t\tupdated date.")
    }
}
