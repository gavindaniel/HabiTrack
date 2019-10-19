//
//  SettingsViewController.swift
//  HabiTrack
//
//  Created by Gavin Daniel on 9/1/19.
//  Copyright © 2019 Gavin Daniel. All rights reserved.
//

import UIKit
import SQLite

class SettingsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var list = ["Manage Habits", "Dark Mode"]
    
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
        return (list.count)
    }
    
    // tableView : cellForRowAt -> cell
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: UITableViewCell.CellStyle.default, reuseIdentifier: "settingCell")
        cell.textLabel?.text = list[indexPath.row]
        
        return (cell)
    }
    
    // tableView : didSelectRowAt
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("Selected row: \(indexPath.row)")
        if (list[indexPath.row] == "Manage Habits") {
            // do something..
            print("\tManage Habits...")
            
            let storyBoard = UIStoryboard(name: "Main", bundle:nil)
            
//            let manageJournalVC = storyboard.instantiateViewController(withIdentifier: "manageJournalVC") as! ManageJournalVC
//            manageJournalVC.journal = journal
//            navigationController?.pushViewController(manageJournalVC, animated: true)
            
            let manageJournalVC = storyBoard.instantiateViewController(withIdentifier: "manageJournalVC") as! ManageJournalVC
//            let manageJournalVC = ManageJournalVC()
            manageJournalVC.journal = journal
            self.present(manageJournalVC, animated: true, completion: nil)
        }
        else if (list[indexPath.row] == "Dark Mode") {
            // do something..
        }
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    
}


