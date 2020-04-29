//
//  SettingsViewController.swift
//  HabiTrack
//
//  Created by Gavin Daniel on 9/1/19.
//  Copyright © 2019 Gavin Daniel. All rights reserved.
//

import UIKit
import SQLite

class SettingsTVCell: UITableViewCell {
    @IBOutlet weak var settingUILabel: UILabel!
    @IBOutlet weak var settingUISwitch: UISwitch!
}

class SettingsVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
    // variables
    var settingList = ["Manage Habits", "Customize Display"]
    var database: Connection!
    let journal = Journal()
    // IBOutlet connections
    @IBOutlet weak var settingsTableView: UITableView!

    
    // name: viewDidLoad
    // desc:
    // last updated: 4/28/2020
    // last update: cleaned up
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        debugPrint("SettingsVC", "viewDidAppear", "start", false)
        do {
            let documentDirectory = try FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
            let fileUrl = documentDirectory.appendingPathComponent("habits").appendingPathExtension("sqlite3")
            let database = try Connection(fileUrl.path)
            self.database = database
        } catch {
            print(error)
        }
        debugPrint("SettingsVC", "viewDidAppear", "end", false)
    }
    
    
    // name: viewDidAppear
    // desc:
    // last updated: 4/28/2020
    // last update: cleaned up
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        debugPrint("SettingsVC", "viewDidAppear", "start", false)
        debugPrint("SettingsVC", "viewDidAppear", "end", false)
        return (settingList.count)
    }
    
    
    // name: viewDidAppear
    // desc:
    // last updated: 4/28/2020
    // last update: cleaned up
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        debugPrint("SettingsVC", "viewDidAppear", "start", false)
        let cell = tableView.dequeueReusableCell(withIdentifier: "settingCell", for: indexPath)
        as! SettingsTVCell
        cell.settingUILabel.text = settingList[indexPath.row]
        debugPrint("SettingsVC", "viewDidAppear", "end", false)
        return (cell)
    }
    
    
    // name: viewDidAppear
    // desc:
    // last updated: 4/28/2020
    // last update: cleaned up
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        debugPrint("SettingsVC", "viewDidAppear", "start", false)
        print("Selected row: \(indexPath.row)")
        if (settingList[indexPath.row] == "Manage Habits") {
            // do something..
            print("\tManage Habits...")
            let storyBoard = UIStoryboard(name: "Main", bundle:nil)
            let manageJournalVC = storyBoard.instantiateViewController(withIdentifier: "manageJournalVC") as! ManageJournalVC
            manageJournalVC.journal = journal
            self.present(manageJournalVC, animated: true, completion: nil)
        }
        else if (settingList[indexPath.row] == "Customize Display") {
            // do something..
            print("\tManage Habits...")
            let storyBoard = UIStoryboard(name: "Main", bundle:nil)
            let manageDisplayVC = storyBoard.instantiateViewController(withIdentifier: "manageDisplayVC") as! ManageDisplayVC
            self.present(manageDisplayVC, animated: true, completion: nil)
        }
        tableView.deselectRow(at: indexPath, animated: true)
        debugPrint("SettingsVC", "viewDidAppear", "end", false)
    } // end func
} // end class


