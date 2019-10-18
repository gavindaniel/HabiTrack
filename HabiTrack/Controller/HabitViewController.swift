//
//  HabitViewController.swift
//  HabiTrack
//
//  Created by Gavin Daniel on 9/12/19.
//  Copyright © 2019 Gavin Daniel. All rights reserved.
//

import UIKit
import SQLite

// class: HabitTableViewCell
class HabitTableViewCell: UITableViewCell {
    @IBOutlet weak var dayUILabel: UILabel!
}

class HabitViewController: UIViewController, UITextFieldDelegate {
    
//    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var nameTextField: UITextField!
//    @IBOutlet weak var nameUnderlineLabel: UILabel!
    @IBOutlet weak var nameUnderlineLabel: UILabel!
//    @IBOutlet weak var nameRequiredLabel: UILabel!
    @IBOutlet weak var nameRequiredLabel: UILabel!
    
//    @IBOutlet weak var repeatTextField: UITextField!
//    @IBOutlet weak var repeatUnderlineLabel: UILabel!
//    @IBOutlet weak var repeatRequiredLabel: UILabel!
    
    
//    @IBOutlet var addHabitView: UIView!
    @IBOutlet weak var addHabitView: UIView!
    
    var habitTableView: HabitTableView?
    @IBOutlet weak var habitUITableView: UITableView!
    //    @IBOutlet weak var habitUITableView: UITableView!
    
    var activeTextField = UITextField()
    var lastActiveTextField: String!
    
    var journal = Journal()
    
    // customViews
//    var journalTableView: JournalTableView?
//    @IBOutlet weak var habitTableView: UITableView!
    
    // load : viewDidAppear
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        print()
        print("viewDidAppear...")
        print()
        // update views
        habitTableView?.updateTableView(habitDayView: habitUITableView)
        
        // set observer of application entering foreground
//        NotificationCenter.default.addObserver(self,
//                                               selector: #selector(applicationWillEnterForeground),
//                                               name: UIApplication.willEnterForegroundNotification,
//                                               object: nil)
    }
    
    // load : viewDidDisappear
    override func viewDidDisappear(_ animated: Bool) {
        print()
        print("viewDidDisappear...")
        print()
        // testing
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let journalViewController = storyBoard.instantiateViewController(withIdentifier: "journalViewController") as! JournalViewController
//        self.navigationController?.pushViewController(nextViewController, animated: true)
        journalViewController.journalUITableView?.reloadData()
    }
    
    // load : viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        print()
        print("viewDidLoad...")
        print()
        
        // testing
        self.habitTableView = HabitTableView(habitTableView: habitUITableView)
        
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
            
            // set the dataSource and delegate
            self.habitUITableView.dataSource = habitTableView
            self.habitUITableView.delegate = habitTableView
            
        } catch {
            print(error)
        }
    }
    
    // load : viewWillAppear
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        print()
        print("viewWillAppear...")
        print()
        // reload the views
        self.habitUITableView.reloadData()
    }
    
    //Calls this function when the tap is recognized.
    @objc func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        print()
        print("dismissKeyboard...")
        print()
        addHabitView.endEditing(true)
    }
    
    // Assign the newly active text field to your activeTextField variable
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
        self.activeTextField = textField
        let id = textField.restorationIdentifier
        
        if (id == "titleTextField") {
            nameUnderlineLabel.textColor = UIColor.systemBlue
        }
//        else if (id == "timeTextField") {
//            repeatUnderlineLabel.textColor = UIColor.systemBlue
//        }
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
//        if (textField.restorationIdentifier == "timeTextField") {
//            if (textField.text != "") {
//                if #available(iOS 13.0, *) {
//                    repeatUnderlineLabel.textColor = UIColor.systemBlue
//                } else {
//                    // Fallback on earlier versions
//                    repeatUnderlineLabel.textColor = UIColor.systemBlue
//                }
//            } else {
//                if #available(iOS 13.0, *) {
//                    repeatUnderlineLabel.textColor = UIColor.systemGray
//                } else {
//                    // Fallback on earlier versions
//                    repeatUnderlineLabel.textColor = UIColor.systemGray
//                }
//            }
//        }
    }
    
    @IBAction func cancelAddHabit(_ sender: AnyObject) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func addHabit(_ sender: AnyObject) {

        // create table if there isn't one
        journal.createTable()
        // create alert controller
        
        // insert new habit into journal
        let habit = nameTextField.text
        // testing
        let selectedDays = habitTableView?.selectedList
//        let time = repeatTextField.text
        var i = 0, count = 0, repeatInt = ""
        var repeatString = "weekly"
        while (i < selectedDays!.count) {
            if (selectedDays![i] == 1) {
//                if (i != 6 && repeatString != "") {
//                    repeatString += ", "
//                }
//                repeatString += "\(getDayOfWeekString(dayOfWeek: i+1, length: "long"))s"
                    repeatInt += "\(i+1)"
                count += 1
            }
            i += 1
        }
        print("repeatInt: \(repeatInt)")
        if (count >= 7) {
            repeatString = "daily"
        }
        // testing
//                if (habit == "" || time == "") {
        if (habit == "" || count == 0) {
            if (habit == "") {
                print("Name blank, displaying required...")
                nameUnderlineLabel.textColor = UIColor.red
                nameRequiredLabel.isHidden = false
            }
            if (count == 0) {
                print("No days selected, displaying required...")
//                repeatUnderlineLabel.textColor = UIColor.red
//                repeatRequiredLabel.isHidden = false
            }
        } else {
            nameRequiredLabel.isHidden = true
//                    repeatRequiredLabel.isHidden = true
//                    let addHabit = self.journal.habitsTable.insert(self.journal.habit <- habit ?? "error",
//                                                                   self.journal.time <- time ?? "error",
//                                                                   self.journal.streak <- 0,
//                                                                   self.journal.dayOfWeek <- 0)
            let addHabit = self.journal.habitsTable.insert(self.journal.habit <- habit ?? "error",
            self.journal.time <- repeatString,
            self.journal.streak <- 0,
            self.journal.dayOfWeek <- Int(repeatInt) ?? 1)

//            if (count < 7) {
//                addHabit = self.journal.habitsTable.insert(self.journal.habit <- habit ?? "error",
//                self.journal.time <- repeatString,
//                self.journal.streak <- 0,
//                self.journal.dayOfWeek <- 0)
//            }
            // attempt to add habit to database
            do {
                try self.journal.database.run(addHabit)
                print("Habit Added -> habit: \(habit ?? "error"), time: \("daily")")
                self.journal.entries.addDay(habit: habit ?? "error", date: Date())
                nameTextField.text = ""
//                        repeatTextField.text = ""
                
                // return to journal view controller
                dismiss(animated: true, completion: nil)
                
            } catch {
                print (error)
            }
        }
    }
}
