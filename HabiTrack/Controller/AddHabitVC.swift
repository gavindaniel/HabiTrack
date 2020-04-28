//
//  HabitViewController.swift
//  HabiTrack
//
//  Created by Gavin Daniel on 9/12/19.
//  Copyright © 2019 Gavin Daniel. All rights reserved.
//

import UIKit
import SQLite

// class: DateCollectionViewCell
class AddDateCVCell: UICollectionViewCell {
    @IBOutlet weak var dayUILabel: UILabel!
}

class AddHabitVC: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var nameUnderlineLabel: UILabel!
//    @IBOutlet weak var habitUILabel: UILabel!
    
    @IBOutlet weak var addUIButton: UIButton!
    @IBOutlet weak var cancelUIButton: UIButton!
    
    @IBOutlet weak var addHabitView: UIView!
    
    var addDateCV: AddDateCV?
    
    @IBOutlet weak var dateUICV: UICollectionView!
    
    
    
    var activeTextField = UITextField()
    var lastActiveTextField: String!
    
    var journal = Journal()
    
    // load : viewDidAppear
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        print()
        print("AddHabitVC : viewDidAppear...start")
        // update views
        addDateCV?.updateView(dateUICV: dateUICV)
        print("AddHabitVC : viewDidAppear...end")
    }
    
    // load : viewDidDisappear
    override func viewDidDisappear(_ animated: Bool) {
        print()
        print("AddHabitVC : viewDidDisappear...start")
        let storyBoard = UIStoryboard(name: "Main", bundle:nil)
        let journalVC = storyBoard.instantiateViewController(withIdentifier: "journalVC") as! JournalVC
        journalVC.journalUITableView?.reloadData()
        print("AddHabitVC : viewDidDisappear...stop")
    }
    
    // load : viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        print()
        print("AddHabitVC : viewDidLoad...start")
        self.addDateCV = AddDateCV(dateUICV: dateUICV)
        
        // Looks for single or multiple taps.
//        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIInputViewController.dismissKeyboard))
        // Uncomment the line below if you want the tap not not interfere and cancel other interactions.
//        tap.cancelsTouchesInView = false
//        addHabitView.addGestureRecognizer(tap)
        // testing... works but causes the selection to not be recognized
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
            self.dateUICV.dataSource = addDateCV
            self.dateUICV.delegate = addDateCV
        } catch {
            print(error)
        }
    }
    
    // load : viewWillAppear
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        print()
        print("AddHabitVC : viewWillAppear...start")
        // testing
        let defaultColor = getSystemColor()
        addUIButton?.tintColor = defaultColor
        cancelUIButton?.tintColor = defaultColor
        // reload the views
        self.dateUICV.reloadData()
        print("AddHabitVC : viewWillAppear...stop")
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        print()
        print("AddHabitVC : traitCollectionDidChange...start")
        // check if change from light/dark mode
        if #available(iOS 13, *), traitCollection.hasDifferentColorAppearance(comparedTo: previousTraitCollection) {
            // handle theme change here.
            self.dateUICV.reloadData()
        }
        print("AddHabitVC : traitCollectionDidChange...stop")
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        print()
        print("AddHabitVC : textFieldShouldReturn...start")
        self.view.endEditing(true)
        print("AddHabitVC : textFieldShouldReturn...stop")
        return false
    }
    
    //Calls this function when the tap is recognized.
    @objc func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        print()
        print("AddHabitVC : dismissKeyboard...start")
        addHabitView.endEditing(true)
        print("AddHabitVC : dismissKeyboard...stop")
    }
    
    // Assign the newly active text field to your activeTextField variable
    func textFieldDidBeginEditing(_ textField: UITextField) {
        print()
        print("AddHabitVC : textFieldDidBeginEditing...start")
        self.activeTextField = textField
        let id = textField.restorationIdentifier
        if (id == "titleTextField") {
            let defaultColor = getSystemColor()
            nameUnderlineLabel.textColor = defaultColor
        }
        print("AddHabitVC : textFieldDidBeginEditing...stop")
    }
    
    // Assign the newly active text field to your activeTextField variable
    func textFieldDidEndEditing(_ textField: UITextField) {
        print()
        print("AddHabitVC : textFieldDidEndEditing...start")
        if (textField.restorationIdentifier == "titleTextField") {
            if (textField.text != "") {
                if #available(iOS 13.0, *) {
                    nameUnderlineLabel.textColor = UIColor.label
                } else {
                    // Fallback on earlier versions
                    nameUnderlineLabel.textColor = UIColor.black
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
        print("AddHabitVC : textFieldDidEndEditing...stop")
    }
    
    @IBAction func cancelAddHabit(_ sender: AnyObject) {
        print()
        print("AddHabitVC : cancelAddHabit...start")
        dismiss(animated: true, completion: nil)
        print("AddHabitVC : cancelAddHabit...stop")
    }
    
    @IBAction func addHabit(_ sender: AnyObject) {
        print()
        print("AddHabitVC : addHabit...start")
        // create table if there isn't one
        journal.createTable()
        // create alert controller
        // insert new habit into journal
        let habit = nameTextField.text
        // testing
//        let selectedDays = self.dateUICollectionView?.indexPathsForSelectedItems
        let selectedDays = self.addDateCV?.getDaysSelected()
        if (habit == "" || selectedDays!.count == 0) {
            if (habit == "") {
                print("Name blank, displaying required...")
    //                habitUILabel.textColor = UIColor.red
                nameUnderlineLabel.textColor = UIColor.red
            }
            if (selectedDays!.count == 0) {
                print("No days selected, displaying required...")
            }
        } else {
            var i = 0, repeatInt = "", repeatString = ""
            print("# selectedDays : \(selectedDays!.count)")
            while (i < selectedDays!.count) {
                repeatInt += "\(selectedDays![i].row+1)"
                i += 1
            }
            print("repeatInt: \(repeatInt)")
            if (selectedDays!.count >= 7) {
                repeatString = "daily"
            } else {
                repeatString = "weekly"
            }
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
                // return to journal view controller
                dismiss(animated: true, completion: nil)
            } catch {
                print (error)
            } // end catch
        } // end if
        print("AddHabitVC : addHabit...stop")
    } // end func
} // end class
