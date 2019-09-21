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
    
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var nameUnderlineLabel: UILabel!
    @IBOutlet weak var nameRequiredLabel: UILabel!

    @IBOutlet weak var repeatTextField: UITextField!
    @IBOutlet weak var repeatUnderlineLabel: UILabel!
    @IBOutlet weak var repeatRequiredLabel: UILabel!
    
    
    @IBOutlet var addHabitView: UIView!
    
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
        
        // testing
        //Looks for single or multiple taps.
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIInputViewController.dismissKeyboard))
        
        //Uncomment the line below if you want the tap not not interfere and cancel other interactions.
        //tap.cancelsTouchesInView = false
        
        addHabitView.addGestureRecognizer(tap)
        
        
        do {
            let documentDirectory = try FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
            let fileUrl = documentDirectory.appendingPathComponent("habits").appendingPathExtension("sqlite3")
            let database = try Connection(fileUrl.path)
            self.journal.database = database
            self.journal.entries.database = database
        } catch {
            print(error)
        }
    }
    
    //Calls this function when the tap is recognized.
    @objc func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        addHabitView.endEditing(true)
    }
    
    // Assign the newly active text field to your activeTextField variable
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
        self.activeTextField = textField
        let id = textField.restorationIdentifier
        
        if (id == "titleTextField") {
            nameUnderlineLabel.textColor = UIColor.systemBlue
        }
        else if (id == "timeTextField") {
            repeatUnderlineLabel.textColor = UIColor.systemBlue
        }
    }
    
    // Assign the newly active text field to your activeTextField variable
    func textFieldDidEndEditing(_ textField: UITextField) {
    
        if (textField.restorationIdentifier == "titleTextField") {
            if (textField.text != "") {
                if #available(iOS 13.0, *) {
                    nameUnderlineLabel.textColor = UIColor.systemBlue
                } else {
                    // Fallback on earlier versions
                    nameUnderlineLabel.textColor = UIColor.systemBlue
                }
            } else {
                if #available(iOS 13.0, *) {
                    nameUnderlineLabel.textColor = UIColor.systemGray
                } else {
                    // Fallback on earlier versions
                    nameUnderlineLabel.textColor = UIColor.systemGray
                }
            }
        }
        if (textField.restorationIdentifier == "timeTextField") {
            if (textField.text != "") {
                if #available(iOS 13.0, *) {
                    repeatUnderlineLabel.textColor = UIColor.systemBlue
                } else {
                    // Fallback on earlier versions
                    repeatUnderlineLabel.textColor = UIColor.systemBlue
                }
            } else {
                if #available(iOS 13.0, *) {
                    repeatUnderlineLabel.textColor = UIColor.systemGray
                } else {
                    // Fallback on earlier versions
                    repeatUnderlineLabel.textColor = UIColor.systemGray
                }
            }
        }
    }
    
    
    @IBAction func submitEntry(_ sender: Any) {
        
        // create table if there isn't one
        journal.createTable()
        // create alert controller
        
        // insert new habit into journal
        let habit = nameTextField.text
        let time = repeatTextField.text
        
        // testing
        if (habit == "" || time == "") {
            if (habit == "") {
                print("Name blank, displaying required...")
                nameUnderlineLabel.textColor = UIColor.red
                nameRequiredLabel.isHidden = false
            }
            if (time == "") {
                print("Time blank, displaying required...")
                repeatUnderlineLabel.textColor = UIColor.red
                repeatRequiredLabel.isHidden = false
            }
        } else {
            nameRequiredLabel.isHidden = true
            repeatRequiredLabel.isHidden = true
            let addHabit = self.journal.habitsTable.insert(self.journal.habit <- habit ?? "error",
                                                           self.journal.time <- time ?? "daily",
                                                           self.journal.streak <- 0,
                                                           self.journal.currentDay <- 1)
            // attempt to add habit to database
            do {
                try self.journal.database.run(addHabit)
                print("Habit Added -> habit: \(habit ?? "error"), time: \(time ?? "daily")")
                self.journal.entries.addDay(habit: habit ?? "error", date: Date())
                nameTextField.text = ""
                repeatTextField.text = ""
                
                // testing
                let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
                let nextViewController = storyBoard.instantiateViewController(withIdentifier: "journalViewController") as! JournalViewController
                self.navigationController?.pushViewController(nextViewController, animated: true)
                
            } catch {
                print (error)
            }
        }
    }
}
