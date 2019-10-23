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
    var buffer = 0
    
    init(journal: Journal, habitTableView: UITableView, date: Date) {
        self.journal = journal
        self.habitTableView = habitTableView
        self.dateSelected = date
        super.init()
    }
    
    // tableView : numberOfRowsInSection
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // get the number of habits in the journal
//        return (journal.getTableSize())
        buffer = 0
        var count = 0
        do {
            // get the table
            let habits = try self.journal.database.prepare(self.journal.habitsTable)
            // testing
            let currentDayOfWeek = Calendar.current.component(.weekday, from: dateSelected)
            // loop through the list of habits
            for habit in habits {
                if(checkDayOfWeek(dayInt: habit[self.journal.dayOfWeek], dayOfWeek: currentDayOfWeek)) {
                    count += 1
                }
            }
        } catch {
            print(error)
        }
        print()
        print("\t\tnumberOfRowsInSection: \(count)")
        print()
        return (count)
    }
    
    // tableView : cellForRowAt
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        print()
        print("cellForRowAt...\(indexPath.row)")
        print()
        // testing
//        buffer = 0
        // create tableView cell
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
            as! JournalTableViewCell
        // since the database only increments from the last ID,
        // this for loop fixes issues with gaps in the database.
        var count = 0
//        var buffer = 0
        do {
            // get the table
            let habits = try self.journal.database.prepare(self.journal.habitsTable)
            // testing
            let currentDayOfWeek = Calendar.current.component(.weekday, from: dateSelected)
            // loop through the list of habits
            for habit in habits {
                print("id: \(habit[self.journal.id])")
                print("count-buffer: \(count) - \(buffer) == \(indexPath.row)")
                if ((count - buffer) == indexPath.row) {
//                if (checkDayOfWeek(dayInt: habit[self.journal.dayOfWeek], dayOfWeek: currentDayOfWeek)) {
//                if (count == habit[self.journal.id]) {
                    // testing
//                    print("dayOfWeek: \(habit[self.journal.dayOfWeek])")
//                    let tempDayOfWeek = getDayOfWeekString(dayOfWeek: habit[self.journal.dayOfWeek], length: "short")
//                    print("currentDayOfWeek: \(currentDayOfWeek) == tempDayOfWeek: \(tempDayOfWeek)")
                    // check if count equals the habits id
//                    if (currentDayOfWeek == tempDayOfWeek) {
                    print("\tid: \(habit[self.journal.id])")
                    print()
                    print("comparing...")
                    print()
                    print("\(habit[self.journal.dayOfWeek]) ? \(currentDayOfWeek)")
                    if (checkDayOfWeek(dayInt: habit[self.journal.dayOfWeek], dayOfWeek: currentDayOfWeek)) {
//                    if (count == indexPath.row) {
                        cell.habitUILabel?.text = habit[self.journal.habit]
    //                    cell.timeUILabel?.text = habit[self.journal.time]
                        
                        //testing ...
                        let repeatString = habit[self.journal.time]
                        if (repeatString == "weekly") {
//                            let dayOfWeekString = getDayOfWeekString(dayOfWeek: habit[self.journal.dayOfWeek], length: "long")
//                            repeatString += " (\(dayOfWeekString)s)"
                        }
                        cell.timeUILabel?.text = repeatString
                        
                        // get the name of habit and size of habit entries table
                        let habitString = habit[self.journal.habit]
    //                    let habitRepeatString = habit[self.journal.time]
                        let habitDayOfWeek = habit[self.journal.dayOfWeek]
                        print("calling countStreak...")
                        let currentStreak = self.journal.entries.countStreak(habit: habitString, date: dateSelected, habitRepeat: habitDayOfWeek) // habitRepeatString
                        print("calling countLongestStreak...")
                        let longestStreak = self.journal.entries.countLongestStreak(habit: habitString, date: dateSelected, habitRepeat: habitDayOfWeek) // habitRepeatString
                        // set the streak
                        cell.streakUILabel?.text = String(currentStreak)
                        
                        // check if the current streak is equal or greater than the longest
                        if (currentStreak >= longestStreak && longestStreak > 0) {
                            cell.longestStreakUILabel?.text = "current longest streak!"
                            cell.longestStreakUILabel?.textColor = getSystemColor()
                        } else { // else return the the longest streak
                            cell.longestStreakUILabel?.text = "longest streak (\( String(longestStreak)))"
                            if #available(iOS 13.0, *) {
                                cell.longestStreakUILabel?.textColor = UIColor.systemGray
                            } else {
                                // Fallback on earlier versions
                                cell.longestStreakUILabel?.textColor = UIColor.darkGray
                            }
                        }
                        
                        if (currentStreak == 1) {
//                            if (cell.timeUILabel?.text == "weekly") {
                            if (habit[self.journal.time] == "weekly") {
                                cell.streakDayUILabel?.text = "week"
                            } else {
                                cell.streakDayUILabel?.text = "day"
                            }
                        } else {
//                            if (cell.timeUILabel?.text == "weekly") {
                            if (habit[self.journal.time] == "weekly") {
                                cell.streakDayUILabel?.text = "weeks"
                            } else {
                                cell.streakDayUILabel?.text = "days"
                            }
                        }
                        // check if today has already been completed
                        if (self.journal.entries.checkCompleted(habit: habitString, date: dateSelected)) {
                            if #available(iOS 13.0, *) {
                                cell.checkImageView?.image = UIImage(systemName: "checkmark.circle.fill")
                                let defaultColor = getSystemColor()
                                cell.checkImageView?.tintColor = defaultColor
//                                cell.checkImageView?.tintColor = UIColor.systemBlue
                                
                            } else {
                                // Fallback on earlier versions
                                cell.accessoryType = .checkmark
                            }
    //                        cell.checkBox?.setOn(true, animated: false)
    //                        cell.checkBox?.on = true
                        } else {
                            if #available(iOS 13.0, *) {
                                cell.checkImageView?.image = UIImage(systemName: "circle")
                                cell.checkImageView?.tintColor = UIColor.systemGray
                            } else {
                                // Fallback on earlier versions
                                cell.accessoryType = .none
                            }
    //                        cell.checkBox?.on = false
    //                        cell.checkBox?.setOn(false, animated: false)
                        }
//                        buffer += 1
                        return (cell)
                    } else {
                        print("\tincrementing buffer...")
                        buffer += 1
                        count += 1
                    }
                    
                    //testing
