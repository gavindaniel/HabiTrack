//
//  HabitViewController.swift
//  HabiTrack
//
//  Created by Gavin Daniel on 9/12/19.
//  Copyright © 2019 Gavin Daniel. All rights reserved.
//

import UIKit
import CoreData

// name: AddDateCVCell
// desc: date selection collection view cell class
// last updated: 4/28/2020
// last update: cleaned up
class HabitDateCVCell: UICollectionViewCell {
    @IBOutlet weak var dayUILabel: UILabel!
}

// name: HabitVC
// desc: add habit view controller class
// last updated: 4/28/2020
// last update: cleaned up
class HabitVC: UIViewController, UITextFieldDelegate {
    // variables
    @IBOutlet weak var addUIButton: UIButton!
    @IBOutlet weak var cancelUIButton: UIButton!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var dateTextField: UITextField!
    @IBOutlet weak var nameUnderlineLabel: UILabel!
    @IBOutlet weak var dateUnderlineLabel: UILabel!
    @IBOutlet weak var addHabitView: UIView!
    @IBOutlet weak var dateUICollectionView: UICollectionView!
    var habitDateCV: HabitDateCV?
    var activeTextField = UITextField()
    var lastActiveTextField: String!
    var habits = Habits()
    
    let datePicker = UIDatePicker() // new
    
    
    // name: viewDidLoad
    // desc:
    // last updated: 5/4/2020
    // last update: cleaned up
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        debugPrint("HabitVC", "viewDidLoad", "start", false)
        self.habitDateCV = HabitDateCV(dateUICollectionView)
        self.nameTextField.delegate = self
        nameTextField.returnKeyType = UIReturnKeyType.done
        do {
            let documentDirectory = try FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
            let fileUrl = documentDirectory.appendingPathComponent("habits").appendingPathExtension("sqlite3")
            let database = try Connection(fileUrl.path)
            self.habits.database = database
            self.habits.entries.database = database
            // set the dataSource and delegate
            self.dateUICollectionView.dataSource = habitDateCV
            self.dateUICollectionView.delegate = habitDateCV
        } catch {
            print(error)
        }
        datePicker.datePickerMode = .date
        dateTextField.inputView = datePicker
        datePicker.addTarget(self, action: #selector(handleDatePicker(sender:)), for: .valueChanged)
        debugPrint("HabitVC", "viewDidLoad", "end", false)
    }
    
    
    // name: viewWillAppear
    // desc:
    // last updated: 4/28/2020
    // last update: cleaned up
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        debugPrint("HabitVC", "viewWillAppear", "start", false)
        let defaultColor = getColor("System")
        addUIButton?.tintColor = defaultColor
        cancelUIButton?.tintColor = defaultColor
        // reload the views
        self.dateUICollectionView.reloadData()
        debugPrint("HabitVC", "viewWillAppear", "end", false)
    }
    
    
    // name: viewDidAppear
    // desc:
    // last updated: 5/16/2020
    // last update: cleaned up
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        debugPrint("HabitVC", "viewDidAppear", "start", false)
        // update views
        habitDateCV?.dateUICollectionView.reloadData()
        debugPrint("HabitVC", "viewDidAppear", "end", false)
        print("******************************************************")
    }
    
    
    // name: viewDidDisappear
    // desc:
    // last updated: 5/16/2020
    // last update: cleaned up
    override func viewDidDisappear(_ animated: Bool) {
        debugPrint("HabitVC", "viewDidDisappear", "start", false)
        debugPrint("HabitVC", "viewDidDisappear", "end", false)
        print("******************************************************")
    }
    
    
    // name: traitCollectionDidChange
    // desc:
    // last updated: 4/28/2020
    // last update: cleaned up
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        debugPrint("HabitVC", "traitCollectionDidChange", "start", true)
        // check if change from light/dark mode
        if #available(iOS 13, *), traitCollection.hasDifferentColorAppearance(comparedTo: previousTraitCollection) {
            // handle theme change here.
            self.dateUICollectionView.reloadData()
        }
        debugPrint("HabitVC", "traitCollectionDidChange", "end", true)
    }
    
    
    // name: textFieldShouldReturn
    // desc:
    // last updated: 4/28/2020
    // last update: cleaned up
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        debugPrint("HabitVC", "textFieldShouldReturn", "start", true)
        self.view.endEditing(true)
        debugPrint("HabitVC", "textFieldShouldReturn", "end", true)
        return false
    }
    
    
    // name: dismissKeyboard
    // desc: Calls this function when the tap is recognized.
    // last updated: 4/28/2020
    // last update: cleaned up
    @objc func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        debugPrint("HabitVC", "dismissKeyboard", "start", true)
        addHabitView.endEditing(true)
        debugPrint("HabitVC", "dismissKeyboard", "end", true)
    }
    
    
    // name: textFieldDidBeginEditing
    // desc: Assign the newly active text field to your activeTextField variable
    // last updated: 4/28/2020
    // last update: cleaned up
    func textFieldDidBeginEditing(_ textField: UITextField) {
        debugPrint("HabitVC", "textFieldDidBeginEditing", "start", true)
        self.activeTextField = textField
        let id = textField.restorationIdentifier
        if (id == "titleTextField") {
            let defaultColor = getColor("System")
            nameUnderlineLabel.textColor = defaultColor
        }
        debugPrint("HabitVC", "textFieldDidBeginEditing", "end", true)
    }
    
    
    // name: textFieldDidEndEditing
    // desc: Assign the newly active text field to your activeTextField variable
    // last updated: 4/28/2020
    // last update: cleaned up
    func textFieldDidEndEditing(_ textField: UITextField) {
        debugPrint("HabitVC", "textFieldDidEndEditing", "start", true)
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
        debugPrint("HabitVC", "textFieldDidEndEditing", "end", true)
    }
    
    
    // name: cancelAddHabit
    // desc:
    // last updated: 4/28/2020
    // last update: cleaned up
    @IBAction func cancelAddHabit(_ sender: AnyObject) {
        debugPrint("HabitVC", "cancelAddHabit", "start", false)
        dismiss(animated: true, completion: nil)
        debugPrint("HabitVC", "cancelAddHabit", "end", false)
    }
    
    
    // name: addHabit
    // desc:
    // last updated: 4/28/2020
    // last update: cleaned up
    @IBAction func addHabit(_ sender: AnyObject) {
        debugPrint("HabitVC", "addHabit", "start", false)
        // create table if there isn't one
        habits.createTable()
        // insert new habit into journal
        let nameString = nameTextField.text
        let dateString = dateTextField.text
        let selectedDays = self.habitDateCV?.getDaysSelected()
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

                let storyBoard = UIStoryboard(name: "Main", bundle:nil)
                let journalVC = storyBoard.instantiateViewController(withIdentifier: "journalVC") as! JournalVC
                journalVC.journalUITableView?.reloadData()
                debugPrint("\tdidSelectRowAt", "Manage Habits", "end", false)
//                self.present(journalVC, animated: true, completion: nil)
//                self.navigationController?.pushViewController(journalVC, animated: true)
                DataManager.shared.journalVC.journalUITableView.reloadData()
                DataManager.shared.journalVC.dateUICollectionView.reloadData()
                dismiss(animated: true, completion: nil)
            } catch {
                print (error)
            } // end catch
        } // end if
        debugPrint("HabitVC", "addHabit", "end", false)
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
