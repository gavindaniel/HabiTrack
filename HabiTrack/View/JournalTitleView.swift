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
    
    init(titleTableView: UITableView, date: Date) {
        self.titleTableView = titleTableView
        self.dateSelected = date
        super.init()
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // do something
        let cell = tableView.dequeueReusableCell(withIdentifier: "title", for: indexPath)
        as! JournalTitleTableViewCell
        
//        cell.weekDayLabel?.text = getDayOfWeek(date: self.dateSelected, length: "long")
        cell.weekDayLabel?.text = getDateAsString(date: self.dateSelected, length: "long")
        
            
//        self.titleTableView.reloadData()
        return (cell)
    }
    
    // custom : updateTableView
    func updateTitleView(titleView: UITableView) {
        print("\tupdating title view...")
        titleTableView = titleView
        print("\t\tupdated title view.")
    }
}
