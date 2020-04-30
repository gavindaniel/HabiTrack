//
//  HabitViewController.swift
//  HabiTrack
//
//  Created by Gavin Daniel on 9/12/19.
//  Copyright © 2019 Gavin Daniel. All rights reserved.
//

import UIKit
import SQLite

// name: AddDateCVCell
// desc: date selection collection view cell class
// last updated: 4/28/2020
// last update: cleaned up
class AddDateCVCell: UICollectionViewCell {
    @IBOutlet weak var dayUILabel: UILabel!
}

// name: AddHabitVC
// desc: add habit view controller class
// last updated: 4/28/2020
// last update: cleaned up
class AddHabitVC: UIViewController, UITextFieldDelegate {
    // variables
    @IBOutlet weak var addUIButton: UIButton!
    @IBOutlet weak var cancelUIButton: UIButton!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var dateTextField: UITextField!
    @IBOutlet weak var nameUnderlineLabel: UILabel!
    @IBOutlet weak var dateUnderlineLabel: UILabel!
    //    @IBOutlet weak var addHabitView: UIView!
    @IBOutlet weak var addHabitView: UIView!
    @IBOutlet weak var dateUICollectionView: UICollectionView!
    var addDateCV: AddDateCV?
    var activeTextField = UITextField()
    var lastActiveTextField: String!
    var habits = Habits()
    
    let datePicker = UIDatePicker() // new
    
    // name: viewDidAppear
    // desc:
    // last updated: 4/28/2020
    // last update: cleaned up
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        debugPrint("AddHabitVC", "viewDidAppear", "start", false)
        // update views
        addDateCV?.updateUICollectionView(dateUICollectionView)
        debugPrint("AddHabitVC", "viewDidAppear", "end", false)
    }
    
    
    // name: viewDidDisappear
    // desc:
    // last updated: 4/28/2020
    // last update: cleaned up
    override func viewDidDisappear(_ animated: Bool) {
        debugPrint("AddHabitVC", "viewDidDisappear", "start", false)
        let storyBoard = UIStoryboard(name: "Main", bundle:nil)
        let journalVC = storyBoard.instantiateViewController(withIdentifier: "journalVC") as! JournalVC
        journalVC.journalUITableView?.reloadData()
        debugPrint("AddHabitVC", "viewDidDisappear", "end", false)
    }
    
    
    // name: viewDidLoad
    // desc:
    // last updated: 4/28/2020
    // last update: cleaned up
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        debugPrint("AddHabitVC", "viewDidLoad", "start", false)
        self.addDateCV = AddDateCV(dateUICollectionView)
        self.nameTextField.delegate = self
        nameTextField.returnKeyType = UIReturnKeyType.done
        do {
            let documentDirectory = try FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
            let fileUrl = documentDirectory.appendingPathComponent("habits").appendingPathExtension("sqlite3")
            let database = try Connection(fileUrl.path)
            self.habits.database = database
            self.habits.entries.database = database
            // set the dataSource and delegate
            self.dateUICollectionView.dataSource = addDateCV
            self.dateUICollectionView.delegate = addDateCV
        } catch {
            print(error)
        }
        
