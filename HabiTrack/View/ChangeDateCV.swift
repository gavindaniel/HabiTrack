//
//  ChangeDateCV.swift
//  HabiTrack
//
//  Created by Gavin Daniel on 5/1/20.
//  Copyright © 2020 Gavin Daniel. All rights reserved.
//

import Foundation
import UIKit
import SQLite


// name: ChangeDateCV
// desc: add date collection view class
// last updated: 4/28/2020
// last update: cleaned up
class ChangeDateCV: NSObject, UICollectionViewDelegate, UICollectionViewDataSource {
    // variables
    var dateUICollectionView: UICollectionView
    var lastSelectedItem: Int
    var selectedCells = [IndexPath]()
    var daysArray: Array<Date> = []
//    var dateSelected = Date()
    
    
    
    // name: init
    // desc:
    // last updated: 4/28/2020
    // last update: cleaned up
    init(_ dateUICollectionView: UICollectionView) {
        debugPrint("ChangeDateCV", "init", "start", false)
        self.dateUICollectionView = dateUICollectionView
        self.lastSelectedItem = -1
        super.init()
        debugPrint("ChangeDateCV", "init", "end", false)
    }
    
    
    // name: numberOfItemsInSection
    // desc:
    // last updated: 4/28/2020
    // last update: cleaned up
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        debugPrint("ChangeDateCV", "numberOfItemsInSection", "start", false)
        
//        var index = 1
        var date = Date()
        let calendar = Calendar.current
        let dateComponents = DateComponents(year: calendar.component(.year, from: date), month: calendar.component(.month, from: date), day: 1)
        date = calendar.date(from: dateComponents)!
        let range = calendar.range(of: .day, in: .month, for: date)!
        let numDays = range.count
        
        daysArray = updateDaysArray(date)
//        print(numDays) // 31
        debugPrint("ChangeDateCV", "numberOfItemsInSection", "end", false)
//        return (7)
        return numDays
    }
    
    
    // name: cellForItemAt
    // desc:
    // last updated: 4/28/2020
    // last update: cleaned up
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        debugPrint("ChangeDateCV", "cellForItemAt", "start", false, indexPath.row)
        print("\t\tdateSelected: \(dateSelected)")
        // create collectionView item
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "changeDateCell", for: indexPath)
            as! ChangeDateCVCell
        let calendar = Calendar.current
        let weekday = calendar.component(.weekday, from: daysArray[indexPath.row])
        // add labels and style
        cell.dowUILabel?.text = getDayOfWeekAsString(weekday, length: "short")
        cell.dayUILabel?.text = String(getDayAsInt(date: daysArray[indexPath.row]))
        cell.layer.cornerRadius = 10.0
        cell.layer.borderWidth = 1.0
        
        // get the day from either today or the last selected date.
        let day = Calendar.current.component(.day, from: dateSelected)
        // check if day selected, mark blue, else mark gray
        if (day == getDayAsInt(date: daysArray[indexPath.row])) {
//        if selectedCells.contains(indexPath) {
            print("\t\t\tmatching dateSelected: \(dateSelected)")
            let defaultColor = getColor("System")
            cell.layer.borderColor = defaultColor.cgColor
            cell.dowUILabel?.textColor = defaultColor
            cell.dayUILabel?.textColor = defaultColor
            // testing
            cell.layer.borderWidth = 2.0
            cell.dowUILabel?.font = UIFont.boldSystemFont(ofSize: 16.0)
            cell.dayUILabel?.font = UIFont.boldSystemFont(ofSize: 16.0)
        } else {
            // unbolds days that were previously, there was a bug where days before the day selected were bold.
            cell.dowUILabel?.font = UIFont.systemFont(ofSize: 16.0)
            cell.dayUILabel?.font = UIFont.systemFont(ofSize: 16.0)
            // testing if today, make a different shade of gray so people know which day is today if not selected.
            if (Calendar.current.component(.day, from: Date()) == Calendar.current.component(.day, from: daysArray[indexPath.row]) &&
                Calendar.current.component(.month, from: Date()) == Calendar.current.component(.month, from: daysArray[indexPath.row]) &&
                Calendar.current.component(.year, from: Date()) == Calendar.current.component(.year, from: daysArray[indexPath.row])) {
                cell.layer.borderWidth = 2.0
                if #available(iOS 13.0, *) {
                    cell.layer.borderColor = UIColor.systemGray.cgColor
                    cell.dowUILabel?.textColor = UIColor.systemGray
                    cell.dayUILabel?.textColor = UIColor.systemGray
                } else {
                    // Fallback on earlier versions
                    cell.layer.borderColor = UIColor.darkGray.cgColor
                    cell.dowUILabel?.textColor = UIColor.darkGray
                    cell.dayUILabel?.textColor = UIColor.darkGray
                }
            } else {
                if #available(iOS 13.0, *) {
                    cell.layer.borderColor = UIColor.systemGray2.cgColor
                    cell.dowUILabel?.textColor = UIColor.systemGray2
                    cell.dayUILabel?.textColor = UIColor.systemGray2
                } else {
                    // Fallback on earlier versions
                    cell.layer.borderColor = UIColor.lightGray.cgColor
                    cell.dowUILabel?.textColor = UIColor.lightGray
                    cell.dayUILabel?.textColor = UIColor.lightGray
                }
            }
        }
        // return initialized item
        debugPrint("ChangeDateCV", "cellForItemAt", "end", true, indexPath.row)
        return (cell)
    }
    
    
    // name: didSelectItemAt
    // desc:
    // last updated: 4/28/2020
    // last update: cleaned up
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        debugPrint("JournalDateCV", "didSelectItemAt", "start", true, indexPath.row)
        // get the cell from the tableView
        if let cell: ChangeDateCVCell = (collectionView.cellForItem(at: indexPath) as? ChangeDateCVCell) {
            // if the selected item is different from the last, deselect the last item
            lastSelectedItem = indexPath.row
            let calendar = Calendar.current
            let day = Int(cell.dayUILabel?.text ?? "1") ?? 1
            let month = calendar.component(.month, from: daysArray[indexPath.row])
            let year = calendar.component(.year, from: Date())
            let date = getDateFromComponents(day, month, year)
    //            print("date: \(date)")
            dateSelected = date
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
            cell.dowUILabel?.textColor = defaultColor
            cell.dayUILabel?.textColor = defaultColor
        }
//        self.journalHabitsTV?.dateSelected = dateSelected
        // testing
    //        self.journalTitleCV?.dateSelected = dateSelected
        daysArray = updateDaysArray(dateSelected)
        print("\t\tdateSelected: \(dateSelected)")
        self.dateUICollectionView.reloadData()
        // testing
    //        self.titleUICollectionView.reloadData()
        debugPrint("JournalDateCV", "didSelectItemAt", "end", true, indexPath.row)
    }
        
        
    // name: updateUICollectionView
    // desc:
    // last updated: 4/28/2020
    // last update: cleaned up
    func updateUICollectionView(_ dateUICollolectionView: UICollectionView) {
        debugPrint("ChangeDateCV", "updateUICollectionView", "start", false)
        dateUICollectionView = dateUICollolectionView
        debugPrint("ChangeDateCV", "updateUICollectionView", "end", false)
    }
}
