//
//  SettingsViewController.swift
//  HabiTrack
//
//  Created by Gavin Daniel on 9/1/19.
//  Copyright © 2019 Gavin Daniel. All rights reserved.
//

import UIKit
import SQLite

class SettingTableViewCell: UITableViewCell {
    @IBOutlet weak var settingUILabel: UILabel!
    @IBOutlet weak var settingUISwitch: UISwitch!
}

class SettingsVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var settingList = ["Manage Habits", "Manage Display"]
    
    var database: Connection!
    let journal = Journal()
    
    @IBOutlet weak var settingsTableView: UITableView!

    
    // viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        do {
            let documentDirectory = try FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
            let fileUrl = documentDirectory.appendingPathComponent("habits").appendingPathExtension("sqlite3")
            let database = try Connection(fileUrl.path)
            self.database = database
        } catch {
            print(error)
        }
    }
    
    // tableView : numberOfRowsInSection
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (settingList.count)
    }
    
    // tableView : cellForRowAt -> cell
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let cell = UITableViewCell(style: UITableViewCell.CellStyle.default, reuseIdentifier: "settingCell")
        let cell = tableView.dequeueReusableCell(withIdentifier: "settingCell", for: indexPath)
        as! SettingTableViewCell
        
        cell.settingUILabel.text = settingList[indexPath.row]
        
        return (cell)
    }
    
    // tableView : didSelectRowAt
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("Selected row: \(indexPath.row)")
        if (settingList[indexPath.row] == "Manage Habits") {
            // do something..
            print("\tManage Habits...")
            
            let storyBoard = UIStoryboard(name: "Main", bundle:nil)
            let manageJournalVC = storyBoard.instantiateViewController(withIdentifier: "manageJournalVC") as! ManageJournalVC
            manageJournalVC.journal = journal
            self.present(manageJournalVC, animated: true, completion: nil)
        }
        else if (settingList[indexPath.row] == "Manage Display") {
            // do something..
            print("\tManage Habits...")
            let storyBoard = UIStoryboard(name: "Main", bundle:nil)
            let manageDisplayVC = storyBoard.instantiateViewController(withIdentifier: "manageDisplayVC") as! ManageDisplayVC
            self.present(manageDisplayVC, animated: true, completion: nil)
        }
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    
}


