//
//  SettingsViewController.swift
//  HabiTrack
//
//  Created by Gavin Daniel on 9/1/19.
//  Copyright © 2019 Gavin Daniel. All rights reserved.
//

import UIKit
import CoreData


// name: SettingsTVCell
// desc: settings table view cell class
// last updated: 4/28/2020
// last update: cleaned up
class SettingsTVCell: UITableViewCell {
    @IBOutlet weak var settingUILabel: UILabel!
    @IBOutlet weak var settingUISwitch: UISwitch!
}


// name: SettingsVC
// desc: settings view controller class
// last updated: 4/28/2020
// last update: cleaned up
class SettingsVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
    // variables
    var settingList = ["Manage Habits", "Customize Display"]
    var database: Connection!
    let habits = Habits()
    // IBOutlet connections
    @IBOutlet weak var settingsTableView: UITableView!

    
    // name: viewDidLoad
    // desc:
    // last updated: 4/28/2020
    // last update: cleaned up
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        debugPrint("SettingsVC", "viewDidLoad", "start", true)
        do {
            let documentDirectory = try FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
            let fileUrl = documentDirectory.appendingPathComponent("habits").appendingPathExtension("sqlite3")
            let database = try Connection(fileUrl.path)
            self.database = database
        } catch {
            print(error)
        }
        debugPrint("SettingsVC", "viewDidLoad", "end", true)
    }
    
    
    // name: numberOfRowsInSection
    // desc:
    // last updated: 4/28/2020
    // last update: cleaned up
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        debugPrint("SettingsVC", "numberOfRowsInSection", "start", true)
        debugPrint("SettingsVC", "numberOfRowsInSection", "end", true)
        return (settingList.count)
    }
    
    
    // name: cellForRowAt
    // desc:
    // last updated: 4/28/2020
    // last update: cleaned up
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        debugPrint("SettingsVC", "cellForRowAt", "start", true, indexPath.row)
        let cell = tableView.dequeueReusableCell(withIdentifier: "settingCell", for: indexPath)
        as! SettingsTVCell
        cell.settingUILabel.text = settingList[indexPath.row]
        debugPrint("SettingsVC", "cellForRowAt", "end", true, indexPath.row)
        return (cell)
    }
    
    
    // name: didSelectRowAt
    // desc:
    // last updated: 4/28/2020
    // last update: cleaned up
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        debugPrint("SettingsVC", "didSelectRowAt", "start", false, indexPath.row)
        if (settingList[indexPath.row] == "Manage Habits") {
            debugPrint("\tdidSelectRowAt", "Manage Habits", "start", false)
            let storyBoard = UIStoryboard(name: "Main", bundle:nil)
            let manageJournalVC = storyBoard.instantiateViewController(withIdentifier: "manageJournalVC") as! ManageJournalVC
            manageJournalVC.habits = habits
            debugPrint("\tdidSelectRowAt", "Manage Habits", "end", false)
            self.present(manageJournalVC, animated: true, completion: nil)
        }
        else if (settingList[indexPath.row] == "Customize Display") {
            debugPrint("\tdidSelectRowAt", "Customize Display", "start", false)
            let storyBoard = UIStoryboard(name: "Main", bundle:nil)
            let manageDisplayVC = storyBoard.instantiateViewController(withIdentifier: "customizeVC") as! CustomizeVC
            debugPrint("\tdidSelectRowAt", "Customize Display", "end", false)
            self.present(manageDisplayVC, animated: true, completion: nil)
        }
        tableView.deselectRow(at: indexPath, animated: true)
        debugPrint("SettingsVC", "didSelectRowAt", "end", false, indexPath.row)
    } // end func
} // end class


