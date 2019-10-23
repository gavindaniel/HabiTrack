//
//  JournalTitleTableView.swift
//  HabiTrack
//
//  Created by Gavin Daniel on 10/5/19.
//  Copyright © 2019 Gavin Daniel. All rights reserved.
//

import Foundation

class JournalTitleView: NSObject, UICollectionViewDataSource, UICollectionViewDelegate {
    
    var titleTableView: UICollectionView
    var dateSelected: Date
    
    // initializer
    init(titleTableView: UICollectionView, date: Date) {
        self.titleTableView = titleTableView
        self.dateSelected = date
        super.init()
    }
    
    // collectionView : numberOfItemsInSection
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 1
    }
    
    // collectionView : cellForItemAt
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        // get the title cell
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "title", for: indexPath)
        as! JournalTitleCollectionViewCell
        
        // comment/uncomment for Day of Week in weekDayLabel
//        cell.weekDayLabel?.text = getDayOfWeek(date: self.dateSelected, length: "long")
        
        // comment/uncomment for Date in weekDayLabel
        cell.weekDayLabel?.text = getDateAsString(date: self.dateSelected, length: "long")
        
        let defaultColor = getSystemColor()
        cell.weekDayLabel?.textColor = defaultColor
        cell.newEntryUIButton?.tintColor = defaultColor
        
        // return the title cell
        return (cell)
    }
    
    // custom : updateTableView
    func updateTitleView(titleView: UICollectionView) {
        self.titleTableView = titleView
    }
}