//        showDatePicker() // new
        
        datePicker.datePickerMode = .date
        dateTextField.inputView = datePicker
        datePicker.addTarget(self, action: #selector(handleDatePicker(sender:)), for: .valueChanged)
        
        debugPrint("AddHabitVC", "viewDidLoad", "end", false)
    }
    
    
    // name: viewWillAppear
    // desc:
    // last updated: 4/28/2020
    // last update: cleaned up
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        debugPrint("AddHabitVC", "viewWillAppear", "start", false)
        let defaultColor = getColor("System")
        addUIButton?.tintColor = defaultColor
        cancelUIButton?.tintColor = defaultColor
        // reload the views
        self.dateUICollectionView.reloadData()
        debugPrint("AddHabitVC", "viewWillAppear", "end", false)
    }
    
    
    // name: traitCollectionDidChange
    // desc:
    // last updated: 4/28/2020
    // last update: cleaned up
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        debugPrint("AddHabitVC", "traitCollectionDidChange", "start", false)
        // check if change from light/dark mode
        if #available(iOS 13, *), traitCollection.hasDifferentColorAppearance(comparedTo: previousTraitCollection) {
            // handle theme change here.
            self.dateUICollectionView.reloadData()
        }
        debugPrint("AddHabitVC", "traitCollectionDidChange", "end", false)
    }
    
    
    // name: textFieldShouldReturn
    // desc:
    // last updated: 4/28/2020
    // last update: cleaned up
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        debugPrint("AddHabitVC", "textFieldShouldReturn", "start", false)
        self.view.endEditing(true)
        debugPrint("AddHabitVC", "textFieldShouldReturn", "end", false)
        return false
    }
    
    
    // name: dismissKeyboard
    // desc: Calls this function when the tap is recognized.
    // last updated: 4/28/2020
    // last update: cleaned up
    @objc func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        debugPrint("AddHabitVC", "dismissKeyboard", "start", false)
        addHabitView.endEditing(true)
        debugPrint("AddHabitVC", "dismissKeyboard", "end", false)
    }
    
    
    // name: textFieldDidBeginEditing
    // desc: Assign the newly active text field to your activeTextField variable
    // last updated: 4/28/2020
    // last update: cleaned up
    func textFieldDidBeginEditing(_ textField: UITextField) {
        debugPrint("AddHabitVC", "textFieldDidBeginEditing", "start", false)
        self.activeTextField = textField
        let id = textField.restorationIdentifier
        if (id == "titleTextField") {
            let defaultColor = getColor("System")
            nameUnderlineLabel.textColor = defaultColor
        }
        debugPrint("AddHabitVC", "textFieldDidBeginEditing", "end", false)
    }
    
    
    // name: textFieldDidEndEditing
    // desc: Assign the newly active text field to your activeTextField variable
    // last updated: 4/28/2020
    // last update: cleaned up
    func textFieldDidEndEditing(_ textField: UITextField) {
        debugPrint("AddHabitVC", "textFieldDidEndEditing", "start", false)
        if (textField.restorationIdentifier == "nameTextField") {
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
        debugPrint("AddHabitVC", "textFieldDidEndEditing", "end", false)
    }
    
    
    // name: cancelAddHabit
    // desc:
    // last updated: 4/28/2020
    // last update: cleaned up
    @IBAction func cancelAddHabit(_ sender: AnyObject) {
        debugPrint("AddHabitVC", "cancelAddHabit", "start", false)
        dismiss(animated: true, completion: nil)
        debugPrint("AddHabitVC", "cancelAddHabit", "end", false)
    }
    
    
    // name: addHabit
    // desc:
    // last updated: 4/28/2020
    // last update: cleaned up
    @IBAction func addHabit(_ sender: AnyObject) {
        debugPrint("AddHabitVC", "addHabit", "start", false)
        // create table if there isn't one
        habits.createTable()
        // insert new habit into journal
        let nameString = nameTextField.text
        let dateString = dateTextField.text
        let selectedDays = self.addDateCV?.getDaysSelected()
        if (nameString == "" || dateString == "" || selectedDays!.count == 0) {
            if (nameString == "") {
                print("\tName blank, displaying required...")
                nameUnderlineLabel.textColor = UIColor.red
            }
            if (dateString == "") {
                print("\tDate blank, displaying required...")
                dateUnderlineLabel.textColor = UIColor.red
            }
            if (selectedDays!.count == 0) {
                print("\tNo days selected, displaying required...")
            }
        } else {
            let date = getDateFromString(dateString ?? "")
            print("\tdate: \(date)")
            let calendar = Calendar.current
            let year = calendar.component(.year, from: date)
            let month = calendar.component(.month, from: date)
            let day = calendar.component(.day, from: date)
            var i = 0, daysString = ""
            print("\t# selectedDays : \(selectedDays!.count)")
            while (i < selectedDays!.count) {
                daysString += "\(selectedDays![i].row+1)"
                i += 1
            }
            print("\tdaysString: \(daysString)")
//            if (selectedDays!.count >= 7) {
//                repeatString = "daily"
//            } else {
//                repeatString = "weekly"
//            }
            let addHabit = self.habits.habitsTable.insert(self.habits.name <- nameString ?? "error",
            self.habits.days <- Int(daysString) ?? 1,
            self.habits.streak <- 0,
            self.habits.startYear <- Int(year),
            self.habits.startMonth <- Int(month),
            self.habits.startDay <- Int(day))
            // attempt to add habit to database
            do {
                try self.habits.database.run(addHabit)
                // testing ...
                let defaults = UserDefaults.standard
                if (isKeyPresentInUserDefaults(key: "localHabits") == false) {
                    defaults.set([String](), forKey: "localHabits")
                }
                var localHabits = defaults.object(forKey: "localHabits") as! [String]
                localHabits.append(nameString!)
                defaults.set(localHabits, forKey: "localHabits")
                print("\tHabit Added -> name: \(nameString ?? "error"), startDay: \(day)")
                self.habits.entries.addDay(habit: nameString ?? "error", date: date)
                nameTextField.text = ""
                // return to journal view controller
                dismiss(animated: true, completion: nil)
            } catch {
                print (error)
            } // end catch
        } // end if
        debugPrint("AddHabitVC", "addHabit", "end", false)
    } // end func
    
    
    // name: handleDatePicker
    // desc:
    // last updated: 4/29/2020
    // last update: added
    @objc func handleDatePicker(sender: UIDatePicker) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy"
        dateTextField.text = dateFormatter.string(from: sender.date)
    }


    // name: touchesBegan
    // desc:
    // last updated: 4/29/2020
    // last update: added
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
} // end class
