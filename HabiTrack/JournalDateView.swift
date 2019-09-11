//
//  JournalDateView.swift
//  HabiTrack
//
//  Created by Gavin Daniel on 9/9/19.
//  Copyright © 2019 Gavin Daniel. All rights reserved.
//

import Foundation
import UIKit
import SQLite

class JournalDateView: NSObject, UICollectionViewDelegate, UICollectionViewDataSource {
    
    var daysArray: Array<Date> = []
    var lastSelectedItem = -1
    var dateSelected = Date()
    
    var dateView: UICollectionView
    var habitTableView: UITableView
    var journalTableView: JournalTableView
    
//    var dateView: UICollectionView!
//    var habitTableView: UITableView!
//    var journalTableView: JournalTableView!
    
//    override init () {
//        self.dateView = UICollectionView()
//        self.journalTableView = JournalTableView()
//        self.habitTableView = UITableView()
//        super.init()
//    }

    init(dateCollectionView: UICollectionView, journalTableView: JournalTableView, habitTableView: UITableView) {
        self.dateView = dateCollectionView
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
        // create collectionView item
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "dateCell", for: indexPath)
            as! DateCollectionViewCell
        // add labels
        cell.monthUILabel?.text = getMonthAsString(date: daysArray[indexPath.row])
        cell.dayUILabel?.text = String(getDayAsInt(date: daysArray[indexPath.row]))
        cell.monthUILabel?.textColor = UIColor.gray
        cell.dayUILabel?.textColor = UIColor.gray
        cell.layer.borderWidth = 1.0
        let tempDay = Calendar.current.component(.day, from: Date())
        // check if today, mark blue, else mark gray
        if (tempDay == getDayAsInt(date: daysArray[indexPath.row])) {
            cell.layer.borderColor = UIColor.blue.cgColor
            cell.monthUILabel?.textColor = UIColor.blue
            cell.dayUILabel?.textColor = UIColor.blue
        } else {
            cell.layer.borderColor = UIColor.lightGray.cgColor
            cell.monthUILabel?.textColor = UIColor.gray
            cell.dayUILabel?.textColor = UIColor.gray
        }
        cell.layer.cornerRadius = 10.0;
        // return initialized item
        return (cell)
    }
    
    // collectionView : didDeselectItemAt
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        if let cell: DateCollectionViewCell = (collectionView.cellForItem(at: indexPath) as? DateCollectionViewCell) {
            // clear the selection
            cell.layer.borderWidth = 1.0
            cell.layer.borderColor = UIColor.lightGray.cgColor
            cell.layer.cornerRadius = 10.0;
            cell.monthUILabel?.textColor = UIColor.gray
            cell.dayUILabel?.textColor = UIColor.gray
        }
    }
    
    // collectionView : didSelectItemAt
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        //        print("Selected item: \(indexPath.row)")
        // get the cell from the tableView
        if let cell: DateCollectionViewCell = (collectionView.cellForItem(at: indexPath) as? DateCollectionViewCell) {
            // if the selected item is different from the last, deselect the last item
            if (lastSelectedItem != indexPath.row) {
                lastSelectedItem = indexPath.row
                
                let month = cell.monthUILabel?.text ?? String(Calendar.current.component(.month, from: Date()))
                let day = cell.dayUILabel?.text ?? String(Calendar.current.component(.day, from: Date()))
                let date = getDate(month: getMonthAsInt(month: month), day: Int(day) ?? Calendar.current.component(.day, from: Date()))
                dateSelected = date
                
                // FIXME: replace 'days' with a calculation for number of days in the month
                // loop through cells and deselect
                var tempIndex = 0
                while tempIndex < daysArray.count {
                    if (tempIndex != lastSelectedItem) {
                        self.dateView.deselectItem(at: IndexPath(row: tempIndex, section: 0), animated: false)
                    }
                    // increment index
                    tempIndex += 1
                }
            }
            // change the border fo the selected item
            cell.layer.borderWidth = 1.0
            cell.layer.borderColor = UIColor.blue.cgColor
            cell.layer.cornerRadius = 10.0;
            cell.monthUILabel?.textColor = UIColor.blue
            cell.dayUILabel?.textColor = UIColor.blue
        }
        //        print("reloading...")
        //        self.habitTableView.reloadData()
        // testing ...
        print("updating dateView...")
        self.journalTableView.updateDate(date: dateSelected)
        self.habitTableView.reloadData()
        //        updateDaysArray(date: dateSelected)
        //        self.dateCollectionView.reloadData()
    }
    
    // custom : updateDaysArray (init daysArray)
    func updateDaysArray(date: Date) {
        print("\t\t\tupdating days array...")
        daysArray = []
        var day = Calendar.current.date(byAdding: .day, value: -3, to: date)
        var count = -3
        while count <= 3 {
            daysArray.append(day ?? Date())
            // increment day count
            day = Calendar.current.date(byAdding: .day, value: 1, to: day ?? date)
            count += 1
        }
        print("\t\t\tupdated days array.")
    }
	
	// custom : updateTableView
	func updateDateView(dateCollectionView: UICollectionView) {
        print("\t\t\tupdating date view...")
		dateView = dateCollectionView
        print("\t\t\tupdated date.")
	}
}
