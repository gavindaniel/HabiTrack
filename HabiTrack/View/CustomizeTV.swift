//
//  CustomizeHabitsTV.swift
//  HabiTrack
//
//  Created by Gavin Daniel on 5/16/20.
//  Copyright © 2020 Gavin Daniel. All rights reserved.
//

import UIKit

public var cellCompleted = false
public var cellStreak = 0

// name: CustomizeTV
// desc: journal habits table view class
// last updated: 4/28/2020
// last update: cleaned up
class CustomizeTV: NSObject, UITableViewDataSource, UITableViewDelegate {
    // variables
    var journalUITableView: UITableView
    
    
    // name: init
    // desc:
    // last updated: 4/28/2020
    // last update: cleaned up
    init(_ habitTableView: UITableView) {
        debugPrint("JournalHabitsTV", "init", "start", true)
        self.journalUITableView = habitTableView
        super.init()
        debugPrint("JournalHabitsTV", "init", "end", true)
    }
    
    
    // name: numberOfRowsInSection
    // desc:
    // last updated: 5/16/2020
    // last update: new
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    
    // name: cellForRowAt
    // desc:
    // last updated: 5/16/2020
    // last update: cleaned up
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        debugPrint("JournalHabitsTV", "cellForRowAt", "start", true, indexPath.row)
        // create tableView cell
        let cell = tableView.dequeueReusableCell(withIdentifier: "HabitCell", for: indexPath)
            as! HabitCell
        
            cell.title?.text = "Habit"
            cell.title?.isHidden = false
            // get the name of habit and size of habit entries table
            // set the streak
            cell.streak?.text = String(cellStreak)
            cell.streak?.isHidden = false
            // check if today has already been completed
            if (cellCompleted) {
                if #available(iOS 13.0, *) {
                    cell.check?.image = UIImage(systemName: "checkmark.circle.fill")
                    cell.streak?.textColor = getColor("System")
                    cell.check?.tintColor = getColor("System")
                } else {
                    // Fallback on earlier versions
                    cell.accessoryType = .checkmark
                }
            } else {
                if #available(iOS 13.0, *) {
                    cell.check?.image = UIImage(systemName: "circle")
                    cell.check?.tintColor = UIColor.systemGray
                    cell.streak?.textColor = UIColor.label
                } else {
                    // Fallback on earlier versions
                    cell.accessoryType = .none
                }
            }
            cell.check?.isHidden = false
            debugPrint("\tJournalHabitsTV", "cellForRowAt", "end", true, indexPath.row)
            return (cell)
    }
    
    
    // name: didSelectRowAt
    // desc:
    // last updated: 4/28/2020
    // last update: cleaned up
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        debugPrint("JournalHabitsTV", "didSelectRowAt", "start", false, indexPath.row)
        // get the cell from the tableView
        if let cell: HabitCell = (tableView.cellForRow(at: indexPath) as? HabitCell) {
            // check if the cell has been completed
            if #available(iOS 13.0, *) {
                if cell.check?.image == UIImage(systemName: "checkmark.circle.fill") {
                    cell.check?.image = UIImage(systemName: "circle")
                    cell.check?.tintColor = UIColor.systemGray
                    cellStreak = 0
                    cellCompleted = false
                } else {
                    cell.check?.image = UIImage(systemName: "checkmark.circle.fill")
                    cell.check?.tintColor = getColor("System")
                    cellStreak = 1
                    cellCompleted = true
                }
            } else {
                // Fallback on earlier versions
                if cell.accessoryType == UITableViewCell.AccessoryType.checkmark {
                    cell.accessoryType = .none
                    cellStreak = 0
                    cellCompleted = false
                } else {
                    cell.accessoryType = .checkmark
                    cellStreak = 1
                    cellCompleted = true
                }
            }
        }
        self.journalUITableView.reloadData()
        debugPrint("JournalHabitsTV", "didSelectRowAt", "end", false, indexPath.row)
    }
}
