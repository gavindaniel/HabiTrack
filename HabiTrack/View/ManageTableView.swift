//
//  ManageTableView.swift
//  HabiTrack
//
//  Created by Gavin Daniel on 10/18/19.
//  Copyright © 2019 Gavin Daniel. All rights reserved.
//

import Foundation
import SQLite
import MobileCoreServices

class ManageTableView: NSObject, UITableViewDataSource, UITableViewDelegate {

    var journal: Journal
    var manageTableView: UITableView
//    var dateSelected: Date
//    var buffer = 0
    
    init(journal: Journal, manageTableView: UITableView) {
        self.journal = journal
        self.manageTableView = manageTableView
//        self.dateSelected = date
        super.init()
    }
    
    // tableView : numberOfRowsInSection
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // get the number of habits in the journal
        return (journal.getTableSize())
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            print()
            print("cellForRowAt...\(indexPath.row)")
            print()
            // testing
    //        buffer = 0
            // create tableView cell
            let cell = tableView.dequeueReusableCell(withIdentifier: "settings_cell", for: indexPath)
                as! ManageTableViewCell
            // since the database only increments from the last ID,
            // this for loop fixes issues with gaps in the database.
    //        var count = 0
    //        var buffer = 0
            do {
                // get the table
                let habits = try self.journal.database.prepare(self.journal.habitsTable)
                // testing
    //            let currentDayOfWeek = Calendar.current.component(.weekday, from: dateSelected)
                // loop through the list of habits
                for habit in habits {
                    if (habit[self.journal.id] == (indexPath.row+1)) {
                        cell.habitNameUILabel?.text = habit[self.journal.habit]
                        return (cell)
                    }
                }

            } catch {
                print(error)
            }
            return (cell)
        }
    
    
    // custom : updateTableView
    func updateTableView(tableView: UITableView) {
        manageTableView = tableView
    }
    
    
}
