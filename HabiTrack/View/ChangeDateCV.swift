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
    var dateArray = [Date]()
    var tempDateSelected = dateSelected
    
    
    
    // name: init
    // desc:
    // last updated: 4/28/2020
    // last update: cleaned up
    init(_ dateUICollectionView: UICollectionView) {
        self.dateUICollectionView = dateUICollectionView
        self.lastSelectedItem = -1
        super.init()
    }
    
    
    // name: numberOfItemsInSection
    // desc:
    // last updated: 4/28/2020
    // last update: cleaned up
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        dateArray = updateDateArray(dateSelected)
        return dateArray.count
    }
    
    
    // name: cellForItemAt
    // desc:
    // last updated: 4/28/2020
    // last update: cleaned up
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        // create collectionView item
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "changeDateCell", for: indexPath)
            as! ChangeDateCVCell
        let calendar = Calendar.current
        let weekday = calendar.component(.weekday, from: dateArray[indexPath.row])
        // add labels and style
        cell.dowUILabel?.text = getWeekdayAsString(weekday, length: "short")
        cell.dayUILabel?.text = String(getDay(dateArray[indexPath.row]))
        cell.layer.cornerRadius = 10.0
        cell.layer.borderWidth = 1.0
        // get the day from either today or the last selected date.
        let day = calendar.component(.day, from: tempDateSelected)
        let month = calendar.component(.month, from: tempDateSelected)
        // check if day selected, mark blue, else mark gray
        if (day == getDay(dateArray[indexPath.row]) && month == getMonth(dateArray[indexPath.row])) {
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
            if (calendar.component(.day, from: Date()) == calendar.component(.day, from: dateArray[indexPath.row]) &&
                calendar.component(.month, from: Date()) == calendar.component(.month, from: dateArray[indexPath.row]) &&
                calendar.component(.year, from: Date()) == calendar.component(.year, from: dateArray[indexPath.row])) {
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
                if (month == getMonth(dateArray[indexPath.row])) {
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
                } else {
                    if #available(iOS 13.0, *) {
                        cell.layer.borderColor = UIColor.systemGray5.cgColor
                        cell.dowUILabel?.textColor = UIColor.systemGray5
                        cell.dayUILabel?.textColor = UIColor.systemGray5
                    } else {
                        // Fallback on earlier versions
                        cell.layer.borderColor = UIColor.lightGray.cgColor
                        cell.dowUILabel?.textColor = UIColor.lightGray
                        cell.dayUILabel?.textColor = UIColor.lightGray
                    }
                }
            }
        }
        // return initialized item
        return (cell)
    }
    
    
    // name: didSelectItemAt
    // desc:
    // last updated: 4/28/2020
    // last update: cleaned up
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        // get the cell from the tableView
        if let cell: ChangeDateCVCell = (collectionView.cellForItem(at: indexPath) as? ChangeDateCVCell) {
            // if the selected item is different from the last, deselect the last item
            lastSelectedItem = indexPath.row
            let calendar = Calendar.current
            let day = Int(cell.dayUILabel?.text ?? "1") ?? 1
            let month = calendar.component(.month, from: dateArray[indexPath.row])
            let year = calendar.component(.year, from: Date())
            let date = getDateFromComponents(day, month, year)
            tempDateSelected = date// loop through cells and deselect
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
            cell.dowUILabel?.textColor = defaultColor
            cell.dayUILabel?.textColor = defaultColor
        }
        dateArray = updateDateArray(tempDateSelected)
        self.dateUICollectionView.reloadData()
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
