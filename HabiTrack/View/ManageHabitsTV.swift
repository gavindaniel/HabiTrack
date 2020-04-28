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

class ManageHabitsTV: NSObject, UITableViewDataSource, UITableViewDelegate, UITableViewDragDelegate {

    var journal: Journal
    var manageUITV: UITableView
//    var dateSelected: Date
//    var buffer = 0
    
    init(_ journal: Journal, manageUITV: UITableView) {
        self.journal = journal
        self.manageUITV = manageUITV
//        self.dateSelected = date
        super.init()
    }
    
    // tableView : numberOfRowsInSection
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // get the number of habits in the journal
        return (journal.getTableSize())
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        print()
//        print("cellForRowAt...\(indexPath.row)")
//        print()
        
        // create tableView cell
        let cell = tableView.dequeueReusableCell(withIdentifier: "settings_cell", for: indexPath)
            as! ManageHabitsTVCell
        do {
            // get the table
            let habits = try self.journal.database.prepare(self.journal.habitsTable)
            // loop through the list of habits
            for habit in habits {
                if (habit[self.journal.id] == (indexPath.row+1)) {
                    cell.habitNameUILabel?.text = habit[self.journal.habit]
                    let tempString = getRepeatDaysString(dayInt: habit[self.journal.dayOfWeek])
                    cell.habitRepeatUILabel?.text = tempString
                    cell.habitRepeatUILabel?.textColor = getSystemColor()
                    return (cell)
                }
            }

        } catch {
            print(error)
        }
        return (cell)
    }
    
    // tableView : editingStyle
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath)
    {
        // check if the editingStyle is delete
        if (editingStyle == UITableViewCell.EditingStyle.delete) {
            var count = 0
            var firstId = 0
            var habitString = ""
            // get the habit string from the tableview cell
            if let cell: ManageHabitsTVCell = (tableView.cellForRow(at: indexPath) as? ManageHabitsTVCell) {
                habitString = cell.habitNameUILabel?.text ?? "error"
            }
            // delete the habit from the table
            journal.entries.deleteTable(habit: habitString)
            do {
                // get the habits table
                let habits = try self.journal.database.prepare(self.journal.habitsTable)
                // loop through the table
                for habit in habits {
                    // get the id of the first habit
                    if (count == 0) {
                        firstId = habit[self.journal.id]
                    }
                    if (habit[self.journal.habit] == habitString) {
                        // get the habit whose id matches the count + first ID in the tableView
                        let habit = self.journal.habitsTable.filter(self.journal.id == (firstId+count))
                        // delete the habit
                        let deleteHabit = habit.delete()
                        do {
                            try self.journal.database.run(deleteHabit)
                            print("\tDeleted habit...\(habitString)...from database")
                            updateHabitIDs()
                            updateLocalTable()
                            manageUITV.reloadData()
                            return
                        } catch {
                            print(error)
                        }
                    } else {
                        count += 1
                    }
                }
            } catch {
                print (error)
            }
        }
    }
    
    // custom : updateTableView
    func updateTableView(_ manageUITV: UITableView) {
        self.manageUITV = manageUITV
    }
    
    
    func updateLocalTable() {
        print("updateLocalTable...")
        if (isKeyPresentInUserDefaults(key: "localHabits") == false) {
            let defaults = UserDefaults.standard
            defaults.set([String](), forKey: "localHabits")
        }
        do {
            let table = Table("habits")
            let habits = try self.journal.database.prepare(table)
            let defaults = UserDefaults.standard
            var localHabits = [String]()
            for habit in habits {
                localHabits.append(habit[self.journal.habit])
            }
            defaults.set(localHabits, forKey: "localHabits")
        } catch {
            print(error)
        }
    }
    
    
    // name:
    // desc:
    // last updated: 4/28/2020
    // last update: fixed issue where database wasn't updating
    func updateHabitIDs() {
        print("updateHabitIDs...")
        do {
            // define variable(s)
            let table = Table("habits")
            let habits = try self.journal.database.prepare(table)
            var index = 1, currId = 1, diff = 0, numUpdates = 0
            // loop through habits table
            for habit in habits {
                // calculate difference = current habit ID - loop index
                currId = habit[self.journal.id]
                diff = currId - index
                // check if there is a difference
                if (diff > 0) {
                    // calculate the new ID based on the difference between database table and local table
                    let newId = currId - diff
                    // get the habit with the current ID
                    let tempHabit = self.journal.habitsTable.filter(self.journal.id == currId)
                    let updateHabit = tempHabit.update(self.journal.id <- newId)
                    // attempt to update the database
                    do {
                        try self.journal.database.run(updateHabit)
                        print("\tupdated habit ID...\(habit[self.journal.id])->\(newId)")
                        numUpdates += 1
                    } catch {
                        print(error)
                    }
                }
                // increment ID
                index += 1
            } // end for loop
            // check for no updates
            if (numUpdates == 0) {
                print("\tno IDs updated")
            }
        } catch {
            print(error)
        }
    } // end func
    
    // testing ...
    
    /**
         A helper function that serves as an interface to the data model,
         called by the implementation of the `tableView(_ canHandle:)` method.
    */
    func canHandle(_ session: UIDropSession) -> Bool {
        return session.canLoadObjects(ofClass: NSString.self)
    }
    
    /**
         A helper function that serves as an interface to the data mode, called
         by the `tableView(_:itemsForBeginning:at:)` method.
    */
    func dragItems(for indexPath: IndexPath) -> [UIDragItem] {
        let defaults = UserDefaults.standard
        let localHabits = defaults.object(forKey: "localHabits") as! [String]
        let habitString = localHabits[indexPath.row]

        let data = habitString.data(using: .utf8)
        let itemProvider = NSItemProvider()
        
        itemProvider.registerDataRepresentation(forTypeIdentifier: kUTTypePlainText as String, visibility: .all) { completion in
            completion(data, nil)
            return nil
        }

        return [
            UIDragItem(itemProvider: itemProvider)
        ]
    }
    
     // testing drag extension ...
        /**
             The `tableView(_:itemsForBeginning:at:)` method is the essential method
             to implement for allowing dragging from a table.
        */
        func tableView(_ tableView: UITableView, itemsForBeginning session: UIDragSession, at indexPath: IndexPath) -> [UIDragItem] {
            return ( dragItems(for: indexPath) )
        }
        
        // testing drop extension ...
        /**
             Ensure that the drop session contains a drag item with a data representation
             that the view can consume.
        */
        func tableView(_ tableView: UITableView, canHandle session: UIDropSession) -> Bool {
            return ( canHandle(session) )
        }
        
        /**
             A drop proposal from a table view includes two items: a drop operation,
             typically .move or .copy; and an intent, which declares the action the
             table view will take upon receiving the items. (A drop proposal from a
             custom view does includes only a drop operation, not an intent.)
        */
        func tableView(_ tableView: UITableView, dropSessionDidUpdate session: UIDropSession, withDestinationIndexPath destinationIndexPath: IndexPath?) -> UITableViewDropProposal {
            // The .move operation is available only for dragging within a single app.
            
            if tableView.hasActiveDrag {
                if session.items.count > 1 {
                    return UITableViewDropProposal(operation: .cancel)
                } else {
                    return UITableViewDropProposal(operation: .move, intent: .insertAtDestinationIndexPath)
                }
            } else {
                return UITableViewDropProposal(operation: .copy, intent: .insertAtDestinationIndexPath)
            }
        }
        /**
             This delegate method is the only opportunity for accessing and loading
             the data representations offered in the drag item. The drop coordinator
             supports accessing the dropped items, updating the table view, and specifying
             optional animations. Local drags with one item go through the existing
             `tableView(_:moveRowAt:to:)` method on the data source.
        */
        func tableView(_ tableView: UITableView, performDropWith coordinator: UITableViewDropCoordinator) {
            let destinationIndexPath: IndexPath
            
            if let indexPath = coordinator.destinationIndexPath {
                destinationIndexPath = indexPath
            } else {
                // Get last index path of table view.
                let section = tableView.numberOfSections - 1
                let row = tableView.numberOfRows(inSection: section)
                destinationIndexPath = IndexPath(row: row, section: section)
            }
            
            coordinator.session.loadObjects(ofClass: NSString.self) { items in
                // Consume drag items.
                let stringItems = items as! [String]
                
                var indexPaths = [IndexPath]()
                for (index, item) in stringItems.enumerated() {
                    let indexPath = IndexPath(row: destinationIndexPath.row + index, section: destinationIndexPath.section)
                    self.journal.addItem(item, at: indexPath.row)
                    indexPaths.append(indexPath)
                }

                tableView.insertRows(at: indexPaths, with: .automatic)
            }
        }
        
        // testing data extension ....
        
        // MARK: - UITableViewDelegate

        func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
            return true
        }
        
        func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
            self.journal.moveItem(at: sourceIndexPath.row, to: destinationIndexPath.row)
    }
}
