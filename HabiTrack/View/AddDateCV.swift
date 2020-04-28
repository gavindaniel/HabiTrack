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
    
    var selectedCells = [IndexPath]()
    
    // initializer
    init(dateCollectionView: UICollectionView) {
        self.dateCollectionView = dateCollectionView
        self.lastSelectedItem = -1
        super.init()
    }
    
    // collectionView : numberOfItemsInSection
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        print()
//        print("AddDateCV : numberOfItemsInSection...")
//        print()
        return (7)
    }
        
    // collectionView : cellForItemAt
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//        print()
//        print("AddDateCV : cellForItemAt...\(indexPath.row)")
//        print()
        // create collectionView item
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "addHabitDateCell", for: indexPath)
            as! AddDateCollectionViewCell
        // add labels and style
        cell.dayUILabel?.text = getDayOfWeekString(dayOfWeek: (indexPath.row)+1, length: "short")
        cell.layer.cornerRadius = 10.0
        cell.layer.borderWidth = 1.0
    
        // check if day selected, mark blue, else mark gray
        if selectedCells.contains(indexPath) {
            let defaultColor = getSystemColor()
            cell.layer.borderColor = defaultColor.cgColor
            cell.dayUILabel?.textColor = defaultColor
            // testing
            cell.layer.borderWidth = 2.0
            cell.dayUILabel?.font = UIFont.boldSystemFont(ofSize: 16.0)
        } else {
            // unbolds days that were previously, there was a bug where days before the day selected were bold.
            cell.dayUILabel?.font = UIFont.systemFont(ofSize: 16.0)
            if #available(iOS 13.0, *) {
                cell.layer.borderColor = UIColor.systemGray2.cgColor
                cell.dayUILabel?.textColor = UIColor.systemGray2
            } else {
                // Fallback on earlier versions
                cell.layer.borderColor = UIColor.lightGray.cgColor
                cell.dayUILabel?.textColor = UIColor.lightGray
            }
            // testing if today, make a different shade of gray so people know which day is today if not selected.
        }
        // return initialized item
        return (cell)
    }
    
    // collectionView : didDeselectItemAt
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        print()
        print("AddDateCV : didDeselectItemAt...")
        if let cell: AddDateCollectionViewCell = (collectionView.cellForItem(at: indexPath) as? AddDateCollectionViewCell) {
            // clear the selection
            if selectedCells.contains(indexPath) {
                selectedCells.remove(at: selectedCells.firstIndex(of: indexPath)!)
                // check if date selected, mark a different shade of gray
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
    }
    
    // collectionView : didSelectItemAt
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("AddDateCV : didSelectItemAt...\(indexPath.row)")
        // get the cell from the tableView
        if let cell: AddDateCollectionViewCell = (collectionView.cellForItem(at: indexPath) as? AddDateCollectionViewCell) {
            if selectedCells.contains(indexPath) {
                selectedCells.remove(at: selectedCells.firstIndex(of: indexPath)!)
                // check if date selected, mark a different shade of gray
                if #available(iOS 13.0, *) {
                    cell.layer.borderColor = UIColor.systemGray2.cgColor
                    cell.dayUILabel?.textColor = UIColor.systemGray2
                } else {
                    // Fallback on earlier versions
                    cell.layer.borderColor = UIColor.lightGray.cgColor
                    cell.dayUILabel?.textColor = UIColor.lightGray
                }
            } else {
                // if the selected item is different from the last, deselect the last item
                selectedCells.append(indexPath)
                print("# selectedCells : \(selectedCells.count)")
//                self.dateCollectionView.reloadData()
                print("# indexPathsForSelectedItems : \(self.dateCollectionView.indexPathsForSelectedItems?.count ?? -1)")
                // change the border fo the selected item
                let defaultColor = getSystemColor()
                cell.layer.borderColor = defaultColor.cgColor
                cell.dayUILabel?.textColor = defaultColor
            }
            self.dateCollectionView.reloadData()
        }
    }
    
    // custom : updateTableView
    func updateView(dateCV: UICollectionView) {
        dateCollectionView = dateCV
    }
    
    func getNumDaysSelected() -> Int {
        return selectedCells.count
    }
    
    func getDaysSelected() -> [IndexPath] {
        return selectedCells
    }
}
