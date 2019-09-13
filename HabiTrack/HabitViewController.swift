//
//  HabitViewController.swift
//  HabiTrack
//
//  Created by Gavin Daniel on 9/12/19.
//  Copyright © 2019 Gavin Daniel. All rights reserved.
//

import Foundation
import UIKit
import SQLite


class HabitViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var habitTextField: UITextField!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var titleUnderLabel: UILabel!
    @IBOutlet weak var timeTextField: UITextField!
    @IBOutlet weak var timeUnderLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    
    
    var activeTextField = UITextField()
    var lastActiveTextField: String!
    
    var journal = Journal()
    
    // load : viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        print()
        print("viewDidLoad...")
        print()
        
        do {
            let documentDirectory = try FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
            let fileUrl = documentDirectory.appendingPathComponent("habits").appendingPathExtension("sqlite3")
            let database = try Connection(fileUrl.path)
            self.journal.database = database
            self.journal.entries.database = database
            
            // testing...
            //            update()
            
        } catch {
            print(error)
        }
    }
    
    // Assign the newly active text field to your activeTextField variable
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
        self.activeTextField = textField
        let id = textField.restorationIdentifier
        
        if (id == "titleTextField") {
            titleLabel.textColor = UIColor.blue
            titleUnderLabel.textColor = UIColor.blue
            lastActiveTextField = id ?? "titleTextField"
        }
        else if (id == "timeTextField") {
            timeLabel.textColor = UIColor.blue
            timeUnderLabel.textColor = UIColor.blue
            lastActiveTextField = id ?? "timeTextField"
        }
        
        print("didBeginEditing, id: \(id ?? "Time")")
    }
    
    // Assign the newly active text field to your activeTextField variable
    func textFieldDidEndEditing(_ textField: UITextField) {
        
//        self.activeTextField = textField
//        let id = textField.restorationIdentifier
        print("didEndEditing")
        
        if (lastActiveTextField == "timeTextField") {
            timeLabel.textColor = UIColor.gray
            timeUnderLabel.textColor = UIColor.gray
        }
        if (lastActiveTextField == "timeTextField") {
            timeLabel.textColor = UIColor.gray
            timeUnderLabel.textColor = UIColor.gray
        }
        
//        print("didBeginEditing, id: \(id ?? "Time")")
    }
    
    // Call activeTextField whenever you need to
    func anotherMethod() {
        
        // self.activeTextField.text is an optional, we safely unwrap it here
        if let activeTextFieldText = self.activeTextField.text {
            print("Active text field's text: \(activeTextFieldText)")
            return;
        }
        
        print("Active text field is empty")
    }
    
    
    @IBAction func submitEntry(_ sender: Any) {
        
        // create table if there isn't one
        journal.createTable()
        // create alert controller
        
            // insert new habit into journal
        let habit = habitTextField.text
        let time = timeTextField.text
            let addHabit = self.journal.habitsTable.insert(self.journal.habit <- habit ?? "error",
                                                           self.journal.time <- time ?? "daily",
                                                           self.journal.streak <- 0,
                                                           self.journal.currentDay <- 1)
            // attempt to add habit to database
            do {
                try self.journal.database.run(addHabit)
                print("Habit Added -> habit: \(habit ?? "error"), time: \(time ?? "daily")")
                
                //                self.journal.entries.addDay(habit: habit, date: Date())
                self.journal.entries.addDay(habit: habit ?? "error", date: Date())
                
                habitTextField.text = ""
                timeTextField.text = ""
                
//                self.habitTableView.reloadData()
            } catch {
                print (error)
            }
    }

}
