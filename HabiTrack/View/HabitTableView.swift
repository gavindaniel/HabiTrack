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

    var habitTableView: UITableView
    var dayList = ["Sunday",
                   "Monday",
                   "Tuesday",
                   "Wednesday",
                   "Thursday",
                   "Friday",
                   "Saturday"]
    var selectedList = [0,0,0,0,0,0,0] // 0 = false, 1 = true
    
    init(habitTableView: UITableView) {
        self.habitTableView = habitTableView
        super.init()
    }
    
    // tableView : numberOfRowsInSection
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // get the number of days in the week list
        return (dayList.count)
    }
    
    // tableView : cellForRowAt
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // create tableView cell
        let cell = tableView.dequeueReusableCell(withIdentifier: "day_cell", for: indexPath)
            as! HabitTableViewCell
        
        cell.dayUILabel?.text = dayList[indexPath.row]
        
        return (cell)
    }
    
    // tableView : didSelectRowAt
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // get the cell from the tableView
//        print("\tdidSelectRowAt...\(indexPath.row)")
        
        // testing
        self.habitTableView.endEditing(true)
        
        if let cell: HabitTableViewCell = (tableView.cellForRow(at: indexPath) as? HabitTableViewCell) {
            if cell.accessoryType == UITableViewCell.AccessoryType.checkmark {
                cell.accessoryType = .none
                selectedList[indexPath.row] = 0
            } else {
                cell.accessoryType = .checkmark
                selectedList[indexPath.row] = 1
            }
        }
        self.habitTableView.reloadData()
    }
    
    // custom : updateTableView
    func updateTableView(habitDayView: UITableView) {
        habitTableView = habitDayView
    }
}
