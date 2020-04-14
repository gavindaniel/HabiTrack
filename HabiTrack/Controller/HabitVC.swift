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

class HabitVC: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var nameUnderlineLabel: UILabel!
    @IBOutlet weak var habitUILabel: UILabel!
    
    @IBOutlet weak var addUIButton: UIButton!
    @IBOutlet weak var cancelUIButton: UIButton!
    
    @IBOutlet weak var addHabitView: UIView!
    
    var habitTableView: HabitTableView?
    @IBOutlet weak var habitUITableView: UITableView!
    
    var activeTextField = UITextField()
    var lastActiveTextField: String!
    
    var journal = Journal()
    
    // load : viewDidAppear
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        print()
        print("HabitVC : viewDidAppear...")
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
        print("HabitVC : viewDidDisappear...")
        print()
        // testing
        let storyBoard = UIStoryboard(name: "Main", bundle:nil)
        let journalVC = storyBoard.instantiateViewController(withIdentifier: "journalVC") as! JournalVC
//        self.navigationController?.pushViewController(nextViewController, animated: true)
        journalVC.journalUITableView?.reloadData()
    }
    
    // load : viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        print()
        print("HabitVC : viewDidLoad...")
        print()
        
        // testing
        self.habitTableView = HabitTableView(habitTableView: habitUITableView)
        
        //Looks for single or multiple taps.
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIInputViewController.dismissKeyboard))
        
        
        //Uncomment the line below if you want the tap not not interfere and cancel other interactions.
        //tap.cancelsTouchesInView = false
        
        addHabitView.addGestureRecognizer(tap)
        
        // testing
//        habitUITableView.addGestureRecognizer(tap)
        
        self.nameTextField.delegate = self
        nameTextField.returnKeyType = UIReturnKeyType.done
        
        
        
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
        print("HabitVC : viewWillAppear...")
        print()
        // testing
        let defaultColor = getSystemColor()
        addUIButton?.tintColor = defaultColor
        cancelUIButton?.tintColor = defaultColor
        // reload the views
        self.habitUITableView.reloadData()
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        print()
        print("HabitVC : traitCollectionDidChange")
        print()
        // check if change from light/dark mode
        if #available(iOS 13, *), traitCollection.hasDifferentColorAppearance(comparedTo: previousTraitCollection) {
            // handle theme change here.
            self.habitUITableView.reloadData()
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
    
    //Calls this function when the tap is recognized.
    @objc func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        print()
        print("HabitVC : dismissKeyboard...")
        print()
        addHabitView.endEditing(true)
        
//        testing
        habitUITableView.endEditing(true)
    }
    
    // Assign the newly active text field to your activeTextField variable
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
        self.activeTextField = textField
        let id = textField.restorationIdentifier
        
        if (id == "titleTextField") {
            let defaultColor = getSystemColor()
            nameUnderlineLabel.textColor = defaultColor
            habitUILabel.textColor = defaultColor
        }
    }
    
    // Assign the newly active text field to your activeTextField variable
    func textFieldDidEndEditing(_ textField: UITextField) {
    
        if (textField.restorationIdentifier == "titleTextField") {
            if (textField.text != "") {
                if #available(iOS 13.0, *) {
                    nameUnderlineLabel.textColor = UIColor.label
                    habitUILabel.textColor = UIColor.label
                } else {
                    // Fallback on earlier versions
                    nameUnderlineLabel.textColor = UIColor.black
                    habitUILabel.textColor = UIColor.black
                }
            } else {
                if #available(iOS 13.0, *) {
                    nameUnderlineLabel.textColor = UIColor.systemGray
                    habitUILabel.textColor = UIColor.systemGray
                } else {
                    // Fallback on earlier versions
                    nameUnderlineLabel.textColor = UIColor.systemGray
                    habitUILabel.textColor = UIColor.systemGray
                }
            }
        }
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
        var i = 0, count = 0, repeatInt = ""
        var repeatString = "weekly"
        while (i < selectedDays!.count) {
            if (selectedDays![i] == 1) {
                    repeatInt += "\(i+1)"
                count += 1
            }
            i += 1
        }
        print("repeatInt: \(repeatInt)")
        if (count >= 7) {
            repeatString = "daily"
        }
        if (habit == "" || count == 0) {
            if (habit == "") {
                print("Name blank, displaying required...")
                habitUILabel.textColor = UIColor.red
                nameUnderlineLabel.textColor = UIColor.red
            }
            if (count == 0) {
                print("No days selected, displaying required...")
            }
        } else {
            let addHabit = self.journal.habitsTable.insert(self.journal.habit <- habit ?? "error",
            self.journal.time <- repeatString,
            self.journal.streak <- 0,
            self.journal.dayOfWeek <- Int(repeatInt) ?? 1)

            // attempt to add habit to database
            do {
                try self.journal.database.run(addHabit)
                // testing ...
                let defaults = UserDefaults.standard
                // FIXME: errror caused by LOCAL copy of database not existing, need to check if database exists and if not, create it
                if (isKeyPresentInUserDefaults(key: "localHabits") == false) {
                    defaults.set([String](), forKey: "localHabits")
                }
                // end FIXME
                var localHabits = defaults.object(forKey: "localHabits") as! [String]
                localHabits.append(habit!)
                defaults.set(localHabits, forKey: "localHabits")
                
                print("Habit Added -> habit: \(habit ?? "error"), time: \("daily")")
                self.journal.entries.addDay(habit: habit ?? "error", date: Date())
                nameTextField.text = ""
                
                // testing ...
                
                // end testing
                
                // return to journal view controller
                dismiss(animated: true, completion: nil)
                
                
                
                
            } catch {
                print (error)
            }
        }
    }
}
