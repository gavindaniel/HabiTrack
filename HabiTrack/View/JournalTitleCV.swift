//
//  JournalTitleTableView.swift
//  HabiTrack
//
//  Created by Gavin Daniel on 10/5/19.
//  Copyright © 2019 Gavin Daniel. All rights reserved.
//

import Foundation


// name: JournalTitleCV
// desc: journal title collection view class
// last updated: 4/28/2020
// last update: cleaned up
class JournalTitleCV: NSObject, UICollectionViewDataSource, UICollectionViewDelegate {
    // variables
    var titleUICollectionView: UICollectionView
    var dateSelected: Date
    
    
    // name: init
    // desc:
    // last updated: 4/28/2020
    // last update: cleaned up
    init(_ titleUICollectionView: UICollectionView,_ date: Date) {
        debugPrint("JournalTitleCV", "init", "start", true)
        self.titleUICollectionView = titleUICollectionView
        self.dateSelected = date
        super.init()
        debugPrint("JournalTitleCV", "init", "end", true)
    }
    
    
    // name: numberOfItemsInSection
    // desc:
    // last updated: 4/28/2020
    // last update: cleaned up
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        debugPrint("JournalTitleCV", "numberOfItemsInSection", "start", true)
        debugPrint("JournalTitleCV", "numberOfItemsInSection", "end", true)
        return 1
    }
    
    
    // name: cellForItemAt
    // desc:
    // last updated: 4/28/2020
    // last update: cleaned up
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        debugPrint("JournalTitleCV", "cellForItemAt", "start", true, indexPath.row)
        // get the title cell
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "title", for: indexPath)
        as! JournalTitleCVCell
        // comment/uncomment for Day of Week in weekDayLabel
//        cell.weekDayLabel?.text = getDayOfWeek(date: self.dateSelected, length: "long")
        // comment/uncomment for Date in weekDayLabel
//        cell.weekDayLabel?.text = getDateAsString(date: self.dateSelected, length: "long")
        cell.weekDayLabel?.text = getMonthAsString(date: self.dateSelected, length: "long")
        let defaultColor = getColor("System")
        cell.weekDayLabel?.textColor = defaultColor
        cell.newEntryUIButton?.tintColor = defaultColor
        // return the title cell
        debugPrint("JournalTitleCV", "cellForItemAt", "end", true, indexPath.row)
        return (cell)
    }
    
    
    // name: updateUICollectionView
    // desc:
    // last updated: 4/28/2020
    // last update: cleaned up
    func updateUICollectionView(_ titleUICollectionView: UICollectionView) {
        debugPrint("JournalTitleCV", "updateUICollectionView", "start", false)
        self.titleUICollectionView = titleUICollectionView
        debugPrint("JournalTitleCV", "updateUICollectionView", "end", false)
    }
}
