//
//  JournalTableView.swift
//  HabiTrack
//
//  Created by Gavin Daniel on 9/27/19.
//  Copyright © 2019 Gavin Daniel. All rights reserved.
//

import Foundation
import SQLite
import MobileCoreServices

class JournalTableView: NSObject, UITableViewDataSource, UITableViewDelegate, UITableViewDragDelegate {

    var journal: Journal
    var habitTableView: UITableView
    var dateSelected: Date
    
    init(journal: Journal, habitTableView: UITableView, date: Date) {
        self.journal = journal
        self.habitTableView = habitTableView
        self.dateSelected = date
        super.init()
    }
    
    // tableView : numberOfRowsInSection
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // get the number of habits in the journal
        return (journal.getTableSize())
    }
    
    // tableView : cellForRowAt
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // create tableView cell
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
            as! HabitTableViewCell
        // since the database only increments from the last ID,
        // this for loop fixes issues with gaps in the database.
        var count = 0
        do {
            // get the table
            let habits = try self.journal.database.prepare(self.journal.habitsTable)
            // loop through the list of habits
            for habit in habits {
                if (count == indexPath.row) {
                    // check if count equals the habits id
                    if (count == habit[self.journal.id]) {
                        // do something
                    }
                    cell.habitUILabel?.text = habit[self.journal.habit]
                    cell.timeUILabel?.text = habit[self.journal.time]
                    // get the name of habit and size of habit entries table
                    let habitString = habit[self.journal.habit]
                    let habitStreak = self.journal.entries.countStreak(habit: habitString, date: dateSelected)
                    // set the streak
//                    cell.streakUILabel?.text = getStreakAsString(streak: habitStreak)
                    cell.streakUILabel?.text = String(habitStreak)
                    if (habitStreak == 1) {
                        cell.streakDayUILabel?.text = "day"
                    } else {
                        cell.streakDayUILabel?.text = "days"
                    }
                    // check if today has already been completed
                    if (self.journal.entries.checkCompleted(habit: habitString, date: dateSelected)) {
                        cell.accessoryType = .checkmark
//                        cell.checkBox?.setOn(true, animated: false)
//                        cell.checkBox?.on = true
                    } else {
                        cell.accessoryType = .none
//                        cell.checkBox?.on = false
//                        cell.checkBox?.setOn(false, animated: false)
                    }
                    
                    //testing
//                    cell.checkBox?.onAnimationType = BEMAnimationType.bounce
//                    cell.checkBox?.offAnimationType = BEMAnimationType.bounce
                    
                    return (cell)
                } else {
                    count += 1
                }
            }
        } catch {
            print (error)
        }
//        self.habitTableView.reloadData()
        return (cell)
    }
    
    // tableView : didSelectRowAt
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // get the cell from the tableView
        if let cell: HabitTableViewCell = (tableView.cellForRow(at: indexPath) as? HabitTableViewCell) {
            // get the habit string from the cell
            let tempString = cell.habitUILabel?.text
            // check if the cell has been completed
            if cell.accessoryType == UITableViewCell.AccessoryType.checkmark {
                cell.accessoryType = .none
//                cell.checkBox?.on = false
//                cell.checkBox?.setOn(false, animated: true)
                journal.updateStreak(row: indexPath.row, inc: 0, date: dateSelected, habitString: tempString ?? "none")
            }
            else {
                cell.accessoryType = .checkmark
//                cell.checkBox?.on = true
//                cell.checkBox?.setOn(true, animated: true)
                journal.updateStreak(row: indexPath.row, inc: 1, date: dateSelected, habitString: tempString ?? "none")
            }
        }
        self.habitTableView.reloadData()
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
            if let cell: HabitTableViewCell = (tableView.cellForRow(at: indexPath) as? HabitTableViewCell) {
                habitString = cell.habitUILabel?.text ?? "error"
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
                    if (count == indexPath.row) {
                        // get the habit whose id matches the count + first ID in the tableView
                        let habit = self.journal.habitsTable.filter(self.journal.id == (count+firstId))
                        // delete the habit
                        let deleteHabit = habit.delete()
                        do {
                            try self.journal.database.run(deleteHabit)
                            print("Deleted habit")
                            habitTableView.reloadData()
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
    func updateTableView(habitView: UITableView) {
//        print("\tupdating table view...")
        habitTableView = habitView
//        print("\t\tupdated table view.")
    }
    
    
    
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
