//
//  HabitTableView.swift
//  HabiTrack
//
//  Created by Gavin Daniel on 10/16/19.
//  Copyright © 2019 Gavin Daniel. All rights reserved.
//


import Foundation
import SQLite

class HabitTableView: NSObject, UITableViewDataSource, UITableViewDelegate {

//    var journal: Journal
    var habitTableView: UITableView
//    var dateSelected: Date
    var list = ["Monday",
                "Tuesday",
                "Wednesday",
                "Thursday",
                "Friday",
                "Saturday",
                "Sunday"]
    
//    init(journal: Journal, habitTableView: UITableView, date: Date) {
    init(habitTableView: UITableView) {
//        self.journal = journal
        self.habitTableView = habitTableView
//        self.dateSelected = date
        super.init()
    }
    
    // tableView : numberOfRowsInSection
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // get the number of days in the week list
        return (list.count)
    }
    
    // tableView : cellForRowAt
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // create tableView cell
        let cell = tableView.dequeueReusableCell(withIdentifier: "day_cell", for: indexPath)
            as! HabitTableViewCell
        
        cell.dayUILabel?.text = list[indexPath.row]
        
        return (cell)
    }
    
    // tableView : didSelectRowAt
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // get the cell from the tableView
        print("\tdidSelectRowAt...")
        if let cell: HabitTableViewCell = (tableView.cellForRow(at: indexPath) as? HabitTableViewCell) {
            if cell.accessoryType == UITableViewCell.AccessoryType.checkmark {
                cell.accessoryType = .none
            } else {
                cell.accessoryType = .checkmark
            }
        }
        self.habitTableView.reloadData()
    }
    
    // custom : updateTableView
    func updateTableView(habitDayView: UITableView) {
        habitTableView = habitDayView
    }
}
