//
//  JournalTitleTableView.swift
//  HabiTrack
//
//  Created by Gavin Daniel on 10/5/19.
//  Copyright © 2019 Gavin Daniel. All rights reserved.
//

import Foundation

class JournalTitleView: NSObject, UITableViewDataSource, UITableViewDelegate {
    
    var titleTableView: UITableView
    var dateSelected: Date
    
    // initializer
    init(titleTableView: UITableView, date: Date) {
        self.titleTableView = titleTableView
        self.dateSelected = date
        super.init()
    }
    
    // tableView: numberOfRowsInSection
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    // tableView : cellForRowAt
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // get the title cell
        let cell = tableView.dequeueReusableCell(withIdentifier: "title", for: indexPath)
        as! JournalTitleTableViewCell
        
        // comment/uncomment for Day of Week in weekDayLabel
//        cell.weekDayLabel?.text = getDayOfWeek(date: self.dateSelected, length: "long")
        
        // comment/uncomment for Date in weekDayLabel
        cell.weekDayLabel?.text = getDateAsString(date: self.dateSelected, length: "long")
        
        // return the title cell
        return (cell)
    }
    
    // custom : updateTableView
    func updateTitleView(titleView: UITableView) {
        titleTableView = titleView
    }
}
