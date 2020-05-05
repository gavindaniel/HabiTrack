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
        let date = Date()
        let calendar = Calendar.current
        let dateComponents = DateComponents(year: calendar.component(.year, from: date), month: calendar.component(.month, from: date), day: 1)
        let day = calendar.date(from: dateComponents)!
        let range = calendar.range(of: .day, in: .month, for: day)!
        let numDays = range.count
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
        debugPrint("ChangeDateCV", "cellForItemAt", "start", false)
        // create collectionView item
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "changeDateCell", for: indexPath)
            as! ChangeDateCVCell
        // add labels and style
        cell.dayUILabel?.text = getDayOfWeekAsString((indexPath.row)+1, length: "short")
        cell.layer.cornerRadius = 10.0
        cell.layer.borderWidth = 1.0
        // check if day selected, mark blue, else mark gray
        if selectedCells.contains(indexPath) {
            let defaultColor = getColor("System")
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
        debugPrint("ChangeDateCV", "cellForItemAt", "end", false)
        return (cell)
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
