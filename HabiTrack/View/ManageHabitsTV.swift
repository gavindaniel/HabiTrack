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
    // variables
    var habits: Habits
    var manageUITableView: UITableView
    
    
    // name: init
    // desc:
    // last updated: 4/28/2020
    // last update: cleaned up
    init(_ habits: Habits,_ manageUITableView: UITableView) {
        debugPrint("ManageHabitsTV", "init", "start", true)
        self.habits = habits
        self.manageUITableView = manageUITableView
//        self.dateSelected = date
        super.init()
        debugPrint("ManageHabitsTV", "init", "end", true)
    }
    
    
    // name: numberOfRowsInSection
    // desc:
    // last updated: 4/28/2020
    // last update: cleaned up
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        debugPrint("ManageHabitsTV", "numberOfRowsInSection", "start", false)
        debugPrint("ManageHabitsTV", "numberOfRowsInSection", "end", false)
        // get the number of habits in the table
        return (habits.getTableSize())
    }
    
    
    // name: cellForRowAt
    // desc:
    // last updated: 4/28/2020
    // last update: cleaned up
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        debugPrint("ManageHabitsTV", "cellForRowAt", "start", false, indexPath.row)
//        print()
//        print("cellForRowAt...\(indexPath.row)")
//        print()
        
        // create tableView cell
        let cell = tableView.dequeueReusableCell(withIdentifier: "settings_cell", for: indexPath)
            as! ManageHabitsTVCell
        do {
            // get the table
            let habits = try self.habits.database.prepare(self.habits.habitsTable)
            // loop through the list of habits
            for habit in habits {
                if (habit[self.habits.id] == (indexPath.row+1)) {
                    cell.habitNameUILabel?.text = habit[self.habits.name]
                    let tempString = getRepeatDaysString(dayInt: habit[self.habits.days])
                    cell.habitRepeatUILabel?.text = tempString
                    cell.habitRepeatUILabel?.textColor = getColor("System")
                    debugPrint("\tManageHabitsTV", "cellForRowAt", "end", false, indexPath.row)
                    return (cell)
                }
            }
        } catch {
            print(error)
        }
        debugPrint("ManageHabitsTV", "cellForRowAt", "end", false, indexPath.row)
        return (cell)
    }
    
    
    // name: editingStyle
    // desc:
    // last updated: 4/28/2020
    // last update: cleaned up
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath)
    {
        debugPrint("ManageHabitsTV", "editingStyle", "start", false)
        // check if the editingStyle is delete
        if (editingStyle == UITableViewCell.EditingStyle.delete) {
            var count = 0
            var firstId = 0
            var nameString = ""
            // get the habit string from the tableview cell
            if let cell: ManageHabitsTVCell = (tableView.cellForRow(at: indexPath) as? ManageHabitsTVCell) {
                nameString = cell.habitNameUILabel?.text ?? "error"
            }
            // delete the habit from the table
            habits.entries.deleteTable(habit: nameString)
            do {
                // get the habits table
                let habits = try self.habits.database.prepare(self.habits.habitsTable)
                // loop through the table
                for habit in habits {
                    // get the id of the first habit
                    if (count == 0) {
                        firstId = habit[self.habits.id]
                    }
                    if (habit[self.habits.name] == nameString) {
                        // get the habit whose id matches the count + first ID in the tableView
                        let habit = self.habits.habitsTable.filter(self.habits.id == (firstId+count))
                        // delete the habit
                        let deleteHabit = habit.delete()
                        do {
                            try self.habits.database.run(deleteHabit)
                            print("\tDeleted habit...\(nameString)...from database")
                            updateHabitIDs()
                            updateLocalTable()
                            manageUITableView.reloadData()
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
        debugPrint("ManageHabitsTV", "editingStyle", "end", false)
    }
    
    
    // name: updateUITableView
    // desc:
    // last updated: 4/28/2020
    // last update: cleaned up
    func updateUITableView(_ manageUITableView: UITableView) {
        debugPrint("ManageHabitsTV", "updateUITableView", "start", false)
        self.manageUITableView = manageUITableView
        debugPrint("ManageHabitsTV", "updateUITableView", "end", false)
    }
    
    
    // name: updateLocalTable
    // desc:
    // last updated: 4/28/2020
    // last update: cleaned up
    func updateLocalTable() {
        debugPrint("ManageHabitsTV", "updateLocalTable", "start", false)
        print("updateLocalTable...")
        if (isKeyPresentInUserDefaults(key: "localHabits") == false) {
            let defaults = UserDefaults.standard
            defaults.set([String](), forKey: "localHabits")
        }
        do {
            let table = Table("habits")
            let habits = try self.habits.database.prepare(table)
            let defaults = UserDefaults.standard
            var localHabits = [String]()
            for habit in habits {
                localHabits.append(habit[self.habits.name])
            }
            defaults.set(localHabits, forKey: "localHabits")
        } catch {
            print(error)
        }
        debugPrint("ManageHabitsTV", "updateLocalTable", "end", false)
    }
    
    
    // name: updateHabitIDs
    // desc:
    // last updated: 4/28/2020
    // last update: fixed issue where database wasn't updating
    func updateHabitIDs() {
        debugPrint("ManageHabitsTV", "updateHabitIDs", "start", false)
        do {
            // define variable(s)
            let table = Table("habits")
            let habits = try self.habits.database.prepare(table)
            var index = 1, currId = 1, diff = 0, numUpdates = 0
            // loop through habits table
            for habit in habits {
                // calculate difference = current habit ID - loop index
                currId = habit[self.habits.id]
                diff = currId - index
                // check if there is a difference
                if (diff > 0) {
                    // calculate the new ID based on the difference between database table and local table
                    let newId = currId - diff
                    // get the habit with the current ID
                    let tempHabit = self.habits.habitsTable.filter(self.habits.id == currId)
                    let updateHabit = tempHabit.update(self.habits.id <- newId)
                    // attempt to update the database
                    do {
                        try self.habits.database.run(updateHabit)
                        print("\tupdated habit ID...\(habit[self.habits.id])->\(newId)")
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
        debugPrint("ManageHabitsTV", "updateHabitIDs", "end", false)
    } // end func
    
    
    // name: canHandle
    // desc:
    /**
         A helper function that serves as an interface to the data model,
         called by the implementation of the `tableView(_ canHandle:)` method.
    */
    // last updated: 4/28/2020
    // last update: cleaned up
    func canHandle(_ session: UIDropSession) -> Bool {
        debugPrint("ManageHabitsTV", "canHandle", "start", false)
        debugPrint("ManageHabitsTV", "canHandle", "end", false)
        return session.canLoadObjects(ofClass: NSString.self)
    }
    
    
    // name: dragItems
    // desc:
    /**
         A helper function that serves as an interface to the data mode, called
         by the `tableView(_:itemsForBeginning:at:)` method.
    */
    // last updated: 4/28/2020
    // last update: cleaned up
    func dragItems(for indexPath: IndexPath) -> [UIDragItem] {
        debugPrint("ManageHabitsTV", "dragItems", "start", false)
        let defaults = UserDefaults.standard
        let localHabits = defaults.object(forKey: "localHabits") as! [String]
        let habitString = localHabits[indexPath.row]
        let data = habitString.data(using: .utf8)
        let itemProvider = NSItemProvider()
        itemProvider.registerDataRepresentation(forTypeIdentifier: kUTTypePlainText as String, visibility: .all) { completion in
            completion(data, nil)
            return nil
        }
        debugPrint("ManageHabitsTV", "dragItems", "end", false)
        return [UIDragItem(itemProvider: itemProvider)]
    }

    
    // name: itemsForBeginning
    // desc:
    /**
         The `tableView(_:itemsForBeginning:at:)` method is the essential method
         to implement for allowing dragging from a table.
    */
    // last updated: 4/28/2020
    // last update: cleaned up
    func tableView(_ tableView: UITableView, itemsForBeginning session: UIDragSession, at indexPath: IndexPath) -> [UIDragItem] {
        debugPrint("ManageHabitsTV", "itemsForBeginning", "start", false)
        debugPrint("ManageHabitsTV", "itemsForBeginning", "end", false)
        return ( dragItems(for: indexPath) )
    }
    
    
    // name: canHandle
    // desc:
    /**
         Ensure that the drop session contains a drag item with a data representation
         that the view can consume.
    */
    // last updated: 4/28/2020
    // last update: cleaned up
    func tableView(_ tableView: UITableView, canHandle session: UIDropSession) -> Bool {
        debugPrint("ManageHabitsTV", "canHandle", "start", false)
        debugPrint("ManageHabitsTV", "canHandle", "end", false)
        return ( canHandle(session) )
    }
        
        
    // name: dropSessionDidUpdate
    // desc:
    /**
         A drop proposal from a table view includes two items: a drop operation,
         typically .move or .copy; and an intent, which declares the action the
         table view will take upon receiving the items. (A drop proposal from a
         custom view does includes only a drop operation, not an intent.)
    */
    // last updated: 4/28/2020
    // last update: cleaned up
    func tableView(_ tableView: UITableView, dropSessionDidUpdate session: UIDropSession, withDestinationIndexPath destinationIndexPath: IndexPath?) -> UITableViewDropProposal {
        debugPrint("ManageHabitsTV", "dropSessionDidUpdate", "start", false)
        // The .move operation is available only for dragging within a single app.
        if tableView.hasActiveDrag {
            if session.items.count > 1 {
                debugPrint("ManageHabitsTV", "dropSessionDidUpdate", "end", false)
                return UITableViewDropProposal(operation: .cancel)
            } else {
                debugPrint("ManageHabitsTV", "dropSessionDidUpdate", "end", false)
                return UITableViewDropProposal(operation: .move, intent: .insertAtDestinationIndexPath)
            }
        } else {
            debugPrint("ManageHabitsTV", "dropSessionDidUpdate", "end", false)
            return UITableViewDropProposal(operation: .copy, intent: .insertAtDestinationIndexPath)
        }
    }
        
    
    // name: performDropWith
    // desc:
    /**
         This delegate method is the only opportunity for accessing and loading
         the data representations offered in the drag item. The drop coordinator
         supports accessing the dropped items, updating the table view, and specifying
         optional animations. Local drags with one item go through the existing
         `tableView(_:moveRowAt:to:)` method on the data source.
    */
    // last updated: 4/28/2020
    // last update: cleaned up
    func tableView(_ tableView: UITableView, performDropWith coordinator: UITableViewDropCoordinator) {
        debugPrint("ManageHabitsTV", "performDropWith", "start", false)
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
                self.habits.addItem(item, at: indexPath.row)
                indexPaths.append(indexPath)
            }

            tableView.insertRows(at: indexPaths, with: .automatic)
        }
        debugPrint("ManageHabitsTV", "performDropWith", "end", false)
    }
        
    
    // name: canMoveRowAt
    // desc:
    // last updated: 4/28/2020
    // last update: cleaned up
    func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        debugPrint("ManageHabitsTV", "canMoveRowAt", "start", false)
        debugPrint("ManageHabitsTV", "canMoveRowAt", "end", false)
        return true
    }
        
    
    // name: moveRowAt
    // desc:
    // last updated: 4/28/2020
    // last update: cleaned up
    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        debugPrint("ManageHabitsTV", "moveRowAt", "start", false)
        self.habits.moveItem(at: sourceIndexPath.row, to: destinationIndexPath.row)
        debugPrint("ManageHabitsTV", "moveRowAt", "end", false)
    }
}
