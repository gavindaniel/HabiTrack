//
//  AddDateCV.swift
//  HabiTrack
//
//  Created by Gavin Daniel on 4/26/20.
//  Copyright © 2020 Gavin Daniel. All rights reserved.
//

import Foundation
import UIKit
import CoreData


// name: HabitDateCV
// desc: add date collection view class
// last updated: 4/28/2020
// last update: cleaned up
class HabitDateCV: NSObject, UICollectionViewDelegate, UICollectionViewDataSource {
    // variables
    var dateUICollectionView: UICollectionView
    var lastSelectedItem: Int
    var selectedCells = [IndexPath]()
    
    
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
        debugPrint("HabitDateCV", "numberOfItemsInSection", "start", true)
        debugPrint("HabitDateCV", "numberOfItemsInSection", "end", true)
        return (7)
    }
        
    
    // name: cellForItemAt
    // desc:
    // last updated: 4/28/2020
    // last update: cleaned up
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        debugPrint("HabitDateCV", "cellForItemAt", "start", true, indexPath.row)
        // create collectionView item
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "WeekCell", for: indexPath)
            as! WeekCell
        // add labels and style
        cell.day?.text = getWeekdayAsString((indexPath.row)+1, length: "short")
        cell.layer.cornerRadius = 10.0
        cell.layer.borderWidth = 1.0
        // check if day selected, mark blue, else mark gray
        if selectedCells.contains(indexPath) {
            let defaultColor = getColor("System")
            cell.layer.borderColor = defaultColor.cgColor
            cell.day?.textColor = defaultColor
            // testing
            cell.layer.borderWidth = 2.0
            cell.day?.font = UIFont.boldSystemFont(ofSize: 16.0)
        } else {
            // unbolds days that were previously, there was a bug where days before the day selected were bold.
            cell.day?.font = UIFont.systemFont(ofSize: 16.0)
            if #available(iOS 13.0, *) {
                cell.layer.borderColor = UIColor.systemGray2.cgColor
                cell.day?.textColor = UIColor.systemGray2
            } else {
                // Fallback on earlier versions
                cell.layer.borderColor = UIColor.lightGray.cgColor
                cell.day?.textColor = UIColor.lightGray
            }
            // testing if today, make a different shade of gray so people know which day is today if not selected.
        }
        // return initialized item
        debugPrint("HabitDateCV", "cellForItemAt", "end", true, indexPath.row)
        return (cell)
    }
    
    
    // name: didDeselectItemAt
    // desc:
    // last updated: 4/28/2020
    // last update: cleaned up
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        debugPrint("HabitDateCV", "didDeselectItemAt", "start", false)
        if let cell: WeekCell = (collectionView.cellForItem(at: indexPath) as? WeekCell) {
            // clear the selection
            if selectedCells.contains(indexPath) {
                selectedCells.remove(at: selectedCells.firstIndex(of: indexPath)!)
                // check if date selected, mark a different shade of gray
                if #available(iOS 13.0, *) {
                    cell.layer.borderColor = UIColor.systemGray2.cgColor
                    cell.day?.textColor = UIColor.systemGray2
                } else {
                    // Fallback on earlier versions
                    cell.layer.borderColor = UIColor.lightGray.cgColor
                    cell.day?.textColor = UIColor.lightGray
                }
            } // endif
        } // endif
        debugPrint("HabitDateCV", "didDeselectItemAt", "end", false)
    } // end func
    
    
    // name: didSelectItemAt
    // desc:
    // last updated: 4/28/2020
    // last update: cleaned up
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        debugPrint("HabitDateCV", "didSelectItemAt", "start", false)
        // get the cell from the tableView
        if let cell: WeekCell = (collectionView.cellForItem(at: indexPath) as? WeekCell) {
            if selectedCells.contains(indexPath) {
                selectedCells.remove(at: selectedCells.firstIndex(of: indexPath)!)
                // check if date selected, mark a different shade of gray
                if #available(iOS 13.0, *) {
                    cell.layer.borderColor = UIColor.systemGray2.cgColor
                    cell.day?.textColor = UIColor.systemGray2
                } else {
                    // Fallback on earlier versions
                    cell.layer.borderColor = UIColor.lightGray.cgColor
                    cell.day?.textColor = UIColor.lightGray
                }
            } else {
                // if the selected item is different from the last, deselect the last item
                selectedCells.append(indexPath)
                print("# selectedCells : \(selectedCells.count)")
//                self.dateCV.reloadData()
                print("# indexPathsForSelectedItems : \(self.dateUICollectionView.indexPathsForSelectedItems?.count ?? -1)")
                // change the border fo the selected item
                let defaultColor = getColor("System")
                cell.layer.borderColor = defaultColor.cgColor
                cell.day?.textColor = defaultColor
            }
            self.dateUICollectionView.reloadData()
        } // endif
        debugPrint("HabitDateCV", "didSelectItemAt", "end", false)
    } // end func
    
    
    // name: updateUICollectionView
    // desc:
    // last updated: 4/28/2020
    // last update: cleaned up
    func updateUICollectionView(_ dateUICollectionView: UICollectionView) {
        debugPrint("HabitDateCV", "updateUICollectionView", "start", false)
        self.dateUICollectionView = dateUICollectionView
        debugPrint("HabitDateCV", "updateUICollectionView", "end", false)
    }
    
    
    // name: viewDidAppear
    // desc:
    // last updated: 4/28/2020
    // last update: cleaned up
    func getNumDaysSelected() -> Int {
        debugPrint("HabitDateCV", "getNumDaysSelected", "start", false)
        debugPrint("HabitDateCV", "getNumDaysSelected", "end", false)
        return selectedCells.count
    }
    
    
    // name: viewDidAppear
    // desc:
    // last updated: 4/28/2020
    // last update: cleaned up
    func getDaysSelected() -> [IndexPath] {
        debugPrint("HabitDateCV", "getDaysSelected", "start", false)
        debugPrint("HabitDateCV", "getDaysSelected", "end", false)
        return selectedCells
    }
}
