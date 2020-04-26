//
//  AddHabitDateCV.swift
//  HabiTrack
//
//  Created by Gavin Daniel on 4/26/20.
//  Copyright © 2020 Gavin Daniel. All rights reserved.
//

import Foundation
import UIKit
import SQLite

class AddDateCollectionView: NSObject, UICollectionViewDelegate, UICollectionViewDataSource {
    // view objects
    var dateCollectionView: UICollectionView
    var lastSelectedItem: Int
    
    // initializer
    init(dateCollectionView: UICollectionView) {
        self.dateCollectionView = dateCollectionView
        self.lastSelectedItem = 1
        super.init()
    }
    
    // collectionView : numberOfItemsInSection
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return (7)
    }
        
    // collectionView : cellForItemAt
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        // create collectionView item
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "addHabitDateCell", for: indexPath)
            as! DateCollectionViewCell
        // add labels and style
        cell.dayUILabel?.text = getDayOfWeekString(dayOfWeek: indexPath.row, length: "short")
        cell.layer.cornerRadius = 10.0
        cell.layer.borderWidth = 1.0
        // return initialized item
        return (cell)
    }
    
    // collectionView : didDeselectItemAt
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        if let cell: DateCollectionViewCell = (collectionView.cellForItem(at: indexPath) as? DateCollectionViewCell) {
            if #available(iOS 13.0, *) {
                cell.layer.borderColor = UIColor.systemGray2.cgColor
                cell.dayUILabel?.textColor = UIColor.systemGray2
            } else {
                // Fallback on earlier versions
                cell.layer.borderColor = UIColor.lightGray.cgColor
                cell.dayUILabel?.textColor = UIColor.lightGray
            }
        }
    }
    
    // collectionView : didSelectItemAt
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        // get the cell from the tableView
        if let cell: DateCollectionViewCell = (collectionView.cellForItem(at: indexPath) as? DateCollectionViewCell) {
            // if the selected item is different from the last, deselect the last item
            lastSelectedItem = indexPath.row
            // loop through cells and deselect
            var tempIndex = 0
            // check to deselect cells not selected
            while tempIndex < 7 {
                if (tempIndex != lastSelectedItem) {
                    self.dateCollectionView.deselectItem(at: IndexPath(row: tempIndex, section: 0), animated: false)
                }
                // increment index
                tempIndex += 1
            }
            // change the border fo the selected item
            let defaultColor = getSystemColor()
            cell.layer.borderColor = defaultColor.cgColor
            cell.dayUILabel?.textColor = defaultColor
        }
        self.dateCollectionView.reloadData()
    }
    
    // custom : updateTableView
    func updateView(dateCV: UICollectionView) {
        dateCollectionView = dateCV
    }
}