//                    cell.checkBox?.onAnimationType = BEMAnimationType.bounce
//                    cell.checkBox?.offAnimationType = BEMAnimationType.bounce
                    
//                    return (cell)
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
        print("didSelectRowAt...")
        if let cell: JournalTableViewCell = (tableView.cellForRow(at: indexPath) as? JournalTableViewCell) {
            // get the habit string from the cell
            let tempString = cell.habitUILabel?.text
            // check if the cell has been completed
            if #available(iOS 13.0, *) {
                if cell.checkImageView?.image == UIImage(systemName: "checkmark.circle.fill") {
                    cell.checkImageView?.image = UIImage(systemName: "circle")
                    cell.checkImageView?.tintColor = UIColor.systemGray
    //                cell.checkBox?.on = false
    //                cell.checkBox?.setOn(false, animated: true)
                    journal.updateStreak(row: indexPath.row, inc: 0, date: dateSelected, habitString: tempString ?? "none")
                } else {
                    cell.checkImageView?.image = UIImage(systemName: "checkmark.circle.fill")
                    cell.checkImageView?.tintColor = getSystemColor()
                    journal.updateStreak(row: indexPath.row, inc: 1, date: dateSelected, habitString: tempString ?? "none")
                }
            } else {
                // Fallback on earlier versions
                if cell.accessoryType == UITableViewCell.AccessoryType.checkmark {
                    cell.accessoryType = .none
//                cell.checkBox?.on = false
  //                cell.checkBox?.setOn(false, animated: true)
                    journal.updateStreak(row: indexPath.row, inc: 0, date: dateSelected, habitString: tempString ?? "none")
                } else {
                    cell.accessoryType = .checkmark
                    journal.updateStreak(row: indexPath.row, inc: 1, date: dateSelected, habitString: tempString ?? "none")
                }
            }
        }
        self.habitTableView.reloadData()
    }
    
    // custom : updateTableView
    func updateTableView(habitView: UITableView) {
        habitTableView = habitView
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
